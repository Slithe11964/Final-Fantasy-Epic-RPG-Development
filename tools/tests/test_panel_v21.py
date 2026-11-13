"""Exercise the native observer and its actual companion/board output."""
import sys,unittest
from pathlib import Path
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from build_f1030_inventory_rollback import view
from build_forest86 import ROOT,functions
from panel_v21 import refresh
from test_armory_materia import execute
from test_shared_context import mocks

class Panel21Tests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.base=view(str(ROOT/'release/development/V20/FFERPG-V20.w3x')).modules['TEquip']
  cls.source=refresh(cls.base);cls.fs=functions(cls.source)
 def engine(self):
  names=['Forsaken_SelectCachedFrame','Forsaken_InventoryContext','Forsaken_BackpackVisible','Forsaken_BackpackControls','CarryUI_ShowAccess','Forsaken_PollPanels']
  src='\n'.join(self.fs[n] for n in names);e=mocks(src);shown={};live={'gear','backdrop','bag'}
  e.update(FRAMEPOINT_TOPRIGHT=1,FRAMEPOINT_BOTTOMRIGHT=2,udg_InCinematicMode=False,InventoryCinematicActive=False,ForsakenPanelNeedsRefresh=False,ForsakenNextPanelDraw=100.,
   ForsakenNativeFrameCount={0:1,1:1,2:1},ForsakenNativeFrame={0:'gear',256:'backdrop',512:'bag'},
   ForsakenCachedEquipment='gear',ForsakenCachedBackdrop='backdrop',ForsakenLinkedBag='bag',ForsakenPanelClock='clock',
   ForsakenInventoryHero='hero',ForsakenBackpackExplicitlyClosed=False,ForsakenBackpackWanted=True,ForsakenInventoryBindUntil=0.,
   ForsakenInspectTarget=None,ForsakenLastInspectTarget=None,ForsakenPanelOpen=False,ForsakenTalentsWanted=False,
   ForsakenTalentToggle='talents',ForsakenTalentRoot='talentPanel',ForsakenBackpackClose='x',ForsakenLinkedBagClose='bx',
   CarryUIButton='move',ForsakenTalentAnchor='backdrop',ForsakenInspectButton='inspect',
   ForsakenSelectedTarget='hero',udg_HuntLeaderboard='hunt',HuntBoardWanted=True,udg_ScoreBoard='version',BazaarBrowserOpen={0:False},
   GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',GetOwningPlayer=lambda u:0,
   IsUnitSelected=lambda u,p:True,BlzFrameIsVisible=lambda f:f in live,TimerGetElapsed=lambda t:5.,GetPlayerId=lambda p:p,
   Forsaken_FindFrame=lambda n:{'SimpleEquipmentPanel':'gear','EquipmentPanelBackdrop':'backdrop'}[n],
   BlzFrameSetVisible=lambda f,v:shown.update({f:v}),LeaderboardDisplay=lambda f,v:shown.update({f:v}),MultiboardDisplay=lambda f,v:shown.update({f:v}),
   Forsaken_BackpackInputControl=lambda *a:None,Forsaken_ShieldReadout=lambda *a:None,Forsaken_HolyBoltsTooltip=lambda *a:None,
   CarryUI_Close=lambda:None,Forsaken_CanInspect=lambda *a:False)
  return execute(src,names,e),live,shown
 def test_stale_closed_intent_cannot_override_open_native_backpack(self):
  e,live,shown=self.engine();e['ForsakenBackpackExplicitlyClosed']=True
  e['Forsaken_PollPanels']()
  for f in ['talents','x','move']:self.assertTrue(shown[f],f)
  for f in ['hunt','version']:self.assertFalse(shown[f],f)
  self.assertFalse(e['ForsakenBackpackExplicitlyClosed'])
 def test_reproduces_recovery09_rejection_then_new_observer_recovers(self):
  old=functions(self.base)['Forsaken_BackpackVisible']
  for active,closed in [({'gear','bag','backdrop'},True),({'gear','bag'},False),({'bag','backdrop'},False)]:
   e,live,shown=self.engine();live.clear();live.update(active);e['ForsakenBackpackExplicitlyClosed']=closed
   oldenv=execute(old,['Forsaken_BackpackVisible'],dict(e))
   self.assertFalse(oldenv['Forsaken_BackpackVisible']('gear'))
   self.assertTrue(e['Forsaken_BackpackVisible']('gear'))
 def test_content_rebinding_and_missing_backdrop_keep_companions_and_board_mask(self):
  for active in [{'gear','bag'},{'gear'},{'bag'},{'gear','backdrop'},{'bag','backdrop'}]:
   with self.subTest(active=active):
    e,live,shown=self.engine();live.clear();live.update(active);e['Forsaken_PollPanels']()
    for f in ['talents','x','move']:self.assertTrue(shown[f],f)
    self.assertFalse(shown['hunt']);self.assertFalse(shown['version'])
 def test_decorative_backdrop_alone_does_not_invent_open_inventory(self):
  e,live,shown=self.engine();live.clear();live.add('backdrop');e['Forsaken_PollPanels']()
  for f in ['talents','x','move']:self.assertFalse(shown[f])
  self.assertTrue(shown['hunt']);self.assertTrue(shown['version'])
 def test_no_selected_own_hero_or_inspection_cannot_adopt_foreign_native_panes(self):
  for field,value in [('IsUnitSelected',lambda *a:False),('GetOwningPlayer',lambda *a:1),('ForsakenInspectTarget','other')]:
   e,live,shown=self.engine();e[field]=value
   self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
 def test_closed_and_cinematic_never_reopen_native_frames(self):
  e,live,shown=self.engine();live.clear();e['Forsaken_PollPanels']()
  for f in ['talents','x','move']:self.assertFalse(shown[f])
  e,live,shown=self.engine();e['InventoryCinematicActive']=True;e['Forsaken_PollPanels']();self.assertEqual(shown,{})
  self.assertFalse(e['Forsaken_BackpackVisible']('gear'))
 def test_scope_contains_only_two_presentation_functions(self):
  from jtok import tokens
  before=functions(self.base)
  self.assertEqual({n for n in before if tokens(before[n])!=tokens(self.fs[n])},{'Forsaken_BackpackVisible','Forsaken_PollPanels'})
  for n in ['Forsaken_BackpackVisible','Forsaken_PollPanels']:
   for forbidden in ['CreateTimer(','BlzCreateFrame','BlzGetFrameByName(','UnitAddAbility(','UnitRemoveAbility(','UnitAddItem(','UnitRemoveItem(','ForceUI','BlzSendSyncData(','Forsaken_HideInventory(']:
    self.assertNotIn(forbidden,self.fs[n])
  self.assertEqual(self.fs['Forsaken_CloseBackpack'],before['Forsaken_CloseBackpack'])

if __name__=='__main__':unittest.main()
