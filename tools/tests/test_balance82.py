import sys,unittest,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_balance82 import BASE,OUT,DETAIL
from editor_pair import View
from jtok import functions,tokens
from damage_tooltips import merged
from priest_master import fields
from test_shared_context import mocks
from test_armory_materia import execute
class Balance82Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime)
 def test_separate_accuracy_multipliers_and_zero_floor(self):
  s=self.fs['DG_AccuracyMultiplier'];e=mocks(s)
  e.update(RMaxBJ=max,Trig_Damage_Engine_GetAccuracy=lambda u:120.,Trig_Damage_Engine_GetEvasion=lambda u:100.)
  e=execute(s,['DG_AccuracyMultiplier'],e)
  self.assertAlmostEqual(e['DG_AccuracyMultiplier'](1,2,.004),1.08)
  self.assertAlmostEqual(e['DG_AccuracyMultiplier'](1,2,.01),1.2)
  e['Trig_Damage_Engine_GetAccuracy']=lambda u:0.;e['Trig_Damage_Engine_GetEvasion']=lambda u:500.
  self.assertEqual(e['DG_AccuracyMultiplier'](1,2,.004),0.)
  self.assertIn('DG_BaseDamage(caster,2,0.)*DG_AccuracyMultiplier(caster,target,.004)',self.fs['DG_Area'])
  self.assertIn('DG_BaseDamage(caster,3,0.)*DG_AccuracyMultiplier(caster,target,.01)',self.fs['DG_Area'])
 def test_native_mana_scaling_and_display_agree(self):
  s=self.fs['Spear80_SyncMana'];e=mocks(s);writes=[]
  e.update(GetUnitTypeId=lambda u:1,Prof_GetLevel=lambda *a:4,GetUnitAbilityLevel=lambda *a:0,GetHandleId=lambda u:u,LoadInteger=lambda *a:0,ForsakenElementSources=1,UnitAddAbility=lambda *a:None,UnitMakeAbilityPermanent=lambda *a:None,BlzGetUnitAbility=lambda *a:1,BlzSetAbilityRealLevelField=lambda a,f,r,value:writes.append(value),ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL=1,SetUnitAbilityLevel=lambda *a:None,SaveInteger=lambda *a:None,I2R=float)
  e=execute(s,['Spear80_SyncMana'],e);e['Spear80_SyncMana'](1)
  self.assertEqual(writes,[.2,.2])
  self.assertIn(".05*I2R(Prof_GetLevel(hero,'R009'))",self.fs['Forsaken_ReadRegeneration'])
 def test_all_tooltips_and_previous_balance_preserved(self):
  a=merged(self.after.archive.read('war3map.w3a'),self.after.archive.read('war3mapSkin.w3a'),'w3a')
  q=merged(self.after.archive.read('war3map.w3q'),self.after.archive.read('war3mapSkin.w3q'),'w3q')
  for raw,coefficient in [('A03M','0.004'),('A14D','0.01')]:
   for (key,rank),val in fields(a[raw]).items():
    if key=='aub1':self.assertIn(coefficient+' x (Accuracy - target Evasion)',val);self.assertNotIn('0.02 x',val)
  for (key,rank),val in fields(q['R009']).items():
   if key=='gub1':self.assertIn(DETAIL,val)
  self.assertIn(DETAIL,fields(a['pF04'])['aub1',1])
  before=functions(self.before.runtime)
  for n in ['DG_BaseDamage','DG_Cast','Dragoon80_ScaleDrake','Spear80_PhysicalBonus','Trig_Damage_Engine_CheckBlock','Forsaken_PrepareInventories']:
   self.assertEqual(tokens(before[n]),tokens(self.fs[n]))
  for raw in ['hH79','hM79','A11R','A1E6']:
   old=merged(self.before.archive.read('war3map.w3a'),self.before.archive.read('war3mapSkin.w3a'),'w3a')
   self.assertEqual(a[raw],old[raw])
  for name in ['war3map.w3u','war3mapSkin.w3u','war3map.w3t','war3mapSkin.w3t']:self.assertEqual(self.before.archive.read(name),self.after.archive.read(name))
if __name__=='__main__':unittest.main()
