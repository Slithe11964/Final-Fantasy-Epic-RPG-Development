"""Actual JASS item journal and placement primitives; mocked inventory natives."""
import unittest

from test_save_jass import engine, SOURCE
from test_save_life import LIFE, Real32
from test_save_native import NATIVE, World

JOURNAL = SOURCE.with_name('Forsaken-save-journal.j')
POSITION = SOURCE.with_name('Forsaken-save-position.j')
SPACER = 777


class Handle(dict):
    def __eq__(self, other): return self is other
    def __ne__(self, other): return self is not other


class InventoryWorld(World):
    def __init__(self):
        super().__init__()
        self.units = []
        self.adds = 0
        self.reject_add = 0
        self.reject_drop = False
        self.get_hook = None

    def unit(self, owner=0, bag=0):
        unit = Handle(owner=owner, raw=1, quick=[None]*6, bag=[None]*bag, equip=[None]*9)
        self.units.append(unit)
        return unit

    def create(self, raw, x, y):
        item = super().create(raw, x, y)
        if item is None: return None
        handle = Handle(item)
        self.items[-1] = handle
        return handle

    def detach(self, item):
        for unit in self.units:
            for kind in ['quick', 'bag', 'equip']:
                for slot, candidate in enumerate(unit[kind]):
                    if candidate is item: unit[kind][slot] = None
        item['owned'] = False

    def remove(self, item):
        if id(item) not in self.refuse_delete: self.detach(item)
        super().remove(item)

    def add(self, unit, item):
        self.calls.append(('add', id(item)))
        self.adds += 1
        if self.callback: self.callback()
        if self.adds == self.reject_add: return True  # Silent rejection.
        for kind in ['quick', 'bag']:
            for slot, candidate in enumerate(unit[kind]):
                if candidate is None:
                    unit[kind][slot] = item
                    item['owned'] = True
                    return True
        return False

    def drop_slot(self, unit, item, slot):
        self.calls.append(('drop', id(item)))
        if self.reject_drop: return True
        if unit['quick'][slot] is not None: return False
        self.detach(item)
        unit['quick'][slot] = item
        item['owned'] = True
        return True

    def at(self, unit, kind, slot):
        if self.get_hook: self.get_hook()
        if unit is None: return None
        assert 0 <= slot < len(unit[kind]), (kind, slot)
        return unit[kind][slot]

    def natives(self):
        env = super().natives()
        env.update(GetUnitTypeId=lambda u: u['raw'] if u else 0,
            GetOwningPlayer=lambda u: u['owner'] if u else None,
            UnitExtendedInventorySize=lambda u: len(u['bag']),
            UnitItemInSlot=lambda u, s: self.at(u, 'quick', s),
            UnitItemInBagSlot=lambda u, s: self.at(u, 'bag', s),
            UnitItemInEquipmentSlot=lambda u, s: self.at(u, 'equip', s),
            ConvertLoadoutSlot=lambda s: s, GetUnitX=lambda u: 0., GetUnitY=lambda u: 0.,
            UnitAddItem=self.add, UnitDropItemSlot=self.drop_slot)
        return env


