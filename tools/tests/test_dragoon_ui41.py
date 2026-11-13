"""Full-RPG Dragoon behavior and integration contracts."""
from pathlib import Path
from collections import defaultdict
from unittest.mock import patch
import math,sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_shared_context import mocks
from test_armory_materia import execute
import test_quest_lifecycle as harness
from test_backpack_sync import unsafe_paths
from jtok import functions
from editor_pair import View
from dragoon_rpg import refresh,patch_objects,SKILLS,EYE_ICON,mana_cost
from objdata import read_objects
from priest_master import fields
ROOT=Path(__file__).resolve().parents[2]
CORE=(ROOT/'experiments/Dragoon/DragoonRPG.j').read_text()
UI=(ROOT/'experiments/Dragoon/DragoonUI.j').read_text()
class DragoonRPGTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.base=View(ROOT/'release/development/QuickUI40/FFERPG-QuickUI40-Forsaken.w3x')
  cls.modules={lib:refresh(s) for lib,s in cls.base.modules.items()}
 def runtime(self):
  pos={1:[-450.,0.],2:[-450.,1000.],3:[250.,0.],4:[-100.,0.],5:[360.,0.]};owners={1:0,2:1,3:11,4:11,5:11};hp=defaultdict(lambda:100000.);hits=[];paused=[];sounds=[]
  e=mocks(CORE);e.update(DG_GatedHero=defaultdict(lambda:None),DG_RiseLocked=defaultdict(bool),BlzGetUnitAbility=lambda *a:900,DG_Data={},DG_Debuffed=set(),DG_Now=0.,DG_Timer=None,DG_Hero=defaultdict(lambda:None),DG_Target=defaultdict(lambda:None),DG_Action=defaultdict(int),DG_End=defaultdict(float),DG_X=defaultdict(float),DG_Y=defaultdict(float),DG_FromX=defaultdict(float),DG_FromY=defaultdict(float),DG_Distance=defaultdict(float),DG_Angle=defaultdict(float),DG_Life=defaultdict(float),DG_Fails=defaultdict(int),DG_Aura=defaultdict(lambda:None),DG_Hits=defaultdict(set),
   Player=lambda p:p,GetPlayerId=lambda p:p,GetOwningPlayer=lambda u:owners[u],Player_GetHero=lambda p:{0:1,1:2}.get(p),GetUnitTypeId=lambda u:('H00C' if u in [1,2] else 'u01M') if u in pos else 0,GetWidgetLife=lambda u:hp[u],GetHandleId=lambda h:h,GetUnitX=lambda u:pos[u][0],GetUnitY=lambda u:pos[u][1],SetUnitX=lambda u,x:pos[u].__setitem__(0,x),SetUnitY=lambda u,y:pos[u].__setitem__(1,y),SetUnitPosition=lambda u,x,y:pos.__setitem__(u,[x,y]),
   GetUnitAbilityLevel=lambda *a:0,IsUnitEnemy=lambda u,p:owners[u]!=p,BlzIsUnitInvulnerable=lambda u:False,IsUnitType=lambda *a:False,GetHeroInt=lambda *a:100,GetHeroStr=lambda *a:100,GetHeroAgi=lambda *a:100,Prof_GetLevel=lambda u,raw:2 if raw=='R009' else 0,BlzGetAbilityManaCost=lambda raw,level:mana_cost(raw,level+1),Abil_GetLevel=lambda *a:0,UNIT_STATE_MAX_LIFE=0,UNIT_TYPE_STRUCTURE=0,GetUnitState=lambda *a:100000.,GetRandomInt=lambda *a:100,
   GetTriggerUnit=lambda:1,GetSpellAbilityId=lambda:'A11R',GetSpellTargetUnit=lambda:3,GetSpellTargetX=lambda:250.,GetSpellTargetY=lambda:0.,IMaxBJ=max,UNIT_STATE_MANA=1,UNIT_STATE_MAX_MANA=2,BlzGetUnitAbilityManaCost=lambda raw,u,rank:60,RMaxBJ=max,RMinBJ=min,SquareRoot=math.sqrt,Atan2=math.atan2,Cos=math.cos,Sin=math.sin,I2R=float,R2I=int,bj_PI=math.pi,bj_RADTODEG=180/math.pi,
   LoadUnitHandle=lambda t,p,c:t.get((p,c)),SaveUnitHandle=lambda t,p,c,u:t.__setitem__((p,c),u),LoadReal=lambda t,p,c:t.get((p,c),0.),SaveReal=lambda t,p,c,v:t.__setitem__((p,c),v),FlushChildHashtable=lambda t,p:[t.pop(k) for k in list(t) if k[0]==p],
   CreateGroup=set,GroupClear=lambda g:g.clear(),GroupAddUnit=lambda g,u:g.add(u),GroupRemoveUnit=lambda g,u:g.discard(u),FirstOfGroup=lambda g:min(g) if g else None,DestroyGroup=lambda g:None,IsUnitInGroup=lambda u,g:u in g,GroupAddGroup=lambda a,b:b.update(a),GroupEnumUnitsInRange=lambda g,x,y,r,f:g.update(u for u in pos if math.hypot(pos[u][0]-x,pos[u][1]-y)<=r),
   DG_UIUpdate=lambda:None,DG_UIInit=lambda:None,PauseUnit=lambda u,flag:paused.append((u,flag)),AddSpecialEffectTarget=lambda *a:'aura',AddSpecialEffect=lambda *a:'fx',CreateTimer=lambda:900,SaveEffectHandle=lambda t,p,c,v:t.__setitem__((p,c),v),CreateSound=lambda file,*a:sounds.append(file) or 'sound',ATTACK_TYPE_MELEE=1,DAMAGE_TYPE_NORMAL=1,ATTACK_TYPE_NORMAL=0,DAMAGE_TYPE_MAGIC=0,UnitDamageTarget=lambda u,t,d,*a:hits.append((u,t,d)))
  e['Trig_Damage_Engine_GetAccuracy']=lambda u:100.
  e['Trig_Damage_Engine_GetEvasion']=lambda u:max(0.,60.-e['DG_Reduction'](u))
  original=harness.expression
  with patch.object(harness,'expression',lambda s:original(s).replace('//','/')):e=execute(CORE,list(functions(CORE)),e)
  return e,pos,hits,paused,sounds
 def test_three_failed_rolls_guarantee_fourth_and_reset_independently(self):
  e,*_=self.runtime();rolls=[];e['GetRandomInt']=lambda *a:rolls.append(1) or 100
  self.assertEqual([e['DG_Proc'](0) for _ in range(4)],[False,False,False,True]);self.assertEqual(len(rolls),3);self.assertEqual(e['DG_Fails'][0],0)
  e['DG_Fails'][1]=2;e['GetRandomInt']=lambda *a:1;self.assertTrue(e['DG_Proc'](1));self.assertEqual(e['DG_Fails'][1],0)
 def test_empty_sweep_does_not_consume_guarantee(self):
  e,pos,*_=self.runtime();e['DG_Hero'][0]=1;e['DG_Fails'][0]=3
  e['DG_Area'](0,2,-450.,-2000.,0.,0.,True);self.assertEqual(e['DG_Fails'][0],3);self.assertEqual(e['DG_Life'][0],0.)
 def test_half_disc_geometry_includes_both_sides_but_not_behind(self):
  e,*_=self.runtime()
  for degrees in [-89,0,89]:self.assertTrue(e['DG_Cone'](399*math.cos(math.radians(degrees)),399*math.sin(math.radians(degrees)),0.,400.))
  self.assertFalse(e['DG_Cone'](-1.,0.,0.,400.));self.assertFalse(e['DG_Cone'](401.,0.,0.,400.))
 def test_path_hits_once_primary_stack_and_whole_unit_push(self):
  e,pos,hits,paused,sounds=self.runtime();e['DG_Cast']()
  for _ in range(120):e['DG_Tick']()
  self.assertEqual(sorted(t for u,t,d in hits),[3,4,5]);self.assertEqual(pos[1],[160.,0.]);self.assertEqual(pos[3],[255.,0.])
  self.assertEqual(e['DG_Reduction'](3),10.);self.assertEqual(e['DG_Reduction'](4),0.)
  self.assertEqual(paused,[(1,True),(1,False)]);self.assertEqual(sounds,['DragoonCharge.ogg','DragoonStab.ogg'])
 def test_state_does_not_share_between_players_and_death_unlocks(self):
  e,pos,hits,paused,*_=self.runtime();e['DG_Cast']();e['DG_Hero'][1]=2;e['DG_Life'][1]=5.;e['DG_Fails'][1]=2
  e['GetWidgetLife']=lambda u:0. if u==1 else 100000.;e['DG_Tick']()
  self.assertEqual(paused[-1],(1,False));self.assertEqual(e['DG_Action'][0],0);self.assertEqual(e['DG_Life'][1],5.);self.assertEqual(e['DG_Fails'][1],2)
 def test_ultimate_consumes_buff_and_checks_hp_before_damage(self):
  e,pos,hits,*_=self.runtime();e['DG_Hero'][0]=1;e['DG_Life'][0]=5.;e['GetSpellAbilityId']=lambda:'A14D'
  e['GetWidgetLife']=lambda u:29000. if u==3 else 100000.;e['DG_Stun']=lambda *a:None
  e['DG_Cast']();self.assertEqual(e['DG_Life'][0],0.)
  for _ in range(4):e['DG_Tick']()
  amount={t:d for u,t,d in hits};self.assertEqual(amount[3],4092.);self.assertEqual(amount[5],2728.)
 def test_local_preview_call_graph_only_reads_gameplay(self):
  fs={**functions(CORE),**functions(UI)}
  self.assertEqual(unsafe_paths(fs,['DG_UIUpdate','DG_UIKey','DG_UIMouse','DG_UIButton']),[])
 def test_blind_immunity_ignores_total_blind_and_regular_blind_penalty(self):
  source=self.modules['TDamage'];fs=functions(source);env=mocks(source);abilities={'B02V':1,'B00P':1,'A11T':1}
  env.update(GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:0,GetUnitAbilityLevel=lambda u,a:abilities.get(a,0),Forsaken_ElementAbilityLevel=lambda u,a:abilities.get(a,0),Trig_Damage_Engine_GetEvasion=lambda u:50.,Trig_Damage_Engine_GetAccuracy=lambda u:100.,IsPlayerInForce=lambda *a:False,GetRandomReal=lambda *a:0.,udg_ActivePlayers=0)
  e=execute(source,['Trig_Damage_Engine_RollMiss'],env);self.assertFalse(e['Trig_Damage_Engine_RollMiss'](1,3,False));abilities['A11T']=0;self.assertTrue(e['Trig_Damage_Engine_RollMiss'](1,3,False))
 def test_objects_keep_save_slots_summon_and_rank_counts(self):
  files=patch_objects(self.base.archive);new={o['id']:o for o in read_objects(files['war3map.w3a'],'w3a')['custom']}
  from damage_tooltips import merged
  old=merged(self.base.archive.read('war3map.w3a'),self.base.archive.read('war3mapSkin.w3a'),'w3a')
  for raw in SKILLS:self.assertEqual(fields(new[raw])['alev',0],fields(old[raw])['alev',0])
  self.assertEqual(fields(new['A03M'])['swp3',1],180.);self.assertEqual(fields(new['A14D'])['aran',1],800.)
  self.assertEqual(fields(new['A11S'])['aart',0],EYE_ICON);self.assertEqual(fields(new['A11T'])['Eev1',1],0.)
  self.assertEqual(functions(self.modules['TLancer'])['Trig_Lancer_DragonAlly_Actions'],functions(self.base.modules['TLancer'])['Trig_Lancer_DragonAlly_Actions'])
 def test_dragoon_cooldowns_are_not_overwritten_by_legacy_scaling(self):
  source=self.modules['TCooldown'];env=mocks(source);raw=['A000']
  env.update(GetSpellAbilityId=lambda:raw[0],GetTriggerUnit=lambda:1,GetUnitAbilityLevelSwapped=lambda *a:0)
  e=execute(source,['Trig_Cooldown_Scaling_Conditions'],env)
  self.assertTrue(e['Trig_Cooldown_Scaling_Conditions']())
  for skill in SKILLS:
   raw[0]=skill;self.assertFalse(e['Trig_Cooldown_Scaling_Conditions'](),skill)
 def test_sonic_reduction_reaches_actual_evasion_and_cleans_dead_targets(self):
  e,pos,*_=self.runtime();e['DG_Data'][3,0]=3;e['DG_Data'][3,1]=20.;e['DG_Debuffed'].add(3)
  self.assertEqual(e['Trig_Damage_Engine_GetEvasion'](3),40.)
  e['GetWidgetLife']=lambda u:0. if u==3 else 100000.;e['DG_Tick']()
  self.assertEqual(e['DG_Reduction'](3),0.);self.assertNotIn(3,e['DG_Debuffed']);self.assertNotIn((3,1),e['DG_Data'])
 def test_jump_keeps_approved_arc_and_unlocks_on_landing(self):
  e,pos,hits,paused,*_=self.runtime();heights=[];e['SetUnitFlyHeight']=lambda u,h,r:heights.append(h)
  e['GetSpellAbilityId']=lambda:'A1E6';e['DG_Cast']()
  for _ in range(13):e['DG_Tick']()
  self.assertAlmostEqual(pos[1][0],-108.75);self.assertGreater(heights[-1],300.);self.assertEqual(paused,[(1,True)])
  for _ in range(14):e['DG_Tick']()
  self.assertEqual(pos[1],[250.,0.]);self.assertEqual(heights[-1],0.);self.assertEqual(paused[-1],(1,False))
 def test_one_pity_roll_for_a_sweep_hitting_multiple_enemies(self):
  e,pos,hits,*_=self.runtime();e['DG_Hero'][0]=1;rolls=[]
  pos[3]=[-200.,0.];pos[4]=[-300.,200.];pos[5]=[-300.,-200.]
  e['GetRandomInt']=lambda *a:rolls.append(1) or 100
  e['DG_Area'](0,2,-450.,0.,0.,0.,True)
  self.assertEqual(len(hits),3);self.assertEqual(rolls,[1]);self.assertEqual(e['DG_Fails'][0],1)
 def test_reference_damage_uses_spear_and_ranked_mp(self):
  e,*_=self.runtime()
  self.assertEqual(e['DG_BaseDamage'](1,1,0.),1260.)
  self.assertEqual(e['DG_BaseDamage'](1,2,0.),1020.)
  self.assertEqual(e['DG_BaseDamage'](1,3,0.),2688.)
  self.assertAlmostEqual(e['DG_BaseDamage'](1,4,700.),3456.)
  e['Abil_GetLevel']=lambda *a:10
  self.assertEqual(e['DG_BaseDamage'](1,1,0.),1260.)
  self.assertEqual(mana_cost('A14D',6),1200)
  e['Abil_GetLevel']=lambda *a:0;e['GetHeroStr']=lambda *a:200;e['GetHeroInt']=lambda *a:0
  self.assertEqual(e['DG_BaseDamage'](1,3,0.),3168.)
 def test_jump_requires_enemy_and_tracks_that_enemy(self):
  e,pos,*_=self.runtime();e['GetSpellAbilityId']=lambda:'A1E6';e['GetSpellTargetUnit']=lambda:1;e['DG_Cast']();self.assertEqual(e['DG_Action'][0],0)
  e['GetSpellTargetUnit']=lambda:3;e['DG_Cast']();pos[3]=[300.,50.]
  for _ in range(27):e['DG_Tick']()
  self.assertEqual(pos[1],[300.,50.])
 def test_manual_spells_call_the_standard_cooldown_scaler_once(self):
  for raw in SKILLS:
   e,*_=self.runtime();calls=[];e['Trig_Cooldown_Scaling_Actions']=lambda:calls.append(raw)
   e['GetSpellAbilityId']=lambda:raw;e['DG_Hero'][0]=1;e['DG_Life'][0]=5.
   e['DG_Cast']();self.assertEqual(calls,[raw])
 def test_layout_icon_target_and_mana_are_real_object_fields(self):
  files=patch_objects(self.base.archive);a={o['id']:o for o in read_objects(files['war3map.w3a'],'w3a')['custom']}
  self.assertEqual(fields(a['A03M'])['swp2',1],400.)
  self.assertEqual(fields(a['A1E6'])['Ncl2',1],1)
  self.assertEqual((fields(a['A14D'])['abpx',0],fields(a['A14D'])['abpy',0]),(3,1))
  self.assertEqual((fields(a['A14G'])['abpx',0],fields(a['A14G'])['abpy',0]),(2,2))
  self.assertTrue(fields(a['A11S'])['aart',0].lower().endswith('btnedricseye.blp'))
  for raw in SKILLS:self.assertGreater(fields(a[raw])['amcs',1],0)
 def test_ui43_life_fire_jump_and_immediate_sweep(self):
  e,pos,hits,*_=self.runtime();e['GetSpellAbilityId']=lambda:'A03M';pos[3]=[-200.,0.];e['GetRandomInt']=lambda *a:1
  statuses=[];e['DG_Status']=lambda u:statuses.append(u)
  e['DG_Cast']();self.assertTrue(hits);self.assertEqual(e['DG_Action'][0],0);self.assertEqual(statuses,[1]);self.assertGreater(e['DG_Life'][0],0.)
  e['DG_Deal'](1,3,100.,False);self.assertEqual(e['udg_DamageElement'],1)
  a=e['DG_BaseDamage'](1,4,700.);e['GetHeroAgi']=lambda *a:999;e['GetHeroInt']=lambda *a:999;self.assertEqual(e['DG_BaseDamage'](1,4,700.),a)
  files=patch_objects(self.base.archive);buffs=read_objects(files['war3map.w3h'],'w3h')['custom'];self.assertTrue(any(o['id']=='BdGL' for o in buffs))
  abilities={o['id']:o for o in read_objects(files['war3map.w3a'],'w3a')['custom']}
  for raw in SKILLS:
   f=fields(abilities[raw]);self.assertIn('MASTER',f['atp1',f['alev',0]]);self.assertIn('Damage Calculation',f['aub1',1])
  self.assertIn('l_amount=l_amount*1.1',self.modules['TDamage'])
  self.assertIn("call DG_Gate(u,DG_Hero[p]==u and DG_Life[p]>DG_Now)",CORE)
  self.assertIn('ORIGIN_FRAME_COMMAND_BUTTON,5',UI)
  e,pos,hits,*_=self.runtime();e['DG_Hero'][0]=1;pos[3]=[99.,0.];pos[4]=[101.,0.];pos[5]=[0.,101.]
  e['DG_Area'](0,4,0.,0.,0.,0.,True);self.assertEqual([t for u,t,d in hits],[3])
 def test_rise_gate_transitions_once_and_restores_disabled_ability(self):
  e,*_=self.runtime();calls=[];e['BlzUnitDisableAbility']=lambda *a:calls.append(a)
  for _ in range(50):e['DG_Gate'](1,False)
  self.assertEqual(calls,[(1,'A14D',True,False)])
  e['GetUnitAbilityLevel']=lambda *a:0
  for _ in range(50):e['DG_Gate'](1,True)
  self.assertEqual(calls[-1],(1,'A14D',False,False));self.assertEqual(len(calls),2)
  e['DG_Gate'](1,False);self.assertEqual(len(calls),3)
 def test_cuts_glow_tracks_stacking_and_stops_on_rip(self):
  e,*_=self.runtime();e={**mocks(UI),**e};visible=[]
  e.update(DG_UIMode=0,DG_MouseX=0.,DG_MouseY=0.,DG_Rune=defaultdict(lambda:1),DG_Ready='rise',Cuts_Ready='cuts',CutsCaster=defaultdict(lambda:None),CutsActive=defaultdict(bool),CutsRipping=defaultdict(bool),GetLocalPlayer=lambda:0,IsUnitSelected=lambda *a:True,BlzFrameSetVisible=lambda f,v:visible.append((f,v)))
  e=execute(UI,['DG_UIUpdate'],e);e['CutsCaster'][0]=1;e['CutsActive'][0]=True
  e['DG_UIUpdate']();self.assertIn(('cuts',True),visible)
  visible.clear();e['CutsActive'][0]=False;e['CutsRipping'][0]=True;e['DG_UIUpdate']();self.assertIn(('cuts',False),visible)
 def test_ui46_sweep_reach_and_ultimate_cooldown(self):
  e,pos,hits,*_=self.runtime();e['DG_Hero'][0]=1;pos[3]=[-51.,0.];pos[4]=[-49.,0.];pos[5]=[-451.,0.]
  e['DG_Area'](0,2,-450.,0.,0.,0.,True);self.assertEqual([t for u,t,d in hits],[3])
  files=patch_objects(self.base.archive);a={o['id']:o for o in read_objects(files['war3map.w3a'],'w3a')['custom']}
  for level in range(1,7):self.assertEqual(fields(a['A14D'])['acdn',level],90.)
  self.assertEqual(fields(a['A03M'])['swp2',1],400.)
  e['GetSpellAbilityId']=lambda:'A14D';e['DG_Life'][0]=5.;e['GetUnitAbilityLevel']=lambda *a:1;cd=[];e['BlzStartUnitAbilityCooldown']=lambda *a:cd.append(a)
  e['DG_Cast']();self.assertEqual(cd,[(1,'A14D',90.)])
if __name__=='__main__':unittest.main()



