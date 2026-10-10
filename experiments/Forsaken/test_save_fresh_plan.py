"""Actual detached preflight rejects unsafe loads before any gameplay mutation."""
import copy
import json
from pathlib import Path
import unittest

import save_vnext as codec
from build_save_probe import fresh_plan_bindings, fresh_plan_source
import test_save_capture
from test_save_jass import JassArray, engine

HERE = Path(__file__).resolve().parent


class FreshPlanTests(unittest.TestCase):
    def setUp(self):
        fixture = test_save_capture.CaptureTests()
        fixture.setUp(); fixture.start(); fixture.finish()
        self.assertTrue(fixture.e['FRC_Ready'][0])
        self.encoded = fixture.e['FRC_Result'][0]
        self.fixture = fixture
        self.hero = dict(raw='H002', owner=0, level=1, quick={}, bag={}, equipment={})
        self.gaya = dict(raw='H03N', owner=0, level=1, quick={})
        self.house = dict(raw='h006', owner=0, quick={})
        fixture.players[1] = self.hero; fixture.gayas[1] = self.gaya; fixture.houses[1] = self.house
        fixture.frees[1] = None
        fixture.job_table.clear(); fixture.job_table[('H002', 0)] = self.hero
        fixture.level_table.clear()
        env = dict(fixture.e)
        env.update(GetOwningPlayer=lambda u: u['owner'], udg_PlayingPlayers={0},
            udg_HardcoreOff=True, udg_HasLoadedCode=JassArray(lambda: False), udg_Difficulty=2)
        catalog = json.loads((HERE.parents[1]/'release/Forsaken/gear-slots-BS.json').read_text())
        source = (HERE/'Forsaken-save-life.j').read_text()+'\n'+(HERE/'Forsaken-save-capture.j').read_text()+'\n'+fresh_plan_source(fixture.registry, catalog)
        self.e = engine(source, env)
        self.e['FFP_Init']()

    def build(self, encoded=None, window=True):
        return self.e['FFP_Build'](0, self.encoded if encoded is None else encoded, window)

    def change(self, sid, transform, version=None, required=None):
        envelope = codec.decode(self.encoded)
        sections = tuple(codec.Section(s.id, s.version if version is None else version,
            s.required if required is None else required, transform(s.payload)) if s.id == sid else s
            for s in envelope.sections)
        return codec.encode(codec.Envelope(envelope.account_hash, sections))

    def test_exact_detached_plan_and_no_gameplay_writes(self):
        before = copy.deepcopy((self.hero, self.gaya, self.house, self.fixture.job_table,
            self.fixture.level_table, self.fixture.techs, self.fixture.title_forces, self.fixture.armory_forces))
        self.assertTrue(self.build(), self.e['FFP_Error'][0])
        self.assertTrue(self.e['FFP_Recheck'](0, True))
        self.assertEqual(self.e['FFP_Count'][0], 6)
        self.assertEqual([self.e['FFP_Raw'][i] for i in range(6)], ['phea', 'f003', 'f003', 'phea', 'pman', 'pman'])
        self.assertEqual([self.e['FFP_Slot'][i] for i in range(6)], [0, 29, 3, 5, 0, 3])
        self.assertEqual([self.e['FFP_Quantity'][i] for i in range(6)], [0, 120, 0, 7, 127, 2])
        self.assertEqual(self.e['FFP_Values'][(2, 11)], 51)
        self.assertEqual(self.e['FFP_Values'][(10, 15)], 3)
        self.assertEqual(before, (self.hero, self.gaya, self.house, self.fixture.job_table,
            self.fixture.level_table, self.fixture.techs, self.fixture.title_forces, self.fixture.armory_forces))
        self.assertFalse(self.e['udg_HasLoadedCode'][0])

    def test_failed_profile_clears_plan_and_allows_retry(self):
        self.assertTrue(self.build())
        self.assertFalse(self.build(self.encoded[:-1]))
        self.assertFalse(self.e['FFP_Ready'][0]); self.assertEqual(self.e['FFP_Count'][0], 0)
        self.assertEqual(self.e['FFP_Values'], {})
        self.assertFalse(self.e['FSC_Busy'][0]); self.assertTrue(self.build())

    def test_closed_window_hardcore_and_one_load(self):
        self.assertFalse(self.build(window=False))
        self.e['udg_HardcoreOff'] = False; self.assertFalse(self.build())
        self.e['udg_HardcoreOff'] = True
        self.e['udg_HasLoadedCode'][0] = True; self.assertFalse(self.build())
        self.e['udg_HasLoadedCode'][0] = False; self.assertTrue(self.build())
        self.assertFalse(self.e['FFP_Recheck'](0, False)); self.assertFalse(self.e['FFP_Ready'][0])

    def test_no_unrelated_items_replaced_in_any_inventory(self):
        for unit, kind, slot in ((self.hero, 'quick', 0), (self.hero, 'bag', 29),
            (self.hero, 'equipment', 8), (self.gaya, 'quick', 5), (self.house, 'quick', 5)):
            unit[kind][slot] = {'unrelated': True}
            self.assertFalse(self.build()); self.assertIn('occupied', self.e['FFP_Error'][0])
            self.assertEqual(unit[kind][slot], {'unrelated': True})
            unit[kind].clear()
        self.assertTrue(self.build())

    def test_context_changed_between_validation_and_creation(self):
        for mutate, restore in (
            (lambda: self.e.__setitem__('udg_Difficulty', 3), lambda: self.e.__setitem__('udg_Difficulty', 2)),
            (lambda: self.fixture.names.__setitem__(1, 'MIN'), lambda: self.fixture.names.__setitem__(1, 'Fixture#1234')),
            (lambda: self.fixture.houses.__setitem__(1, dict(self.house, changed=True)), lambda: self.fixture.houses.__setitem__(1, self.house)),
            (lambda: self.house['quick'].__setitem__(0, {}), lambda: self.house['quick'].clear()),
            (lambda: self.e['udg_HasLoadedCode'].__setitem__(0, True), lambda: self.e['udg_HasLoadedCode'].__setitem__(0, False))):
            self.assertTrue(self.build()); mutate()
            self.assertFalse(self.e['FFP_Recheck'](0, True)); self.assertFalse(self.e['FFP_Ready'][0])
            restore()

    def test_engine_cap_and_unknown_job_identity(self):
        def jobs(text, level=100):
            return codec.uint(22)+''.join(codec.uint(i)+codec.uint(level)+codec.uint(2) for i in range(1, 23))
        self.assertFalse(self.build(self.change(2, jobs)))
        self.assertIn('cap99', self.e['FFP_Error'][0])
        def extra(text): return codec.uint(23)+text[1:]+codec.uint(23)+codec.uint(1)+codec.uint(0)
        self.assertFalse(self.build(self.change(2, extra)))
        self.assertTrue(self.build())

    def test_unknown_optional_sections_not_silently_preserved(self):
        env = codec.decode(self.encoded)
        encoded = codec.encode(codec.Envelope(env.account_hash, env.sections+(codec.Section(99, 1, False, 'A'),)))
        self.assertFalse(self.build(encoded))
        self.assertTrue(self.build())

    def test_unknown_item_and_wrong_equipment_position(self):
        records = codec.read_inventory(next(s.payload for s in codec.decode(self.encoded).sections if s.id == 1))[0]
        row = records[2]
        for identity, slot in ((99999, 3), (row[1], 2)):
            changed = list(records); changed[2] = (row[0], identity, row[2], slot, *row[4:])
            self.assertFalse(self.build(self.change(1, lambda _: codec.inventory(changed))))
        self.assertTrue(self.build())

    def test_saved_mode_must_match_game(self):
        self.e['udg_SpeedrunMode'] = True; self.assertFalse(self.build())
        self.assertIn('Speedrun', self.e['FFP_Error'][0])
        self.e['udg_SpeedrunMode'] = False; self.e['udg_Difficulty'] = 3
        self.assertFalse(self.build()); self.assertIn('difficulty', self.e['FFP_Error'][0])

    def test_codec_accepted_profile_is_not_replaced_by_preflight(self):
        self.assertTrue(self.e['FSC_Decode'](0, self.encoded, self.e['FRC_Account'](0), True))
        before = self.e['FSC_Reencode'](0)
        self.assertTrue(self.build()); self.assertFalse(self.build(self.encoded[:-1]))
        self.assertEqual(self.e['FSC_Reencode'](0), before)

    def test_unknown_flags_metadata_and_zero_gaya_are_rejected(self):
        for sid, identity in ((7, 101), (8, 359)):
            encoded = self.change(sid, lambda text: codec.pairs(codec.read_pairs(text)+[(identity, 1)]))
            self.assertFalse(self.build(encoded))
        encoded = self.change(5, lambda text: codec.pairs([(i, 0 if i == 2 else v) for i, v in codec.read_pairs(text)]))
        self.assertFalse(self.build(encoded))
        records = codec.read_inventory(next(s.payload for s in codec.decode(self.encoded).sections if s.id == 1))[0]
        row = records[0]
        records[0] = (*row[:6], row[6]+((99, False, 'A'),))
        self.assertFalse(self.build(self.change(1, lambda _: codec.inventory(records))))
        self.assertTrue(self.build())

    def test_two_players_keep_independent_detached_plans(self):
        self.e['udg_PlayingPlayers'].add(1)
        hero = dict(self.hero, owner=1)
        self.fixture.players[2] = hero
        self.fixture.gayas[2] = dict(self.gaya, owner=1)
        self.fixture.houses[2] = dict(self.house, owner=1)
        self.fixture.job_table[('H002', 1)] = hero
        self.assertTrue(self.build())
        self.assertTrue(self.e['FFP_Build'](1, self.encoded, True))
        self.assertEqual(self.e['FFP_Count'][1], 6)
        self.assertFalse(self.build(self.encoded[:-1]))
        self.assertTrue(self.e['FFP_Ready'][1])
        self.assertTrue(self.e['FFP_Recheck'](1, True))

    def test_all_bindings_use_reviewed_ids_and_offhand_aliases(self):
        catalog = json.loads((HERE.parents[1]/'release/Forsaken/gear-slots-BS.json').read_text())
        bindings = {(parent, identity): value for parent, identity, value in fresh_plan_bindings(self.fixture.registry, catalog)}
        permanent = {r['rawcode']: r['id'] for r in self.fixture.registry['items']}
        for canonical, gear in catalog.items():
            identity = permanent[canonical]
            if gear['slot'] == 'Primary':
                self.assertEqual(bindings[(7, identity)], gear['offhand'])
            if gear['slot'] == 'Ring': self.assertEqual(bindings[(6, identity)], 48)
            if gear['slot'] == 'Inventory': self.assertNotIn((3, identity), bindings)


if __name__ == '__main__':
    unittest.main()
