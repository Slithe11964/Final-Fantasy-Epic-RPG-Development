"""NG+ XP math, one-shot scheduling, six-slot previews and pane scope."""
import sys,unittest,re
from pathlib import Path
from collections import defaultdict
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from session_v19 import XP,HIDE,refresh,native_preview_delta
from build_f1030_inventory_rollback import view
from build_forest86 import ROOT,functions
from test_armory_materia import execute
from test_shared_context import mocks
import test_preview77

class Session19Tests(unittest.TestCase):
 def test_ngxp_is_additive_and_does_not_scale_penalties(self):
  e=mocks(XP);given=[]
  e.update(I2R=float,R2I=int,IMaxBJ=max,udg_NewGamePlusLevel={1:0,2:9},GetPlayerId=lambda p:p,
   GetOwningPlayer=lambda u:0 if u=='new' else 1,AddHeroXP=lambda *a:given.append(a))
  e=execute(XP,['NG19_Factor','NG19_AddXP','NG19_AddXPSwapped'],e)
  self.assertEqual(e['NG19_Factor'](0),1.)
  self.assertAlmostEqual(e['NG19_Factor'](1),1.9)
  e['NG19_AddXP']('new',100,True);e['NG19_AddXP']('ng9',100,True);e['NG19_AddXPSwapped'](-100,'ng9',False)
  self.assertEqual(given,[('new',100,True),('ng9',190,True),('ng9',-100,False)])
 def test_buff_follows_ng_count_and_does_not_stack_duplicate_abilities(self):
  src='\n'.join(functions(XP)[n] for n in ['NG19_Buff','NG19_SyncBuffs']);e=mocks(src);rank={};adds=[]
  e.update(GetUnitTypeId=lambda u:1,GetUnitAbilityLevel=lambda u,r:rank.get(u,0),IMinBJ=min,
   UnitAddAbility=lambda u,r:adds.append((u,r)),UnitMakeAbilityPermanent=lambda *a:None,
   SetUnitAbilityLevel=lambda u,r,n:rank.update({u:n}),UnitRemoveAbility=lambda u,r:rank.pop(u,None),
   udg_PlayerHero=defaultdict(lambda:None,{1:'hero',2:'other'}),udg_SpiritOfGaya=defaultdict(lambda:None,{1:'gaya'}),
   udg_NewGamePlusLevel=defaultdict(int,{1:9}))
  e=execute(src,['NG19_Buff','NG19_SyncBuffs'],e);e['NG19_SyncBuffs']();e['NG19_SyncBuffs']()
  self.assertEqual(rank,{'hero':9,'gaya':9});self.assertEqual(len(adds),2)
 def test_backpack_poll_never_hides_every_context(self):
  v=view(str(ROOT/'release/development/V18/FFERPG-V18.w3x'));s=refresh('TEquip',v.modules['TEquip']);f=functions(s)
  self.assertNotIn('Forsaken_HideInventory()',f['Forsaken_BackpackVisible'])
  self.assertNotIn('ForsakenNativeFrame',f['Forsaken_HideInventory'])
  self.assertIn('ForsakenInventoryHero!=Player_GetHero(GetLocalPlayer())',f['Forsaken_HideInventory'])
 def test_stats_heartbeat_rearms_before_cinematic_gate(self):
  v=view(str(ROOT/'release/development/V18/FFERPG-V18.w3x'));f=functions(refresh('TPassive',v.modules['TPassive']))['Trig_Passive_Bonus_Sync_Actions']
  e=mocks(f);calls=[];e.update(udg_InCinematicMode=True,InventoryCinematicActive=True,StartTimerBJ=lambda *a:calls.append('timer'),ExecuteFunc=lambda *a:calls.append('sync'))
  e=execute(f,['Trig_Passive_Bonus_Sync_Actions'],e);e['Trig_Passive_Bonus_Sync_Actions']()
  self.assertEqual(calls,['timer'])

class NativePreview19Tests(test_preview77.Preview77Tests):
 @classmethod
 def setUpClass(cls):
  cls.before=view(str(ROOT/'release/development/QuickUI76/FFERPG-QuickUI76.w3x')).modules['TEquip']
  base=view(str(ROOT/'release/development/V18/FFERPG-V18.w3x')).modules['TEquip']
  cls.source=refresh('TEquip',base);cls.fs=functions(cls.source)
 def click_engine(self):
  e,items,state,clears=super().click_engine()
  e['InventoryCinematicActive']=False;e['udg_InCinematicMode']=False
  return e,items,state,clears
 def test_idle_cache_cast_receiver_and_input_paths_unchanged(self):
  self.assertNotIn('Idle76_Capture',self.fs)
  self.assertNotIn('Inventory94',self.source)
  for n in ['BagScreen_Click66','Wave65_Draw','Preview75_QuickSlot']:
   self.assertNotIn('NG19_',self.fs[n])

if __name__=='__main__':unittest.main()
