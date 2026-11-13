import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_autosave_h02 import DIR,SOURCE
from backpack_b_h02 import ORIGINAL
from editor_pair import View
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks

class BackpackH02Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.v=View(DIR/'FFERPG-0.9.7.5h-Hotfix02.w3x');c.f=functions(c.v.runtime);c.original=functions(View(ORIGINAL).runtime)
 def run_j(self,names,extra={}):
  s='\n'.join(self.f[n] for n in names);e=mocks(s)
  e.update(GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0,GetOwningPlayer=lambda u:0,Player_GetHero=lambda p:p+1,udg_SpiritOfGaya=defaultdict(lambda:None,{1:10,2:20}),ForsakenPanelClock=1,TimerGetElapsed=lambda t:10.,ForsakenBackpackWanted=False,ForsakenBackpackExplicitlyClosed=False,ForsakenInspectTarget=None,InventoryCinematicActive=False,ForsakenInventoryBindUntil=0.,ForsakenInventoryBindPhase=0,ForsakenLastToggleTime=-10.,ForsakenLastToggleSource=0,ForsakenBackpackRequests=0,ForsakenBackpackKeyHeld=False,ForsakenBackpackCloses=0,ForsakenBackpackCloseUntil=0.,ForsakenBackpackWasVisible=False,ForsakenPanelOpen=False,OSKEY_B=66,BlzIsKeyPressed=lambda key:False)
  e.update(extra);return execute(s,names,e)
 def test_owner_selection_context_rejects_foreign_or_unselected_inventory(self):
  selected={1};owners={1:0,2:1,10:0,20:1}
  e=self.run_j(['Forsaken_InventoryContext'],{'GetOwningPlayer':lambda u:owners[u],'IsUnitSelected':lambda u,p:u in selected})
  self.assertTrue(e['Forsaken_InventoryContext'](1,0));self.assertFalse(e['Forsaken_InventoryContext'](2,0));selected.clear();selected.add(2);self.assertFalse(e['Forsaken_InventoryContext'](1,0));selected.clear();selected.add(10);self.assertTrue(e['Forsaken_InventoryContext'](1,0))
 def test_inspection_always_hides_native_panels_without_closing_inspection(self):
  hidden=[];e=self.run_j(['Forsaken_BackpackVisible'],{'Forsaken_SelectCachedFrame':lambda kind,fallback:'pane'+str(kind),'Forsaken_InventoryContext':lambda *a:True,'Forsaken_HideInventory':lambda:hidden.append(True),'ForsakenInspectTarget':99})
  self.assertFalse(e['Forsaken_BackpackVisible'](None));self.assertEqual(e['ForsakenInspectTarget'],99);self.assertFalse(e['ForsakenBackpackWanted']);self.assertEqual(hidden,[True])
  e['ForsakenInspectTarget']=None;e['Forsaken_InventoryContext']=lambda *a:False;self.assertFalse(e['Forsaken_BackpackVisible'](None));self.assertFalse(e['ForsakenBackpackWanted'])
 def test_one_native_frame_per_kind_survives_aliases_and_duplicate_views(self):
  frames={0:'g1',1:'g2',2:'g1',256:'d1',257:'d2',512:'b1',513:'b2'};visible={x:True for x in frames.values()}
  e=self.run_j(['Forsaken_KeepInventoryFrames'],{'ForsakenNativeFrameCount':{0:3,1:2,2:2},'ForsakenNativeFrame':frames,'BlzFrameIsVisible':lambda f:visible[f],'BlzFrameSetVisible':lambda f,v:visible.__setitem__(f,v)})
  e['Forsaken_KeepInventoryFrames']('g1','d1','b1');self.assertEqual({k for k,v in visible.items() if v},{'g1','d1','b1'})
 def test_x_then_physical_b_can_reopen_even_inside_synthetic_echo_delay(self):
  e=self.run_j(['Forsaken_CloseBackpack','Forsaken_RequestBackpackToggle'],{'ForsakenBackpackWanted':True,'ForsakenBackpackKeyHeld':True,'ForsakenLastToggleSource':3,'ForsakenLastToggleTime':10.,'BlzIsKeyPressed':lambda key:True,'ForsakenTalentToggle':1,'ForsakenTalentRoot':2,'ForsakenBackpackClose':3,'ForsakenLinkedBagClose':4})
  e['Forsaken_CloseBackpack']();self.assertFalse(e['ForsakenBackpackKeyHeld']);self.assertTrue(e['ForsakenBackpackExplicitlyClosed']);e['Forsaken_RequestBackpackToggle'](1);self.assertTrue(e['ForsakenBackpackWanted']);self.assertFalse(e['ForsakenBackpackExplicitlyClosed'])
 def test_missing_key_up_recovers_without_toggling_or_hiding_inventory(self):
  hidden=[];e=self.run_j(['UI72_Tick'],{'ForsakenBackpackKeyHeld':True,'Inventory94_Blocked':lambda:True,'Forsaken_HideInventory':lambda:hidden.append(True)})
  e['UI72_Tick']();self.assertFalse(e['ForsakenBackpackKeyHeld']);self.assertFalse(hidden);self.assertNotIn('not ForsakenBackpackWanted',self.f['UI72_Tick']);self.assertNotIn('or not ForsakenBackpackWanted',self.f['Forsaken_BackpackVisible'])
 def test_other_player_selection_event_does_not_touch_local_ui(self):
  changes=[];e=self.run_j(['Forsaken_PanelAccess'],{'GetTriggerPlayer':lambda:1,'GetTriggerUnit':lambda:2,'Inventory94_Blocked':lambda:False,'ForsakenInspectTarget':99,'ForsakenPanelOpen':True,'BlzFrameSetVisible':lambda *a:changes.append(a)})
  e['Forsaken_PanelAccess']();self.assertEqual(changes,[]);self.assertEqual(e['ForsakenInspectTarget'],99);self.assertTrue(e['ForsakenPanelOpen'])
 def test_hover_tooltips_are_outside_inspect_grid_and_noninteractive(self):
  b=self.f['Forsaken_CreateInspection'];self.assertIn('FRAMEPOINT_TOPRIGHT,ForsakenInspectRoot,FRAMEPOINT_TOPLEFT,-.032,-.025',b);self.assertIn('BlzFrameSetEnable(tip,false)',b);self.assertIn('BlzFrameSetEnable(ForsakenInspectItemText[slot],false)',b)
  self.assertNotIn('call Forsaken_RenderInspection(hero)',self.f['Forsaken_DrawPanels']);self.assertIn('CollectionInventoryRevision',self.f['Forsaken_PollPanels']);self.assertIn('Inventory94Until[GetPlayerId(GetOwningPlayer(ForsakenInspectTarget))]',self.f['Forsaken_PollPanels'])
 def test_panels_are_singletons_and_inspect_is_read_only(self):
  self.assertIn('if ForsakenInspectRoot!=null then',self.f['Forsaken_CreateInspection']);self.assertIn('if ForsakenTalentRoot!=null then',self.f['Register_Forsaken_PanelAccess'])
  self.assertIn('set ForsakenTalentRoot=null',self.f['Forsaken_RebuildPanels']);self.assertIn('set ForsakenInspectRoot=null',self.f['Forsaken_RebuildPanels'])
  b=self.f['Forsaken_RenderInspection'];self.assertNotIn('UnitAddItem',b);self.assertNotIn('UnitRemoveItem',b);self.assertNotIn('BlzFrameClick',b)
  self.assertIn('call Forsaken_CloseBackpack()',self.f['Forsaken_PanelClick']);self.assertIn('ForsakenInspectTarget==null',self.f['Forsaken_BackpackToggleAction'])
  self.assertNotIn('BlzCreateFrame',self.f['Forsaken_KeepInventoryFrames']);self.assertNotIn('CreateTimer',self.f['Forsaken_KeepInventoryFrames'])
 def test_good_item_refresh_and_native_b_open_path_preserved(self):
  before=functions(View(SOURCE/'FFERPG-0.9.7.5h.w3x').runtime)
  for name in ['Inventory94_ClearAim','Inventory94_ClearLocal','Inventory94_Changed','Forsaken_BackpackCloseAction','Forsaken_BackpackActivity','QuickGear_Receive','QuickGear_Draw']:
   self.assertEqual(tokens(before[name]),tokens(self.f[name]),name)
  self.assertNotIn('ForceUIKey',self.f['Forsaken_BackpackAccess'].replace('// ForceUIKey','// synthetic key'))
 def test_full_and_partial_teleporter_cancel_above_hud(self):
  for total,page in [(13,0),(13,1),(10,0),(5,0),(0,0)]:
   points={};sizes={};visible={};e=self.run_j(['TravelPanel_Render'],{'TravelPanel':99,'TravelPanelTitle':98,'TravelPanelButton':{i:i for i in range(16)},'TravelPage':{0:page},'TravelOrder':{i:i for i in range(1,14)},'udg_TravelCount':total,'udg_WarpUnlocked':defaultdict(lambda:True),'udg_TravelName':defaultdict(lambda:'Destination'),'FRAMEPOINT_TOPLEFT':0,'FRAMEPOINT_TOP':1,'I2R':float,'I2S':str,'IMaxBJ':max,'IMinBJ':min,'RMinBJ':min,'BlzFrameSetPoint':lambda f,p,parent,q,x,y:points.__setitem__(f,(x,y)),'BlzFrameSetSize':lambda f,w,h:sizes.__setitem__(f,(w,h)),'BlzFrameSetVisible':lambda f,v:visible.__setitem__(f,v)})
   e['TravelPanel_Render'](0);self.assertTrue(visible[0]);self.assertLessEqual(sizes[99][1],.400001)
   for frame,shown in visible.items():
    if frame!=99 and shown:
     bottom=.585+points[frame][1]-sizes[frame][1];self.assertGreater(bottom,.18,(total,page,frame,bottom))
  self.assertIn('BlzFrameSetLevel(TravelPanel,80)',self.f['TravelPanel_Init']);self.assertIn('BlzFrameSetEnable(TravelPanelTitle,false)',self.f['TravelPanel_Init'])
 def test_teleporter_click_cancel_esc_and_sync_unchanged(self):
  for n in ['TravelPanel_Click','TravelPanel_Key','TravelPanel_Request','TravelPanel_Sync','TravelPanel_Choose','Travel_Show','Travel_Hide']:
   self.assertEqual(tokens(self.original[n]),tokens(self.f[n]),n)
if __name__=='__main__':unittest.main()
