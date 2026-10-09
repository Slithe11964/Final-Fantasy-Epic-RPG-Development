"""Original living hero body recovery: native failures, identity and guards."""
import unittest
from test_save_jass import engine, SOURCE
from test_save_units import MODULES
from test_save_references import RefWorld, REFERENCES
import test_save_units as unit_tests
import test_save_session as session_tests
from test_save_session import SESSION_GLOBALS
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA
from test_save_position import SPACER
from test_save_equipment import RING_FILLER

BODY=SOURCE.with_name('Forsaken-save-body.j')
FIELDS=('x','y','facing','body_life','mana','invulnerable','hidden','paused')


class BodyWorld(RefWorld):
    def __init__(self):
        super().__init__()
        self.body_writes=[]; self.reject_body=0; self.body_hook=None

    def body_set(self,u,key,value):
        self.body_writes.append((id(u),key,value))
        if self.body_hook: self.body_hook()
        if len(self.body_writes)!=self.reject_body: u[key]=value

    def natives(self):
        env=super().natives()
        old_life=env['GetWidgetLife']; old_set=env['SetWidgetLife']
        env.update(UNIT_TYPE_DEAD='dead',UNIT_STATE_MANA='mana',
            UNIT_STATE_MAX_LIFE='max_life',UNIT_STATE_MAX_MANA='max_mana',
            IsUnitType=lambda u,t:u.get('dead',False) if t=='dead' else u['is_hero'],
            GetWidgetLife=lambda u:u['body_life'] if 'is_hero' in u else old_life(u),
            SetWidgetLife=lambda u,v:self.body_set(u,'body_life',v) if 'is_hero' in u else old_set(u,v),
            GetUnitState=lambda u,k:u[k],SetUnitState=lambda u,k,v:self.body_set(u,k,v),
            GetUnitX=lambda u:u['x'],GetUnitY=lambda u:u['y'],GetUnitFacing=lambda u:u['facing'],
            SetUnitX=lambda u,v:self.body_set(u,'x',v),SetUnitY=lambda u,v:self.body_set(u,'y',v),
            BlzSetUnitFacingEx=lambda u,v:self.body_set(u,'facing',v),
            ShowUnit=lambda u,v:self.body_set(u,'hidden',not v),
            PauseUnit=lambda u,v:self.body_set(u,'paused',v),
            SetUnitInvulnerable=lambda u,v:self.body_set(u,'invulnerable',v))
        return env


