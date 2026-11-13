import sys,unittest,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_spear83 import BASE,OUT,POISON,PASSIVE
from editor_pair import View
from objdata import read_objects
from damage_tooltips import merged
from priest_master import fields
from jtok import functions,tokens
from test_shared_context import mocks
from test_armory_materia import execute
class Spear83Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime)
 def test_native_damage_pointer_not_only_numeric_value(self):
  found=0
  for name in ['war3map.w3a','war3mapSkin.w3a']:
   d=self.after.archive.read(name)
   if not d:continue
   for o in read_objects(d,'w3a')['custom']:
    if o['id']=='A1CP':
     mods=[m for st in o['sets'] for m in st['mods'] if m['field']=='Iatt'];self.assertTrue(mods)
     for m in mods:self.assertEqual((m['value'],m['level'],m['data'],m['type']),(800,1,1,0));found+=1
  self.assertGreater(found,0)
  t=merged(self.after.archive.read('war3map.w3t'),self.after.archive.read('war3mapSkin.w3t'),'w3t')
  for o in t.values():
   f=fields(o)
   if 'Zodiac Spear' in f.get(('unam',None),''):self.assertIn('A1CP',f['iabi',None])
 def test_poison_panel_is_equipped_only_and_shows_level_calculation(self):
  s=self.fs['Forsaken_RenderGearDamage'];e=mocks(s);rows=[];equipped=[True];level=[20]
  e.update(Forsaken_StatAbilityLevel=lambda u,raw:int(raw=='A0PH' and equipped[0]),Forsaken_StatGun=lambda u:False,IsUnitType=lambda *a:False,UNIT_TYPE_MELEE_ATTACKER=1,Forsaken_WeaponType=lambda *a:False,GetUnitLevel=lambda u:level[0],I2S=str,Forsaken_StatRow=lambda *a:rows.append(a))
  e=execute(s,['Forsaken_RenderGearDamage'],e);e['Forsaken_RenderGearDamage'](1,10);self.assertEqual(rows,[(10,'Attacks poison enemies','65 DPS')])
  rows.clear();level[0]=99;e['Forsaken_RenderGearDamage'](1,10);self.assertEqual(rows[0][2],'302 DPS')
  rows.clear();equipped[0]=False;e['Forsaken_RenderGearDamage'](1,10);self.assertEqual(rows,[])
 def test_all_poison_tooltip_surfaces_and_damage_duration(self):
  report=json.loads(OUT.with_suffix('.json').read_text())
  for name,raw in report['poison_tooltips']:
   ext=name.rsplit('.',1)[1];t=merged(self.after.archive.read('war3map.'+ext),self.after.archive.read('war3mapSkin.'+ext),ext);f=fields(t[raw]);self.assertIn(POISON,f['utub',None])
   if ext=='w3t':self.assertIn(POISON,f['ides',None])
  a=merged(self.after.archive.read('war3map.w3a'),self.after.archive.read('war3mapSkin.w3a'),'w3a')
  for raw in ['A0PH','A0PG']:self.assertEqual(fields(a[raw])['aub1',1],PASSIVE)
  self.assertEqual(fields(a['A0PG'])['adur',1],10.)
  self.assertEqual(fields(a['A0PG'])['ahdu',1],10.)
  physical=self.fs['Trig_Damage_Engine_Step12_PhysicalSkills'];self.assertIn('if(l_physical and l_amount>.0)then\n        set l_amount=l_amount*(1.+Spear80_PhysicalBonus(u))',physical)
  self.assertIn('SaveReal(udg_ProxyDamageHash,l_tmp,1,(GetUnitLevel(u)*3)+5.)',physical)
 def test_rise_is_physical_and_fire_while_other_spells_preserve_route(self):
  s=self.fs['DG_Deal'];e=mocks(s);hits=[]
  e.update(Element_GetOfUnit=lambda *a:4,ATTACK_TYPE_MELEE=1,DAMAGE_TYPE_NORMAL=1,ATTACK_TYPE_NORMAL=2,DAMAGE_TYPE_MAGIC=2,UnitDamageTarget=lambda *a:hits.append((e['udg_IsPhysicalAttack'],e['udg_DamageElement'],a[5],a[6])))
  e=execute(s,['DG_Deal'],e)
  e['DG_Deal'](1,2,100,False,3);self.assertEqual(hits[-1],(True,1,1,1))
  e['DG_Deal'](1,2,100,True,2);self.assertEqual(hits[-1],(True,4,1,1))
  e['DG_Deal'](1,2,100,True,1);self.assertEqual(hits[-1],(True,0,1,1))
  a=merged(self.after.archive.read('war3map.w3a'),self.after.archive.read('war3mapSkin.w3a'),'w3a')
  for (key,rank),val in fields(a['A14D']).items():
   if key=='aub1':self.assertIn('Physical Fire damage:',val)
  # Physical classification selects the existing physical-source bonus step;
  # the element step remains unchanged and independently applies Fire bonuses.
  self.assertIn('Spear80_PhysicalBonus(u)',self.fs['Trig_Damage_Engine_Step12_PhysicalSkills'])
  self.assertIn('if(l_physical and l_amount>.0)then',self.fs['Trig_Damage_Engine_Step12_PhysicalSkills'])
 def test_only_panel_function_changes_and_existing_balance_preserved(self):
  old=functions(self.before.runtime);changed={n for n in old if tokens(old[n])!=tokens(self.fs[n])};self.assertEqual(changed,{'Forsaken_RenderGearDamage','DG_Deal','SpellCalc_Data13'})
  before=merged(self.before.archive.read('war3map.w3a'),self.before.archive.read('war3mapSkin.w3a'),'w3a');after=merged(self.after.archive.read('war3map.w3a'),self.after.archive.read('war3mapSkin.w3a'),'w3a')
  for raw in before:
   if raw not in ['A1CP','A0PH','A0PG','A14D']:self.assertEqual(before[raw],after[raw],raw)
if __name__=='__main__':unittest.main()
