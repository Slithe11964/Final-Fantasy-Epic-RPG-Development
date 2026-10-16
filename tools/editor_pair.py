"""Merge an edited shared editor master onto the native profile without copying classic UI.

The editor owns world content. Profile-specific source/object differences are three-way
merged against a pinned editor reference; conflicting edits are errors, never discarded.
"""
import copy
from pathlib import Path
import re
import subprocess
import tempfile

from editor_layout import trigger_items, normalize
from jtok import functions, tokens, strip_comments
from mpq import MPQ, write_files
from objdata import read_objects, write_objects
from vjass_lite import GLOBALS_RE, resolve_static_ifs
from wct import read_wct, write_wct, text_of, raw_of
from wtg import read_wtg, write_wtg
from downgrade import wts_read, wts_write, inline_strings


class Conflict(ValueError):
    pass


def relayout(reference_path,edited_path,out_path):
    """Put each object field in the table (base or skin) the reference keeps it in.

    Reforged World Editor may move display fields between war3map.* and war3mapSkin.*
    on save. The game reads the skin value over the base value, so the combined field
    set is what the author made; laying it out like the reference keeps the merge from
    mistaking a move for a deleted field. World Editor also drops fields it treats as
    defaults; those keep the reference value, so to reset a field give it an explicit value.
    Returns the number of field placements changed."""
    ref,edited=MPQ(str(reference_path)),MPQ(str(edited_path))
    changes={};moved=0;ref_strings=wts_read(ref.read('war3map.wts'))
    for ext in ('w3u','w3t','w3a','w3b','w3d','w3h','w3q'):
        main,skin='war3map.'+ext,'war3mapSkin.'+ext
        if not (edited.read(main) and edited.read(skin) and ref.read(main) and ref.read(skin)):continue
        ref_tables=[read_objects(ref.read(n),ext) for n in (main,skin)]
        for table in ref_tables:inline_strings(table,ref_strings)  # reference string ids mean nothing here
        rp,rs=map(object_index,ref_tables)
        plain_t,skin_t=read_objects(edited.read(main),ext),read_objects(edited.read(skin),ext)
        pi,si=object_index(plain_t),object_index(skin_t)
        for key in pi.keys()|si.keys():
            if key not in rp and key not in rs:continue
            pm=mods(pi[key]) if key in pi else {}
            sm=mods(si[key]) if key in si else {}
            combined=dict(pm);combined.update(sm)
            in_skin=mods(rs[key]) if key in rs else {};in_plain=mods(rp[key]) if key in rp else {}
            # World Editor also drops fields it considers defaults; keep the reference value.
            for fk,m in list(in_plain.items())+list(in_skin.items()):
                if fk not in combined:combined[fk]=copy.deepcopy(m)
            def entries(obj):
                return [((st['flag'],m['field'],m.get('level'),m.get('data')),m) for st in obj['sets'] for m in st['mods']] if obj else []
            # Reference order (repeats included) first, so an untouched object reads like the reference.
            def like(ref_entries):
                # Only the last of a repeated field is read; earlier repeats keep the reference entry.
                last={fk:i for i,(fk,_) in enumerate(ref_entries)}
                return [(fk,combined[fk] if i==last[fk] else copy.deepcopy(m)) for i,(fk,m) in enumerate(ref_entries)]
            new_p=like(entries(rp.get(key)))
            new_s=like(entries(rs.get(key)))
            for fk,m in combined.items():
                if fk in in_plain or fk in in_skin:continue
                if fk in sm:new_s.append((fk,m))
                if fk in pm or fk not in sm:new_p.append((fk,m))
            if new_p==entries(pi.get(key)) and new_s==entries(si.get(key)):continue
            moved+=len({k for k,_ in new_s}^set(sm))+len({k for k,_ in new_p}^set(pm))
            for table,index,wanted in ((plain_t,pi,new_p),(skin_t,si,new_s)):
                if key not in index:
                    if not wanted:continue
                    src=pi.get(key) or si[key]
                    obj=dict(src,sets=[]);table[key[0]].append(obj);index[key]=obj
                obj=index[key]
                flags=list(dict.fromkeys([st['flag'] for st in obj['sets']]+[k[0] for k,_ in wanted]))
                obj['sets']=[dict(flag=f,mods=[copy.deepcopy(m) for k,m in wanted if k[0]==f]) for f in flags]
        changes[main]=write_objects(plain_t,plain_t['version'],ext)
        changes[skin]=write_objects(skin_t,skin_t['version'],ext)
    write_files(str(edited_path),str(out_path),changes)
    from add_header import read_header,build_header
    # Newer World Editor saves can omit the HM3W header; the reference supplies one then.
    has_header=Path(edited_path).read_bytes()[:4]==b'HM3W'
    name,flags,players=read_header(str(edited_path if has_header else reference_path))
    data=Path(out_path).read_bytes()
    Path(out_path).write_bytes(build_header(name,flags,players)+data[data.index(b'MPQ\x1a'):])
    return moved