class BodyTests(unittest.TestCase):
    def setUp(self):
        template=unit_tests.UnitTests('test_hidden_neutral_hero_and_originals_untouched')
        template.setUp()
        self.w=BodyWorld()
        for name in ('resources','techs','units','types','items'): setattr(self.w,name,getattr(template.w,name))
        for name in ('hero','gaya','free','house','units','table','talents','original_code'): setattr(self,name,getattr(template,name))
        for ordinal,u in enumerate(self.units): self.body(u,ordinal)
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+'\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in MODULES)+REFERENCES.read_text()+BODY.read_text(),self.w.natives())
        self.e.update({k:v for k,v in template.e.items() if not callable(v)})

    def body(self,u,n=0):
        u.update(x=-125.25+n,y=310.5+n,facing=123.75,body_life=531.25,mana=0. if n==1 else 71.5,
                 max_life=1000.,max_mana=250.,hidden=bool(n%2),paused=bool(n%2),invulnerable=bool(n%2),dead=False)

    def capture(self,pid=0):
        self.assertTrue(self.e['FSB_Begin'](pid))
        self.original={id(u):{k:u[k] for k in FIELDS} for u in self.units}

    def change(self):
        for u in self.units:
            u.update(x=800.,y=-900.,facing=20.,body_life=11.,mana=23.,
                     hidden=not u['hidden'],paused=not u['paused'],invulnerable=not u['invulnerable'])

    def assert_original(self):
        for u in self.units: self.assertEqual({k:u[k] for k in FIELDS},self.original[id(u)])

    def test_readonly_capture_alias_dedup_and_exact_recovery(self):
        self.capture(); self.assertEqual(self.w.body_writes,[])
        self.assertTrue(self.e['FSB_Verify'](0)); self.assertFalse(self.e['FSB_Begin'](0))
        self.change(); self.assertFalse(self.e['FSB_Verify'](0))
        self.assertTrue(self.e['FSB_Recover'](0)); self.assert_original()
        self.assertEqual(len(self.w.body_writes),8*len(self.units))
        self.assertEqual(len({u for u,k,v in self.w.body_writes}),len(self.units))
        self.assertTrue(self.e['FSB_Release'](0)); self.assertIsNone(self.e['FSB_Unit'][0])

    def test_every_body_write_failure_retains_guards_and_retries(self):
        count=8*len(self.units)
        for fault in range(1,count+1):
            with self.subTest(fault=fault):
                self.setUp(); self.capture(); self.change(); self.w.reject_body=fault
                self.assertFalse(self.e['FSB_Recover'](0)); self.assertEqual(self.e['FSB_State'][0],3)
                self.assertFalse(self.e['FSB_Release'](0)); self.assertTrue(self.e['FSN_BodyBlocked'][0])
                self.assertTrue(self.e['FSC_BodyBlocked'][0]); self.assertTrue(self.e['FSJ_BodyPending'][0])
                self.assertIs(self.e['FSB_Unit'][0],self.hero)
                self.w.reject_body=0
                self.assertTrue(self.e['FSB_Recover'](0)); self.assert_original()
                self.assertTrue(self.e['FSB_Release'](0))

    def test_invalid_body_capture_clears_partial_references_without_setters(self):
        for key,value in [('x',float('nan')),('y',float('inf')),('x',32769.),('facing',360.),
                          ('body_life',0.405),('body_life',1001.),('mana',-1.),('mana',251.),
                          ('max_life',float('inf')),('max_mana',float('nan')),('dead',True)]:
            with self.subTest(key=key,value=value):
                self.setUp(); self.free[key]=value
                self.assertFalse(self.e['FSB_Begin'](0)); self.assertEqual(self.w.body_writes,[])
                self.assertEqual(self.e['FSB_State'][0],0); self.assertFalse(self.e['FSJ_BodyPending'][0])
                self.assertTrue(all(self.e['FSB_Unit'][i] is None for i in range(25)))

    def test_changed_maximum_refuses_before_any_setter_and_retries(self):
        self.capture(); self.change(); self.gaya['max_life']=900.
        self.assertFalse(self.e['FSB_Recover'](0)); self.assertEqual(self.w.body_writes,[])
        self.gaya['max_life']=1000.
        self.assertTrue(self.e['FSB_Recover'](0)); self.assert_original()

    def test_dead_original_is_not_resurrected(self):
        self.capture(); self.hero['dead']=True; self.hero['body_life']=0.
        self.assertFalse(self.e['FSB_Recover'](0)); self.assertEqual(self.w.body_writes,[])
        self.assertFalse(self.e['FSB_Release'](0)); self.assertEqual(self.hero['body_life'],0.)

    def test_destroyed_foreign_owned_or_replaced_original_refuses_setters(self):
        for change in ('raw','owner','ref','table','roster'):
            with self.subTest(change=change):
                self.setUp(); self.capture()
                if change=='raw': self.free['raw']=0
                elif change=='owner': self.free['owner']=3
                elif change=='ref': self.e['udg_PlayerHero'][1]=self.w.hero('H001')
                elif change=='table': self.e['udg_JobHeroHash']=dict(self.table)
                else: self.e['udg_JobUnitType'][1]='HZZZ'
                self.assertFalse(self.e['FSB_Recover'](0)); self.assertEqual(self.w.body_writes,[])

    def test_references_must_reverse_before_original_body_recovery(self):
        self.capture(); self.assertTrue(self.e['FSU_Begin'](0))
        self.assertTrue(self.e['FSU_Stage'](0,0,100.,200.)); self.w.body_writes.clear()
        self.assertTrue(self.e['FSR_Begin'](0)); self.assertTrue(self.e['FSR_Plan'](0,0,False))
        self.assertTrue(self.e['FSR_Apply'](0)); self.change()
        self.assertFalse(self.e['FSB_Recover'](0)); self.assertEqual(self.w.body_writes,[])
        self.assertTrue(self.e['FSR_Reverse'](0))
        self.assertTrue(self.e['FSB_Recover'](0)); self.assert_original()
        self.assertTrue(self.e['FSU_Abort'](0)); self.assertTrue(self.e['FSR_Release'](0))
        self.assertTrue(self.e['FSB_Release'](0))

    def test_reentrant_recovery_release_codec_staging_and_reference_ops_blocked(self):
        self.capture(); self.change(); attempts=[]
        def hook():
            attempts.append([self.e['FSB_Recover'](0),self.e['FSB_Release'](0),self.e['FSB_Verify'](0),
                self.e['FSR_Reverse'](0),self.e['FSU_Begin'](0),self.e['FHU_Recover'](0),
                self.e['FSS_Recover'](0),self.e['FPG_Recover'](0),self.e['FSJ_Release'](0),
                self.e['FSC_Reset'](0)])
        self.w.body_hook=hook
        self.assertTrue(self.e['FSB_Recover'](0)); self.assertTrue(attempts)
        self.assertTrue(all(not any(a) for a in attempts))

    def test_other_journal_release_does_not_clear_body_guards(self):
        self.capture(); self.change(); self.assertTrue(self.e['FSB_Recover'](0))
        for name in ('FHU','FPG','FSS'): self.assertTrue(self.e[name+'_Recover'](0))
        self.assertTrue(self.e['FQR_Recover'](0,SPACER,RING_FILLER,30))
        for name in ('FSS','FHU','FPG','FQR'): self.assertTrue(self.e[name+'_Release'](0))
        self.assertFalse(self.e['FSJ_Release'](0)); self.assertFalse(self.e['FSN_Begin'](0))
        self.assertFalse(self.e['FSU_Begin'](0)); self.assertFalse(self.e['FSC_Reset'](0))
        self.assertTrue(self.e['FSB_Verify'](0)); self.assertTrue(self.e['FSB_Release'](0))
        self.assertTrue(self.e['FSJ_Release'](0))

    def test_body_release_does_not_clear_another_guard(self):
        self.capture(); self.assertTrue(self.e['FSB_Recover'](0))
        self.e['FSN_ReferenceBlocked'][0]=True; self.e['FSC_ReferenceBlocked'][0]=True
        self.assertTrue(self.e['FSB_Release'](0))
        self.assertTrue(self.e['FSN_ReferenceBlocked'][0]); self.assertTrue(self.e['FSC_ReferenceBlocked'][0])
        self.assertFalse(self.e['FSC_Reset'](0))

    def test_changed_body_after_recovery_prevents_release_until_retry(self):
        self.capture(); self.assertTrue(self.e['FSB_Recover'](0)); self.hero['mana']=1.
        self.assertFalse(self.e['FSB_Release'](0)); self.assertTrue(self.e['FSB_Recover'](0))
        self.assertTrue(self.e['FSB_Release'](0))

    def test_invalid_players_missing_journal_and_busy_are_readonly(self):
        for pid in (-1,8):
            for fn in ('FSB_Begin','FSB_Verify','FSB_Recover','FSB_Release'): self.assertFalse(self.e[fn](pid))
        self.e['FHU_State'][0]=0; self.assertFalse(self.e['FSB_Begin'](0))
        self.e['FHU_State'][0]=1; self.e['FSR_Busy'][0]=True
        self.assertFalse(self.e['FSB_Begin'](0)); self.assertEqual(self.w.body_writes,[])

    def test_zero_mana_and_boundary_coordinates_and_cooldown_are_supported(self):
        self.hero.update(x=-32768.,y=32768.,facing=0.,mana=0.,max_mana=0.)
        self.capture(); self.hero['cooldown']=0.; self.change(); self.hero['mana']=0.
        self.assertTrue(self.e['FSB_Recover'](0)); self.assert_original()
        self.assertEqual(self.hero['cooldown'],0.)

    def test_all25_distinct_units_player7_max_index_and_clear(self):
        self.hero['owner']=self.gaya['owner']=7
        self.e['udg_PlayerHero'][8]=self.hero
        self.e['udg_SpiritOfGaya'][8]=self.gaya
        self.e['udg_FreelancerHero'][8]=self.free
        self.units=[]
        for role in range(22):
            u=self.w.hero(self.e['FPG_JobRaw'](role),15)
            self.body(u,role)
            self.e['udg_JobHeroHash'][u['raw'],7]=u
            self.units.append(u)
        self.units.extend([self.free,self.gaya,self.hero])
        self.assertTrue(self.e['FSJ_Capture'](7,self.hero,self.gaya,self.house,True))
        self.assertTrue(self.e['FQR_Begin'](7,self.table))
        self.assertTrue(self.e['FPG_Begin'](7)); self.assertTrue(self.e['FHU_Begin'](7))
        self.assertTrue(self.e['FSS_Begin'](7)); self.capture(7)
        self.assertEqual(max(self.e['FSB_Unit']),199)
        self.change(); self.assertTrue(self.e['FSB_Recover'](7)); self.assert_original()
        self.assertEqual(len(self.w.body_writes),200)
        self.assertTrue(self.e['FSB_Release'](7))
        self.assertTrue(all(self.e['FSB_Unit'][i] is None for i in range(175,200)))
        self.assertEqual(self.e['FSB_State'][0],0)

    def test_writer_abort_required_and_reference_planning_stays_blocked(self):
        self.capture(); self.assertTrue(self.e['FSC_Begin'](0,0))
        self.assertFalse(self.e['FSB_Recover'](0)); self.assertEqual(self.w.body_writes,[])
        self.e['FSC_Abort'](0); self.assertTrue(self.e['FSB_Recover'](0))
        self.assertFalse(self.e['FSR_Begin'](0)); self.assertFalse(self.e['FSU_Begin'](0))
        self.assertTrue(self.e['FSB_Release'](0))

    def test_existing_reference_plan_blocks_after_body_recovery(self):
        self.capture(); self.assertTrue(self.e['FSU_Begin'](0))
        self.assertTrue(self.e['FSU_Stage'](0,0,100.,200.))
        self.assertTrue(self.e['FSR_Begin'](0)); self.assertTrue(self.e['FSR_Plan'](0,0,False))
        self.assertTrue(self.e['FSB_Recover'](0))
        self.assertFalse(self.e['FSR_Plan'](0,0,False)); self.assertFalse(self.e['FSR_Apply'](0))
        self.assertTrue(self.e['FSR_Reverse'](0)); self.assertTrue(self.e['FSU_Abort'](0))
        self.assertTrue(self.e['FSR_Release'](0)); self.assertTrue(self.e['FSB_Release'](0))

    def test_source_crlf_and_no_original_destruction_or_resurrection(self):
        raw=BODY.read_bytes(); self.assertNotIn(b'\n',raw.replace(b'\r\n',b''))
        text=raw.decode()
        for forbidden in ('RemoveUnit(', 'CreateUnit(', 'ReviveHero(', 'SetUnitOwner(', 'SetUnitFacing(', 'IssueImmediateOrder('): self.assertNotIn(forbidden,text)
        self.assertIn('BlzSetUnitFacingEx(',text)


if __name__=='__main__': unittest.main()
