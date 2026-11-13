import sys,unittest,re,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_forest87 import BASE,OUT
from build_forest86 import all_objects
from editor_pair import View
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
import test_forest86 as legacy
class Forest87Tests(unittest.TestCase):
 env=legacy.Forest86Tests.env
 @classmethod
 def setUpClass(c):c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime);c.a=all_objects(c.after,'w3a');c.u=all_objects(c.after,'w3u')
 def test_reduced_poison_uses_victim_level_and_keeps_chance_duration(self):
  names=['Forest86_Alive','Forest86_PoisonDamage','Forest86_OnAttack'];s,e,data,types,hp,*_=self.env(names)
  e.update(GetHeroLevel=lambda u:10,GetRandomInt=lambda *a:1,DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:None)
  e=execute(s,names,e);types[1]='nspg';e['Forest86_OnAttack'](1,2);self.assertEqual(data[2,11],25.);self.assertEqual(data[2,12],5.)
  data.clear();types[1]='nbrg';e['Forest86_OnAttack'](1,2);self.assertEqual(data[2,11],45.)
  for raw,coefficient,chance in [('fP86',2,33),('fQ86',4,15)]:
   text=fields(self.a[raw])['aub1',1];self.assertIn(f'5 + {coefficient} x poisoned hero level',text);self.assertIn(str(chance)+'%',text)
 def test_triton_alert_fifteen_second_cast_final_countdown_and_death(self):
  names=['Forest86_Alive','Forest86_Alert','Forest86_AI','Forest86_Death'];s,e,data,types,hp,floats,orders,paused=self.env(names);types[1]='nmrl';e['Forest86_InForest']=lambda *a:True
  e=execute(s,names,e);e['Forest86_Alert'](1);self.assertEqual(data[1,4],15.)
  for now in range(10,15):e['Forest86Now']=float(now);e['Forest86_AI']()
  self.assertEqual(floats[-5:],['5','4','3','2','1']);self.assertEqual(e['Forest86AlertUntil'],0.)
  e['Forest86Now']=15.;e['Forest86_AI']();self.assertEqual(e['Forest86AlertUntil'],75.)
  # Dark Goblins no longer start the alert.
  data.clear();types[1]='ndtr';e['Forest86_Alert'](1);self.assertNotIn((1,4),data)
  # Killing a second Triton before completion removes its channel.
  types[1]='nmrl';e['Forest86_Alert'](1);hp[1]=0.;e['Forest86_Death']();self.assertNotIn((1,4),data);self.assertIn((1,False),paused)
 def test_night_only_dark_goblin_and_day_night_triton_keep_existing_pools(self):
  self.assertIn('fL86',fields(self.u['nmrl'])['uabi',None]);self.assertNotIn('fL86',fields(self.u['ndtr'])['uabi',None])
  body=functions(self.after.modules['TSpawn'])['Trig_Spawn_Pools_Init_Actions']
  day=body.split('call SaveUnitPoolHandle(udg_SpawnDataHash,3,1,l_pool)')[0]
  night=body.split('call SaveUnitPoolHandle(udg_SpawnDataHash,3,1,l_pool)')[1].split('call SaveUnitPoolHandle(udg_SpawnDataHash,4,1,l_pool)')[0]
  self.assertNotIn("'ndtr'",day);self.assertIn("'ndtr',.5",night)
  self.assertIn("'nmrl'",day);self.assertIn("'nmrl'",night)
  self.assertIn('15 seconds',fields(self.a['fL86'])['aub1',1])
 def test_gnoll_taunt_three_seconds_evasion_fifteen_no_damage_reduction(self):
  names=['Forest86_Alive','Forest86_Taunt','Forest86_Order','Forest86_TauntTick','Forest86_Evasion','Forest86_Defense'];s,e,data,types,hp,floats,orders,*_=self.env(names);types[1]='ngnb';g=set()
  e.update(CreateGroup=lambda:g,GroupEnumUnitsInRange=lambda *a:g.add(2),FirstOfGroup=lambda group:next(iter(group),None),Forest86_Enemy=lambda *a:True,DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:None,DestroyGroup=lambda *a:None,Forest86_TauntOrder=lambda victim,caster:orders.append((victim,'attack',caster)),GetTriggerUnit=lambda:2,GetEnumUnit=lambda:2,GetIssuedOrderId=lambda:1,OrderId=lambda *a:2,GetOrderTargetUnit=lambda:None)
  e=execute(s,names,e);e['Forest86_Taunt'](1);self.assertEqual(data[2,21],3.);self.assertEqual(data[1,22],15.)
  self.assertEqual(e['Forest86_Evasion'](1),40.);self.assertEqual(e['Forest86_Defense'](1),1.)
  e['Forest86Now']=3.;orders.clear();e['Forest86_Order']();e['Forest86_TauntTick']();self.assertEqual(orders,[]);self.assertEqual(e['Forest86_Evasion'](1),40.)
  e['Forest86Now']=14.9;self.assertEqual(e['Forest86_Evasion'](1),40.)
  e['Forest86Now']=15.;self.assertEqual(e['Forest86_Evasion'](1),0.)
  self.assertEqual(fields(self.a['fT86'])['acdn',1],20.);self.assertEqual(fields(self.a['fT86'])['amcs',1],25)
  text=fields(self.a['fT86'])['aub1',1];self.assertIn('3 seconds',text);self.assertIn('40 increased evasion for 15 seconds',text);self.assertNotIn('less damage',text)
 def test_recent_work_and_all_other_behavior_preserved(self):
  old=functions(self.before.runtime);changes={n for n in old if tokens(old[n])!=tokens(self.fs[n])}
  self.assertEqual(changes,{'Forest86_Actor','Forest86_Alert','Forest86_Death','Forest86_OnAttack','Forest86_Taunt','Forest86_Defense','Forest86_Evasion'})
  self.assertEqual(set(old),set(self.fs))
  before=all_objects(self.before,'w3u')
  for raw in before:
   for key,val in fields(before[raw]).items():
    if raw in ['nmrl','ndtr','nspg','nbrg','ngnb'] and key[0] in ['utub','uabi']:continue
    self.assertEqual(fields(self.u[raw])[key],val,(raw,key))
  self.assertAlmostEqual(fields(self.a['hH79'])['Oar1',1],.07)
  self.assertAlmostEqual(fields(self.a['hM79'])['Arm1',1],.07)
if __name__=='__main__':unittest.main()