def exclude_resets(base_data,edited_data,fallback_data,ext):
    """Do not resurrect explicit Reset to Default edits through classic fallback."""
    if not base_data or not fallback_data:return fallback_data,0
    base=read_objects(base_data,ext)
    edited=read_objects(edited_data,ext) if edited_data else dict(original=[],custom=[])
    fallback=read_objects(fallback_data,ext);removed=0
    for group in ('original','custom'):
        index=lambda table:{(o['base'],o['id']):o for o in table[group]}
        old,new=index(base),index(edited)
        keys=lambda o:{(m['field'],m['level'],m['data']) for s in o['sets'] for m in s['mods']}
        for obj in fallback[group]:
            key=(obj['base'],obj['id'])
            if key not in old:continue
            resets=keys(old[key])-(keys(new[key]) if key in new else set())
            for entry in obj['sets']:
                before=len(entry['mods'])
                entry['mods']=[m for m in entry['mods'] if (m['field'],m['level'],m['data']) not in resets]
                removed+=before-len(entry['mods'])
    return write_objects(fallback,fallback['version'],ext),removed


def classic_fallback(base_path,edited_path,template_path,out_path):
    base,edited,template=map(MPQ,map(str,(base_path,edited_path,template_path)))
    changes={};count=0
    for ext in ('w3u','w3t','w3a','w3b','w3d','w3h','w3q'):
        main='war3map.'+ext
        value=template.read(main)
        if not value:continue
        # Skin fields join the same classic table, so either editor table can reset one.
        for name in (main,'war3mapSkin.'+ext):
            value,n=exclude_resets(base.read(name),edited.read(name),value,ext)
            count+=n
        if value!=template.read(main):changes[main]=value
    write_files(str(template_path),str(out_path),changes)
    return count


def merge_value(base, edited, profile, label):
    if edited==base:return profile
    if profile==base or profile==edited:return edited
    if all(isinstance(v,str) for v in (base,edited,profile)):
        merge_root=Path(__file__).resolve().parents[1]/'build'
        merge_root.mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(prefix='editor-merge-',dir=merge_root) as tmp:
            if not Path(tmp).resolve().is_relative_to(merge_root.resolve()):
                raise Conflict('merge scratch directory escaped the workspace')
            paths=[Path(tmp)/n for n in ('edited','base','profile')]
            for p,s in zip(paths,(edited,base,profile)):
                p.write_bytes(s.encode('utf-8'))
            result=subprocess.run(['git','merge-file','-p',*map(str,paths)],capture_output=True)
            if result.returncode==0:
                return result.stdout.decode('utf-8')
    raise Conflict(label+': editor and profile changed the same value; needs a paired adaptation')


def decls(source):
    match=GLOBALS_RE.search(source)
    return declarations(match[1]) if match else {}


def declarations(body):
    result={}
    for line in strip_comments(body).splitlines():
        line=line.strip()
        if not line:continue
        match=re.match(r'(?:constant\s+)?\w+\s+(?:array\s+)?(\w+)',line)
        if not match:raise Conflict('unsupported global declaration: '+line)
        if match[1] in result:raise Conflict('duplicate global: '+match[1])
        result[match[1]]=line
    return result


def put_globals(source, values):
    match=GLOBALS_RE.search(source)
    block='globals\n'+'\n'.join(values.values())+'\nendglobals\n'
    if match:return source[:match.start()]+block+source[match.end():]
    at=source.index('\n')+1
    return source[:at]+block+source[at:]


