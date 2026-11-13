import sys,unittest,math,json,struct
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_v2 import *
from v2_icy import STATS as ICY_STATS
from test_ancient99 import table_env
from test_armory_materia import execute

def env(source):
 e=table_env(source);e.update(D2Data={},D2Poison={},D2Watch=set(),D2Serial=0,N98Data={},N98Buffs=set(),N98Pulls=set(),I2Data={},I2Stacks={},I2Active=set(),I2Serial=0,Forest86Data={},Forest86Taunted=set(),CreateGroup=set,FirstOfGroup=lambda g:next(iter(g),None),IsUnitIllusion=lambda u:False,SaveEffectHandle=lambda t,p,k,v:t.__setitem__((p,k),v),LoadEffectHandle=lambda t,p,k:t.get((p,k)),SaveTimerHandle=lambda t,p,k,v:t.__setitem__((p,k),v),LoadTimerHandle=lambda t,p,k:t.get((p,k)),GetUnitAbilityLevel=lambda *a:1,Forest86_Alive=lambda u:u is not None,GetUnitTypeId=lambda u:'hero',OrderId=lambda s:s)
 return e
class V2Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.old=View(BASE);c.v=View(OUT);c.f=functions(c.v.runtime);c.u=all_objects(c.v,'w3u');c.a=all_objects(c.v,'w3a');c.b=all_objects(c.v,'w3h')
 def run_j(self,names,changes={}):
  s='\n'.join(self.f[n] for n in names);e=env(s);e.update(changes);return execute(s,names,e)
 def test_stats_and_removed_spells(self):
  for raw,(lv,hp,armor,low,high) in dict(STATS,**ICY_STATS).items():
   f=fields(self.u[raw]);self.assertEqual((f['ulev',None],f['uhpm',None],f['udef',None],f['ua1b',None]+1,f['ua1b',None]+f['ua1s',None]),(lv,hp,armor,low,high),raw)
  for raw,removed in {'nsbm':['A0PI','Aspd'],'n025':['A0UT','A0B6'],'n0MQ':['A1C5','A12U','A0BD'],'n026':['A0B5'],'n02C':['A040','A0BK'],'n029':['A0BG'],'n02D':['A0B6','A0BG'],'n027':['A0BD','A0B5','A1F4','A0BM'],'n028':['A0BM','A0BC','A0Z0']}.items():
   for r in removed:self.assertNotIn(r,fields(self.u[raw])['uabi',None],raw)
  self.assertEqual(fields(self.u['qL99'])['ubui',None],'')
 def test_unrelated_items_jobs_arenas_autosave_preserved(self):
  for lib in self.old.modules:
   if 'Arena' in lib or lib in ['TSpawn','TLancer','TThief','TJob','TSave','TCmd','TAutoSave','TQuickCast']:self.assertEqual(self.old.modules[lib],self.v.modules[lib],lib)
  for ext in ['w3t','w3q','w3b','w3d']:self.assertEqual(self.old.archive.read('war3map.'+ext),self.v.archive.read('war3map.'+ext))
  old=functions(self.old.runtime)
  self.assertEqual(tokens(old['Trig_Spawn_Pools_Init_Actions']),tokens(self.f['Trig_Spawn_Pools_Init_Actions']))
  for n in old:
   if 'Autosave' in n or 'AutoSave' in n:self.assertEqual(tokens(old[n]),tokens(self.f[n]),n)
 def test_only_bearers_have_aura_art(self):
  for r in ['hEA0','nAU8','zTH9']:
   for k in ['acat','atat','asat','aeat','aaea']:self.assertEqual(fields(self.a[r])[k,0],BLANK)
  for r in ['bE90','bMP8','bTH9']:self.assertEqual(fields(self.b[r])['ftat',None],BLANK)
  e=self.run_j(['D2_AuraPath'],{'GetUnitTypeId':lambda u:u})
  self.assertIn('EvasiveGreen',e['D2_AuraPath']('nfsh'));self.assertIn('AbyssalPurple',e['D2_AuraPath']('nnsw'));self.assertIn('ThornsAura',e['D2_AuraPath']('n00P'));self.assertEqual(e['D2_AuraPath']('nftb'),'')
  bearers=[r for r,o in self.u.items() if 'hEA0' in fields(o).get(('uabi',None),'')];self.assertEqual(bearers,['nfsh'])
  self.assertNotIn('DarkPortal',self.f['F99_VortexFx']);self.assertIn('TornadoElementalSmall',self.f['F99_VortexFx'])
 def test_brood_poison_stacks_get_five_independent_ticks(self):
  hits=[];names=['D2_ClearPoison','D2_PoisonAdd','D2_PoisonTick'];e=self.run_j(names,{'GetHeroLevel':lambda u:40,'UnitDamageTarget':lambda c,u,damage,*a:hits.append(damage),'ATTACK_TYPE_NORMAL':0,'DAMAGE_TYPE_MAGIC':0})
  e['D2_PoisonAdd'](1,2)
  for t in range(1,3):e['Forest86Now']=t;e['D2_PoisonTick'](2)
  e['D2_PoisonAdd'](1,2)
  for t in range(3,8):e['Forest86Now']=t;e['D2_PoisonTick'](2)
  self.assertEqual(hits,[300.,300.,600.,600.,600.,300.,300.]);self.assertFalse(e['D2Poison']);self.assertNotIn((2,80),e['D2Data'])
 def test_brood_poison_chance(self):
  applications=[];roll=[35];e=self.run_j(['D2_OnHit'],{'GetUnitTypeId':lambda u:'nsbm','BlzGetEventIsAttack':lambda:True,'Forest86_Enemy':lambda *a:True,'IsUnitType':lambda *a:True,'UNIT_TYPE_HERO':1,'GetRandomInt':lambda *a:roll[0],'D2_PoisonAdd':lambda *a:applications.append(a)})
  e['D2_OnHit'](1,2);roll[0]=36;e['D2_OnHit'](1,2);self.assertEqual(applications,[(1,2)])
 def test_permanent_split_children(self):
  born=[];e=self.run_j(['D2_SpawnOffspring'],{'udg_SpawnTimerHash':{},'GetUnitUserData':lambda u:7,'LoadGroupHandle':lambda *a:None,'GetUnitX':lambda u:0.,'GetUnitY':lambda u:0.,'Cos':math.cos,'Sin':math.sin,'bj_DEGTORAD':math.pi/180,'UNIT_TYPE_SUMMONED':1,'F99_Summon':lambda *a:(born.append(a) or len(born))})
  e['D2_SpawnOffspring'](1,'nsbm',3);self.assertEqual(len(born),3);self.assertTrue(all(a[-1]==0. for a in born))
  calls=[];e=self.run_j(['D2_Death'],{'GetUnitTypeId':lambda u:'nsbm','D2_SpawnOffspring':lambda *a:calls.append(a)});e['D2_Death'](1);self.assertEqual(calls,[(1,'nspr',2)])
 def test_death_roar_only_spider_family_stacks_permanently(self):
  ranks=[];raw={1:'nspr',2:'n010',3:'nsbm',4:'nspr',5:'n010',6:'other'}
  e=self.run_j(['D2_SpiderRoar'],{'GroupEnumUnitsInRange':lambda g,*a:g.update(raw),'GetUnitX':lambda u:0.,'GetUnitY':lambda u:0.,'GetUnitTypeId':lambda u:raw[u],'IsUnitAlly':lambda u,p:u!=5,'SetUnitAbilityLevel':lambda *a:ranks.append(a)})
  e['D2_SpiderRoar'](1);e['D2_SpiderRoar'](1);self.assertEqual(ranks,[(2,'dFR2',1),(3,'dFR2',1),(2,'dFR2',2),(3,'dFR2',2)])
  self.assertAlmostEqual(fields(self.a['dFR2'])['Isx1',2],.1)
 def test_eggs_are_timer_not_separate_unit(self):
  self.assertNotIn("raw=='zEG9'",self.f['F99_Spell']);self.assertIn('Forest86Now+10.',self.f['D2_Spell']);self.assertIn('EggSack0.mdl',self.f['D2_Spell']);self.assertNotIn('SetUnitMaxHP',self.f['D2_Spell'])
  data={(1,50):10.,(1,51):'eggs'};born=[];e=self.run_j(['D2_TickUnit'],{'D2Data':data,'GetEnumUnit':lambda:1,'D2_AuraPath':lambda u:'','Forest86Now':9.,'D2_SpawnOffspring':lambda *a:born.append(a),'D2_Active':lambda *a:False})
  e['D2_TickUnit']();self.assertFalse(born);e['Forest86Now']=10.;e['D2_TickUnit']();e['D2_TickUnit']();self.assertEqual(born,[(1,'nsbm',3)]);self.assertNotIn((1,50),data)
 def test_root_movement_restores_even_when_hidden_move_query_was_false(self):
  data={(1,10):30.,(1,14):0.,(1,13):270.,(1,16):12,(1,15):1000.,(1,17):False};events=[]
  e=self.run_j(['F99_RootEnd'],{'F99Data':data,'GetUnitTypeId':lambda u:'n00O','BlzGetUnitArmor':lambda u:125.,'BlzGetUnitBaseDamage':lambda *a:450,'UnitAddAbility':lambda *a:events.append(('ability',a[1])),'SetUnitMoveSpeed':lambda u,s:events.append(('speed',s)),'UNIT_WEAPON_RF_ATTACK_RANGE':0})
  e['F99_RootEnd'](1);self.assertEqual(events[:2],[('ability','Amov'),('speed',270.)])
  f=fields(self.u['n00O']);self.assertEqual((f['ua1r',None],f['ua1w',None],f['uaen',None],f['ua2r',None]),(1000.,'missile',2,128.))
  e=self.run_j(['F99_Active'],{'F99Data':{(1,10):30.},'GetUnitTypeId':lambda u:'n00O','Forest86Now':900.});self.assertTrue(e['F99_Active'](1,10))
 def test_tower_chases_escaped_target(self):
  events=[];e=self.run_j(['D2_TowerTick'],{'D2Data':{(1,22):2},'Forest86_Enemy':lambda *a:True,'IsUnitInRange':lambda *a:False,'D2_FindEnemy':lambda *a:None,'F99_RootEnd':lambda u:events.append('uproot'),'IssueTargetOrder':lambda *a:events.append(a)})
  e['D2_TowerTick'](1);self.assertEqual(events,['uproot',(1,'attack',2)])
 def test_cover_active_30_seconds_only(self):
  self.assertEqual(fields(self.a['zCV9'])['acdn',1],45.)
  self.assertIn('D2_Active(u,60)',self.f['F99_Cover']);self.assertLess(self.f['F99_AI'].index("raw=='n00N'"),self.f['F99_AI'].index('if F99_Active(u,10)'))
  e=self.run_j(['D2_Active'],{'D2Data':{(1,60):30.},'Forest86Now':29.});self.assertTrue(e['D2_Active'](1,60));e['Forest86Now']=30.;self.assertFalse(e['D2_Active'](1,60))
 def test_images_expiration_never_rewards(self):
  data={(1,30):2};hp=[3200];damage=[240];e=self.run_j(['N98_ImageDeath'],{'N98Data':data,'GetKillingUnit':lambda:3,'IsUnitEnemy':lambda *a:True,'BlzGetUnitMaxHP':lambda u:hp[0],'BlzSetUnitMaxHP':lambda u,v:hp.__setitem__(0,v),'GetWidgetLife':lambda u:1000.,'BlzGetUnitBaseDamage':lambda *a:damage[0],'BlzSetUnitBaseDamage':lambda u,v,i:damage.__setitem__(0,v)})
  e['N98_ImageDeath'](1);e['N98_ImageDeath'](1);self.assertEqual((hp[0],damage[0]),(4700,360))
  data[1,30]=2;data[1,32]=True;e['N98_ImageDeath'](1);self.assertEqual(hp[0],4700)
  self.assertNotIn('N98_ImageDeath',self.f['N98_Cleanup']);self.assertIn('TimerStart(clock,30.,false',self.f['D2_ImageLife']);self.assertEqual(fields(self.a['nMI8'])['acdn',1],60.)
 def test_infernal_uses_native_meteor_landing(self):
  o=self.a['zIF9'];f=fields(o);self.assertEqual(o['base'],'ANin');self.assertEqual((f['Uin1',1],f['Uin3',1],f['Uin4',1]),(2000.,1.5,'qI99'));self.assertNotIn("raw=='zIF9'",self.f['F99_Spell'])
 def test_icy_devour_only_pool_injured_twice(self):
  data={};e=self.run_j(['I2_Pool','I2_FoodValid'],{'Forest86Data':data,'GetUnitTypeId':lambda u:u,'M89_Injured':lambda u:u!='n025','IsUnitAlly':lambda *a:True,'IsUnitType':lambda *a:False,'IsUnitInGroup':lambda *a:False,'udg_SpecialUnits':set(),'UNIT_TYPE_HERO':0})
  self.assertTrue(e['I2_FoodValid']('n02B','n027'));self.assertFalse(e['I2_FoodValid']('n02B','n025'));self.assertFalse(e['I2_FoodValid']('n02B','nfsh'));data['n02B',90]=2;self.assertFalse(e['I2_FoodValid']('n02B','n027'))
  self.assertEqual(fields(self.a['jDV2'])['acdn',1],20.)
 def test_beam_stacks_expire_separately(self):
  e=self.run_j(['I2_AddSlow','I2_ExpireSlow','I2_ClearSlow']);e['I2_AddSlow'](1,2);e['Forest86Now']=5.;e['I2_AddSlow'](1,2);e['Forest86Now']=30.;e['I2_ExpireSlow'](2);self.assertEqual(e['I2Data'][2,72],1);e['Forest86Now']=35.;e['I2_ExpireSlow'](2);self.assertFalse(e['I2Stacks']);self.assertNotIn((2,72),e['I2Data'])
 def test_cold_line_heals_or_stuns_once(self):
  hits=[];heals=[];e=self.run_j(['I2_WaveHit'],{'udg_ArgIndex':1,'udg_ArgUnit':2,'udg_MissileCaster':{1:5},'udg_MissileHitGroup':{1:set()},'IsUnitInGroup':lambda u,g:u in g,'IsUnitAlly':lambda u,p:u==2,'Forest86_Enemy':lambda *a:True,'M89_Heal':lambda *a:heals.append(a),'M89_Dummy':lambda *a:hits.append(a)})
  e['I2_WaveHit']();e['I2_WaveHit']();e['udg_ArgUnit']=3;e['I2_WaveHit']();self.assertEqual(heals,[(5,2,2500.)]);self.assertEqual(hits,[(5,3,'jST2','thunderbolt')]);self.assertEqual(fields(self.a['jST2'])['adur',1],3.)
 def test_alert_and_damage_numbers(self):
  self.assertIn('Forest86Now+30.',self.f['Forest86_Alert']);self.assertIn('I2AlertUntil=Forest86Now+60.',self.f['Forest86_AI']);self.assertIn('zone==8',self.f['Forest86_SpawnFactor'])
  f=fields(self.a['jBF2']);self.assertEqual((f['Ucs1',1],f['Nbf5',1],f['adur',1]),(3000.,500.,5.))
  f=fields(self.a['jRO2']);self.assertEqual((f['Htb1',1],f['adur',1]),(3000.,4.))
  f=fields(self.a['jCR2']);self.assertEqual((f['Ocr1',1],f['Ocr2',1]),(30.,2.))
  self.assertIn('call I2_SurgeImpact(u,victim)',self.f['B88_ChargeEnd']);self.assertIn("'bDT2'",self.f['H90_BreakTaunt'])
 def test_regen_thirty_ticks_and_second_slam(self):
  data={(1,10):30.,(1,11):12500./30.,(1,12):5,(1,13):1.,(1,50):2.,(1,51):100.,(1,52):200.};heals=[];slams=[]
  e=self.run_j(['I2_TickUnit'],{'I2Data':data,'GetEnumUnit':lambda:1,'M89_Heal':lambda c,u,v:heals.append(v),'I2_Slam':lambda *a:slams.append(a)})
  for t in range(1,32):e['Forest86Now']=float(t);e['I2_TickUnit']()
  self.assertEqual(len(heals),30);self.assertAlmostEqual(sum(heals),12500.);self.assertEqual(slams,[(1,100.,200.,500.)]);self.assertNotIn((1,10),data)
 def test_duel_stays_until_caster_or_target_dies_or_break_stun(self):
  data={(1,30):2};taunts={(2,20):1};alive={1,2};taunted={2}
  e=self.run_j(['I2_Dueling','I2_DuelTick'],{'I2Data':data,'Forest86Data':taunts,'Forest86Taunted':taunted,'IsUnitInGroup':lambda u,g:u in g,'Forest86_Alive':lambda u:u in alive})
  self.assertTrue(e['I2_Dueling'](1));alive.remove(1);self.assertFalse(e['I2_Dueling'](1));alive.add(1);taunted.clear();self.assertFalse(e['I2_Dueling'](1));e['I2_DuelTick'](1);self.assertNotIn((1,30),data)
 def test_bite_heal_penalty_and_native_regen_restoration(self):
  life=[1000.];e=self.run_j(['M89_Heal'],{'I2_Active':lambda *a:True,'BlzGetUnitMaxHP':lambda u:20000,'GetWidgetLife':lambda u:life[0],'SetWidgetLife':lambda u,v:life.__setitem__(0,v)})
  e['M89_Heal'](1,2,2500.);self.assertEqual(life[0],2250.)
  regen=[5.];data={(2,40):15.,(2,41):5.,(2,43):True}
  e=self.run_j(['I2_WoundEnd'],{'I2Data':data,'UNIT_RF_HIT_POINTS_REGENERATION_RATE':0,'BlzGetUnitRealField':lambda *a:regen[0],'BlzSetUnitRealField':lambda u,f,v:regen.__setitem__(0,v)})
  e['I2_WoundEnd'](2);e['I2_WoundEnd'](2);self.assertEqual(regen[0],10.);self.assertNotIn((2,40),data)
 def test_bear_surge_extra_ice_and_pulverize(self):
  hits=[];areas=[];e=self.run_j(['I2_OnHit'],{'I2Proccing':False,'GetUnitTypeId':lambda u:'n028','BlzGetEventIsAttack':lambda:True,'Forest86_Enemy':lambda *a:True,'I2_Active':lambda *a:True,'GetRandomInt':lambda *a:25,'M89_Damage':lambda *a:hits.append(a),'M89_Area':lambda *a:areas.append(a),'GetUnitX':lambda u:10.,'GetUnitY':lambda u:20.})
  e['I2_OnHit'](1,2);self.assertEqual(hits,[(1,2,500.,2)]);self.assertEqual(areas,[(1,10.,20.,300.,700.,2,False)]);self.assertFalse(e['I2Proccing'])
 def test_marsh_stats_and_spell_isolation(self):
  from v2_marsh import STATS as marsh
  old=all_objects(self.old,'w3u')
  for raw,(lv,hp,armor,low,high) in marsh.items():
   f=fields(self.u[raw]);original=fields(old[raw]);self.assertEqual(f['udef',None],armor)
   if lv:self.assertEqual(f['ulev',None],lv)
   else:self.assertEqual(f.get(('ulev',None)),original.get(('ulev',None)))
   if hp:self.assertEqual(f['uhpm',None],hp)
   else:self.assertEqual(f.get(('uhpm',None)),original.get(('uhpm',None)))
   if low:self.assertEqual((f['ua1b',None]+1,f['ua1b',None]+f['ua1s',None]),(low,high))
  for raw,spell in [('n03H','A040'),('n03J','Acrs'),('n03I','Aap3'),('n03E','A11D')]:self.assertNotIn(spell,fields(self.u[raw])['uabi',None])
  for raw,damage,mana,cd in [('kOB2',5000.,1000,30.),('kLB2',4000.,200,10.),('kWB2',4000.,200,10.),('kFB2',4000.,200,10.)]:
   f=fields(self.a[raw]);self.assertEqual((f['Ucs1',1],f['Nbf5',1],f['amcs',1],f['acdn',1]),(damage,0.,mana,cd))
  olda=all_objects(self.old,'w3a')
  for raw in ['A040','A11D','A0Z0','A0BK','A0YR','Aap3']:self.assertEqual(self.a[raw],olda[raw],raw)
 def test_marsh_devour_pool_and_two_use_limit(self):
  e=self.run_j(['M2_Pool','M2_FoodValid'],{'GetUnitTypeId':lambda u:u,'M89_Injured':lambda u:True,'IsUnitAlly':lambda *a:True,'IsUnitType':lambda *a:False,'IsUnitInGroup':lambda *a:False,'udg_SpecialUnits':set(),'UNIT_TYPE_HERO':0})
  self.assertTrue(e['M2_FoodValid']('n03H','n03I'));self.assertFalse(e['M2_FoodValid']('n03H','n025'));e['Forest86Data']['n03H',90]=2;self.assertFalse(e['M2_FoodValid']('n03H','n03I'))
 def test_vampirism_uses_different_rates_and_caps_overkill(self):
  life={1:1000.,2:100.};e=self.run_j(['M2_Lifesteal'],{'Forest86_Enemy':lambda *a:True,'I2_Active':lambda *a:False,'GetWidgetLife':lambda u:life[u],'BlzGetUnitMaxHP':lambda u:2000,'SetWidgetLife':lambda u,v:life.__setitem__(u,v)})
  e['M2_Lifesteal'](1,2,1000.,True,False,False,False,False);self.assertEqual(life[1],1001.)
  e['M2_Lifesteal'](1,2,1000.,False,True,False,False,False);self.assertEqual(life[1],1006.)
  e['M2_Lifesteal'](1,2,1000.,False,True,True,False,False);e['M2_Lifesteal'](1,2,1000.,False,True,False,False,True);self.assertEqual(life[1],1006.)
 def test_sacrifice_heals_other_allies_and_uses_normal_kill_credit(self):
  heals=[];deaths=[];life={1:2999.,2:1000.,3:1000.,4:1000.}
  e=self.run_j(['M2_Sacrifice'],{'GroupEnumUnitsInRange':lambda g,*a:g.update([1,2,3,4]),'GetWidgetLife':lambda u:life[u],'SetWidgetLife':lambda u,v:life.__setitem__(u,v),'GetUnitX':lambda u:u*10.,'GetUnitY':lambda u:0.,'IsUnitAlly':lambda u,p:u in [1,2],'IsUnitType':lambda u,t:u in [3,4],'Forest86_Enemy':lambda *a:True,'UNIT_TYPE_HERO':1,'M89_Heal':lambda *a:heals.append(a),'UnitDamageTarget':lambda *a:deaths.append(a),'ATTACK_TYPE_CHAOS':0,'DAMAGE_TYPE_UNIVERSAL':0})
  e['M2_Sacrifice'](1);self.assertEqual(heals,[(1,2,5000.)]);self.assertEqual(deaths[0][:3],(3,1,2.));self.assertEqual(life[1],1.)
  deaths.clear();heals.clear();life[1]=3000.;e['M2_Sacrifice'](1);self.assertFalse(heals);self.assertFalse(deaths)
  self.assertIn('l_amount=l_amount*.75',self.f['Trig_Damage_Engine_Step08_Elements']);self.assertIn("'bPL2'",self.f['Trig_Damage_Engine_GetAccuracy']);self.assertEqual(fields(self.a['kPL2'])['Apl2',1],500.)
 def test_no_local_gameplay_or_new_periodic_timer(self):
  for path in ['experiments/V2/V2.j','experiments/V2/Icy.j']:
   s=(ROOT/path).read_text();self.assertNotIn('GetLocalPlayer',s);self.assertNotIn(',true,function',s)
  for s in ['D2_Tick','I2_Tick']:self.assertIn('udg_InCinematicMode',self.f['F99_Tick' if s=='D2_Tick' else s])
if __name__=='__main__':unittest.main()
