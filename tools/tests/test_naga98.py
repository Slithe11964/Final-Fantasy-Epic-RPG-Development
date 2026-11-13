import sys,re,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_naga98 import *
from build_removals91 import pool_blocks
from test_armory_materia import execute
from test_shared_context import mocks
class Naga98Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.old=View(BASE);c.v=View(OUT);c.f=functions(c.v.runtime);c.u=all_objects(c.v,'w3u');c.a=all_objects(c.v,'w3a')
 def test_stats_dice_and_existing_content_scope(self):
  old=all_objects(self.old,'w3u')
  for r,o in old.items():
   if r not in STATS:self.assertEqual(o,self.u[r],r)
  for r,(lv,hp,ar,lo,hi,mp) in STATS.items():
   f=fields(self.u[r]);self.assertEqual((f['ulev',None],f['uhpm',None],f['udef',None]),(lv,hp,ar),r)
   self.assertEqual((f['ua1b',None]+f['ua1d',None],f['ua1b',None]+f['ua1d',None]*f['ua1s',None]),(lo,hi),r)
  for r,o in all_objects(self.old,'w3a').items():self.assertEqual(o,self.a[r],r)
  for lib,s in self.old.modules.items():
   if 'Arena' in lib or lib in ['TSpawn','TLancer','TThief','TJob']:self.assertEqual(s,self.v.modules[lib],lib)
  for n,b in functions(self.old.modules['TEquip']).items():
   if n!='Forsaken_Stat_GetElementResist':self.assertEqual(tokens(b),tokens(functions(self.v.modules['TEquip'])[n]),n)
  self.assertEqual(self.old.archive.read('war3map.w3t'),self.v.archive.read('war3map.w3t'))
 def test_pool_membership_unchanged_and_moved_units_not_central(self):
  f=self.f['Trig_Spawn_Pools_Init_Actions'];zones={}
  for m,night,zone in pool_blocks(f):zones.setdefault(zone,set()).update(re.findall(r"UnitPoolAddUnitType\(l_pool,'(.{4})'",m[0]))
  for r in ['nsgn','nsgh','nsgb','nrel','nsel','n01O']:self.assertIn(r,zones[6]);self.assertNotIn(r,zones[3])
  self.assertIn('n01P',zones[5]);self.assertNotIn('n01P',zones[6])
  self.assertEqual(tokens(functions(self.old.runtime)['Trig_Spawn_Pools_Init_Actions']),tokens(f))
 def test_hatchling_poison_at_exact_probability_boundary(self):
  s=self.f['C95_Poison'];data={};roll=[25];e=mocks(s)
  e.update(C95Data={},Forest86Data=data,Forest86Now=3.,I2R=float,GetUnitTypeId=lambda u:'nhyh',GetUnitLevel=lambda u:20,GetHandleId=lambda u:u,GetRandomInt=lambda *a:roll[0],Forest86_Enemy=lambda *a:True,HaveSavedReal=lambda t,p,c:(p,c) in t,LoadReal=lambda t,p,c:t.get((p,c),0.),SaveReal=lambda t,p,c,v:t.__setitem__((p,c),v),SaveUnitHandle=lambda t,p,c,v:t.__setitem__((p,c),v),Forest86Poisoned=set(),GroupAddUnit=lambda g,u:g.add(u))
  e=execute(s,['C95_Poison'],e);e['C95_Poison'](1,2);self.assertEqual(data[2,11],110.);self.assertEqual(data[2,12],13.);data.clear();roll[0]=26;e['C95_Poison'](1,2);self.assertFalse(data)
  self.assertNotIn('A0PH',fields(self.u['nhyh'])['uabi',None])
 def test_mirror_each_death_stacks_once_preserving_other_gains(self):
  s=self.f['N98_ImageDeath'];table={(2,30):1,(3,30):1};hp=[3200];life=[3000.];damage=[239];haste=[];alive=[True];e=mocks(s)
  e.update(N98Data=table,GetHandleId=lambda u:u,LoadUnitHandle=lambda t,p,k:t.get((p,k)),LoadInteger=lambda t,p,k:t.get((p,k),0),SaveInteger=lambda t,p,k,v:t.__setitem__((p,k),v),RemoveSavedHandle=lambda t,p,k:t.pop((p,k),None),Forest86_Alive=lambda u:alive[0],IMinBJ=min,RMinBJ=min,I2R=float,BlzGetUnitMaxHP=lambda u:hp[0],BlzSetUnitMaxHP=lambda u,v:hp.__setitem__(0,v),GetWidgetLife=lambda u:life[0],SetWidgetLife=lambda u,v:life.__setitem__(0,v),BlzGetUnitBaseDamage=lambda *a:damage[0],BlzSetUnitBaseDamage=lambda u,v,i:damage.__setitem__(0,v),SetUnitAbilityLevel=lambda u,r,k:haste.append(k))
  e=execute(s,['N98_ImageDeath'],e);e['N98_ImageDeath'](2);e['N98_ImageDeath'](2);damage[0]+=50;e['N98_ImageDeath'](3)
  self.assertEqual((hp[0],life[0],damage[0],haste),(6200,6000.,529,[1,2]));self.assertEqual(table[1,40],2)
  table[4,30]=1;alive[0]=False;e['N98_ImageDeath'](4);self.assertEqual(hp[0],6200)
  f=fields(self.a['nMI8']);self.assertEqual((f['Omi1',1],f['Omi2',1],f['Omi3',1]),(2,.25,1.5))
 def test_native_damage_cooldowns_and_no_old_double_effects(self):
  for r,dmg,cd in [('nFL8',1750.,15.),('nFQ8',2000.,20.)]:
   f=fields(self.a[r]);self.assertEqual((f['Ocl1',1],f['Ocl2',1],f['amcs',1],f['acdn',1]),(dmg,3,200,cd))
  for r,k,v in [('nBO8','Htb1',1000.),('nBU8','Htb1',1500.),('nST8','Wrs1',1500.),('nER8','Eer1',500.),('nFA8','Ufa1',50.),('nMD8','Udd1',.01)]:self.assertAlmostEqual(fields(self.a[r])[k,1],v)
  self.assertNotIn('A03N',fields(self.u['nnrg'])['uabi',None]);self.assertNotIn('A0PH',fields(self.u['nsnp'])['uabi',None]);self.assertNotIn('A0BD',fields(self.u['nmyr'])['uabi',None])
 def test_devour_unlocked_only_by_valid_two_use_consume(self):
  b=self.f['N98_Spell'];self.assertIn("LoadInteger(Forest86Data,id,90)<2",b);self.assertIn('M89_Injured(victim)',b);self.assertIn('IsUnitAlly(victim',b);self.assertIn('N98_Pool(GetUnitTypeId(victim))',b);self.assertIn("UnitAddAbility(caster,'nMA8')",b);self.assertNotIn('nMA8',fields(self.u['nnsw'])['uabi',None]);self.assertEqual(tokens(functions(self.old.runtime)['M89_Absorb']),tokens(self.f['M89_Absorb']))
 def test_alert_zone_duration_block_and_regen(self):
  self.assertIn('Forest86Now+20.',self.f['Forest86_Alert']);self.assertIn('set N98AlertUntil=Forest86Now+60.',self.f['Forest86_AI']);self.assertIn('SpawnFactor(6)',self.f['N98_UpdateSpawnTimer'])
  s=self.f['N98_Block'];active=[False];e=mocks(s);e.update(GetUnitTypeId=lambda u:'nhyc',N98_Active=lambda *a:active[0]);e=execute(s,['N98_Block'],e);self.assertEqual(e['N98_Block'](1,True,False),10);active[0]=True;self.assertEqual(e['N98_Block'](1,False,True),60)
  self.assertIn('I2R(BlzGetUnitMaxHP(caster))/60.',self.f['N98_Spell']);self.assertIn("l_magical and GetUnitAbilityLevel(u,'bMP8')>0",self.f['Trig_Damage_Engine_Step18_FinalModifiers']);self.assertIn('RMaxBJ(1.,l_amount-100.)',self.f['Trig_Damage_Engine_Step18_FinalModifiers'])
 def test_water_wave_hits_and_heals_once(self):
  b=self.f['N98_Wave'];self.assertIn('set udg_MissileRange[d]=1000.',b);self.assertIn('set udg_MissileTravelDamage[d]=2000.',b);self.assertIn('set udg_MissileHitOnce[d]=true',b);self.assertIn("GetUnitTypeId(caster)=='n01Q'",b)
  b=self.f['Missile_DamageUnit'];self.assertIn('MissileTag[l_idx]==98',b);self.assertIn('not IsUnitInGroup(t,udg_MissileHitGroup[l_idx])',b);self.assertIn('GetWidgetLife(t)+1000.',b)
 def test_tidal_only_changes_live_proxy_and_projectile(self):
  old=functions(self.old.runtime)['Trig_Famfrit_TidalWave_Actions'];new=self.f['Trig_Famfrit_TidalWave_Actions']
  restored=new.replace('        call SetUnitVertexColor(GetLastCreatedUnit(),255,255,255,0)\n        call SetUnitPathing(GetLastCreatedUnit(),false)','        call ShowUnitHide(GetLastCreatedUnit())').replace("'nTW8'","'A0PZ'")
  self.assertEqual(tokens(old),tokens(restored));self.assertIn('set bj_forLoopAIndexEnd=5',new);self.assertIn('call Wait_Polled(2)',new)
  f=fields(self.a['nTW8']);self.assertEqual(f['amat',0],tidal_wave98.MODEL);self.assertEqual(f['amcs',1],0);self.assertEqual(f['acdn',1],0.)
  self.assertNotIn('GetLocalPlayer',new);self.assertNotIn('TimerStart',new)
 def test_removed_monsters_and_expired_images_are_cleaned(self):
  self.assertIn('call N98_Cleanup(u)',self.f['Forest86_AI'])
  for n in ['N98_Summoned','N98_BindImages']:self.assertIn('GroupAddUnit(N98Buffs,child)',self.f[n])
  self.assertIn('not HaveSavedHandle(N98Data,id,30)',self.f['N98_TickUnit'])
  self.assertIn('call RemoveSavedHandle(N98Data,id,30)',self.f['N98_ImageDeath'])
 def test_no_local_gameplay_and_no_added_continuous_polling(self):
  frag=(ROOT/'experiments/GuardiaForest/Naga98.j').read_text();self.assertNotIn('GetLocalPlayer',frag);self.assertIn('TimerStart(N98PullTimer,.1,true',frag);self.assertIn('PauseTimer(N98PullTimer)',frag)
  for n in ['Forest86_Init','Forest86_Tick','Forest86_Spell']:self.assertNotIn('GetLocalPlayer',self.f[n])
if __name__=='__main__':unittest.main()