def put_function(source,name,value):
    pattern=r'^[ \t]*(?:constant\s+)?function '+re.escape(name)+r' takes\b.*?^[ \t]*endfunction[^\n]*\n?'
    if re.search(pattern,source,re.M|re.S):
        return re.sub(pattern,lambda _:value+'\n' if value else '',source,count=1,flags=re.M|re.S)
    if value:
        at=source.find('endlibrary')
        if at<0:at=source.index('function InitCustomTriggers')
        return source[:at]+value+'\n'+source[at:]
    return source


def merge_module(base,edited,profile,label):
    if edited==base:return profile
    if profile==base:return edited
    result=profile
    a,b,c=map(functions,(base,edited,profile))
    for name in a.keys()|b.keys():
        if a.get(name)==b.get(name):continue
        merged=merge_value(a.get(name),b.get(name),c.get(name),label+'/'+name)
        if name not in c and merged:
            # A newly called helper must precede its callers inside the library.
            following=list(b)[list(b).index(name)+1:]
            anchor=next((n for n in following if n in functions(result)),None)
            if anchor:
                at=result.index('function '+anchor+' takes')
                result=result[:at]+merged+'\n'+result[at:]
                continue
        result=put_function(result,name,merged)
    a,b,c=map(decls,(base,edited,profile))
    for name in a.keys()|b.keys():
        if a.get(name)==b.get(name):continue
        v=merge_value(a.get(name),b.get(name),c.get(name),label+'/global '+name)
        if v is None:c.pop(name,None)
        else:c[name]=v
    if c:result=put_globals(result,c)
    # Keep native requirements; apply the editor's deliberate dependency additions/removals.
    def reqs(s):
        first=s.splitlines()[0]
        return [v.strip() for v in re.split(r'\b(?:requires|needs|uses)\b',first,maxsplit=1)[1].split(',')] if re.search(r'\b(?:requires|needs|uses)\b',first) else []
    old,new,current=map(reqs,(base,edited,profile))
    current=[v for v in current if v not in set(old)-set(new)]
    current+= [v for v in new if v not in old and v not in current]
    header=profile.splitlines()[0].split(' requires')[0].split(' needs')[0].split(' uses')[0]
    if current:header+=' requires '+', '.join(current)
    result=header+'\n'+result.split('\n',1)[1]
    return result


class View:
    def __init__(self,path):
        self.path=Path(path);self.archive=MPQ(str(path))
        self.tree=read_wtg(self.archive.read('war3map.wtg'))
        self.wct=read_wct(self.archive.read('war3map.wct'))
        if self.wct['format']!='reforged':raise Conflict('Use a Reforged-format editor master, not a converted 1.29.2 output')
        if len(trigger_items(self.tree))!=len(self.wct['entries']):raise Conflict('trigger tree/source count mismatch')
        self.modules={};self.entries={}
        for item,raw in zip(trigger_items(self.tree),self.wct['entries']):
            source=text_of(raw).replace('\r\n','\n')
            match=re.match(r'\s*library\s+(\w+)\b',source)
            if match:
                lib=match[1]
                if lib in self.modules:raise Conflict('duplicate library '+lib)
                self.modules[lib]=source;self.entries[lib]=item
        runtime=self.archive.read('war3map.j')
        if runtime is None:raise Conflict('The editor master must remain a JASS map; Lua cannot build for 1.29.2')
        self.runtime=runtime.decode('utf-8').replace('\r\n','\n')
        self.strings=wts_read(self.archive.read('war3map.wts'))
        self.objects={}

    def object_bytes(self,name):
        if name not in self.objects:
            data=self.archive.read(name)
            if data:
                ext=name.rsplit('.',1)[1];table=read_objects(data,ext)
                inline_strings(table,self.strings)
                data=write_objects(table,table['version'],ext)
            self.objects[name]=data
        return self.objects[name]


def modules_for(base,edited,profile):
    result=dict(profile.modules)
    for lib in base.modules.keys()|edited.modules.keys():
        a,b,c=base.modules.get(lib),edited.modules.get(lib),profile.modules.get(lib)
        if a==b:continue
        if b and re.search(r'^\s*(?:private|public|struct|scope|module|interface|method)\b|^\s*//!',b,re.M):
            raise Conflict(lib+': this vJass construct needs compiler support before making a compatible pair')
        if lib.startswith('TForsakenSave') or lib=='TForsakenFreshLoad':
            if tokens(a or '')!=tokens(b or ''):
                raise Conflict(lib+': save-code changes require a reviewed paired codec migration')
        if a is not None and c is None:
            raise Conflict(lib+': this is classic-only code; provide its native equivalent before building both')
        if a is None:
            if c is not None and c!=b:raise Conflict(lib+': new library collides with the native profile')
            result[lib]=b
        elif b is None:
            if c!=a:raise Conflict(lib+': cannot remove a library adapted for the native profile')
            result.pop(lib,None)
        else:result[lib]=merge_module(a,b,c,lib)
    return result


