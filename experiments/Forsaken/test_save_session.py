"""Actual session journal source with typed native table faults and codec checks."""
import itertools
import unittest

from test_save_jass import engine, SOURCE
from test_save_life import LIFE
from test_save_native import NATIVE
from test_save_position import JOURNAL, EFFECTS, POSITION, SPACER, Handle
from test_save_equipment import EQUIPMENT, RING_FILLER
from test_save_recovery import RECOVERY
from test_save_progression_journal import PROGRESSION, DECLARATIONS
from test_save_heroes import HEROES, EXTRA, HeroWorld
import test_save_heroes as hero_tests
import save_vnext as codec

SESSION=SOURCE.with_name('Forsaken-save-session.j')
SKILLS=['AbilitySlot1','AbilitySlot2','AbilitySlot3','AbilitySlot4','MainSkillSlot','SubSkillSlot']
SESSION_GLOBALS='''
globals
    hashtable ForsakenTalentState
    integer array ChroniclesMonographCount
    boolean array ChroniclesMonographSeen
'''+''.join('    integer array udg_'+name+'\n' for name in SKILLS)+'endglobals\n'


class TypedTable(Handle): pass


class SessionWorld(HeroWorld):
    def __init__(self):
        super().__init__()
        self.session_writes=[]
        self.reject_session=0
        self.session_callback=None

    def typed_write(self,table,kind,parent,child,value,remove=False):
        self.session_writes.append((kind,parent,child,remove))
        if self.session_callback: self.session_callback()
        if len(self.session_writes)!=self.reject_session:
            if remove: table.pop((kind,parent,child),None)
            else: table[kind,parent,child]=value
        return True

    def natives(self):
        env=super().natives()
        env.setdefault('LoadBoolean',lambda t,p,k:t.get((p,k),False))
        env.setdefault('SaveBoolean',lambda t,p,k,v:t.__setitem__((p,k),v))
        fallback={name:env[name] for name in ('LoadBoolean','LoadInteger','SaveBoolean','SaveInteger','HaveSavedInteger','RemoveSavedInteger')}
        env.update(
            HaveSavedBoolean=lambda t,p,k:('boolean',p,k) in t if isinstance(t,TypedTable) else (p,k) in t,
            LoadBoolean=lambda t,p,k:t.get(('boolean',p,k),False) if isinstance(t,TypedTable) else fallback['LoadBoolean'](t,p,k),
            LoadInteger=lambda t,p,k:t.get(('integer',p,k),0) if isinstance(t,TypedTable) else fallback['LoadInteger'](t,p,k),
            HaveSavedInteger=lambda t,p,k:('integer',p,k) in t if isinstance(t,TypedTable) else fallback['HaveSavedInteger'](t,p,k),
            SaveBoolean=lambda t,p,k,v:self.typed_write(t,'boolean',p,k,v) if isinstance(t,TypedTable) else fallback['SaveBoolean'](t,p,k,v),
            SaveInteger=lambda t,p,k,v:self.typed_write(t,'integer',p,k,v) if isinstance(t,TypedTable) else fallback['SaveInteger'](t,p,k,v),
            RemoveSavedBoolean=lambda t,p,k:self.typed_write(t,'boolean',p,k,None,True),
            RemoveSavedInteger=lambda t,p,k:self.typed_write(t,'integer',p,k,None,True) if isinstance(t,TypedTable) else fallback['RemoveSavedInteger'](t,p,k))
        return env


