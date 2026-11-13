import sys,unittest,re
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_fixes85 import BASE,OUT
from build_balance82 import DETAIL
from editor_pair import View
from objdata import read_objects
from damage_tooltips import merged
from priest_master import fields
from jtok import functions,tokens
from downgrade import wts_read
from test_shared_context import mocks
from test_armory_materia import execute
class Fixes85Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime)
 def objects(self,v,ext):return merged(v.archive.read('war3map.'+ext),v.archive.read('war3mapSkin.'+ext),ext)
 def test_actual_native_aura_value_percentage_flag_and_data_pointer(self):
  a=self.objects(self.after,'w3a');before=self.objects(self.before,'w3a')
  for raw,rate,flag in [('hH79','Oar1','Oar2'),('hM79','Arm1','Arm2')]:
   mods=[m for st in a[raw]['sets'] for m in st['mods']];r=next(m for m in mods if m['field']==rate);p=next(m for m in mods if m['field']==flag)
   self.assertEqual((r['level'],r['data']),(1,1));self.assertAlmostEqual(r['value'],.1)
   self.assertEqual((p['level'],p['data'],p['value']),(1,2,1))
   self.assertEqual(fields(a[raw])['aare',1],350.)
  for raw in ['A001','A00F']:self.assertEqual(a[raw],before[raw])
  u=self.objects(self.after,'w3u')
  for raw in ['h006','h00N']:self.assertIn('hH79,hM79',fields(u[raw])['uabi',None])
 def test_eclipse_all_ranks_allow_proxy_damage_and_keep_signal_visual_formula(self):
  a=self.objects(self.after,'w3a');before=self.objects(self.before,'w3a')
  o=a['A04N'];mods=[m for st in o['sets'] for m in st['mods']]
  for rank in range(1,12):
   flag=next(m for m in mods if m['field']=='Uim6' and m['level']==rank);self.assertEqual((flag['value'],flag['data'],flag['type']),(1,6,0))
  for key,val in fields(before['A04N']).items():self.assertEqual(fields(o)[key],val,key)
  old=functions(self.before.runtime)['Trig_HolySwordsman_Eclipse_Actions']
  self.assertEqual(tokens(re.sub(r"(UnitApplyTimedLifeBJ\()2\.",r"\g<1>12.",old)),tokens(self.fs['Trig_HolySwordsman_Eclipse_Actions']))
 def test_master_eclipse_stores_positive_damage_and_source_for_proxy(self):
  s=self.fs['Trig_HolySwordsman_Eclipse_Actions'];e=mocks(s);saved={};lives=[];orders=[]
  e.update(GetSpellTargetUnit=lambda:None,IsUnitType=lambda *a:True,UNIT_TYPE_HERO=1,GetTriggerUnit=lambda:1,GetUnitLoc=lambda u:(0.,0.),GetOwningPlayer=lambda u:0,CreateNUnitsAtLocFacingLocBJ=lambda *a:None,GetLastCreatedUnit=lambda:2,RemoveLocation=lambda *a:None,Trig_HolySwordsman_Eclipse_HasNoTargetUnit=lambda:True,GetSpellTargetLoc=lambda:(500.,0.),SetUnitFacingToFaceLocTimed=lambda *a:None,GetHandleIdBJ=lambda u:u,udg_ProxyDamageHash=5,SaveUnitHandleBJ=lambda val,child,parent,table:saved.__setitem__((parent,child),val),SaveRealBJ=lambda val,child,parent,table:saved.__setitem__((parent,child),val),SaveIntegerBJ=lambda val,child,parent,table:saved.__setitem__((parent,child),val),GetSpellAbilityId=lambda:'A0QJ',Abil_GetLevel=lambda *a:10,BlzGetAbilityManaCost=lambda *a:200,Trig_HolySwordsman_Eclipse_CasterIsHero=lambda:True,GetHeroStatBJ=lambda *a:100,bj_HEROSTAT_STR=0,bj_HEROSTAT_INT=1,Prof_GetHybridLevel=lambda *a:10,I2R=float,ShowUnitHide=lambda *a:None,UnitApplyTimedLifeBJ=lambda seconds,*a:lives.append(seconds),UnitAddAbilityBJ=lambda *a:None,SetUnitAbilityLevelSwapped=lambda *a:None,GetUnitAbilityLevelSwapped=lambda *a:11,IssuePointOrderLocBJ=lambda *a:orders.append(a))
  e=execute(s,['Trig_HolySwordsman_Eclipse_Actions'],e);e['Trig_HolySwordsman_Eclipse_Actions']()
  self.assertEqual(saved[2,0],1);self.assertEqual(saved[2,1],2200.);self.assertEqual(saved[2,2],2);self.assertEqual(saved[2,3],7)
  self.assertEqual(lives,[12.]);self.assertEqual(orders[0][1],'impale')
 def test_all_house_proficiency_surfaces_are_concise_and_recent_balances_preserved(self):
  w=wts_read(self.after.archive.read('war3map.wts'))
  def resolve(s):return w.get(int(s[8:]),s) if s.startswith('TRIGSTR_') else s
  a=self.objects(self.after,'w3a');q=self.objects(self.after,'w3q')
  tips=[resolve(val) for (key,rank),val in fields(q['R009']).items() if key=='gub1']+[resolve(fields(a['pF04'])['aub1',1])]
  self.assertEqual(len(tips),11)
  for tip in tips:self.assertIn('Increases mana regen and reduces enemies chance to block.',tip);self.assertNotIn('Per proficiency point',tip)
  old=functions(self.before.runtime)
  changed={n for n in old if tokens(old[n])!=tokens(self.fs[n])};self.assertEqual(changed,{'Trig_HolySwordsman_Eclipse_Actions'})
  for name in ['war3map.w3u','war3mapSkin.w3u','war3map.w3t','war3mapSkin.w3t']:self.assertEqual(self.before.archive.read(name),self.after.archive.read(name))
if __name__=='__main__':unittest.main()