def tree_for(base,edited,profile,modules):
    tree=copy.deepcopy(edited.tree);wct=copy.deepcopy(edited.wct)
    pairs={it['id']:raw for it,raw in zip(trigger_items(tree),wct['entries'])}
    by_id={it['id']:lib for lib,it in edited.entries.items()}
    keep=[];present=set()
    for item in tree['items']:
        lib=by_id.get(item['id'])
        if lib and lib not in modules:continue
        if lib:
            present.add(lib);pairs[item['id']]=raw_of(modules[lib].replace('\n','\r\n'))
            if lib in base.entries and lib in profile.entries:
                for key in ('enabled','initially_off','run_on_init'):
                    item[key]=merge_value(base.entries[lib][key],item[key],profile.entries[lib][key],lib+'/'+key)
        keep.append(item)
    tree['items']=keep
    used={it['id'] for it in keep}
    def allocate(kind):
        n=max([it['id'] for it in tree['items'] if it['kind']==kind] or [0x2000000 if kind==4 else 0x6000000])+1
        while n in used:n+=1
        used.add(n);tree['counts'][kind]+=1
        return n
    root=next(it['id'] for it in keep if it['kind']==1)
    native_items={it['id']:it for it in profile.tree['items']}
    def folder(native_id):
        it=native_items[native_id]
        if it['kind']==1:return root
        parent=folder(it['parent'])
        existing=next((v for v in tree['items'] if v['kind']==4 and v['name']==it['name'] and v['parent']==parent),None)
        if existing:return existing['id']
        new=copy.deepcopy(it);new.update(id=allocate(4),parent=parent);tree['items'].append(new)
        return new['id']
    for lib in sorted(modules.keys()-present):
        if lib not in profile.entries:raise Conflict('new library lacks editor trigger: '+lib)
        item=copy.deepcopy(profile.entries[lib]);item.update(id=allocate(item['kind']),parent=folder(item['parent']))
        tree['items'].append(item);pairs[item['id']]=raw_of(modules[lib].replace('\n','\r\n'))
    wct['entries']=[pairs[it['id']] for it in trigger_items(tree)]
    wct['header']=raw_of(merge_value(text_of(base.wct['header']),text_of(edited.wct['header']),text_of(profile.wct['header']),'map header'))
    tree,wct=normalize(tree,wct)
    return tree,wct


def compiled(source,libs):
    match=re.match(r'library\s+(\w+)[^\n]*\n(.*?)^endlibrary',source,re.M|re.S)
    if not match:raise Conflict('only one vJass library per custom-text trigger is supported')
    body=resolve_static_ifs(match[2],libs)
    globals_=GLOBALS_RE.search(body)
    values=declarations(globals_[1]) if globals_ else {}
    if globals_:body=body[:globals_.start()]+body[globals_.end():]
    body=re.sub(r'^([ \t]*)(?:private|public)\s+(function|constant)',r'\1\2',body,flags=re.M)
    if re.search(r'^\s*(?:struct|scope|textmacro|implement|method)\b',body,re.M):
        raise Conflict(match[1]+': unsupported vJass construct; needs compiler adaptation')
    return '//library '+match[1]+':\n'+body.strip()+'\n//library '+match[1]+' ends\n',values


