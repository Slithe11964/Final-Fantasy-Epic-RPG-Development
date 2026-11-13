import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_autosave_h02 import DIR,SOURCE
from mpq import MPQ
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
class AutosaveH02Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.maps=[]
  for suffix in ['', '-1.29.2']:
   name='FFERPG-0.9.7.5h'+suffix;old=MPQ(str(SOURCE/(name+'.w3x')));new=MPQ(str(DIR/(name+'-Hotfix02.w3x')));c.maps.append((old,new,functions(new.read('war3map.j').decode().replace('\r\n','\n'))))
 def setup_scheduler(self,extra_names=()):
  f=self.maps[0][2];names=['FFL_TryAutosave','FFL_RetryAutosaves','FFL_QueueAutosave','FFL_AutoStart','FFL_AutoSchedule','FFL_Autosave']+list(extra_names);s='\n'.join(f[n] for n in names);starts=[];timers=[];paused=[];stems=[];now=[0.]
  e=mocks(s);e.update(FFL_AutoTimer=60,FFL_AutoStarted=False,FFL_AutoOptOut=defaultdict(bool),FFL_AutoInFlight=defaultdict(bool),FFL_AutoRetryAfter=defaultdict(float),FFL_AutoPending=defaultdict(bool),FFL_AutoRetryCursor=0,FFL_AutoRetryTimer=50,FFL_AutoRetryActive=False,Save_AutosavePid=0,udg_GameRunning=True,udg_HardcoreOff=True,Inventory94Paused=False,InventoryCinematicActive=False,udg_InCinematicMode=False,udg_PlayingPlayers=set(range(8)),udg_AutosaveForce=set(),FFL_Phase=defaultdict(int),FFP_Locked=defaultdict(bool),FRC_Phase=defaultdict(int),FSC_Writing=defaultdict(bool),FSC_Busy=defaultdict(bool),FST_Pending=defaultdict(bool),udg_PlayerHero=defaultdict(lambda:1),udg_SpiritOfGaya=defaultdict(lambda:2),udg_PlayerHouse=defaultdict(lambda:3),FSC_PlayerValid=lambda p:0<=p<8,Player=lambda p:p,IsPlayerInForce=lambda p,f:p in f,BlzUnitExtendedInventorySize=lambda u:30,FST_SetFileStem=lambda pid,stem:(stems.append((pid,stem)) or True),FFL_BeginSave=lambda *a:(starts.append(a) or True),ModuloInteger=lambda a,b:a%b,TimerStart=lambda *a:timers.append(a),PauseTimer=lambda t:paused.append(t),FST_Clock=1,TimerGetElapsed=lambda t:now[0])
  e['FFL_BeginAutosave']=lambda pid:(starts.append((pid,True,True)) or True)
  return execute(s,names,e),starts,timers,paused,stems,now
 def test_timer_enabled_and_bound_before_match_start_without_loading_window(self):
  for _,_,f in self.maps:
   b=f['Save_InitCommands'];self.assertNotIn('DisableTrigger(udg_AutosaveTimerTrig)',b);self.assertIn('TriggerRegisterTimerExpireEvent(udg_AutosaveTimerTrig,FFL_AutoTimer)',b);self.assertIn('ExecuteFunc("FFL_AutoStart")',f['Trig_Game_Start_Actions'])
   self.assertIn('FFL_AutoOptOut[pid]=false',f['InitTrig_ForsakenFreshLoad']);self.assertIn('Collection_ForceAddPlayerSimple(Player(pid),udg_AutosaveForce)',f['InitTrig_ForsakenFreshLoad'])
  e,starts,timers,*_=self.setup_scheduler();e['FFL_AutoStart']();e['FFL_AutoStart']();self.assertEqual([(a[0],a[1],a[2]) for a in timers],[(60,600.,True)])
 def test_all_eight_players_export_queued_every_ten_minutes(self):
  e,starts,timers,paused,stems,now=self.setup_scheduler();e['FFL_AutoStart']();exports=[]
  for due in [600.,1200.,1800.]:
   now[0]=due;e['FFL_AutoSchedule']()
   for offset in range(1,10):
    now[0]=due+offset;before=len(starts);e['FFL_RetryAutosaves']();self.assertLessEqual(len(starts)-before,1)
    if len(starts)>before:exports.append((now[0],starts[-1][0]))
  for pid in range(8):self.assertEqual([t for t,p in exports if p==pid],[601.+pid,1201.+pid,1801.+pid])
  self.assertTrue(all(stem=='autosave' for _,stem in stems));self.assertEqual(len(starts),24);self.assertFalse(e['FFL_AutoRetryActive'])
 def test_bare_command_status_never_disables_and_only_explicit_off_opts_out(self):
  f=self.maps[0][2];s=f['Trig_Autosave_Command_Actions'];command=['-autosave'];force={0};messages=[];e=mocks(s)
  e.update(GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:0,GetEventPlayerChatString=lambda:command[0],StringCase=lambda s,upper:s.upper() if upper else s.lower(),FFL_AutoOptOut=defaultdict(bool),FFL_AutoPending=defaultdict(bool),udg_AutosaveForce=force,udg_HardcoreOff=True,Collection_ForceRemovePlayerSimple=lambda p,f:f.discard(p),Collection_ForceAddPlayerSimple=lambda p,f:f.add(p),DisplayTimedTextToPlayer=lambda *a:messages.append(a[-1]))
  e['ForceRemovePlayerSimple']=lambda p,f:f.discard(p)
  e['ForceAddPlayerSimple']=lambda p,f:f.add(p)
  e=execute(s,['Trig_Autosave_Command_Actions'],e)
  for _ in range(3):e['Trig_Autosave_Command_Actions']()
  self.assertFalse(e['FFL_AutoOptOut'][0]);self.assertIn(0,force)
  command[0]='-autosave off';e['Trig_Autosave_Command_Actions']();self.assertTrue(e['FFL_AutoOptOut'][0]);self.assertNotIn(0,force)
  command[0]='-autosave';e['Trig_Autosave_Command_Actions']();self.assertTrue(e['FFL_AutoOptOut'][0])
  command[0]='-autosave on';e['Trig_Autosave_Command_Actions']();self.assertFalse(e['FFL_AutoOptOut'][0]);self.assertIn(0,force)
 def test_off_before_match_start_is_not_overridden(self):
  b=self.maps[0][2]['Trig_Game_Start_AddPlayerToForces'];adds=[];e=mocks(b);e.update(GetEnumPlayer=lambda:0,GetPlayerId=lambda p:p,FFL_AutoOptOut=defaultdict(bool,{0:True}),udg_AutosaveForce='autosave',udg_AbilityTextForce='text',udg_TrackedPlayers='tracked',ForceAddPlayerSimple=lambda p,f:adds.append(f),Collection_ForceAddPlayerSimple=lambda p,f:adds.append(f));e=execute(b,['Trig_Game_Start_AddPlayerToForces'],e);e['Trig_Game_Start_AddPlayerToForces']();self.assertEqual(adds,['text','tracked'])
 def test_busy_or_missing_character_is_deferred_then_retried(self):
  for field in ['FFL_Phase','FFP_Locked','FRC_Phase','FSC_Writing','FSC_Busy','FST_Pending','udg_InCinematicMode','Inventory94Paused','nohero']:
   e,starts,timers,paused,stems,now=self.setup_scheduler()
   if field=='nohero':e['udg_PlayerHero'][1]=None
   elif field in ['udg_InCinematicMode','Inventory94Paused']:e[field]=True
   else:e[field][0]=1
   e['FFL_Autosave']();e['FFL_RetryAutosaves']();self.assertFalse(starts,field);self.assertTrue(e['FFL_AutoPending'][0])
   if field=='nohero':e['udg_PlayerHero'][1]=1
   elif field in ['udg_InCinematicMode','Inventory94Paused']:e[field]=False
   else:e[field][0]=0
   e['FFL_RetryAutosaves']();self.assertEqual(starts,[(0,True,True)],field);self.assertFalse(e['FFL_AutoPending'][0]);self.assertTrue(e['FFL_AutoInFlight'][0])
 def test_failed_capture_start_remains_pending_and_backs_off(self):
  e,starts,timers,paused,stems,now=self.setup_scheduler();attempts=[];ok=[False];e['FFL_BeginAutosave']=lambda *a:(attempts.append(a) or ok[0])
  e['FFL_Autosave']();e['FFL_RetryAutosaves']();self.assertTrue(e['FFL_AutoPending'][0]);self.assertFalse(e['FFL_AutoInFlight'][0]);self.assertEqual(e['FFL_AutoRetryAfter'][0],30.)
  now[0]=29.;e['FFL_RetryAutosaves']();self.assertEqual(len(attempts),1)
  ok[0]=True;now[0]=30.;e['FFL_RetryAutosaves']();self.assertEqual(len(attempts),2);self.assertFalse(e['FFL_AutoPending'][0]);self.assertTrue(e['FFL_AutoInFlight'][0])
 def test_asynchronous_capture_or_export_failure_is_not_discarded(self):
  for ready,writes_ok in [(False,True),(True,False),(True,True)]:
   e,starts,timers,paused,stems,now=self.setup_scheduler(['FFL_Tick']);writes=[]
   e.update(FRC_Ready=defaultdict(bool,{0:ready}),FFL_SaveFile=defaultdict(bool,{0:True}),FST_LegacySaveMessages=defaultdict(lambda:True),FRC_Result=defaultdict(lambda:'code'),FRC_Account=lambda p:123,FRC_Error=defaultdict(str),FSC_Error=defaultdict(str),FSS_Concat=lambda a,b:a+b,FST_Write=lambda *a:(writes.append(a) or writes_ok))
   e['FFL_Phase'][0]=1;e['FFL_AutoInFlight'][0]=True;e['FFL_Tick']()
   self.assertFalse(e['FFL_AutoInFlight'][0]);self.assertEqual(e['FFL_AutoPending'][0],not (ready and writes_ok))
   self.assertEqual(len(writes),1 if ready else 0)
   if not (ready and writes_ok):self.assertEqual(e['FFL_AutoRetryAfter'][0],30.)
 def test_optout_and_departed_players_are_not_queued(self):
  e,starts,*_=self.setup_scheduler();e['FFL_AutoOptOut'][1]=True;e['udg_PlayingPlayers'].remove(7);e['FFL_AutoSchedule']();self.assertFalse(e['FFL_AutoPending'][1]);self.assertFalse(e['FFL_AutoPending'][7]);self.assertTrue(e['FFL_AutoPending'][0])
 def test_writer_capture_and_ui_fixes_preserved(self):
  for old,new,f in self.maps:
   before=functions(old.read('war3map.j').decode().replace('\r\n','\n'))
   for n in before:
    if n.startswith(('FRC_','FSC_','FST_','Load_','Trig_Cmd_Load_Code_','Inventory94_','QuickGear_')):self.assertEqual(tokens(before[n]),tokens(f[n]),n)
   for ext in ['w3a','w3u','w3t','w3q','w3h']:self.assertEqual(old.read('war3map.'+ext),new.read('war3map.'+ext))
   self.assertIn('PreloadGenEnd(FST_PlayerPath(pid,page))',f['FST_Write'])
 def test_actual_export_path_is_autosave_txt_owner_only(self):
  f=self.maps[0][2];s=f['FST_PlayerPath']+'\n'+f['FST_Write'];encoded='Gsample-code-contents';written=[];local=[0];names=defaultdict(lambda:'PlayerName');e=mocks(s)
  e.update(FST_FileStem=defaultdict(lambda:'autosave'),FSS_Equals=lambda a,b:a==b,FSS_Concat=lambda a,b:str(a)+str(b),FSS_Length=len,FSS_SubString=lambda s,a,b:s[a:b],I2S=str,FSC_PlayerValid=lambda p:0<=p<8,FST_Pending=defaultdict(bool),FST_LIMIT=100000,FSC_Decode=lambda *a:True,FST_TextChecksum=lambda s:123,FST_PAGE=1000,FST_CHUNK=100,FST_Fixed=lambda v,n:str(v).zfill(n),Player=lambda p:p,GetLocalPlayer=lambda:local[0],FST_LegacySaveMessages=defaultdict(lambda:True),GetPlayerName=lambda p:names[p],SetPlayerName=lambda p,n:names.__setitem__(p,n),FST_ReadFile=lambda p:encoded,FST_LocalCheck=defaultdict(lambda:123),PreloadGenEnd=lambda p:written.append(p))
  e=execute(s,['FST_PlayerPath','FST_Write'],e);self.assertTrue(e['FST_Write'](0,encoded,1));self.assertEqual(written,[r'.\FFERPG\autosave.txt']);written.clear();local[0]=1;self.assertTrue(e['FST_Write'](0,encoded,1));self.assertFalse(written)
 def test_autosave_uses_staged_capture_and_immediate_test_command_queues(self):
  for _,_,f in self.maps:
   self.assertIn('if FRC_Start(pid) then',f['FFL_BeginAutosave']);self.assertNotIn('FRC_StartNow',f['FFL_BeginAutosave']);self.assertIn('command=="-autosave now"',f['Trig_Autosave_Command_Actions'])
  f=self.maps[0][2];s=f['FFL_BeginAutosave'];e=mocks(s);starts=[]
  e.update(FRC_Start=lambda pid:(starts.append(pid) or True),FFL_SaveFile=defaultdict(bool),FST_LegacySaveMessages=defaultdict(bool),FFL_Phase=defaultdict(int));e=execute(s,['FFL_BeginAutosave'],e)
  self.assertTrue(e['FFL_BeginAutosave'](0));self.assertEqual(starts,[0]);self.assertEqual(e['FFL_Phase'][0],1);self.assertTrue(e['FFL_SaveFile'][0])
  e['FRC_Start']=lambda pid:False;self.assertFalse(e['FFL_BeginAutosave'](1));self.assertEqual(e['FFL_Phase'][1],0)
if __name__=='__main__':unittest.main()
