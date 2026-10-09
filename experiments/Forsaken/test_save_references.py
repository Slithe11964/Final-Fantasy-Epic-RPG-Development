"""Actual-source reference switch/reversal, native write failures and cleanup gates."""
import unittest
from test_save_jass import engine, SOURCE, JassArray
from test_save_units import UnitWorld, MODULES
import test_save_units as unit_tests
import test_save_session as session_tests
from test_save_session import SESSION_GLOBALS
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA
from test_save_position import Handle

REFERENCES=SOURCE.with_name('Forsaken-save-references.j')


class RefWorld(UnitWorld):
    def __init__(self):
        super().__init__()
        self.ref_writes=[]; self.reject_ref=0; self.ref_hook=None

    def reference_write(self,table,parent,child,value,remove=False):
        self.ref_writes.append((parent,child,remove))
        if self.ref_hook: self.ref_hook()
        if len(self.ref_writes)!=self.reject_ref:
            if remove: table.pop((parent,child),None)
            else: table[parent,child]=value
        return True

    def natives(self):
        env=super().natives()
        def load(table,parent,child):
            value=table.get((parent,child))
            return value if isinstance(value,Handle) and 'is_hero' in value else None
        env.update(LoadUnitHandle=load,HaveSavedHandle=lambda t,p,k:(p,k) in t,
            SaveUnitHandle=lambda t,p,k,u:self.reference_write(t,p,k,u),
            RemoveSavedHandle=lambda t,p,k:self.reference_write(t,p,k,None,True))
        return env


class RejectArray(JassArray):
    def __init__(self,base):
        super().__init__(lambda:None); self.update(base); self.reject=False
    def __setitem__(self,key,value):
        if not self.reject: super().__setitem__(key,value)