def runtime_for(base,edited,profile,modules):
    rt=profile.runtime
    values=decls(rt)
    owned=set().union(*(set(functions(s)) for s in base.modules.values()),*(set(functions(s)) for s in edited.modules.values()))
    native_owned=set().union(*(set(functions(s)) for s in profile.modules.values()))
    for name in functions(base.runtime).keys()-functions(edited.runtime).keys():
        if name not in owned and name not in native_owned:
            rt=put_function(rt,name,None)
    # Editor-generated placement/region/sound/player functions own the common world.
    for name,body in functions(edited.runtime).items():
        if name in owned or name=='InitCustomTriggers':continue
        if name in native_owned:raise Conflict('generated function collides with native library: '+name)
        rt=put_function(rt,name,body)
    # Only editor changes to GUI/global declarations cross over; native globals remain intact.
    a,b=decls(base.runtime),decls(edited.runtime)
    module_globals=set().union(*(set(decls(s)) for s in base.modules.values()),*(set(decls(s)) for s in edited.modules.values()))
    for name in a.keys()|b.keys():
        if name in module_globals or name.startswith('LIBRARY_') or a.get(name)==b.get(name):continue
        v=merge_value(a.get(name),b.get(name),values.get(name),'global '+name)
        if v is None:values.pop(name,None)
        else:values[name]=v
    active=set()
    for lib in modules:
        if lib in base.entries and lib in edited.entries and lib in profile.entries:
            on=merge_value(base.entries[lib]['enabled'],edited.entries[lib]['enabled'],profile.entries[lib]['enabled'],lib+'/enabled')
        else:on=(edited.entries.get(lib) or profile.entries[lib])['enabled']
        if on:active.add(lib)
    was_active={lib for lib,it in profile.entries.items() if it['enabled']}
    removed_libs=profile.modules.keys()-modules.keys() | was_active-active
    for lib in removed_libs:
        pattern=r'^// ?library '+re.escape(lib)+r':\n.*?^// ?library '+re.escape(lib)+r' ends[^\n]*\n?'
        rt=re.sub(pattern,'',rt,flags=re.M|re.S)
        for name in decls(profile.modules[lib]):values.pop(name,None)
        values.pop('LIBRARY_'+lib,None)
    for lib,source in modules.items():
        if lib not in active:continue
        if profile.modules.get(lib)==source and lib in was_active:continue
        block,globals_=compiled(source,active)
        for name in set(decls(profile.modules.get(lib,'')))-globals_.keys():values.pop(name,None)
        values.update(globals_);values['LIBRARY_'+lib]='constant boolean LIBRARY_'+lib+'=true'
        pattern=r'^// ?library '+re.escape(lib)+r':\n.*?^// ?library '+re.escape(lib)+r' ends[^\n]*\n?'
        if re.search(pattern,rt,re.M|re.S):rt=re.sub(pattern,lambda _:block,rt,count=1,flags=re.M|re.S)
        else:
            at=rt.index('function InitCustomTriggers');rt=rt[:at]+block+rt[at:]
    # GUI/custom trigger additions and removals are relative to the editor reference.
    def calls(s):return re.findall(r'call (InitTrig_\w+)\(\)',functions(s)['InitCustomTriggers'])
    old,new,current=calls(base.runtime),calls(edited.runtime),calls(rt)
    removed=set(old)-set(new)
    removed|={'InitTrig_'+profile.entries[lib]['name'] for lib in removed_libs}
    current=[name for name in current if name not in removed]
    current+=[name for name in new if name not in old and name not in current]
    for lib in active-was_active:
        name='InitTrig_'+edited.entries[lib]['name']
        if name not in current:current.append(name)
    rt=put_function(rt,'InitCustomTriggers','function InitCustomTriggers takes nothing returns nothing\n'+''.join('    call '+n+'()\n' for n in current)+'endfunction')
    return put_globals(rt,values)


def object_index(table):
    return {(group,o['id'] or o['base']):o for group in ('original','custom') for o in table[group]}


def mods(obj):
    return {(st['flag'],m['field'],m.get('level'),m.get('data')):m for st in obj['sets'] for m in st['mods']}


def field_value(mod):
    return (mod['type'],mod['value']) if mod else None


def merge_mod(base,edit,profile,label):
    a,b,c=map(field_value,(base,edit,profile))
    if a==b:return copy.deepcopy(profile)
    if a==c or b==c:return copy.deepcopy(edit)
    if all(v and v[0]==3 for v in (a,b,c)) and (profile or edit or base)['field'] in ('uabi','uhab','iabi'):
        old,new,current=([x for x in v[1].split(',') if x] for v in (a,b,c))
        if any(x not in current for x in set(old)-set(new)):
            raise Conflict(label+': removed ability has a native substitution; needs an adaptation')
        merged=[x for x in new if x in current or x not in old]
        merged+=[x for x in current if x not in old and x not in merged]
        mod=copy.deepcopy(profile);mod['value']=','.join(merged)
        return mod
    if all(v and v[0]==3 for v in (a,b,c)):
        # Slot descriptions belong to the inventory profile, not the author's prose.
        slot=r'\|n\|cffffcc00(?:Forsaken slot|Slot)\|r: [^|]*(?=\|n|$)'
        aa,bb,cc=(re.sub(slot,'',v[1]) for v in (a,b,c))
        suffix=re.findall(slot,c[1])
        value=merge_value(*(s.replace('|n','\n') for s in (aa,bb,cc)),label).replace('\n','|n')
        m=copy.deepcopy(profile);m['value']=value+(suffix[-1] if suffix else '')
        return m
    raise Conflict(label+': object field conflicts with the inventory/UI profile')


