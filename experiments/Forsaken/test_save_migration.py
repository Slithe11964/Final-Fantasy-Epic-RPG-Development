"""Detached progression/migration contract; no Warcraft or live account data."""
import json
from pathlib import Path
import random
import re
import subprocess
import sys
import tempfile
import unittest

import legacy_snapshot as legacy
import migrate_save as migration
import save_progression as progression
import save_vnext as codec

HERE = Path(__file__).resolve().parent
CASES = json.loads((HERE / 'legacy-fixtures.json').read_text())['cases']


def replace(envelope, identity, payload=None, required=True, version=1):
    sections = tuple(codec.Section(identity, version, required, payload) if s.id == identity else s
                     for s in envelope.sections if s.id != identity or payload is not None)
    return codec.Envelope(envelope.account_hash, sections)


def native_sections():
    # Explicit synthetic maxima, independent of a legacy decoder.
    core = {1: 3, 2: 999999, 3: 500, 4: 100, 5: 10, 6: 3, 7: 7, 8: 15, 9: 1, 10: 1, 11: 0}
    gaya = {1: 1, 2: 99, 3: 3, 4: 3, 5: 3, 6: 1, 7: 1, 8: 1}
    return (codec.Section(4, 1, True, codec.pairs(list(core.items()))),
            codec.Section(5, 1, True, codec.pairs(list(gaya.items()))),
            codec.Section(6, 1, True, codec.pairs([(i, 10) for i in range(1, 16)])),
            codec.Section(7, 1, True, codec.pairs([(59, 1)])),
            codec.Section(8, 1, True, codec.pairs([(358, 1)])))


