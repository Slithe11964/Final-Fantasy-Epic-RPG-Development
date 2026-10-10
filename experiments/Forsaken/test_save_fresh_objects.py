"""Attempt allocation and cleanup use only journaled, newly created handles."""
import copy
import json
from pathlib import Path
import unittest

import test_save_fresh_plan
from build_save_probe import fresh_plan_source
from test_save_jass import engine
from test_save_life import Real32

HERE = Path(__file__).resolve().parent


class FreshObjectsTests(unittest.TestCase):
    def setUp(self):
        base = test_save_fresh_plan.FreshPlanTests()
        base.setUp()
        self.base = base
        self.units = []; self.items = []; self.removed = []
        self.fail_unit = -1; self.fail_item = -1
        self.block_item_removal = False; self.block_unit_removal = False
        self.bad_metadata = False
        def create_unit(owner, raw, x, y, facing):
            if len(self.units) == self.fail_unit: return None
            u = dict(owner=owner, raw=raw, x=x, y=y, facing=facing, quick={}, bag={}, equipment={})
            self.units.append(u); return u
        def create_item(raw, x, y):
            if len(self.items) == self.fail_item: return None
            item = dict(raw=raw, x=x, y=y, owner=15, quantity=1, binding=0, life=Real32(1), flags=0)
            self.items.append(item); return item
        def remove_item(item):
            if self.block_item_removal: return
            item['raw'] = 0; self.removed.append(item)
            for u in self.units:
                for kind in ('quick', 'bag', 'equipment'):
                    for k, value in list(u[kind].items()):
                        if value is item: del u[kind][k]
        def remove_unit(u):
            if not self.block_unit_removal:
                u['raw'] = 0; self.removed.append(u)
        def flag(i, bit, value):
            i['flags'] = (i['flags'] | bit) if value else (i['flags'] & ~bit)
        env = dict(base.e)
        env.update(CreateUnit=create_unit, CreateItem=create_item, RemoveUnit=remove_unit, RemoveItem=remove_item,
            GetUnitX=lambda u: u.get('x', 12), GetUnitY=lambda u: u.get('y', 34), GetUnitFacing=lambda u: u.get('facing', 90),
            BlzSetHeroProperName=lambda u, name: u.__setitem__('name', name),
            GetItemPlayer=lambda i: i['owner'], SetItemPlayer=lambda i, p, c: i.__setitem__('owner', p),
            SetItemCharges=lambda i, q: i.__setitem__('quantity', q+1 if self.bad_metadata else q),
            SetItemUserData=lambda i, b: i.__setitem__('binding', b),
            SetWidgetLife=lambda i, life: i.__setitem__('life', Real32(life)),
            SetItemInvulnerable=lambda i, v: flag(i, 1, v), SetItemDroppable=lambda i, v: flag(i, 2, v),
            SetItemPawnable=lambda i, v: flag(i, 4, v))
        catalog = json.loads((HERE.parents[1]/'release/Forsaken/gear-slots-BS.json').read_text())
        source = (HERE/'Forsaken-save-life.j').read_text()+'\n'+(HERE/'Forsaken-save-capture.j').read_text()+'\n'+fresh_plan_source(base.fixture.registry, catalog)+'\n'+(HERE/'Forsaken-save-fresh-objects.j').read_text()
        self.e = engine(source, env)
        self.e['FFP_Init']()

    def plan(self):
        self.assertTrue(self.e['FFP_Build'](0, self.base.encoded, True), self.e['FFP_Error'][0])

    def allocate(self):
        return self.e['FFN_Allocate'](0, True)

    def assert_originals(self, before):
        self.assertEqual(before, (self.base.hero, self.base.gaya, self.base.house, self.base.fixture.job_table,
            self.base.fixture.level_table, self.base.fixture.techs, self.base.fixture.title_forces))
        self.assertFalse(self.e['udg_HasLoadedCode'][0])

    def original_snapshot(self):
        return copy.deepcopy((self.base.hero, self.base.gaya, self.base.house, self.base.fixture.job_table,
            self.base.fixture.level_table, self.base.fixture.techs, self.base.fixture.title_forces))

    def test_real_owned_units_and_exact_item_metadata(self):
        before = self.original_snapshot()
        self.plan(); self.assertTrue(self.allocate(), self.e['FFN_Error'][0])
        self.assertEqual([u['raw'] for u in self.units], ['H002', 'H01D', 'H02L'])
        self.assertTrue(all(u['owner'] == 0 for u in self.units))
        self.assertEqual([i['quantity'] for i in self.items], [0, 120, 0, 7, 127, 2])
        self.assertEqual([i['binding'] for i in self.items], [1, 1, 1, 1, 1, 0])
        for ordinal in range(6): self.assertTrue(self.e['FFN_MetadataMatches'](0, ordinal))
        self.assertEqual(self.e['FFN_State'][0], 2)
        self.assertTrue(self.e['FFP_Locked'][0])
        self.assert_originals(before)
        self.assertTrue(self.e['FFN_Cleanup'](0))
        self.assertTrue(all(i['raw'] == 0 for i in self.items+self.units))
        self.assertFalse(self.e['FFP_Locked'][0]); self.assertEqual(self.e['FFN_Count'][0], 0)
        self.assert_originals(before)

    def test_failure_at_every_unit_and_item_allocation_allows_retry(self):
        before = self.original_snapshot()
        for ordinal in range(3):
            self.units.clear(); self.items.clear(); self.fail_unit = ordinal
            self.plan(); self.assertFalse(self.allocate())
            self.assertTrue(all(u['raw'] == 0 for u in self.units))
            self.assertEqual(self.e['FFN_State'][0], 0)
            self.assert_originals(before)
        self.fail_unit = -1
        for ordinal in range(6):
            self.units.clear(); self.items.clear(); self.fail_item = ordinal
            self.plan(); self.assertFalse(self.allocate())
            self.assertTrue(all(i['raw'] == 0 for i in self.units+self.items))
            self.assertFalse(self.e['FFP_Locked'][0]); self.assert_originals(before)
        self.fail_item = -1; self.plan(); self.assertTrue(self.allocate())

    def test_metadata_mismatch_cleans_every_created_handle(self):
        self.bad_metadata = True; self.plan(); self.assertFalse(self.allocate())
        self.assertIn('metadata', self.e['FFN_Error'][0])
        self.assertTrue(all(i['raw'] == 0 for i in self.units+self.items))
        self.bad_metadata = False; self.plan(); self.assertTrue(self.allocate())

    def test_failed_item_deletion_retains_tracking_and_blocks_duplicate_attempt(self):
        self.plan(); self.assertTrue(self.allocate())
        self.block_item_removal = True
        self.assertFalse(self.e['FFN_Cleanup'](0))
        tracked = self.e['FFN_Item'][0]
        self.assertIs(tracked, self.items[0]); self.assertTrue(self.e['FFP_Locked'][0])
        self.assertFalse(self.e['FFP_Build'](0, self.base.encoded, True))
        self.e['FFP_Clear'](0)
        self.assertEqual(self.e['FFP_Count'][0], 6)
        self.assertFalse(self.allocate()); self.assertEqual(len(self.items), 6)
        self.block_item_removal = False
        self.assertTrue(self.e['FFN_Cleanup'](0)); self.plan(); self.assertTrue(self.allocate())

    def test_failed_unit_deletion_retains_tracking_until_retry(self):
        self.plan(); self.assertTrue(self.allocate())
        self.block_unit_removal = True
        self.assertFalse(self.e['FFN_Cleanup'](0))
        self.assertIs(self.e['FFN_Unit'][0], self.units[0])
        self.assertFalse(self.allocate())
        self.block_unit_removal = False
        self.assertTrue(self.e['FFN_Cleanup'](0))

    def test_cleanup_does_not_delete_unrelated_items_on_an_owned_unit(self):
        self.plan(); self.assertTrue(self.allocate())
        unrelated = dict(raw='unrelated')
        self.units[0]['bag'][29] = unrelated
        self.assertFalse(self.e['FFN_Cleanup'](0))
        self.assertEqual(unrelated['raw'], 'unrelated')
        self.assertNotEqual(self.units[0]['raw'], 0)
        del self.units[0]['bag'][29]
        self.assertTrue(self.e['FFN_Cleanup'](0))
        self.assertEqual(unrelated['raw'], 'unrelated')

    def test_window_closes_after_plan_without_allocating_anything(self):
        self.plan()
        self.assertFalse(self.e['FFN_Allocate'](0, False))
        self.assertEqual(self.units+self.items, [])
        self.assertFalse(self.e['FFP_Locked'][0])

    def test_allocation_cannot_run_twice_or_append_duplicate_items(self):
        self.plan(); self.assertTrue(self.allocate())
        self.assertFalse(self.allocate())
        self.assertFalse(self.e['FFN_CreateItem'](0, 0))
        self.assertFalse(self.e['FFN_CreateUnit'](0, 0, 'H002', self.base.hero))
        self.assertEqual(len(self.items), 6); self.assertEqual(len(self.units), 3)


if __name__ == '__main__':
    unittest.main()
