import sys,json,re,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from build_forest86 import all_objects
from priest_master import fields
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
class Revision92Tests(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.normal=View(ROOT/'release/development/QuickUI92/FFERPG-QuickUI92.w3x');c.review=View(ROOT/'release/development/CreatureReview03b/FFERPG-Creature-Review-03b.w3x')
  c.a=all_objects(c.normal,'w3a');c.u=all_objects(c.normal,'w3u');c.ru=all_objects(c.review,'w3u');c.fs=functions(c.normal.runtime);c.rf=functions(c.review.runtime)
 def test_hp_and_extra_roar(self):
  self.assertEqual(fields(self.u['n0L0'])['uhpm',None],1600);self.assertEqual(fields(self.u['nowe'])['uhpm',None],1800)
  ids=fields(self.u['n0MO'])['uabi',None].split(',');self.assertNotIn('A1C5',ids);self.assertIn('mRO9',ids)
  self.assertEqual(fields(self.a['mRO9'])['amcs',1],125)
 def test_channel_art_and_enemy_filters(self):
  for raw,o in self.a.items():
   if o['base']=='ANcl' and raw[0] in 'fbmh':
    for key in ['acat','atat','asat','aeat']:self.assertEqual(fields(o)[key,0],'',(raw,key))
  for raw in ['bG88','bC88','bQ88','mBI9','mRK9','mFB9','hBI0','hMF0','hAA0','hHB0']:
   self.assertNotIn('friend',fields(self.a[raw])['atar',1]);self.assertIn('enemy',fields(self.a[raw])['atar',1])
 def test_regional_spiders_and_payloads(self):
  f=fields(self.ru['nspb']);h=fields(self.ru['rSP3'])
  self.assertEqual((f['ulev',None],f['uhpm',None],f['udef',None]),(5,450,4.))
  self.assertEqual((h['ulev',None],h['uhpm',None],h['udef',None]),(23,2900,48.))
  self.assertNotIn('hBO0',f['uabi',None]);self.assertIn('hBO0',h['uabi',None])
  ra=all_objects(self.review,'w3a');tip=fields(ra['rPS3'])['aub1',1]
  self.assertIn('30%',tip);self.assertIn('100 + 5',tip);self.assertNotIn('Evasion',tip)
  s=self.rf['Forest86_OnAttack'];d={};raw=['nspb'];roll=[33]
  e=mocks(s);e.update(UNIT_TYPE_HERO=1,GetUnitTypeId=lambda *a:raw[0],Forest86Data=d,GetHandleId=lambda u:u,Forest86Now=0.,Forest86Poisoned=set(),IsUnitType=lambda *a:True,IsUnitEnemy=lambda *a:True,GetOwningPlayer=lambda *a:0,GetRandomInt=lambda *a:roll[0],GetHeroLevel=lambda *a:20,HaveSavedReal=lambda table,p,c:(p,c) in table,LoadReal=lambda table,p,c:table.get((p,c),0.),SaveUnitHandle=lambda table,p,c,x:table.__setitem__((p,c),x),SaveReal=lambda table,p,c,x:table.__setitem__((p,c),x),GroupAddUnit=lambda g,u:g.add(u),AddSpecialEffectTarget=lambda *a:1,DestroyEffect=lambda *a:None,I2R=float)
  e=execute(s,['Forest86_OnAttack'],e);e['Forest86_OnAttack'](1,2);self.assertEqual(d[2,11],70.);self.assertEqual(d[2,12],10.)
  d.clear();roll[0]=34;e['Forest86_OnAttack'](1,2);self.assertEqual(d,{})
  raw[0]='rSP3';roll[0]=30;e['Forest86_OnAttack'](1,2);self.assertEqual(d[2,11],200.)
  d.clear();roll[0]=31;e['Forest86_OnAttack'](1,2);self.assertEqual(d,{})
 def test_charge_moves_and_faces_enemy_until_melee(self):
  names=['B88_Charge','B88_ChargeStep','B88_ChargeEnd'];s='\n'.join(self.fs[n] for n in names);e=mocks(s);data={};xy={1:[0.,0.],2:[500.,0.]};charges=set();enemy=[True];facings=[];buffs=[];hits=[];paused=[]
  e.update(Forest86Data=data,Forest86Now=0.,B88Charges=charges,B88ChargeTimer=1,GetHandleId=lambda u:u,GetEnumUnit=lambda:1,GetUnitX=lambda u:xy[u][0],GetUnitY=lambda u:xy[u][1],SetUnitX=lambda u,x:xy[u].__setitem__(0,x),SetUnitY=lambda u,y:xy[u].__setitem__(1,y),FirstOfGroup=lambda g:next(iter(g),None),TimerStart=lambda *a:None,B88_ChargeTick=lambda:None,SaveUnitHandle=lambda t,p,c,v:t.__setitem__((p,c),v),SaveReal=lambda t,p,c,v:t.__setitem__((p,c),v),LoadUnitHandle=lambda t,p,c:t.get((p,c)),LoadReal=lambda t,p,c:t.get((p,c),0.),RemoveSavedHandle=lambda t,p,c:t.pop((p,c),None),GroupAddUnit=lambda g,u:g.add(u),GroupRemoveUnit=lambda g,u:g.discard(u),PauseUnit=lambda *a:paused.append(a),SetUnitAnimation=lambda *a:None,ResetUnitAnimation=lambda *a:None,SetUnitFacing=lambda *a:facings.append(a),Atan2=__import__('math').atan2,SquareRoot=__import__('math').sqrt,RMinBJ=min,RMaxBJ=max,bj_RADTODEG=180./__import__('math').pi,Forest86_Alive=lambda *a:True,Forest86_Enemy=lambda *a:enemy[0],GetUnitTypeId=lambda *a:'nrzg',IsUnitInRange=lambda u,v,r:abs(xy[u][0]-xy[v][0])<=r,B88_Buff=lambda *a:buffs.append(a),B88_Damage=lambda *a:hits.append(a),UnitAddAbility=lambda *a:None)
  e=execute(s,names,e);enemy[0]=False;e['B88_Charge'](1,2);self.assertFalse(charges)
  enemy[0]=True;e['B88_Charge'](1,2)
  for i in range(5):e['B88_ChargeStep']()
  self.assertEqual(xy[1],[400.,0.]);self.assertFalse(charges);self.assertEqual(buffs,[(2,43,5.)]);self.assertTrue(facings);self.assertIn((1,True),paused);self.assertIn((1,False),paused)
  xy[1]=[0.,0.];buffs.clear();e['GetUnitTypeId']=lambda *a:'ncen';e['B88_Charge'](1,2)
  for i in range(5):e['B88_ChargeStep']()
  self.assertEqual(xy[1],[400.,0.]);self.assertFalse(charges);self.assertEqual(hits,[(1,2,400.,True)]);self.assertEqual(buffs,[(2,46,5.)])
 def test_projectiles_are_not_hidden_and_keep_numbers(self):
  for n in ['B88_Quill','M89_Projectile','M89_Dummy']:
   self.assertNotIn('ShowUnit(dummy,false)',self.fs[n]);self.assertIn('SetUnitVertexColor(dummy,255,255,255,0)',self.fs[n])
  for raw,fragment in [('bY88','BristleBackMissile'),('mPF9','FireBallMissile'),('mPE9','RockBoltMissile'),('mCS9','CarrionSwarmMissile')]:self.assertIn(fragment,fields(self.a[raw])['amat',0])
  self.assertEqual(fields(self.a['mCS9'])['Ucs1',1],600.);self.assertEqual(fields(self.a['mCS9'])['Ucs2',1],2400.)
  self.assertEqual(fields(self.a['hHB0'])['Htb1',1],800.);self.assertEqual(fields(self.a['hHB0'])['adur',1],3.)
 def test_review_path_probe_and_missile_cleanup_initialized(self):
  b=self.rf['Review03_Combat']
  for n in ['Path_Init','Missile_CheckCollision','Missile_DamageWrap','Missile_Impact','LiquidSteel_Remove','RapidFire_Remove']:self.assertIn(n,b)
  self.assertEqual(len(re.findall(r'\bcall Path_Init\(',self.review.runtime)),1)
  self.assertIn('udg_LiquidSteelBounces[d]<=0',self.fs['Trig_Spell_LiquidSteel_Loop']);self.assertIn('DestroyEffect(udg_LiquidSteelEffect[l_idx])',self.fs['LiquidSteel_Remove'])
 def test_summarized_tooltips_no_script_dump(self):
  a=all_objects(self.review,'w3a')
  for raw,o in a.items():
   for (key,rank),text in fields(o).items():
    if key=='aub1' and isinstance(text,str):
     for bad in ['Script calculation (conditions','tempGroup=','UnitAddAbilityBJ(', 'Hero-caster formula (where applicable)']:self.assertNotIn(bad,text,raw)
  self.assertTrue((ROOT/'release/development/CreatureReview03b/Detailed-Script-Audit.json').exists())
 def test_visual_treatments(self):
  self.assertIn('Whirlwind\\\\Whirlwind.mdl',self.fs['H90_Spell'])
  self.assertIn('DefendCaster.mdl',self.fs['M89_Spell']);self.assertIn('CreateSoundFromLabel("Defend"',self.fs['M89_Spell'])
  self.assertIn('AnimateDeadTarget.mdl',self.fs['M89_Spell'])
  self.assertNotIn('MirrorImageCaster.mdl',self.fs['Forest86_Spell'])
if __name__=='__main__':unittest.main()