class ReferenceTests(unittest.TestCase):
    def setUp(self):
        template=unit_tests.UnitTests('test_hidden_neutral_hero_and_originals_untouched')
        template.setUp()
        self.w=RefWorld()
        for name in ('resources','techs','units','types','items'): setattr(self.w,name,getattr(template.w,name))
        for name in ('hero','gaya','free','house','units','table','talents','original_code'): setattr(self,name,getattr(template,name))
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+'\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in MODULES)+REFERENCES.read_text(),self.w.natives())
        self.e.update({k:v for k,v in template.e.items() if not callable(v)})
        self.assertTrue(self.e['FSU_Begin'](0))

    def stage(self,role=0,pid=0):
        self.assertTrue(self.e['FSU_Stage'](pid,role,100.,100.))
        return self.e['FSU_Count'][pid]-1

    def prepare(self,full=False,pid=0):
        roles=range(24) if full else [0]
        stages=[self.stage(r,pid) for r in roles]
        self.assertTrue(self.e['FSR_Begin'](pid))
        for stage in stages: self.assertTrue(self.e['FSR_Plan'](pid,stage,False))

    def cleanup(self,pid=0):
        self.assertTrue(self.e['FSR_Reverse'](pid))
        self.assertTrue(self.e['FSU_Abort'](pid))
        self.assertTrue(self.e['FSR_Release'](pid))

    def test_capture_plan_is_read_only_and_active_alias_switch_reverses(self):
        before=[dict(u) for u in self.units]
        self.prepare()
        self.assertIs(self.e['udg_PlayerHero'][1],self.hero)
        self.assertEqual(self.w.ref_writes,[])
        self.assertTrue(self.e['FSR_Apply'](0))
        new=self.w.created[0]
        self.assertIs(self.e['udg_PlayerHero'][1],new)
        self.assertIs(self.e['udg_JobHeroHash']['H000',0],new)
        self.assertEqual([dict(u) for u in self.units],before)
        self.assertEqual((new['owner'],new['hidden'],new['paused']),(15,True,True))
        self.assertFalse(self.e['FSU_Abort'](0))
        self.assertFalse(self.e['FSC_Reset'](0))
        self.cleanup()
        self.assertIs(self.e['udg_PlayerHero'][1],self.hero)
        self.assertTrue(self.hero['raw']); self.assertEqual(new['raw'],0)

    def test_activate_different_job_uses_same_owned_cached_handle(self):
        stage=self.stage(1); self.assertTrue(self.e['FSR_Begin'](0))
        self.assertTrue(self.e['FSR_Plan'](0,stage,True))
        self.assertTrue(self.e['FSR_Apply'](0))
        self.assertIs(self.e['udg_PlayerHero'][1],self.w.created[0])
        self.assertIs(self.e['udg_JobHeroHash'][self.e['FPG_JobRaw'](1),0],self.w.created[0])
        self.cleanup()

    def test_freelancer_cache_global_and_active_share_replacement(self):
        stage=self.stage(22); self.assertTrue(self.e['FSR_Begin'](0))
        self.assertTrue(self.e['FSR_Plan'](0,stage,True)); self.assertTrue(self.e['FSR_Apply'](0))
        for value in (self.e['udg_FreelancerHero'][1],self.e['udg_PlayerHero'][1],self.e['udg_JobHeroHash']['H02L',0]):
            self.assertIs(value,self.w.created[0])
        self.cleanup(); self.assertNotIn(('H02L',0),self.e['udg_JobHeroHash'])
        self.assertIs(self.e['udg_FreelancerHero'][1],self.free)

    def test_gaya_never_becomes_active(self):
        stage=self.stage(23); self.assertTrue(self.e['FSR_Begin'](0))
        self.assertFalse(self.e['FSR_Plan'](0,stage,True))
        self.assertTrue(self.e['FSR_Plan'](0,stage,False)); self.assertTrue(self.e['FSR_Apply'](0))
        self.assertIs(self.e['udg_PlayerHero'][1],self.hero)
        self.assertIs(self.e['udg_SpiritOfGaya'][1],self.w.created[0]); self.cleanup()

    def test_all23_forward_table_write_faults_block_and_reverse(self):
        for fault in range(1,24):
            self.setUp(); self.prepare(True); self.w.reject_ref=fault
            self.assertFalse(self.e['FSR_Apply'](0),fault)
            self.assertEqual(self.e['FSR_State'][0],3)
            self.assertTrue(self.e['FSC_ReferenceBlocked'][0])
            self.w.reject_ref=0; self.cleanup()
            self.assertTrue(self.e['FSS_Verify'](0))

    def test_all23_reversal_table_write_faults_retain_and_retry(self):
        for fault in range(1,24):
            self.setUp(); self.prepare(True); self.assertTrue(self.e['FSR_Apply'](0))
            self.w.ref_writes=[]; self.w.reject_ref=fault
            self.assertFalse(self.e['FSR_Reverse'](0),fault)
            self.assertFalse(self.e['FSR_Release'](0))
            self.w.reject_ref=0; self.cleanup()

    def test_three_global_assignment_faults_each_direction_require_readback(self):
        for name in ('udg_FreelancerHero','udg_SpiritOfGaya','udg_PlayerHero'):
            for reverse in (False,True):
                self.setUp(); self.prepare(True)
                array=RejectArray(self.e[name]); self.e[name]=array
                if reverse: self.assertTrue(self.e['FSR_Apply'](0))
                array.reject=True
                self.assertFalse(self.e['FSR_Reverse' if reverse else 'FSR_Apply'](0))
                array.reject=False; self.cleanup()

    def test_absent_entries_restore_and_unrelated_types_other_players_survive(self):
        table=self.e['udg_JobHeroHash']
        table['integer','H000',0]=42; table['string','H000',0]='keep'
        other=self.w.hero('H001',7); table['H001',7]=other
        before=dict(table)
        self.prepare(True); self.assertTrue(self.e['FSR_Apply'](0)); self.cleanup()
        self.assertEqual(dict(table),before)

    def test_foreign_unit_or_table_change_refuses_reversal_before_writes(self):
        for kind in ('unit','table','owner'):
            self.setUp(); self.prepare(); self.assertTrue(self.e['FSR_Apply'](0)); writes=len(self.w.ref_writes)
            table=self.e['udg_JobHeroHash']
            if kind=='unit': self.e['udg_PlayerHero'][1]=self.w.hero('H000')
            elif kind=='table': self.e['udg_JobHeroHash']=Handle(table)
            else: self.hero['owner']=7
            self.assertFalse(self.e['FSR_Reverse'](0))
            self.assertEqual(len(self.w.ref_writes),writes)
            if kind=='unit': self.e['udg_PlayerHero'][1]=self.w.created[0]
            elif kind=='table': self.e['udg_JobHeroHash']=table
            else: self.hero['owner']=0
            self.cleanup()

    def test_nonunit_handle_at_known_key_refuses_capture_and_recovery(self):
        table=self.e['udg_JobHeroHash']; table['H02L',0]=Handle(kind='item',raw=123)
        self.assertFalse(self.e['FSR_Begin'](0)); self.assertEqual(self.w.ref_writes,[])
        table.pop(('H02L',0)); self.prepare(); self.assertTrue(self.e['FSR_Apply'](0))
        table['H02L',0]=Handle(kind='item',raw=123)
        writes=len(self.w.ref_writes); self.assertFalse(self.e['FSR_Reverse'](0))
        self.assertEqual(len(self.w.ref_writes),writes); table.pop(('H02L',0)); self.cleanup()

    def test_reentrant_operations_blocked_during_reference_writes(self):
        self.prepare()
        def hook():
            for name in ('FSR_Begin','FSR_Apply','FSR_Reverse','FSR_Release','FSU_Abort','FSS_Recover','FHU_Recover','FSJ_Release','FSC_Reset'):
                self.assertFalse(self.e[name](0),name)
            self.assertFalse(self.e['FSR_Plan'](0,0,True))
        self.w.ref_hook=hook; self.assertTrue(self.e['FSR_Apply'](0)); self.cleanup()

    def test_original_recovery_and_releases_keep_reference_guard_until_cleanup(self):
        self.prepare(); self.assertTrue(self.e['FSR_Apply'](0))
        self.assertFalse(self.e['FSS_Recover'](0))
        self.assertTrue(self.e['FSR_Reverse'](0))
        session_tests.SessionTests.recover_all(self)
        for name in ('FQR_Release','FPG_Release','FHU_Release','FSS_Release'): self.assertTrue(self.e[name](0))
        self.assertTrue(self.e['FSU_Abort'](0))
        self.assertFalse(self.e['FSJ_Release'](0)); self.assertIsNone(self.e['FSC_Reencode'](0))
        self.assertTrue(self.e['FSR_Release'](0)); self.assertTrue(self.e['FSJ_Release'](0))
        self.assertEqual(self.e['FSC_Reencode'](0),self.original_code)

    def test_invalid_player_plan_bounds_recapture_and_missing_journal(self):
        for pid in (-1,8,8192):
            for name in ('FSR_Begin','FSR_Apply','FSR_Reverse','FSR_Release'): self.assertFalse(self.e[name](pid))
        self.prepare(); self.assertFalse(self.e['FSR_Begin'](0))
        for staged in (-1,1,24): self.assertFalse(self.e['FSR_Plan'](0,staged,True))
        self.cleanup(); self.assertFalse(self.e['FSR_Begin'](0))

    def test_player7_max_indices_and_references_cleared(self):
        self.assertTrue(session_tests.SessionTests.capture(self,7)); self.assertTrue(self.e['FSU_Begin'](7))
        self.prepare(True,7); self.assertTrue(self.e['FSR_Apply'](7)); self.cleanup(7)
        self.assertTrue(all(self.e['FSR_Old'][i] is None and self.e['FSR_Target'][i] is None for i in range(182,208)))

    def test_source_crlf_and_no_original_deletion_or_activation(self):
        data=REFERENCES.read_bytes(); self.assertNotIn(b'\n',data.replace(b'\r\n',b''))
        text=data.decode()
        for native in ('RemoveUnit','CreateUnit','UnitAddItem','SetUnitOwner','ShowUnit','SetHeroXP','FlushChildHashtable'):
            self.assertNotIn('call '+native+'(',text)


if __name__=='__main__': unittest.main()
