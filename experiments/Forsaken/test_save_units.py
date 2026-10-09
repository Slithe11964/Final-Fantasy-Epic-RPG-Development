"""Owned unit staging: real isolated JASS, mocked native failures and provenance."""
import unittest
from test_save_jass import engine, SOURCE
from test_save_session import SessionWorld, SESSION, SESSION_GLOBALS
import test_save_session as session_tests
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA

UNITS=SOURCE.with_name('Forsaken-save-units.j')
MODULES=['life','native','journal','effects','position','equipment','recovery','progression','heroes','session','units']


class UnitWorld(SessionWorld):
    def __init__(self):
        super().__init__()
        self.unit_calls=[]
        self.unit_native_count=0
        self.reject_native=0
        self.unit_hook=None
        self.forced=None
        self.refuse_units=set()
        self.created=[]

    def permit_unit(self,kind,unit=None):
        self.unit_native_count+=1
        self.unit_calls.append((kind,unit))
        if self.unit_hook: self.unit_hook(kind,unit)
        return self.unit_native_count!=self.reject_native

    def create_unit(self,owner,raw,x,y,face):
        if not self.permit_unit('create'): return None
        if self.forced is not None: return self.forced
        u=self.hero(raw,owner,0 if raw=='H01D' else 30)
        u.update(hidden=False,paused=False,invulnerable=False,x=x,y=y,facing=face,inventory_size=6)
        self.created.append(u)
        return u

    def unit_flag(self,kind,u,value):
        if self.permit_unit(kind,u): u[kind]=value

    def remove_unit(self,u):
        if self.permit_unit('remove',u) and id(u) not in self.refuse_units: u['raw']=0

    def natives(self):
        env=super().natives()
        env.update(CreateUnit=self.create_unit,RemoveUnit=self.remove_unit,
            ShowUnit=lambda u,v:self.unit_flag('hidden',u,not v),
            PauseUnit=lambda u,v:self.unit_flag('paused',u,v),
            SetUnitInvulnerable=lambda u,v:self.unit_flag('invulnerable',u,v),
            IsUnitHidden=lambda u:u.get('hidden',False),IsUnitPaused=lambda u:u.get('paused',False),
            BlzIsUnitInvulnerable=lambda u:u.get('invulnerable',False),
            UnitInventorySize=lambda u:u.get('inventory_size',6))
        return env


