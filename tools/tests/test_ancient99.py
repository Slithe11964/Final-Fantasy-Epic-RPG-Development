import sys,unittest,math,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_ancient99 import *
from test_armory_materia import execute
from test_shared_context import mocks

def table_env(source,data=None):
 e=mocks(source);data={} if data is None else data
 e.update(F99Data=data,F99Stacks={},F99Serial=0,F99Active=set(),F99Guardians=set(),Forest86Now=0.,GetHandleId=lambda u:u,I2R=float,IMinBJ=min,RMinBJ=min,RMaxBJ=max,LoadInteger=lambda t,p,k:t.get((p,k),0),LoadReal=lambda t,p,k:t.get((p,k),0.),LoadBoolean=lambda t,p,k:t.get((p,k),False),LoadUnitHandle=lambda t,p,k:t.get((p,k)),LoadLightningHandle=lambda t,p,k:t.get((p,k)),HaveSavedReal=lambda t,p,k:(p,k) in t,HaveSavedHandle=lambda t,p,k:(p,k) in t,SaveInteger=lambda t,p,k,v:t.__setitem__((p,k),v),SaveReal=lambda t,p,k,v:t.__setitem__((p,k),v),SaveBoolean=lambda t,p,k,v:t.__setitem__((p,k),v),SaveUnitHandle=lambda t,p,k,v:t.__setitem__((p,k),v),RemoveSavedInteger=lambda t,p,k:t.pop((p,k),None),RemoveSavedReal=lambda t,p,k:t.pop((p,k),None),RemoveSavedBoolean=lambda t,p,k:t.pop((p,k),None),RemoveSavedHandle=lambda t,p,k:t.pop((p,k),None),FlushChildHashtable=lambda t,p:[t.pop(k,None) for k in list(t) if k[0]==p],GroupAddUnit=lambda g,u:g.add(u),GroupRemoveUnit=lambda g,u:g.discard(u),GetUnitTypeId=lambda u:'hero',GetOwningPlayer=lambda u:11)
 return e
