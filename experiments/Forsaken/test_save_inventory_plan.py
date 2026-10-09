"""Actual-map target resolution; no Warcraft allocation or placement."""
from dataclasses import replace
from pathlib import Path
from types import MappingProxyType
import unittest

import save_inventory_plan as target
import save_transaction as tx
import save_vnext as codec
import migrate_save as migration
from test_save_migration import native_sections, CASES

ROOT = Path(__file__).resolve().parents[2]


def record(identity, holder=2, slot=0, ordinal=1, quantity=120, bound=True):
    return (ordinal, identity, holder, slot, quantity, bound,
            ((1, True, codec.life_words(145.25)), (2, True, codec.uint(5))))


def envelope(records):
    return codec.Envelope(42, (codec.Section(1, 1, True, codec.inventory(records)),
        codec.Section(2, 1, True, codec.pairs([(i, 1) for i in range(1, 23)]))) + native_sections())


class InventoryPlanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.runtime = target.catalog(ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x',
                                     ROOT/'release/Forsaken/gear-slots-BS.json')
        cls.ids = {raw: identity for identity, raw in cls.runtime.items.items()}
        cls.gear = {raw: value for raw, value in cls.runtime.mapping.items() if 'variant' in value}
        cls.identity = cls.ids[next(iter(cls.gear))]

    def test_actual_catalog_is_immutable_and_complete(self):
        self.assertEqual(len(self.runtime.items), 358)
        self.assertEqual(len(self.gear), 276)
        self.assertEqual(len(self.runtime.passives), 1012)
        self.assertEqual(self.runtime.map_hash, '4a7cd22fe195ffec8740ff418c0d02ea17d6539d275348962f7609a34aea74b2')
        with self.assertRaises(TypeError): self.runtime.items[1] = 'fake'
        with self.assertRaises(TypeError): self.runtime.mapping[next(iter(self.gear))]['slot'] = 'fake'
        with self.assertRaises(TypeError): self.runtime.objects[next(iter(self.gear))]['iabi'] = 'fake'

    def test_all_gear_bag_equipment_and_primary_offhand_aliases(self):
        for raw, value in self.gear.items():
            identity = self.ids[raw]
            self.assertEqual(target.runtime_raw(self.runtime, identity, 2, 29), value['variant'])
            slot = target.EQUIPMENT_SLOTS.index(value['slot'])
            self.assertEqual(target.runtime_raw(self.runtime, identity, 3, slot), value['variant'])
            if value['slot'] == 'Primary':
                self.assertEqual(target.runtime_raw(self.runtime, identity, 3, 7), value['offhand'])
            for holder in (1, 4, 5):
                self.assertEqual(target.runtime_raw(self.runtime, identity, holder, 0), raw)

    def test_full_57_positions_metadata_binding_and_duplicate_rings(self):
        rows = []
        for holder, count in codec.HOLDERS.items():
            for slot in range(count):
                identity = self.identity
                if holder == 3:
                    wanted = target.EQUIPMENT_SLOTS[slot]
                    raw = next(raw for raw, v in self.gear.items() if v['slot'] == wanted)
                    identity = self.ids[raw]
                rows.append(record(identity, holder, slot, len(rows)+1,
                                   (0, 120, 127)[len(rows)%3], bool(len(rows)%2)))
        source = envelope(rows)
        before = codec.encode(source)
        result = target.plan(source, 42, 7, self.runtime)
        self.assertEqual(len(result.placements), 57)
        self.assertEqual(len(set(result.reserved_positions)), 57)
        for placement in result.placements:
            material = placement.material
            self.assertEqual((material.life, material.flags, material.owner), (145.25, 5, 7))
            self.assertEqual(material.user_data, 8 if material.record[5] else 0)
            self.assertEqual(material.charges, material.record[4])
            self.assertEqual(placement.stored, material.record[2] == 2)
        rings = [p.material for p in result.placements if p.material.record[2:4] in ((3, 4), (3, 5))]
        self.assertEqual(rings[0].rawcode, rings[1].rawcode)
        self.assertEqual(codec.encode(source), before)
        self.assertIs(result.envelope, source)

    def test_sparse_bag_and_harmless_marker_keep_exact_roles(self):
        result = target.plan(envelope([record(self.identity, slot=29)]), 42, 0, self.runtime)
        p = result.placements[0]
        self.assertEqual(result.reserved_positions, ((2, 29),))
        self.assertIn(('fGmk', 2), p.effects)
        for ability, role in p.effects:
            self.assertEqual(role, 1 if ability in self.runtime.passives and ability != 'fGmk' else 2)

    def test_unknown_identity_and_optional_metadata_reserve_complete_records(self):
        known = record(self.identity)
        optional = known[:6] + (known[6]+((100, False, 'ABC'),),)
        unknown = record(1000, slot=29, ordinal=2)
        result = target.plan(envelope([optional, unknown]), 42, 0, self.runtime)
        self.assertEqual(result.placements, ())
        self.assertEqual(tuple(d.record for d in result.dormant), (optional, unknown))
        self.assertEqual(result.reserved_positions, ((2, 0), (2, 29)))

    def test_wrong_equipment_slot_refuses(self):
        raw = next(raw for raw, v in self.gear.items() if v['slot'] == 'Boots')
        with self.assertRaisesRegex(tx.Failure, 'different slot'):
            target.plan(envelope([record(self.ids[raw], 3, 0)]), 42, 0, self.runtime)

    def test_account_and_player_context_refuse(self):
        source = envelope([record(self.identity)])
        with self.assertRaisesRegex(tx.Failure, 'account'):
            target.plan(source, 43, 0, self.runtime)
        for pid in (-1, 8, True):
            with self.assertRaisesRegex(tx.Failure, 'binding'):
                target.plan(source, 42, pid, self.runtime)

    def test_incomplete_profile_and_cheat_status_refuse(self):
        source = envelope([record(self.identity)])
        incomplete = codec.Envelope(42, tuple(s for s in source.sections if s.id != 5))
        with self.assertRaises(codec.Error): target.plan(incomplete, 42, 0, self.runtime)
        core = next(s for s in source.sections if s.id == 4)
        cheated = codec.Section(4, 1, True, codec.pairs([
            (i, 1 if i == 11 else value) for i, value in codec.read_pairs(core.payload)]))
        source = codec.Envelope(42, tuple(cheated if s.id == 4 else s for s in source.sections))
        with self.assertRaisesRegex(tx.Failure, 'cheat'):
            target.plan(source, 42, 0, self.runtime)

    def test_invalid_legacy_rawcode_default_refuses(self):
        source = migration.translate(CASES[0]['code'])
        import save_progression
        first = save_progression.snapshot(source)['inventory'][0]
        with self.assertRaisesRegex(tx.Failure, 'life/flags'):
            target.plan(source, source.account_hash, 0, self.runtime,
                        legacy_defaults={first[1:4]: tx.Defaults('fake', 0, 99., 6)})

    def test_missing_inherited_defaults_refuse_and_explicit_defaults_work(self):
        raw = target.runtime_raw(self.runtime, self.identity, 2, 0)
        objects = dict(self.runtime.objects)
        definition = dict(objects[raw])
        definition.pop('iuse', None)
        definition.pop('iabi', None)
        objects[raw] = definition
        runtime = replace(self.runtime, objects=MappingProxyType(objects))
        source = envelope([record(self.identity, quantity=None)])
        with self.assertRaisesRegex(tx.Failure, 'charge default'):
            target.plan(source, 42, 0, runtime)
        with self.assertRaisesRegex(tx.Failure, 'ability defaults'):
            target.plan(source, 42, 0, runtime, charge_defaults={self.identity: 0})
        result = target.plan(source, 42, 0, runtime, charge_defaults={self.identity: 0},
                             ability_defaults={raw: ('fGmk',)})
        self.assertEqual(result.placements[0].material.charges, 0)
        self.assertEqual(result.placements[0].effects, (('fGmk', 2),))

    def test_invalid_or_duplicate_ability_bindings_refuse(self):
        raw = target.runtime_raw(self.runtime, self.identity, 2, 0)
        for abilities in ('fake,fake', 'bad', ','.join(f'{i:04d}' for i in range(17))):
            objects = dict(self.runtime.objects)
            objects[raw] = dict(objects[raw], iabi=abilities)
            runtime = replace(self.runtime, objects=objects)
            with self.assertRaises(tx.Failure):
                target.plan(envelope([record(self.identity)]), 42, 0, runtime)

    def test_legacy_requires_explicit_life_flags_for_every_position(self):
        for case in CASES:
            source = migration.translate(case['code'])
            import save_progression
            rows = save_progression.snapshot(source)['inventory']
            defaults, charges, abilities = {}, {}, {}
            for r in rows:
                raw = target.runtime_raw(self.runtime, r[1], r[2], r[3])
                defaults[r[1:4]] = tx.Defaults(raw, 0, 99., 6)
                charges[r[1]] = 0
                if 'iabi' not in self.runtime.objects[raw]: abilities[raw] = ()
            with self.assertRaisesRegex(tx.Failure, 'life/flags'):
                target.plan(source, source.account_hash, 0, self.runtime, charges, ability_defaults=abilities)
            result = target.plan(source, source.account_hash, 0, self.runtime, charges, defaults, abilities)
            self.assertEqual(len(result.placements), len(rows))
            for p in result.placements:
                self.assertEqual((p.material.life, p.material.flags), (99., 6))
                self.assertEqual(p.material.charges, p.material.record[4] or 0)


if __name__ == '__main__':
    unittest.main()
