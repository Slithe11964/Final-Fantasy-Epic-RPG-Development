"""Package selective requested features without restoring Inventory94."""
from build_f1030_inventory_rollback import *
from selective_f_restore import refresh

def build_selected(base,out,label,classic=False):
 assert not out.exists()
 v=view(str(base));modules={lib:refresh(lib,s,classic) for lib,s in v.modules.items()}
 changed=sorted(k for k in modules if modules[k]!=v.modules[k])
 rt,_=order(runtime_for(v,v,v,modules));rt=re.sub(r'\n{3,}','\n\n',rt)
 for token in ['Inventory94','FFL94','Inventory05','Load04_','Idle76_','Preview75','FFL_AutoTimer']:
  assert token not in rt,token
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(rt)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j');bliz=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(bliz),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-2500:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 final=MPQ(str(out))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert final.read(n)==files.get(n,v.archive.read(n)),n
 before,after=functions(v.runtime),functions(rt)
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_modules=changed,changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),new_functions=sorted(after.keys()-before.keys()),unchanged_resources='All objects, models, imports, quests and other archive entries byte-identical.',acceptance='Native ownership routing, shared cinematic gates, f capture path autosave scheduler. Native/multiplayer behavior unverified.'),indent=2));print(out)

if __name__=='__main__':
 build_selected(ROOT/'release/development/GRecovery05/FFERPG-0.9.7.5g-Recovery05.w3x',ROOT/'release/development/GRecovery06/FFERPG-0.9.7.5g-Recovery06.w3x','FFERPG 0.9.7.5g Recovery06')
 build_selected(ROOT/'release/development/GRecovery05/FFERPG-0.9.7.5g-1.29.2-Recovery05.w3x',ROOT/'release/development/GRecovery06/FFERPG-0.9.7.5g-1.29.2-Recovery06.w3x','FFERPG 0.9.7.5g Recovery06 1.29.2',True)
 build_selected(ROOT/'release/development/V16/FFERPG-V16.w3x',ROOT/'release/development/V17/FFERPG-V17.w3x','FFERPG V17')