class SessionTests(unittest.TestCase):
    def setUp(self):
        template=hero_tests.HeroTests('test_exact_progression_and_alias_recovery')
        template.setUp()
        self.w=SessionWorld()
        for name in ('resources','techs','units','types','items'): setattr(self.w,name,getattr(template.w,name))
        self.hero,self.gaya,self.free,self.house=template.hero,template.gaya,template.free,template.house
        self.units=template.units
        self.table={}
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+'\n'.join(p.read_text() for p in
            [LIFE,NATIVE,JOURNAL,EFFECTS,POSITION,EQUIPMENT,RECOVERY,PROGRESSION,HEROES,SESSION]),self.w.natives())
        self.e.update({k:v for k,v in template.e.items() if k.startswith('udg_') and k not in
                      {'udg_'+name for name in SKILLS}})
        self.talents=TypedTable()
        self.e['ForsakenTalentState']=self.talents
        for pid in (0,7):
            for job in range(23):
                parent=pid*100+job
                self.talents['boolean',parent,0]=bool(job%2)
                self.talents['boolean',parent,3]=True
                self.talents['boolean',parent,4]=False
                if job%3: self.talents['integer',parent,20]=job%4
            for index,name in enumerate(SKILLS): self.e['udg_'+name][pid+1]=pid+index
            self.e['ChroniclesMonographCount'][pid+1]=3
            for slot in (0,2,9): self.e['ChroniclesMonographSeen'][(pid+1)*10+slot]=True
        self.original_code=self.code(42)
        self.assertTrue(self.e['FSC_Decode'](0,self.original_code,42,False))

    def code(self,account):
        return codec.encode(codec.Envelope(account,[codec.Section(1,1,True,codec.inventory([])),
                                                   codec.Section(777,3,False,'AQ')]))

    def capture(self,pid=0):
        if pid==7:
            self.hero['owner']=self.gaya['owner']=7
            self.e['udg_PlayerHero'][8]=self.hero
            self.e['udg_SpiritOfGaya'][8]=self.gaya
            self.e['udg_FreelancerHero'][8]=self.free
            self.e['udg_JobHeroHash']['H000',7]=self.hero
        self.assertTrue(self.e['FSJ_Capture'](pid,self.hero,self.gaya,self.house,True))
        self.assertTrue(self.e['FQR_Begin'](pid,self.table))
        self.assertTrue(self.e['FPG_Begin'](pid))
        self.assertTrue(self.e['FHU_Begin'](pid))
        return self.e['FSS_Begin'](pid)

    def mutate(self,pid=0):
        for job in range(23):
            parent=pid*100+job
            self.talents['integer',parent,20]=777
            for node in range(12):
                self.talents['boolean',parent,node]=not self.talents.get(('boolean',parent,node),False)
        for name in SKILLS: self.e['udg_'+name][pid+1]=777
        self.e['ChroniclesMonographCount'][pid+1]=9
        for node in range(10): self.e['ChroniclesMonographSeen'][(pid+1)*10+node]=False

    def recover_all(self,pid=0):
        self.assertTrue(self.e['FSS_Recover'](pid))
        self.assertTrue(self.e['FHU_Recover'](pid))
        self.assertTrue(self.e['FPG_Recover'](pid))
        self.assertTrue(self.e['FQR_Recover'](pid,SPACER,RING_FILLER,30))

    def test_readonly_capture_and_exact_rollback(self):
        original=dict(self.talents)
        self.assertTrue(self.capture())
        self.assertEqual(self.w.session_writes,[])
        self.mutate()
        self.assertFalse(self.e['FSS_Verify'](0))
        self.recover_all()
        self.assertTrue(self.e['FSS_Verify'](0))
        self.assertEqual(dict(self.talents),original)
        self.assertEqual(self.e['ChroniclesMonographCount'][1],3)

    def test_all299_native_write_failures_block_and_retry(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertEqual(len(self.w.session_writes),299)
        for fault in range(1,300):
            with self.subTest(fault=fault):
                self.mutate()
                self.w.session_writes=[]
                self.w.reject_session=fault
                self.assertFalse(self.e['FSS_Recover'](0))
                self.assertEqual(self.e['FSS_State'][0],3)
                self.assertTrue(self.e['FSJ_SessionPending'][0])
                self.assertFalse(self.e['FSN_Begin'](0))
                self.assertFalse(self.e['FSC_Reset'](0))
                self.assertFalse(self.e['FSJ_Release'](0))
                self.w.reject_session=0
                self.assertTrue(self.e['FSS_Recover'](0))

    def test_absent_present_false_and_present_zero_are_distinct(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertIn(('boolean',0,0),self.talents)
        self.assertFalse(self.talents['boolean',0,0])
        self.assertNotIn(('boolean',0,1),self.talents)
        self.assertNotIn(('integer',0,20),self.talents)
        self.assertEqual(self.talents['integer',4,20],0)

    def test_typed_and_unrelated_fields_and_other_player_survive(self):
        self.talents['integer',0,0]=4321
        self.talents['string',0,20]='opaque unrelated'
        self.talents['boolean',0,99]=True
        self.talents['integer',100,20]=888  # Player1, outside this journal.
        original=dict(self.talents)
        self.assertTrue(self.capture())
        self.mutate()
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertEqual(dict(self.talents),original)

    def test_prior_accepted_code_and_unknown_sections_restore(self):
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FSC_Decode'](0,self.code(99),99,False))
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertEqual(self.e['FSC_Code'][0],self.original_code)
        self.assertIsNone(self.e['FSC_Reencode'](0))
        self.recover_all()
        self.assertTrue(self.e['FSS_Release'](0))
        self.assertEqual(self.e['FSC_Reencode'](0),self.original_code)
        self.assertEqual(self.e['FSC_Id'][33],777)
        self.assertEqual(self.e['FSC_Payload'][33],'AQ')

    def test_all_accepted_slots_and_metadata_caches_preserved(self):
        for slot in range(32):
            self.e['FSC_Id'][32+slot]=slot+1000
            self.e['FSC_Version'][32+slot]=slot+1
            self.e['FSC_Required'][32+slot]=bool(slot%2)
            self.e['FSC_Payload'][32+slot]='AQ'+str(slot)
        self.e['FSC_Count'][1]=32
        self.e['FSC_Text'][1]='literal cached cursor'
        self.e['FSC_Pos'][1]=7
        self.e['FSC_End'][1]=18
        self.e['FSC_Opaque'][1]=12
        self.e['FSC_Dormant'][1]=4
        self.e['FSC_HasEvidence'][1]=True
        for slot in range(16):
            self.e['FSC_Spec'][16+slot]=slot+20
            self.e['FSC_Gaya'][16+slot]=slot+30
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FSC_Reset'](0))
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertTrue(self.e['FSS_Verify'](0))
        self.assertEqual(self.e['FSC_Text'][1],'literal cached cursor')
        self.assertEqual(self.e['FSC_Payload'][63],'AQ31')
        self.assertEqual(self.e['FSC_Gaya'][31],45)

    def test_empty_accepted_code_stays_empty(self):
        self.assertTrue(self.e['FSC_Reset'](0))
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FSC_Decode'](0,self.code(99),99,False))
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertIsNone(self.e['FSC_Code'][0])
        self.assertEqual(self.e['FSC_Count'][1],0)

    def test_player7_indices_and_reference_release(self):
        self.assertTrue(self.e['FSC_Decode'](7,self.code(7),7,False))
        self.assertTrue(self.capture(7))
        self.assertEqual(max(self.e['FSS_Choice']),2207)
        self.assertEqual(max(self.e['FSS_Payload']),255)
        self.mutate(7)
        self.recover_all(7)
        self.assertTrue(self.e['FSS_Release'](7))
        self.assertIsNone(self.e['FSS_Code'][7])
        self.assertIsNone(self.e['FSS_Talents'][7])
        self.assertTrue(all(u is None for u in self.e['FSS_Unit'].values()))
        self.assertTrue(all(p is None for p in self.e['FSS_Payload'].values()))
        self.assertEqual(self.e['FSC_Code'][0],self.original_code)

    def test_all24_release_orders_keep_independent_guards(self):
        for order in itertools.permutations(('FSS','FHU','FPG','FQR')):
            self.setUp()
            self.assertTrue(self.capture())
            self.mutate()
            self.recover_all()
            for index,prefix in enumerate(order):
                self.assertTrue(self.e[prefix+'_Release'](0),order)
                self.assertEqual(self.e['FSN_Begin'](0),index==3,order)
                if index<3: self.assertFalse(self.e['FSJ_Release'](0))
            self.assertTrue(self.e['FSJ_Release'](0))

    def test_session_release_requires_other_recoveries(self):
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertFalse(self.e['FSS_Release'](0))
        self.recover_all()
        self.hero['bonuses']=(100,4,5)
        self.assertFalse(self.e['FSS_Release'](0))
        self.hero['bonuses']=(3,4,5)
        self.assertTrue(self.e['FSS_Release'](0))

    def test_replaced_table_or_hero_reference_refuses_before_writes(self):
        self.assertTrue(self.capture())
        for name,value in [('ForsakenTalentState',TypedTable()),('udg_JobHeroHash',Handle())]:
            old=self.e[name]
            self.e[name]=value
            self.assertFalse(self.e['FSS_Recover'](0))
            self.assertEqual(self.w.session_writes,[])
            self.e[name]=old
        self.e['udg_FreelancerHero'][1]=self.w.hero('H02L',15)
        self.assertFalse(self.e['FSS_Recover'](0))
        self.assertEqual(self.w.session_writes,[])

    def test_active_writer_cleanup_then_recovery_retry(self):
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FSC_Begin'](0,42))
        self.assertFalse(self.e['FSS_Recover'](0))
        self.assertIsNone(self.e['FSC_Finish'](0,False))
        self.assertFalse(self.e['FSC_Add'](0,777,1,False,'AQ'))
        self.e['FSC_Abort'](0)
        self.assertFalse(self.e['FSC_Writing'][0])
        self.assertTrue(self.e['FSS_Recover'](0))

    def test_blocked_codec_public_mutation_is_refused(self):
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertFalse(self.e['FSC_Decode'](0,self.code(99),99,False))
        self.assertFalse(self.e['FSC_Begin'](0,99))
        self.assertFalse(self.e['FSC_Reset'](0))
        self.assertIsNone(self.e['FSC_Reencode'](0))
        self.assertEqual(self.e['FSC_Code'][0],self.original_code)

    def test_reentrant_operations_and_codec_writes_are_blocked(self):
        self.assertTrue(self.capture())
        self.mutate()
        def callback():
            for name in ('FSS_Begin','FSS_Recover','FSS_Verify','FSS_Release','FHU_Recover','FPG_Recover','FSN_Begin','FSJ_Release','FSC_Reset'):
                self.assertFalse(self.e[name](0))
            self.assertFalse(self.e['FQR_Recover'](0,SPACER,RING_FILLER,30))
            self.assertFalse(self.e['FSC_Decode'](0,self.code(99),99,False))
        self.w.session_callback=callback
        self.assertTrue(self.e['FSS_Recover'](0))

    def test_post_recovery_change_prevents_release(self):
        self.assertTrue(self.capture())
        self.recover_all()
        self.e['ChroniclesMonographCount'][1]=4
        self.assertFalse(self.e['FSS_Release'](0))
        self.assertTrue(self.e['FSJ_SessionPending'][0])
        self.assertTrue(self.e['FSS_Recover'](0))
        self.assertTrue(self.e['FSS_Release'](0))

    def test_bounds_invalid_players_busy_and_recapture(self):
        for pid in (-1,8,8192):
            for name in ('FSS_Begin','FSS_Recover','FSS_Verify','FSS_Release'):
                self.assertFalse(self.e[name](pid))
        self.assertTrue(self.capture())
        self.assertFalse(self.e['FSS_Begin'](0))
        self.e['FSC_Busy'][0]=True
        self.assertFalse(self.e['FSS_Recover'](0))

    def test_unsupported_bounds_and_null_table_refuse_capture(self):
        for name,value in [('table',None),('count',33),('monographs',11)]:
            self.setUp()
            if name=='table': self.e['ForsakenTalentState']=value
            elif name=='count': self.e['FSC_Count'][1]=value
            else: self.e['ChroniclesMonographCount'][1]=value
            self.assertFalse(self.capture())
            self.assertFalse(self.e['FSJ_SessionPending'][0])
            self.assertEqual(self.w.session_writes,[])

    def test_source_schema_matches_live_keys_and_no_serialization(self):
        data=SESSION.read_bytes()
        self.assertNotIn(b'\n',data.replace(b'\r\n',b''))
        text=data.decode()
        self.assertNotIn('initializer',text)
        for native in ('FlushChildHashtable','DestroyHashtable','CreateUnit','RemoveUnit','FSC_Add','FSC_Decode'):
            self.assertNotIn('call '+native+'(',text)
        panels=SOURCE.with_name('Forsaken-panels.j').read_text()
        self.assertIn('GetPlayerId(owner)*100+job',panels)
        self.assertIn('key,20,',panels)
        self.assertIn('node<0 or node>=12',panels)
        self.assertIn('local integer active=pid+1',text)


if __name__=='__main__': unittest.main()