def merge_objects(base_bytes,edited_bytes,profile_bytes,ext,aliases=None):
    a=read_objects(base_bytes,ext) if base_bytes else dict(original=[],custom=[],version=3)
    b=read_objects(edited_bytes,ext) if edited_bytes else dict(original=[],custom=[],version=3)
    c=read_objects(profile_bytes,ext) if profile_bytes else dict(original=[],custom=[],version=b['version'])
    ai,bi,ci=map(object_index,(a,b,c))
    aliases=aliases or {}
    for key in ai.keys()|bi.keys():
        before,edit=ai.get(key),bi.get(key)
        if before==edit:continue
        if before is None:
            if key in ci and ci[key]!=edit:raise Conflict(ext+'/'+key[1]+': new object ID collides with the native profile')
            if key not in ci:c[key[0]].append(copy.deepcopy(edit));ci[key]=c[key[0]][-1]
            continue
        if edit is None:
            if ci.get(key)!=before:raise Conflict(ext+'/'+key[1]+': cannot delete a profile-modified object')
            c[key[0]].remove(ci.pop(key));continue
        if before['base']!=edit['base']:raise Conflict(ext+'/'+key[1]+': changing an existing object base needs review')
        targets=[key]+[(key[0],raw) for raw in aliases.get(key[1],[])]
        for target in targets:
            if target not in ci:raise Conflict(ext+'/'+target[1]+': target object is missing')
            obj=ci[target];am,bm,cm=mods(before),mods(edit),mods(obj)
            for field in am.keys()|bm.keys():
                if field_value(am.get(field))==field_value(bm.get(field)):continue
                aa,bb=copy.deepcopy(am.get(field)),copy.deepcopy(bm.get(field))
                if target!=key:
                    if field[1]=='icla':continue  # Native clones must remain equipment.
                    if field[1]=='iabi':
                        for m in (aa,bb):
                            if m:m['value']+=',fGmk'
                value=merge_mod(aa,bb,cm.get(field),ext+'/'+target[1]+'/'+str(field))
                if value is None:cm.pop(field,None)
                else:cm[field]=value
            flags=list(dict.fromkeys([st['flag'] for st in obj['sets']]+[k[0] for k in cm]))
            obj['sets']=[dict(flag=flag,mods=[m for k,m in cm.items() if k[0]==flag]) for flag in flags]
    return write_objects(c,c['version'],ext)


def mirror_skin(old_base,new_base,old_skin,new_skin,ext):
    """An unchanged skin override must not hide a deliberate base-field edit."""
    aa,bb,cc,dd=[read_objects(data,ext) for data in (old_base,new_base,old_skin,new_skin)]
    a,b,c,d=map(object_index,(aa,bb,cc,dd))
    for key in a.keys()&b.keys()&c.keys()&d.keys():
        am,bm,cm,dm=map(mods,(a[key],b[key],c[key],d[key]))
        for field in am.keys()|bm.keys():
            if field not in cm or field_value(am.get(field))==field_value(bm.get(field)):continue
            if field_value(dm.get(field))!=field_value(cm[field]):continue  # Explicit skin edits win.
            value=merge_mod(am.get(field),bm.get(field),cm[field],ext+'/'+key[1]+'/skin '+str(field))
            if value is None:dm.pop(field,None)
            else:dm[field]=value
        flags=list(dict.fromkeys([st['flag'] for st in d[key]['sets']]+[k[0] for k in dm]))
        d[key]['sets']=[dict(flag=flag,mods=[m for k,m in dm.items() if k[0]==flag]) for flag in flags]
    return write_objects(dd,dd['version'],ext)


