import sys,unittest,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_balance81 import BASE,OUT,FACTOR,BONUS
from build_spear80 import SPEARS
from editor_pair import View
from damage_tooltips import merged
from priest_master import fields
from jtok import functions,tokens
from downgrade import wts_read
from test_shared_context import mocks
from test_armory_materia import execute
class Balance81Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  fixtures=Path(__file__).with_name("fixtures")/"historical-maps"
  c.before=View(fixtures/BASE.parent.name/BASE.name)
  c.output=fixtures/OUT.parent.name/OUT.name
  c.after=View(c.output)
  c.fs=functions(c.after.runtime)
  c.w=wts_read(c.after.archive.read('war3map.wts'))
 def objects(self,v,ext):return merged(v.archive.read('war3map.'+ext),v.archive.read('war3mapSkin.'+ext),ext)
 def resolve(self,s):return self.w.get(int(s[8:]),s) if s.startswith('TRIGSTR_') else s
 def test_accuracy_multiplier_handles_advantage_disadvantage_and_no_negative_healing(self):
  s=self.fs['DG_AccuracyMultiplier'];e=mocks(s);acc=[100];eva=[100]
  e.update(RMaxBJ=max,Trig_Damage_Engine_GetAccuracy=lambda u:acc[0],Trig_Damage_Engine_GetEvasion=lambda u:eva[0]);e=execute(s,['DG_AccuracyMultiplier'],e)
  for a,b,expected in [(100,100,1.),(120,100,1.4),(90,100,.8),(0,100,0.)]:
   acc[0]=a;eva[0]=b;self.assertAlmostEqual(e['DG_AccuracyMultiplier'](1,2),expected)
  area=self.fs['DG_Area']
  for kind in [2,3]:self.assertIn(f'DG_BaseDamage(caster,{kind},0.)*DG_AccuracyMultiplier(caster,target)',area)
  self.assertNotIn('0.)+RMaxBJ',area)
  self.assertIn('set amount=amount*1.5',area)
 def test_actual_jump_radius_targets_includes_300_excludes_301(self):
  s=self.fs['DG_Area'];e=mocks(s);group=set();hits=[];pos={2:(300.,0.),3:(301.,0.),4:(0.,-299.)}
  e.update(DG_Hero={0:1},CreateGroup=lambda:group,GroupEnumUnitsInRange=lambda *a:group.update(pos),FirstOfGroup=lambda g:next(iter(g),None),GroupRemoveUnit=lambda g,u:g.remove(u),DG_Enemy=lambda *a:True,GetUnitX=lambda u:pos[u][0],GetUnitY=lambda u:pos[u][1],DG_BaseDamage=lambda *a:100.,DG_Distance={0:500.},DG_Deal=lambda c,t,*a:hits.append(t),DestroyGroup=lambda *a:None,DG_Fx=lambda *a:None)
  e=execute(s,['DG_Area'],e);e['DG_Area'](0,4,0.,0.,0.,0.,True);self.assertEqual(set(hits),{2,4})
 def test_house_only_rates_and_max_rank_mana(self):
  a=self.objects(self.after,'w3a');before=self.objects(self.before,'w3a')
  self.assertAlmostEqual(fields(a['hH79'])['Oar1',1],.1);self.assertEqual(fields(a['hH79'])['Oar2',1],1)
  self.assertAlmostEqual(fields(a['hM79'])['Arm1',1],.1);self.assertEqual(fields(a['hM79'])['Arm2',1],1)
  for raw in ['A001','A00F']:self.assertEqual(a[raw],before[raw])
  f=fields(a['A11R']);maxrank=f['alev',0]
  for (key,rank),value in f.items():
   if key=='amcs':self.assertEqual(value,200 if rank==maxrank else fields(before['A11R'])[key,rank])
  self.assertIn('Impact radius: 300',fields(a['A1E6'])['aub1',1])
  for raw in ['A03M','A14D']:
   for (key,rank),val in fields(a[raw]).items():
    if key=='aub1':self.assertIn(FACTOR,val)
 def test_all_house_spears_and_completed_upgrade_match_current_effects(self):
  u=self.objects(self.after,'w3u');t=self.objects(self.after,'w3t');q=self.objects(self.after,'w3q');a=self.objects(self.after,'w3a')
  report=json.loads(self.output.with_suffix('.json').read_text())
  byname={spec[0]:raw for raw,spec in SPEARS.items()}
  self.assertEqual({name for raw,name in report['armory_tooltips']},set(byname))
  for raw,name in report['armory_tooltips']:self.assertEqual(fields(u[raw])['utub',None],fields(t[byname[name]])['utub',None])
  tips=[self.resolve(val) for (key,rank),val in fields(q['R009']).items() if key=='gub1']+[self.resolve(fields(a['pF04'])['aub1',1])]
  self.assertEqual(len(tips),11)
  for s in tips:self.assertIn(BONUS,s);self.assertNotIn('Dragon Techniques',s);self.assertNotIn('Lancer',s)
 def test_input_inventory_and_previous_spear_scaling_preserved(self):
  before=functions(self.before.runtime)
  changed=json.loads(self.output.with_suffix('.json').read_text())['changed_functions']
  self.assertEqual(set(changed),{'DG_Area','SpellCalc_Data2','SpellCalc_Data13'})
  for n in ['DG_BaseDamage','DG_Cast','Dragoon80_ScaleDrake','Spear80_SyncMana','Spear80_PhysicalBonus']:
   self.assertEqual(tokens(before[n]),tokens(self.fs[n]),n)
  for name in ['war3map.w3t','war3mapSkin.w3t']:self.assertEqual(self.before.archive.read(name),self.after.archive.read(name))
if __name__=='__main__':unittest.main()

