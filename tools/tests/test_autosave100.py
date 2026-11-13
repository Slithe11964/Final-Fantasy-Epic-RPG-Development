import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_autosave100 import ROOT,DIR,SOURCE_DIR
from mpq import MPQ
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
class Autosave100Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.maps=[]
  for classic in [False,True]:
   name='FFERPG-0.9.7.5g'+('-1.29.2' if classic else '')
   old=MPQ(str(SOURCE_DIR/(name+'.w3x')));new=MPQ(str(DIR/(name+'-Hotfix02.w3x')))
   c.maps.append((old,new,functions(new.read('war3map.j').decode().replace('\r\n','\n'))))
 def setup_retry(self):
  f=self.maps[0][2];names=['FFL_TryAutosave','FFL_RetryAutosaves','FFL_Autosave'];s='\n'.join(f[n] for n in names);starts=[];timers=[];paused=[];stems=[]
  e=mocks(s);e.update(FFL_AutoPending=defaultdict(bool),FFL_AutoRetryCursor=0,FFL_AutoRetryTimer=50,FFL_AutoRetryActive=False,Save_AutosavePid=0,udg_HardcoreOff=True,Inventory94Paused=False,udg_InCinematicMode=False,udg_PlayingPlayers=set(range(8)),udg_AutosaveForce=set(range(8)),FFL_Phase=defaultdict(int),FFP_Locked=defaultdict(bool),FRC_Phase=defaultdict(int),FSC_Writing=defaultdict(bool),FSC_Busy=defaultdict(bool),FST_Pending=defaultdict(bool),udg_PlayerHero=defaultdict(lambda:1),udg_SpiritOfGaya=defaultdict(lambda:2),udg_PlayerHouse=defaultdict(lambda:3),FSC_PlayerValid=lambda p:0<=p<8,Player=lambda p:p,IsPlayerInForce=lambda p,f:p in f,BlzUnitExtendedInventorySize=lambda u:30,FST_SetFileStem=lambda pid,stem:(stems.append((pid,stem)) or True),FFL_BeginSave=lambda *a:(starts.append(a) or True),ModuloInteger=lambda a,b:a%b,TimerStart=lambda *a:timers.append(a),PauseTimer=lambda t:paused.append(t))
  return execute(s,names,e),starts,timers,paused,stems
 def test_inventory_setup_retains_autosave_action(self):
  s=self.maps[0][2]['Forsaken_PrepareInventories'];cleared=[];e=mocks(s)
  e.update(Forsaken_SaveUnavailable=lambda:None,Inventory94Paused=False,ForsakenSaveBlocked=False,udg_SaveCommandTrig=1,udg_SaveToFileTrig=2,udg_NewGamePlusTrig=3,udg_NewGameMinusTrig=4,udg_AutosaveTimerTrig=5,TriggerClearActions=lambda t:cleared.append(t),Player=lambda p:p,Player_GetHero=lambda p:p+10)
  e=execute(s,['Forsaken_PrepareInventories'],e);e['Forsaken_PrepareInventories']();self.assertEqual(cleared,[1,2,4]);self.assertTrue(e['ForsakenSaveBlocked']);self.assertNotIn(5,cleared)
 def test_original_round_robin_is_ten_minutes_per_player(self):
  for _,_,f in self.maps:
   calls=[];s=f['Save_Autosave'];e=mocks(s);e.update(udg_AutosaveNextPlayer=0,udg_AutosavePlayerCount=10,Save_UseNewAutosave=True,Save_AutosavePid=0,udg_PlayingPlayers=set(range(8)),udg_AutosaveForce=set(range(8)),Player=lambda p:p,IsPlayerInForce=lambda p,f:p in f)
   e=execute(s,['Save_Autosave'],e);e['ExecuteFunc']=lambda n:calls.append((minute,e['Save_AutosavePid']))
   for minute in range(30):e['Save_Autosave']()
   for pid in range(8):self.assertEqual([m for m,p in calls if p==pid],[pid,pid+10,pid+20])
   self.assertIn('TriggerRegisterTimerEvent(udg_AutosaveTimerTrig,60.,true)',f['Save_InitCommands'])
 def test_due_autosave_captures_current_full_profile_to_autosave_file(self):
  e,starts,timers,paused,stems=self.setup_retry();e['Save_AutosavePid']=7;e['FFL_Autosave']();self.assertEqual(starts,[(7,True,True)]);self.assertEqual(stems,[(7,'autosave')]);self.assertFalse(timers)
 def test_busy_load_capture_file_and_cinematic_defer_without_profile_reads(self):
  for field in ['FFL_Phase','FFP_Locked','FRC_Phase','FSC_Writing','FSC_Busy','FST_Pending','udg_InCinematicMode','Inventory94Paused']:
   e,starts,timers,paused,stems=self.setup_retry()
   if field in ['udg_InCinematicMode','Inventory94Paused']:e[field]=True
   else:e[field][0]=1
   e['FFL_Autosave']();self.assertFalse(starts,field);self.assertFalse(stems,field);self.assertTrue(e['FFL_AutoPending'][0],field);self.assertEqual(len(timers),1);self.assertEqual(timers[0][1:3],(1.,True))
 def test_deferred_save_retries_after_scene_then_retry_timer_pauses(self):
  e,starts,timers,paused,stems=self.setup_retry();e['udg_InCinematicMode']=True;e['FFL_Autosave']();e['FFL_Autosave']();self.assertEqual(len(timers),1)
  e['FFL_RetryAutosaves']();self.assertFalse(starts);e['udg_InCinematicMode']=False;e['FFL_RetryAutosaves']();self.assertEqual(starts,[(0,True,True)]);self.assertFalse(e['FFL_AutoPending'][0]);e['FFL_RetryAutosaves']();self.assertEqual(paused,[50]);self.assertFalse(e['FFL_AutoRetryActive'])
 def test_retries_capture_at_most_one_player_per_second(self):
  e,starts,timers,paused,stems=self.setup_retry();e['FFL_AutoPending'][0]=True;e['FFL_AutoPending'][7]=True;e['FFL_RetryAutosaves']();self.assertEqual(len(starts),1);e['FFL_RetryAutosaves']();self.assertEqual([a[0] for a in starts],[0,7])
 def test_off_departed_hardcore_or_missing_character_never_overwrite(self):
  for mode in ['off','left','hardcore','nohero']:
   e,starts,timers,paused,stems=self.setup_retry()
   if mode=='off':e['udg_AutosaveForce'].clear()
   elif mode=='left':e['udg_PlayingPlayers'].clear()
   elif mode=='hardcore':e['udg_HardcoreOff']=False
   else:e['udg_PlayerHero'][1]=None
   e['FFL_Autosave']();self.assertFalse(starts,mode);self.assertFalse(stems,mode);self.assertFalse(timers,mode)
 def test_closing_initial_window_enables_the_restored_timer_only_when_saving_allowed(self):
  s=self.maps[0][2]['FFL_CloseWindow'];enabled=[];e=mocks(s);e.update(FFL_WindowOpen=True,udg_HardcoreOff=True,udg_AutosaveTimerTrig=5,EnableTrigger=lambda t:enabled.append(t));e=execute(s,['FFL_CloseWindow'],e);e['FFL_CloseWindow']();self.assertFalse(e['FFL_WindowOpen']);self.assertEqual(enabled,[5]);enabled.clear();e['udg_HardcoreOff']=False;e['FFL_CloseWindow']();self.assertFalse(enabled)
 def test_file_writer_is_unchanged_and_owner_local(self):
  for old,new,f in self.maps:
   before=functions(old.read('war3map.j').decode().replace('\r\n','\n'))
   for n in before:
    if n.startswith(('FRC_','FSC_','FST_','Save_','Load_','Trig_Cmd_Load_Code_')):self.assertEqual(tokens(before[n]),tokens(f[n]),n)
   self.assertEqual(old.read('war3map.w3t'),new.read('war3map.w3t'))
   self.assertIn('if (GetLocalPlayer() == Player(pid)) then',f['FST_Write']);self.assertIn('PreloadGenEnd(FST_PlayerPath(pid,page))',f['FST_Write']);self.assertIn('FST_ReadFile(pid)',f['FST_Write'])
 def test_actual_file_route_uses_autosave_txt_and_only_the_owning_client_writes(self):
  f=self.maps[0][2];s=f['FST_PlayerPath']+'\n'+f['FST_Write'];encoded='Gsample-code-contents';written=[];local=[0];names=defaultdict(lambda:'PlayerName');e=mocks(s)
  e.update(FST_FileStem=defaultdict(lambda:'autosave'),FSS_Equals=lambda a,b:a==b,FSS_Concat=lambda a,b:str(a)+str(b),FSS_Length=len,FSS_SubString=lambda s,a,b:s[a:b],I2S=str,FSC_PlayerValid=lambda p:0<=p<8,FST_Pending=defaultdict(bool),FST_LIMIT=100000,FSC_Decode=lambda *a:True,FST_TextChecksum=lambda s:123,FST_PAGE=1000,FST_CHUNK=100,FST_Fixed=lambda v,n:str(v).zfill(n),Player=lambda p:p,GetLocalPlayer=lambda:local[0],FST_LegacySaveMessages=defaultdict(lambda:True),GetPlayerName=lambda p:names[p],SetPlayerName=lambda p,n:names.__setitem__(p,n),FST_ReadFile=lambda p:encoded,FST_LocalCheck=defaultdict(lambda:123),PreloadGenEnd=lambda p:written.append(p))
  e=execute(s,['FST_PlayerPath','FST_Write'],e);self.assertTrue(e['FST_Write'](0,encoded,1));self.assertEqual(written,[r'.\FFERPG\autosave.txt']);written.clear();local[0]=1;self.assertTrue(e['FST_Write'](0,encoded,1));self.assertFalse(written)
 def test_scheduled_timer_is_not_disabled_by_loading_guard(self):
  for _,_,f in self.maps:
   self.assertNotIn('FFL_OneGuard(udg_AutosaveTimerTrig',f['FFL_Guard']);self.assertIn('set FFL_AutoRetryTimer=CreateTimer()',f['InitTrig_ForsakenFreshLoad']);self.assertNotIn('TimerStart(FFL_AutoRetryTimer',f['InitTrig_ForsakenFreshLoad'])
if __name__=='__main__':unittest.main()
