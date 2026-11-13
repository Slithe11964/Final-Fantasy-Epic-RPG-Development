"""Separate production/development load-isolation candidates; no release overwrite."""
from build_forest86 import *
from wct import read_wct
from load_quiet_h03 import refresh

def build(base,out,label):
 assert not out.exists()
 m=MPQ(str(base));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(old);assert runtime!=old
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(refresh(text_of(wct['header']).replace('\r\n','\n')))
 for i,raw in enumerate(wct['entries']):
  source=text_of(raw).replace('\r\n','\n');updated=refresh(source)
  if updated!=source:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1000:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 new=MPQ(str(out))
 for file in m.read('(listfile)').decode().splitlines():
  if file.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(file)==files.get(file,m.read(file)),file
 a,b=functions(old),functions(runtime);changed=sorted(n for n in a if tokens(a[n])!=tokens(b[n]));assert changed==['Inventory71_Reconcile','Inventory94_Blocked'],changed
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,new_functions=['InventoryH03_LoadBusy'],archive_readback='PASS; all objects/assets/gameplay/save codec retained',acceptance='Diagnostic candidate only. Report records network desync; root cause not established. Multiplayer reproduction pending.'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/0.9.7.5h/FFERPG-0.9.7.5h.w3x',ROOT/'release/development/VersionHHotfix03/FFERPG-0.9.7.5h-Hotfix03.w3x','FFERPG 0.9.7.5h Hotfix03')
 build(ROOT/'release/development/V3/FFERPG-V3.w3x',ROOT/'release/development/V4/FFERPG-V4.w3x','FFERPG V4')
