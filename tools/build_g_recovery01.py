"""g baseline + only owner-retained autosave and teleporter fixes; no H inventory layers."""
from build_forest86 import *
from wct import read_wct
from autosave_h02 import refresh as autosave
from autosave_twenty import refresh as timing
from travel_h02 import refresh as travel
AUTO={'FFL_TryAutosave','FFL_Autosave','FFL_Tick','InitTrig_ForsakenFreshLoad','Save_InitCommands','Save_Autosave','Trig_Game_Start_Actions','Trig_Game_Start_AddPlayerToForces','Trig_Autosave_Command_Actions'}
ADDED={'FFL_AutoSchedule','FFL_AutoStart','FFL_BeginAutosave','FFL_QueueAutosave'}

def patch(s,classic=False):return timing(autosave(travel(s),classic))

def build(base,out,label,classic=False):
 assert not out.exists()
 m=MPQ(str(base));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=patch(old,classic)
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(patch(text_of(wct['header']).replace('\r\n','\n'),classic))
 for i,raw in enumerate(wct['entries']):
  source=text_of(raw).replace('\r\n','\n');updated=patch(source,classic)
  if updated!=source:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 a,b=functions(old),functions(runtime);changed={n for n in a if tokens(a[n])!=tokens(b[n])};allowed=AUTO|({'TravelPanel_Render','TravelPanel_Init'} if 'TravelPanel_Render' in a else set())
 assert changed==allowed,(changed-allowed,allowed-changed)
 assert b.keys()-a.keys()==ADDED
 for n in ['Inventory05','InventoryH03','Load04_','Load04ResumeUntil','Forsaken_KeepInventoryFrames','Inventory94_ClearAim']:assert n not in runtime,n
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j');blizzard=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(blizzard),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1700:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 new=MPQ(str(out))
 for name in m.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(name)==files.get(name,m.read(name)),name
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=sorted(changed),added_functions=sorted(ADDED),inventory='All existing inventory, hotkey, preview, job/load/stat/UI functions match baseline exactly. H inventory changes excluded.',retained='Maiden Eye hidden command already present in baseline objects; accepted teleporter layout and default-on autosave20/10 restored.',archive_readback='Only playable/editor scripts changed; all objects/assets/arena/dev content preserved.',acceptance='Owner reports these retained fixes worked. This combination has no new live multiplayer verification.'),indent=2));print(out)
if __name__=='__main__':
 directory=ROOT/'release/development/GRecovery01'
 for classic in [False,True]:
  suffix='-1.29.2' if classic else ''
  build(ROOT/'release/0.9.7.5g'/('FFERPG-0.9.7.5g'+suffix+'.w3x'),directory/('FFERPG-0.9.7.5g'+suffix+'-Recovery01.w3x'),'FFERPG 0.9.7.5g Recovery01'+(' 1.29.2' if classic else ''),classic)
 build(ROOT/'release/development/V10/FFERPG-V10.w3x',ROOT/'release/development/V11/FFERPG-V11.w3x','FFERPG V11')
