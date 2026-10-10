"""All57 saved inventory positions, including separately owned neutral house."""
import unittest
import test_save_house as house
import test_save_inventory_profile as profile
from test_save_position import SPACER
from test_save_equipment import POLICY,RING_FILLER

class HouseCargoTests(house.HouseTests):
    # Inherited house lifecycle checks also run against the connected route.
    def start(self,rows,pid=0):
        self.ready(pid);self.assertTrue(self.stage(pid))
        return profile.InventoryProfileTests.begin(self,rows,pid)
    def gear_id(self,slot):return profile.InventoryProfileTests.gear_id(self,slot)
    def apply(self,pid=0):return profile.InventoryProfileTests.apply(self,pid)
    def release_profile(self,pid=0):
        self.assertTrue(self.e['FIP_Recover'](pid));self.assertTrue(self.e['FIP_Release'](pid));self.clean(pid)

    def test_complete57_profile_and_house_owner_metadata(self):
        rows=[];names=('Head','Chest','Gloves','Boots','Ring','Ring','Primary','Offhand','Trinket')
        for h,n in ((1,6),(2,30),(3,9),(4,6),(5,6)):
            for s in range(n):
                identity=self.gear_id(names[s]) if h==3 else self.gear_id('Boots')
                rows.append(profile.record(identity,h,s,len(rows)+1,127,True))
        source=self.start(rows,7);original=dict(self.house);self.apply(7)
        self.assertEqual(self.e['FIP_Count'][7],57);self.assertTrue(self.e['FHS_Verify'](7))
        target=self.e['FHS_Unit'][7]
        for s in range(6):
            item=target['quick'][s];self.assertEqual((item['binding'],item['charges'],item['owner']),(8,127,7))
            self.assertEqual(self.e['FSN_PlacedOwner'][7*57+51+s],15)
        self.assertEqual(self.e['FIP_Code'][7],source);self.assertEqual(dict(self.house),original)
        self.assertFalse(self.e['FHS_Recover'](7));self.release_profile(7)
        self.assertEqual(target['raw'],0);self.assertEqual(dict(self.house),original)

    def test_sparse_house_preserves_slots_and_quantities(self):
        self.start([profile.record(self.gear_id('Boots'),5,5,quantity=0),
                    profile.record(self.gear_id('Boots'),5,2,ordinal=2,quantity=120)])
        self.apply();target=self.e['FHS_Unit'][0]
        self.assertEqual([i['charges'] if i else None for i in target['quick']],[None,None,120,None,None,0])
        self.release_profile()

    def test_house_placement_failure_retains_originals_and_retry(self):
        self.start([profile.record(self.gear_id('Boots'),5,5)]);self.assertTrue(self.e['FIP_StageNext'](0))
        self.assertTrue(self.e['FIP_PrepareNext'](0,POLICY));self.w.reject_add=self.w.adds+6
        item=self.e['FSN_Item'][0];self.w.refuse_delete.add(id(item))
        self.assertFalse(self.e['FIP_PlaceNext'](0,SPACER,RING_FILLER,30));self.w.reject_add=0
        self.assertFalse(self.e['FIP_Recover'](0));self.assertFalse(self.e['FHS_Recover'](0))
        self.w.refuse_delete.clear();self.release_profile()

    def test_unexpected_house_item_blocks_seal_and_cleanup(self):
        self.start([profile.record(self.gear_id('Boots'),5,5)]);self.apply()
        target=self.e['FHS_Unit'][0];foreign=self.w.create(SPACER,0,0);target['quick'][0]=foreign
        self.assertFalse(self.e['FCG_Verify'](0));self.assertFalse(self.e['FHS_Verify'](0))
        self.assertFalse(self.e['FIP_Recover'](0));self.assertNotEqual(foreign['raw'],0)
        target['quick'][0]=None;self.release_profile()

    def test_dormant_house_record_keeps_code_without_materialization(self):
        source=self.start([profile.record(1000,5,5)])
        self.assertEqual(self.e['FIP_Count'][0],0);self.assertEqual(self.e['FIP_Dormant'][0],1)
        self.assertTrue(self.e['FIP_Seal'](0));self.assertEqual(self.e['FIP_Code'][0],source)
        self.assertTrue(self.e['FHS_Verify'](0));self.release_profile()

if __name__=='__main__':unittest.main()
