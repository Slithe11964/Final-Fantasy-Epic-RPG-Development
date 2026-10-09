"""Reversible contained replacement ownership, native faults and ordering."""
import unittest
from test_save_jass import engine, SOURCE
from test_save_units import MODULES
from test_save_references import REFERENCES
from test_save_body import BODY, BodyWorld
import test_save_body as body_tests
from test_save_session import SESSION_GLOBALS
import test_save_session as session_tests
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA
from test_save_position import Handle

OWNERSHIP=SOURCE.with_name('Forsaken-save-ownership.j')


class OwnershipWorld(BodyWorld):
    def __init__(self):
        super().__init__()
        self.ownership_writes=[]; self.reject_ownership=0; self.ownership_hook=None

    def ownership_set(self,u,key,value):
        self.ownership_writes.append((id(u),key,value))
        if self.ownership_hook: self.ownership_hook()
        if len(self.ownership_writes)!=self.reject_ownership: u[key]=value

    def body_set(self,u,key,value):
        self.ownership_set(u,key,value)

    def create_unit(self,owner,raw,x,y,face):
        u=super().create_unit(owner,raw,x,y,face)
        if u is not None: u.update(body_life=100.,mana=0.,max_life=1000.,max_mana=250.,dead=False)
        return u

    def natives(self):
        env=super().natives()
        env['SetUnitOwner']=lambda u,p,color:self.ownership_set(u,'owner',p)
        return env


