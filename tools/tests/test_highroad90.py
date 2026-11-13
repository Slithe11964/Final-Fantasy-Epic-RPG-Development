import sys,unittest,math,collections
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_highroad90 import BASE,OUT,STATS,RAW
from build_forest86 import all_objects,META
from editor_pair import View
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
import test_mountains89 as prior
class Highroad90Tests(unittest.TestCase):
 env=prior.Mountains89Tests.env
 @classmethod
 def setUpClass(c):c.before=View(BASE);c.after=View(OUT);c.fs=functions(c.after.runtime);c.a=all_objects(c.after,'w3a');c.u=all_objects(c.after,'w3u')
 def setup(self,names):
  s,e,d,types,hp,floats,orders,paused=prior.Mountains89Tests.setup(self,names)
  e.update(H90Buffs=set(),H90AlertUntil=0.,H90AlertActive=False,H90_Pool=lambda *a:False,H90_AI=lambda *a:None,HaveSavedHandle=lambda table,p,c:(p,c) in table,LoadEffectHandle=lambda table,p,c:table.get((p,c)),SaveEffectHandle=lambda table,p,c,v:table.__setitem__((p,c),v),RemoveSavedBoolean=lambda table,p,c:table.pop((p,c),None),DestroyEffect=lambda *a:None,AddSpecialEffectTarget=lambda *a:301,UnitAddAbility=lambda *a:None,SetUnitScale=lambda *a:None)
  return s,e,d,types,hp,floats,orders,paused
 def test_requested_normal_stats_and_damage_ranges(self):
  for raw,(level,hp,armor,lo,hi,mana) in STATS.items():
   f=fields(self.u[raw]);self.assertEqual(f['ulev',None],level,raw)
   for key,val in [('uhpm',hp),('udef',armor),('umpm',mana)]:
    if val is not None:self.assertEqual(f[key,None],val,(raw,key))
   if lo is not None:self.assertEqual((f['ua1b',None]+f['ua1d',None],f['ua1b',None]+f['ua1d',None]*f['ua1s',None]),(lo,hi),raw)
 def test_native_values_real_pointers_and_updated_tooltips(self):
  checks={'hHB0':{'Htb1':800.,'adur':3.,'amcs':100,'acdn':30.},'hER0':{'Eer1':400.,'adur':3.,'amcs':200,'acdn':12.},'hBI0':{'amcs':150,'acdn':15.},'hD20':{'Iatt':200},'hAS0':{'Isx1':.2},'hAV0':{'Hav2':1000.,'Hav3':100.,'Hav4':1.,'adur':30.,'amcs':150,'acdn':45.},'hA25':{'Isx1':.25},'hRD0':{'amcs':400,'acdn':30.},'hGS0':{'amcs':200,'acdn':15.},'hMF0':{'amcs':100,'acdn':30.},'hPB0':{'Cri3':.25,'adur':10.},'hFK0':{'amcs':50,'acdn':20.},'hAA0':{'amcs':100,'acdn':15.}}
  for raw,values in checks.items():
   for key,val in values.items():
    self.assertAlmostEqual(fields(self.a[raw])[key,1],val,places=5,msg=(raw,key))
    m=next(m for st in self.a[raw]['sets'] for m in st['mods'] if m['field']==key and m.get('level')==1);self.assertEqual(m['data'],int(META.get(key,{}).get('data','0') or 0))
  for raw in ['nsgg','narg','nwrg']:self.assertNotIn('A07A',fields(self.u[raw])['uabi',None])
 def test_roar_accumulate_mirror_and_every_devour(self):
  self.assertEqual(fields(self.a['mD39'])['Iatt',1],150)
  for raw in ['mRO9','mAC9']:self.assertIn('150',fields(self.a[raw])['aub1',1]);self.assertNotIn('300',fields(self.a[raw])['aub1',1])
  for raw in ['n0MO','nogl']:self.assertIn('150',fields(self.u[raw])['utub',None])
  self.assertEqual(fields(self.a['mMI9'])['aran',1],96.);self.assertEqual(fields(self.a['mMI9'])['aare',1],128.)
  for raw in ['A0YR','fD86','bD88','mDV9','hDV0']:self.assertEqual(fields(self.a[raw])['acdn',1],20.,raw)
 def test_stinger_damage_retained_for_half_cost_highroad_bio(self):
  names=['H90_BioMana','Trig_Bio_Cast_Actions'];s='\n'.join(self.fs[n] for n in names);e=mocks(s);raw=['A10N'];values=[];ranks=[]
  e.update(GetTriggerUnit=lambda:1,GetUnitLoc=lambda *a:0,CreateNUnitsAtLocFacingLocBJ=lambda *a:None,GetOwningPlayer=lambda *a:11,RemoveLocation=lambda *a:None,GetLastCreatedUnit=lambda:2,GetHandleIdBJ=lambda u:u,SaveUnitHandleBJ=lambda *a:None,udg_ProxyDamageHash={},BlzGetAbilityManaCost=lambda a,*rest:100 if a=='hBO0' else 200,GetSpellAbilityId=lambda:raw[0],Abil_GetLevel=lambda *a:0,Trig_Bio_Cast_IsHero=lambda:False,Prof_InnerManaPower=lambda *a:1.5,I2R=float,SaveRealBJ=lambda value,*a:values.append(value),SaveIntegerBJ=lambda *a:None,ShowUnitHide=lambda *a:None,UnitApplyTimedLifeBJ=lambda *a:None,UnitAddAbilityBJ=lambda *a:None,SetUnitAbilityLevelSwapped=lambda ability,u,rank:ranks.append(rank),IssueTargetOrderBJ=lambda *a:None,GetSpellTargetUnit=lambda:3)
  e=execute(s,names,e)
  for r in ['A10N','fI86','hBO0']:raw[0]=r;e['Trig_Bio_Cast_Actions']()
  self.assertAlmostEqual(values[1],values[0]*.8);self.assertEqual(values[2],values[1]);self.assertEqual(ranks[1],ranks[2]);self.assertEqual(ranks[2],10)
  self.assertEqual(fields(self.a['hBO0'])['amcs',1],100);self.assertEqual(fields(self.a['fI86'])['amcs',1],200)
 def test_new_poison_formulas_and_chances(self):
  names=['Forest86_OnAttack'];s,e,d,types,hp,*_=self.setup(names);roll=[30]
  e.update(GetHeroLevel=lambda u:20,GetRandomInt=lambda *a:roll[0]);e=execute(s,names,e)
  types[1]='nspb';e['Forest86_OnAttack'](1,2);self.assertEqual((d[2,11],d[2,12]),(200.,10.));d.clear();roll[0]=31;e['Forest86_OnAttack'](1,2);self.assertEqual(d,{})
  types[1]='ngns';roll[0]=25;e['Forest86_OnAttack'](1,2);self.assertEqual((d[2,11],d[2,12]),(190.,10.));d.clear();roll[0]=26;e['Forest86_OnAttack'](1,2);self.assertEqual(d,{})
 def test_highroad_alert_uses_only_zone_five(self):
  names=['Forest86_Alive','B88_Active','B88_AlertZone','Forest86_Alert','Forest86_AI','Forest86_SpawnFactor'];s,e,d,types,hp,floats,orders,*_=self.setup(names);types[1]='ngna';e['B88_InZone']=lambda *a:True;e=execute(s,names,e);e['Forest86_Alert'](1);self.assertEqual(d[1,4],15.)
  for now in range(10,15):e['Forest86Now']=float(now);e['Forest86_AI']()
  self.assertEqual(floats[-5:],['5','4','3','2','1']);e['Forest86Now']=15.;e['Forest86_AI']();self.assertEqual(e['H90AlertUntil'],75.);self.assertEqual(e['M89AlertUntil'],0.);self.assertEqual(e['B88_AlertZone'](1),5);self.assertEqual(e['Forest86_SpawnFactor'](5),2);self.assertEqual(e['Forest86_SpawnFactor'](4),1)
 def test_block_values_rocky_upgrade_and_expiry(self):
  names=['B88_Active','B88_BlockChance'];s,e,d,types,hp,*_=self.setup(names);e=execute(s,names,e)
  for raw,p,m in [('nsgg',30,0),('narg',20,0),('nwrg',15,15),('nggr',33,33)]:
   types[1]=raw;self.assertEqual(e['B88_BlockChance'](1,True,False),p);self.assertEqual(e['B88_BlockChance'](1,False,True),m)
  d[1,106]=10.;self.assertEqual(e['B88_BlockChance'](1,True,False),60);self.assertEqual(e['B88_BlockChance'](1,False,True),60);e['Forest86Now']=10.;self.assertEqual(e['B88_BlockChance'](1,True,False),33)
 def test_evasion_aura_rocky_and_debuff_match_stat_panel(self):
  names=['B88_Active','Forest86_Evasion','H90_Evasion','Trig_Damage_Engine_GetEvasion','Forsaken_Stat_GetEvasion'];s,e,d,types,hp,*_=self.setup(names);types[1]='nggr';loss=[0.]
  e.update(Trig_Damage_Engine_GetSpeedBonus=lambda *a:0.,Forsaken_Stat_GetSpeedBonus=lambda *a:0.,GetUnitDefaultMoveSpeed=lambda *a:300.,GetHeroAgi=lambda *a:0,GetUnitLevel=lambda *a:24,IsUnitType=lambda *a:False,Forsaken_ElementAbilityLevel=lambda *a:0,Forsaken_StatAbilityLevel=lambda *a:0,GetUnitAbilityLevel=lambda u,a:1 if a=='bE90' else 0,DG_Reduction=lambda *a:loss[0],DG_Data=None,RMaxBJ=max)
  e=execute(s,names,e)
  for rocky,wanted in [(False,50.),(True,100.)]:
   d[1,106]=10. if rocky else 0.
   self.assertEqual(e['Trig_Damage_Engine_GetEvasion'](1),wanted);self.assertEqual(e['Forsaken_Stat_GetEvasion'](1),wanted)
  d[1,112]=10.;loss[0]=15.;e['DG_Data']={(1,0):1,(1,1):15.};self.assertEqual(e['Trig_Damage_Engine_GetEvasion'](1),55.);self.assertEqual(e['Forsaken_Stat_GetEvasion'](1),55.)
  types[1]='n000';loss[0]=0.;d.clear();e['DG_Data']=None;self.assertAlmostEqual(e['Trig_Damage_Engine_GetEvasion'](1),80.4);self.assertAlmostEqual(e['Forsaken_Stat_GetEvasion'](1),80.4)
  b=all_objects(self.after,'w3h')['bE90'];self.assertEqual(b['base'],'BOae');self.assertEqual(fields(self.a['hEA0'])['abuf',1],'bE90')
 def tickenv(self,names):
  s,e,d,types,hp,floats,orders,paused=self.setup(names);heals=[];areas=[];whirls=[];removed=[];scales=[]
  e.update(Forest86_Alive=lambda u:hp.get(u,0.)>.405,M89_Heal=lambda *a:heals.append(a),H90_Ground=lambda *a:areas.append(a),H90_Whirl=lambda *a:whirls.append(a),UnitRemoveAbility=lambda *a:removed.append(a),SetUnitScale=lambda *a:scales.append(a))
  return s,e,d,types,hp,heals,areas,whirls,removed,scales,paused
 def test_field_kit_immediate_and_five_healing_ticks(self):
  names=['B88_Active','H90_Buff','H90_Spell','H90_TickUnit'];s,e,d,types,hp,heals,*_=self.tickenv(names);e['GetEnumUnit']=lambda:2;e=execute(s,names,e);e['H90_Spell'](1,2,'hFK0');self.assertEqual(heals,[(1,2,1000.)])
  for now in range(1,7):e['Forest86Now']=float(now);e['H90_TickUnit']()
  self.assertEqual([h[2] for h in heals],[1000.,100.,100.,100.,100.,100.]);self.assertNotIn((2,121),d);self.assertNotIn(2,e['H90Buffs'])
 def test_ground_slam_two_radii_original_center_two_second_gap(self):
  names=['B88_Active','H90_Buff','H90_Spell','H90_TickUnit'];s,e,d,types,hp,heals,areas,*_=self.tickenv(names);xy=[10.,20.];e.update(GetUnitX=lambda *a:xy[0],GetUnitY=lambda *a:xy[1]);e=execute(s,names,e);e['H90_Spell'](1,None,'hGS0');self.assertEqual(areas,[(1,10.,20.,300.)]);xy[:]=[1000.,1000.]
  e['Forest86Now']=1.;e['H90_TickUnit']();self.assertEqual(len(areas),1);e['Forest86Now']=2.;e['H90_TickUnit']();self.assertEqual(areas[-1],(1,10.,20.,500.));e['Forest86Now']=3.;e['H90_TickUnit']();self.assertEqual(len(areas),2)
 def test_whirlwind_five_ticks_effect_cleanup_and_radius_damage(self):
  names=['B88_Active','H90_Buff','H90_Spell','H90_TickUnit'];s,e,d,types,hp,heals,areas,whirls,*_=self.tickenv(names);destroyed=[];e['DestroyEffect']=lambda fx:destroyed.append(fx);e=execute(s,names,e);e['H90_Spell'](1,None,'hWW0')
  for now in range(1,7):e['Forest86Now']=float(now);e['H90_TickUnit']()
  self.assertEqual(len(whirls),5);self.assertEqual(destroyed,[301]);self.assertNotIn((1,120),d)
  n='H90_Whirl';s=self.fs[n];e=mocks(s);hits=[];radii=[];e.update(CreateGroup=lambda:{2},FirstOfGroup=lambda g:next(iter(g),None),GroupRemoveUnit=lambda g,u:g.discard(u),GroupEnumUnitsInRange=lambda g,x,y,r,f:radii.append(r),GetUnitX=lambda *a:0.,GetUnitY=lambda *a:0.,Forest86_Enemy=lambda *a:True,B88_Damage=lambda *a:hits.append(a),DestroyGroup=lambda *a:None)
  e=execute(s,[n],e);e[n](1);self.assertEqual(radii,[250.]);self.assertEqual(hits,[(1,2,500.,True)])
 def test_immovable_taunt_holds_five_seconds_then_releases(self):
  names=['Forest86_Alive','Forest86_Taunt','B88_Active','H90_Buff','H90_Spell','H90_TickUnit'];s,e,d,types,hp,heals,areas,whirls,removed,scales,paused=self.tickenv(names);types[1]='nsgg'
  e.update(CreateGroup=lambda:{2},GroupEnumUnitsInRange=lambda *a:None,FirstOfGroup=lambda g:next(iter(g),None),DestroyGroup=lambda *a:None,Forest86_Enemy=lambda *a:True,Forest86_TauntOrder=lambda *a:None);e=execute(s,names,e);e['H90_Spell'](1,None,'hTT0');self.assertEqual(d[2,21],5.);self.assertEqual(d[1,100],5.);self.assertIn((1,True),paused)
  e['Forest86Now']=4.;e['H90_TickUnit']();self.assertNotIn((1,False),paused);e['Forest86Now']=5.;e['H90_TickUnit']();self.assertIn((1,False),paused);self.assertIn('B88_Active(t,100)',self.fs['Trig_Damage_Engine_Step18_FinalModifiers'])
 def test_avatar_size_and_attack_speed_restore_after_thirty_seconds(self):
  names=['B88_Active','H90_Buff','H90_Spell','H90_TickUnit'];s,e,d,types,hp,heals,areas,whirls,removed,scales,*_=self.tickenv(names);e=execute(s,names,e);e['H90_Spell'](1,None,'hAV0');self.assertIn((1,1.5,1.5,1.5),scales);e['Forest86Now']=30.;e['H90_TickUnit']();self.assertIn((1,1.,1.,1.),scales);self.assertIn((1,'hA25'),removed)
 def test_highroad_devour_pool_injury_two_use_gate_and_unlock(self):
  names=['H90_Pool','H90_Spell'];s,e,d,types,hp,*_=self.setup(names);types[2]='n01P';absorbed=[];added=[];consumed=[];refund=[]
  def absorb(c,t):absorbed.append((c,t));d[c,90]=d.get((c,90),0)+1
  e.update(M89_Injured=lambda *a:True,IsUnitType=lambda *a:False,M89_Absorb=absorb,LoadGroupHandle=lambda *a:None,udg_SpawnTimerHash={},RemoveUnit=lambda u:consumed.append(u),UnitAddAbility=lambda *a:added.append(a),GetUnitState=lambda *a:0.,SetUnitState=lambda *a:refund.append(a),RMinBJ=min,BlzEndUnitAbilityCooldown=lambda *a:None);e=execute(s,names,e)
  e['H90_Spell'](1,2,'hDV0');self.assertEqual(consumed,[2]);self.assertIn((1,'hRD0'),added);e['H90_Spell'](1,2,'hDV0');self.assertEqual(d[1,90],2);e['H90_Spell'](1,2,'hDV0');self.assertEqual(len(consumed),2);self.assertTrue(refund)
  d[1,90]=0;types[2]='nfsp';consumed.clear();e['H90_Spell'](1,2,'hDV0');self.assertEqual(consumed,[]);types[2]='n01P';e['M89_Injured']=lambda *a:False;e['H90_Spell'](1,2,'hDV0');self.assertEqual(consumed,[])
 def test_aerial_assault_values_and_original_liquid_steel_branch(self):
  n='Trig_Spell_LiquidSteel_Actions';s=self.fs[n];e=mocks(s);raw=['hAA0'];effects=[];index=[0];arrays=['H90LiquidWind','udg_LiquidSteelCaster','udg_LiquidSteelTarget','udg_LiquidSteelOwner','udg_LiquidSteelBounces','udg_LiquidSteelDmg','udg_LiquidSteelX','udg_LiquidSteelY','gg_unit_h020_0272','udg_LiquidSteelEffect']
  for name in arrays:e[name]=collections.defaultdict(int)
  def start(c,t):index[0]+=1;d=index[0];e['udg_LiquidSteelCaster'][d]=c;e['udg_LiquidSteelTarget'][d]=t;return d
  e.update(GetTriggerUnit=lambda:1,GetSpellTargetUnit=lambda:2,Trig_Spell_LiquidSteel_Start=start,GetSpellAbilityId=lambda:raw[0],GetUnitAbilityLevel=lambda *a:11,GetUnitX=lambda u:float(u*100),GetUnitY=lambda *a:0.,Atan2=math.atan2,Cos=math.cos,Sin=math.sin,Trig_Spell_LiquidSteel_DamageFormula=lambda *a:999.,BlzGetAbilityManaCost=lambda *a:100,Abil_GetLevel=lambda *a:0,GetHeroStr=lambda *a:0,GetHeroInt=lambda *a:0,Prof_GetHybridLevel=lambda *a:0,CreateUnit=lambda *a:3,AddSpecialEffectTarget=lambda *a:effects.append(a) or 4)
  e=execute(s,[n],e);e[n]();self.assertEqual((e['udg_LiquidSteelBounces'][1],e['udg_LiquidSteelDmg'][1],e['H90LiquidWind'][1]),(5,150.,True));self.assertIn('Tornado',effects[-1][0]);raw[0]='A0QH';e[n]();self.assertEqual((e['udg_LiquidSteelBounces'][2],e['udg_LiquidSteelDmg'][2],e['H90LiquidWind'][2]),(15,999.,0));self.assertIn('WaterElemental',effects[-1][0])
  self.assertIn('set udg_DamageElement=6',self.fs['Trig_Spell_LiquidSteel_Loop']);self.assertIn('set udg_DamageElement=4',self.fs['Trig_Spell_LiquidSteel_Loop'])
 def test_ai_ready_orders_support_and_new_roles(self):
  names=['H90_AI'];s,e,d,types,hp,floats,orders,*_=self.setup(names);ready=[None]
  e.update(Forest86_Ready=lambda u,raw,cost:raw==ready[0],M89_Ally=lambda *a:3,H90_Food=lambda *a:3,IsUnitInRange=lambda *a:True);e=execute(s,names,e)
  for raw,spell,order in [('ngno','hFK0','healingwave'),('nggr','hDV0','devour'),('nsgg','hTT0','roar'),('narg','hHB0','thunderbolt'),('n01P','hER0','entanglingroots'),('nwld','hBI0','cripple'),('nwlg','hHW0','roar'),('nspb','hBO0','firebolt'),('ngnv','hWW0','whirlwind'),('ngnw','hAA0','chainlightning'),('ngrk','hAV0','avatar'),('ngst','hGS0','stomp'),('nggr','hRD0','howlofterror'),('nwrg','hMF0','cripple')]:
   types[1]=raw;ready[0]=spell;orders.clear();e['H90_AI'](1,2);self.assertTrue(orders,(raw,spell));self.assertEqual(orders[0][1],order,(raw,spell))
 def test_gaya_break_stun_clears_every_added_taunt_and_only_own_hero(self):
  names=['H90_BreakTaunt','Trig_Gaya_BreakStun_Actions','Forest86_Order'];s,e,d,types,hp,floats,orders,*_=self.setup(names);removed=[];forced=[]
  e.update(GetTriggerUnit=lambda:7,GetOwningPlayer=lambda u:0,Player_GetHero=lambda p:2,UnitRemoveAbility=lambda *a:removed.append(a),GetIssuedOrderId=lambda:1,OrderId=lambda *a:2,GetOrderTargetUnit=lambda:None,Forest86_Alive=lambda *a:True,Forest86_TauntOrder=lambda *a:forced.append(a));e=execute(s,names,e)
  for raw in ['ngnb','nowe','ncnk','nenf','ngnv','nsgg']:
   types[1]=raw;e['Forest86Taunted'].update({2,3});d[2,20]=1;d[2,21]=5.;d[3,20]=4;d[3,21]=5.;d[1,100]=5.;orders.clear();e['Trig_Gaya_BreakStun_Actions']()
   self.assertNotIn(2,e['Forest86Taunted']);self.assertIn(3,e['Forest86Taunted']);self.assertNotIn((2,20),d);self.assertNotIn((2,21),d);self.assertEqual(d[3,20],4);self.assertEqual(d[1,100],5.);self.assertIn((2,'stop'),orders)
   e['GetTriggerUnit']=lambda:2;e['Forest86_Order']();self.assertEqual(forced,[]);e['GetTriggerUnit']=lambda:7
  for rank in [1,2,3]:self.assertIn('Taunt',fields(self.a['A0B4'])['aub1',rank])
 def test_source_runtime_parity_no_new_polling_and_player_abilities_preserved(self):
  for lib,source in self.after.modules.items():
   old=functions(self.before.modules[lib])
   for n,b in functions(source).items():
    if n not in old or tokens(b)!=tokens(old[n]):self.assertEqual(tokens(b),tokens(self.fs[n]),(lib,n))
  text='\n'.join(b for n,b in self.fs.items() if n.startswith('H90_') and not n.endswith('UpdateSpawnTimer'))
  for forbidden in ['GetLocalPlayer','BlzGetLocal','IsUnitVisible','TimerStart']:self.assertNotIn(forbidden,text)
  old=all_objects(self.before,'w3a')
  for raw in ['A0AE','A10N','fI86','A0QH','A01Q']:self.assertEqual(self.a[raw],old[raw],raw)
  self.assertEqual(all_objects(self.before,'w3t'),all_objects(self.after,'w3t'))
if __name__=='__main__':unittest.main()
