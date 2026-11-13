"""Narrow normal-speed cinematic skip correction on the selective recovery."""
from build_forest86 import *
from wct import read_wct
from cinematic_text_recovery03 import refresh

def build(base,out,label,classic=False):
 assert not out.exists()
 m=MPQ(str(base));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(old)
 a,b=functions(old),functions(runtime);assert a.keys()==b.keys();allowed={'Cine_OnSkip'}|({'Inventory94_CineEnter'} if 'Inventory94_CineEnter' in a else set());assert {n for n in a if tokens(a[n])!=tokens(b[n])}==allowed
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(refresh(text_of(wct['header']).replace('\r\n','\n')))
 for i,raw in enumerate(wct['entries']):
  source=text_of(raw).replace('\r\n','\n');updated=refresh(source)
  if updated!=source:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j');bliz=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(bliz),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1200:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 new=MPQ(str(out))
 for name in m.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(name)==files.get(name,m.read(name)),name
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=sorted(allowed),new_functions=[],new_timers=0,scope='Remove scene-entry synthetic cancel where present; only process explicit skip events during active cinematics. Existing dialogue, timing, speed/vote, quest notifications and inventory cleanup unchanged.',acceptance='Candidate for normal-speed scenes immediately finishing without portrait/text; native root cause/visual/multiplayer confirmation pending.',archive_readback='Only JASS/editor source changed; all other resources preserved.'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/development/GRecovery02/FFERPG-0.9.7.5g-Recovery02.w3x',ROOT/'release/development/GRecovery03/FFERPG-0.9.7.5g-Recovery03.w3x','FFERPG 0.9.7.5g Recovery03')
 build(ROOT/'release/development/GRecovery01/FFERPG-0.9.7.5g-1.29.2-Recovery01.w3x',ROOT/'release/development/GRecovery03/FFERPG-0.9.7.5g-1.29.2-Recovery03.w3x','FFERPG 0.9.7.5g Recovery03 1.29.2',True)
 build(ROOT/'release/development/V13/FFERPG-V13.w3x',ROOT/'release/development/V14/FFERPG-V14.w3x','FFERPG V14')
