"""Modern + classic production h autosave reliability candidate."""
from build_forest86 import *
from wct import read_wct
from autosave_h02 import refresh
from backpack_b_h02 import refresh as restore_b
from travel_h02 import refresh as travel_refresh
DIR=ROOT/'release/development/VersionHHotfix02'
BACKUP=ROOT/'release/0.9.7.5h/history/2026-11-06-before-autosave-h02'
SOURCE=BACKUP if BACKUP.exists() else ROOT/'release/0.9.7.5h'
def build(classic=False):
 name='FFERPG-0.9.7.5h'+('-1.29.2' if classic else '')
 base=SOURCE/(name+'.w3x');out=DIR/(name+'-Hotfix02.w3x');assert not out.exists()
 m=MPQ(str(base));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(travel_refresh(restore_b(old)),classic)
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(refresh(travel_refresh(restore_b(text_of(wct['header']).replace('\r\n','\n'))),classic))
 for i,raw in enumerate(wct['entries']):
  source=text_of(raw).replace('\r\n','\n');updated=refresh(travel_refresh(restore_b(source)),classic)
  if updated!=source:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 DIR.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j');bliz=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(bliz),str(out.with_suffix('.j'))],capture_output=True,text=True);print(result.stdout[-1500:],result.stderr);assert result.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
 _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header('FFERPG 0.9.7.5h Hotfix02'+(' 1.29.2' if classic else ''),flags,players)+data[data.index(b'MPQ\x1a'):]);new=MPQ(str(out))
 for file in m.read('(listfile)').decode().splitlines():
  if file.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(file)==files.get(file,m.read(file)),file
 oldf,newf=functions(old),functions(runtime);changed=sorted(n for n in oldf if tokens(oldf[n])!=tokens(newf[n]));added=sorted(set(newf)-set(oldf))
 assert set(changed)=={'FFL_TryAutosave','FFL_Autosave','FFL_Tick','InitTrig_ForsakenFreshLoad','Save_InitCommands','Save_Autosave','Trig_Game_Start_Actions','Trig_Game_Start_AddPlayerToForces','Trig_Autosave_Command_Actions'}| (set() if classic else {'Forsaken_BackpackVisible','UI72_Tick','Forsaken_InventoryContext','Forsaken_CloseBackpack','Forsaken_PanelAccess','Forsaken_BackpackToggleAction','Forsaken_PanelClick','Forsaken_CreateInspection','Register_Forsaken_PanelAccess','Forsaken_DrawPanels','Forsaken_PollPanels','Forsaken_RenderInspection','Forsaken_BackpackAccess','Forsaken_RequestBackpackToggle','Forsaken_RebuildPanels','TravelPanel_Render','TravelPanel_Init'}),changed
 assert set(added)=={'FFL_AutoSchedule','FFL_AutoStart','FFL_BeginAutosave','FFL_QueueAutosave'}|(set() if classic else {'Forsaken_KeepInventoryFrames'}),added
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,new_functions=added,interval='First schedule 600s after match start; all enabled players queued every600s, at most one capture per retry second.',default='ON; only explicit -autosave off opts out. Bare -autosave reports status; -autosave now queues an immediate test.',save_format='unchanged',archive_readback='PASS',native_test='pending'),indent=2));print(out)
if __name__=='__main__':build();build(True)
