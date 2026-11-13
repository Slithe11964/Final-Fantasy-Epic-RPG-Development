"""Place the three directly called UI helpers before their callers."""
from build_f1030_inventory_rollback import *
for folder,name in [('V23','FFERPG-V23'),('GRecovery12','FFERPG-0.9.7.5g-Recovery12')]:
 path=ROOT/'release/development'/folder/(name+'.w3x');v=view(str(path));rt=v.runtime;fs=functions(rt)
 names=['C23_PauseControls','C23_ResumeControls','C23_HidePreviewImages']
 for n in names:rt=rt.replace(fs[n],'',1)
 marker='function C20_HideUI takes';assert marker in rt
 rt=rt.replace(marker,'\n'.join(fs[n] for n in names)+'\n'+marker,1)
 assert {n:tokens(b) for n,b in functions(rt).items()}=={n:tokens(b) for n,b in fs.items()}
 files={'war3map.j':rt.replace('\n','\r\n').encode()}
 tmp=path.with_suffix('.ordered-unpacked.w3x');candidate=path.with_suffix('.ordered.w3x')
 write_files(str(path),str(tmp),files);compact(str(tmp),str(candidate))
 oldbytes=path.read_bytes();data=candidate.read_bytes();candidate.write_bytes(oldbytes[:oldbytes.index(b'MPQ\x1a')]+data[data.index(b'MPQ\x1a'):])
 result=MPQ(str(candidate))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert result.read(n)==files.get(n,v.archive.read(n)),n
 history=path.parent/'history-before-helper-order';history.mkdir(exist_ok=True)
 assert history.resolve().is_relative_to(ROOT.resolve()) and not (history/path.name).exists()
 path.rename(history/path.name);candidate.rename(path)
 path.with_suffix('.j').write_text(rt)
 meta=json.loads(path.with_suffix('.json').read_text());meta['sha256']=hashlib.sha256(path.read_bytes()).hexdigest();path.with_suffix('.json').write_text(json.dumps(meta,indent=2))
 print(path.name)
