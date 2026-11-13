"""Promote tested H02 to production h with the requested20/10autosave schedule."""
from build_forest86 import *
from wct import read_wct
from autosave_twenty import refresh
DIR=ROOT/'release/development/VersionHFinal20'
def build(classic=False):
 suffix='-1.29.2' if classic else '';name='FFERPG-0.9.7.5h'+suffix
 base=ROOT/'release/development/VersionHHotfix02'/(name+'-Hotfix02.w3x');out=DIR/(name+'.w3x');assert not out.exists()
 m=MPQ(str(base));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(old)
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(refresh(text_of(wct['header']).replace('\r\n','\n')))
 for i,raw in enumerate(wct['entries']):
  s=text_of(raw).replace('\r\n','\n');updated=refresh(s)
  if updated!=s:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 DIR.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j');bliz=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(bliz),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1000:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header('FFERPG 0.9.7.5h'+(' 1.29.2' if classic else ''),flags,players)+data[data.index(b'MPQ\x1a'):])
 new=MPQ(str(out))
 for file in m.read('(listfile)').decode().splitlines():
  if file.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(file)==files.get(file,m.read(file)),file
 a,b=functions(old),functions(runtime);changed=sorted(n for n in a if tokens(a[n])!=tokens(b[n]));assert changed==['FFL_AutoSchedule','FFL_AutoStart','Trig_Autosave_Command_Actions'],changed
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),version='0.9.7.5h',changed_functions=changed,interval='20,30,40...minutes from match start; existing deferred staggered capture retained.',acceptance='Owner confirms H02 autosave and single-player tests work; multiplayer not yet tried. Timing change validated separately.',archive_readback='PASS'),indent=2));print(out)
if __name__=='__main__':build();build(True)
