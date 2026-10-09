"""Guarded actual JASS allocation/preparation/placement with native fault mocks."""
import unittest
import test_save_cargo as cargo_tests
from test_save_position import SPACER
from test_save_equipment import POLICY, RING_FILLER
from test_save_equipment import EquipmentWorld


class CargoPlacementTests(unittest.TestCase):
    def setUp(self):
        cargo_tests.CargoTests.setUp(self)
        self.w.definitions[SPACER]=[]
        self.w.definitions[RING_FILLER]=[30]
        self.w.types[RING_FILLER]=4
        # The hero recovery fixture shares a removal helper; use the item native here.
        self.e['BlzItemRemoveAbility']=lambda item,raw:EquipmentWorld.remove_ability(self.w,item,raw)

    def core(self,stage=0,pid=0,level=11): return cargo_tests.CargoTests.core(self,stage,pid,level)
    def ready(self,pid=0): return cargo_tests.CargoTests.ready(self,pid)
    def close(self,pid=0): return cargo_tests.CargoTests.close(self,pid)

    def plan(self,positions,pid=0):
        for h,s in positions:
            raw=1000+s if h==3 else 1234
            if h==3:self.w.types[raw]=4 if s==5 else s
            self.assertTrue(self.e['FCG_Plan'](pid,raw,h,s))
        self.assertTrue(self.e['FCG_StartItems'](pid))

    def stage(self,pid=0):
        return self.e['FCG_Stage'](pid,127,True,7,0x4311,0x4000,100.,200.)

    def prepare_items(self,pid=0):
        for ordinal in range(self.e['FCG_Count'][pid]):
            self.assertTrue(self.e['FCG_PrepareItem'](pid,ordinal,POLICY))

    def place(self,ordinal=0,pid=0):
        return self.e['FCG_PlaceItem'](pid,ordinal,SPACER,RING_FILLER,30)

    def allocate(self,pid=0):
        for _ in range(self.e['FCG_Count'][pid]):self.assertTrue(self.stage(pid))
        self.prepare_items(pid)

    def test_complete51_real_pipeline_and_originals_unchanged(self):
        self.ready();positions=[(h,s) for h,n in ((1,6),(2,30),(3,9),(4,6)) for s in range(n)]
        self.plan(positions);self.allocate()
        # Equipment needs temporary inventory capacity before the full bag is placed.
        order=sorted(range(51),key=lambda i:(positions[i][0]!=3,positions[i]))
        for ordinal in order:self.assertTrue(self.place(ordinal))
        self.assertTrue(self.e['FCG_Seal'](0));self.assertTrue(self.e['FCG_Verify'](0))
        self.assertTrue(self.e['FHP_Verify'](0));self.assertTrue(self.e['FSJ_Verify'](0))
        for ordinal,(h,s) in enumerate(positions):
            item=self.e['FSN_Item'][ordinal]
            self.assertEqual((item['charges'],item['binding'],float(item['life'])),(127,1,145.25))
            self.assertEqual(item['abilities'],[20,30] if h==2 else [10,20,30])
        self.close()

    def test_sparse_positions_alternate_ring_and_player7(self):
        self.ready(7);self.plan([(2,29),(4,5),(3,5),(1,3)],7);self.allocate(7)
        for ordinal in (2,3,0,1):self.assertTrue(self.place(ordinal,7))
        self.assertTrue(self.e['FCG_Seal'](7));self.assertTrue(self.e['FCG_Verify'](7))
        self.assertEqual(self.e['FSN_AuxCount'][7],0)
        self.assertIsNone(self.e['FCG_Unit'][14]['equip'][4]);self.close(7)

    def test_legacy_entries_and_internal_cores_refuse_without_permit(self):
        self.ready();self.plan([(1,0)])
        self.assertFalse(self.e['FSN_Stage'](0,1234,127,True,7,0x4311,0x4000,0.,0.))
        self.assertFalse(self.e['FSN_StageCore'](0,1234,127,True,7,0x4311,0x4000,0.,0.))
        self.assertTrue(self.stage());self.prepare_items()
        for name,args in [('FSA_Prepare',(0,0,False,POLICY)),('FSP_Place',(0,0,self.e['FCG_Unit'][0],1,0,SPACER)),
                          ('FSE_Place',(0,0,self.e['FCG_Unit'][0],0,RING_FILLER,30))]:
            self.assertFalse(self.e[name](*args))
            self.assertFalse(self.e[name+'Core'](*args))
        self.assertTrue(self.place());self.close()

    def test_plan_freezes_and_incomplete_preparation_or_placement_refuse(self):
        self.ready();self.plan([(1,0),(2,29)])
        self.assertFalse(self.e['FCG_Plan'](0,1234,1,1))
        self.assertTrue(self.stage());self.assertFalse(self.e['FCG_PrepareItem'](0,0,POLICY))
        self.assertFalse(self.place());self.assertTrue(self.stage())
        self.assertTrue(self.e['FCG_PrepareItem'](0,0,POLICY));self.assertFalse(self.place())
        self.assertFalse(self.e['FCG_Seal'](0));self.close()

    def test_creation_and_metadata_setter_failure_clean_owned_batch(self):
        for fault in ('create','charges','binding','life','owner','visible','droppable','invulnerable','pawnable'):
            with self.subTest(fault=fault):
                self.setUp();self.ready();self.plan([(1,0),(1,1)])
                self.assertTrue(self.stage())
                if fault=='create':self.w.fail_create=len(self.w.items)+1
                else:self.w.silent=fault
                self.assertFalse(self.stage());self.assertEqual(self.e['FCG_State'][0],3)
                self.assertTrue(self.e['FSJ_CargoPending'][0]);self.w.silent=None;self.w.fail_create=0;self.close()

    def test_ability_policy_and_silent_passive_removal_fail(self):
        for fault in ('policy','removal'):
            self.setUp();self.ready();self.plan([(2,29)]);self.assertTrue(self.stage())
            self.w.ignore_remove=fault=='removal'
            policy={} if fault=='policy' else POLICY
            self.assertFalse(self.e['FCG_PrepareItem'](0,0,policy));self.close()

    def test_quick_bag_equipment_native_rejections_recover(self):
        for position,fault in (((1,3),'drop'),((2,29),'add'),((3,0),'equip')):
            self.setUp();self.ready();self.plan([position]);self.allocate()
            if fault=='drop':self.w.reject_drop=True
            elif fault=='add':self.w.reject_add=self.w.adds+1
            else:self.w.reject_equip=self.w.equips+1
            self.assertFalse(self.place());self.assertEqual(self.e['FCG_State'][0],3)
            self.w.reject_drop=False;self.w.reject_add=0;self.w.reject_equip=0;self.close()

    def test_failed_filler_deletion_retains_handle_and_retries_cleanup(self):
        self.ready();self.plan([(2,29)]);self.allocate()
        def hook():
            if self.e['FSN_AuxCount'][0]:
                item=self.e['FSN_AuxItem'][0]
                if item:self.w.refuse_delete.add(id(item))
        self.w.callback=hook
        self.assertFalse(self.place());self.w.callback=None
        self.assertGreater(self.e['FSN_AuxCount'][0],0)
        self.assertFalse(self.e['FCG_Recover'](0));self.assertTrue(self.e['FSJ_CargoPending'][0])
        self.w.refuse_delete.clear();self.close()

    def test_callback_reentry_is_refused_during_each_primitive(self):
        self.ready();self.plan([(2,29)]);attempts=[]
        def hook():
            attempts.append((self.stage(),self.place(),self.e['FCG_Recover'](0),
                self.e['FSN_StageCore'](0,1234,127,True,7,0x4311,0x4000,0.,0.),
                self.e['FCG_CallDone'](0,True,False)))
        self.w.callback=hook
        self.assertTrue(self.stage());self.prepare_items();self.assertTrue(self.place())
        self.w.callback=None
        self.assertTrue(attempts);self.assertTrue(all(a==(False,False,False,False,False) for a in attempts))
        self.assertEqual(self.e['FSN_Operation'][0],0);self.assertFalse(self.e['FSN_Executing'][0]);self.close()

    def test_core_side_effect_after_placement_retains_recovery(self):
        self.ready();self.plan([(3,0)]);self.allocate()
        hero=self.e['FCG_Unit'][0]
        self.w.callback=lambda:hero.update(strength=99)
        self.assertFalse(self.place());self.w.callback=None
        self.assertEqual(self.e['FCG_State'][0],3);self.close()

    def test_post_readback_keeps_item_cleanup_locked(self):
        self.ready();self.plan([(1,0)]);attempts=[]
        def hook():
            if self.e['FSR_Busy'][0]:
                attempts.append((self.e['FSN_Abort'](0),self.stage(),self.e['FCG_Recover'](0)))
        self.w.get_hook=hook
        self.assertTrue(self.stage());self.prepare_items();self.assertTrue(self.place())
        self.w.get_hook=None
        self.assertTrue(attempts);self.assertTrue(all(a==(False,False,False) for a in attempts));self.close()

    def test_original_handle_cannot_be_deleted_as_a_filler(self):
        self.ready();self.plan([(1,0)]);self.assertTrue(self.stage())
        original=self.w.create(SPACER,0.,0.)
        self.e['FSJ_Item'][0]=original
        self.e['FSN_AuxItem'][0]=original;self.e['FSN_AuxCount'][0]=1
        calls=len(self.w.calls)
        self.assertFalse(self.e['FCG_Recover'](0));self.assertEqual(len(self.w.calls),calls)
        self.assertNotEqual(original['raw'],0)
        self.e['FSJ_Item'][0]=None;self.e['FSN_AuxItem'][0]=None;self.e['FSN_AuxCount'][0]=0
        self.close()


if __name__=='__main__':unittest.main()
