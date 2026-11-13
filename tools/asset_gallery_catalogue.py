"""Catalogue locally installed HD assets against the RPG's explicit asset references."""
from pathlib import Path
import collections,csv,json,re,sys,struct
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mpq import MPQ
from objdata import read_objects
from downgrade import wts_read
from priest_master import fields

ROOT=Path(__file__).resolve().parents[1]
WORK=ROOT/'tools/build-inputs/asset-gallery'
DEST=ROOT/'experiments/AssetGallery'
HD='war3.w3mod:_hd.w3mod:'
GROUPS={1:'Units, heroes and creatures',2:'Buildings',3:'Props and scenery',4:'Spells, missiles and item effects',5:'Environment and terrain pieces',6:'Portraits and animation pieces',7:'Cinematics and miscellaneous world models'}

def normal(path):
    path=path.strip().lower().replace('/','\\').replace('\\\\','\\')
    path=re.sub(r'\.(?:mdl|mdx)$','.mdx',path)
    return path

def slk(data):
    x=y=0;rows=collections.defaultdict(dict)
    for line in data.decode('utf-8-sig','replace').splitlines():
        if not line.startswith('C;'):continue
        a=re.search(r';X(\d+)',line);b=re.search(r';Y(\d+)',line);v=re.search(r';K(.*)$',line)
        if a:x=int(a[1])
        if b:y=int(b[1])
        if v:rows[y][x]=v[1].strip('"').replace('""','"')
    header=rows.pop(1,{})
    return [{header.get(k,str(k)):v for k,v in row.items()} for row in rows.values()]

def sections(data):
    result={};current=None
    for line in data.decode('utf-8-sig','replace').splitlines():
        line=line.strip()
        if line.startswith('[') and line.endswith(']'):current=result.setdefault(line[1:-1],{})
        elif current is not None and '=' in line:
            k,v=line.split('=',1);current[k]=v
    return result

def category(path):
    if '_portrait' in path or re.search(r'(?:birth|death|decay|upgrade|work)\d?\.mdx$',path):return 6
    first=path.split('\\')[0]
    if first=='units':return 1
    if first=='buildings':return 2
    if first=='abilities' or first=='objects':return 4
    if first=='doodads':return 3
    if first=='environment':return 5
    return 7

def title(path):
    name=path.rsplit('\\',1)[-1].rsplit('.',1)[0]
    return name.replace('_',' ').title()

def create():
    names=json.loads((WORK/'casc-names.json').read_text())
    hd=sorted({normal(n[len(HD):]) for n in names if n.startswith(HD) and n.count(':')==2 and n.lower().endswith('.mdx')})
    used=set();game=MPQ(str(ROOT/'release/development/QuickUI30/FFERPG-QuickUI30-Forsaken.w3x'))
    strings=wts_read(game.read('war3map.wts'));skins=sections((WORK/'unitskin.txt').read_bytes())
    doodads=sections((WORK/'doodadskins.txt').read_bytes())
    destruct=sections((WORK/'destructableskin.txt').read_bytes())
    available=set(hd)
    def add(value):
        if not isinstance(value,str):return
        value=value.replace('\\\\','\\')
        if value.startswith('TRIGSTR_'):value=strings.get(int(value[8:]),value)
        for path in value.split(','):
            if '\\' not in path and '/' not in path:continue
            path=normal(path)
            if not path.endswith('.mdx'):path+='.mdx'
            if path in available:used.add(path)
            stem=path[:-4]
            for n in range(10):
                if stem+str(n)+'.mdx' in available:used.add(stem+str(n)+'.mdx')
    for ext in ['w3u','w3a','w3t','w3b','w3d']:
        for prefix in ['war3map.','war3mapSkin.']:
            data=game.read(prefix+ext)
            if not data:continue
            table=read_objects(data,ext)
            for obj in table['original']+table['custom']:
                if ext=='w3u':
                    for key in ['file','file:hd']:add(skins.get(obj['base'],{}).get(key,''))
                elif ext=='w3d':add(doodads.get(obj['base'],{}).get('file',''))
                elif ext=='w3b':add(destruct.get(obj['base'],{}).get('file',''))
                for entry in obj['sets']:
                    for mod in entry['mods']:
                        if mod['type']==3:add(mod['value'])
    # Include direct script effect paths and stock unit IDs created by script.
    script=game.read('war3map.j').decode()
    for path in re.findall(r'"([^"\r\n]*\.(?:mdl|mdx))"',script,re.I):add(path)
    for raw in set(re.findall(r"'([A-Za-z0-9]{4})'",script)):
        for key in ['file','file:hd']:add(skins.get(raw,{}).get(key,''))
    from downgrade import doo_v8,_skip_sets
    placements=doo_v8(game.read('war3map.doo'));offset=16
    for _ in range(struct.unpack_from('<I',placements,12)[0]):
        raw=placements[offset:offset+4].decode('latin1')
        for key in ['file','file:hd']:
            add(doodads.get(raw,{}).get(key,''));add(destruct.get(raw,{}).get(key,''))
        offset=_skip_sets(placements,offset+42)+4
    for path in list(used):
        if path[:-4]+'_portrait.mdx' in available:used.add(path[:-4]+'_portrait.mdx')
    excluded=[p for p in hd if p.startswith(('ui\\','sharedmodels\\'))]
    models=[{'path':p,'name':title(p),'group':category(p),'used':p in used} for p in hd if p not in excluded]
    unused=sorted((m for m in models if not m['used']),key=lambda m:(m['group'],m['path']))
    for i,m in enumerate(unused,1):m['id']=i
    icons={}
    for prefix in ['war3.w3mod:',HD]:
        for n in names:
            if n.startswith(prefix) and n.count(':')==prefix.count(':'):
                path=n[len(prefix):].lower()
                if path.startswith('replaceabletextures\\commandbuttons\\') and path.endswith(('.blp','.dds')):
                    icons[path]={'path':path,'name':title(path),'hd':prefix==HD}
    icons=sorted(icons.values(),key=lambda m:m['path'])
    for i,entry in enumerate(icons,1):entry['id']=i
    allmodels=sorted(models,key=lambda m:m['path'])
    manifest={'comparison_map':'QuickUI30','hd_models_found':len(hd),'unused_world_models':len(unused),'referenced_models_excluded':len(used),
        'ui_only_model_files_excluded':excluded,'groups':{str(k):{'name':v,'count':sum(m['group']==k for m in unused)} for k,v in GROUPS.items()},
        'icons':len(icons),'method':'Unused = no matching explicit object-model field, inherited stock unit model, stock doodad/destructible model, or script model path in QuickUI30. Filename matching cannot identify every dynamically constructed path. Portraits of referenced units are excluded. HD UI-only/shared skeleton files are omitted.',
        'models':unused,'icon_catalogue':icons,'all_world_models':allmodels}
    DEST.mkdir(parents=True,exist_ok=True)
    (DEST/'catalogue.json').write_text(json.dumps(manifest,indent=2)+'\n')
    for filename,rows,keys in [('unused-models.csv',unused,['id','group','name','path']),('icons.csv',icons,['id','name','path','hd'])]:
        with (DEST/filename).open('w',newline='',encoding='utf-8-sig') as f:
            w=csv.DictWriter(f,fieldnames=keys,extrasaction='ignore');w.writeheader();w.writerows(rows)
    print(json.dumps({k:v for k,v in manifest.items() if k not in ['models','icon_catalogue','all_world_models','ui_only_model_files_excluded']},indent=2))
    return manifest

if __name__=='__main__':create()
