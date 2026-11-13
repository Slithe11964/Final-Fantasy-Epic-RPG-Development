import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
PAIRS=[('release/0.9.7.5g/history/2026-11-04-before-ui96/FFERPG-0.9.7.5g.w3x','release/development/VersionGHotfix01/FFERPG-0.9.7.5g-Hotfix01.w3x'),('release/development/QuickUI95/FFERPG-QuickUI95.w3x','release/development/QuickUI96/FFERPG-QuickUI96.w3x')]

class UI96Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.pairs=[(View(ROOT/b),View(ROOT/a)) for b,a in PAIRS];c.f=functions(c.pairs[1][1].runtime)
 def test_move_attack_stop_smart_and_item_cast_orders_do_not_clear_ui(self):
  s=self.f['Forsaken_OnEquip'];events={'EVENT_PLAYER_UNIT_EQUIP_ITEM':1,'EVENT_PLAYER_UNIT_UNEQUIP_ITEM':2,'EVENT_PLAYER_UNIT_PICKUP_ITEM':3,'EVENT_PLAYER_UNIT_DROP_ITEM':4,'EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER':5,'EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER':6,'EVENT_PLAYER_UNIT_ISSUED_ORDER':7};kind=[6];order=[851986];target=[None];resets=[];carry=[];e=mocks(s)
  e.update(events);e.update(Inventory94Paused=False,ForsakenConvertingGear=False,GetTriggerUnit=lambda:1,GetTriggerEventId=lambda:kind[0],GetIssuedOrderId=lambda:order[0],GetOrderTargetItem=lambda:target[0],GetUnitAbilityLevel=lambda *a:0,Inventory94_Changed=lambda u:resets.append(u),Forsaken_CarryEvent=lambda u:carry.append(u))
  e=execute(s,['Forsaken_OnEquip'],e)
  for k in [5,6,7]:
   kind[0]=k
   for o in [851986,851983,851972,851971,852008,852013]:
    order[0]=o
    for _ in range(20):e['Forsaken_OnEquip']()
  self.assertFalse(resets);self.assertEqual(len(carry),360)
  kind[0]=5;order[0]=852002;target[0]=2;e['Forsaken_OnEquip']();self.assertEqual(resets,[1])
  target[0]=None;e['Forsaken_OnEquip']();self.assertEqual(resets,[1])
 def test_actual_equipment_events_keep_transition_safety(self):
  b=self.f['Forsaken_OnEquip']
  for event in ['EQUIP','UNEQUIP','PICKUP','DROP']:self.assertIn('EVENT_PLAYER_UNIT_'+event+'_ITEM',b)
  self.assertIn('call Inventory94_Changed(holder)',b)
  self.assertIn('Inventory94Paused',b);self.assertIn('ForsakenConvertingGear',b)
 def test_cinematic_clear_closes_the_panel_and_resets_its_open_state(self):
  b=self.f['Inventory94_ClearLocal'];self.assertIn('call CarryUI_Close()',b)
  self.assertIn('set CarryUIOpen=false',self.f['CarryUI_Close']);self.assertIn('BlzFrameSetVisible(CarryUIRoot,false)',self.f['CarryUI_Close'])
  self.assertIn('BlzFrameSetLevel(CarryUIButton,60)',self.f['CarryUI_Init'])
  self.assertIn('BlzFrameSetVisible(CarryUIButton,visible)',self.f['CarryUI_ShowAccess'])
 def test_only_three_functions_change_and_no_objects_or_timers(self):
  for old,new in self.pairs:
   a,b=functions(old.runtime),functions(new.runtime)
   self.assertEqual({n for n in a if tokens(a[n])!=tokens(b[n])},{'Forsaken_OnEquip','Inventory94_ClearLocal','CarryUI_Init'})
   self.assertEqual(set(a),set(b))
   for lib,s in old.modules.items():
    if lib!='TEquip':self.assertEqual(s,new.modules[lib],lib)
   for n in old.archive.read('(listfile)').decode().splitlines():
    if n.lower() not in ['war3map.j','war3map.wct','war3map.wts','(listfile)','(attributes)','(signature)']:self.assertEqual(old.archive.read(n),new.archive.read(n),n)
   for s in ['CreateTimer(','TimerStart(','TriggerRegisterAnyUnitEventBJ(']:self.assertEqual(old.runtime.count(s),new.runtime.count(s),s)
 def test_working_casting_icons_transfer_and_cinematic_hooks_preserved(self):
  for old,new in self.pairs:
   a,b=functions(old.runtime),functions(new.runtime)
   for n in ['QuickGear_Receive','QuickGear_Input','QuickGear_PaintIcon','QuickGear_Poll','CarryUI_Receive','CarryUI_ShowAccess','Forsaken_CarryOrder','Cine_Enter','Cine_Exit','Inventory94_CineEnter','Inventory94_CineExit']:
    self.assertEqual(tokens(a[n]),tokens(b[n]),n)
   self.assertEqual(tokens(a['CarryUI_Init']),tokens(b['CarryUI_Init'].replace('    call BlzFrameSetLevel(CarryUIButton,60)\n','')))

if __name__=='__main__':unittest.main()
