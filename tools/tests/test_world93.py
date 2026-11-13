import sys,json,re,unittest,collections
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from build_forest86 import all_objects
from build_world93 import BASE,OUT,TO_NAGA,HIGHROAD_ONLY
from build_removals91 import pool_blocks
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
class World93Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.old=View(BASE);c.v=View(OUT);c.fs=functions(c.v.runtime);c.u=all_objects(c.v,'w3u');c.a=all_objects(c.v,'w3a');c.b=all_objects(c.v,'w3h')
  c.review=View(ROOT/'release/development/CreatureReview03c/FFERPG-Creature-Review-03c.w3x');c.rf=functions(c.review.runtime)
  c.rows=json.loads((ROOT/'release/development/CreatureReview03c/Creature-Catalogue.json').read_text())['creatures']
 def test_pool_moves_keep_weights_and_other_entries(self):
  def pools(v):return {(d,z):dict(re.findall(r"UnitPoolAddUnitType\(l_pool,\s*'(.{4})',\s*([^)]*)\)",m[0])) for m,d,z in pool_blocks(functions(v.runtime)['Trig_Spawn_Pools_Init_Actions'])}
  old=pools(self.old);new=pools(self.v)
  for key,values in old.items():
   expected={r:w for r,w in values.items() if (r not in TO_NAGA or key[1]==6) and (r not in HIGHROAD_ONLY or key[1]==5)}
   if key[1]==6:
    for (day,zone),items in old.items():
     if day==key[0]:expected.update({r:w for r,w in items.items() if r in TO_NAGA})
    for raw in TO_NAGA:expected.setdefault(raw,'1.')
   self.assertEqual(new[key],expected,key)
  for raw in HIGHROAD_ONLY:self.assertEqual({z for (d,z),items in new.items() if raw in items},{5})
  for raw in TO_NAGA:self.assertEqual({z for (d,z),items in new.items() if raw in items},{6})
  for day in [3,4]:self.assertIn('n01P',new[day,5])
 def test_arena_rosters_and_moved_unit_definitions_unchanged(self):
  for lib in self.old.modules:
   if 'Arena' in lib:self.assertEqual(self.old.modules[lib],self.v.modules[lib],lib)
  old=all_objects(self.old,'w3u')
  for raw in TO_NAGA|HIGHROAD_ONLY:self.assertEqual(fields(old[raw]),fields(self.u[raw]),raw)
 def test_review_groups_match_moves(self):
  for raw in TO_NAGA|HIGHROAD_ONLY:
   regular=[r for r in self.rows if r['raw']==raw and r['section']=='Regular spawns']
   self.assertTrue(regular,raw);self.assertEqual({r['area'] for r in regular},{6 if raw in TO_NAGA else 5},raw)
  self.assertTrue(any(r['raw']=='n01P' and r['area']==5 for r in self.rows))
 def test_aura_swap_and_correct_descriptions(self):
  self.assertIn('hEA0',fields(self.u['nfsh'])['uabi',None]);self.assertNotIn('fA86',fields(self.u['nfsh'])['uabi',None])
  self.assertIn('fA86',fields(self.u['nggr'])['uabi',None]);self.assertNotIn('hEA0',fields(self.u['nggr'])['uabi',None])
  self.assertIn('20% increased evasion',fields(self.u['nfsh'])['utub',None]);self.assertIn('10% increased armor',fields(self.u['nggr'])['utub',None])
  s=self.fs['H90_Evasion'];e=mocks(s);e.update(GetUnitAbilityLevel=lambda *a:1,B88_Active=lambda *a:False);e=execute(s,['H90_Evasion'],e);self.assertEqual(e['H90_Evasion'](1,50.),60.)
 def test_block_chances(self):
  s=self.fs['B88_BlockChance'];raw=['nsgg'];e=mocks(s);e.update(GetUnitTypeId=lambda *a:raw[0],B88_Active=lambda *a:False);e=execute(s,['B88_BlockChance'],e)
  for name,p,m in [('nsgg',20,0),('narg',15,0),('nowe',20,20),('nbld',15,10),('nban',25,15),('nggr',33,33)]:
   raw[0]=name;self.assertEqual(e['B88_BlockChance'](1,True,False),p,name);self.assertEqual(e['B88_BlockChance'](1,False,True),m,name)
 def test_reflection_is_twenty_percent_and_not_recursive(self):
  s=self.fs['B88_Thorns'];hits=[];e=mocks(s);e.update(B88Reflecting=False,Forest86_Alive=lambda *a:True,GetUnitTypeId=lambda *a:'nowe',B88_Active=lambda *a:True,IsUnitEnemy=lambda *a:True,GetOwningPlayer=lambda *a:11,B88_Damage=lambda *a:hits.append(a));e=execute(s,['B88_Thorns'],e);e['B88_Thorns'](1,2,100.);self.assertEqual(hits,[(2,1,20.,False)]);self.assertFalse(e['B88Reflecting']);e['B88Reflecting']=True;e['B88_Thorns'](1,2,100.);self.assertEqual(len(hits),1)
 def test_close_range_ai_gates(self):
  s=self.fs['H90_AI'];raw=['nsgg'];distance=[151.];casts=[];desired=['hTT0']
  e=mocks(s);e.update(GetUnitTypeId=lambda *a:raw[0],Forest86_Ready=lambda u,a,m:a==desired[0],IsUnitInRange=lambda u,t,r:distance[0]<=r,IssueImmediateOrder=lambda *a:casts.append(a),M89_AI=lambda *a:None);e=execute(s,['H90_AI'],e)
  for name,spell,order in [('nsgg','hTT0','roar'),('ngst','hGS0','stomp')]:
   raw[0]=name;desired[0]=spell;distance[0]=151.;casts.clear();e['H90_AI'](1,2);self.assertFalse(casts)
   distance[0]=150.;e['H90_AI'](1,2);self.assertEqual(casts,[(1,order)])
 def test_harpy_alert_uses_barrens(self):
  s=self.fs['B88_AlertZone'];e=mocks(s);raw=['nhar'];e.update(GetUnitTypeId=lambda *a:raw[0]);e=execute(s,['B88_AlertZone'],e);self.assertEqual(e['B88_AlertZone'](1),2)
  self.assertIn('bAL8',fields(self.u['nhar'])['uabi',None]);self.assertIn("GetUnitTypeId(u)!='nhar'",self.fs['Forest86_Alert']);self.assertIn("raw=='nhar'",self.fs['Forest86_AI'])
 def test_ai_keeps_existing_cast_orders(self):
  s=self.fs['R93_Casting'];current=['firebolt'];data={};ids={name:i+1 for i,name in enumerate(['firebolt','thunderbolt','flamestrike','chainlightning','attack','move'])};e=mocks(s);e.update(Forest86Data=data,Forest86Now=0.,GetHandleId=lambda u:u,HaveSavedInteger=lambda t,p,c:(p,c) in t,LoadInteger=lambda t,p,c:t.get((p,c),0),LoadReal=lambda t,p,c:t.get((p,c),0.),SaveInteger=lambda t,p,c,v:t.__setitem__((p,c),v),SaveReal=lambda t,p,c,v:t.__setitem__((p,c),v),RemoveSavedInteger=lambda t,p,c:t.pop((p,c),None),RemoveSavedReal=lambda t,p,c:t.pop((p,c),None),GetUnitCurrentOrder=lambda *a:ids[current[0]],OrderId=lambda name:ids.get(name,99));e=execute(s,['R93_Casting'],e)
  for name in ['firebolt','thunderbolt','flamestrike','chainlightning']:current[0]=name;self.assertTrue(e['R93_Casting'](1))
  for name in ['attack','move']:current[0]=name;self.assertFalse(e['R93_Casting'](1))
  current[0]='firebolt';self.assertTrue(e['R93_Casting'](1));e['Forest86Now']=3.;self.assertFalse(e['R93_Casting'](1))
  self.assertIn('R93_Casting(u)',self.fs['Forest86_AI'])
 def test_firebolt_launches_real_missile_with_fire_payload(self):
  s=self.fs['R93_Firebolt'];e=mocks(s);models=[];e.update(udg_TempUnit=1,udg_TempUnit2=2,GetUnitFacing=lambda *a:0.,Missile_CreateWithEffects=lambda *a:(models.append(a) or 1),BlzSetSpecialEffectScale=lambda *a:None)
  for array in re.findall(r'\b(\w+)\[',s):e[array]=collections.defaultdict(float)
  e=execute(s,['R93_Firebolt'],e);e['R93_Firebolt']();self.assertIn('FireBallMissile',models[0][1]);self.assertEqual(e['udg_MissileTarget'][1],2);self.assertEqual(e['udg_MissileImpactDamage'][1],800.);self.assertEqual(e['udg_MissileElement'][1],1);self.assertEqual(e['MissileTag'][1],93)
  self.assertIn("UnitAddAbility(stunDummy,'mST9')",self.fs['Missile_Impact']);self.assertEqual(fields(self.a['mST9'])['adur',1],3.)
 def test_ranges_for_summons_and_penance_arms(self):
  changes=json.loads((OUT.parent/'Changes.json').read_text());self.assertGreater(len(changes['summons']),10)
  for raw in changes['summons']:self.assertEqual(fields(self.u[raw])['uacq',None],1000.,raw)
  for raw in ['n08E','n08B']:self.assertEqual(fields(self.u[raw])['uacq',None],800.)
  self.assertIn('SetUnitAcquireRange(udg_TempUnit2,1000.)',self.fs['Trig_Summon_Powerup_Actions'])
  for name in ['Trig_Animal_Companion_Actions','Trig_Lancer_DragonAlly_Actions','Trig_Summon_Bahamut_Actions','Trig_Summon_Ifrit_Actions','Trig_Summon_Shiva_Actions','Trig_Summon_Cyclops_Actions']:
   self.assertIn('SetUnitAcquireRange(udg_TempUnit2,1000.)',self.fs[name],name)
  for array in ['udg_IfritUnitType','udg_ShivaUnitType','udg_CyclopsUnitType','udg_DragonSummonUnit','udg_AnimalCompanionUnit']:
   for raw in re.findall(r"set\s+"+array+r"\[[^]]+\]\s*=\s*'(.{4})'",self.v.runtime):self.assertEqual(fields(self.u[raw])['uacq',None],1000.,(array,raw))
  self.assertIn('SetUnitAcquireRange(GetEnumUnit(),800.)',self.fs['Trig_Boss_Penance_Summon_UnpauseArm'])
 def test_aeroaga_is_unlocked_and_avatar_voice_disabled(self):
  self.assertIn('mAW9',fields(self.u['nwzg'])['uabi',None]);self.assertEqual(fields(self.a['mAW9'])['areq',0],'');self.assertEqual(fields(self.a['mAW9'])['arqa',0],0)
  for key in ['aefs','aefl']:self.assertEqual(fields(self.a['hAV0'])[key,0],'')
  for raw in ['nwzd','nwzg','nwzr']:self.assertIn(raw,self.fs['M89_AI'])
 def test_icons_are_unique_between_different_named_spells(self):
  report=json.loads((OUT.parent/'Icons.json').read_text());self.assertGreater(len(report),60);owners={}
  for raw,info in report.items():
   icon=info['icon'].lower()
   if icon in owners:self.assertEqual(owners[icon],info['name'],raw)
   owners[icon]=info['name']
 def test_status_icons_roots_and_taunt_cleansing(self):
  for raw,buff,duration in [('xT93','bT93',3.),('xT95','bT95',5.),('xW93','bW93',5.),('xV93','bV93',10.),('xG93','bG93',5.)]:
   f=fields(self.a[raw]);self.assertEqual(f['Crs1',1],0.);self.assertEqual(f['adur',1],duration);self.assertEqual(f['abuf',1],buff);self.assertTrue(fields(self.b[buff])['ftat',None].endswith('.mdl'))
  self.assertEqual(fields(self.a['hER0'])['abuf',1],'bER3');self.assertIn('EntanglingRootsTarget',fields(self.b['bER3'])['ftat',None])
  for fn in ['H90_BreakTaunt','Forest86_TauntTick']:
   self.assertIn("'bT93'",self.fs[fn]);self.assertIn("'bT95'",self.fs[fn])
 def test_no_local_client_gameplay_changes(self):
  for fn in ['R93_Casting','R93_Firebolt','R93_Visual']:
   self.assertNotIn('GetLocalPlayer',self.fs[fn]);self.assertNotIn('TimerStart',self.fs[fn])
if __name__=='__main__':unittest.main()
