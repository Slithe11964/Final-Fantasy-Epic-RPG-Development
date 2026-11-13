"""Finalize exact baseline model/font paths in the new startup function."""
from build_f1030_inventory_rollback import *
from gear_frontend25 import refresh
for folder,name in [('V25','FFERPG-V25'),('GRecovery14','FFERPG-0.9.7.5g-Recovery14')]:
 path=ROOT/'release/development'/folder/(name+'.w3x');v=view(str(path));meta=json.loads(path.with_suffix('.json').read_text());base=view(meta['base'])
 desired=functions(refresh(base.modules['TEquip']))['QuickGear_Init'];source=put(v.modules['TEquip'],'QuickGear_Init',desired);rt=put(v.runtime,'QuickGear_Init',desired)
 for i,raw in enumerate(v.wct['entries']):
  if re.match(r'\s*library TEquip\b',text_of(raw)):v.wct['entries'][i]=raw_of(source.replace('\n','\r\n'))
 files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 tmp=path.with_suffix('.paths-unpacked.w3x');candidate=path.with_suffix('.paths.w3x')
 write_files(str(path),str(tmp),files);compact(str(tmp),str(candidate));old=path.read_bytes();d=candidate.read_bytes();candidate.write_bytes(old[:old.index(b'MPQ\x1a')]+d[d.index(b'MPQ\x1a'):])
 result=MPQ(str(candidate))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert result.read(n)==files.get(n,v.archive.read(n)),n
 history=path.parent/'history-before-path-finalization';history.mkdir(exist_ok=True);assert history.resolve().is_relative_to(ROOT.resolve()) and not (history/path.name).exists()
 path.rename(history/path.name);candidate.rename(path);path.with_suffix('.j').write_text(rt)
 meta['sha256']=hashlib.sha256(path.read_bytes()).hexdigest();path.with_suffix('.json').write_text(json.dumps(meta,indent=2));print(path.name)
