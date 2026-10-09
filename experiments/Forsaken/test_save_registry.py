"""Identity migration preflight tests; no Warcraft runtime or codec execution."""
import copy
import json
import unittest

import save_registry as registry


class IdentityTests(unittest.TestCase):
    def setUp(self):
        self.data, _ = registry.check()
        self.items = {str(r['legacy_index']): r['rawcode'] for r in self.data['items']}
        self.jobs = {str(r['legacy_index']): r['rawcode'] for r in self.data['jobs']}

    def validate(self, data=None, mapping=None):
        return registry.validate(data or self.data, self.items, self.jobs, mapping or {})

    def test_reviewed_legacy_contract_and_food_extension(self):
        old = json.loads((registry.ROOT / 'tools/contracts/save-compatibility.json').read_text())
        food = json.loads((registry.ROOT / 'tools/contracts/chocobo-food-save-extension.json').read_text())
        self.assertEqual(self.items, dict(old['items'], **food['items']))
        self.assertEqual(self.jobs, old['jobs'])
        self.assertEqual(len(self.validate()), 358)

    def test_reassigned_identity_rejected(self):
        changed = copy.deepcopy(self.data)
        changed['items'][0]['id'] = 10000
        with self.assertRaisesRegex(ValueError, 'reassigned'):
            self.validate(changed)

    def test_duplicate_identity_rejected(self):
        changed = copy.deepcopy(self.data)
        changed['jobs'][1]['id'] = changed['jobs'][0]['id']
        with self.assertRaisesRegex(ValueError, 'duplicate'):
            self.validate(changed)

    def test_legacy_reordering_rejected(self):
        self.jobs['0'], self.jobs['1'] = self.jobs['1'], self.jobs['0']
        with self.assertRaisesRegex(ValueError, 'source differs'):
            self.validate()

    def test_unreviewed_append_rejected(self):
        self.items['359'] = 'Izzz'
        with self.assertRaisesRegex(ValueError, 'source differs'):
            self.validate()

    def mapping(self):
        catalog = json.loads((registry.ROOT / 'src/armory-hints.json').read_text())
        return {e['item']: dict(item=e['item'], slot='Primary', variant='f%03d' % i,
                               offhand='g%03d' % i) for i, e in enumerate(catalog.values())}

    def test_both_runtime_variants_resolve_to_same_canonical_item(self):
        mapping = self.mapping()
        aliases = self.validate(mapping=mapping)
        for raw, entry in mapping.items():
            self.assertEqual(aliases[raw], aliases[entry['variant']])
            self.assertEqual(aliases[raw], aliases[entry['offhand']])

    def test_missing_catalog_mapping_rejected(self):
        with self.assertRaisesRegex(ValueError, 'empty runtime mapping'):
            registry.check({})
        mapping = self.mapping()
        mapping.pop(next(iter(mapping)))
        with self.assertRaisesRegex(ValueError, 'coverage'):
            self.validate(mapping=mapping)

    def test_variant_reassignment_rejected(self):
        mapping = self.mapping()
        mapping[next(iter(mapping))]['variant'] = 'f999'
        with self.assertRaisesRegex(ValueError, 'variant differs'):
            self.validate(mapping=mapping)

    def test_offhand_reassignment_rejected(self):
        mapping = self.mapping()
        mapping[next(iter(mapping))]['offhand'] = 'g999'
        with self.assertRaisesRegex(ValueError, 'offhand differs'):
            self.validate(mapping=mapping)

    def test_collision_with_canonical_rawcode_rejected(self):
        mapping = self.mapping()
        # Preserve a syntactically correct builder alias but collide with an
        # otherwise valid permanent rawcode, simulating a later object addition.
        changed = copy.deepcopy(self.data)
        changed['items'][0]['rawcode'] = 'f000'
        self.items['1'] = 'f000'
        with self.assertRaisesRegex(ValueError, 'colliding'):
            self.validate(changed, mapping)


if __name__ == '__main__':
    unittest.main()
