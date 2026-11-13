import sys,json,unittest,collections
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_hydra97 import BASE,OUT
from editor_pair import View
from build_forest86 import all_objects
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class Hydra97Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.old=View(BASE);c.v=View(OUT);c.f=functions(c.v.runtime);c.u=all_objects(c.v,'w3u');c.a=all_objects(c.v,'w3a')
  c.review=View(ROOT/'release/development/CreatureReview03e/FFERPG-Creature-Review-03e.w3x');c.rf=functions(c.review.runtime)
 def test_offspring_stats_and_no_duplicate_native_split_or_poison(self):
  f=fields(self.u['nhyd'])
  for k,val in [('ulev',25),('uhpm',3000),('udef',41.),('ua1b',134),('ua1d',1),('ua1s',6)]:self.assertEqual(f[k,None],val,k)
  self.assertNotIn('A0PH',f['uabi',None]);self.assertNotIn('Aspt',f['uabi',None]);self.assertIn('cPH7',f['uabi',None]);self.assertIn('cSP7',f['uabi',None]);self.assertNotIn('Aspy',fields(self.u['nahy'])['uabi',None]);self.assertIn('175 at level 25',fields(self.a['cPH7'])['aub1',1])
 def test_poison_twenty_percent_attacker_level(self):
  s=self.f['C95_Poison'];data={};roll=[20];e=mocks(s)
  e.update(C95Data={},Forest86Data=data,Forest86Now=3.,I2R=float,GetUnitTypeId=lambda u:'nhyd',GetUnitLevel=lambda u:25,GetHandleId=lambda u:u,GetRandomInt=lambda *a:roll[0],Forest86_Enemy=lambda *a:True,HaveSavedReal=lambda t,p,c:(p,c) in t,LoadReal=lambda t,p,c:t.get((p,c),0.),SaveReal=lambda t,p,c,v:t.__setitem__((p,c),v),SaveUnitHandle=lambda t,p,c,v:t.__setitem__((p,c),v),Forest86Poisoned=set(),GroupAddUnit=lambda g,u:g.add(u))
  e=execute(s,['C95_Poison'],e);e['C95_Poison'](1,2);self.assertEqual(data[2,11],175.);self.assertEqual(data[2,12],13.);data.clear();roll[0]=21;e['C95_Poison'](1,2);self.assertFalse(data)
 def test_real_death_hook_creates_two_children_with_owner_and_zone(self):
  s=self.f['C97_SplitDeath'];raw=['nahy'];life=[0.];born=[];tags=[];members=[];e=mocks(s)
  e.update(GetUnitTypeId=lambda u:raw[0],GetWidgetLife=lambda u:life[0],GetUnitAbilityLevel=lambda *a:1,udg_SpawnTimerHash={},GetUnitUserData=lambda u:3,LoadGroupHandle=lambda *a:'wave',I2R=float,bj_DEGTORAD=0.0174532925199433,GetUnitFacing=lambda u:0.,GetUnitX=lambda u:100.,GetUnitY=lambda u:200.,Cos=lambda a:__import__('math').cos(a),Sin=lambda a:__import__('math').sin(a),GetOwningPlayer=lambda u:11,CreateUnit=lambda *a:(born.append(a) or len(born)+10),SetUnitUserData=lambda *a:tags.append(a),GroupAddUnit=lambda *a:members.append(a))
  e=execute(s,['C97_SplitDeath'],e)
  for parent,child in [('nahy','nhyd'),('nhyd','nhyh')]:
   raw[0]=parent;born.clear();e['C97_SplitDeath'](1);self.assertEqual(len(born),2);self.assertEqual({a[:2] for a in born},{(11,child)})
  born.clear();raw[0]='nhyh';e['C97_SplitDeath'](1);self.assertFalse(born)
  raw[0]='nahy';life[0]=100.;e['C97_SplitDeath'](1);self.assertFalse(born)
  self.assertTrue(all(a[1]==3 for a in tags));self.assertTrue(all(a[0]=='wave' for a in members));self.assertIn('call C97_SplitDeath(u)',self.f['Forest86_Death'])
 def test_avatar_bonuses_apply_once_and_restore_without_overwriting_other_gains(self):
  s=self.f['C97_AvatarStart']+'\n'+self.f['C97_AvatarEnd'];data={};damage=[200];hp=[2000];life=[1500.];immune=set();e=mocks(s)
  e.update(Forest86Data=data,GetHandleId=lambda u:u,LoadBoolean=lambda t,p,c:t.get((p,c),False),SaveBoolean=lambda t,p,c,v:t.__setitem__((p,c),v),RemoveSavedBoolean=lambda t,p,c:t.pop((p,c),None),GetUnitAbilityLevel=lambda u,a:1 if a in immune else 0,BlzGetUnitBaseDamage=lambda *a:damage[0],BlzSetUnitBaseDamage=lambda u,v,i:damage.__setitem__(0,v),BlzGetUnitMaxHP=lambda u:hp[0],BlzSetUnitMaxHP=lambda u,v:hp.__setitem__(0,v),GetWidgetLife=lambda u:life[0],SetWidgetLife=lambda u,v:life.__setitem__(0,v),I2R=float,RMinBJ=min,IMaxBJ=max,UnitAddAbility=lambda u,a:immune.add(a),UnitRemoveAbility=lambda u,a:immune.discard(a))
  e=execute(s,['C97_AvatarStart','C97_AvatarEnd'],e);e['C97_AvatarStart'](1);e['C97_AvatarStart'](1);self.assertEqual((damage[0],hp[0],life[0]),(300,3000,2500.));self.assertIn('Amim',immune)
  damage[0]+=50;hp[0]+=250;e['C97_AvatarEnd'](1);e['C97_AvatarEnd'](1);self.assertEqual((damage[0],hp[0]),(250,2250));self.assertNotIn('Amim',immune)
  immune.add('Amim');e['C97_AvatarStart'](1);e['C97_AvatarEnd'](1);self.assertIn('Amim',immune)
  self.assertNotIn('C95Data',s)
 def test_whirlwind_uses_actual_bladestorm_asset_and_damage_unchanged(self):
  s=self.f['H90_Spell'];self.assertIn('Bladestorm\\\\BladestormTarget.mdl',s);self.assertNotIn('Whirlwind\\\\Whirlwind.mdl',s)
  self.assertEqual(tokens(functions(self.old.runtime)['H90_Whirl']),tokens(self.f['H90_Whirl']))
  self.assertEqual(fields(self.a['hWW0']),fields(all_objects(self.old,'w3a')['hWW0']))
 def test_avatar_is_silent_channel_with_existing_duration_speed_and_cleanup(self):
  self.assertEqual(self.a['hAV0']['base'],'ANcl');f=fields(self.a['hAV0']);self.assertEqual(f['acdn',1],45.);self.assertEqual(f['amcs',1],150);self.assertEqual(f['aefs',0],'');self.assertEqual(f['aefl',0],'')
  self.assertIn('call C97_AvatarStart(caster)',self.f['H90_Spell']);self.assertIn("UnitAddAbility(caster,'hA25')",self.f['H90_Spell']);self.assertIn('H90_Buff(caster,105,30.)',self.f['H90_Spell'])
  for name in ['H90_Cleanup','H90_TickUnit']:self.assertIn('call C97_AvatarEnd(u)',self.f[name])
 def test_review_split_command_accepts_both_living_sizes_and_chat(self):
  b=self.rf['Review_Chat'];self.assertIn("GetUnitTypeId(u)=='nahy' or GetUnitTypeId(u)=='nhyd'",b);self.assertIn('GetWidgetLife(u)>.405',b);self.assertIn('KillUnit(u)',b);self.assertIn('StringCase(GetEventPlayerChatString(),false)',b);self.assertIn('TriggerRegisterPlayerChatEvent(t,Player(0),"-",false)',self.rf['Review_Start'])
  commands=['-SPLIT ','-split'];raw=['nahy'];killed=[];e=mocks(b);e.update(ReviewSelected=1,GetEventPlayerChatString=lambda:commands[0],StringCase=lambda s,upper:s.upper() if upper else s.lower(),StringLength=len,SubString=lambda s,a,z:s[a:z],GetUnitTypeId=lambda u:raw[0],GetWidgetLife=lambda u:100.,KillUnit=lambda u:killed.append(u),Player=lambda i:i)
  e=execute(b,['Review_Chat'],e)
  e['Review_Chat']();raw[0]='nhyd';commands[0]='-split';e['Review_Chat']();self.assertEqual(killed,[1,1]);raw[0]='nhyh';e['Review_Chat']();self.assertEqual(killed,[1,1])
 def test_other_content_and_ui_fixes_unchanged(self):
  for lib,s in self.old.modules.items():
   if lib!='TMonsterData':self.assertEqual(s,self.v.modules[lib],lib)
  old=all_objects(self.old,'w3u')
  for raw in old:
   if raw not in ['nahy','nhyd']:self.assertEqual(old[raw],self.u[raw],raw)
  self.assertEqual(self.old.archive.read('war3map.w3t'),self.v.archive.read('war3map.w3t'))
  for text in ['TimerStart(','CreateTimer(']:self.assertEqual(self.old.runtime.count(text),self.v.runtime.count(text))
  rows=json.loads((ROOT/'release/development/CreatureReview03e/Creature-Catalogue.json').read_text())['creatures']
  for raw in ['nhyd','nhyh']:self.assertTrue(any(r['raw']==raw and r['area']==3 and r['section']=='Area bosses / summons' for r in rows))

if __name__=='__main__':unittest.main()
