"""Recovery10 renderer preserved; cinematic shutdown and owner isolation."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from build_f1030_inventory_rollback import view
from build_forest86 import ROOT,functions
from cinematic_v23 import refresh,TRIGGERS,UI_PAUSE
from test_shared_context import mocks
from test_armory_materia import execute
from jtok import tokens

class Cinematic23Tests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.v=view(str(ROOT/'release/development/GRecovery10/FFERPG-0.9.7.5g-Recovery10.w3x'))
  cls.modules={k:refresh(k,s) for k,s in cls.v.modules.items()}
  cls.fs={n:b for s in cls.modules.values() for n,b in functions(s).items()}
 def test_retains_recovery10_native_models_icons_and_no_pane_recovery(self):
  old=functions(self.v.modules['TEquip'])
  for n in ['QuickGear_Init','QuickGear_DrawWheel','QuickGear_PaintIcon','Forsaken_BackpackVisible','Forsaken_PollPanels','Forsaken_CloseBackpack','Forsaken_RequestBackpackToggle']:
   self.assertEqual(tokens(old[n]),tokens(self.fs[n]),n)
  self.assertNotIn('Bag22','\n'.join(self.modules.values()))
 def test_disables_all_registered_gear_controls_and_restores_only_prior_enabled(self):
  names=['C23_PauseControls','C23_ResumeControls'];src='\n'.join(self.fs[n] for n in names);e=mocks(src);events=[]
  for i,n in enumerate(TRIGGERS):e[n]='t%d'%i
  e.update(C23Control={},C23ControlResume={},C23ButtonEnabled={},QuickGearButton={0:'f',1:'g'},QuickGearHeld={0:True,1:True},C23DropCount=0,ForsakenBackpackKeyHeld=True,
   IsTriggerEnabled=lambda t:t!='t3',DisableTrigger=lambda t:events.append(('off',t)),EnableTrigger=lambda t:events.append(('on',t)),BlzFrameGetEnable=lambda f:f=='f',BlzFrameSetEnable=lambda f,v:events.append((f,v)),ExecuteFunc=lambda n:None)
  e=execute(src,names,e);e['C23_PauseControls']()
  self.assertEqual({t for op,t in events if op=='off'},set(e[n] for n in TRIGGERS)-{'t3'})
  self.assertIn(('f',False),events);self.assertIn(('g',False),events)
  e['C23_ResumeControls']();self.assertEqual({t for op,t in events if op=='on'},set(e[n] for n in TRIGGERS)-{'t3'})
  self.assertIn(('f',True),events);self.assertFalse(e['QuickGearHeld'][0]);self.assertFalse(e['ForsakenBackpackKeyHeld'])
 def test_hides_all_images_even_when_preview_mode_was_already_zero(self):
  b=self.fs['C23_HidePreviewImages'];e=mocks(b);hidden=[]
  e.update(QuickGearPending=1,QuickGearPreview=0,QuickGearPreviewCount=3,QuickGearPreviewImage={1:'a',2:None,3:'c'},GearWaveRune=defaultdict(lambda:None,{1:'r1',64:'r64'}),GearWaveMode=0,
   GearCursorError60='error',ShowImage=lambda f,on:hidden.append((f,on)),Wave65_Clear=lambda:hidden.append(('water/ice',False)),BlzFrameSetVisible=lambda f,on:hidden.append((f,on)))
  e=execute(b,['C23_HidePreviewImages'],e);e['C23_HidePreviewImages']()
  self.assertEqual(set(hidden),{('a',False),('c',False),('r1',False),('r64',False),('water/ice',False),('error',False)})
  self.assertEqual(e['QuickGearPending'],-1);self.assertEqual(e['QuickGearPreview'],0)
 def test_models_and_simple_frames_both_hidden_before_selection_changes(self):
  b=self.fs['C20_HideUI']
  self.assertIn('BlzFrameSetVisible(QuickGearNativeWheel[i],false)',b)
  self.assertIn('BlzFrameSetVisible(QuickGearButton[i],false)',b)
  self.assertIn('BlzFrameSetVisible(QuickGearWheelPanel[i],false)',b)
  self.assertIn('call C23_HidePreviewImages()',b)
  self.assertLess(self.fs['C20_UIPause'].index('call C23_PauseControls()'),self.fs['C20_UIPause'].index('call C20_HideUI()'))
  b=self.fs['Cine_Enter'];self.assertLess(b.index('C20_UIPause'),b.index('GroupEnumUnitsInRect'))
  self.assertLess(b.index('C23Chronicles_Pause'),b.index('GroupEnumUnitsInRect'))
 def test_deferred_item_and_rebuild_callbacks_read_no_inventory_in_scene(self):
  for n,updates,result in [('Forsaken_CarryDrop',dict(C23DropTimer={},C23DropCount=0),'C23DropTimer'),('ForsakenUI_Rebuild',dict(C23RebuildTimer=None),'C23RebuildTimer')]:
   b=self.fs[n];e=mocks(b)
   def fail(*a):self.fail(n+' accessed inventory/UI during scene')
   e.update(udg_InCinematicMode=True,InventoryCinematicActive=True,GetExpiredTimer=lambda:'pending',GetHandleId=fail,LoadItemHandle=fail,ExecuteFunc=fail,DestroyTimer=fail,**updates)
   e=execute(b,[n],e);e[n]()
   self.assertEqual(e[result],{0:'pending'} if result=='C23DropTimer' else 'pending')
 def test_queued_stat_events_cannot_restart_timer_during_scene(self):
  for n in ['Trig_Passive_Bonus_Sync_Actions','Trig_Stats_RefreshOnEvent_Actions']:
   b=self.fs[n];e=mocks(b);calls=[]
   e.update(udg_InCinematicMode=True,InventoryCinematicActive=True,C23StatsDirty=False,StartTimerBJ=lambda *a:calls.append(a),ExecuteFunc=lambda *a:self.fail('stat scan'))
   e=execute(b,[n],e);e[n]();self.assertEqual(calls,[]);self.assertTrue(e['C23StatsDirty'])
  self.assertIn('if C23StatsDirty then\n        call StartTimerBJ(udg_StatsRefreshTimer,false,.01)',self.fs['Cine_Exit'])
 def test_chronicle_and_shield_use_existing_timer_pause_resume(self):
  for prefix,timer in [('C23Chronicles','C23ChroniclesTimer'),('C23Shield','TalentShieldDisplayTimer')]:
   names=[prefix+'_Pause',prefix+'_Resume'];b='\n'.join(self.fs[n] for n in names);e=mocks(b);calls=[]
   e.update({timer:'existing',prefix+'Running':False,'TimerGetRemaining':lambda t:1.,'PauseTimer':lambda t:calls.append(('pause',t)),'ResumeTimer':lambda t:calls.append(('resume',t))})
   e=execute(b,names,e);e[names[0]]();e[names[1]]();self.assertEqual(calls,[('pause','existing'),('resume','existing')])
  self.assertIn('C23ChroniclesTimer=CreateTimer()',self.fs['Chronicles_Init'])
  self.assertNotIn('TimerStart(CreateTimer(),1.',self.fs['Chronicles_Init'])
 def test_remote_players_input_returns_before_hero_and_frame_access(self):
  for n in ['Forsaken_BackpackToggleAction','Forsaken_BackpackCloseAction','Forsaken_PanelAccess']:
   b=self.fs[n];e=mocks(b)
   def fail(*a):self.fail(n+' handled remote input')
   e.update(udg_InCinematicMode=False,InventoryCinematicActive=False,GetTriggerPlayer=lambda:1,GetLocalPlayer=lambda:0,Player_GetHero=fail,BlzGetTriggerFrame=fail,BlzFrameSetVisible=fail,Forsaken_RequestBackpackToggle=fail,Forsaken_CloseBackpack=fail)
   e=execute(b,[n],e);e[n]()
  b=self.fs['Forsaken_BackpackAccess'];e=mocks(b);e.update(GetLocalPlayer=lambda:0,BlzGetTriggerPlayerKey=lambda:self.fail('remote key read'))
  e=execute(b,['Forsaken_BackpackAccess'],e);e['Forsaken_BackpackAccess'](1,'otherHero')
 def test_every_actual_cinematic_hud_entry_uses_common_shutdown(self):
  fs=functions(self.v.runtime)
  self.assertEqual([n for n,b in fs.items() if any(x in b for x in ['ShowInterface(false','CinematicModeBJ(true','CinematicModeExBJ(true'])],['Cine_Enter'])
  self.assertGreater(sum('call Cine_Enter()' in b for n,b in fs.items() if n!='Cine_Enter'),300)

if __name__=='__main__':unittest.main()