class OwnershipTests(unittest.TestCase):
    def setUp(self):
        template=body_tests.BodyTests('test_readonly_capture_alias_dedup_and_exact_recovery'); template.setUp()
        self.w=OwnershipWorld()
        for name in ('resources','techs','units','types','items'): setattr(self.w,name,getattr(template.w,name))
        for name in ('hero','gaya','free','house','units','table','talents','original_code'): setattr(self,name,getattr(template,name))
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+'\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in MODULES)+REFERENCES.read_text()+BODY.read_text()+OWNERSHIP.read_text(),self.w.natives())
        self.e.update({k:v for k,v in template.e.items() if not callable(v)})
        self.originals=[dict(u) for u in self.units]

    def prepare(self,pid=0,dormant=False,gaya=True):
        if pid==7: self.assertTrue(session_tests.SessionTests.capture(self,7))
        self.assertTrue(self.e['FSB_Begin'](pid)); self.assertTrue(self.e['FSU_Begin'](pid))
        self.assertTrue(self.e['FSU_Stage'](pid,0,100.,200.))
        if gaya: self.assertTrue(self.e['FSU_Stage'](pid,23,110.,210.))
        if dormant: self.assertTrue(self.e['FSU_Stage'](pid,1,120.,220.))
        self.assertTrue(self.e['FSR_Begin'](pid))
        for stage in range(self.e['FSU_Count'][pid]): self.assertTrue(self.e['FSR_Plan'](pid,stage,False))
        self.assertTrue(self.e['FSR_Apply'](pid)); self.w.ownership_writes.clear()

    def begin(self,pid=0): self.assertTrue(self.e['FSO_Begin'](pid))

    def cleanup(self,pid=0):
        self.assertTrue(self.e['FSO_Neutralize'](pid)); self.assertTrue(self.e['FSO_Release'](pid))
        self.assertTrue(self.e['FSR_Reverse'](pid)); self.assertTrue(self.e['FSU_Abort'](pid))
        self.assertTrue(self.e['FSR_Release'](pid)); self.assertTrue(self.e['FSB_Recover'](pid))
        self.assertTrue(self.e['FSB_Release'](pid))

    def test_assign_active_and_gaya_only_keeps_containment_and_originals(self):
        self.prepare(dormant=True); self.begin(); self.assertEqual(self.w.ownership_writes,[])
        self.assertTrue(self.e['FSO_Assign'](0)); self.assertTrue(self.e['FSO_Verify'](0))
        self.assertEqual([u['owner'] for u in self.w.created],[0,0,15])
        for u in self.w.created: self.assertEqual((u['hidden'],u['paused'],u['invulnerable']),(True,True,True))
        self.assertEqual([dict(u) for u in self.units],self.originals)
        self.assertEqual([kind for u,kind,v in self.w.ownership_writes],['owner','owner'])
        self.cleanup(); self.assertTrue(all(u['raw']==0 for u in self.w.created))
        self.assertTrue(all(u['raw'] for u in self.units))

    def test_each_assignment_fault_retains_then_neutralizes(self):
        for fault in (1,2):
            with self.subTest(fault=fault):
                self.setUp(); self.prepare(); self.begin(); self.w.reject_ownership=fault
                self.assertFalse(self.e['FSO_Assign'](0)); self.assertEqual(self.e['FSO_State'][0],3)
                self.assertFalse(self.e['FSO_Release'](0)); self.assertFalse(self.e['FSR_Reverse'](0))
                self.assertTrue(self.e['FSJ_OwnershipPending'][0]); self.assertIs(self.e['FSO_Unit'][0],self.w.created[0])
                self.w.reject_ownership=0; self.cleanup()

    def test_all8_neutralization_faults_retain_and_retry(self):
        for fault in range(1,9):
            with self.subTest(fault=fault):
                self.setUp(); self.prepare(); self.begin(); self.assertTrue(self.e['FSO_Assign'](0))
                for u in self.w.created: u.update(hidden=False,paused=False,invulnerable=False)
                self.w.ownership_writes.clear(); self.w.reject_ownership=fault
                self.assertFalse(self.e['FSO_Neutralize'](0)); self.assertEqual(self.e['FSO_State'][0],3)
                self.assertFalse(self.e['FSO_Release'](0)); self.assertFalse(self.e['FSR_Reverse'](0))
                self.assertFalse(self.e['FSU_Abort'](0)); self.assertTrue(self.e['FSC_OwnershipBlocked'][0])
                self.w.reject_ownership=0; self.cleanup()

    def test_foreign_owner_refuses_whole_pair_before_any_write(self):
        self.prepare(); self.begin(); self.assertTrue(self.e['FSO_Assign'](0))
        self.w.created[1]['owner']=3; self.w.ownership_writes.clear()
        self.assertFalse(self.e['FSO_Neutralize'](0)); self.assertEqual(self.w.ownership_writes,[])
        self.assertEqual(self.w.created[0]['owner'],0); self.assertEqual(self.w.created[1]['owner'],3)
        self.w.created[1]['owner']=0; self.cleanup()

    def test_changed_identity_reference_or_items_refuses_before_setters(self):
        for change in ('raw','reference','item','dead'):
            with self.subTest(change=change):
                self.setUp(); self.prepare(); self.begin()
                if change=='raw': self.w.created[0]['raw']=0
                elif change=='reference': self.e['udg_PlayerHero'][1]=self.hero
                elif change=='dead': self.w.created[0]['dead']=True
                else: self.w.created[0]['quick'][0]=Handle(raw='I001',owner=0)
                self.assertFalse(self.e['FSO_Assign'](0)); self.assertFalse(self.e['FSO_Neutralize'](0))
                self.assertEqual(self.w.ownership_writes,[]); self.assertFalse(self.e['FSO_Release'](0))

    def test_missing_gaya_and_uncontained_dormant_batch_refuse_capture(self):
        self.prepare(gaya=False); self.assertFalse(self.e['FSO_Begin'](0))
        self.assertEqual(self.w.ownership_writes,[]); self.assertFalse(self.e['FSJ_OwnershipPending'][0])
        self.assertIsNone(self.e['FSO_Unit'][0])
        self.setUp(); self.prepare(dormant=True); self.w.created[2]['hidden']=False
        self.assertFalse(self.e['FSO_Begin'](0)); self.assertEqual(self.w.ownership_writes,[])

    def test_reentrant_operations_are_blocked(self):
        self.prepare(); self.begin(); attempts=[]
        def hook():
            attempts.append([self.e['FSO_Assign'](0),self.e['FSO_Neutralize'](0),self.e['FSO_Release'](0),
                self.e['FSO_Verify'](0),self.e['FSR_Reverse'](0),self.e['FSU_Abort'](0),
                self.e['FSB_Recover'](0),self.e['FSC_Reset'](0),self.e['FSJ_Release'](0)])
        self.w.ownership_hook=hook; self.assertTrue(self.e['FSO_Assign'](0))
        self.assertTrue(attempts); self.assertTrue(all(not any(a) for a in attempts))
        self.w.ownership_hook=None; self.cleanup()

    def test_neutralize_then_release_must_precede_reference_reversal(self):
        self.prepare(); self.begin()
        self.assertFalse(self.e['FSR_Reverse'](0)); self.assertFalse(self.e['FSU_Abort'](0))
        self.assertFalse(self.e['FSJ_Release'](0)); self.assertFalse(self.e['FSC_Reset'](0))
        self.assertTrue(self.e['FSO_Neutralize'](0)); self.assertFalse(self.e['FSR_Reverse'](0))
        self.assertTrue(self.e['FSO_Release'](0)); self.assertTrue(self.e['FSR_Reverse'](0))
        self.assertTrue(self.e['FSC_ReferenceBlocked'][0]); self.assertFalse(self.e['FSC_Reset'](0))

    def test_other_guard_release_does_not_clear_ownership(self):
        self.prepare(); self.begin(); self.e['FSC_ReferenceBlocked'][0]=False
        self.e['FSN_ReferenceBlocked'][0]=False
        self.assertFalse(self.e['FSC_Reset'](0)); self.assertFalse(self.e['FSN_Begin'](0))
        self.assertTrue(self.e['FSJ_OwnershipPending'][0]); self.cleanup()

    def test_player7_keys_and_other_player_state_are_separate(self):
        self.prepare(7); self.begin(7); self.assertTrue(self.e['FSO_Assign'](7))
        self.assertEqual([u['owner'] for u in self.w.created],[7,7])
        self.assertEqual(max(self.e['FSO_Unit']),15); self.assertEqual(self.e['FSO_State'][0],0)
        self.assertFalse(self.e['FSC_OwnershipBlocked'][0]); self.cleanup(7)
        self.assertIsNone(self.e['FSO_Unit'][14]); self.assertIsNone(self.e['FSO_Unit'][15])

    def test_invalid_player_repeated_capture_and_changed_readback_block_release(self):
        for pid in (-1,8):
            for fn in ('FSO_Begin','FSO_Assign','FSO_Verify','FSO_Neutralize','FSO_Release'): self.assertFalse(self.e[fn](pid))
        self.assertFalse(self.e['FSO_Begin'](0)); self.prepare(); self.begin()
        self.assertFalse(self.e['FSO_Begin'](0)); self.assertFalse(self.e['FSO_Release'](0))
        self.assertTrue(self.e['FSO_Neutralize'](0)); self.w.created[0]['hidden']=False
        self.assertFalse(self.e['FSO_Release'](0)); self.cleanup()

    def test_freelancer_active_alias_uses_owned_replacement(self):
        self.assertTrue(self.e['FSB_Begin'](0)); self.assertTrue(self.e['FSU_Begin'](0))
        self.assertTrue(self.e['FSU_Stage'](0,22,100.,200.)); self.assertTrue(self.e['FSU_Stage'](0,23,110.,210.))
        self.assertTrue(self.e['FSR_Begin'](0)); self.assertTrue(self.e['FSR_Plan'](0,0,True))
        self.assertTrue(self.e['FSR_Plan'](0,1,False)); self.assertTrue(self.e['FSR_Apply'](0))
        self.begin(); self.assertTrue(self.e['FSO_Assign'](0))
        self.assertIs(self.e['udg_PlayerHero'][1],self.w.created[0])
        self.assertIs(self.e['udg_FreelancerHero'][1],self.w.created[0])
        self.assertIs(self.e['udg_JobHeroHash']['H02L',0],self.w.created[0])
        self.assertTrue(self.e['FSO_Verify'](0)); self.cleanup()
        self.assertIs(self.e['udg_FreelancerHero'][1],self.free)

    def test_source_crlf_no_activation_original_mutation_or_deletion(self):
        raw=OWNERSHIP.read_bytes(); self.assertNotIn(b'\n',raw.replace(b'\r\n',b''))
        source=raw.decode('utf-8')
        for call in ('RemoveUnit(', 'CreateUnit(', 'SetHeroXP(', 'ShowUnit(candidate,true)', 'PauseUnit(candidate,false)'):
            self.assertNotIn(call,source)
        self.assertIn('Player(pid),false)',source)
        self.assertIn('Player(PLAYER_NEUTRAL_PASSIVE),false)',source)


if __name__=='__main__': unittest.main()
