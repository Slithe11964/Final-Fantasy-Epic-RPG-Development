import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_mountains89 import BASE,OUT,STATS,RAW
from build_forest86 import all_objects,META
from editor_pair import View
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
import test_barrens88 as prior
import test_forest86 as forest
class Mountains89Tests(unittest.TestCase):
 env=forest.Forest86Tests.env
 @classmethod
 def setUpClass(c):c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime);c.a=all_objects(c.after,'w3a');c.u=all_objects(c.after,'w3u')
 def setup(self,names):
  s,e,d,types,hp,floats,orders,paused=prior.Barrens88Tests.setup(self,names)
  e.update(M89Buffs=set(),M89AlertUntil=0.,M89AlertActive=False,M89_Pool=lambda *a:False,M89_AI=lambda *a:None)
  return s,e,d,types,hp,floats,orders,paused
 def test_all_requested_normal_stats(self):
  for raw,(level,hp,armor,lo,hi,mana) in STATS.items():
   f=fields(self.u[raw]);self.assertEqual(f['ulev',None],level,raw)
   for key,value in [('uhpm',hp),('udef',armor),('umpm',mana)]:
    if value is not None:self.assertEqual(f[key,None],value,(raw,key))
   if lo is not None:self.assertEqual((f['ua1b',None]+f['ua1d',None],f['ua1b',None]+f['ua1d',None]*f['ua1s',None]),(lo,hi),raw)
  self.assertEqual(fields(self.u['nhfp'])['unam',None],'Cultist')
  f=fields(self.u['mH89']);self.assertEqual(f['ulev',None],10);self.assertEqual(f['uhpm',None],1000);self.assertEqual(f['udef',None],25.);self.assertEqual(f['udty',None],'fort');self.assertEqual(f['ua1t',None],'chaos');self.assertIn('Felhound',f['umdl',None])
 def test_private_native_values_and_data_pointers(self):
  for raw,expected in {'mMI9':{'Omi1':1,'Omi2':.5,'Omi3':1.5},'mCS9':{'Ucs1':600.,'Ucs2':2400.,'acdn':8.},'mAU9':{'Hab1':.75,'Hab2':1},'mL79':{'Ocl1':750.},'mL69':{'Ocl1':600.},'mFL9':{'Ocl1':450.},'mLS9':{'Lsh1':150.},'mST9':{'adur':3.},'mSN9':{'Slo1':.33,'Slo2':.33},'mD39':{'Iatt':300},'mA29':{'Idef':20},'mA49':{'Idef':40},'fE86':{'amcs':200},'mCU9':{'amcs':300,'acdn':8.,'aran':800.},'mAW9':{'amcs':200,'acdn':20.},'mSL9':{'amcs':125,'acdn':15.},'mRK9':{'amcs':75,'acdn':10.},'mFB9':{'amcs':200,'acdn':10.}}.items():
   for key,value in expected.items():
    self.assertAlmostEqual(fields(self.a[raw])[key,1],value,places=5,msg=(raw,key))
    m=next(m for st in self.a[raw]['sets'] for m in st['mods'] if m['field']==key and m.get('level')==1);self.assertEqual(m['data'],int(META.get(key,{}).get('data','0') or 0))
  for raw,removed in [('nhhr',['ACcs','ACsw','ACca']),('nkog',['ACsw','A05A']),('nkol',['ACct']),('nass',['A0PH']),('ngns',['A0PH'])]:
   for a in removed:self.assertNotIn(a,fields(self.u[raw])['uabi',None])
  for raw in ['ngns','nrog']:self.assertIn('A03N',fields(self.u[raw])['uabi',None])
 def test_material_pickup_not_gear_and_stack_eligibility(self):
  names=['ItemStack_Eligible','Trig_Equip_Restrictions_Conditions'];s='\n'.join(self.fs[n] for n in names);e=mocks(s);raw=['I073'];e.update(GetManipulatedItem=lambda:1,GetItemTypeId=lambda u:raw[0],GetItemType=lambda u:0,ITEM_TYPE_CHARGED=1,GetItemLevel=lambda u:99,GetItemCharges=lambda u:1)
  e=execute(s,names,e)
  for item in ['I073','I071']:raw[0]=item;self.assertTrue(e['ItemStack_Eligible'](1));self.assertFalse(e['Trig_Equip_Restrictions_Conditions']())
  raw[0]='gear';self.assertFalse(e['ItemStack_Eligible'](1));self.assertFalse(e['ItemStack_Eligible'](None))
 def test_both_materials_merge_in_native_six_slots_and_keep_overflow(self):
  names=['ItemStack_Eligible','ItemStack_MergePair','ItemStack_MergeUnit'];s='\n'.join(self.fs[n] for n in names);e=mocks(s);raw=['I073'];charges={1:1,2:1};removed=[]
  e.update(GetItemTypeId=lambda i:raw[0] if i and i not in removed else 0,GetItemType=lambda i:0,ITEM_TYPE_CHARGED=1,GetItemLevel=lambda i:99,GetItemCharges=lambda i:charges.get(i,0),GetItemUserData=lambda i:0,GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:0,Carry_Size=lambda u:6,Carry_At=lambda u,slot:2 if slot==3 else None,IMinBJ=min,SetItemCharges=lambda i,x:charges.__setitem__(i,x),SetItemUserData=lambda *a:None,RemoveItem=lambda i:removed.append(i))
  e=execute(s,names,e)
  for item in ['I073','I071']:
   raw[0]=item;charges.update({1:1,2:1});removed.clear();e['ItemStack_MergeUnit'](3,1);self.assertEqual(charges[2],2);self.assertEqual(removed,[1])
  charges.update({1:5,2:98});removed.clear();e['ItemStack_MergeUnit'](3,1);self.assertEqual((charges[1],charges[2]),(4,99));self.assertEqual(removed,[])
 def test_injured_only_devour_validation(self):
  names=['Forest86_Alive','M89_Injured','Forest86_Pool','Forest86_DevourValid'];s,e,d,types,hp,*_=self.setup(names);types[2]='nfsp';hp[2]=200.
  e.update(BlzGetUnitMaxHP=lambda u:200,IsUnitType=lambda *a:False);e=execute(s,names,e);self.assertFalse(e['Forest86_DevourValid'](1,2));hp[2]=199.;self.assertTrue(e['Forest86_DevourValid'](1,2))
  d[1,90]=2;self.assertFalse(e['Forest86_DevourValid'](1,2));d.clear()
  e['IsUnitAlly']=lambda *a:False;self.assertFalse(e['Forest86_DevourValid'](1,2))
  self.assertIn('M89_Injured(victim)',self.fs['B88_Spell']);self.assertIn('M89_Injured(victim)',self.fs['M89_Spell'])
 def test_queen_stat_absorption(self):
  names=['M89_Absorb'];s,e,d,types,hp,*_=self.setup(names);base={(1,0):10,(1,1):20,(2,0):30,(2,1):40};maxhp={1:1000,2:400};mp={1:200,2:100};armor={1:10.,2:6.};hp.update({1:500.,2:120.})
  e.update(BlzGetUnitBaseDamage=lambda u,slot:base[u,slot],BlzSetUnitBaseDamage=lambda u,v,slot:base.__setitem__((u,slot),v),BlzGetUnitMaxHP=lambda u:maxhp[u],BlzSetUnitMaxHP=lambda u,v:maxhp.__setitem__(u,v),BlzGetUnitMaxMana=lambda u:mp[u],BlzSetUnitMaxMana=lambda u,v:mp.__setitem__(u,v),BlzGetUnitArmor=lambda u:armor[u],BlzSetUnitArmor=lambda u,v:armor.__setitem__(u,v),SetWidgetLife=lambda u,v:hp.__setitem__(u,v),RMinBJ=min,DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:None)
  removed=[];e.update(GetSpellAbilityId=lambda:'fD86',UnitRemoveAbility=lambda *a:removed.append(a))
  e=execute(s,names,e);e['M89_Absorb'](1,2);self.assertEqual((base[1,0],base[1,1],maxhp[1],mp[1],armor[1],hp[1]),(40,60,1400,300,16.,620.));self.assertEqual(removed,[])
  e['M89_Absorb'](1,2);self.assertEqual(removed,[(1,'fD86')]);self.assertEqual(d[1,90],2)
 def test_mountain_alert_independent_countdown_and_zone_gate(self):
  names=['Forest86_Alive','B88_AlertZone','Forest86_Alert','Forest86_AI','Forest86_SpawnFactor'];s,e,d,types,hp,floats,orders,*_=self.setup(names);types[1]='nbrg';e['B88_InZone']=lambda *a:True;e=execute(s,names,e);e['Forest86_Alert'](1);self.assertEqual(d[1,4],15.)
  for now in range(10,15):e['Forest86Now']=float(now);e['Forest86_AI']()
  self.assertEqual(floats[-5:],['5','4','3','2','1']);e['Forest86Now']=15.;e['Forest86_AI']();self.assertEqual(e['M89AlertUntil'],75.);self.assertEqual(e['B88AlertUntil'],0.);self.assertEqual(e['Forest86AlertUntil'],0.);self.assertEqual(e['Forest86_SpawnFactor'](4),2);self.assertEqual(e['Forest86_SpawnFactor'](1),1)
  self.assertEqual(e['B88_AlertZone'](1),4);types[1]='nkob';self.assertEqual(e['B88_AlertZone'](1),4);d.clear();e['B88_InZone']=lambda *a:False;e['Forest86_Alert'](1);self.assertEqual(d,{})
 def test_new_poison_chances_and_damage(self):
  names=['Forest86_OnAttack'];s,e,d,types,hp,*_=self.setup(names);roll=[25]
  e.update(GetHeroLevel=lambda u:20,GetRandomInt=lambda *a:roll[0],DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:None);e=execute(s,names,e)
  for raw,wanted in [('nass',110.),('ngns',90.)]:
   types[1]=raw;d.clear();e['Forest86_OnAttack'](1,2);self.assertEqual(d[2,11],wanted);self.assertEqual(d[2,12],10.)
  roll[0]=26;d.clear();e['Forest86_OnAttack'](1,2);self.assertEqual(d,{})
  shocked=[];types[1]='ngnw';roll[0]=10;e['IsUnitType']=lambda *a:False;e['M89_Dummy']=lambda *a:shocked.append(a);e['Forest86_OnAttack'](1,2);self.assertEqual(shocked,[(1,2,'A13V','acidbomb')])
 def test_block_buffs_expire_and_evasive_duration(self):
  names=['B88_Active','B88_BlockChance','Forest86_Evasion'];s,e,d,types,hp,*_=self.setup(names);e=execute(s,names,e);types[1]='nban';self.assertEqual(e['B88_BlockChance'](1,True,False),25);d[1,80]=10.;self.assertEqual(e['B88_BlockChance'](1,True,False),55);self.assertEqual(e['B88_BlockChance'](1,False,True),40)
  types[1]='nenf';d[1,81]=10.;self.assertEqual(e['B88_BlockChance'](1,True,False),66);self.assertEqual(e['B88_BlockChance'](1,False,True),50);e['Forest86Now']=10.;self.assertEqual(e['B88_BlockChance'](1,True,False),0)
  types[1]='nbld';d[1,30]=15.;e['Forest86Now']=14.;self.assertEqual(e['Forest86_Evasion'](1),80.);e['Forest86Now']=15.;self.assertEqual(e['Forest86_Evasion'](1),0.)
  types[1]='nkob';self.assertEqual(e['Forest86_Evasion'](1),40.)
 def test_darkness_bite_heal_accumulate_and_slam(self):
  names=['M89_Spell'];s,e,d,types,hp,*_=self.setup(names);hits=[];heals=[];buffs=[];group={2};added=[]
  e.update(CreateGroup=lambda:set(group),GroupEnumUnitsInRange=lambda *a:None,FirstOfGroup=lambda g:next(iter(g),None),DestroyGroup=lambda *a:None,Forest86_Enemy=lambda *a:True,M89_Damage=lambda *a:hits.append(a),M89_Heal=lambda *a:heals.append(a),M89_Buff=lambda *a:buffs.append(a),M89_Area=lambda *a:hits.append(a),BlzGetUnitMaxHP=lambda u:3400,UnitAddAbility=lambda *a:added.append(a),DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:None)
  e=execute(s,names,e);e['M89_Spell'](1,None,'mDA9');self.assertEqual(hits[0],(1,2,100.,0));e['M89_Spell'](1,2,'mBI9');self.assertEqual(hits[-1],(1,2,600.,0));self.assertEqual(heals[-1],(1,1,250.))
  e['M89_Spell'](1,None,'mAC9');self.assertEqual(heals[-1],(1,1,1700.));self.assertIn((1,'mD39'),added);self.assertIn((1,'mA49'),added)
  e['M89_Spell'](1,None,'mSL9');self.assertEqual(hits[-1],(1,0.,0.,300.,600.,5,True))
 def test_aeroaga_exactly_three_pulses_and_caster_specific_scaling(self):
  names=['B88_Active','M89_Buff','M89_Spell','M89_TickUnit'];s,e,d,types,hp,*_=self.setup(names);hits=[];types[1]='nwzd'
  e.update(GetSpellTargetX=lambda:25.,GetSpellTargetY=lambda:50.,BlzGetUnitMaxHP=lambda u:3100,BlzGetUnitBaseDamage=lambda *a:144,M89_Area=lambda *a:hits.append(a),Forest86_Alive=lambda *a:True,DestroyEffect=lambda *a:None,AddSpecialEffect=lambda *a:None)
  e=execute(s,names,e);e['M89_Spell'](1,None,'mAW9');self.assertAlmostEqual(d[1,89],1147.1)
  for now in range(1,11):e['Forest86Now']=float(now);e['M89_TickUnit']()
  self.assertEqual(len(hits),3);self.assertTrue(all(h[1:4]==(25.,50.,300.) and h[5]==6 for h in hits));self.assertNotIn(1,e['M89Buffs'])
  types[1]='nwzg';e['M89_Spell'](1,None,'mAW9');self.assertEqual(d[1,89],500.)
 def test_projectiles_preserve_explicit_elements_and_slow(self):
  names=['M89_Projectile'];s,e,d,types,hp,*_=self.setup(names);proxy={};orders=[]
  e.update(udg_ProxyDamageHash=proxy,CreateUnit=lambda *a:9,GetUnitFacing=lambda *a:0.,ShowUnit=lambda *a:None,UnitAddAbility=lambda *a:None,UnitApplyTimedLife=lambda *a:None,IssueTargetOrder=lambda *a:orders.append(a));e=execute(s,names,e)
  e['M89_Projectile'](1,2,'mPF9',800.,1,False);self.assertEqual((proxy[9,0],proxy[9,1],proxy[9,100],proxy[9,101]),(1,800.,1,False));e['M89_Projectile'](1,2,'mPE9',400.,5,True);self.assertEqual((proxy[9,1],proxy[9,100],proxy[9,101]),(400.,5,True));self.assertIn('HaveSavedInteger(udg_ProxyDamageHash,dh,100)',self.fs['Trig_Damage_Engine_ProxyDamageApply'])
 def test_cure_private_branch_and_player_preservation(self):
  self.assertIn("'mCU9'",self.fs['Trig_Spell_Cure_Conditions']);self.assertIn('set r=600.',self.fs['Trig_Spell_Cure_Actions']);self.assertIn('set splash=300.',self.fs['Trig_Spell_Cure_Actions'])
  old=all_objects(self.before,'w3a')
  for raw in ['A00M','A10K','A003','A03Z','ACca','ACcl','ACfl','A0AE','A0YR']:self.assertEqual(self.a.get(raw),old.get(raw),raw)
  f=self.fs['Trig_Damage_Engine_GetCritMult'];self.assertIn("GetUnitTypeId(u)=='nkol' and GetRandomInt(1,100)<=35",f);self.assertIn('return 2.5',f)
 def test_mountain_ai_ready_casts_and_support_orders(self):
  names=['M89_AI'];s,e,d,types,hp,floats,orders,*_=self.setup(names);ready=[None]
  e.update(Forest86_Ready=lambda u,raw,cost:raw==ready[0],M89_Ally=lambda *a:3,GetUnitAbilityLevel=lambda *a:0,IsUnitInRange=lambda *a:True);e=execute(s,names,e)
  cases=[('nkog','mCU9','holybolt'),('nwzd','mDV9','devour'),('nomg','mBR9','innerfire'),('nomg','A059','bloodlust'),('nwiz','mDA9','howlofterror'),('nhfp','mSU9','roar'),('n0MO','mRO9','roar'),('nban','mDS9','defend'),('nbld','fE86','howlofterror'),('nenf','mTE9','roar'),('ngnv','mTV9','roar'),('ngno','mBI9','cripple'),('nhdc','mMI9','mirrorimage'),('nhhr','mCS9','carrionswarm'),('nkot','mSH9','roar'),('nogl','mAC9','roar'),('nogm','mSL9','stomp'),('nogr','mRK9','thunderbolt'),('nwzg','mAW9','flamestrike'),('nwzd','mL79','chainlightning'),('nwzd','mFL9','forkedlightning'),('nwzg','mL69','chainlightning'),('nwzg','mLS9','lightningshield'),('nwzr','mFB9','firebolt')]
  for raw,spell,order in cases:
   types[1]=raw;ready[0]=spell;d[1,91]=True;orders.clear();e['M89_AI'](1,2);self.assertTrue(orders,(raw,spell));self.assertEqual(orders[0][1],order,(raw,spell))
 def test_only_requested_mirror_images_can_deal_damage(self):
  self.assertIn("GetUnitTypeId(u)=='nhdc' and GetOwningPlayer(u)==Player(11)",self.fs['Trig_Damage_Engine_Step19_Apply'])
  self.assertIn('not IsUnitIllusion(u)',self.fs['Forest86_Track'])
 def test_cure_runtime_amounts_for_mob_player_and_hostile_talent(self):
  n='Trig_Spell_Cure_Actions';s=self.fs[n];e=mocks(s);raw=['mCU9'];hostile=[False];launches=[]
  e.update(GetTriggerUnit=lambda:1,GetSpellTargetUnit=lambda:2,BlzGetAbilityManaCost=lambda *a:100,GetSpellAbilityId=lambda:raw[0],Abil_GetLevel=lambda *a:0,Trig_Spell_Cure_HealFormula=lambda *a:400.,GetHeroInt=lambda *a:0,Prof_StaffPower=lambda *a:1.,Talent_Active=lambda *a:hostile[0],TALENT_JOB_PRIEST=1,IsUnitEnemy=lambda *a:True,GetOwningPlayer=lambda *a:0,Trig_Spell_Cure_MissileLaunchHeal=lambda *a:launches.append(a) or 1,PriestShieldMissile={},Talent_PriestChoice=lambda *a:False,Talent_MarkBlindingMissile=lambda *a:None,Talent_BlindTarget=lambda *a:None)
  e=execute(s,[n],e);e[n]();self.assertEqual(launches[-1][7:9],(300.,600.));raw[0]='A00M';e[n]();self.assertEqual(launches[-1][7:9],(100.,400.));hostile[0]=True;e[n]();self.assertEqual(launches[-1][7:9],(0.,0.))
 def test_cure_selects_lowest_health_fraction_ally_within_800(self):
  names=['M89_Ally'];s,e,d,types,hp,*_=self.setup(names);hp.update({1:1000.,2:500.,3:20.,4:1.});ranges=[]
  e.update(CreateGroup=lambda:{1,2,3,4},GroupEnumUnitsInRange=lambda g,x,y,r,f:ranges.append(r),FirstOfGroup=lambda g:min(g) if g else None,DestroyGroup=lambda *a:None,Forest86_Alive=lambda *a:True,IsUnitAlly=lambda u,p:u!=4,IsUnitType=lambda *a:False,BlzGetUnitMaxHP=lambda u:1000 if u in [1,2] else 100)
  # The JASS test translator uses integer division for '/', so supply real max HP.
  e['I2R']=float
  import test_quest_lifecycle as harness
  original=harness.expression
  harness.expression=lambda text:original(text).replace(' // ',' / ')
  try:e=execute(s,names,e)
  finally:harness.expression=original
  self.assertEqual(e['M89_Ally'](1,0),3);self.assertEqual(ranges,[800.])
 def test_changed_source_matches_playable_and_no_local_gameplay(self):
  for lib,source in self.after.modules.items():
   old=functions(self.before.modules[lib])
   for name,b in functions(source).items():
    if name not in old or tokens(b)!=tokens(old[name]):self.assertEqual(tokens(b),tokens(self.fs[name]),(lib,name))
  text='\n'.join(b for n,b in self.fs.items() if n.startswith(('M89_','B88_','Forest86_')))
  for forbidden in ['GetLocalPlayer','BlzGetLocal','IsUnitVisible']:self.assertNotIn(forbidden,text)
  self.assertNotIn('TimerStart', '\n'.join(b for n,b in self.fs.items() if n.startswith('M89_') and not n.endswith('UpdateSpawnTimer')))
  self.assertEqual(all_objects(self.before,'w3t'),all_objects(self.after,'w3t'))
if __name__=='__main__':unittest.main()
