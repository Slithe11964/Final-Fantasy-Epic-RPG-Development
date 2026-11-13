"""Geometry, swept path hits, selected-target debuff and native preview parity."""
from pathlib import Path
from collections import defaultdict
import math,sys,unittest,struct
from unittest.mock import patch
import test_quest_lifecycle as harness
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_shared_context import mocks
from test_armory_materia import execute
from jtok import functions
from mpq import MPQ
from objdata import read_objects
from priest_master import fields
ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'experiments/Dragoon/Dragoon.j').read_text()
class DragoonTests(unittest.TestCase):
 def runtime(self):
  e=mocks(SOURCE);pos={'hero':[-450.,0.]};hp={'hero':5000.};damage=[];cooldowns=[]
  for i,x,y in [(1,250,0),(2,-100,0),(3,360,0),(4,650,0),(5,-187,145),(6,-187,-145),(7,-220,193)]:pos[i]=[float(x),float(y)];hp[i]=100000.
  e.update(Hero='hero',Foe={i:i for i in range(1,8)},Variant=1,SweepAbility='pDrB',RiseAbility='pRoD',Clock=0.,LifeUntil=0.,Accuracy=100.,Evasion=60.,NextQ=0.,NextW=0.,NextR=0.,NextJ=0.,DashTarget=None,DashUntil=0.,DashSpeed=0.,DashWidth=100.,DashEndX=0.,DashEndY=0.,Pending=0,PendingAt=0.,JumpUntil=0.,Aura=None,ChargeAura=None,OriginX=0.,OriginY=0.,Aim=0.,AimX=0.,AimY=0.,FxSlot=0,ProcMode=0,
   DashImpactX=0.,DashImpactY=0.,JumpStartX=0.,JumpStartY=0.,JumpX=0.,JumpY=0.,PreviewMode=0,RiseReady="rise-ready",IsUnitSelected=lambda *a:True,BlzGetMouseFocusUnit=lambda:None,IsUnitEnemy=lambda *a:True,MouseX=250.,MouseY=0.,Rune={i:i for i in range(1,65)},BlzGetUnitCollisionSize=lambda u:32.,Stacks=defaultdict(int),DashHit=defaultdict(bool),Stun=defaultdict(float),Label=defaultdict(str),VariantTag='tag',TimedFx=defaultdict(lambda:None),TimedFxUntil=defaultdict(float),
   RMaxBJ=max,RMinBJ=min,SquareRoot=math.sqrt,Cos=math.cos,Sin=math.sin,Atan2=math.atan2,bj_PI=math.pi,bj_RADTODEG=180/math.pi,bj_DEGTORAD=math.pi/180,ModuloInteger=lambda a,b:a%b,I2R=float,I2S=str,R2SW=lambda v,*a:str(v),GetHeroInt=lambda *a:100,
   GetUnitX=lambda u:pos[u][0],GetUnitY=lambda u:pos[u][1],SetUnitX=lambda u,v:pos[u].__setitem__(0,v),SetUnitY=lambda u,v:pos[u].__setitem__(1,v),SetUnitPosition=lambda u,x,y:pos.__setitem__(u,[x,y]),GetWidgetLife=lambda u:hp[u],GetTriggerUnit=lambda:'hero',GetSpellAbilityId=lambda:'pSTh',GetSpellTargetUnit=lambda:1,GetSpellTargetX=lambda:250.,GetSpellTargetY=lambda:0.,GetUnitFacing=lambda u:0.,
   AddSpecialEffectTarget=lambda *a:'charge',AddSpecialEffect=lambda *a:'effect',DestroyEffect=lambda *a:None,BlzStartUnitAbilityCooldown=lambda *a:cooldowns.append(a),ANIM_TYPE_STAND=0,ATTACK_TYPE_NORMAL=0,DAMAGE_TYPE_UNIVERSAL=0,WEAPON_TYPE_WHOKNOWS=0,UNIT_STATE_MAX_LIFE=0,GetUnitState=lambda u,k:100000.,
   UnitDamageTarget=lambda u,t,amount,*a:damage.append((t,amount)))
  real_expression=harness.expression
  with patch.object(harness,"expression",lambda expression:real_expression(expression).replace("//","/")):
   e=execute(SOURCE,list(functions(SOURCE)),e)
  return e,pos,damage,cooldowns
 def test_charge_hits_path_and_behind_once_but_debuffs_only_selected_target(self):
  e,pos,hits,cd=self.runtime();e['Cast']()
  for _ in range(120):e['Tick']()
  self.assertEqual(sorted(t for t,d in hits),[1,2,3])
  self.assertEqual(e['Stacks'][1],1);self.assertTrue(all(e['Stacks'][i]==0 for i in range(2,8)))
  self.assertEqual(e['EffectiveEvasion'](1),50.);self.assertEqual(pos['hero'],[160.,0.])
  self.assertIsNone(e['DashTarget'])
 def test_cone_edges_and_native_objects_match_damage_geometry_in_every_variant(self):
  e,*_=self.runtime();table=read_objects(MPQ(str(ROOT/'release/development/Dragoon10/FFERPG-Dragoon-10.w3x')).read('war3map.w3a'),'w3a');objects={o['id']:o for o in table['custom']}
  for variant,w,r in [(1,'pDrB','pRoD'),(2,'pDr2','pRo2'),(3,'pDr3','pRo3')]:
   e['Variant']=variant;reach=e['SweepReach']();radius=e['RiseRadius']();f=fields(objects[w]);rf=fields(objects[r])
   self.assertEqual(objects[w]['base'],'AHsw');self.assertEqual(f['swp2',1],reach);self.assertEqual(f['swp3',1],90.);self.assertEqual(f['swp1',1],0.)
   self.assertTrue(e['InCone']((reach-.1)*math.cos(math.radians(44)),(reach-.1)*math.sin(math.radians(44)),0.,reach))
   self.assertFalse(e['InCone'](reach*math.cos(math.radians(46)),reach*math.sin(math.radians(46)),0.,reach))
   self.assertFalse(e['InCone'](reach+1,0.,0.,reach));self.assertEqual(rf['aare',1],radius);self.assertEqual(rf['Ncl3',1]&2,2);self.assertGreater(f['aran',1],5000.)
 def test_sweep_rolls_once_for_multiple_hits_and_keeps_fiery_buff(self):
  e,points,hits,cd=self.runtime();points[1]=[100.,0.];points[2]=[200.,0.];points[3]=[300.,0.];e['Pending']=1;rolls=[];effects=[]
  e['GetRandomInt']=lambda a,b:rolls.append(1) or 1
  e['AddSpecialEffectTarget']=lambda model,*a:effects.append(model) or 'aura'
  e['Resolve']()
  self.assertEqual(len(rolls),1);self.assertEqual(e['LifeUntil'],5.)
  self.assertTrue(any('ImmolationRedTarget' in model for model in effects))

 def test_jump_is_fifteen_seconds(self):
  e,pos,hits,cd=self.runtime();e['GetSpellAbilityId']=lambda:'pJmp';e['Clock']=10.;e['Cast']();self.assertEqual(e['NextJ'],25.);self.assertIn(('hero','pJmp',15.),cd)
 def test_variants_share_charge_speed_damage_width_and_cooldown(self):
  outcomes=[]
  for variant in [1,2,3]:
   e,*_=self.runtime();e['Variant']=variant;e['Cast']();n=0
   while e['DashTarget'] is not None and n<120:e['Tick']();n+=1
   outcomes.append((n,e['DashSpeed'],e['DashWidth'],e['NextQ']))
  self.assertEqual(outcomes[0],outcomes[1]);self.assertEqual(outcomes[0],outcomes[2])
 def test_jump_moves_across_ground_during_arc(self):
  e,pos,*_=self.runtime();heights=[];e['SetUnitFlyHeight']=lambda u,h,r:heights.append(h)
  e['GetSpellAbilityId']=lambda:'pJmp';e['Cast']()
  for _ in range(13):e['Tick']()
  self.assertGreater(pos['hero'][0],-200.);self.assertLess(pos['hero'][0],100.)
  self.assertGreater(heights[-1],300.)
  for _ in range(14):e['Tick']()
  self.assertEqual(pos['hero'],[250.,0.]);self.assertEqual(heights[-1],0.)
 def test_stab_damage_extends_beyond_target_without_hero_crossing_it_or_fire(self):
  e,pos,hits,*_=self.runtime();effects=[];e['AddSpecialEffectTarget']=lambda model,*a:effects.append(model)
  e['AddSpecialEffect']=lambda model,*a:effects.append(model)
  e['Cast']()
  for _ in range(120):
   e['Tick']();self.assertLess(pos['hero'][0],pos[1][0])
  self.assertIn(3,[t for t,d in hits]);self.assertTrue(effects);self.assertFalse(any("ValiantCharge" in model or "Immolation" in model or "Flame" in model for model in effects))
 def test_sweep_counts_bodies_overlapping_edge_and_all_interior_targets(self):
  e,pos,hits,*_=self.runtime();e['ProcMode']=2;e['Pending']=1
  for i in range(1,8):pos[i]=[200.,(i-4)*25.]
  e['Resolve']();self.assertEqual(len(hits),7)
  angle=math.radians(48);self.assertTrue(e['ConeHits'](300*math.cos(angle),300*math.sin(angle),0.,350.,32.))
  angle=math.radians(60);self.assertFalse(e['ConeHits'](300*math.cos(angle),300*math.sin(angle),0.,350.,32.))
 def test_indicators_trace_wider_cone_single_circle_and_charge_extension(self):
  e,pos,*_=self.runtime();marks={};shown={}
  e['SetImagePosition']=lambda i,x,y,z:marks.__setitem__(i,(x,y))
  e['ShowImage']=lambda i,flag:shown.__setitem__(i,flag)
  e['PreviewMode']=2;e['UpdatePreview']();self.assertFalse(any(shown.values()))
  self.assertNotIn('RiseRing',SOURCE)
  e['PreviewMode']=1;e['UpdatePreview']()
  for i in range(1,33):self.assertAlmostEqual(math.hypot(marks[i][0]+12.+450.,marks[i][1]+12.),450.)
  self.assertAlmostEqual(math.degrees(math.atan2(marks[1][1]+12.,marks[1][0]+12.+450.)),-45.)
  self.assertAlmostEqual(math.degrees(math.atan2(marks[32][1]+12.,marks[32][0]+12.+450.)),45.)
  e['PreviewMode']=3;e['UpdatePreview']();self.assertEqual(marks[32],(388.,-12.))
  self.assertTrue(all(shown[i] for i in range(1,33)));self.assertFalse(any(shown[i] for i in range(33,65)))
  e['PreviewMode']=0;e['UpdatePreview']();self.assertFalse(any(shown.values()))
 def test_charge_locks_actions_faces_target_each_tick_and_releases_lock(self):
  e,pos,*_=self.runtime();paused=[];facing=[];orders=[];sounds=[]
  e['PauseUnit']=lambda u,flag:paused.append(flag)
  e['BlzSetUnitFacingEx']=lambda u,a:facing.append(a)
  e['IssueImmediateOrder']=lambda u,order:orders.append(order)
  e['CreateSound']=lambda file,*a:sounds.append(file) or 'cue'
  e['Cast']();self.assertEqual(paused,[True]);self.assertEqual(sounds,['DragoonCharge.ogg'])
  pos[1]=[250.,100.];e['Tick']();self.assertGreater(facing[-1],0.)
  self.assertEqual(paused,[True])
  for _ in range(100):e['Tick']()
  self.assertEqual(paused,[True,False]);self.assertEqual(orders,['stop','stop']);self.assertIsNone(e['DashTarget'])
 def test_death_releases_charge_lock(self):
  e,*_=self.runtime();paused=[];e['PauseUnit']=lambda u,flag:paused.append(flag)
  e['Cast']();e['GetWidgetLife']=lambda u:0. if u=='hero' else 100000.;e['Tick']()
  self.assertEqual(paused,[True,False]);self.assertIsNone(e['DashTarget'])
 def test_selected_effects_are_shared_by_legacy_variant_commands(self):
  results=[];visuals=[]
  for variant in [1,2,3]:
   e,pos,hits,*_=self.runtime();e['Variant']=variant;e['GetSpellAbilityId']=lambda:'pDrB';e['Cast']()
   sweep=(e['PendingAt'],e['NextW'],e['SweepReach']())
   e['Pending']=0;e['LifeUntil']=5.;e['GetSpellAbilityId']=lambda:'pRoD';e['Cast']()
   results.append((sweep,e['PendingAt'],e['NextR'],e['RiseRadius']()))
   models=[];e['AddSpecialEffect']=lambda model,*a:models.append(model) or 'fx'
   e['SweepVisual']();e['RiseVisual']();visuals.append(tuple(models))
  self.assertEqual(results[0],results[1]);self.assertEqual(results[0],results[2]);self.assertEqual(len(set(visuals)),1)
 def test_primary_hit_nudges_twenty_and_plays_stab_only_once_after_whoosh(self):
  e,pos,hits,*_=self.runtime();sounds=[]
  e['CreateSound']=lambda file,*a:sounds.append((file,len(hits))) or 'cue'
  e['Cast']();self.assertEqual(sounds,[('DragoonCharge.ogg',0)])
  for _ in range(120):e['Tick']()
  self.assertEqual(pos[1],[270.,0.]);self.assertEqual(pos[2],[-100.,0.]);self.assertEqual(pos[3],[360.,0.])
  self.assertEqual([name for name,n in sounds],['DragoonCharge.ogg','DragoonStab.ogg']);self.assertGreater(sounds[1][1],0)
 def test_ready_glow_tracks_buff_cooldown_selection_and_consumption(self):
  e,*_=self.runtime();shown=[];e['BlzFrameSetVisible']=lambda frame,flag:shown.append(flag)
  e['UpdateRiseReady']();self.assertFalse(shown[-1])
  e['LifeUntil']=5.;e['UpdateRiseReady']();self.assertTrue(shown[-1])
  e['NextR']=2.;e['UpdateRiseReady']();self.assertFalse(shown[-1])
  e['Clock']=3.;e['UpdateRiseReady']();self.assertTrue(shown[-1])
  e['GetSpellAbilityId']=lambda:'pRoD';e['Cast']();self.assertFalse(shown[-1]);self.assertEqual(e['LifeUntil'],0.)
  e['Clock']=5.;e['LifeUntil']=5.;e['NextR']=0.;e['UpdateRiseReady']();self.assertFalse(shown[-1])
  e['LifeUntil']=8.;e['IsUnitSelected']=lambda *a:False;e['UpdateRiseReady']();self.assertFalse(shown[-1])
 def test_approved_jump_trajectory_and_landing_are_preserved(self):
  old=MPQ(str(ROOT/'release/development/Dragoon06/FFERPG-Dragoon-06.w3x')).read('war3map.j').decode().replace('\r\n','\n')
  def motion(source):
   tick=functions(source)['Tick'];return tick[tick.index(' set step=RMaxBJ(0.,RMinBJ(1.,1.-(JumpUntil-Clock)/.8))'):tick.index(' call SetUnitFlyHeight(Hero,350.*Sin(step*bj_PI),0.)')+len(' call SetUnitFlyHeight(Hero,350.*Sin(step*bj_PI),0.)')]
  self.assertEqual(motion(old),motion(SOURCE))
  self.assertEqual(functions(old)['LandingVisual'].split(' else\n')[-1].split(' endif')[0].strip(),functions(SOURCE)['LandingVisual'].split('returns nothing\n')[1].split('endfunction')[0].strip())
 def test_rise_is_locked_with_only_cast_range_changed(self):
  old=MPQ(str(ROOT/'release/development/Dragoon07/FFERPG-Dragoon-07.w3x'));new=MPQ(str(ROOT/'release/development/Dragoon10/FFERPG-Dragoon-10.w3x'))
  old_source=old.read('war3map.j').decode().replace('\r\n','\n')
  for name in ['RiseVisual','RiseRadius','UpdateRiseReady','Resolve']:
   self.assertEqual(functions(old_source)[name],functions(SOURCE)[name],name)
  def rise_cast(source):
   cast=functions(source)['Cast'];return cast[cast.index(' elseif id==SweepAbility'):cast.index(" elseif id=='pJmp'")]
  self.assertEqual(rise_cast(old_source),rise_cast(SOURCE))
  def objects(archive,ext):return {o['id']:o for o in read_objects(archive.read('war3map.'+ext),ext)['custom']}
  before=objects(old,'w3a');after=objects(new,'w3a')
  for raw in ['pRoD','pRo2','pRo3']:
   f=fields(after[raw]);self.assertEqual(f['aran',1],800.)
   previous=fields(before[raw]);previous['aran',1]=800.;self.assertEqual(previous,f)
  self.assertEqual(fields(objects(new,'w3u')['H00C'])['ucs1',None],'MetalMediumSlice')
 def test_sweep_uses_actual_campaign_effect_at_original_scale(self):
  e,*_=self.runtime();calls=[];e['FacingFx']=lambda *args:calls.append(args)
  e['SweepVisual']();self.assertEqual(len(calls),1);self.assertIn('SweepingStrike',calls[0][0]);self.assertEqual(calls[0][-1],1.)
  self.assertNotIn('DragoonSweep.mdx',SOURCE)
 def test_targets_support_visible_whole_unit_push(self):
  archive=MPQ(str(ROOT/'release/development/Dragoon10/FFERPG-Dragoon-10.w3x'))
  targets={o['id']:o for o in read_objects(archive.read('war3map.w3u'),'w3u')['custom']};f=fields(targets['u01M'])
  self.assertEqual(f['umvt',None],'foot');self.assertGreater(f['umvs',None],0)
  e,pos,*_=self.runtime();pathing=[];e['SetUnitPathing']=lambda u,flag:pathing.append((u,flag))
  e['ThrustImpact'](1,-450.,0.);self.assertEqual(pos[1],[270.,0.]);self.assertEqual(pathing,[(1,False),(1,True)])
 def test_jump_locks_orders_tracks_landing_facing_and_unlocks_on_landing(self):
  e,pos,hits,*_=self.runtime();paused=[];facings=[];animations=[]
  e['PauseUnit']=lambda u,flag:paused.append(flag)
  e['BlzSetUnitFacingEx']=lambda u,a:facings.append(a)
  e['SetUnitAnimationByIndex']=lambda u,i:animations.append(i)
  e['GetSpellAbilityId']=lambda:'pJmp';e['GetSpellTargetY']=lambda:200.;e['Cast']()
  self.assertEqual(paused,[True]);self.assertEqual(animations,[5])
  expected=math.degrees(math.atan2(200.,700.))
  for _ in range(13):e['Tick']();self.assertAlmostEqual(facings[-1],expected)
  self.assertEqual(paused,[True]);self.assertEqual(hits,[])
  for _ in range(14):e['Tick']()
  self.assertEqual(paused,[True,False]);self.assertEqual(pos['hero'],[250.,200.]);self.assertEqual(animations,[5,0])
 def test_death_during_jump_unlocks_without_landing_damage(self):
  e,pos,hits,*_=self.runtime();paused=[];e['PauseUnit']=lambda u,flag:paused.append(flag)
  e['GetSpellAbilityId']=lambda:'pJmp';e['Cast']();e['GetWidgetLife']=lambda u:0. if u=='hero' else 100000.;e['Tick']()
  self.assertEqual(paused,[True,False]);self.assertEqual(hits,[]);self.assertEqual(e['JumpUntil'],0.)
if __name__=='__main__':unittest.main()



