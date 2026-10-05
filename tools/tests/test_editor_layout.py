"""Regression: a module appended after folders must retain its editor source."""
import unittest
from editor_layout import normalize, layout_errors, trigger_items


class EditorLayoutTests(unittest.TestCase):
    def fixture(self):
        tree = {'items': [
            {'kind': 1, 'id': 0, 'parent': -1},
            {'kind': 4, 'id': 1, 'parent': 0},
            {'kind': 8, 'id': 2, 'parent': 1, 'name': 'Early', 'custom': 1, 'enabled': 1},
            {'kind': 4, 'id': 3, 'parent': 0},
            {'kind': 8, 'id': 4, 'parent': 3, 'name': 'Dev', 'custom': 1, 'enabled': 0},
            {'kind': 8, 'id': 5, 'parent': 1, 'name': 'Engine', 'custom': 1, 'enabled': 1}]}
        wct = {'entries': [f'function InitTrig_{name} takes nothing returns nothing\nendfunction\0'.encode()
                           for name in ('Early', 'Dev', 'Engine')]}
        return tree, wct

    def test_appended_engine_is_repaired_with_all_source_and_flags_preserved(self):
        tree, wct = self.fixture()
        self.assertTrue(layout_errors(tree, wct))
        fixed, sources = normalize(tree, wct)
        self.assertEqual([x['name'] for x in trigger_items(fixed)], ['Early', 'Engine', 'Dev'])
        self.assertEqual(sources['entries'], [wct['entries'][i] for i in (0, 2, 1)])
        self.assertEqual(trigger_items(fixed)[-1]['enabled'], 0)
        self.assertEqual(layout_errors(fixed, sources), [])
        self.assertEqual(normalize(fixed, sources), (fixed, sources))

    def test_already_misassigned_source_is_rejected_instead_of_guessed(self):
        tree, wct = self.fixture()
        wct['entries'][0], wct['entries'][1] = wct['entries'][1], wct['entries'][0]
        with self.assertRaisesRegex(ValueError, 'InitTrig'):
            normalize(tree, wct)

    def test_orphan_and_duplicate_ids_are_rejected(self):
        for change in ('orphan', 'duplicate'):
            tree, wct = self.fixture()
            tree['items'][-1]['parent' if change == 'orphan' else 'id'] = 99 if change == 'orphan' else 2
            with self.assertRaises(ValueError):
                normalize(tree, wct)


if __name__ == '__main__':
    unittest.main()
