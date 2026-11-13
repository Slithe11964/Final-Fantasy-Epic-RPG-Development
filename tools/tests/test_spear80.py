from pathlib import Path
import sys,unittest,json
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from damage_tooltips import merged
from priest_master import fields
from build_spear80 import BASE,OUT,SPEARS
from test_shared_context import mocks
from test_armory_materia import execute

class Spear80Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime);c.report=json.loads(OUT.with_suffix('.json').read_text())
 def test_balance_live_and_tooltips_across_all_item_forms(self):
  t=merged(self.after.archive.read('war3map.w3t'),self.after.archive.read('war3mapSkin.w3t'),'w3t')
  a=merged(self.after.archive.read('war3map.w3a'),self.after.archive.read('war3mapSkin.w3a'),'w3a')
  for alias,raw in self.report['aliases'].items():
   f=fields(t[alias]);spec=SPEARS[raw];tip=f['utub',None];ab=f['iabi',None].split(',')
   self.assertIn(f'damage by {spec[1]} and accuracy by {spec[2]}',tip)
   self.assertTrue(any(fields(a[x]).get(('Iatt',1))==spec[1] for x in ab if x in a),alias)
   if raw=='I060':self.assertNotIn('A0OD',ab);self.assertIn('A0H9',ab)
   if raw=='I05S':self.assertNotIn('A0WQ',ab);self.assertIn('A03Y',ab)
   if raw=='I00M':self.assertIn('A0PH',ab);self.assertIn('A19E',ab)
  for raw,cd in [('A11R',20),('A1E6',30)]:
   f=fields(a[raw]);self.assertTrue(all(value==cd for (field,rank),value in f.items() if field=='acdn'))
  self.assertEqual(fields(a['dGLf'])['adur',1],15)
  self.assertIn('radius=200.',self.fs['DG_Area']);self.assertIn('DG_Now+15.',self.fs['DG_Area'])
 def test_jump_damage_halved_with_existing_distance_offset_and_str(self):
  s=self.fs['DG_BaseDamage'];e=mocks(s);e.update(Prof_GetLevel=lambda *a:2,BlzGetAbilityManaCost=lambda *a:300,Abil_GetLevel=lambda *a:0,I2R=float,GetHeroStr=lambda *a:100,RMinBJ=min)
  e=execute(s,['DG_BaseDamage'],e)
  self.assertAlmostEqual(e['DG_BaseDamage'](1,4,500),400*.01*700*1.2)
  self.assertAlmostEqual(e['DG_BaseDamage'](1,4,2000),400*.01*1200*1.2)
 def test_spear_bonuses_use_equipped_forms_only_and_holy_efficiency(self):
  fs=self.fs;s='\n'.join(fs[n] for n in ['Spear80_PhysicalBonus','Spear80_ElementBonus']);e=mocks(s)
  slots={6:101,7:102,8:103,0:104};raw={101:'f176',102:'g148',103:'I0F6',104:'I07Z'}
  aliases={'f176':'I0LB','g148':'I05S','I0F6':'I0F6','I07Z':'I07Z'}
  e.update(Forsaken_ActiveGear=lambda u,slot:slots.get(slot),GetItemTypeId=lambda it:raw.get(it,''),BlzGetItemEquipmentType=lambda it:1,EQUIPMENT_TYPE_NONE=0,ForsakenElementSources=0,LoadInteger=lambda table,parent,k:aliases.get(k,0),Talent_HealingPower=lambda u:1.)
  e=execute(s,['Spear80_PhysicalBonus','Spear80_ElementBonus'],e)
  self.assertAlmostEqual(e['Spear80_PhysicalBonus'](1),1.6) # .6 Longinus + 1.0 Holy; unequipped Zodiac excluded
  self.assertAlmostEqual(e['Spear80_ElementBonus'](1,1),.25)
  self.assertEqual(e['Spear80_ElementBonus'](1,4),0)
 def test_block_reduction_is_percentage_points_and_clamps_at_no_blocks(self):
  s=self.fs['Trig_Damage_Engine_RollBlock'];e=mocks(s)
  e.update(Forsaken_ElementAbilityLevel=lambda u,a:1 if a=='A05B' else 0,GetRandomInt=lambda low,high:20,LoadInteger=lambda *a:0)
  e=execute(s,['Trig_Damage_Engine_RollBlock'],e)
  self.assertTrue(e['Trig_Damage_Engine_RollBlock'](2,True,False,0))
  self.assertFalse(e['Trig_Damage_Engine_RollBlock'](2,True,False,1))
  e['GetRandomInt']=lambda *a:1
  self.assertFalse(e['Trig_Damage_Engine_RollBlock'](2,True,False,30))
 def test_mana_sync_changes_only_on_proficiency_or_hero_state_change(self):
  s=self.fs['Spear80_SyncMana'];e=mocks(s);levels={};saved={};writes=[];prof=[4]
  e.update(GetUnitTypeId=lambda hero:1,Prof_GetLevel=lambda *a:prof[0],GetUnitAbilityLevel=lambda hero,raw:levels.get(hero,0),GetHandleId=lambda hero:hero,ForsakenElementSources=1,LoadInteger=lambda t,p,k:saved.get((p,k),0),HaveSavedInteger=lambda t,p,k:(p,k) in saved,RemoveSavedInteger=lambda t,p,k:saved.pop((p,k),None),SaveInteger=lambda t,p,k,v:saved.__setitem__((p,k),v),UnitAddAbility=lambda hero,raw:levels.__setitem__(hero,1),UnitRemoveAbility=lambda hero,raw:levels.pop(hero,None),UnitMakeAbilityPermanent=lambda *a:None,BlzGetUnitAbility=lambda *a:1,BlzSetAbilityRealLevelField=lambda a,f,rank,value:writes.append(value),ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL=1,I2R=float,SetUnitAbilityLevel=lambda hero,raw,rank:levels.__setitem__(hero,rank))
  e=execute(s,['Spear80_SyncMana'],e)
  e['Spear80_SyncMana'](1);self.assertEqual(writes,[.4,.4])
  e['Spear80_SyncMana'](1);self.assertEqual(len(writes),2)
  prof[0]=7;e['Spear80_SyncMana'](1);self.assertAlmostEqual(writes[-1],.7)
  prof[0]=0;e['Spear80_SyncMana'](1);self.assertNotIn(1,levels)
  e['Spear80_SyncMana'](1);self.assertEqual(len(writes),4)
 def test_only_drakesbane_inherits_attack_element_and_rise_stays_fire(self):
  s=self.fs['DG_Deal'];e=mocks(s);hits=[]
  e.update(Element_GetOfUnit=lambda u,p:4,ATTACK_TYPE_MELEE=1,DAMAGE_TYPE_NORMAL=1,ATTACK_TYPE_NORMAL=0,DAMAGE_TYPE_MAGIC=0,UnitDamageTarget=lambda *a:hits.append(e['udg_DamageElement']))
  e=execute(s,['DG_Deal'],e)
  e['DG_Deal'](1,2,100,True,2);e['DG_Deal'](1,2,100,False,3);e['DG_Deal'](1,2,100,True,1)
  self.assertEqual(hits,[4,1,0])
 def test_inventory_input_and_local_rendering_functions_preserved(self):
  b=functions(self.before.runtime)
  for n in b:
   if any(k in n for k in ['Backpack','QuickGear','BagScreen','Wave65','UI72','Preview75']):self.assertEqual(tokens(b[n]),tokens(self.fs[n]),n)
  for n in ['Spear80_SyncMana','Spear80_PhysicalBonus','Spear80_ElementBonus']:
   self.assertNotIn('GetLocalPlayer',self.fs[n]);self.assertNotIn('TimerStart',self.fs[n])
  self.assertIn('Inventory71_Reconcile(hero,i)\n        call Spear80_SyncMana(hero)',self.fs['Forsaken_PrepareInventories'])
  self.assertIn("LoadInteger(ForsakenElementSources,81,GetHandleId(hero))!=prof",self.fs['Spear80_SyncMana'])
if __name__=='__main__':unittest.main()
