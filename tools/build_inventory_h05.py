"""Paired H05/V9: shared presentation snapshots; V9 creature visual corrections."""
from build_forest86 import *
from wct import read_wct
from inventory_snap_h05 import refresh,GLOBALS,HELPERS
import struct

def creature(s):
 f=functions(s)
 if 'D7_BadgeFrames' in f:
  b=f['D7_BadgeFrames'];b=b.replace('FRAMEPOINT_BOTTOMLEFT,D7BadgeBuffBar,FRAMEPOINT_TOPLEFT,0.,.003','FRAMEPOINT_TOPLEFT,D7BadgeBuffBar,FRAMEPOINT_BOTTOMRIGHT,.003,.018');b=b.replace('FRAMEPOINT_BOTTOMLEFT,.255,.07','FRAMEPOINT_TOPLEFT,.32,.035');s=put(s,'D7_BadgeFrames',b)
 return s

def build(base,out,label,dev=False):
 assert not out.exists()
 m=MPQ(str(base));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(old)
 runtime=runtime.replace('endglobals',GLOBALS+'endglobals',1)
 f=functions(runtime);runtime=put(runtime,'Load04_Resume',f['Load04_Resume']+'\n'+HELPERS)
 if dev:runtime=creature(runtime)
 wct=read_wct(m.read('war3map.wct'))
 header=refresh(text_of(wct['header']).replace('\r\n','\n'));header=header.replace('endglobals',GLOBALS+'endglobals',1);f=functions(header);header=put(header,'Load04_Resume',f['Load04_Resume']+'\n'+HELPERS);wct['header']=raw_of(header.replace('\n','\r\n'))
 for i,raw in enumerate(wct['entries']):
  source=text_of(raw).replace('\r\n','\n');updated=refresh(source)
  if dev:updated=creature(updated)
  if updated!=source:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 if dev:
  # Keep the accepted mesh; omit the remaining emitter/trail component.
  data=m.read(r'war3mapImported\DarkSwarmBreathV7.mdx');model=bytearray(data[:4]);i=4;removed=[]
  while i<len(data):
   n=struct.unpack_from('<I',data,i+4)[0];tag=data[i:i+4]
   if tag not in [b'PRE2',b'RIBB']:model+=data[i:i+8+n]
   else:removed.append(tag.decode())
   i+=8+n
  assert i==len(data) and removed==['PRE2']
  files[r'war3mapImported\DarkSwarmBreathV7.mdx']=bytes(model)
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-2500:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 new=MPQ(str(out))
 for file in m.read('(listfile)').decode().splitlines():
  if file.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(file)==files.get(file,m.read(file)),file
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_resources=list(files),new_polling_timers=0,acceptance='Hotfix04 failed multiplayer after backpack drop. H05/V9 synchronized presentation snapshot candidate; cause/fix unconfirmed. V9 native visual placement pending.'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/development/VersionHHotfix04/FFERPG-0.9.7.5h-Hotfix04.w3x',ROOT/'release/development/VersionHHotfix05/FFERPG-0.9.7.5h-Hotfix05.w3x','FFERPG 0.9.7.5h Hotfix05')
 build(ROOT/'release/development/V8/FFERPG-V8.w3x',ROOT/'release/development/V9/FFERPG-V9.w3x','FFERPG V9',True)
