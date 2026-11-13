import sys,unittest,hashlib
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from mpq import MPQ
from jtok import functions,tokens
from test_shared_context import mocks
from test_armory_materia import execute
from confirmed_g_load_recovery04 import reference_functions,REF,CORE
ROOT=Path(__file__).resolve().parents[2]
class ConfirmedG(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.paths=[ROOT/'release/development/GRecovery04/FFERPG-0.9.7.5g-Recovery04.w3x',ROOT/'release/development/GRecovery04/FFERPG-0.9.7.5g-1.29.2-Recovery04.w3x',ROOT/'release/development/V15/FFERPG-V15.w3x'];c.maps=[MPQ(str(p)) for p in c.paths];c.fs=[functions(m.read('war3map.j').decode()) for m in c.maps]
 def env(self,viewer=0):
  f=self.fs[0];names=['FFL_OneGuard','FFL_AutoStart','FFL_AutoSchedule','FFL_QueueAutosave','FFL_TryAutosave','FFL_RetryAutosaves','FFL_BeginAutosave','Save_Autosave'];src='\n'.join(f[n] for n in names);e=mocks(src);timers=[];made=[];captures=[];enabled=[True];now=[0.]
  def create():made.append(100+len(made));return made[-1]
  e.update(FFL_AutoTimer=10,FFL_AutoStarted=False,FFL_AutoRepeating=False,FFL_AutoRetryTimer=None,FFL_AutoRetryActive=False,FFL_AutoRetryCursor=0,FFL_AutoPending=defaultdict(bool),FFL_AutoOptOut=defaultdict(bool),FFL_AutoRetryAfter=defaultdict(float),FFL_GuardEnabled=defaultdict(bool),udg_GameRunning=True,udg_HardcoreOff=True,udg_AutosaveTimerTrig=11,Inventory94Paused=False,udg_InCinematicMode=False,FFL_Phase=defaultdict(int),FFP_Locked=defaultdict(bool),FRC_Phase=defaultdict(int),FSC_Writing=defaultdict(bool),FSC_Busy=defaultdict(bool),FST_Pending=defaultdict(bool),FST_Clock=1,Save_AutosavePid=0,udg_PlayerHero=defaultdict(lambda:1),udg_SpiritOfGaya=defaultdict(lambda:2),udg_PlayerHouse=defaultdict(lambda:3),udg_PlayingPlayers=set(range(8)),FSC_PlayerValid=lambda p:0<=p<8,Player=lambda p:p,IsPlayerInForce=lambda p,f:p in f,GetLocalPlayer=lambda:viewer,BlzUnitExtendedInventorySize=lambda u:30,FST_SetFileStem=lambda *a:True,FFL_BeginSave=lambda *a:captures.append(a) or True,IsTriggerEnabled=lambda t:enabled[0],DisableTrigger=lambda t:enabled.__setitem__(0,False),EnableTrigger=lambda t:enabled.__setitem__(0,True),CreateTimer=create,TimerStart=lambda *a:timers.append(a),TimerGetElapsed=lambda t:now[0],PauseTimer=lambda t:None,ModuloInteger=lambda a,b:a%b)
  e=execute(src,names,e);e['ExecuteFunc']=lambda n:e[n]();return e,timers,made,captures,enabled,now
 def test_reference_is_the_owner_confirmed_file_and_all_loading_code_matches(self):
  self.assertEqual(hashlib.sha256((REF/'FFERPG-0.9.7.5g.w3x').read_bytes()).hexdigest(),'9ca78509bad9e88a436a8871a407567dd1b813bd40f6fdacf5428c87ab089844')
  for idx,f in enumerate(self.fs):
   ref=reference_functions(idx==1)
   for n in ref:
    if n.startswith(('FRC_','FSC_','FST_','FSS_','FFP_','Load_','Trig_Cmd_Load_Code_')) or (n.startswith('FFL_') and n!='FFL_Autosave') or n=='InitTrig_ForsakenFreshLoad':self.assertEqual(tokens(ref[n]),tokens(f[n]),n)
   self.assertIn('FFL_OneGuard(udg_AutosaveTimerTrig,',f['FFL_Guard']);self.assertNotIn('FFL_AutoInFlight','\n'.join(f.values()))
 def test_autosave_due_during_another_player_load_waits_and_resumes(self):
  e,t,m,c,gate,now=self.env();e['FFL_AutoStart']();self.assertEqual(t[-1][1:3],(1200.,False));self.assertIs(t[-1][3],e['Save_Autosave']);self.assertEqual(m,[])
  e['FFL_OneGuard'](11,2256,True);self.assertFalse(gate[0]);now[0]=1200.;t[0][3]();self.assertTrue(all(e['FFL_AutoPending'][p] for p in range(8)));self.assertEqual(len(m),1);self.assertEqual(t[1][1:3],(600.,True));self.assertIs(t[1][3],e['Save_Autosave'])
  e['FFL_RetryAutosaves']();self.assertFalse(c);self.assertTrue(e['FFL_AutoRetryActive'])
  e['FFL_OneGuard'](11,2256,False);self.assertTrue(gate[0])
  for i in range(8):
   before=len(c);e['FFL_RetryAutosaves']();self.assertEqual(len(c)-before,1)
  self.assertEqual(c,[(p,True,True) for p in range(8)])
 def test_first_20_then_10_minute_callback_survives_disabled_trigger(self):
  e,t,m,c,gate,now=self.env();e['FFL_AutoStart']();cb=t[-1][3];self.assertEqual(t[-1][1],1200.)
  for due in [1200.,1800.,2400.]:
   now[0]=due;cb();self.assertTrue(e['FFL_AutoRepeating']);self.assertIs(t[1][3],e['Save_Autosave'])
  self.assertEqual(sum(a[1]==600. for a in t),1);self.assertEqual(len(m),1)
 def test_autosave_uses_g_save_entry_and_honors_explicit_off_and_departures(self):
  e,t,m,c,gate,now=self.env();e['FFL_AutoOptOut'][2]=True;e['udg_PlayingPlayers'].remove(6);e['FFL_AutoSchedule']();self.assertFalse(e['FFL_AutoPending'][2]);self.assertFalse(e['FFL_AutoPending'][6]);e['FFL_RetryAutosaves']();self.assertEqual(c,[(0,True,True)])
  for f in self.fs:self.assertNotIn('FRC_Start(',f['FFL_BeginAutosave']);self.assertIn('return FFL_BeginSave(pid,true,true)',f['FFL_BeginAutosave'])
 def test_shared_autosave_state_does_not_depend_on_local_viewer(self):
  states=[]
  for viewer in [0,7]:
   e,t,m,c,gate,now=self.env(viewer);e['FFL_AutoSchedule']();e['FFL_RetryAutosaves']();states.append((dict(e['FFL_AutoPending']),m,c))
  self.assertEqual(states[0],states[1])
  for f in self.fs:
   for n in ['FFL_QueueAutosave','FFL_TryAutosave','FFL_BeginAutosave','FFL_AutoSchedule','FFL_AutoStart']:self.assertNotIn('GetLocalPlayer',f[n])
 def test_all_other_accepted_ui_quest_and_resource_changes_preserved(self):
  bases=['release/development/GRecovery03/FFERPG-0.9.7.5g-Recovery03.w3x','release/development/GRecovery03/FFERPG-0.9.7.5g-1.29.2-Recovery03.w3x','release/development/V14/FFERPG-V14.w3x']
  for path,new,f in zip(bases,self.maps,self.fs):
   old=MPQ(str(ROOT/path));before=functions(old.read('war3map.j').decode())
   for n in before:
    if n.startswith(('Inventory','QuickGear','Forsaken_','Quest','Text_','Cine_','Travel','D5_','D7_')):self.assertEqual(tokens(before[n]),tokens(f[n]),n)
   for file in old.read('(listfile)').decode().splitlines():
    if file.lower() not in ['war3map.j','war3map.wct','(listfile)','(attributes)','(signature)']:self.assertEqual(old.read(file),new.read(file),file)
if __name__=='__main__':unittest.main()