class PositionTests(unittest.TestCase):
    def setUp(self):
        self.w = InventoryWorld()
        self.e = engine('\n'.join(p.read_text() for p in [LIFE, NATIVE, JOURNAL, POSITION]), self.w.natives())
        self.hero, self.gaya, self.house = self.w.unit(bag=30), self.w.unit(), self.w.unit(owner=9)

    def original(self, unit, kind, slot, raw=1234):
        item = self.w.create(raw, 0., 0.)
        item.update(charges=127, binding=3, life=Real32(145.25), owner=9, owned=True,
                    visible=False, invulnerable=True, droppable=False, pawnable=True)
        unit[kind][slot] = item
        return item

    def capture(self, verified=True):
        return self.e['FSJ_Capture'](0, self.hero, self.gaya, self.house, verified)

    def stage(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.assertTrue(self.e['FSN_Stage'](0, 1235, 127, True, 7, 0x4311, 0x4000, 0., 0.))  # 145.25.
        return self.e['FSN_Item'][0]

    def place(self, kind, slot, unit=None):
        unit = unit or {1:self.hero, 2:self.hero, 4:self.gaya, 5:self.house}.get(kind, self.hero)
        return self.e['FSP_Place'](0, 0, unit, kind, slot, SPACER)

    def assert_no_allocations(self):
        self.assertEqual(self.e['FSN_Count'][0], 0)
        self.assertEqual(self.e['FSN_AuxCount'][0], 0)
        self.assertTrue(all(self.e['FSN_AuxItem'][s] is None for s in range(36)))
        self.assertIsNone(self.e['FSN_PlacedItem'][0])
        self.assertIsNone(self.e['FSN_PlacedUnit'][0])

    def test_full_57_journal_all_players_read_only_and_both_rings(self):
        for pid in range(8):
            hero, gaya, house = self.w.unit(pid, 30), self.w.unit(pid), self.w.unit(9)
            expected = []
            for unit, kind, size in [(hero,'quick',6), (hero,'bag',30), (hero,'equip',9), (gaya,'quick',6), (house,'quick',6)]:
                for slot in range(size): expected.append(self.original(unit,kind,slot,1000+len(expected)))
            before = [dict(i) for i in expected]
            self.w.calls.clear()
            self.assertTrue(self.e['FSJ_Capture'](pid, hero, gaya, house, True))
            self.assertTrue(self.e['FSJ_Verify'](pid))
            self.assertEqual(self.w.calls, [])
            for position, item in enumerate(expected):
                self.assertIs(self.e['FSJ_Item'][pid*57+position], item)
                self.assertEqual(dict(item), before[position])
                self.assertEqual(self.e['FSJ_Owner'][pid*57+position], 9)
            self.assertIs(self.e['FSJ_Item'][pid*57+40], hero['equip'][4])
            self.assertIs(self.e['FSJ_Item'][pid*57+41], hero['equip'][5])
            self.assertTrue(self.e['FSJ_Release'](pid))

    def test_sparse_journal_retains_every_empty_position(self):
        for position in range(57):
            with self.subTest(position=position):
                self.setUp()
                if position<6: unit,kind,slot=self.hero,'quick',position
                elif position<36: unit,kind,slot=self.hero,'bag',position-6
                elif position<45: unit,kind,slot=self.hero,'equip',position-36
                elif position<51: unit,kind,slot=self.gaya,'quick',position-45
                else: unit,kind,slot=self.house,'quick',position-51
                kept=self.original(unit,kind,slot)
                self.assertTrue(self.capture())
                for other in range(57): self.assertIs(self.e['FSJ_Item'][other], kept if other==position else None)
                self.assertTrue(self.e['FSJ_Verify'](0))

    def test_unverified_drop_and_invalid_contexts_refuse_without_mutation(self):
        self.assertFalse(self.capture(False))
        for pid in [-1,8,2147483647]:
            self.assertFalse(self.e['FSJ_Capture'](pid,self.hero,self.gaya,self.house,True))
            self.assertFalse(self.e['FSJ_Verify'](pid))
            self.assertFalse(self.e['FSJ_Release'](pid))
        for size in [29,31]:
            invalid=self.w.unit(bag=size)
            self.assertFalse(self.e['FSJ_Capture'](0,invalid,self.gaya,self.house,True))
        self.assertFalse(self.e['FSJ_Capture'](0,self.hero,self.hero,self.house,True))
        self.assertFalse(self.e['FSJ_Capture'](0,self.hero,self.w.unit(owner=1),self.house,True))
        self.assertEqual(self.w.calls, [])

    def test_duplicate_handle_refuses_and_releases_scratch(self):
        kept=self.original(self.hero,'quick',0)
        self.hero['bag'][29]=kept
        self.assertFalse(self.capture())
        self.assertFalse(self.e['FSJ_Ready'][0])
        for slot in range(57): self.assertIsNone(self.e['FSJ_Item'][456+slot])

    def test_capture_rechecks_empty_positions_and_unit_owners(self):
        kept=self.original(self.hero,'quick',0)
        calls=0
        def move_during_scan():
            nonlocal calls
            calls+=1
            if calls==58:
                self.hero['quick'][0]=None
                self.hero['bag'][29]=kept
        self.w.get_hook=move_during_scan
        self.assertFalse(self.capture())
        self.assertFalse(self.e['FSJ_Ready'][0])
        self.w.get_hook=lambda: self.house.update(owner=8)
        self.assertFalse(self.capture())

    def test_metadata_or_position_change_blocks_verification_and_release(self):
        changes=dict(charges=126,binding=4,life=Real32(145.),owner=8,visible=True,
                     invulnerable=False,droppable=True,pawnable=False,raw=2222,owned=False)
        for field,value in changes.items():
            self.setUp()
            kept=self.original(self.hero,'bag',29)
            self.assertTrue(self.capture())
            previous=kept[field]
            kept[field]=value
            self.assertFalse(self.e['FSJ_Verify'](0),field)
            self.assertFalse(self.e['FSJ_Release'](0),field)
            self.assertIs(self.e['FSJ_Item'][35],kept)
            kept[field]=previous
            self.assertTrue(self.e['FSJ_Release'](0))

    def test_cannot_replace_ready_journal(self):
        kept=self.original(self.hero,'equip',5)
        self.assertTrue(self.capture())
        self.assertFalse(self.capture())
        self.assertIs(self.e['FSJ_Item'][41],kept)
        self.assertTrue(self.e['FSJ_Release'](0))
        self.assertTrue(self.capture())

    def test_exact_all_48_storage_positions_with_empty_earlier_slots(self):
        for kind,size in [(1,6),(2,30),(4,6),(5,6)]:
            for slot in range(size):
                with self.subTest(kind=kind,slot=slot):
                    self.setUp()
                    kept=self.stage()
                    self.assertTrue(self.place(kind,slot))
                    unit={1:self.hero,2:self.hero,4:self.gaya,5:self.house}[kind]
                    self.assertIs(unit['bag' if kind==2 else 'quick'][slot],kept)
                    self.assertTrue(self.e['FSP_Verify'](0))
                    self.assertEqual(self.e['FSN_State'][0],4)
                    self.assertEqual(self.e['FSN_AuxCount'][0],0)
                    self.assertTrue(all(i['raw']==0 for i in self.w.items if i is not kept))
                    self.assertTrue(self.e['FSN_Abort'](0))
                    self.assert_no_allocations()

    def test_occupied_target_rejects_before_inventory_mutation(self):
        original=self.original(self.hero,'bag',29)
        before=dict(original)
        self.stage()
        self.w.calls.clear()
        self.assertFalse(self.place(2,29))
        self.assertEqual(dict(original),before)
        self.assertIs(self.hero['bag'][29],original)
        self.assertFalse(any(c[0]=='add' for c in self.w.calls))
        self.assert_no_allocations()

    def test_complete_48_item_storage_batch_and_player_isolation(self):
        for pid in [0,7]:
            hero,gaya,house=self.w.unit(pid,30),self.w.unit(pid),self.w.unit(9)
            self.assertTrue(self.e['FSN_Begin'](pid))
            for ordinal in range(48):
                self.assertTrue(self.e['FSN_Stage'](pid,1000+ordinal,127,ordinal%2==1,ordinal%8,0x4311,0x4000,0.,0.))
            ordinal=0
            for unit,kind,size in [(hero,1,6),(hero,2,30),(gaya,4,6),(house,5,6)]:
                for slot in range(size):
                    self.assertTrue(self.e['FSP_Place'](pid,ordinal,unit,kind,slot,SPACER))
                    ordinal+=1
            self.assertTrue(self.e['FSP_Verify'](pid))
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assertTrue(self.e['FSP_Verify'](7))
        self.assertTrue(self.e['FSN_Abort'](7))

    def test_sparse_neighbors_and_original_journal_survive_placement_abort(self):
        originals=[self.original(self.hero,'quick',4,10),self.original(self.hero,'bag',7,11),self.original(self.hero,'equip',5,12)]
        before=[dict(i) for i in originals]
        self.assertTrue(self.capture())
        self.stage()
        self.assertTrue(self.place(2,29))
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assertTrue(self.e['FSJ_Verify'](0))
        self.assertEqual([dict(i) for i in originals],before)

    def test_silent_add_failure_at_all_36_filler_and_item_positions(self):
        for position in range(1,37):
            self.setUp()
            self.stage()
            self.w.reject_add=position
            self.assertFalse(self.place(2,29))
            self.assert_no_allocations()
            self.assertTrue(all(i['raw']==0 for i in self.w.items))

    def test_filler_creation_failure_at_every_position_is_owned_cleanup(self):
        for position in range(1,36):
            self.setUp()
            self.stage()
            self.w.fail_create=position+1
            self.assertFalse(self.place(2,29))
            self.assert_no_allocations()
            self.assertTrue(all(i['raw']==0 for i in self.w.items))

    def test_failed_filler_deletion_is_retained_for_abort_retry(self):
        self.stage()
        create=self.w.create
        def refuse_filler(raw,x,y):
            item=create(raw,x,y)
            if raw==SPACER: self.w.refuse_delete.add(id(item))
            return item
        self.e['CreateItem']=refuse_filler
        self.assertFalse(self.place(2,0))
        self.assertEqual(self.e['FSN_State'][0],3)
        self.assertEqual(self.e['FSN_AuxCount'][0],6)
        self.assertFalse(self.e['FSN_Begin'](0))
        self.w.refuse_delete.clear()
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assert_no_allocations()

    def test_quick_slot_silent_move_failure_and_equipment_are_refused(self):
        self.stage()
        self.w.reject_drop=True
        self.assertFalse(self.place(1,5))
        self.assert_no_allocations()
        self.setUp()
        ring=self.original(self.hero,'equip',4)
        self.stage()
        self.w.calls.clear()
        self.assertFalse(self.place(3,5))
        self.assertIs(self.hero['equip'][4],ring)
        self.assertFalse(any(c[0]=='add' for c in self.w.calls))

    def test_placed_readback_detects_external_move_or_metadata_change(self):
        for mutate in ['position','metadata']:
            self.setUp()
            kept=self.stage()
            self.assertTrue(self.place(2,29))
            if mutate=='position':
                self.hero['bag'][29]=None
                self.hero['bag'][0]=kept
            else: kept['charges']=126
            self.assertFalse(self.e['FSP_Verify'](0))
            self.assert_no_allocations()

    def test_reentrant_operations_are_refused_during_placement(self):
        self.stage()
        reentries=[]
        def callback():
            reentries.extend([self.e['FSN_Abort'](0),self.e['FSP_Verify'](0),self.place(1,5)])
        self.w.callback=callback
        self.assertTrue(self.place(2,29))
        self.assertTrue(reentries)
        self.assertFalse(any(reentries))
        self.w.callback=None
        self.assertTrue(self.e['FSN_Abort'](0))

    def test_placed_unit_owner_type_or_capacity_change_refuses_readback(self):
        for change in ['owner','raw','bag']:
            self.setUp()
            self.stage()
            self.assertTrue(self.place(2,29))
            if change=='bag': self.hero['bag'].append(None)
            else: self.hero[change]=1 if change=='owner' else 0
            self.assertFalse(self.e['FSP_Verify'](0))
            self.assert_no_allocations()

    def test_new_sources_crlf_no_mutation_in_journal_no_equipment_in_placement(self):
        for path in [JOURNAL,POSITION]: self.assertNotIn(b'\n',path.read_bytes().replace(b'\r\n',b''))
        for name in ['CreateItem(', 'RemoveItem(', 'SetItem', 'UnitAddItem(', 'UnitRemoveItem(', 'UnitEquipItem(']:
            self.assertNotIn(name,JOURNAL.read_text())
        for name in ['call UnitEquipItem(', 'call UnitUnequipItem(', 'call UnitAddItemToSlotById(']:
            self.assertNotIn(name,POSITION.read_text())


if __name__=='__main__': unittest.main()
