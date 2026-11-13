"""One-function visibility change on the working selective recovery baseline."""
from build_forest86 import *
from wct import read_wct
from talent_flash_recovery02 import refresh

def build(base,out,label):
 assert not out.exists()
 m=MPQ(str(base));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(old)
 a,b=functions(old),functions(runtime);assert a.keys()==b.keys();assert {n for n in a if tokens(a[n])!=tokens(b[n])}=={'Inventory94_ClearLocal'}
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(refresh(text_of(wct['header']).replace('\r\n','\n')))
 for i,raw in enumerate(wct['entries']):
  source=text_of(raw).replace('\r\n','\n');updated=refresh(source)
  if updated!=source:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1000:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 new=MPQ(str(out))
 for name in m.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(name)==files.get(name,m.read(name)),name
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=['Inventory94_ClearLocal'],added_functions=[],new_polling_timers=0,scope='Only four talent/X hide conditions and panel-open reset are now cinematic-only. Existing input cleanup/other UI/owner guard/timing untouched.',archive_readback='Only runtime/editor source changed. All objects/assets and all other functions match baseline.',acceptance='Owner reports Recovery01 working. This visibility-only candidate has no live multiplayer confirmation.'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/development/GRecovery01/FFERPG-0.9.7.5g-Recovery01.w3x',ROOT/'release/development/GRecovery02/FFERPG-0.9.7.5g-Recovery02.w3x','FFERPG 0.9.7.5g Recovery02')
 build(ROOT/'release/development/V11/FFERPG-V11.w3x',ROOT/'release/development/V12/FFERPG-V12.w3x','FFERPG V12')
