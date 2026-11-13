"""Build V18 and production mastery-only Recovery07 counterparts."""
from build_f1030_inventory_rollback import *
from creatures_v18 import refresh,objects

def build(base,out,label,classic=False,dev=False):
 assert not out.exists()
 v=view(str(base));modules={lib:refresh(lib,s,dev) for lib,s in v.modules.items()}
 changed=sorted(k for k in modules if modules[k]!=v.modules[k]);files={}
 if dev:
  units,abilities=objects(v)
  for ext,replacements in [('w3u',units),('w3a',abilities)]:
   for prefix in ['war3map','war3mapSkin']:
    name=prefix+'.'+ext;data=v.archive.read(name)
    if not data:continue
    t=read_objects(data,ext)
    for table in ['original','custom']:
     if prefix=='war3map':
      t[table]=[copy.deepcopy(replacements.get(o['id'] or o['base'],o)) for o in t[table]]
     else:t[table]=[o for o in t[table] if (o['id'] or o['base']) not in replacements]
    packed=write_objects(t,t['version'],ext)
    if packed!=data:files[name]=packed
 rt=runtime_for(v,v,v,modules)
 # Replacing a library can undo historical runtime-only inlining elsewhere in
 # that library. Keep every unrelated playable function exactly as it was.
 original_runtime=functions(v.runtime)
 for lib in changed:
  old_source,new_source=functions(v.modules[lib]),functions(modules[lib])
  for n,b in new_source.items():
   if n in old_source and n in original_runtime and tokens(old_source[n])==tokens(b):
    rt=put(rt,n,original_runtime[n])
 rt,_=order(rt);rt=re.sub(r'\n{3,}','\n\n',rt)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 files.update({'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)})
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(rt)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j');bliz=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(bliz),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1500:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 final=MPQ(str(out))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert final.read(n)==files.get(n,v.archive.read(n)),n
 before,after=functions(v.runtime),functions(rt)
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_modules=changed,changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),removed_functions=sorted(before.keys()-after.keys()),changed_resources=sorted(files),acceptance='Native gameplay and multiplayer unverified. Inventory/autosave/load mechanisms retained; only mastery lookup changes in production.'),indent=2));print(out)

if __name__=='__main__':
 build(ROOT/'release/development/V17/FFERPG-V17.w3x',ROOT/'release/development/V18/FFERPG-V18.w3x','FFERPG V18',dev=True)
 build(ROOT/'release/development/GRecovery06/FFERPG-0.9.7.5g-Recovery06.w3x',ROOT/'release/development/GRecovery07/FFERPG-0.9.7.5g-Recovery07.w3x','FFERPG 0.9.7.5g Recovery07')
 build(ROOT/'release/development/GRecovery06/FFERPG-0.9.7.5g-1.29.2-Recovery06.w3x',ROOT/'release/development/GRecovery07/FFERPG-0.9.7.5g-1.29.2-Recovery07.w3x','FFERPG 0.9.7.5g Recovery07 1.29.2',classic=True)
