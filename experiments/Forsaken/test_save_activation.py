"""Reversible empty-pair exposure, containment faults and original recovery."""
import unittest
from test_save_jass import engine, SOURCE
from test_save_units import MODULES
from test_save_references import REFERENCES
from test_save_body import BODY
from test_save_ownership import OWNERSHIP
from test_save_prepared_heroes import PREPARED, SKILL_GLOBALS, PreparedWorld
import test_save_prepared_heroes as prepared_tests
import test_save_ownership as ownership_tests
from test_save_session import SESSION_GLOBALS
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA

ACTIVATION=SOURCE.with_name('Forsaken-save-activation.j')


class ActivationTests(unittest.TestCase):
    def setUp(self):
        template=prepared_tests.PreparedTests('test_readonly_plan_exact_owned_core_and_abilities_originals_untouched'); template.setUp()
        self.w=PreparedWorld()
        for name in ('resources','techs','units','types','items'): setattr(self.w,name,getattr(template.w,name))
        for name in ('hero','gaya','free','house','units','table','talents','original_code'): setattr(self,name,getattr(template,name))
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+SKILL_GLOBALS+'\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in MODULES)+REFERENCES.read_text()+BODY.read_text()+OWNERSHIP.read_text()+PREPARED.read_text()+ACTIVATION.read_text(),self.w.natives())
        self.e.update({k:v for k,v in template.e.items() if not callable(v)})
        self.hero.update(hidden=False,paused=False,invulnerable=False)
        self.gaya.update(hidden=False,paused=False,invulnerable=False)

    def prepare(self,pid=0):
        prepared_tests.PreparedTests.prepare(self,pid); prepared_tests.PreparedTests.plan(self,pid)
        self.assertTrue(self.e['FHP_Apply'](pid)); self.w.ownership_writes.clear()
        self.originals=[dict(u) for u in self.units]

    def core(self,stage=0,pid=0,level=11): return prepared_tests.PreparedTests.core(self,stage,pid,level)

    def begin(self,pid=0): self.assertTrue(self.e['FHA_Begin'](pid,1000.,-1000.,20.,1100.,-1100.,30.))

    def cleanup(self,pid=0):
        self.assertTrue(self.e['FHA_Contain'](pid)); self.assertTrue(self.e['FHA_Release'](pid))
        prepared_tests.PreparedTests.cleanup(self,pid)
        self.assertEqual([dict(u) for u in self.units],self.originals)

    def test_readonly_capture_expose_prepared_pair_and_restore_originals(self):
        self.prepare(); self.begin(); self.assertEqual(self.w.ownership_writes,[])
        self.assertTrue(self.e['FHA_Expose'](0)); self.assertTrue(self.e['FHA_Verify'](0))
        self.assertEqual(len(self.w.ownership_writes),18)
        for u in (self.hero,self.gaya): self.assertEqual((u['hidden'],u['paused'],u['invulnerable']),(True,True,True))
        for u in self.w.created: self.assertEqual((u['hidden'],u['paused'],u['invulnerable']),(False,False,False))
        self.assertEqual((self.w.created[0]['x'],self.w.created[0]['y'],self.w.created[0]['facing']),(1000.,-1000.,20.))
        self.assertEqual((self.w.created[1]['x'],self.w.created[1]['y'],self.w.created[1]['facing']),(1100.,-1100.,30.))
        self.assertTrue(self.e['FSJ_Verify'](0)); self.assertFalse(self.e['FHP_Discard'](0))
        self.cleanup(); self.assertTrue(all(u['raw']==0 for u in self.w.created)); self.assertTrue(all(u['raw'] for u in self.units))

    def test_all18_exposure_faults_retain_recovery_and_retry_containment(self):
        for fault in range(1,19):
            with self.subTest(fault=fault):
                self.setUp(); self.prepare(); self.begin(); self.w.reject_ownership=fault
                self.assertFalse(self.e['FHA_Expose'](0)); self.assertEqual(self.e['FHA_State'][0],3)
                self.assertFalse(self.e['FHA_Release'](0)); self.assertFalse(self.e['FHP_Discard'](0))
                self.assertFalse(self.e['FSO_Neutralize'](0)); self.assertFalse(self.e['FSR_Reverse'](0))
                if fault<=12:
                    for u in self.w.created: self.assertEqual((u['hidden'],u['paused'],u['invulnerable']),(True,True,True))
                self.w.reject_ownership=0; self.cleanup()

    def test_all12_containment_pose_faults_retain_and_retry(self):
        for fault in range(1,13):
            with self.subTest(fault=fault):
                self.setUp(); self.prepare(); self.begin(); self.assertTrue(self.e['FHA_Expose'](0))
                self.w.ownership_writes.clear(); self.w.reject_ownership=fault
                self.assertFalse(self.e['FHA_Contain'](0)); self.assertEqual(self.e['FHA_State'][0],3)
                self.assertFalse(self.e['FHA_Release'](0)); self.assertTrue(self.e['FSJ_ActivationPending'][0])
                self.w.reject_ownership=0; self.cleanup()

    def test_invalid_pose_missing_preparation_and_changed_core_refuse_readonly(self):
        self.assertFalse(self.e['FHA_Begin'](0,1.,2.,3.,4.,5.,6.)); self.prepare()
        for x,y,face in [(float('nan'),0.,0.),(0.,float('inf'),0.),(32769.,0.,0.),(0.,0.,360.)]:
            self.assertFalse(self.e['FHA_Begin'](0,x,y,face,100.,200.,0.))
        self.w.created[0]['points']+=1
        self.assertFalse(self.e['FHA_Begin'](0,1.,2.,3.,4.,5.,6.)); self.assertEqual(self.w.ownership_writes,[])
        self.assertFalse(self.e['FSJ_ActivationPending'][0])

    def test_stat_or_original_body_drift_does_not_prevent_owned_containment(self):
        self.prepare(); self.begin(); self.assertTrue(self.e['FHA_Expose'](0))
        self.w.created[0]['strength']+=2; self.hero['mana']+=1
        self.assertFalse(self.e['FHA_Verify'](0))
        self.cleanup()

    def test_foreign_owner_or_reference_refuses_containment_without_setters(self):
        for change in ('owner','reference','raw'):
            with self.subTest(change=change):
                self.setUp(); self.prepare(); self.begin(); self.assertTrue(self.e['FHA_Expose'](0))
                self.w.ownership_writes.clear()
                if change=='owner': self.w.created[0]['owner']=3
                elif change=='reference': self.e['udg_PlayerHero'][1]=self.hero
                else: self.w.created[0]['raw']=0
                self.assertFalse(self.e['FHA_Contain'](0)); self.assertEqual(self.w.ownership_writes,[])
                self.assertFalse(self.e['FHA_Release'](0)); self.assertTrue(self.e['FSJ_ActivationPending'][0])

    def test_reentrancy_blocks_exposure_cleanup_and_upstream_disposal(self):
        self.prepare(); self.begin(); attempts=[]
        def hook(): attempts.append([self.e['FHA_Expose'](0),self.e['FHA_Contain'](0),self.e['FHA_Verify'](0),self.e['FHA_Release'](0),
                                    self.e['FHP_Discard'](0),self.e['FSO_Neutralize'](0),self.e['FSR_Reverse'](0),self.e['FSU_Abort'](0),self.e['FSC_Reset'](0)])
        self.w.ownership_hook=hook; self.assertTrue(self.e['FHA_Expose'](0))
        self.assertTrue(attempts); self.assertTrue(all(not any(a) for a in attempts)); self.w.ownership_hook=None
        self.cleanup()

    def test_release_requires_containment_and_preserves_upstream_guards(self):
        self.prepare(); self.begin(); self.assertFalse(self.e['FHA_Release'](0))
        self.assertTrue(self.e['FHA_Expose'](0)); self.assertFalse(self.e['FHA_Release'](0))
        self.assertTrue(self.e['FHA_Contain'](0)); self.assertTrue(self.e['FHA_Release'](0))
        self.assertTrue(self.e['FSJ_PreparedPending'][0]); self.assertTrue(self.e['FSC_PreparedBlocked'][0]); self.assertFalse(self.e['FSC_Reset'](0))
        prepared_tests.PreparedTests.cleanup(self)

    def test_cancel_before_exposure_and_player7_state_isolation(self):
        self.prepare(7); self.begin(7); self.assertEqual(self.e['FHA_State'][0],0)
        self.assertEqual(max(self.e['FHA_New']),15); self.cleanup(7)
        self.assertIsNone(self.e['FHA_New'][14]); self.assertIsNone(self.e['FHA_Old'][15])

    def test_changed_skill_table_after_capture_prevents_exposure(self):
        self.prepare(); self.begin(); self.e['udg_JobSkill'][1]='BAD1'
        self.assertFalse(self.e['FHA_Expose'](0)); self.assertEqual(self.w.ownership_writes,[])
        self.cleanup()

    def test_dormant_flag_drift_blocks_exposure_verify_but_not_pair_containment(self):
        ownership_tests.OwnershipTests.prepare(self,dormant=True)
        self.assertTrue(self.e['FSO_Begin'](0)); self.assertTrue(self.e['FSO_Assign'](0))
        self.assertTrue(self.e['FHP_Begin'](0)); prepared_tests.PreparedTests.plan(self)
        self.assertTrue(self.e['FHP_Apply'](0)); self.originals=[dict(u) for u in self.units]
        self.begin(); self.assertTrue(self.e['FHA_Expose'](0))
        self.w.created[2]['hidden']=False; self.assertFalse(self.e['FHA_Verify'](0))
        self.cleanup(); self.assertTrue(all(u['raw']==0 for u in self.w.created))

    def test_source_crlf_no_original_deletion_reference_or_owner_mutation(self):
        raw=ACTIVATION.read_bytes(); self.assertNotIn(b'\n',raw.replace(b'\r\n',b''))
        source=raw.decode('utf-8')
        for forbidden in ('RemoveUnit(', 'SetUnitOwner(', 'SaveUnitHandle(', 'CreateUnit(', 'SetWidgetLife(', 'IssueImmediateOrder('): self.assertNotIn(forbidden,source)
        self.assertIn('BlzSetUnitFacingEx(',source)


if __name__=='__main__': unittest.main()
