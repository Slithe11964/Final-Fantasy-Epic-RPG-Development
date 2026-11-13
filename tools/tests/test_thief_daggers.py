"""Exercise the isolated dagger mechanic and its cleanup, without loading RPG code."""
from collections import defaultdict
from pathlib import Path
import math,sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
from build_thief_daggers import object_data,terrain,map_info,BASE
from mpq import MPQ
from objdata import read_objects
from priest_master import fields
SOURCE=(Path(__file__).resolve().parents[2]/'experiments/ThiefDaggers/ThiefDaggers.j').read_text()

class ThiefDaggerTests(unittest.TestCase):
    def runtime(self):
        hp={'thief':2000.,'dummy':100000.};state={'range':True};live=set();damage=[];cooldowns=[];textures=[]
        def effect(*args):
            value=len(textures)+1;textures.append(args);live.add(value);return value
        def hurt(source,target,amount,*args):hp[target]-=amount;damage.append(amount);return True
        e=mocks(SOURCE)
        e.update(DagThief='thief',DagScarecrow='dummy',DagTimer=None,DagSpells=None,DagCounter='counter',
            DagBlade=defaultdict(lambda:None),DagX=defaultdict(float),DagY=defaultdict(float),DagZ=defaultdict(float),
            DagExpires=defaultdict(int),DagStacks=0,DagStyle=1,DagTicks=0,DagRipTicks=0,DagRipDamage=0.,DagActive=False,DagRipping=False,
            GetWidgetLife=lambda unit:hp.get(unit,0.),GetHeroAgi=lambda unit,bonus:100,
            GetUnitX=lambda unit:-96. if unit=='thief' else 96.,GetUnitY=lambda unit:0.,
            IsUnitInRange=lambda *args:state['range'],I2R=float,I2S=str,R2I=int,ModuloInteger=lambda x,y:x%y,
            Cos=math.cos,Sin=math.sin,Atan2=math.atan2,bj_PI=math.pi,bj_RADTODEG=180./math.pi,
            AddSpecialEffect=effect,AddSpecialEffectTarget=effect,DestroyEffect=lambda handle:live.discard(handle),
            UnitDamageTarget=hurt,BlzStartUnitAbilityCooldown=lambda *args:cooldowns.append(args),
            ATTACK_TYPE_NORMAL=0,DAMAGE_TYPE_UNIVERSAL=1,WEAPON_TYPE_WHOKNOWS=2,
            CreateTextTag=lambda:'damage-tag',UNIT_STATE_MANA=0,UNIT_STATE_MAX_MANA=1,UNIT_STATE_LIFE=2,
            GetUnitState=lambda *args:1000.,SetUnitState=lambda u,kind,v:hp.__setitem__(u,v) if kind==2 else None)
        return execute(SOURCE,list(functions(SOURCE)),e),hp,state,live,damage,cooldowns

    def test_attacks_stack_and_same_r_button_rips_once(self):
        e,hp,state,live,damage,cooldowns=self.runtime()
        e['GetTriggerUnit']=lambda:'thief'
        e['GetSpellAbilityId']=lambda:'pDgA'
        e['Dag_OnSpell']()
        self.assertEqual(e['DagStacks'],0)
        for _ in range(100):e['Dag_Tick']()
        self.assertEqual(e['DagStacks'],0)
        e['GetTriggerUnit']=lambda:'dummy'
        e['GetEventDamageSource']=lambda:'thief'
        e['BlzGetEventIsAttack']=lambda:False
        e['GetEventDamage']=lambda:100.
        e['Dag_OnAttackDamage']();self.assertEqual(e['DagStacks'],0)
        e['BlzGetEventIsAttack']=lambda:True
        for _ in range(25):e['Dag_OnAttackDamage']()
        self.assertEqual(e['DagStacks'],25)
        e['GetTriggerUnit']=lambda:'thief'
        e['Dag_OnSpell']()
        self.assertTrue(e['DagRipping'])
        for _ in range(8):e['Dag_Tick']()
        self.assertEqual(damage,[6250.]);self.assertEqual(hp['dummy'],93750.)
        self.assertEqual(e['DagStacks'],0);self.assertFalse(live)
        for _ in range(10):e['Dag_Tick']()
        self.assertEqual(damage,[6250.])

    def test_cutting_sound_plays_once_on_rip_and_is_cleaned_up(self):
        e,hp,state,live,damage,cooldowns=self.runtime();sounds=[];started=[];released=[]
        e['CreateSoundFromLabel']=lambda label,*args:sounds.append(label) or 'rip-sound'
        e['StartSound']=lambda handle:started.append(handle)
        e['KillSoundWhenDone']=lambda handle:released.append(handle)
        e['Dag_Begin']('dummy')
        for _ in range(5):e['Dag_Plant']()
        self.assertFalse(sounds)
        e['Dag_Rip']()
        for _ in range(8):e['Dag_Tick']()
        self.assertEqual(sounds,['MetalHeavySliceFlesh'])
        self.assertEqual(started,['rip-sound']);self.assertEqual(released,started)
        for _ in range(10):e['Dag_Tick']()
        self.assertEqual(len(sounds),1)

    def test_each_dagger_expires_separately_without_refreshing_older_stacks(self):
        e,hp,state,live,damage,cooldowns=self.runtime();e['Dag_Begin']('dummy')
        e['Dag_Plant']()
        for _ in range(500):e['Dag_Tick']()
        e['Dag_Plant']()
        for _ in range(499):e['Dag_Tick']()
        self.assertEqual(e['DagStacks'],2)
        e['Dag_Tick']();self.assertEqual(e['DagStacks'],1);self.assertEqual(len(live),1)
        for _ in range(500):e['Dag_Tick']()
        self.assertEqual(e['DagStacks'],0);self.assertFalse(live);self.assertFalse(damage)

    def test_abort_clears_more_than_twenty_blades(self):
        e,hp,state,live,damage,cooldowns=self.runtime();e['Dag_Begin']('dummy')
        for _ in range(50):e['Dag_Plant']()
        self.assertEqual(len(live),50)
        e['Dag_Abort']();self.assertFalse(live);self.assertEqual(e['DagStacks'],0)

    def test_switching_styles_preserves_stacks_and_replaces_visuals(self):
        e,hp,state,live,damage,cooldowns=self.runtime();e['Dag_Begin']('dummy')
        for _ in range(4):e['Dag_Plant']()
        for style in [2,3,1]:
            before=set(live);e['Dag_ChangeStyle'](style)
            self.assertEqual(e['DagStacks'],4);self.assertEqual(len(live),4)
            self.assertFalse(before&live);self.assertFalse(damage)

    def test_reset_cancels_pending_rip_and_cleans_every_blade(self):
        e,hp,state,live,damage,cooldowns=self.runtime();e['Dag_Begin']('dummy');e['Dag_Plant']();e['Dag_Rip']()
        e['Dag_Reset']()
        for _ in range(10):e['Dag_Tick']()
        self.assertFalse(live);self.assertFalse(damage);self.assertEqual(e['DagStacks'],0)
        self.assertEqual(hp['dummy'],100000.)

    def test_target_death_aborts_without_stranding_ultimate(self):
        e,hp,state,live,damage,cooldowns=self.runtime();e['Dag_Begin']('dummy')
        hp['dummy']=0.;e['Dag_Tick']()
        self.assertFalse(e['DagActive']);self.assertFalse(e['DagRipping']);self.assertFalse(live)
        self.assertFalse(damage)

    def test_only_two_actor_types_and_nonlocking_one_rank_abilities(self):
        data,thief,abilities=object_data(MPQ(str(BASE)))
        self.assertEqual({o['id'] for o in read_objects(data['war3map.w3u'],'w3u')['custom']},{'H00B','u01M'})
        orders=set()
        for obj in abilities:
            f=fields(obj);self.assertEqual(f['alev',0],1)
            self.assertEqual(f['Ncl1',1],0.);self.assertEqual(f['Ncl5',1],0)
            orders.add(f['Ncl6',1])
        self.assertEqual(len(orders),6)
        self.assertNotIn('PauseUnit',SOURCE);self.assertNotIn('QuickGear_',SOURCE)

    def test_camera_bounds_have_positive_width_and_matching_corners(self):
        import re,struct
        from objdata import R
        info=map_info();reader=R(info);reader.o=12
        for _ in range(4):reader.z()
        bounds=struct.unpack_from('<8f',info,reader.o)
        runtime=tuple(float(value) for value in re.search(r'call SetCameraBounds\(([^)]+)\)',SOURCE)[1].split(','))
        for coordinates in [bounds,runtime]:
            self.assertLess(coordinates[0],coordinates[2])
            self.assertLess(coordinates[1],coordinates[3])
            self.assertEqual(coordinates[0],coordinates[4])
            self.assertEqual(coordinates[2],coordinates[6])
            self.assertEqual(coordinates[1],coordinates[7])
            self.assertEqual(coordinates[3],coordinates[5])

if __name__=='__main__':unittest.main()