class UnitTests(unittest.TestCase):
    def setUp(self):
        template=session_tests.SessionTests('test_readonly_capture_and_exact_rollback')
        template.setUp()
        self.w=UnitWorld()
        for name in ('resources','techs','units','types','items'): setattr(self.w,name,getattr(template.w,name))
        for name in ('hero','gaya','free','house','units','table','talents','original_code'): setattr(self,name,getattr(template,name))
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+'\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in MODULES),self.w.natives())
        self.e.update({k:v for k,v in template.e.items() if not callable(v)})
        self.assertTrue(session_tests.SessionTests.capture(self))

    def begin(self,pid=0): self.assertTrue(self.e['FSU_Begin'](pid))
    def stage(self,role=0,pid=0): return self.e['FSU_Stage'](pid,role,100.,200.)

    def test_hidden_neutral_hero_and_originals_untouched(self):
        originals=[dict(u) for u in self.units]
        code=self.e['FSC_Code'][0]
        self.begin()
        self.assertTrue(self.stage())
        u=self.e['FSU_Unit'][0]
        self.assertEqual((u['owner'],u['hidden'],u['paused'],u['invulnerable']),(15,True,True,True))
        self.assertEqual((u['x'],u['y'],u['facing']),(100.,200.,0.))
        self.assertIs(self.e['udg_PlayerHero'][1],self.hero)
        self.assertEqual([dict(u) for u in self.units],originals)
        self.assertEqual(self.e['FSC_Code'][0],code)
        self.assertTrue(self.e['FSU_Verify'](0))
        self.assertFalse(self.e['FSJ_Release'](0))
        self.assertTrue(self.e['FSU_Abort'](0))
        self.assertEqual(u['raw'],0)
        self.assertIsNone(self.e['FSU_Unit'][0])
        self.assertTrue(all(u['raw'] for u in self.units))

    def test_all24_roles_unique_and_bounded(self):
        self.begin()
        for role in range(24): self.assertTrue(self.stage(role))
        self.assertEqual(len(self.w.created),24)
        self.assertEqual([u['raw'] for u in self.w.created],
                         [self.e['FPG_JobRaw'](r) for r in range(22)]+['H02L','H01D'])
        self.assertFalse(self.stage(0))
        self.assertEqual(len(self.w.created),24)
        self.assertTrue(self.e['FSU_Abort'](0))
        self.assertTrue(all(u['raw']==0 for u in self.w.created))

    def test_create_and_three_containment_faults_retain_then_cleanup(self):
        for fault in range(1,5):
            with self.subTest(fault=fault):
                self.setUp(); self.begin(); self.w.reject_native=fault
                self.assertFalse(self.stage())
                self.assertEqual(self.e['FSU_State'][0],2)
                self.assertTrue(self.e['FSN_UnitBlocked'][0])
                self.assertTrue(self.e['FSC_UnitBlocked'][0])
                self.assertFalse(self.e['FSN_Begin'](0))
                self.assertFalse(self.e['FSC_Reset'](0))
                self.assertIsNone(self.e['FSC_Reencode'](0))
                self.assertEqual(self.e['FSU_Count'][0],int(fault!=1))
                self.w.reject_native=0
                self.assertTrue(self.e['FSU_Abort'](0))
                self.assertFalse(self.e['FSN_UnitBlocked'][0])

    def test_each_of24_deletion_failures_retains_only_survivor_and_retries(self):
        for failed in range(24):
            with self.subTest(failed=failed):
                self.setUp(); self.begin()
                for role in range(24): self.assertTrue(self.stage(role))
                self.w.refuse_units.add(id(self.w.created[failed]))
                self.assertFalse(self.e['FSU_Abort'](0))
                self.assertEqual(self.e['FSU_State'][0],3)
                self.assertIs(self.e['FSU_Unit'][failed],self.w.created[failed])
                self.assertEqual(sum(u['raw']!=0 for u in self.w.created),1)
                self.assertFalse(self.stage())
                self.w.refuse_units.clear()
                self.assertTrue(self.e['FSU_Abort'](0))
                self.assertTrue(all(self.e['FSU_Unit'][i] is None for i in range(24)))

    def test_live_original_and_cross_player_original_never_adopted(self):
        for kind in ('active','gaya','free','other_player','journal_only'):
            with self.subTest(kind=kind):
                self.setUp(); self.begin()
                u={'active':self.hero,'gaya':self.gaya,'free':self.free}.get(kind)
                if u is None:
                    u=self.w.hero('H001',7)
                    if kind=='other_player': self.e['udg_JobHeroHash']['H001',7]=u
                    else: self.e['FHU_Unit'][7*25+1]=u
                before=dict(u); self.w.forced=u
                self.assertFalse(self.stage())
                self.assertEqual(self.e['FSU_Count'][0],0)
                self.assertEqual(dict(u),before)
                self.assertTrue(self.e['FSU_Abort'](0))
                self.assertEqual(dict(u),before)

    def test_repeated_native_handle_is_not_owned_twice(self):
        self.begin(); self.assertTrue(self.stage())
        self.w.forced=self.w.created[0]
        self.assertFalse(self.stage(1))
        self.assertEqual(self.e['FSU_Count'][0],1)
        self.assertTrue(self.e['FSU_Abort'](0))
        self.assertEqual(sum(k=='remove' for k,u in self.w.unit_calls),1)

    def test_wrong_raw_owner_or_nonhero_fails_readback(self):
        for field,value in [('raw','HZZZ'),('owner',3),('is_hero',False)]:
            self.setUp(); self.begin()
            def hook(kind,u):
                if kind=='hidden': u[field]=value
            self.w.unit_hook=hook
            self.assertFalse(self.stage())
            self.assertIs(self.e['FSU_Unit'][0],self.w.created[0])
            self.w.unit_hook=None
            self.assertTrue(self.e['FSU_Abort'](0))

    def test_items_in_quick_bag_equipment_prevent_any_unit_deletion(self):
        for kind,slot in [('quick',5),('bag',29),('equip',8)]:
            self.setUp(); self.begin(); self.assertTrue(self.stage(0)); self.assertTrue(self.stage(1))
            u=self.w.created[1]; carried=self.w.create(123,0.,0.); u[kind][slot]=carried
            self.assertFalse(self.e['FSU_Abort'](0))
            self.assertFalse(any(k=='remove' for k,v in self.w.unit_calls))
            self.assertNotEqual(carried['raw'],0)
            u[kind][slot]=None
            self.assertTrue(self.e['FSU_Abort'](0))
            self.assertNotEqual(carried['raw'],0)

    def test_published_unit_refuses_cleanup_until_detached(self):
        self.begin(); self.assertTrue(self.stage())
        u=self.w.created[0]; self.e['udg_PlayerHero'][8]=u
        self.assertFalse(self.e['FSU_Abort'](0))
        self.assertTrue(u['raw'])
        self.e['udg_PlayerHero'][8]=None
        self.assertTrue(self.e['FSU_Abort'](0))

    def test_pending_item_cleanup_and_writer_must_finish_first(self):
        self.begin(); self.assertTrue(self.stage())
        self.assertTrue(self.e['FSN_Begin'](0))
        self.assertFalse(self.e['FSU_Abort'](0))
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assertTrue(self.e['FSC_Begin'](0,42))
        self.assertFalse(self.e['FSU_Abort'](0))
        self.e['FSC_Abort'](0)
        self.assertTrue(self.e['FSU_Abort'](0))

    def test_reentrant_native_calls_are_refused(self):
        self.begin()
        def hook(kind,u):
            for name in ('FSU_Begin','FSU_Verify','FSU_Abort','FSN_Begin','FSN_Abort','FSS_Recover','FHU_Recover','FPG_Recover','FSJ_Release','FSC_Reset'):
                self.assertFalse(self.e[name](0),name)
            self.assertFalse(self.stage(1))
        self.w.unit_hook=hook
        self.assertTrue(self.stage())
        self.assertTrue(self.e['FSU_Abort'](0))

    def test_callback_publication_during_cleanup_keeps_handle(self):
        self.begin(); self.assertTrue(self.stage())
        u=self.w.created[0]
        def hook(kind,candidate):
            if kind=='hidden': self.e['udg_PlayerHero'][8]=candidate
        self.w.unit_hook=hook
        self.assertFalse(self.e['FSU_Abort'](0))
        self.assertTrue(u['raw'])
        self.assertFalse(any(k=='remove' for k,v in self.w.unit_calls))
        self.w.unit_hook=None; self.e['udg_PlayerHero'][8]=None
        self.assertTrue(self.e['FSU_Abort'](0))

    def test_already_deleted_owned_unit_is_cleared_without_second_removal(self):
        self.begin(); self.assertTrue(self.stage())
        self.w.created[0]['raw']=0
        self.assertTrue(self.e['FSU_Abort'](0))
        self.assertFalse(any(k=='remove' for k,v in self.w.unit_calls))

    def test_invalid_players_roles_coordinates_and_recapture(self):
        for pid in (-1,8,8192):
            for name in ('FSU_Begin','FSU_Verify','FSU_Abort'): self.assertFalse(self.e[name](pid))
            self.assertFalse(self.stage(0,pid))
        self.begin(); self.assertFalse(self.e['FSU_Begin'](0))
        for role,x,y in [(-1,0.,0.),(24,0.,0.),(0,float('nan'),0.),(0,0.,float('inf')),(0,32769.,0.)]:
            self.assertFalse(self.e['FSU_Stage'](0,role,x,y))
        self.assertEqual(self.w.created,[])
        self.assertTrue(self.e['FSU_Abort'](0)); self.begin()

    def test_changed_reference_and_containment_block_further_staging(self):
        for kind in ('reference','visible'):
            self.setUp(); self.begin(); self.assertTrue(self.stage())
            if kind=='reference': self.e['udg_PlayerHero'][1]=self.w.hero('H000')
            else: self.w.created[0]['hidden']=False
            self.assertFalse(self.stage(1))
            self.assertEqual(self.e['FSU_State'][0],2)
            self.assertTrue(self.e['FSN_UnitBlocked'][0])
            self.assertTrue(self.e['FSU_Abort'](0))

    def test_abort_clears_only_its_own_guards(self):
        self.begin(); self.assertTrue(self.stage())
        self.e['FSN_SessionBlocked'][0]=self.e['FSC_SessionBlocked'][0]=True
        self.e['FSN_HeroBlocked'][0]=self.e['FSN_ProgressionBlocked'][0]=self.e['FSN_RecoveryBlocked'][0]=True
        self.assertTrue(self.e['FSU_Abort'](0))
        for name in ('FSN_SessionBlocked','FSC_SessionBlocked','FSN_HeroBlocked','FSN_ProgressionBlocked','FSN_RecoveryBlocked'):
            self.assertTrue(self.e[name][0])
        self.assertFalse(self.e['FSJ_UnitPending'][0])

    def test_other_journal_releases_cannot_clear_failed_unit_cleanup(self):
        self.begin(); self.assertTrue(self.stage())
        self.w.refuse_units.add(id(self.w.created[0]))
        self.assertFalse(self.e['FSU_Abort'](0))
        session_tests.SessionTests.recover_all(self)
        for name in ('FQR_Release','FPG_Release','FHU_Release','FSS_Release'):
            self.assertTrue(self.e[name](0),name)
        self.assertFalse(self.e['FSJ_Release'](0))
        self.assertTrue(self.e['FSC_UnitBlocked'][0])
        self.assertTrue(self.e['FSN_UnitBlocked'][0])
        self.assertFalse(self.e['FSC_Decode'](0,self.original_code,42,False))
        self.assertFalse(self.e['FSC_Begin'](0,42))
        self.w.refuse_units.clear()
        self.assertTrue(self.e['FSU_Abort'](0))
        self.assertTrue(self.e['FSJ_Release'](0))
        self.assertEqual(self.e['FSC_Reencode'](0),self.original_code)

    def test_begin_requires_all_capture_and_verified_original_state(self):
        for kind in ('session','writer','talent','unit_guard'):
            self.setUp()
            if kind=='session': self.e['FSS_State'][0]=0
            elif kind=='writer': self.e['FSC_Writing'][0]=True
            elif kind=='talent': self.talents['boolean',0,0]=True
            else: self.e['FSN_UnitBlocked'][0]=True
            self.assertFalse(self.e['FSU_Begin'](0))
            self.assertEqual(self.w.unit_calls,[])

    def test_player7_bounds(self):
        self.setUp()
        self.assertTrue(session_tests.SessionTests.capture(self,7))
        self.begin(7)
        for role in range(24): self.assertTrue(self.stage(role,7))
        self.assertIs(self.e['FSU_Unit'][191],self.w.created[-1])
        self.assertTrue(self.e['FSU_Abort'](7))
        self.assertTrue(all(self.e['FSU_Unit'][i] is None for i in range(168,192)))

    def test_source_boundaries_and_crlf(self):
        data=UNITS.read_bytes(); self.assertNotIn(b'\n',data.replace(b'\r\n',b''))
        text=data.decode()
        for phrase in ('initializer','call Job_GetHero(','call Gaya_RecreateSpirit(','call SaveUnitHandle(','call RemoveItem(','set udg_PlayerHero['):
            self.assertNotIn(phrase,text.replace('// No original mutation, reference promotion, initializer or successful-load commit.',''))


if __name__=='__main__': unittest.main()
