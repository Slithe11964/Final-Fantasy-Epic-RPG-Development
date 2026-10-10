"""Actual levels/mastery and active job survive schema2 without sentinel ambiguity."""
import unittest

import save_progression as progression
import save_vnext as codec
from test_save_jass import engine, reference_accepts, unchecked
from test_save_migration import native_sections
from save_hero_policy import plan


def modern(level=150, tier=2, current=11, freelancer=99, free_tier=3, variant=1):
    sections = list(native_sections())
    core = dict(codec.read_pairs(sections[0].payload))
    core.update({4: freelancer, 12: free_tier, 13: current, 14: variant, 15: 0})
    sections[0] = codec.Section(4, 2, True, codec.pairs(list(core.items())))
    return codec.Envelope(42, (codec.Section(1, 1, True, codec.inventory([])),
        codec.Section(2, 2, True, progression.jobs2([(i, level, tier) for i in range(1, 23)])))+tuple(sections))


class JobSchemaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.e = engine()

    def parity(self, envelope, valid=True):
        text = unchecked(envelope.sections)
        self.assertEqual(reference_accepts(text, 42, True), valid)
        self.assertEqual(self.e['FSC_Decode'](0, text, 42, True), valid)
        if valid:
            self.assertEqual(self.e['FSC_Reencode'](0), text)
            self.assertTrue(self.e['FSC_Begin'](0, 42))
            for section in envelope.sections:
                self.assertTrue(self.e['FSC_Add'](0, section.id, section.version, section.required, section.payload))
            self.assertEqual(self.e['FSC_Finish'](0, True), text)
        return text

    def change(self, envelope, sid, payload=None, version=None, required=None):
        return codec.Envelope(42, tuple(codec.Section(s.id, s.version if version is None else version,
            s.required if required is None else required, s.payload if payload is None else payload)
            if s.id == sid else s for s in envelope.sections))

    def test_levels_100_150_999_are_real_and_mastery_independent(self):
        for level in (1, 49, 50, 98, 99, 100, 150, 999):
            tier = 0 if level < 50 else 1 if level < 99 else 2
            envelope = modern(level, tier)
            self.parity(envelope)
            snapshot = progression.snapshot(envelope)
            self.assertEqual(snapshot['job_levels'][11], level)
            self.assertEqual(snapshot['job_mastery'][11], tier)
            self.assertEqual(snapshot['core']['current_job'], 11)
        for tier in (2, 3): self.parity(modern(100, tier))

    def test_legacy_sentinel_maps_to_99_and_enhanced_mastery(self):
        self.assertEqual(progression.legacy_job(100), (99, 3))
        self.assertEqual(progression.legacy_job(99), (99, 2))
        self.assertEqual(progression.legacy_job(50), (50, 1))
        self.assertEqual(progression.legacy_job(0), (0, 0))

    def test_bad_mastery_and_duplicate_missing_overflowing_records(self):
        good = modern()
        for level, tier in ((49, 1), (50, 0), (98, 2), (99, 1), (999, 4), (1000, 2)):
            rows = [(i, 150, 2) for i in range(1, 23)]
            rows[10] = (11, level, tier)
            payload = codec.uint(len(rows))+''.join(codec.uint(i)+codec.uint(l)+codec.uint(t) for i, l, t in rows)
            self.parity(self.change(good, 2, payload), False)
        for rows in ([(i, 150, 2) for i in range(1, 22)], [(1, 150, 2)]*22):
            payload = codec.uint(len(rows))+''.join(codec.uint(i)+codec.uint(l)+codec.uint(t) for i, l, t in rows)
            self.parity(self.change(good, 2, payload), False)
        self.parity(self.change(good, 2, 'g'*8), False)

    def test_active_job_missing_progress_and_freelancer_variant_constraints(self):
        self.parity(modern(current=0))
        self.parity(modern(current=0, freelancer=0, free_tier=0, variant=0), False)
        self.parity(modern(freelancer=0, free_tier=0, variant=0))
        self.parity(modern(freelancer=0, free_tier=0, variant=1), False)
        self.parity(modern(0, 0), False)
        self.parity(modern(1, 0, current=23), False)
        self.parity(modern(1, 0, freelancer=49, free_tier=1), False)
        self.parity(modern(1, 0, variant=4), False)

    def test_required_schema_pair_and_core_completeness(self):
        good = modern()
        self.parity(self.change(good, 2, required=False), False)
        self.parity(self.change(good, 4, required=False), False)
        self.parity(self.change(good, 2, version=3), False)
        for identity in (12, 13, 14, 15):
            rows = [(i, v) for i, v in codec.read_pairs(good.sections[2].payload) if i != identity]
            self.parity(self.change(good, 4, codec.pairs(rows)), False)
        oldcore = native_sections()[0]
        self.parity(self.change(good, 4, oldcore.payload, version=1), False)

    def test_old_live_staging_policy_cannot_misread_new_actual_level_100(self):
        with self.assertRaisesRegex(codec.Error, 'fresh-load'):
            plan(modern(100, 2), 42)


if __name__ == '__main__':
    unittest.main()