class MigrationTests(unittest.TestCase):
    def test_all_eight_pinned_vectors_and_independent_expected_fields(self):
        for case in CASES:
            with self.subTest(case=case['name']):
                envelope = migration.translate(case['code'], 'MigrationFixture#1234')
                target = progression.snapshot(codec.decode(codec.encode(envelope)))
                expected = case['expected']
                self.assertEqual(target['jobs'], {int(i): v for i, v in expected['jobs'].items()})
                self.assertEqual(target['upgrades'], {int(i): v for i, v in expected['upgrades'].items()})
                self.assertEqual(target['titles'], expected['titles'])
                self.assertEqual(target['gaya']['level'], expected['gaya']['level'])
                self.assertEqual(target['core']['freelancer'], expected['freelancer'])
                self.assertEqual(target['core']['new_game_plus'], expected['new_game_plus'])
                self.assertEqual(target['core']['gold'], 424242)
                self.assertEqual(target['core']['difficulty'], 2)
                for name in ('miracle_stage', 'meta_fragments'):
                    self.assertEqual(target['core'].get(name), expected[name])
                for name, modern in [('speedrun_level', 9), ('legendary_guardian', 1),
                                     ('armory_allowed_on_hard', 1)]:
                    self.assertEqual(target['core'].get(name), modern if case['version'] in 'GH' else None)
                self.assertTrue(migration.comparison(envelope)['equal'])

    def test_golden_successor_envelopes(self):
        golden = json.loads((HERE / 'migration-fixtures.json').read_text())['cases']
        self.assertEqual(len(CASES), len(golden))
        for before, after in zip(CASES, golden):
            self.assertEqual(before['name'], after['name'])
            envelope = migration.translate(before['code'])
            self.assertEqual(codec.encode(envelope), after['code'])
            self.assertEqual(len(codec.encode(envelope)), after['encoded_characters'])
            self.assertEqual(len(migration.comparison(envelope)['checks']), after['compared_fields'])

    def test_placement_binding_quantities_and_explicit_defaults(self):
        for case in CASES:
            target = progression.snapshot(migration.translate(case['code']))
            expected = [(1, 7, 1, 0, 0, True, ()), (2, 29, 2, 0, None, True, ()),
                        (3, 352, 1, 1, 127, True, ())]
            if case['version'] in 'GH':
                expected.append((4, 18, 4, 0, None, True, ()))
            expected.extend([(5, 7, 5, 0, 127, True, ()), (6, 29, 5, 1, None, True, ())])
            self.assertEqual(target['inventory'], expected)
            self.assertNotIn('shards', target['core'])  # Cannot unmix old currency.
            if case['version'] in 'EF':
                self.assertNotIn('speedrun_level', target['core'])
                self.assertNotIn('legendary_guardian', target['core'])
            else:
                self.assertIn(59, target['titles'])  # Completed Keg Hunter.
            self.assertEqual(target['migration'], (case['code'], False))

    def test_frozen_policy_matches_reviewed_sources(self):
        rules = migration.policy()
        catalog = json.loads((legacy.ROOT / 'src/armory-hints.json').read_text())
        layout = json.loads(legacy.LAYOUT.read_text())
        self.assertEqual(set(rules['gear_item_ids']), set(map(int, catalog)) - {71, 100, 103, 150})
        self.assertEqual(len(rules['gear_item_ids']), 276)
        self.assertEqual(rules['v2_rejected_item_ids'], layout['legacy_rejected_items'])
        text = (legacy.ROOT / 'src/triggers/09 Player features/Cmd.j').read_text()
        body = text.split('function Trig_Cmd_Load_Code_IsChocoboFood takes')[1].split('endfunction')[0]
        raws = set(re.findall("raw=='([^']+)'", body))
        self.assertEqual(raws, {layout['items'][str(i)]['rawcode'] for i in rules['speedrun_food_ids']})
        self.assertEqual(len(raws), 7)

    def test_speedrun_filter_and_metadata_provenance_are_reported(self):
        for case in CASES:
            envelope = migration.translate(case['code'], speedrun=True)
            report = migration.comparison(envelope)
            self.assertTrue(report['equal'])
            rejected = [d for d in report['inventory_decisions'] if d['reason'] == 'speedrun-food']
            self.assertEqual([d['item_id'] for d in rejected], [352])
            self.assertTrue(all(d['metadata_provenance'] == 'legacy-object-defaults-unresolved'
                                for d in report['inventory_decisions'] if d['action'] == 'retained'))
            self.assertEqual(progression.snapshot(envelope)['migration'][1], True)
        with self.assertRaises(codec.Error): migration.translate(CASES[0]['code'], speedrun=1)

    def test_pending_armory_wrong_account_and_corruption_refuse_translation(self):
        for case in CASES:
            if case['version'] in 'FH':
                with self.assertRaisesRegex(codec.Error, 'pending'):
                    migration.translate(case['code'].split('(')[0])
        with self.assertRaises(legacy.Error): migration.translate(CASES[0]['code'], 'WrongAccount')
        with self.assertRaises(legacy.Error): migration.translate(CASES[0]['code'] + 'A')

    def test_ngplus_reset_and_retired_minus_source_evidence(self):
        from test_legacy_snapshot import source_new_game
        plus = progression.snapshot(migration.translate(source_new_game(False)))
        self.assertEqual((plus['core']['gold'], plus['core']['miracle_stage'],
                          plus['core']['new_game_plus'], plus['core']['meta_fragments']), (300, 2, 1, 0))
        self.assertEqual(plus['inventory'], [])
        self.assertEqual(set(plus['jobs'].values()), {0})
        with self.assertRaisesRegex(codec.Error, 'cheat status'):
            migration.translate(source_new_game(True))

    def test_dense_armory_and_legacy_removal_are_preserved(self):
        from test_legacy_snapshot import source_armory_code
        order = json.loads(legacy.LAYOUT.read_text())['armory_order']
        for version in 'FH':
            case = next(c for c in CASES if c['version'] == version)
            code = source_armory_code(case['code'].split('(')[0], set(order))
            envelope = migration.translate(code)
            expected = set(order)
            if version == 'F': expected -= set(migration.policy()['v2_rejected_item_ids'])
            self.assertEqual(set(progression.snapshot(envelope)['armory']), expected)
            self.assertTrue(migration.comparison(envelope)['equal'])

    def test_comparison_detects_tampering_after_valid_rechecksum(self):
        envelope = migration.translate(CASES[-1]['code'])
        for identity in (1, 2, 4, 5, 6, 7, 8):
            section = next(s for s in envelope.sections if s.id == identity)
            if identity == 1:
                rows, _ = codec.read_inventory(section.payload)
                rows[0] = tuple(1 if i == 4 else value for i, value in enumerate(rows[0]))
                changed = codec.inventory(rows)
            else:
                rows = codec.read_pairs(section.payload)
                # Alter a valid field without breaking profile structure.
                if identity == 5: rows = [(i, 0 if i == 1 else v) for i, v in rows]
                elif identity in (7, 8): rows = rows[1:]
                else: rows[0] = (rows[0][0], rows[0][1] - 1 if rows[0][1] else 1)
                changed = codec.pairs(rows)
            tampered = codec.decode(codec.encode(replace(envelope, identity, changed)))
            self.assertFalse(migration.comparison(tampered)['equal'], identity)

    def test_profile_requires_sections_schema_fields_and_job_ids(self):
        envelope = migration.translate(CASES[-1]['code'])
        for identity in progression.PROFILE_SECTIONS:
            with self.assertRaises(codec.Error): progression.snapshot(replace(envelope, identity))
            payload = next(s.payload for s in envelope.sections if s.id == identity)
            for required, version in [(False, 1), (True, 2)]:
                with self.assertRaises(codec.Error):
                    progression.snapshot(replace(envelope, identity, payload, required, version))
        for identity in (2, 4, 5, 6):
            payload = next(s.payload for s in envelope.sections if s.id == identity)
            with self.assertRaises(codec.Error):
                progression.snapshot(replace(envelope, identity, codec.pairs(codec.read_pairs(payload)[1:])))

    def test_known_progression_ranges_duplicates_and_absence(self):
        for identity, rows in [(4, [(99, 0)]), (4, [(5, 11)]), (5, [(3, 4)]),
                               (6, [(16, 0)]), (6, [(1, 16)]), (7, [(59, 0)]), (8, [(1, 2)])]:
            with self.assertRaises(codec.Error):
                codec.encode(codec.Envelope(1, (codec.Section(identity, 1, True, codec.pairs(rows)),)))
        for invalid in (1.5, '2'):
            with self.assertRaises(codec.Error): progression.scalars({'gold': invalid}, progression.CORE)
        self.assertEqual(progression.read_scalars(progression.scalars({'gold': 0}, progression.CORE),
                                                 progression.CORE), {'gold': 0})

    def test_new_capture_profile_requires_metadata_and_all_core_values(self):
        empty = codec.Section(1, 1, True, codec.inventory([]))
        jobs = codec.Section(2, 1, True, codec.pairs([(i, 100) for i in range(1, 43)]))
        envelope = codec.Envelope(1, (empty, jobs) + native_sections())
        self.assertEqual(len(progression.snapshot(envelope)['jobs']), 42)
        item = (1, 1001, 2, 29, 120, True, ())
        with self.assertRaisesRegex(codec.Error, 'life/flags'):
            progression.snapshot(replace(envelope, 1, codec.inventory([item])))
        item = item[:6] + (((1, True, codec.life_words(145.25)), (2, True, codec.uint(5))),)
        progression.snapshot(replace(envelope, 1, codec.inventory([item])))
        for section in native_sections()[:2]:
            rows = codec.read_pairs(section.payload)
            if section.id == 4: rows = [(i, v) for i, v in rows if i != 3]
            else: rows = [(i, 98 if i == 2 else v) for i, v in rows]
            with self.assertRaises(codec.Error):
                progression.snapshot(replace(envelope, section.id, codec.pairs(rows)))

    def test_bounded_evidence_and_optional_future_sections(self):
        envelope = migration.translate(CASES[0]['code'])
        future = codec.Section(100, 1, False, 'ABC')
        extended = codec.Envelope(envelope.account_hash, envelope.sections + (future,))
        self.assertTrue(migration.comparison(codec.decode(codec.encode(extended)))['equal'])
        self.assertEqual(codec.decode(codec.encode(extended)).sections[-1], future)
        for raw in ('E' + 'A' * 4096, 'X' + 'A' * 20, 'E' + '!' * 20):
            with self.assertRaises(codec.Error): progression.evidence(raw)
        for payload in (codec.uint(2) + 'AAA', codec.uint(1) + codec.uint(2) + 'AAA',
                        progression.evidence(CASES[0]['code']) + 'A'):
            with self.assertRaises(codec.Error): progression.read_evidence(payload)

    def test_seeded_progression_roundtrips(self):
        rng = random.Random(20261009)
        base = migration.translate(CASES[-1]['code'])
        for _ in range(250):
            sections = [s for s in base.sections if s.id not in (4, 5, 6, 7, 8, 9)]
            # Keep the migration evidence so absent legacy item metadata is explicit.
            sections += list(native_sections()) + [base.sections[-1]]
            core = {name: rng.randint(0, maximum) for name, maximum in progression.CORE.values()}
            sections = [codec.Section(4, 1, True, progression.scalars(core, progression.CORE))
                        if s.id == 4 else s for s in sections]
            envelope = codec.Envelope(base.account_hash, tuple(sections))
            decoded = codec.decode(codec.encode(envelope))
            self.assertEqual(progression.snapshot(decoded)['core'], core)
            self.assertEqual(decoded, envelope)

    def test_full_logical_and_migration_size_profiles(self):
        from measure_save_vnext import profiles
        report = profiles()
        for row in report['logical_profiles']:
            self.assertEqual((row['inventory_records'], row['job_records'], row['armory_records'],
                              row['dormant_records']), (57, 42, 280, 50))
            self.assertLess(row['encoded_characters'], codec.MAX_PAYLOAD)
        self.assertEqual(len(report['migration_profiles']), 8)
        self.assertEqual([r['encoded_characters'] for r in report['migration_profiles']],
                         [373, 346, 429, 402, 463, 436, 521, 494])

    def test_cli_exports_only_after_account_and_comparison_validation(self):
        with tempfile.TemporaryDirectory(dir=legacy.ROOT / 'build') as folder:
            path = Path(folder) / 'synthetic-code.txt'
            path.write_text(CASES[-1]['code'], encoding='utf-8')
            command = [sys.executable, str(HERE / 'migrate_save.py'), '--input', str(path), '--player']
            accepted = subprocess.run(command + ['MigrationFixture'], capture_output=True, text=True)
            self.assertEqual(accepted.returncode, 0, accepted.stderr)
            result = json.loads(accepted.stdout)
            self.assertTrue(result['report']['equal'])
            self.assertEqual(len(result['report']['checks']), 62)
            self.assertTrue(migration.comparison(codec.decode(result['code']))['equal'])
            refused = subprocess.run(command + ['WrongAccount'], capture_output=True, text=True)
            self.assertNotEqual(refused.returncode, 0)
            self.assertEqual(refused.stdout, '')


if __name__ == '__main__':
    unittest.main()