WORLD={'war3map.w3e','war3map.doo','war3mapUnits.doo','war3map.wpm','war3map.w3r','war3map.w3c','war3map.w3s',
       'war3map.shd','war3mapMap.blp','war3mapMap.tga'}
STRUCTURAL={'war3map.j','war3map.wtg','war3map.wct','war3map.w3i','(listfile)','(attributes)','(signature)'}


def derived_native_objects(base,edited,modules):
    """Regenerate object aliases and lookup deltas from the author's actual object data."""
    import sys
    root=Path(__file__).resolve().parents[1]
    sys.path.insert(0,str(root/'experiments/Forsaken'))
    import build_forsaken as generator
    parent=root/'build';parent.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='editor-native-data-',dir=parent) as tmp:
        work=Path(tmp).resolve()
        if not work.is_relative_to(parent.resolve()):raise Conflict('native-data scratch escaped the workspace')
        old,new=work/'old.w3x',work/'new.w3x'
        resolved=[]
        for label,view in [('base',base),('edited',edited)]:
            path=work/(label+'-strings.w3x')
            replacements={name:view.object_bytes(name) for name in
                ('war3map.w3u','war3map.w3t','war3map.w3a','war3mapSkin.w3u','war3mapSkin.w3t','war3mapSkin.w3a')
                if view.archive.read(name)}
            write_files(str(view.path),str(path),replacements)
            resolved.append(path)
        before=generator.prepare_objects(resolved[0],old,work/'old.json')
        after=generator.prepare_objects(resolved[1],new,work/'new.json')
        if before!=after:
            structural=lambda m:{k:(v['slot'],v.get('variant'),v.get('offhand')) for k,v in m.items()}
            if structural(before)!=structural(after):
                raise Conflict('equipment slot/catalogue changed: requires a reviewed save-compatible slot migration')
        sources=[]
        for path,mapping in ((old,before),(new,after)):
            lines=generator.bag_passive_initialization(str(path))
            lines+=generator.item_accuracy_initialization(path,mapping)
            lines+=generator.regeneration_initialization(str(path))
            lines+=generator.element_source_initialization(path)
            sources.append({line.strip().rsplit(',',1)[0]:line for line in lines if line.strip().startswith('call Save')})
        a,b=sources
        if a!=b:
            equip=modules['TEquip'];body=functions(equip)['Register_Forsaken_Equipment']
            for key in sorted(a.keys()|b.keys()):
                if a.get(key)==b.get(key):continue
                if key in a:
                    matches=[line for line in body.splitlines() if tokens(line)==tokens(a[key])]
                    if len(matches)!=1:raise Conflict('native generated lookup differs: '+key)
                    body=body.replace(matches[0],b.get(key,''),1)
                else:
                    marker='    set gg_trg_Forsaken_Equipment=CreateTrigger()'
                    if body.count(marker)!=1:raise Conflict('native equipment initializer changed')
                    body=body.replace(marker,b[key]+'\n'+marker,1)
            modules['TEquip']=put_function(equip,'Register_Forsaken_Equipment',body)
        objects={}
        for name in ('war3map.w3u','war3map.w3t','war3map.w3a','war3mapSkin.w3u','war3mapSkin.w3t','war3mapSkin.w3a'):
            aa,bb=MPQ(str(old)).read(name),MPQ(str(new)).read(name)
            if aa!=bb:objects[name]=(aa,bb)
        return objects


