import sys,re,json,unittest,collections
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_central95 import STATS,BASE,OUT,META
from editor_pair import View
from build_forest86 import all_objects
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class Central95Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.old=View(BASE);c.v=View(OUT);c.f=functions(c.v.runtime);c.u=all_objects(c.v,'w3u');c.a=all_objects(c.v,'w3a');c.b=all_objects(c.v,'w3h')
 def test_normal_stats_and_damage_dice(self):
  for raw,(lv,hp,armor,lo,hi,mp) in STATS.items():
   f=fields(self.u[raw]);self.assertEqual(f['ulev',None],lv,raw);self.assertEqual(f['uhpm',None],hp,raw)
   self.assertEqual(f['ua1b',None]+f['ua1d',None],lo,raw);self.assertEqual(f['ua1b',None]+f['ua1d',None]*f['ua1s',None],hi,raw)
   if armor is not None:self.assertEqual(f['udef',None],armor,raw)
   if mp is not None:self.assertEqual(f['umpm',None],mp,raw)
 def test_only_central_units_and_new_role_objects_change(self):
  old=all_objects(self.old,'w3u')
  for raw in old:
   if raw not in STATS:self.assertEqual(old[raw],self.u[raw],raw)
  old=all_objects(self.old,'w3a')
  for raw in old:self.assertEqual(old[raw],self.a[raw],raw)
  for lib,s in self.old.modules.items():
   if 'Arena' in lib or lib in ['TSpawn','TJob','TLancer','TThief']:self.assertEqual(s,self.v.modules[lib],lib)
  self.assertEqual(self.old.archive.read('war3map.w3t'),self.v.archive.read('war3map.w3t'))
 def test_mana_cooldowns_and_effect_values(self):
  for raw,cd,mp in [('cPU5',30,150),('cDV5',20,200),('cEL5',45,1100),('cFK5',15,200),('cSK5',15,200),('cWV5',20,100),('cRG5',20,0),('cGD5',30,0),('cNT5',20,300),('cBI5',10,200),('cPN5',15,200),('cBU5',30,200),('cWW5',30,200),('cRA5',20,200),('cCH5',20,250),('cWR5',30,0)]:
   f=fields(self.a[raw]);self.assertEqual(f['acdn',1],cd,raw);self.assertEqual(f['amcs',1],mp,raw)
  self.assertEqual(fields(self.a['cFK5'])['Efk1',1],1600.)
  self.assertAlmostEqual(fields(self.a['cRG5'])['bsk2',1],.8);self.assertAlmostEqual(fields(self.a['cRG5'])['bsk3',1],.2)
 def test_hydra_poison_uses_attacker_level_not_victim(self):
  s=self.f['C95_Poison'];raw=['nahy'];roll=[25];data={};marks=[]
  e=mocks(s);e.update(I2R=float,GetUnitTypeId=lambda a:raw[0],GetUnitLevel=lambda a:30,GetHandleId=lambda a:a,GetRandomInt=lambda *a:roll[0],Forest86_Enemy=lambda *a:True,C95Data={},Forest86Data=data,Forest86Now=5.,HaveSavedReal=lambda t,p,c:(p,c) in t,LoadReal=lambda t,p,c:t.get((p,c),0.),SaveReal=lambda t,p,c,v:t.__setitem__((p,c),v),SaveUnitHandle=lambda t,p,c,v:t.__setitem__((p,c),v),Forest86Poisoned=set(),GroupAddUnit=lambda g,u:g.add(u),M89_Dummy=lambda *a:marks.append(a))
  e=execute(s,['C95_Poison'],e);e['C95_Poison'](1,2);self.assertEqual(data[2,11],190.);self.assertEqual(data[2,12],15.);self.assertEqual(data[2,13],6.)
  raw[0]='nehy';roll[0]=33;e['C95_Poison'](1,2);self.assertEqual(data[2,11],250.)
  data.clear();roll[0]=34;e['C95_Poison'](1,2);self.assertFalse(data)
  self.assertNotIn('GetHeroLevel',s)
 def test_block_bonuses_stack_and_shield_is_physical_only(self):
  s=self.f['C95_Block'];raw=['ntrd'];active=set();e=mocks(s);e.update(GetUnitTypeId=lambda u:raw[0],C95_Active=lambda u,k:k in active);e=execute(s,['C95_Block'],e)
  for r,p,m in [('ntrd',15,15),('ntrg',10,10),('ntrs',10,10),('nlrv',0,0)]:raw[0]=r;self.assertEqual(e['C95_Block'](1,True,False),p);self.assertEqual(e['C95_Block'](1,False,True),m)
  active.update([10,15]);self.assertEqual(e['C95_Block'](1,True,False),50);self.assertEqual(e['C95_Block'](1,False,True),10)
 def test_devour_only_injured_friendly_pool_units_two_uses(self):
  s=self.f['C95_DevourValid'];friendly=[True];injured=[True];raw=['ntrg'];uses=[0];e=mocks(s)
  e.update(M89_Injured=lambda u:injured[0],IsUnitAlly=lambda *a:friendly[0],GetOwningPlayer=lambda u:11,C95_Pool=lambda r:r in STATS,GetUnitTypeId=lambda u:raw[0],IsUnitType=lambda *a:False,UNIT_TYPE_HERO=1,IsUnitInGroup=lambda *a:False,udg_SpecialUnits=set(),Forest86Data={},GetHandleId=lambda u:u,LoadInteger=lambda *a:uses[0])
  e=execute(s,['C95_DevourValid'],e);self.assertTrue(e['C95_DevourValid'](1,2));uses[0]=2;self.assertFalse(e['C95_DevourValid'](1,2));uses[0]=0
  injured[0]=False;self.assertFalse(e['C95_DevourValid'](1,2));injured[0]=True;friendly[0]=False;self.assertFalse(e['C95_DevourValid'](1,2));friendly[0]=True;raw[0]='hfoo';self.assertFalse(e['C95_DevourValid'](1,2))
  self.assertEqual(tokens(functions(self.old.runtime)['M89_Absorb']),tokens(self.f['M89_Absorb']))
 def test_alert_is_central_only_with_existing_countdown(self):
  b=self.f['Forest86_Alert'];self.assertIn("GetUnitTypeId(u)!='ntrs'",b);self.assertIn("GetUnitTypeId(u)!='njg1'",b)
  s=self.f['B88_AlertZone'];raw=['ntrs'];e=mocks(s);e.update(GetUnitTypeId=lambda u:raw[0]);e=execute(s,['B88_AlertZone'],e)
  for r in ['ntrs','njg1']:raw[0]=r;self.assertEqual(e['B88_AlertZone'](1),3)
  self.assertIn('set C95AlertUntil=Forest86Now+60.',self.f['Forest86_AI']);self.assertIn('remaining<=5',self.f['Forest86_AI'])
  self.assertIn('zone==3 and C95AlertUntil>Forest86Now',self.f['Forest86_SpawnFactor']);self.assertIn('30./I2R(Forest86_SpawnFactor(3))',self.f['C95_UpdateSpawnTimer'])
 def test_net_is_full_stun_and_gaya_can_remove_it(self):
  f=fields(self.a['cNT5']);self.assertEqual(self.a['cNT5']['base'],'AHtb');self.assertEqual(f['Htb1',1],0.);self.assertEqual(f['adur',1],4.);self.assertEqual(f['ahdu',1],4.);self.assertEqual(f['abuf',1],'bNT5');self.assertIn('ensnareTarget',fields(self.b['bNT5'])['ftat',None]);self.assertIn("UnitRemoveAbility(u,'bNT5')",self.f['Trig_Gaya_BreakStun_Actions'])
 def test_burrow_recovery_has_full_heal_and_evasion(self):
  b=self.f['C95_Spell'];self.assertIn('C95_Buff(caster,40,5.)',b);self.assertIn('ShowUnit(caster,false)',b)
  t=self.f['C95_TickUnit'];self.assertIn('SetWidgetLife(u,I2R(BlzGetUnitMaxHP(u)))',t);self.assertIn('C95_Buff(u,42,3.)',t);self.assertIn('LoadBoolean(C95Data,id,41)',t)
  self.assertIn('GetWidgetLife(u)<=I2R(BlzGetUnitMaxHP(u))*.5',self.f['C95_AI'])
 def test_charge_bleed_uses_wounded_hero_level_and_lands_after_dash(self):
  b=self.f['B88_ChargeEnd'];self.assertIn("GetUnitTypeId(u)=='nmtw'",b);self.assertIn('B88_Damage(u,victim,1000.,true)',b);self.assertIn('C95_Bleed(u,victim)',b);self.assertIn('IsUnitInRange(u,victim,120.)',b)
  self.assertIn('100.+7.*I2R(GetHeroLevel(victim))',self.f['C95_Bleed']);self.assertIn('C95_Buff(victim,30,5.)',self.f['C95_Bleed'])
 def test_two_punches_are_two_seconds_apart_and_use_elements(self):
  self.assertIn('TimerStart(clock,2.,false,function C95_PairSecond)',self.f['C95_Spell']);self.assertIn('M89_Damage(caster,victim,1400.,4)',self.f['C95_Spell']);self.assertIn("M89_Dummy(caster,victim,'cIM5'",self.f['C95_Spell'])
  self.assertIn('M89_Damage(caster,victim,1000.,5)',self.f['C95_PairSecond']);self.assertIn("'mST9'",self.f['C95_PairSecond']);self.assertIn('DestroyTimer(clock)',self.f['C95_PairSecond'])
 def test_magic_revenant_and_guardians(self):
  for raw,low,high,hp,armor in [('ndrv',152,189,3600,5),('cWE5',125,139,2000,3)]:
   f=fields(self.u[raw]);self.assertEqual(f['ua1r',None],600);self.assertEqual(f['ua1t',None],'magic');self.assertEqual(f['uhpm',None],hp);self.assertEqual(f['udef',None],armor)
  self.assertEqual(fields(self.u['cWE5'])['udty',None],'divine');self.assertIn("GetUnitAbilityLevel(caster,'bBN5')>0",self.f['C95_Spell']);self.assertIn("UnitApplyTimedLife(summoned,'BTLF',60.)",self.f['C95_Spell']);self.assertIn('exitwhen i>=2',self.f['C95_Spell'])
  self.assertEqual(fields(self.a['cBN5'])['adur',1],15.);self.assertIn("'cFS5'",self.f['C95_Poison'])
 def test_critical_only_normal_attacks_and_one_roll_for_slow(self):
  b=self.f['Trig_Damage_Engine_Step16_PhysicalHit'];self.assertIn("BlzGetEventIsAttack() and GetUnitTypeId(u)=='njga' and GetRandomInt(1,100)<=20",b);self.assertIn('set l_amount=l_amount*2.5',b);self.assertIn("M89_Dummy(u,t,'cSL5'",b)
 def test_elementa_reuses_original_effect_paths_with_base_attack_scaling(self):
  for name in ['Trig_Fire_Cast_IsFire','Trig_Ice_Cast_IsIce','Trig_Spell_Bolt_Conditions']:self.assertIn("'cEL5'",self.f[name])
  for name in ['Trig_Fire_Cast_Actions','Trig_Ice_Cast_Actions']:self.assertIn('set l_tempInteger=2*BlzGetUnitBaseDamage(GetTriggerUnit(),0)',self.f[name])
  self.assertIn('set r=2.*I2R(BlzGetUnitBaseDamage(triggeringUnit,0))',self.f['Trig_Spell_Bolt_Actions'])
  self.assertIn("UnitAddAbility(caster,'cEL5')",self.f['C95_Spell']);self.assertNotIn('cEL5',fields(self.u['njgb'])['uabi',None])
 def test_shuriken_water_and_wave_damage(self):
  self.assertIn("'cSK5'",self.f['Trig_Spell_Shuriken_Conditions']);self.assertIn('set udg_ShurikenDamage[d]=1400.',self.f['Trig_Spell_Shuriken_Actions']);self.assertIn('set udg_DamageElement=4',self.f['Shuriken_Damage']);self.assertIn('1000.,0.,0.,200.,1200.,4',self.f['C95_Spell'])
 def test_war_cry_damage_and_element_expire(self):
  b=self.f['C95_Shout'];self.assertIn("UnitAddAbility(u,'cD15')",b);self.assertIn('C95_Buff(u,11,20.)',b);self.assertIn('UNIT_TYPE_RANGED_ATTACKER',b)
  self.assertEqual(fields(self.a['cD15'])['Iatt',1],100);self.assertIn("UnitRemoveAbility(u,'cD15')",self.f['C95_TickUnit']);self.assertIn('LoadInteger(C95Data,GetHandleId(u),13)',self.f['Element_GetOfUnit'])
 def test_native_status_fields_and_icon_assets(self):
  names={s.lower() for s in json.loads((ROOT/'tools/build-inputs/asset-gallery/casc-names.json').read_text())}
  for raw in ['cBL5','cEV5','cPB5','cSB5','cGB5','cWB5','cPO5']:
   o=self.a[raw];self.assertEqual(fields(o)['Crs\0',1],0.);self.assertTrue(any(m['field']=='Crs\0' and m['data']==1 for st in o['sets'] for m in st['mods']))
  self.assertEqual(fields(self.a['cBI5'])['Crs\0',1],0.);self.assertEqual(fields(self.a['cBI5'])['abuf',1],'B00P')
  report=json.loads(OUT.with_suffix('.json').read_text())
  for raw,icon in report['icons'].items():self.assertTrue(any(s.endswith('replaceabletextures\\commandbuttons\\'+icon.lower().replace('.blp','.dds')) for s in names),(raw,icon))
 def test_no_new_polling_or_local_gameplay(self):
  source='\n'.join(b for n,b in self.f.items() if n.startswith('C95_'))
  self.assertNotIn('GetLocalPlayer',source);self.assertNotIn('BlzSendSyncData',source);self.assertNotIn('BlzGetTriggerPlayerMouse',source)
  self.assertEqual(source.count('TimerStart('),2) # One-shot punch plus existing zone timer restart.
  self.assertIn('call C95_Tick()',self.f['Forest86_Tick']);self.assertIn('call C95_AI(u,victim)',self.f['Forest86_AI'])
 def test_legacy_poison_and_hardened_skin_do_not_stack(self):
  for raw in ['nahy','nehy']:self.assertNotIn('A0PH',fields(self.u[raw])['uabi',None])
  for raw in ['ntrd','ntrg']:self.assertNotIn('ACrk',fields(self.u[raw])['uabi',None])
 def test_command_aura_only_buffs_melee_and_caster_can_refill(self):
  f=fields(self.a['cAU5']);self.assertAlmostEqual(f['Cac1',1],.15);self.assertEqual(f['Ear2',1],1);self.assertEqual(f['Ear3',1],0);self.assertEqual(f['Ear4',1],0);self.assertEqual(f['aare',1],600.)
  self.assertEqual(fields(self.u['njgb'])['umpr',None],20.)
 def test_pool_icons_are_distinct_from_earlier_monster_roles(self):
  old=json.loads((ROOT/'release/development/QuickUI93/Icons.json').read_text());used={d['icon'].lower():d['name'] for d in old.values()}
  support={'cIM5','cSL5','cD15','cBL5','cEV5','cPB5','cSB5','cGB5','cWB5','cPO5','cFS5'}
  for raw,icon in json.loads(OUT.with_suffix('.json').read_text())['icons'].items():
   if raw in support:continue
   f=fields(self.a[raw]);path=f['aart',0].lower()
   if path in used:self.assertEqual(f['anam',0],used[path],raw)
 def test_review_hydra_split_summons_and_combat_callbacks(self):
  folder=ROOT/'release/development/CreatureReview03d';v=View(folder/'FFERPG-Creature-Review-03d.w3x');fs=functions(v.runtime);rows=json.loads((folder/'Creature-Catalogue.json').read_text())['creatures']
  self.assertIn('s=="-split"',fs['Review_Chat']);self.assertIn('KillUnit(u)',fs['Review_Chat']);self.assertIn('Aspy',fields(all_objects(v,'w3u')['nahy'])['uabi',None])
  for raw in ['nhyd','cWE5']:
   self.assertTrue(any(r['raw']==raw and r['area']==3 and r['section']=='Area bosses / summons' for r in rows),raw)
   self.assertFalse(any(r['raw']==raw and r['area']==11 for r in rows),raw)
  for text in ['function Shuriken_Damage','function Shuriken_Remove','Inventory94_Init()']:self.assertIn(text,fs['Review03_Combat'])
  for registration in ['RegisterLegacy_Spell_Shuriken','RegisterLegacy_Spell_Bolt','Register_Fire_Cast','Register_Ice_Cast']:self.assertIn(registration,fs['main'])
  ru=all_objects(v,'w3u')
  for raw in STATS:
   for k in ['ulev','uhpm','ua1b','ua1d','ua1s']:self.assertEqual(fields(ru[raw])[k,None],fields(self.u[raw])[k,None],(raw,k))

if __name__=='__main__':unittest.main()
