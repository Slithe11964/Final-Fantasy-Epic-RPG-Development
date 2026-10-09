"""Actual JASS cargo audit/cleanup; item placement is a detached fixture."""
import unittest
from test_save_jass import engine, SOURCE
from test_save_prepared_heroes import SKILL_GLOBALS
import test_save_prepared_heroes as prepared_tests
from test_save_units import MODULES
from test_save_references import REFERENCES
from test_save_body import BODY
from test_save_ownership import OWNERSHIP
import test_save_ownership as ownership_tests
from test_save_prepared_heroes import PREPARED
from test_save_activation import ACTIVATION
from test_save_session import SESSION_GLOBALS
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA
from test_save_life import Real32
from test_save_position import Handle

CARGO=SOURCE.with_name('Forsaken-save-cargo.j')


class CargoTests(unittest.TestCase):
    def setUp(self):
        prepared_tests.PreparedTests.setUp(self)
        old=self.e
        sources='\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in MODULES)
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+SKILL_GLOBALS+sources+
                      REFERENCES.read_text()+BODY.read_text()+OWNERSHIP.read_text()+
                      PREPARED.read_text()+ACTIVATION.read_text()+CARGO.read_text(),self.w.natives())
        self.e.update({k:v for k,v in old.items() if not callable(v)})

    def core(self,stage=0,pid=0,level=11): return prepared_tests.PreparedTests.core(self,stage,pid,level)

    def ready(self,pid=0,dormant=False):
        ownership_tests.OwnershipTests.prepare(self,pid,dormant=dormant)
        self.assertTrue(self.e['FSO_Begin'](pid));self.assertTrue(self.e['FSO_Assign'](pid))
        self.assertTrue(self.e['FHP_Begin'](pid));prepared_tests.PreparedTests.plan(self,pid)
        self.assertTrue(self.e['FHP_Apply'](pid));self.assertTrue(self.e['FCG_Begin'](pid))

    def plan(self,pid=0,full=False):
        positions=[(1,0),(2,29),(3,4),(3,5),(4,5)]
        if full:positions=[(h,s) for h,n in ((1,6),(2,30),(3,9),(4,6)) for s in range(n)]
        for h,s in positions:self.assertTrue(self.e['FCG_Plan'](pid,1234,h,s))
        return positions

    def placed_fixture(self,pid=0):
        # Future adapter output fixture, not a bypass of production staging guards.
        for ordinal in range(self.e['FCG_Count'][pid]):
            key=pid*57+ordinal;index=pid*57+ordinal
            h,s=self.e['FCG_Holder'][key],self.e['FCG_Slot'][key]
            unit=self.e['FCG_Unit'][pid*2+(h==4)]
            item=self.w.create(1234,0.,0.)
            item.update(charges=127,binding=pid+1,life=Real32(145.25),owner=pid,
                        visible=False,owned=True,invulnerable=True,droppable=True,pawnable=True)
            item['abilities']=[20,30] if h==2 else [10,20,30]
            unit[{1:'quick',2:'bag',3:'equip',4:'quick'}[h]][s]=item
            self.assertTrue(self.e['FSL_Pack'](pid,item['life']))
            for name,value in dict(Item=item,Raw=1234,Charges=127,Binding=pid+1,Flags=7,
                High=self.e['FSL_High'][pid],Low=self.e['FSL_Low'][pid],
                EffectsReady=True,EffectsStored=h==2,EffectCount=3,PlacedItem=item,
                PlacedUnit=unit,PlacedOwner=pid,PlacedHolder=h,PlacedSlot=s).items():
                self.e['FSN_'+name][index]=value
            for j,(ability,role) in enumerate(((10,1),(20,2),(30,2))):
                self.e['FSN_EffectId'][index*16+j]=ability
                self.e['FSN_EffectRole'][index*16+j]=role
        self.e['FSN_Count'][pid]=self.e['FCG_Count'][pid]
        self.e['FSN_State'][pid]=4

    def close(self,pid=0):
        self.assertTrue(self.e['FCG_Recover'](pid));self.assertTrue(self.e['FCG_Release'](pid))
        prepared_tests.PreparedTests.cleanup(self,pid)

    def test_full51_exact_cargo_and_old_originals_unchanged(self):
        self.ready();positions=self.plan(full=True);self.placed_fixture()
        self.assertTrue(self.e['FCG_Seal'](0));self.assertTrue(self.e['FCG_Verify'](0))
        self.assertTrue(self.e['FSO_Verify'](0));self.assertTrue(self.e['FHP_Verify'](0))
        self.assertEqual(len(positions),51);self.assertTrue(self.e['FSJ_Verify'](0))
        self.assertFalse(self.e['FHA_Begin'](0,0.,0.,0.,0.,0.,0.))
        self.close();self.assertTrue(all(u['raw'] for u in self.units))

    def test_invalid_plan_duplicate_house_and_player_refuse(self):
        self.ready()
        for args in ((-1,1234,1,0),(0,0,1,0),(0,1234,5,0),(0,1234,2,30),(0,1234,3,9)):
            self.assertFalse(self.e['FCG_Plan'](*args))
        self.assertTrue(self.e['FCG_Plan'](0,1234,3,4))
        self.assertFalse(self.e['FCG_Plan'](0,1234,3,4))
        self.close()

    def test_empty_target_and_player7(self):
        self.ready(7);self.assertTrue(self.e['FCG_Seal'](7))
        self.assertTrue(self.e['FCG_Verify'](7));self.close(7)

    def test_metadata_drift_refuses_verification_but_allows_cleanup(self):
        for field,value in (('charges',1),('binding',2),('life',Real32(1.)),('owner',7),
                            ('pawnable',False),('invulnerable',False),('droppable',False)):
            with self.subTest(field=field):
                self.setUp();self.ready();self.plan();self.placed_fixture()
                self.assertTrue(self.e['FCG_Seal'](0));self.e['FSN_Item'][0][field]=value
                self.assertFalse(self.e['FCG_Verify'](0));self.close()

    def test_wrong_position_unplanned_extra_and_dormant_cargo_refuse(self):
        for fault in ('position','extra','dormant'):
            self.setUp();self.ready(dormant=True);self.plan();self.placed_fixture()
            hero=self.e['FCG_Unit'][0]
            if fault=='position':hero['quick'][1],hero['quick'][0]=hero['quick'][0],None
            else:
                extra=self.w.create(9999,0.,0.)
                unit=hero if fault=='extra' else self.w.created[2]
                unit['quick'][2]=extra;extra['owned']=True
            self.assertFalse(self.e['FCG_Seal'](0))
            if fault!='position':self.w.detach(extra)
            self.close()

    def test_deletion_failure_retains_journal_and_retries(self):
        self.ready();self.plan();self.placed_fixture();self.assertTrue(self.e['FCG_Seal'](0))
        carried=self.e['FSN_Item'][0];self.w.refuse_delete.add(id(carried))
        self.assertFalse(self.e['FCG_Recover'](0));self.assertEqual(self.e['FCG_State'][0],3)
        self.assertIs(self.e['FSN_Item'][0],carried);self.assertTrue(self.e['FSJ_CargoPending'][0])
        self.assertFalse(self.e['FCG_Release'](0));self.assertFalse(self.e['FHP_Discard'](0))
        self.w.refuse_delete.clear();self.close()

    def test_foreign_cargo_is_never_deleted_and_keeps_guard(self):
        self.ready();self.plan();self.placed_fixture()
        extra=self.w.create(9999,0.,0.);self.e['FCG_Unit'][0]['quick'][3]=extra;extra['owned']=True
        self.assertFalse(self.e['FCG_Recover'](0));self.assertEqual(extra['raw'],9999)
        self.assertTrue(self.e['FSJ_CargoPending'][0]);self.w.detach(extra);self.close()

    def test_original_handle_and_duplicate_provenance_refuse_before_delete(self):
        self.ready();self.plan();self.placed_fixture()
        carried=self.e['FSN_Item'][0];original=self.w.create(8888,0.,0.)
        self.e['FSJ_Item'][0]=original
        self.e['FSN_Item'][0]=original
        self.assertFalse(self.e['FCG_Recover'](0));self.assertNotEqual(original['raw'],0)
        self.e['FSN_Item'][0]=self.e['FSN_Item'][1]
        self.assertFalse(self.e['FCG_Recover'](0))
        self.e['FSN_Item'][0]=carried;self.e['FSJ_Item'][0]=None;self.close()

    def test_core_or_owner_drift_and_pending_disposal_guards(self):
        self.ready();self.plan();self.placed_fixture()
        for name in ('FHP_Discard','FSO_Neutralize','FSR_Reverse','FSU_Abort','FSJ_Release'):
            self.assertFalse(self.e[name](0))
        self.assertFalse(self.e['FSN_Begin'](0))
        self.e['FCG_Unit'][0]['strength']+=1
        self.assertFalse(self.e['FCG_Seal'](0));self.close()

    def test_busy_reentry_during_cleanup_refuses(self):
        self.ready();self.plan();self.placed_fixture();attempts=[]
        self.w.callback=lambda:attempts.append((self.e['FCG_Recover'](0),self.e['FCG_Release'](0),self.e['FSU_Abort'](0)))
        self.assertTrue(self.e['FCG_Recover'](0));self.w.callback=None
        self.assertTrue(attempts);self.assertTrue(all(a==(False,False,False) for a in attempts))
        self.assertTrue(self.e['FCG_Release'](0));prepared_tests.PreparedTests.cleanup(self)

    def test_ability_membership_drift_and_unfinished_batch_refuse(self):
        self.ready();self.plan();self.placed_fixture()
        count=self.e['FSN_Count'][0];self.e['FSN_Count'][0]=count-1
        self.assertFalse(self.e['FCG_Seal'](0));self.e['FSN_Count'][0]=count
        self.e['FSN_Item'][1]['abilities'].append(999)
        self.e['FSN_Item'][1]['ability_objects'][999]=Handle(raw=999)
        self.assertFalse(self.e['FCG_Seal'](0));self.close()

    def test_context_change_during_cleanup_retains_guard_and_retry(self):
        self.ready();self.plan();self.placed_fixture();unit=self.e['FCG_Unit'][0]
        self.w.callback=lambda:unit.update(owner=7)
        self.assertFalse(self.e['FCG_Recover'](0));self.w.callback=None
        self.assertTrue(self.e['FSJ_CargoPending'][0]);unit['owner']=0;self.close()


if __name__=='__main__':unittest.main()