def prepare(base_path,edited_path,profile_path,out_path,*,native=False,aliases=None):
    base,edited,profile=map(View,(base_path,edited_path,profile_path))
    modules=modules_for(base,edited,profile)
    from save_strings import refresh_runtime
    from performance_runtime import refresh as refresh_performance
    from gameplay_runtime import refresh as refresh_gameplay
    from job_runtime import refresh as refresh_jobs
    from inventory_ui import refresh as refresh_inventory_ui
    modules={lib:refresh_inventory_ui(refresh_jobs(refresh_gameplay(refresh_performance(refresh_runtime(s) if lib.startswith(('TForsakenSave','TForsakenFreshLoad')) else s),native=native),native=native))
             for lib,s in modules.items()}
    derived={}
    if native and (any(base.object_bytes(n)!=edited.object_bytes(n) for n in
                      ('war3map.w3a','war3map.w3t','war3map.w3u','war3mapSkin.w3a','war3mapSkin.w3t','war3mapSkin.w3u')) or
                      base.archive.read('war3mapMisc.txt')!=edited.archive.read('war3mapMisc.txt')):
        derived=derived_native_objects(base,edited,modules)
    rt=runtime_for(base,edited,profile,modules)
    guard_lib=next((lib for lib,s in modules.items() if 'function FFL_Guard takes' in s),None)
    if guard_lib:
        import sys
        sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'experiments/Forsaken'))
        from build_save_roundtrip import load_source
        guard=functions(load_source(rt))['FFL_Guard']
        if tokens(guard)!=tokens(functions(modules[guard_lib])['FFL_Guard']):
            modules[guard_lib]=put_function(modules[guard_lib],'FFL_Guard',guard)
            rt=put_function(rt,'FFL_Guard',guard)
    tree,wct=tree_for(base,edited,profile,modules)
    replacements={'war3map.wtg':write_wtg(tree),'war3map.wct':write_wct(wct),'war3map.j':rt.replace('\n','\r\n').encode('utf-8')}
    names=lambda m:set(m.archive.read('(listfile)').decode('utf-8').replace('\r','').splitlines())
    changed=[]
    for name in names(base)|names(edited)|WORLD|derived.keys():
        if name in STRUCTURAL:continue
        a,b,c=(v.archive.read(name) for v in (base,edited,profile))
        obj=re.fullmatch(r'war3map(?:Skin)?\.(w3[utabdqh])',name)
        if obj:a,b,c=(v.object_bytes(name) for v in (base,edited,profile))
        if name in derived:a,b=derived[name]
        if a==b and name not in WORLD:continue
        changed.append(name)
        if obj:replacements[name]=merge_objects(a,b,c,obj[1],None if name in derived else aliases if obj[1]=='w3t' else None)
        elif name=='war3map.wts':
            strings=dict(profile.strings)
            for key in base.strings.keys()|edited.strings.keys():
                v=merge_value(base.strings.get(key),edited.strings.get(key),strings.get(key),'STRING '+str(key))
                if v is None:strings.pop(key,None)
                else:strings[key]=v
            replacements[name]=wts_write(strings)
        elif name in WORLD:replacements[name]=b
        elif c==a or c==b:replacements[name]=b
        else:raise Conflict(name+': binary asset differs between profiles; needs a paired adaptation')
    for ext in ('w3u','w3t','w3a','w3b','w3d','w3h','w3q'):
        main='war3map.'+ext;skin='war3mapSkin.'+ext
        if main in replacements and replacements[main] and profile.archive.read(main) and profile.archive.read(skin):
            replacements[skin]=mirror_skin(profile.object_bytes(main),replacements[main],profile.object_bytes(skin),
                replacements.get(skin) or profile.object_bytes(skin),ext)
    info=edited.archive.read('war3map.w3i')
    if native:
        import sys
        sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'experiments/Forsaken'))
        from build_forsaken import forsaken_map_info
        info=forsaken_map_info(info)
        if any(lib in modules for lib in ('TBackpack','TSaveSlots','TForsakenSaveSlots')):
            raise Conflict('classic inventory modules entered the native build')
        if 'UnitItemInBagSlot(' not in rt or 'Forsaken_RebuildPanels' not in functions(rt):
            raise Conflict('native inventory/panel recovery was lost')
    from world_visuals import clear_marker_art
    ability_data=replacements.get('war3map.w3a') or profile.object_bytes('war3map.w3a')
    replacements['war3map.w3a'],marker_art=clear_marker_art(ability_data)
    from job_objects import refresh as refresh_job_objects
    for name in ('war3map.w3a','war3mapSkin.w3a'):
        data=replacements.get(name) or profile.object_bytes(name)
        if data:replacements[name]=refresh_job_objects(data)
    replacements['war3map.w3i']=info
    write_files(str(profile_path),str(out_path),replacements)
    from add_header import read_header,build_header
    name,flags,players=read_header(str(edited.path))
    data=Path(out_path).read_bytes()
    Path(out_path).write_bytes(build_header(name,flags,players)+data[data.index(b'MPQ\x1a'):])
    return dict(changed_files=sorted(changed),changed_modules=sorted(lib for lib,s in modules.items() if profile.modules.get(lib)!=s),
                world_authority=str(edited_path),native=native,cleared_marker_art=marker_art)
