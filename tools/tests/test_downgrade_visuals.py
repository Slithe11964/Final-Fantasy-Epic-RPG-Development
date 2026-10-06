import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import copy
import unittest

from downgrade import fferpg_visuals
from objdata import read_objects, write_objects


def mod(field, value, kind=3, level=0):
    return dict(field=field, type=kind, level=level, data=0 if level is not None else None,
                value=value, end=0)


def obj(base, rawcode, mods):
    return dict(base=base, id=rawcode, sets=[dict(flag=0, mods=mods)])


class VisualProfileTests(unittest.TestCase):
    def fixture(self):
        units = dict(version=2, original=[], custom=[
            obj('Hapm', 'H002', [mod('uabi', 'A0HL,AInv', level=None)]),
            obj('Eill', 'H00F', [mod('uabi', 'A0HP,AInv', level=None)]),
            obj('now3', 'H01D', [mod('uabi', 'Avul,A0VJ,A10U', level=None),
                                mod('ussc', 1.0, 1, None), mod('uslz', 100.0, 1, None),
                                mod('umvh', 100.0, 1, None)]),
        ])
        abilities = dict(version=2, original=[], custom=[
            obj('Amgl', 'A0HL', [mod('aart', 'Pharmacology.blp')]),
            obj('Amgl', 'A0HP', [mod('aart', 'DualWield.blp')]),
            obj('ACba', 'A10U', [mod('Hab1', 5010.0, 1, 1),
                                mod('abuf', 'B06P', level=1)]),
            obj('AImt', 'A0P3', [mod('atat', 'MassTeleportTarget.mdl')]),
        ])
        return {'war3map.w3u': write_objects(units, 2, 'w3u'),
                'war3map.w3a': write_objects(abilities, 2, 'w3a')}

    def test_only_requested_visuals_change(self):
        files = self.fixture()
        before = copy.deepcopy(files)
        fferpg_visuals(files)
        self.assertEqual(before['war3map.w3u'], files['war3map.w3u'])
        for ext in ('w3u', 'w3a'):
            old = read_objects(before['war3map.' + ext], ext)
            new = read_objects(files['war3map.' + ext], ext)
            for original, changed in zip(old['custom'], new['custom']):
                mods = changed['sets'][0]['mods']
                if changed['id'] in ('A0HL', 'A0HP'):
                    added = [m for m in mods if m['field'] in ('acat', 'atat', 'aeat', 'asat')]
                    self.assertEqual(len(added), 4)
                    self.assertTrue(all(m['value'] == '' for m in added))
                    mods[:] = [m for m in mods if m not in added]
                self.assertEqual(original, changed)

    def test_explicit_passive_art_is_preserved_and_profile_is_idempotent(self):
        files = self.fixture()
        table = read_objects(files['war3map.w3a'], 'w3a')
        table['custom'][0]['sets'][0]['mods'].append(mod('atat', 'AuthoredEffect.mdl'))
        files['war3map.w3a'] = write_objects(table, 2, 'w3a')
        fferpg_visuals(files)
        result = copy.deepcopy(files)
        fferpg_visuals(files)
        self.assertEqual(result, files)
        table = read_objects(files['war3map.w3a'], 'w3a')
        self.assertIn(mod('atat', 'AuthoredEffect.mdl'), table['custom'][0]['sets'][0]['mods'])

    def test_different_map_is_rejected_without_mutation(self):
        files = self.fixture()
        table = read_objects(files['war3map.w3u'], 'w3u')
        table['custom'][0]['base'] = 'Hpal'
        files['war3map.w3u'] = write_objects(table, 2, 'w3u')
        before = copy.deepcopy(files)
        with self.assertRaises(ValueError):
            fferpg_visuals(files)
        self.assertEqual(before, files)


if __name__ == '__main__':
    unittest.main()
