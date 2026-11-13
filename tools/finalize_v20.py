"""Finalize capture pacing and order-only equipment routing; no format changes."""
from build_f1030_inventory_rollback import *
from cinematic_v20 import refresh
paths=[ROOT/'release/development/V20/FFERPG-V20.w3x',ROOT/'release/development/GRecovery09/FFERPG-0.9.7.5g-Recovery09.w3x',ROOT/'release/development/GRecovery09/FFERPG-0.9.7.5g-1.29.2-Recovery09.w3x']
for path in paths:
 v=view(str(path));modules=dict(v.modules);runtime=v.runtime
 report=json.loads(path.with_suffix('.json').read_text());base=view(report['base'])
 for lib,source in base.modules.items():
  desired=refresh(lib,source,'1.29.2' in path.name)
  if desired==source:continue
  current=functions(modules[lib])
  for n,body in functions(desired).items():
   if n in current and tokens(current[n])!=tokens(body):
    modules[lib]=put(modules[lib],n,body);runtime=put(runtime,n,body)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in modules and modules[m[1]]!=v.modules[m[1]]:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 old=path.parent/'history-before-final-command-admission-retry'/path.name;old.parent.mkdir(exist_ok=True);assert not old.exists();path.rename(old)
 tmp=path.with_suffix('.command-final-unpacked.w3x');write_files(str(old),str(tmp),files);compact(str(tmp),str(path))
 original=old.read_bytes();d=path.read_bytes();path.write_bytes(original[:original.index(b'MPQ\x1a')]+d[d.index(b'MPQ\x1a'):])
 out=MPQ(str(path))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert out.read(n)==files.get(n,v.archive.read(n)),n
 path.with_suffix('.j').write_text(runtime)
 report=json.loads(path.with_suffix('.json').read_text());report['sha256']=hashlib.sha256(path.read_bytes()).hexdigest();report['finalization']='Autosave capture 10Hz only while active. Order events only route item transfers and do not rescan/reapply worn abilities.';path.with_suffix('.json').write_text(json.dumps(report,indent=2));print(path.name,report['sha256'])
