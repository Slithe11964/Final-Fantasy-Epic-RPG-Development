"""Freelancer policy, canonical stat-source parity and contained preparation."""
import random
import unittest
from collections import defaultdict

import save_hero_policy as policy
import test_save_hero_policy as job_tests
import test_save_session as session_tests
from test_save_jass import engine

SOURCE=job_tests.HERE / 'Forsaken-save-freelancer-policy.j'
CANONICAL=job_tests.HERE.parents[1] / 'src/triggers/03 Jobs and progression/Freelancer.j'


class FreelancerPolicyTests(unittest.TestCase):
    def test_every_saved_level_preserves_milestones_and_fresh_choices(self):
        jobs={i:0 for i in range(1,23)}
        for level in range(101):
            p=policy.freelancer(level,jobs); normal=policy.normal_job(1,level)
            self.assertEqual((p.native_level,p.mastery_rank),(normal.native_level,normal.mastery_rank))
            bonus=normal.attribute_bonus
            self.assertEqual(p.attributes,(10+bonus+p.native_level+39,10+bonus+p.native_level//2,10+bonus+p.native_level//2))
            self.assertEqual(p.borrowed_choices,(0,0,0,0))

    def test_inheritance_matches_actual_canonical_stat_source(self):
        def canonical(saved,jobs):
            p=policy.freelancer(saved,jobs)
            unit={'rank':p.mastery_rank,'level':p.native_level,'stats':[0,0,0]}
            env={}
            def modify(attr,u,method,value):
                if method==0:u['stats'][attr]=value
                else:u['stats'][attr]+=value
            natives=dict(bj_HEROSTAT_STR=0,bj_HEROSTAT_AGI=1,bj_HEROSTAT_INT=2,bj_MODIFYMETHOD_SET=0,bj_MODIFYMETHOD_ADD=1,
                udg_TempInteger=1,udg_JobUnitType=defaultdict(int,{i:i+1 for i in range(22)}),udg_BonusGroup=defaultdict(int),udg_BonusValue=defaultdict(int),udg_CheaterForce=0,
                ConvertedPlayer=lambda p:p,Player_GetHero=lambda p:unit,GetUnitName=lambda u:'Freelancer',
                GetUnitTypeId=lambda u:'H02L',GetHeroLevel=lambda u:u['level'],GetUnitAbilityLevelSwapped=lambda r,u:u['rank'],
                GetForLoopIndexA=lambda:env['bj_forLoopAIndex'],Job_GetSavedLevel=lambda p,i:jobs[i],
                ModuloInteger=lambda a,b:a%b,ModifyHeroStat=modify,IsUnitInGroup=lambda u,g:False,
                IsPlayerInForce=lambda p,f:False,UnitRemoveAbilityBJ=lambda r,u:None)
            counters='globals\ninteger bj_forLoopAIndex\ninteger bj_forLoopAIndexEnd\nendglobals\n'
            # The mock treats quoted rawcodes as strings; JASS one-byte 'd' is100.
            canonical_source=CANONICAL.read_text(encoding='utf-8').replace("'d'",'100')
            env.update(engine(counters+canonical_source,natives))
            # Rebind loop accessor to the function engine's own changing globals.
            env['GetForLoopIndexA']=lambda:env['Trig_Freelancer_Stats_Actions'].__globals__['bj_forLoopAIndex']
            env['Trig_Freelancer_Stats_Actions'].__globals__['GetForLoopIndexA']=env['GetForLoopIndexA']
            env['Trig_Freelancer_Stats_Actions']()
            self.assertEqual(tuple(unit['stats']),p.attributes)
        rng=random.Random(999)
        fixtures=[{i:0 for i in range(1,23)},{i:99 for i in range(1,23)}]
        fixtures += [{i:100 if i==selected else 0 for i in range(1,23)} for selected in range(1,23)]
        fixtures += [{i:rng.choice((0,49,50,98,99,100)) for i in range(1,23)} for _ in range(8)]
        for level in (0,49,50,99,100):
            for jobs in fixtures: canonical(level,jobs)

    def test_invalid_and_unknown_jobs_do_not_grant_inheritance(self):
        jobs={i:0 for i in range(1,23)}
        base=policy.freelancer(50,jobs)
        self.assertEqual(policy.freelancer(50,jobs | {999:100}),base)
        for bad in ({1:50},jobs | {22:101}):
            with self.assertRaises(job_tests.codec.Error): policy.freelancer(50,bad)

    def test_bt_level_cap_and_strength_variant_bindings(self):
        from mpq import MPQ
        from objdata import read_objects,fields
        archive=MPQ(str(job_tests.HERE.parents[1] / 'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x'))
        self.assertIn('MaxHeroLevel=99',archive.read('war3mapMisc.txt').decode('utf-8'))
        table=read_objects(archive.read('war3map.w3u'),'w3u')
        unit=next(o for o in table['custom'] if o['id']=='H02L')
        data=fields(unit)
        self.assertTrue({'A02F','A15I'}<=set(data['uabi'].split(',')))
        self.assertFalse(data.get('uhab'))


class FreelancerBridgeTests(unittest.TestCase):
    def setUp(self):
        job_tests.BridgeTests.setUp(self)
        addition=engine(SOURCE.read_text(encoding='utf-8'),self.w.natives())
        addition.update(self.e); self.e=addition

    core=job_tests.BridgeTests.core
    cleanup=job_tests.BridgeTests.cleanup

    def prepare_free(self,pid=0):
        if pid==7:self.assertTrue(session_tests.SessionTests.capture(self,7))
        self.assertTrue(self.e['FSB_Begin'](pid));self.assertTrue(self.e['FSU_Begin'](pid))
        self.assertTrue(self.e['FSU_Stage'](pid,22,100.,200.));self.assertTrue(self.e['FSU_Stage'](pid,23,110.,210.))
        self.assertTrue(self.e['FSR_Begin'](pid));self.assertTrue(self.e['FSR_Plan'](pid,0,True));self.assertTrue(self.e['FSR_Plan'](pid,1,False))
        self.assertTrue(self.e['FSR_Apply'](pid));self.assertTrue(self.e['FSO_Begin'](pid));self.assertTrue(self.e['FSO_Assign'](pid))
        self.assertTrue(self.e['FHP_Begin'](pid));self.w.unit_writes.clear()
        self.w.add_ability(self.w.created[0],'A15I',1)

    def test_saved_plan_prepares_exact_core_marker_and_aliases(self):
        for saved in (0,49,50,99,100):
            with self.subTest(saved=saved):
                self.setUp();self.prepare_free()
                p=policy.freelancer(saved,{i:99 for i in range(1,23)})
                self.assertTrue(self.e['FFP_Plan'](0,0,saved,(p.native_level-1)*100+7,5,*p.attributes))
                self.assertTrue(self.core(stage=1));self.assertEqual(self.w.unit_writes,[])
                self.assertTrue(self.e['FHP_Apply'](0));self.assertTrue(self.e['FHP_Verify'](0))
                u=self.w.created[0]
                self.assertEqual((u['level'],u['points'],u['ranks']['A02F']),(p.native_level,5,p.mastery_rank))
                self.assertEqual((u['strength'],u['agility'],u['intelligence']),p.attributes)
                self.assertIs(self.e['udg_PlayerHero'][1],u);self.assertIs(self.e['udg_FreelancerHero'][1],u)
                self.assertEqual([dict(u) for u in self.units],self.originals);self.cleanup()

    def test_borrowed_skill_or_missing_versatility_reject_before_planning(self):
        self.prepare_free();u=self.w.created[0]
        self.w.add_ability(u,'J000',1)
        self.assertFalse(self.e['FFP_Plan'](0,0,50,4907,5,50,50,50))
        self.assertFalse(self.e['FHP_Planned'][0]);u['ranks'].pop('J000');u['ability_handles'].pop('J000')
        u['ranks']['A15I']=2
        self.assertFalse(self.e['FFP_Plan'](0,0,50,4907,5,50,50,50))
        self.assertFalse(self.e['FHP_Planned'][0]);self.assertEqual(self.w.unit_writes,[]);self.cleanup()

    def test_player7_boundaries_and_duplicate_plan(self):
        self.prepare_free(7)
        for saved in (-1,101,999):
            self.assertFalse(self.e['FFP_Plan'](7,0,saved,9807,5,50,50,50))
        self.assertFalse(self.e['FFP_Plan'](7,1,99,9807,5,50,50,50))
        self.assertTrue(self.e['FFP_Plan'](7,0,100,9807,5,50,50,50))
        self.assertFalse(self.e['FFP_Plan'](7,0,100,9807,5,50,50,50))
        self.assertEqual((self.e['FHP_Level'][168],self.e['FHP_Abilities'][168]),(99,1));self.cleanup(7)

    def test_source_crlf_no_original_or_session_setters(self):
        raw=SOURCE.read_bytes();self.assertNotIn(b'\n',raw.replace(b'\r\n',b''))
        for forbidden in ('SetHeroXP(', 'SetUnitAbilityLevel(', 'UnitRemoveAbility(', 'udg_AbilitySlot1[', 'RemoveUnit('):
            self.assertNotIn(forbidden,raw.decode('utf-8'))


if __name__=='__main__':unittest.main()
