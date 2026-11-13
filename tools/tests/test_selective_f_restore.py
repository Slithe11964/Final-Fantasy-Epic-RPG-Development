"""Behavior checks for autosave timing and shared cinematic/presentation gates."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from selective_f_restore import AUTO,COMMAND,guard,refresh
from test_armory_materia import execute
from test_shared_context import mocks
from jtok import functions

class SelectiveRestoreTests(unittest.TestCase):
 def auto(self,viewer=0):
  source=AUTO+'\n'+COMMAND;e=mocks(source);now=[0.];calls=[]
  e.update(Collection_ForceRemovePlayerSimple=lambda *a:None,Collection_ForceAddPlayerSimple=lambda *a:None,StringCase=lambda s,upper:s.upper() if upper else s.lower(),GetLocalPlayer=lambda:viewer,GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:0,GetEventPlayerChatString=lambda:'-autosave',
   Player=lambda p:p,TimerGetElapsed=lambda t:now[0],FST_Clock=1,
   udg_GameRunning=True,udg_HardcoreOff=True,udg_InCinematicMode=False,InventoryCinematicActive=False,
   RestoreAutoNext=1200.,RestoreAutoPending=defaultdict(bool),RestoreAutoOff=defaultdict(bool),
   FFL_Phase=defaultdict(int),FFP_Locked=defaultdict(bool),FRC_Phase=defaultdict(int),
   FSC_Busy=defaultdict(bool),FSC_Writing=defaultdict(bool),FST_Pending=defaultdict(bool),
   udg_PlayingPlayers='playing',udg_AutosaveForce='auto',IsPlayerInForce=lambda p,f:p<2,ForceRemovePlayerSimple=lambda *a:None,ForceAddPlayerSimple=lambda *a:None,
   udg_PlayerHero={1:'h0',2:'h1'},udg_SpiritOfGaya={1:'g0',2:'g1'},udg_PlayerHouse={1:'house0',2:'house1'},
   FST_SetFileStem=lambda p,s:True,FFL_BeginSave=lambda p,*a:calls.append((now[0],p)) or True)
  return execute(source,['Restore_AutosaveTick','Trig_Autosave_Command_Actions'],e),now,calls
 def test_schedule_20_then_10_and_identical_for_different_viewers(self):
  logs=[]
  for viewer in [0,1]:
   e,now,calls=self.auto(viewer)
   for t in [0,1199,1200,1201,1799,1800,1801,2400,2401]:
    now[0]=t;e['Restore_AutosaveTick']()
   self.assertEqual(calls,[(1200,0),(1201,1),(1800,0),(1801,1),(2400,0),(2401,1)])
   logs.append(calls)
  self.assertEqual(*logs)
 def test_opt_out_and_cinematic_busy_deferral_keep_other_player(self):
  e,now,calls=self.auto();e['GetEventPlayerChatString']=lambda:'-autosave off';e['Trig_Autosave_Command_Actions']()
  now[0]=1200;e['udg_InCinematicMode']=True;e['Restore_AutosaveTick']();self.assertFalse(calls)
  self.assertFalse(e['RestoreAutoPending'][0]);self.assertTrue(e['RestoreAutoPending'][1])
  e['udg_InCinematicMode']=False;e['FFL_Phase'][0]=3;e['Restore_AutosaveTick']();self.assertFalse(calls)
  e['FFL_Phase'][0]=0;e['Restore_AutosaveTick']();self.assertEqual(calls,[(1200,1)])
 def test_failed_capture_stays_pending_and_manual_request_does_not_move_schedule(self):
  e,now,calls=self.auto();e['GetEventPlayerChatString']=lambda:'-autosave now';e['Trig_Autosave_Command_Actions']()
  self.assertEqual(e['RestoreAutoNext'],1200.)
  e['FFL_BeginSave']=lambda *a:False;e['Restore_AutosaveTick']();self.assertTrue(e['RestoreAutoPending'][0])
 def test_cinematic_gate_runs_before_initialized_getters(self):
  source=guard('function Probe takes nothing returns nothing\n    local integer x=ReadInventory()\n    call Work(x)\nendfunction')
  calls=[];e=mocks(source);e.update(udg_InCinematicMode=True,InventoryCinematicActive=True,ReadInventory=lambda:calls.append('read') or 1,Work=lambda x:calls.append(x))
  e=execute(source,['Probe'],e);e['Probe']();self.assertFalse(calls)
  e['udg_InCinematicMode']=False;e['InventoryCinematicActive']=False;e['Probe']();self.assertEqual(calls,['read',1])
 def test_backpack_context_rejects_other_hero_and_inspection(self):
  from build_f1030_inventory_rollback import view
  root=Path(__file__).resolve().parents[2]
  v=view(str(root/'release/development/GRecovery05/FFERPG-0.9.7.5g-Recovery05.w3x'))
  source=functions(refresh('TEquip',v.modules['TEquip']))['Forsaken_InventoryContext']
  e=mocks(source);e.update(GetOwningPlayer=lambda u:0 if u=='mine' else 1,IsUnitSelected=lambda u,p:True,ForsakenInspectTarget=None)
  e=execute(source,['Forsaken_InventoryContext'],e)
  self.assertTrue(e['Forsaken_InventoryContext']('mine',0));self.assertFalse(e['Forsaken_InventoryContext']('other',0))
  e['ForsakenInspectTarget']='other';self.assertFalse(e['Forsaken_InventoryContext']('mine',0))
 def test_legacy_autosave_uses_only_shared_scheduler(self):
  source=refresh('TSave','library TSave\nfunction Save_Autosave takes nothing returns nothing\n call Save_WriteCode(Player(0),true,"autosave")\nendfunction\nendlibrary')
  calls=[];e=mocks(source);e['ExecuteFunc']=lambda n:calls.append(n)
  e=execute(source,['Save_Autosave'],e);e['Save_Autosave']();self.assertEqual(calls,['Restore_AutosaveTick'])

if __name__=='__main__':unittest.main()
