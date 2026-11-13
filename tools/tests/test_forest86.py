"""Behavior checks for the Guardia Forest prototype, using the actual built JASS."""
import sys,unittest,json,math
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_forest86 import BASE,OUT,all_objects,RAW
from editor_pair import View
from priest_master import fields
from jtok import functions,tokens
from test_shared_context import mocks
from test_armory_materia import execute
class Forest86Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime);c.a=all_objects(c.after,'w3a');c.u=all_objects(c.after,'w3u')
 def env(self,names):
  s='\n'.join(self.fs[n] for n in names);e=mocks(s);data={};types={1:'ndtr',2:'H000',3:'nfsh'};hp={1:100.,2:1000.,3:300.};floats=[];orders=[];dead=[]
  e.update(Forest86Data=data,Forest86Now=0.,Forest86AlertUntil=0.,Forest86AlertActive=False,Forest86OrderGuard=False,Forest86Actors={1,3},Forest86Poisoned=set(),Forest86Taunted=set(),udg_SpecialUnits=set(),Player=lambda i:i,GetOwningPlayer=lambda u:11 if u!=2 else 0,GetUnitTypeId=lambda u:types.get(u,0),GetHandleId=lambda u:u,GetWidgetLife=lambda u:hp.get(u,0.),GetEnumUnit=lambda:1,GetTriggerUnit=lambda:1,GetUnitUserData=lambda u:1,IsUnitType=lambda u,t:u==2,UNIT_TYPE_HERO=1,UNIT_TYPE_STRUCTURE=2,IsUnitInGroup=lambda u,g:u in g,IsUnitAlly=lambda *a:True,IsUnitEnemy=lambda *a:True,IsUnitPaused=lambda *a:False,IsUnitHidden=lambda *a:False,udg_InCinematicMode=False,Forest86_Find=lambda *a:None,Forest86_Ready=lambda *a:False,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,PauseUnit=lambda u,v:dead.append((u,v)),SetUnitAnimation=lambda *a:None,ResetUnitAnimation=lambda *a:None,IssueImmediateOrder=lambda *a:orders.append(a),IssueTargetOrder=lambda *a:orders.append(a),IssuePointOrder=lambda *a:orders.append(a),Forest86_Float=lambda u,text:floats.append(text),ExecuteFunc=lambda name:orders.append(('exec',name)),R2I=int,I2S=str,I2R=float,GroupRemoveUnit=lambda g,u:g.discard(u),GroupAddUnit=lambda g,u:g.add(u),FlushChildHashtable=lambda t,parent:[t.pop(k) for k in list(t) if k[0]==parent],HaveSavedReal=lambda t,p,c:(p,c) in t,HaveSavedInteger=lambda t,p,c:(p,c) in t,LoadBoolean=lambda t,p,c:t.get((p,c),False),LoadReal=lambda t,p,c:t.get((p,c),0.),LoadInteger=lambda t,p,c:t.get((p,c),0),LoadUnitHandle=lambda t,p,c:t.get((p,c)),SaveBoolean=lambda t,p,c,v:t.__setitem__((p,c),v),SaveReal=lambda t,p,c,v:t.__setitem__((p,c),v),SaveInteger=lambda t,p,c,v:t.__setitem__((p,c),v),SaveUnitHandle=lambda t,p,c,v:t.__setitem__((p,c),v),RemoveSavedReal=lambda t,p,c:t.pop((p,c),None),RemoveSavedHandle=lambda t,p,c:t.pop((p,c),None),SetUnitState=lambda *a:None,UNIT_STATE_MANA=0,UNIT_STATE_MAX_MANA=1)
  return s,e,data,types,hp,floats,orders,dead
 def test_normal_object_stats_and_damage_ranges(self):
  expected={'nfsh':{'ulev':5,'udef':5.,'udty':'none','umpm':300},'nftb':{'ulev':5,'uhpm':350,'udef':10.},'nfsp':{'uhpm':200},'ndtp':{'uhpm':350,'udef':7.},'ngnb':{'ulev':4,'uhpm':440,'udef':11.,'umpm':100}}
  for raw,wanted in expected.items():
   f=fields(self.u[raw])
   for k,v in wanted.items():self.assertEqual(f[k,None],v,(raw,k))
  for raw,low,high in [('nfsh',15,23),('nfsp',6,12)]:
   f=fields(self.u[raw]);self.assertEqual(f['ua1b',None]+f['ua1d',None],low);self.assertEqual(f['ua1b',None]+f['ua1d',None]*f['ua1s',None],high)
  self.assertIn('A03N',fields(self.u['nwlt'])['uabi',None]);self.assertNotIn('ACcs',fields(self.u['nfsp'])['uabi',None]);self.assertEqual(fields(self.u['nfsp'])['udaa',None],'fH86')
 def test_native_spell_values_and_real_data_pointers(self):
  for raw,values in {'fD86':{'amcs':200},'fT86':{'amcs':25,'acdn':15.},'fR86':{'bsk2':.3,'bsk3':.3,'adur':10.,'acdn':30.},'fH86':{'Hea1':25.,'amcs':10},'fA86':{'Had1':.1,'Had2':1},'fS86':{'Htb1':0.,'adur':1.,'ahdu':1.}}.items():
   f=fields(self.a[raw])
   for key,value in values.items():self.assertAlmostEqual(f[key,1],value,places=6,msg=(raw,key))
  self.assertEqual(fields(self.a['fN86'])['acdn',1],15.);self.assertEqual(fields(self.a['fN86'])['aran',1],500.)
  for raw,key,data in [('fA86','Had1',1),('fA86','Had2',2),('fH86','Hea1',1),('fR86','bsk2',2),('fR86','bsk3',3),('hH79','Oar1',1),('hM79','Arm1',1)]:
   m=next(m for st in self.a[raw]['sets'] for m in st['mods'] if m['field']==key and m['level']==1);self.assertEqual(m['data'],data)
  self.assertAlmostEqual(fields(self.a['hH79'])['Oar1',1],.07);self.assertAlmostEqual(fields(self.a['hM79'])['Arm1',1],.07)
 def test_devour_pool_only_and_unlocks_blizzaga_on_success(self):
  names=['Forest86_Alive','Forest86_Pool','Forest86_DevourValid','Forest86_Spell'];s,e,data,types,hp,*_=self.env(names);types[2]='nfsp';hp[2]=200.;e['IsUnitType']=lambda *a:False
  removed=[];added=[];g={2};e.update(GetTriggerUnit=lambda:3,GetSpellTargetUnit=lambda:2,GetSpellAbilityId=lambda:'fD86',udg_SpawnTimerHash={},LoadGroupHandle=lambda *a:g,RemoveUnit=lambda u:removed.append(u),UnitAddAbility=lambda *a:added.append(a),DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:None,RMinBJ=min,GetUnitState=lambda *a:0.,BlzEndUnitAbilityCooldown=lambda *a:None)
  e=execute(s,names,e);self.assertTrue(e['Forest86_DevourValid'](3,2));types[2]='n0BS';self.assertFalse(e['Forest86_DevourValid'](3,2));types[2]='nfsp';e['Forest86_Spell']()
  self.assertEqual(removed,[2]);self.assertIn((3,'fB86'),added);self.assertTrue(data[3,1]);self.assertNotIn(2,g)
 def test_alert_final_countdown_success_and_once_per_goblin(self):
  names=['Forest86_Alive','Forest86_Alert','Forest86_AI','Forest86_SpawnFactor'];s,e,data,types,hp,floats,orders,paused=self.env(names);e['Forest86_InForest']=lambda *a:True
  e=execute(s,names,e);e['Forest86_Alert'](1);self.assertEqual(floats,['Calling Reinforcements']);self.assertIn((1,True),paused)
  for now in range(5,10):e['Forest86Now']=float(now);e['Forest86_AI']()
  self.assertEqual(floats[-5:],['5','4','3','2','1'])
  e['Forest86Now']=10.;e['Forest86_AI']();self.assertEqual(e['Forest86AlertUntil'],70.);self.assertIn((1,False),paused)
  self.assertEqual(e['Forest86_SpawnFactor'](1),2);self.assertEqual(e['Forest86_SpawnFactor'](2),1)
  e['Forest86_Alert'](1);self.assertNotIn((1,4),data)
  e['Forest86Now']=70.;self.assertEqual(e['Forest86_SpawnFactor'](1),1)
 def test_killing_alert_goblin_cancels_countdown_and_reinforcements(self):
  names=['Forest86_Alive','Forest86_Alert','Forest86_AI','Forest86_Death'];s,e,data,types,hp,floats,orders,paused=self.env(names);e['Forest86_InForest']=lambda *a:True
  e=execute(s,names,e);e['Forest86_Alert'](1);e['Forest86Now']=9.;hp[1]=0.;e['Forest86_Death']();e['Forest86_AI']();self.assertEqual(e['Forest86AlertUntil'],0.);self.assertFalse(e['Forest86AlertActive']);self.assertEqual(floats,['Calling Reinforcements'])
 def test_poison_uses_victim_hero_level_exact_chances_and_five_ticks(self):
  names=['Forest86_Alive','Forest86_PoisonDamage','Forest86_OnAttack','Forest86_PoisonTick'];s,e,data,types,hp,*_=self.env(names);types[1]='nspg';e.update(GetHeroLevel=lambda u:10,GetRandomInt=lambda *a:33,GetEnumUnit=lambda:2,AddSpecialEffectTarget=lambda *a:None,DestroyEffect=lambda *a:None,ATTACK_TYPE_NORMAL=1,DAMAGE_TYPE_MAGIC=2)
  damage=[];e['UnitDamageTarget']=lambda a,v,d,*rest:damage.append(d);e=execute(s,names,e);e['Forest86_OnAttack'](1,2);self.assertEqual(data[2,11],255.)
  for now in range(1,7):e['Forest86Now']=float(now);e['Forest86_PoisonTick']()
  self.assertEqual(damage,[255.]*5)
  e['Forest86Now']=10.;types[1]='nbrg';e['GetRandomInt']=lambda *a:15;e['Forest86_OnAttack'](1,2);self.assertEqual(data[2,11],355.)
  data.clear();e['GetRandomInt']=lambda *a:16;e['Forest86_OnAttack'](1,2);self.assertNotIn((2,11),data)
  types[1]='nspg';e['GetRandomInt']=lambda *a:34;e['Forest86_OnAttack'](1,2);self.assertNotIn((2,11),data)
 def test_taunt_forces_attack_stops_at_five_seconds_and_reduces_damage(self):
  names=['Forest86_Alive','Forest86_TauntOrder','Forest86_Order','Forest86_Defense','Forest86_TauntTick'];s,e,data,types,hp,floats,orders,*_=self.env(names);types[1]='ngnb';data.update({(2,20):1,(2,21):5.,(1,22):5.});e['Forest86Taunted']={2};e.update(GetTriggerUnit=lambda:2,GetEnumUnit=lambda:2,GetIssuedOrderId=lambda:1,OrderId=lambda s:2,GetOrderTargetUnit=lambda:None)
  e=execute(s,names,e);e['Forest86_Order']();self.assertIn((2,'attack',1),orders);self.assertEqual(e['Forest86_Defense'](1),.8)
  e['Forest86Now']=5.;orders.clear();e['Forest86_Order']();e['Forest86_TauntTick']();self.assertEqual(orders,[]);self.assertEqual(e['Forest86_Defense'](1),1.);self.assertNotIn(2,e['Forest86Taunted'])
 def test_bandit_evasive_action_expires_after_ten_seconds(self):
  names=['Forest86_Evasion'];s,e,data,types,*_=self.env(names);types[1]='nbld';data[1,30]=10.;e=execute(s,names,e)
  self.assertEqual(e['Forest86_Evasion'](1),40.);e['Forest86Now']=10.;self.assertEqual(e['Forest86_Evasion'](1),0.)
 def test_ai_issues_correct_ready_spells_and_does_not_control_players(self):
  names=['Forest86_AI'];s,e,data,types,hp,floats,orders,*_=self.env(names);ready=[None];mode=[]
  e.update(Forest86_Alive=lambda u:hp.get(u,0.)>.405,Forest86_Find=lambda u,m:mode.append(m) or 2,Forest86_Ready=lambda u,raw,cost:raw==ready[0],GetUnitAbilityLevel=lambda *a:0)
  e=execute(s,names,e)
  for unit,ability,expected in [('nfsp','fH86','heal'),('nfsh','fD86','devour'),('nftb','fR86','berserk'),('ngnb','fT86','roar'),('nbld','fE86','howlofterror'),('nftt','fN86','ensnare'),('n0BS','fI86','firebolt')]:
   types[1]=unit;ready[0]=ability;orders.clear();e['Forest86_AI']();self.assertTrue(orders,(unit,orders));self.assertEqual(orders[0][1],expected,(unit,orders))
  types[1]='nfsh';data[1,1]=True;ready[0]='fB86';orders.clear();e['Forest86_AI']();self.assertEqual(orders[0][1],'shockwave')
  e['GetOwningPlayer']=lambda u:0;orders.clear();e['Forest86_AI']();self.assertEqual(orders,[])
 def test_spawn_amount_cap_and_frequency_hooks_are_forest_only(self):
  n='Trig_Zone_Spawn_System_SpawnZoneUnits';s=self.fs[n];e=mocks(s);group=set();spawned=[];factor=[2]
  e.update(udg_SpawnDataHash={},udg_SpawnTimerHash={},udg_SpawnRectHash={},LoadInteger=lambda table,key,zone:{2:1,7:20}.get(key,0),LoadGroupHandle=lambda *a:group,Trig_Zone_Spawn_System_GroupSize=lambda g:len(g),Forest86_SpawnFactor=lambda zone:factor[0] if zone==1 else 1,Trig_Damage_Engine_IsNight=lambda:False,udg_HellSpawnsActive=False,LoadUnitPoolHandle=lambda *a:1,LoadRectHandle=lambda *a:1,GetRandomInt=lambda *a:1,GetRandomReal=lambda *a:0.,GetRectMinY=lambda *a:0.,GetRectMaxY=lambda *a:0.,GetRectMinX=lambda *a:0.,GetRectMaxX=lambda *a:0.,Player=lambda i:i,PlaceRandomUnit=lambda *a:spawned.append(len(spawned)+100) or spawned[-1],SetUnitUserData=lambda *a:None,GroupAddUnit=lambda g,u:g.add(u),Trig_Zone_Spawn_System_ScaleSpawnHP=lambda *a:None,udg_EternityMode=False,SetUnitState=lambda *a:None,GetUnitState=lambda *a:100.,UNIT_STATE_MANA=0,UNIT_STATE_MAX_MANA=1,GetUnitTypeId=lambda *a:'nfsh',IssuePointOrderById=lambda *a:None)
  e=execute(s,[n],e);e[n](1,10);self.assertEqual(len(spawned),20)
  group.clear();spawned.clear();factor[0]=1;e[n](1,10);self.assertEqual(len(spawned),10)
  self.assertIn('30./I2R(Forest86_SpawnFactor(1))',self.fs['Forest86_UpdateSpawnTimer'])
 def test_stinger_bio_only_has_twenty_percent_reduction(self):
  s=self.fs['Trig_Bio_Cast_Actions'];e=mocks(s);values=[];raw=['A10N']
  e.update(GetTriggerUnit=lambda:1,GetUnitLoc=lambda *a:0,CreateNUnitsAtLocFacingLocBJ=lambda *a:None,GetOwningPlayer=lambda *a:11,RemoveLocation=lambda *a:None,GetLastCreatedUnit=lambda:2,GetHandleIdBJ=lambda u:u,SaveUnitHandleBJ=lambda *a:None,udg_ProxyDamageHash={},BlzGetAbilityManaCost=lambda *a:200,GetSpellAbilityId=lambda:raw[0],Abil_GetLevel=lambda *a:0,Trig_Bio_Cast_IsHero=lambda:False,Prof_InnerManaPower=lambda *a:1.5,I2R=float,SaveRealBJ=lambda value,*a:values.append(value),SaveIntegerBJ=lambda *a:None,ShowUnitHide=lambda *a:None,UnitApplyTimedLifeBJ=lambda *a:None,UnitAddAbilityBJ=lambda *a:None,SetUnitAbilityLevelSwapped=lambda *a:None,IssueTargetOrderBJ=lambda *a:None,GetSpellTargetUnit=lambda:3)
  e=execute(s,['Trig_Bio_Cast_Actions'],e);e['Trig_Bio_Cast_Actions']();raw[0]='fI86';e['Trig_Bio_Cast_Actions']();self.assertAlmostEqual(values[1],values[0]*.8)
  self.assertIn('fI86',fields(self.u['n0BS'])['uabi',None]);self.assertNotIn('A10N',fields(self.u['n0BS'])['uabi',None])
 def test_world_callbacks_ignore_unrelated_and_player_owned_units(self):
  names=['Forest86_Actor','Forest86_Entered','Forest86_Death'];s,e,data,types,hp,*_=self.env(names);changes=[]
  e.update(GetTriggerUnit=lambda:9,FlushChildHashtable=lambda *a:changes.append('flush'),Forest86_Track=lambda *a:changes.append('track'))
  types[9]='n000';e=execute(s,names,e);e['Forest86_Entered']();e['Forest86_Death']();self.assertEqual(changes,[])
  types[9]='nfsh';e['GetOwningPlayer']=lambda *a:0;e['Forest86_Entered']();self.assertEqual(changes,[])
  e['GetOwningPlayer']=lambda *a:11;e['Forest86_Entered']();self.assertEqual(changes,['flush','track'])
 def test_shared_only_bounded_heartbeat_and_recent_hero_fixes_preserved(self):
  new='\n'.join(b for n,b in self.fs.items() if n.startswith('Forest86_'))
  self.assertNotIn('GetLocalPlayer',new);self.assertNotIn('BlzGetLocal',new);self.assertNotIn('IsUnitVisible',new)
  self.assertEqual(new.count('TimerStart(CreateTimer(),1.,true'),1)
  old=functions(self.before.runtime)
  for n in ['DG_Deal','DG_BaseDamage','DG_Area','Dragoon80_ScaleDrake','Spear80_SyncMana','Forsaken_BackpackToggleAction','Forsaken_BackpackCloseAction','Trig_HolySwordsman_Eclipse_Actions']:
   self.assertEqual(tokens(old[n]),tokens(self.fs[n]),n)
if __name__=='__main__':unittest.main()
