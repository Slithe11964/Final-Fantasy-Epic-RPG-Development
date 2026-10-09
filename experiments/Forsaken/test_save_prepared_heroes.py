"""Owned replacement core/ability preparation and user load-skill policy."""
import unittest
from test_save_jass import engine, SOURCE
from test_save_units import MODULES
from test_save_references import REFERENCES
from test_save_body import BODY
from test_save_ownership import OWNERSHIP, OwnershipWorld
import test_save_ownership as ownership_tests
from test_save_session import SESSION_GLOBALS
import test_save_session as session_tests
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA

PREPARED=SOURCE.with_name('Forsaken-save-prepared-heroes.j')
SKILL_GLOBALS='globals\n    integer array udg_JobSkill\nendglobals\n'


class PreparedWorld(OwnershipWorld):
    def __init__(self):
        super().__init__(); self.bad_ability=None; self.rank_cap=None

    def add_planned(self,u,raw):
        if self.permit('add',u) and raw!=self.bad_ability: self.add_ability(u,raw)
        return True

    def learn(self,u,raw):
        if self.permit('learn',u) and u['points']>0:
            rank=u['ranks'].get(raw,0)+1
            if self.rank_cap is not None: rank=min(rank,self.rank_cap)
            if raw not in u['ranks']: self.add_ability(u,raw,rank)
            else: u['ranks'][raw]=rank
            u['points']-=1

    def natives(self):
        env=super().natives(); env.update(UnitAddAbility=self.add_planned,SelectHeroSkill=self.learn)
        return env


