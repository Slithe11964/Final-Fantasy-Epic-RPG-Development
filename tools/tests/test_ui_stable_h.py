import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_ui_stable_h import BASE,OUT
from editor_pair import View
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks

class StableInventoryUITests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.old=View(BASE);c.new=View(OUT);c.f=functions(c.new.runtime)
 def run_j(self,names,extras={}):
  source='\n'.join(self.f[n] for n in names);e=mocks(source)
  e.update(QuickGearHeld=defaultdict(bool),QuickGearSeenRevision=10,QuickGearReady=True,QuickGearShown=True,QuickGearRoot='gear',ForsakenPanelOpen=True,ForsakenInspectTarget='inspected',ForsakenTalentRoot='talents',ForsakenTalentToggle='toggle',ForsakenInspectRoot='inspect',ForsakenInspectButton='inspectbutton',ForsakenBackpackClose='X',ForsakenLinkedBagClose='bagX',CarryUIRoot='carry',CarryUIOpen=True,ForsakenHolyBoltsAttached=False,ForsakenAttackCommand=None,GearCursorError60=None,GetPlayerId=lambda p:p,GetOwningPlayer=lambda u:0,GetLocalPlayer=lambda:0,GetUnitTypeId=lambda u:1,NativeCDClock=1,TimerGetElapsed=lambda t:10.,Inventory94Until=defaultdict(float))
  e['UI73AimRevision']=0
  e['QuickGearPending']=0
  e.update(extras);return execute(source,names,e)
 def test_item_maintenance_keeps_open_panels_buttons_and_glow_roots_visible(self):
  visible=[];e=self.run_j(['Inventory94_ClearAim'],{'BlzFrameSetVisible':lambda *a:visible.append(a)})
  e['Inventory94_ClearAim']()
  self.assertEqual(visible,[]);self.assertTrue(e['ForsakenPanelOpen']);self.assertTrue(e['CarryUIOpen']);self.assertTrue(e['QuickGearShown']);self.assertEqual(e['ForsakenInspectTarget'],'inspected')
  self.assertEqual(e['QuickGearPending'],-1);self.assertFalse(e['QuickGearReady']);self.assertEqual(e['QuickGearSeenRevision'],-1)
 def test_item_change_only_cancels_own_aim_and_preserves_closed_state(self):
  calls=[];e=self.run_j(['Inventory94_Changed'],{'Inventory94_ClearAim':lambda:calls.append('clear'),'ForsakenPanelOpen':False,'CarryUIOpen':False})
  e['Inventory94_Changed'](5);self.assertEqual(calls,['clear']);self.assertAlmostEqual(e['Inventory94Until'][0],10.2);self.assertFalse(e['ForsakenPanelOpen']);self.assertFalse(e['CarryUIOpen'])
  e['GetOwningPlayer']=lambda u:1;e['Inventory94_Changed'](6);self.assertEqual(calls,['clear']);self.assertAlmostEqual(e['Inventory94Until'][1],10.2)
 def test_cutscene_full_clear_still_hides_every_panel(self):
  visible=[];e=self.run_j(['Inventory94_ClearAim','Inventory94_ClearLocal'],{'BlzFrameSetVisible':lambda *a:visible.append(a)})
  e['Inventory94_ClearLocal']();self.assertFalse(e['ForsakenPanelOpen']);self.assertFalse(e['QuickGearShown']);self.assertIsNone(e['ForsakenInspectTarget'])
  for frame in ['gear','talents','toggle','inspect','inspectbutton','X','bagX']:self.assertIn((frame,False),visible)
  self.assertIn('call Inventory94_ClearLocal()',self.f['Inventory94_CineEnter'])
 def test_native_frame_rebind_cannot_open_closed_inventory(self):
  hidden=[];e=self.run_j(['Forsaken_BackpackVisible'],{'Forsaken_SelectCachedFrame':lambda kind,fallback:str(kind),'ForsakenPanelClock':1,'Player_GetHero':lambda p:4,'InventoryCinematicActive':False,'ForsakenBackpackExplicitlyClosed':False,'ForsakenBackpackWanted':False,'ForsakenInventoryBindUntil':0.,'Forsaken_HideInventory':lambda:hidden.append(True)})
  self.assertFalse(e['Forsaken_BackpackVisible'](None));self.assertFalse(e['ForsakenBackpackWanted']);self.assertEqual(hidden,[True])
  e['ForsakenBackpackWanted']=True;self.assertTrue(e['Forsaken_BackpackVisible'](None));self.assertTrue(e['ForsakenBackpackWanted'])
 def test_closed_native_guard_runs_even_during_item_settle(self):
  hidden=[];e=self.run_j(['UI72_Tick'],{'ForsakenBackpackWanted':False,'Forsaken_HideInventory':lambda:hidden.append(True),'Inventory94_Blocked':lambda:True})
  e['UI72_Tick']();self.assertEqual(hidden,[True]);e['ForsakenBackpackWanted']=True;e['UI72_Tick']();self.assertEqual(hidden,[True])
 def test_only_ui_functions_changed_no_gameplay_or_new_timer(self):
  old=functions(self.old.runtime);changed={n for n in old if tokens(old[n])!=tokens(self.f[n])}
  self.assertEqual(changed,{'Inventory94_ClearLocal','Inventory94_Changed','Forsaken_BackpackVisible','UI72_Tick'})
  self.assertEqual(set(self.f)-set(old),{'Inventory94_ClearAim'})
  for ext in ['w3a','w3u','w3t','w3q','w3h']:self.assertEqual(self.old.archive.read('war3map.'+ext),self.new.archive.read('war3map.'+ext))
  for n in ['QuickGear_Receive','QuickGear_Draw','QuickGear_Input','Inventory94_CineEnter','Inventory94_CineExit','Inventory94_Blocked','Forsaken_RequestBackpackToggle','Forsaken_OnEquip','Forsaken_RebindBag']:
   self.assertEqual(tokens(old[n]),tokens(self.f[n]),n)
  self.assertNotIn('CreateTimer',self.f['Inventory94_ClearAim']);self.assertNotIn('CreateGroup',self.f['Inventory94_ClearAim'])
if __name__=='__main__':unittest.main()
