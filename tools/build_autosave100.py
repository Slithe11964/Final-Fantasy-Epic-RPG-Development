"""Production g autosave hotfix, modern and 1.29.2, without development content."""
from build_forest86 import *
from wct import read_wct
from autosave100 import refresh
ROOT=Path(__file__).resolve().parents[1]
DIR=ROOT/'release/development/VersionGHotfix02'
SOURCE_DIR=ROOT/'release/0.9.7.5g/history/2026-11-05-before-autosave'
if not SOURCE_DIR.exists():SOURCE_DIR=ROOT/'release/0.9.7.5g'
def build(classic=False):
 name='FFERPG-0.9.7.5g'+('-1.29.2' if classic else '')
 base=SOURCE_DIR/(name+'.w3x')
 out=DIR/(name+'-Hotfix02.w3x');assert not out.exists()
 m=MPQ(str(base));original=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(original,classic)
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(refresh(text_of(wct['header']).replace('\r\n','\n'),classic))
 for i,raw in enumerate(wct['entries']):
  s=text_of(raw).replace('\r\n','\n');new=refresh(s,classic)
  if new!=s:wct['entries'][i]=raw_of(new.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 DIR.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j')
 blizzard=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(blizzard),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1500:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
 a=MPQ(str(out))
 for file in m.read('(listfile)').decode().splitlines():
  if file.lower() not in ['(listfile)','(attributes)','(signature)']:assert a.read(file)==files.get(file,m.read(file)),file
 old,new=functions(original),functions(runtime)
 changed=sorted(n for n in old if tokens(old[n])!=tokens(new[n]));added=sorted(set(new)-set(old))
 assert set(changed)=={'FFL_Autosave','FFL_Guard','FFL_CloseWindow','InitTrig_ForsakenFreshLoad'}|({'Forsaken_PrepareInventories'} if not classic else set()),changed
 assert added==['FFL_RetryAutosaves','FFL_TryAutosave'],added
 assert not set(old)-set(new)
 for n in ['Save_Autosave','Save_InitCommands','FST_Write','FST_ReadFile','FRC_StartNow']:
  assert tokens(old[n])==tokens(new[n]),n
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,new_functions=added,interval='Original60second round-robin over10slots: each player every10minutes after15minute initial load window.',file='Existing FFERPG/autosave.txt, overwritten with latest validated full profile.',save_format='unchanged',archive_readback='PASS',live_test='pending'),indent=2));print(out)
if __name__=='__main__':
 build();build(True)