class Ancient99Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.old=View(BASE);c.v=View(OUT);c.f=functions(c.v.runtime);c.u=all_objects(c.v,'w3u');c.a=all_objects(c.v,'w3a');c.b=all_objects(c.v,'w3h')
 def test_normal_stats_and_summon_stats(self):
  for r,(lv,hp,ar,lo,hi) in STATS.items():
   f=fields(self.u[r]);self.assertEqual((f['ulev',None],f['uhpm',None]),(lv,hp),r)
   if ar is not None:self.assertEqual(f['udef',None],ar,r)
   if lo is not None:self.assertEqual((f['ua1b',None]+f['ua1d',None],f['ua1b',None]+f['ua1d',None]*f['ua1s',None]),(lo,hi),r)
  for r,(base,name,lv,hp,ar,atype,lo,hi,attack,reach,speed) in SUMMONS.items():
   f=fields(self.u[r]);self.assertEqual((f['ulev',None],f['uhpm',None],f['udef',None],f['udty',None]),(lv,hp,ar,atype),r)
  self.assertEqual(fields(self.u['n010'])['unam',None],'Mother Spider')
 def test_old_ui_items_arenas_and_pools_preserved(self):
  for lib in self.old.modules:
   if 'Arena' in lib or lib in ['TSpawn','TLancer','TThief','TJob']:self.assertEqual(self.old.modules[lib],self.v.modules[lib],lib)
  old=functions(self.old.modules['TEquip']);new=functions(self.v.modules['TEquip'])
  for n in old:
   if n!='Forsaken_Stat_GetAccuracy':self.assertEqual(tokens(old[n]),tokens(new[n]),n)
  self.assertEqual(self.old.archive.read('war3map.w3t'),self.v.archive.read('war3map.w3t'))
  old=all_objects(self.old,'w3a')
  for r in old:
   if r!='nFA8':self.assertEqual(old[r],self.a[r],r)
 def test_frost_armor_correct_real_field_and_aura_assets(self):
  f=fields(self.a['nFA8']);self.assertEqual((f['Ufa1',1],f['Ufa2',1]),(5.,50.))
  for r,asset in [('bMP8','AbyssalPurple'),('bE90','EvasiveGreen')]:self.assertEqual(fields(self.b[r])['ftat',None],'war3mapImported\\'+asset+'.mdx')
  for p in (ROOT/'experiments/Ancient99/Assets').iterdir():self.assertEqual(self.v.archive.read('war3mapImported\\'+p.name),p.read_bytes())
  self.assertIn('call F99_VortexFx(x,y)',self.f['N98_Vortex']);self.assertIn('TimerStart(t,2.,false,function F99_FxEnd)',self.f['F99_VortexFx'])
 def test_accuracy_stacks_expire_individually(self):
  names=['F99_Count','F99_ClearStack','F99_AddStack','F99_ExpireStacks'];s='\n'.join(self.f[n] for n in names);e=table_env(s);e=execute(s,names,e)
  e['F99_AddStack'](1,2,1,30.);e['Forest86Now']=5.;e['F99_AddStack'](1,2,1,30.);self.assertEqual(e['F99_Count'](2,1),2)
  e['Forest86Now']=30.;e['F99_ExpireStacks'](2,1);self.assertEqual(e['F99_Count'](2,1),1)
  e['Forest86Now']=35.;e['F99_ExpireStacks'](2,1);self.assertEqual(e['F99_Count'](2,1),0);self.assertFalse(e['F99Stacks'])
 def test_binding_fifteen_stacks_stuns_and_clears(self):
  names=['F99_Count','F99_ClearStack','F99_AddStack','F99_ExpireStacks'];s='\n'.join(self.f[n] for n in names);marks=[];e=table_env(s);e.update(M89_Dummy=lambda *a:marks.append(a));e=execute(s,names,e)
  for i in range(14):e['F99_AddStack'](1,2,2,45.)
  self.assertEqual(e['F99_Count'](2,2),14);e['F99_AddStack'](1,2,2,45.);self.assertEqual(e['F99_Count'](2,2),0);self.assertFalse(e['F99Stacks']);self.assertEqual(marks[-1],(1,2,'zST9','thunderbolt'))
  self.assertEqual(fields(self.a['zST9'])['adur',1],5.)
 def test_death_yells_stack_and_expire_individually(self):
  names=['F99_Count','F99_ClearStack','F99_AddStack','F99_ExpireStacks'];s='\n'.join(self.f[n] for n in names);ranks=[];e=table_env(s);e.update(SetUnitAbilityLevel=lambda u,r,k:ranks.append(k));e=execute(s,names,e)
  e['F99_AddStack'](1,2,3,20.);e['Forest86Now']=5.;e['F99_AddStack'](3,2,3,20.);self.assertEqual(ranks,[1,2])
  e['Forest86Now']=20.;e['F99_ExpireStacks'](2,3);self.assertEqual(e['F99_Count'](2,3),1);self.assertEqual(ranks[-1],1);e['Forest86Now']=25.;e['F99_ExpireStacks'](2,3);self.assertEqual(e['F99_Count'](2,3),0)
 def test_shell_hatches_once_into_original_three_brood_mothers(self):
  s=self.f['F99_Brood'];born=[];e=table_env(s);e.update(GetUnitX=lambda u:10.,GetUnitY=lambda u:20.,Cos=math.cos,Sin=math.sin,bj_DEGTORAD=math.pi/180,F99_Summon=lambda *a:(born.append(a) or len(born)));e=execute(s,['F99_Brood'],e)
  e['F99_Brood'](1);e['F99_Brood'](1);self.assertEqual(len(born),3);self.assertTrue(all(a[1]=='nsbm' for a in born))
  self.assertNotIn('A018',fields(self.u['n010'])['uabi',None]);self.assertIn("raw=='n010' or raw=='qE99'",self.f['F99_Death'])
 def test_rooted_production_six_times_and_end(self):
  s=self.f['F99_TickUnit'];data={(1,10):30.,(1,11):5.,(1,18):100.,(1,19):200.};born=[];ended=[];now=[0.];e=table_env(s,data)
  e.update(GetEnumUnit=lambda:1,GetUnitTypeId=lambda u:'n00P',Forest86_Alive=lambda u:True,F99_Active=lambda u,k:now[0]<data.get((u,k),0),F99_ExpireStacks=lambda *a:None,F99_Count=lambda *a:0,GetUnitX=lambda u:100.,GetUnitY=lambda u:200.,F99_Summon=lambda *a:(born.append(a) or 5),F99_RootEnd=lambda u:(ended.append(u),data.pop((u,10),None)))
  e=execute(s,['F99_TickUnit'],e)
  for t in range(1,31):now[0]=float(t);e['Forest86Now']=float(t);e['F99_TickUnit']()
  self.assertEqual(len(born),6);self.assertTrue(all(a[1]=='qL99' for a in born));self.assertEqual(ended,[1])
 def test_root_stats_restore_without_losing_external_bonuses(self):
  s=self.f['F99_RootEnd'];data={(1,10):30.,(1,14):100.,(1,13):270.,(1,15):128.,(1,16):12,(1,17):True};armor=[280.];damage=[500];sides=[];moves=[];e=table_env(s,data)
  e.update(GetUnitTypeId=lambda u:'n00O',BlzGetUnitArmor=lambda u:armor[0],BlzSetUnitArmor=lambda u,v:armor.__setitem__(0,v),BlzGetUnitBaseDamage=lambda *a:damage[0],BlzSetUnitBaseDamage=lambda u,v,i:damage.__setitem__(0,v),BlzSetUnitDiceSides=lambda *a:sides.append(a[1]),SetUnitMoveSpeed=lambda u,v:moves.append(v),UNIT_WEAPON_RF_ATTACK_RANGE=0)
  e=execute(s,['F99_RootEnd'],e);e['F99_RootEnd'](1);e['F99_RootEnd'](1);self.assertEqual((armor[0],damage[0],sides,moves),(180.,400,[12],[270.]))
 def test_poison_uses_target_hero_level_and_probability(self):
  s=self.f['F99_OnHit'];data={};roll=[30];e=table_env(s);e.update(Forest86Data=data,Forest86Poisoned=set(),BlzGetEventIsAttack=lambda:True,GetUnitTypeId=lambda u:'nenp',Forest86_Enemy=lambda *a:True,IsUnitType=lambda *a:True,UNIT_TYPE_HERO=1,GetRandomInt=lambda *a:roll[0],GetHeroLevel=lambda u:13);e=execute(s,['F99_OnHit'],e)
  e['F99_OnHit'](1,2);self.assertEqual(data[2,11],391.);self.assertEqual(data[2,12],10.);data.clear();roll[0]=31;e['F99_OnHit'](1,2);self.assertFalse(data)
 def test_cover_only_nearest_living_friendly_guardian_within_800(self):
  s=self.f['F99_Cover'];pos={1:0.,2:600.,3:100.,4:801.,5:300.};e=table_env(s);e.update(F99Guardians={2,3,4,5},CreateGroup=set,GroupAddGroup=lambda g,h:h.update(g),FirstOfGroup=lambda g:next(iter(g),None),GetUnitTypeId=lambda u:'qA99',Forest86_Alive=lambda u:True,IsUnitAlly=lambda u,p:u!=3,GetUnitAbilityLevel=lambda *a:1,GetUnitX=lambda u:pos[u],GetUnitY=lambda u:0.);e=execute(s,['F99_Cover'],e);self.assertEqual(e['F99_Cover'](1),5)
 def test_share_halves_once_and_has_recursion_guard(self):
  s=self.f['F99_Share'];hits=[];e=table_env(s);e.update(F99Sharing=False,GetUnitTypeId=lambda u:'qA99',F99_Cover=lambda u:2,B88_Damage=lambda *a:hits.append(a));e=execute(s,['F99_Share'],e);self.assertEqual(e['F99_Share'](9,1,1000.),500.);self.assertEqual(hits,[(9,2,500.,False)]);e['F99Sharing']=True;self.assertEqual(e['F99_Share'](9,1,1000.),1000.);self.assertEqual(len(hits),1)
 def drain_env(self,kind,mana=0.):
  s=self.f['F99_TickUnit'];data={(1,50):2,(1,51):5,(1,52):1.,(1,53):kind,(1,54):123,(1,55):'beam'};heals=[];hits=[];hp={1:6000.,2:10000.,3:1000.,4:1000.};mp={1:100.,2:mana}
  e=table_env(s,data)
  def damage(c,t,v,element):hits.append(v);hp[t]-=v*.5 if kind==1 else v
  e.update(GetEnumUnit=lambda:1,GetUnitTypeId=lambda u:'nstl',Forest86_Alive=lambda u:hp[u]>.405,F99_Active=lambda *a:False,F99_ExpireStacks=lambda *a:None,F99_Count=lambda *a:0,Forest86_Enemy=lambda *a:True,IsUnitInRange=lambda *a:True,IsUnitPaused=lambda *a:False,GetUnitCurrentOrder=lambda *a:123,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,GetWidgetLife=lambda u:hp[u],M89_Damage=damage,M89_Heal=lambda c,u,v:heals.append((u,v)),CreateGroup=set,GroupEnumUnitsInRange=lambda g,*a:g.update([1,3,4]),FirstOfGroup=lambda g:next(iter(g),None),IsUnitAlly=lambda u,p:u!=4,F99_DrainEnd=lambda u:data.pop((u,51),None),GetUnitState=lambda u,state:1000. if state==2 else mp[u],SetUnitState=lambda u,state,v:mp.__setitem__(u,v),UNIT_STATE_MANA=1,UNIT_STATE_MAX_MANA=2)
  return execute(s,['F99_TickUnit'],e),heals,hits,mp
 def test_life_drain_heals_half_actual_drained_for_five_ticks(self):
  e,heals,hits,mp=self.drain_env(1)
  for t in range(1,6):e['Forest86Now']=float(t);e['F99_TickUnit']()
  self.assertEqual(hits,[1000.]*5);self.assertEqual(heals,[(1,250.),(3,250.)]*5)
  self.assertNotIn((1,51),e['F99Data'])
 def test_mana_drain_damage_uses_actual_available_mana(self):
  e,heals,hits,mp=self.drain_env(2,125.);e['Forest86Now']=1.;e['F99_TickUnit']();self.assertEqual(hits,[250.]);self.assertEqual(mp,{1:225.,2:0.});self.assertFalse(heals)
 def test_spells_and_regional_devour_conditions(self):
  self.assertEqual(fields(self.a['zPL9'])['Apl2',1],400.)
  for r in ['zDL9','zDM9','zCU9','zSY9']:self.assertEqual(fields(self.a[r])['acdn',1],30.)
  for r in ['zDY9','zIF9']:self.assertEqual(fields(self.a[r])['acdn',1],60.)
  self.assertIn('M89_Injured(target)',self.f['F99_Spell']);self.assertIn('F99_Pool(GetUnitTypeId(target))',self.f['F99_Spell']);self.assertIn('LoadInteger(Forest86Data,id,90)<2',self.f['F99_Spell'])
  self.assertIn('return 7',self.f['B88_AlertZone']);self.assertIn('set F99AlertUntil=Forest86Now+60.',self.f['Forest86_AI']);self.assertIn('Forest86Now+20.',self.f['Forest86_Alert'])
 def test_no_local_gameplay_and_no_continuous_new_timer(self):
  text=(ROOT/'experiments/Ancient99/Ancient99.j').read_text();self.assertNotIn('GetLocalPlayer',text)
  self.assertNotIn(',true,function',text);self.assertIn('call F99_Tick()',self.f['Forest86_Tick']);self.assertIn('call F99_Death(u)',self.f['Forest86_Death'])
if __name__=='__main__':unittest.main()
