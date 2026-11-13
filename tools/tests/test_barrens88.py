import sys,unittest,math
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_barrens88 import BASE,OUT,STATS,RAW
from build_forest86 import all_objects,META
from editor_pair import View
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
import test_forest86 as legacy
class Barrens88Tests(unittest.TestCase):
 env=legacy.Forest86Tests.env
 @classmethod
 def setUpClass(c):
  c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime);c.a=all_objects(c.after,'w3a');c.u=all_objects(c.after,'w3u')
 def setup(self,names):
  s,e,d,types,hp,floats,orders,paused=self.env(names)
  e.update(B88Buffs=set(),B88Charges=set(),B88AlertUntil=0.,B88AlertActive=False,B88Reflecting=False,B88ChargeTimer=1,UnitRemoveAbility=lambda *a:None,IsUnitEnemy=lambda *a:True,B88_AI=lambda *a:None,B88_Actor=lambda *a:False)
  return s,e,d,types,hp,floats,orders,paused
 def test_normal_stats_all_requested_units(self):
  for raw,(level,hp,armor,lo,hi,mana) in STATS.items():
   f=fields(self.u[raw]);self.assertEqual(f['ulev',None],level,raw)
   for key,value in [('uhpm',hp),('udef',armor),('umpm',mana)]:
    if value is not None:self.assertEqual(f[key,None],value,(raw,key))
   if lo is not None:self.assertEqual((f['ua1b',None]+f['ua1d',None],f['ua1b',None]+f['ua1d',None]*f['ua1s',None]),(lo,hi),raw)
 def test_native_spell_data_and_target_settings(self):
  checks={'bAUR':{'Ear1':.15,'Ear2':0,'Ear3':1},'bH88':{'Hea1':75.,'amcs':50},'bL88':{'Ocl1':450.},'bI88':{'Lsh1':40.},'bM88':{'Ctc3':.33,'Ctc4':.33,'Ctc2':0.},'bE88':{'Fae1':8},'bJ88':{'Rej1':600.,'adur':9.},'bN88':{'Emb1':200.},'bZ88':{'bsk2':.8,'bsk3':.25,'adur':10.},'bF88':{'amcs':150,'acdn':30.,'adur':15.},'bO88':{'amcs':50,'acdn':30.},'bOF8':{'adur':20.},'bK88':{'amcs':150,'acdn':30.},'bU88':{'amcs':100,'acdn':30.,'adur':20.},'bD88':{'amcs':250},'bQ88':{'amcs':50,'acdn':15.},'bG88':{'amcs':50,'acdn':15.}}
  for raw,checks in checks.items():
   for key,value in checks.items():
    f=fields(self.a[raw]);self.assertAlmostEqual(f[key,1],value,places=5,msg=(raw,key))
    if key in META:
     m=next(m for st in self.a[raw]['sets'] for m in st['mods'] if m['field']==key and m.get('level')==1);self.assertEqual(m['data'],int(META[key].get('data','0') or 0),(raw,key))
  for raw in ['bH88','bAUR','bJ88','bU88','bI88']:self.assertIn('friend',fields(self.a[raw])['atar',1],raw)
  for raw in ['nhrq','nstw']:
   ua=fields(self.u[raw])['uabi',None]
   for removed in (['Acht','ACcr','ACr2','ACff','Ambd'] if raw=='nhrq' else ['ACcl','ACls']):self.assertNotIn(removed,ua)
 def test_stinger_isolation_night_might_and_etem_preserved(self):
  olda=all_objects(self.before,'w3a')
  for raw in ['A10N','A03N','A1AZ','A1B0','A1B1']:self.assertEqual(self.a[raw],olda[raw],raw)
  self.assertIn('fI86',fields(self.u['n0BS'])['uabi',None])
  for raw in ['ndtr','nrzs']:self.assertIn('A03N',fields(self.u[raw])['uabi',None])
  oldfs=functions(self.before.runtime)
  for n in ['Trig_Bio_Cast_Actions','Trig_Bio_Cast_Conditions','Trig_Bio_Cast_IsBio']:self.assertEqual(tokens(self.fs[n]),tokens(oldfs[n]))
  legacy.Forest86Tests.test_stinger_bio_only_has_twenty_percent_reduction(self)
 def test_spider_poison_ten_seconds_and_victim_level(self):
  names=['Forest86_Alive','Forest86_OnAttack'];s,e,d,types,hp,*_=self.setup(names);types[1]='nspb'
  e.update(GetHeroLevel=lambda u:20,GetRandomInt=lambda *a:33,DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:None)
  e=execute(s,names,e);e['Forest86_OnAttack'](1,2);self.assertEqual(d[2,11],70.);self.assertEqual(d[2,12],10.)
  d.clear();e['GetRandomInt']=lambda *a:34;e['Forest86_OnAttack'](1,2);self.assertEqual(d,{})
 def test_block_percentages_and_evasion_expiry(self):
  names=['B88_BlockChance','Forest86_Evasion'];s,e,d,types,hp,*_=self.setup(names);e=execute(s,names,e)
  for raw,p,m in [('nban',25,15),('nbld',15,10),('nowe',15,0),('nrzg',0,0)]:
   types[1]=raw;self.assertEqual(e['B88_BlockChance'](1,True,False),p);self.assertEqual(e['B88_BlockChance'](1,False,True),m)
  types[1]='ngnb';d[1,22]=10.;self.assertEqual(e['Forest86_Evasion'](1),70.)
  types[1]='nbld';d[1,30]=10.;self.assertEqual(e['Forest86_Evasion'](1),80.)
  e['Forest86Now']=10.;self.assertEqual(e['Forest86_Evasion'](1),0.)
 def test_independent_alerts_and_countdown(self):
  names=['Forest86_Alive','B88_AlertZone','Forest86_Alert','Forest86_AI','Forest86_SpawnFactor'];s,e,d,types,hp,floats,orders,*_=self.setup(names)
  e.update(B88_InZone=lambda *a:True);types[1]='nhrr';e=execute(s,names,e);e['Forest86_Alert'](1);self.assertEqual(d[1,4],15.)
  for now in range(10,15):e['Forest86Now']=float(now);e['Forest86_AI']()
  self.assertEqual(floats[-5:],['5','4','3','2','1']);e['Forest86Now']=15.;e['Forest86_AI']()
  self.assertEqual(e['B88AlertUntil'],75.);self.assertEqual(e['Forest86AlertUntil'],0.)
  self.assertEqual(e['Forest86_SpawnFactor'](2),2);self.assertEqual(e['Forest86_SpawnFactor'](1),1);self.assertEqual(e['Forest86_SpawnFactor'](3),1)
  d.clear();types[1]='nmrl';e['Forest86_Alert'](1);e['Forest86Now']=30.;e['Forest86_AI']();self.assertEqual(e['Forest86AlertUntil'],90.)
 def test_devour_allowlist_unlock_and_refund(self):
  names=['B88_Pool','B88_Spell'];s,e,d,types,hp,*_=self.setup(names);types[1]='nqbh';types[2]='nrzs';added=[];removed=[];refund=[]
  e.update(Forest86_Alive=lambda u:u is not None,IsUnitType=lambda *a:False,LoadGroupHandle=lambda *a:None,udg_SpawnTimerHash={},RemoveUnit=lambda u:removed.append(u),UnitAddAbility=lambda *a:added.append(a),GetUnitState=lambda *a:0.,SetUnitState=lambda *a:refund.append(a),RMinBJ=min,BlzEndUnitAbilityCooldown=lambda *a:None)
  e=execute(s,names,e);e['B88_Spell'](1,2,'bD88');self.assertEqual(removed,[2]);self.assertIn((1,'bR88'),added)
  types[2]='nfsp';removed.clear();e['B88_Spell'](1,2,'bD88');self.assertEqual(removed,[]);self.assertTrue(refund)
  self.assertIn("'nowk'",self.fs['B88_Pool']);self.assertIn("'n0L0'",self.fs['B88_Pool'])
 def test_swipe_bleed_quills_and_buff_expiry(self):
  names=['B88_Active','B88_Buff','B88_Spell','B88_BuffTick'];s,e,d,types,hp,*_=self.setup(names);hits=[];e.update(B88_Damage=lambda *a:hits.append(a),Forest86_Alive=lambda u:u is not None,Forest86_Enemy=lambda *a:True,BlzGetUnitMaxHP=lambda u:2000,UnitAddAbility=lambda *a:None,GetEnumUnit=lambda:2,DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:None)
  e=execute(s,names,e);e['B88_Spell'](1,2,'bB88');self.assertEqual(hits[-1][2],300.)
  for now in [1.,2.,3.]:e['Forest86Now']=now;e['B88_BuffTick']()
  self.assertEqual([h[2] for h in hits],[300.,20.,20.,20.]);self.assertNotIn(2,e['B88Buffs'])
  quills=[];e['B88_Quill']=lambda *a:quills.append(a);e['B88_Spell'](1,2,'bQ88');self.assertEqual(quills,[(1,2,-25.),(1,2,0.),(1,2,25.)])
  e['B88_Spell'](1,2,'bU88');self.assertEqual(d[2,44],23.);self.assertTrue(e['B88_Active'](2,44));e['Forest86Now']=23.;self.assertFalse(e['B88_Active'](2,44))
 def test_thorns_both_damage_kinds_and_no_recursion(self):
  names=['B88_Active','B88_Thorns'];s,e,d,types,hp,*_=self.setup(names);types[2]='nowe';d[2,42]=5.;hits=[]
  e.update(Forest86_Alive=lambda *a:True,B88_Damage=lambda *a:hits.append(a));e=execute(s,names,e)
  e['B88_Thorns'](1,2,200.);self.assertEqual(hits[-1],(2,1,20.,False));self.assertFalse(e['B88Reflecting'])
  e['B88Reflecting']=True;e['B88_Thorns'](1,2,200.);self.assertEqual(len(hits),1)
  e['B88Reflecting']=False;e['Forest86Now']=5.;e['B88_Thorns'](1,2,200.);self.assertEqual(len(hits),1)
 def test_charge_locks_facing_moves_and_applies_correct_impact(self):
  names=['B88_ChargeStep','B88_ChargeEnd'];s,e,d,types,hp,floats,orders,paused=self.setup(names);types[1]='nrzg';d[1,60]=2;d[1,61]=3.;xy={1:[0.,0.],2:[300.,0.]};buffs=[];hits=[];facing=[]
  e.update(GetUnitX=lambda u:xy.get(u,[0.,0.])[0],GetUnitY=lambda u:xy.get(u,[0.,0.])[1],SquareRoot=math.sqrt,RMinBJ=min,RMaxBJ=max,Atan2=math.atan2,bj_RADTODEG=180/math.pi,SetUnitX=lambda u,x:xy[u].__setitem__(0,x),SetUnitY=lambda u,y:xy[u].__setitem__(1,y),SetUnitFacing=lambda *a:facing.append(a),Forest86_Alive=lambda *a:True,Forest86_Enemy=lambda *a:True,B88_Buff=lambda *a:buffs.append(a),B88_Damage=lambda *a:hits.append(a),UnitAddAbility=lambda *a:None)
  e=execute(s,names,e);e['B88_ChargeStep']();self.assertEqual(xy[1],[100.,0.]);self.assertEqual(facing,[(1,0.)]);xy[1]=[210.,0.];e['B88_ChargeStep']();self.assertEqual(buffs,[(2,43,5.)]);self.assertIn((1,False),paused)
  types[1]='ncen';d[1,60]=2;e['B88_ChargeStep']();self.assertEqual(hits[-1],(1,2,400.,True));self.assertEqual(buffs[-1],(2,46,5.))
 def test_rapid_fire_formula_and_damage_buffs_are_wired(self):
  n='Trig_Spell_RapidFire_Actions';s=self.fs[n];e=legacy.mocks(s);values={};e.update(GetTriggerUnit=lambda:1,Trig_Spell_RapidFire_Start=lambda u:1,GroupAddUnit=lambda *a:None,udg_RapidFireGroup=set(),GetSpellAbilityId=lambda:'bR88',Forest86Data={},GetHandleId=lambda u:u,SaveBoolean=lambda *a:None,BlzGetUnitMaxHP=lambda u:1000,BlzGetUnitBaseDamage=lambda *a:34,I2R=float,GetUnitAbilityLevel=lambda *a:0,udg_RapidFireDmg={},udg_RapidFireElement={},udg_RapidFireMissileFx={},udg_RapidFireImpactFx={})
  e=execute(s,[n],e);e[n]();self.assertEqual(e['udg_RapidFireDmg'][1],54.)
  self.assertIn('B88_Active(u,40)',self.fs['Trig_Damage_Engine_Step18_FinalModifiers']);self.assertIn('B88_Active(t,41)',self.fs['Trig_Damage_Engine_Step18_FinalModifiers'])
  for n in ['Trig_Damage_Engine_GetAccuracy','Forsaken_Stat_GetAccuracy']:self.assertIn('l_acc=l_acc+30.',self.fs[n])
  for n in ['Trig_Damage_Engine_GetEvasion','Forsaken_Stat_GetEvasion']:self.assertIn('l_eva=l_eva*.9',self.fs[n])
  self.assertIn("'bR88'",self.fs['Trig_Spell_RapidFire_Conditions'])
  before=functions(self.before.runtime)
  self.assertEqual(tokens(before['Trig_Spell_RapidFire_DamageFormula']),tokens(self.fs['Trig_Spell_RapidFire_DamageFormula']))
  olda=all_objects(self.before,'w3a');self.assertEqual(olda['A0AE'],self.a['A0AE'])
  e['GetSpellAbilityId']=lambda:'A0AE';e['Trig_Spell_RapidFire_DamageFormula']=lambda u:123.;e['Trig_Spell_RapidFire_Actions']();self.assertEqual(e['udg_RapidFireDmg'][1],123.)
 def test_quill_projectiles_each_keep_caster_and_120_physical_damage(self):
  names=['B88_Quill'];s,e,d,types,hp,*_=self.setup(names);proxy={};orders=[]
  e.update(udg_ProxyDamageHash=proxy,CreateUnit=lambda *a:9,GetUnitFacing=lambda *a:0.,ShowUnit=lambda *a:None,UnitAddAbility=lambda *a:None,UnitApplyTimedLife=lambda *a:None,IssueTargetOrder=lambda *a:orders.append(a))
  e=execute(s,names,e);e['B88_Quill'](1,2,0.);self.assertEqual(proxy[9,0],1);self.assertEqual(proxy[9,1],120.);self.assertEqual(proxy[9,2],2);self.assertEqual(orders,[(9,'thunderbolt',2)])
 def test_every_changed_editor_function_matches_playable_script(self):
  for lib,source in self.after.modules.items():
   old=functions(self.before.modules[lib])
   for name,body in functions(source).items():
    if name not in old or tokens(body)!=tokens(old[name]):self.assertEqual(tokens(body),tokens(self.fs[name]),(lib,name))
 def test_ai_cast_orders_include_support_and_unique_fog(self):
  names=['B88_AI'];s,e,d,types,hp,floats,orders,*_=self.setup(names);ready=[None]
  e.update(Forest86_Ready=lambda u,raw,cost:raw==ready[0],B88_Ally=lambda *a:3,Forest86_Find=lambda *a:3,GetUnitAbilityLevel=lambda *a:0,IsUnitInRange=lambda *a:True,GetUnitState=lambda *a:100.)
  e=execute(s,names,e)
  for raw,spell,order in [('nqbh','bD88','devour'),('nqbh','bR88','thunderbolt'),('nowe','bT88','roar'),('ncnk','bK88','roar'),('nowb','bW88','howlofterror'),('ncer','bV88','howlofterror'),('nrzb','bB88','cripple'),('nrzg','bG88','acidbomb'),('ncen','bC88','acidbomb'),('nrzt','bQ88','shadowstrike'),('ncea','bS88','thunderbolt'),('ncim','bZ88','berserk'),('nthl','bL88','chainlightning'),('nthl','bI88','lightningshield'),('nthl','bM88','creepthunderclap'),('nhrw','bE88','faeriefire'),('nhrq','bN88','manaburn'),('n0L0','bO88','drunkenhaze'),('nrzm','bH88','heal'),('nstw','bF88','unholyfrenzy'),('ncks','bU88','innerfire'),('nhrq','bJ88','rejuvination')]:
   types[1]=raw;ready[0]=spell;orders.clear();d[1,1]=spell=='bR88';d[1,49]=True;e['B88_AI'](1,2);self.assertTrue(orders,(raw,spell));self.assertEqual(orders[0][1],order,(raw,spell,orders))
 def test_ui_hero_content_preserved_no_local_gameplay_and_bounded_timers(self):
  old=functions(self.before.runtime)
  for n in old:
   if n.startswith(('BagQuick_','DG_','Cuts_','UI55_')):self.assertEqual(tokens(old[n]),tokens(self.fs[n]),n)
  text='\n'.join(b for n,b in self.fs.items() if n.startswith(('Forest86_','B88_')))
  for forbidden in ['GetLocalPlayer','BlzGetLocal','IsUnitVisible']:self.assertNotIn(forbidden,text)
  self.assertEqual(text.count('TimerStart(CreateTimer(),1.,true'),1);self.assertIn('TimerStart(B88ChargeTimer,.1,true',text);self.assertIn('PauseTimer(B88ChargeTimer)',text)
  before=all_objects(self.before,'w3u')
  for raw in before:
   if raw not in RAW:self.assertEqual(self.u[raw],before[raw],raw)
if __name__=='__main__':unittest.main()