class PreparedTests(unittest.TestCase):
    def setUp(self):
        template=ownership_tests.OwnershipTests('test_assign_active_and_gaya_only_keeps_containment_and_originals'); template.setUp()
        self.w=PreparedWorld()
        for name in ('resources','techs','units','types','items'): setattr(self.w,name,getattr(template.w,name))
        for name in ('hero','gaya','free','house','units','table','talents','original_code','originals'): setattr(self,name,getattr(template,name))
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+SKILL_GLOBALS+'\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in MODULES)+REFERENCES.read_text()+BODY.read_text()+OWNERSHIP.read_text()+PREPARED.read_text(),self.w.natives())
        self.e.update({k:v for k,v in template.e.items() if not callable(v)})
        for role in range(22):
            for skill in range(5): self.e['udg_JobSkill'][role*5+skill+1]='J%03d'%(role*5+skill)

    def prepare(self,pid=0):
        ownership_tests.OwnershipTests.prepare(self,pid)
        self.assertTrue(self.e['FSO_Begin'](pid)); self.assertTrue(self.e['FSO_Assign'](pid))
        self.assertTrue(self.e['FHP_Begin'](pid)); self.w.unit_writes.clear()

    def core(self,stage=0,pid=0,level=11):
        return self.e['FHP_PlanCore'](pid,stage,(level-1)*100+7,level,3,13,18,19)

    def plan(self,pid=0,level=11):
        for stage in range(self.e['FHP_Count'][pid]):
            self.assertTrue(self.core(stage,pid,level))
            self.assertTrue(self.e['FHP_PlanAbility'](pid,stage,'AAA1',4))
            self.assertTrue(self.e['FHP_PlanAbility'](pid,stage,'ZZZ1',2))

    def cleanup(self,pid=0):
        self.assertTrue(self.e['FHP_Discard'](pid)); ownership_tests.OwnershipTests.cleanup(self,pid)

    def test_readonly_plan_exact_owned_core_and_abilities_originals_untouched(self):
        self.prepare(); self.plan(); self.assertEqual(self.w.unit_writes,[])
        self.assertTrue(self.e['FHP_Apply'](0)); self.assertTrue(self.e['FHP_Verify'](0))
        for stage,u in enumerate(self.w.created):
            self.assertEqual((u['xp'],u['level'],u['points'],u['strength'],u['agility'],u['intelligence']),(1007,11,11 if stage==0 else 3,13,18,19))
            self.assertEqual((u['ranks']['AAA1'],u['ranks']['ZZZ1']),(4,2))
            self.assertEqual((u['hidden'],u['paused'],u['invulnerable']),(True,True,True))
        self.assertEqual([dict(u) for u in self.units],self.originals)
        self.cleanup(); self.assertTrue(all(u['raw'] for u in self.units))

    def test_all18_core_ability_write_faults_retain_and_retry(self):
        for fault in range(1,19):
            with self.subTest(fault=fault):
                self.setUp(); self.prepare(); self.plan(); self.w.reject_unit=fault
                self.assertFalse(self.e['FHP_Apply'](0)); self.assertEqual(self.e['FHP_State'][0],3)
                self.assertTrue(self.e['FSJ_PreparedPending'][0]); self.assertFalse(self.e['FSO_Neutralize'](0))
                self.assertFalse(self.e['FSC_Reset'](0)); self.assertIs(self.e['FHP_Unit'][0],self.w.created[0])
                self.w.reject_unit=0; self.assertTrue(self.e['FHP_Apply'](0)); self.cleanup()

    def test_below50_refunds_level_points_and_leaves_five_skills_unlearned(self):
        self.prepare(); self.plan(level=49); self.assertTrue(self.e['FHP_Apply'](0))
        u=self.w.created[0]; self.assertEqual(u['points'],49)
        for skill in range(5): self.assertEqual(u['ranks'].get(self.e['udg_JobSkill'][skill+1],0),0)
        self.assertFalse(any(kind=='learn' for kind,u in self.w.unit_writes))
        self.cleanup()

    def test_level50_unlocks_four_rank11_skills_and_rank6_ultimate(self):
        self.prepare(); self.plan(level=50); self.assertTrue(self.e['FHP_Apply'](0))
        u=self.w.created[0]
        self.assertEqual([u['ranks'][self.e['udg_JobSkill'][i+1]] for i in range(5)],[11,11,11,11,6])
        self.assertEqual(u['points'],0); self.assertTrue(self.e['FHP_Verify'](0))
        self.assertEqual(sum(kind=='learn' for kind,u in self.w.unit_writes),50)
        self.cleanup()

    def test_six_master_skill_learning_faults_retry_without_overlearning(self):
        # Inject first/middle/last learning failures, including regular/ultimate boundary.
        for failed in (1,11,12,44,45,50):
            with self.subTest(failed=failed):
                self.setUp(); self.prepare(); self.plan(level=50); learned=[0]
                def hook():
                    if self.w.unit_writes[-1][0]=='learn':
                        learned[0]+=1
                        if learned[0]==failed: self.w.reject_unit=len(self.w.unit_writes)
                self.w.unit_callback=hook
                self.assertFalse(self.e['FHP_Apply'](0)); self.assertEqual(self.e['FHP_State'][0],3)
                self.w.unit_callback=None; self.w.reject_unit=0
                self.assertTrue(self.e['FHP_Apply'](0))
                self.assertEqual([self.w.created[0]['ranks'][self.e['udg_JobSkill'][i+1]] for i in range(5)],[11,11,11,11,6])
                self.cleanup()

    def test_policy_skill_cannot_be_overridden_and_unexpected_learned_below50_refuses(self):
        self.prepare(); self.plan()
        self.assertFalse(self.e['FHP_PlanAbility'](0,0,self.e['udg_JobSkill'][1],11))
        self.w.add_ability(self.w.created[0],self.e['udg_JobSkill'][1],1)
        self.assertFalse(self.e['FHP_Apply'](0)); self.assertEqual(self.w.unit_writes,[])
        self.cleanup()

    def test_incomplete_invalid_duplicate_and_overflow_plans_are_readonly(self):
        self.prepare(); self.assertFalse(self.e['FHP_Apply'](0))
        self.assertFalse(self.e['FHP_PlanCore'](0,0,-1,11,3,13,18,19))
        self.assertTrue(self.core()); self.assertFalse(self.core())
        for raw,rank in [(0,1),('ZERO',0),('HIGH',256)]: self.assertFalse(self.e['FHP_PlanAbility'](0,0,raw,rank))
        for i in range(40): self.assertTrue(self.e['FHP_PlanAbility'](0,0,'B%03d'%i,1))
        self.assertFalse(self.e['FHP_PlanAbility'](0,0,'B000',1)); self.assertFalse(self.e['FHP_PlanAbility'](0,0,'EXTR',1))
        self.assertEqual(self.w.unit_writes,[]); self.cleanup()

    def test_xp_level_mismatch_and_unknown_ability_refuse_prepared_acceptance(self):
        self.prepare(); self.assertTrue(self.e['FHP_PlanCore'](0,0,1007,10,3,13,18,19))
        self.assertTrue(self.core(1)); self.assertFalse(self.e['FHP_Apply'](0)); self.assertFalse(self.e['FHP_Verify'](0)); self.cleanup()
        self.setUp(); self.prepare(); self.plan(); self.w.bad_ability='ZZZ1'
        self.assertFalse(self.e['FHP_Apply'](0)); self.assertFalse(self.e['FHP_Verify'](0)); self.cleanup()

    def test_reentrancy_and_cleanup_order_keep_independent_guards(self):
        self.prepare(); self.plan(); attempts=[]
        def hook(): attempts.append([self.e['FHP_Apply'](0),self.e['FHP_Verify'](0),self.e['FHP_Discard'](0),
                                    self.e['FSO_Neutralize'](0),self.e['FSR_Reverse'](0),self.e['FSU_Abort'](0),self.e['FSC_Reset'](0)])
        self.w.unit_callback=hook; self.assertTrue(self.e['FHP_Apply'](0))
        self.assertTrue(attempts); self.assertTrue(all(not any(a) for a in attempts)); self.w.unit_callback=None
        self.assertFalse(self.e['FSO_Neutralize'](0)); self.assertFalse(self.e['FSU_Abort'](0))
        self.assertTrue(self.e['FHP_Discard'](0)); self.assertTrue(self.e['FSC_OwnershipBlocked'][0]); self.assertFalse(self.e['FSC_Reset'](0))
        ownership_tests.OwnershipTests.cleanup(self)

    def test_changed_owner_raw_skill_map_or_items_refuses_before_setters(self):
        for change in ('owner','raw','skill','item'):
            with self.subTest(change=change):
                self.setUp(); self.prepare(); self.plan()
                if change=='owner': self.w.created[0]['owner']=3
                elif change=='raw': self.w.created[0]['raw']=0
                elif change=='skill': self.e['udg_JobSkill'][1]='BAD1'
                else: self.w.created[0]['quick'][0]=object()
                self.assertFalse(self.e['FHP_Apply'](0)); self.assertEqual(self.w.unit_writes,[])
                self.assertTrue(self.e['FHP_Discard'](0)); self.assertTrue(self.e['FSJ_OwnershipPending'][0])

    def test_player7_plan_and_discard_clear_only_its_owned_references(self):
        self.prepare(7); self.plan(7); self.assertTrue(self.e['FHP_Apply'](7)); self.assertEqual(max(self.e['FHP_Unit']),169)
        self.cleanup(7); self.assertIsNone(self.e['FHP_Unit'][168]); self.assertIsNone(self.e['FHP_Unit'][169]); self.assertEqual(self.e['FHP_State'][0],0)

    def test_master_point_grant_failure_and_rank_cap_fail_closed(self):
        self.prepare(); self.plan(level=50); self.w.reject_unit=2
        self.assertFalse(self.e['FHP_Apply'](0)); self.assertFalse(any(k=='learn' for k,u in self.w.unit_writes))
        self.w.reject_unit=0; self.assertTrue(self.e['FHP_Apply'](0)); self.cleanup()
        self.setUp(); self.prepare(); self.plan(level=50); self.w.rank_cap=10
        self.assertFalse(self.e['FHP_Apply'](0)); self.assertFalse(self.e['FHP_Verify'](0)); self.cleanup()

    def test_all24_units40_ability_plans_player7_max_index(self):
        self.assertTrue(session_tests.SessionTests.capture(self,7))
        self.assertTrue(self.e['FSB_Begin'](7)); self.assertTrue(self.e['FSU_Begin'](7))
        for role in range(24): self.assertTrue(self.e['FSU_Stage'](7,role,100.,200.))
        self.assertTrue(self.e['FSR_Begin'](7))
        for stage in range(24): self.assertTrue(self.e['FSR_Plan'](7,stage,False))
        self.assertTrue(self.e['FSR_Apply'](7)); self.assertTrue(self.e['FSO_Begin'](7)); self.assertTrue(self.e['FSO_Assign'](7))
        self.assertTrue(self.e['FHP_Begin'](7)); self.w.unit_writes.clear()
        for stage in range(24):
            self.assertTrue(self.core(stage,7))
            for ability in range(40): self.assertTrue(self.e['FHP_PlanAbility'](7,stage,'B%03d'%ability,2))
        self.assertEqual(max(self.e['FHP_Id']),7679)
        self.assertTrue(self.e['FHP_Apply'](7)); self.assertTrue(self.e['FHP_Verify'](7))
        self.assertEqual(len(self.w.unit_writes),2064)
        self.cleanup(7)
        self.assertTrue(all(self.e['FHP_Unit'][i] is None for i in range(168,192)))

    def test_source_crlf_and_no_original_deletion_activation_or_level_guess(self):
        raw=PREPARED.read_bytes(); self.assertNotIn(b'\n',raw.replace(b'\r\n',b''))
        source=raw.decode('utf-8')
        for forbidden in ('RemoveUnit(', 'SetHeroLevel(', 'SetUnitOwner(', 'ShowUnit(', 'UnitRemoveAbility(', 'CreateUnit('): self.assertNotIn(forbidden,source)
        self.assertIn('SelectHeroSkill(',source)


if __name__=='__main__': unittest.main()
