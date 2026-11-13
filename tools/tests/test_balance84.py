import sys,unittest,math
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_balance84 import BASE,OUT
from editor_pair import View
from jtok import functions,tokens
from damage_tooltips import merged
from priest_master import fields
from test_shared_context import mocks
from test_armory_materia import execute
class Balance84Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime)
 def test_sonic_str_and_stacks_execute(self):
  s=self.fs['DG_BaseDamage'];e=mocks(s);e.update(Prof_GetLevel=lambda *a:10,BlzGetAbilityManaCost=lambda *a:200,Abil_GetLevel=lambda *a:0,I2R=float,GetHeroStr=lambda *a:100,RMinBJ=min)
  e=execute(s,['DG_BaseDamage'],e);self.assertEqual(e['DG_BaseDamage'](1,1,0.),2800.)
  s=self.fs['DG_Area'];e=mocks(s);g=set();data={};hits={0:set()}
  e.update(SquareRoot=math.sqrt,DG_Hero={0:1},DG_Target={0:2},DG_Hits=hits,DG_Data=1,DG_Debuffed=set(),CreateGroup=lambda:g,GroupEnumUnitsInRange=lambda *a:g.add(2),FirstOfGroup=lambda group:next(iter(group),None),GroupRemoveUnit=lambda group,u:group.remove(u),DG_Enemy=lambda *a:True,GetUnitX=lambda u:100.,GetUnitY=lambda u:0.,IsUnitInGroup=lambda u,group:u in group,DG_Line=lambda *a:True,GroupAddUnit=lambda group,u:group.add(u),GetHandleId=lambda u:u,LoadUnitHandle=lambda *a:2,SaveUnitHandle=lambda *a:None,SaveReal=lambda t,p,c,value:data.__setitem__((p,c),value),DG_Reduction=lambda u:data.get((u,1),0.),DG_BaseDamage=lambda *a:100.,DG_Deal=lambda *a:None,DG_Impact=lambda *a:None,DestroyGroup=lambda *a:None)
  e=execute(s,['DG_Area'],e)
  for expected in [5.,10.,15.]:
   hits[0].clear();e['DG_Area'](0,1,0.,0.,100.,0.,True);self.assertEqual(data[2,1],expected)
 def test_accuracy_formula_and_inherent_evasion_floor(self):
  s=self.fs['DG_AccuracyMultiplier'];e=mocks(s);e.update(Trig_Damage_Engine_GetAccuracy=lambda u:120.,Trig_Damage_Engine_GetEvasion=lambda u:100.)
  e=execute(s,['DG_AccuracyMultiplier'],e);self.assertAlmostEqual(e['DG_AccuracyMultiplier'](1,2,.006),1.12)
  self.assertNotIn('RMaxBJ',s)
  old=functions(self.before.runtime)
  for n in ['Trig_Damage_Engine_GetEvasion','Forsaken_Stat_GetEvasion']:
   self.assertEqual(tokens(old[n]),tokens(self.fs[n]));self.assertIn('RMaxBJ(0.',self.fs[n])
  self.assertIn('DG_AccuracyMultiplier(caster,target,.006)',self.fs['DG_Area'])
  s=self.fs['DG_Deal'];e=mocks(s);calls=[];e['UnitDamageTarget']=lambda *a:calls.append(a)
  e=execute(s,['DG_Deal'],e);e['DG_Deal'](1,2,-100.,False,3);e['DG_Deal'](1,2,0.,False,3);self.assertEqual(calls,[])
 def test_reduced_drake_scaling_and_all_ranked_tooltips(self):
  s=self.fs['Dragoon80_ScaleDrake'];e=mocks(s);damage={0:400,1:200}
  e.update(Prof_GetLevel=lambda caster,raw:20,I2R=float,R2I=int,BlzGetUnitBaseDamage=lambda u,slot:damage[slot],BlzSetUnitBaseDamage=lambda u,value,slot:damage.__setitem__(slot,value))
  e=execute(s,['Dragoon80_ScaleDrake'],e);e['Dragoon80_ScaleDrake'](1,2);self.assertEqual(damage,{0:720,1:360})
  a=merged(self.after.archive.read('war3map.w3a'),self.after.archive.read('war3mapSkin.w3a'),'w3a')
  for (key,rank),val in fields(a['A11R']).items():
   if key=='aub1':self.assertIn('4 x STR',val);self.assertIn('Evasion reduction: 5 per stack',val)
  for (key,rank),val in fields(a['A03M']).items():
   if key=='aub1':self.assertIn('1 + 0.006 x (Accuracy - target Evasion)',val);self.assertNotIn('max(0',val)
  for (key,rank),val in fields(a['A14G']).items():
   if key=='aub1':self.assertIn('1 + 0.04 x Spear Proficiency',val)
  for name in ['war3map.w3t','war3mapSkin.w3t','war3map.w3u','war3mapSkin.w3u']:self.assertEqual(self.before.archive.read(name),self.after.archive.read(name))
if __name__=='__main__':unittest.main()
