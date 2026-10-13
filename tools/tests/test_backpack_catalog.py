"""Backpack objects may only use fields and types this map already uses.

An invented field id, or a real field written with the wrong type, corrupts the object
file from that point on: tooltips turn to garbage, items go missing and abilities stop
working. The map itself is the reference for what is valid.
"""
import unittest
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from mpq import MPQ
from objdata import read_objects
import backpack_catalog as catalog

ROOT = Path(__file__).resolve().parents[2]
MAPS = sorted((ROOT / 'release').glob('FFERPG_*-stageAS*.w3x'))
NEW_ABILITIES = {catalog.BACKPACK, catalog.RETURN}


def vouched(archive):
    """Every (file, field) -> the types this map writes it with."""
    known = {}
    for kind, name in (('w3u', 'war3map.w3u'), ('w3a', 'war3map.w3a')):
        for obj in read_objects(archive.read(name), kind)['custom']:
            for group in obj['sets']:
                for mod in group['mods']:
                    known.setdefault((kind, mod['field']), set()).add(mod['type'])
    return known


class BackpackCatalogTests(unittest.TestCase):
    def setUp(self):
        # A map that does not carry the Backpack objects yet, so they can be added here.
        for path in reversed(MAPS):
            archive = MPQ(str(path))
            if not NEW_ABILITIES & {o['id'] for o in
                                    read_objects(archive.read('war3map.w3a'), 'w3a')['custom']}:
                self.archive = archive
                self.known = vouched(archive)
                return
        self.skipTest('no stage map without the Backpack objects')

    def added(self):
        abilities = read_objects(self.archive.read('war3map.w3a'), 'w3a')
        units = read_objects(self.archive.read('war3map.w3u'), 'w3u')
        catalog.prepare_abilities(abilities)
        catalog.prepare_holder(units)
        return abilities, units

    def test_every_field_and_type_is_one_the_map_already_uses(self):
        abilities, units = self.added()
        unvouched = []
        for kind, table, ids in (('w3a', abilities, NEW_ABILITIES), ('w3u', units, {catalog.HOLDER})):
            for obj in table['custom']:
                if obj['id'] not in ids:
                    continue
                for group in obj['sets']:
                    for mod in group['mods']:
                        types = self.known.get((kind, mod['field']))
                        if types is None:
                            unvouched.append('%s.%s is not a field this map uses' % (obj['id'], mod['field']))
                        elif mod['type'] not in types:
                            unvouched.append('%s.%s written as type %d, map uses %s'
                                             % (obj['id'], mod['field'], mod['type'], sorted(types)))
        self.assertEqual(unvouched, [])

    def test_the_icons_are_paths_the_map_already_loads(self):
        paths = {mod['value'] for kind, name in (('w3a', 'war3map.w3a'), ('w3t', 'war3map.w3t'))
                 if self.archive.read(name)
                 for obj in read_objects(self.archive.read(name), kind)['custom']
                 for group in obj['sets'] for mod in group['mods']
                 if mod['field'] in ('aart', 'iico') and mod['value']}
        lowered = {p.lower().rsplit('\\', 1)[-1] for p in paths}
        for icon in (catalog.BACKPACK_ICON, catalog.RETURN_ICON):
            name = icon.lower().rsplit('\\', 1)[-1]
            self.assertIn(name, {n.replace('disbtn', 'btn') for n in lowered},
                          icon + ' is not an icon this map already shows')

    def test_the_order_string_sits_in_the_same_column_as_the_working_button(self):
        """Channel keeps its order string in a data column; the wrong one leaves no order."""
        abilities, _ = self.added()
        def order_mods(raw):
            obj = next(o for o in abilities['custom'] if o['id'] == raw)
            return [(m['level'], m['data'], m['value']) for group in obj['sets']
                    for m in group['mods'] if m['field'] == 'Ncl6']
        working = order_mods(catalog.TALENTS)
        self.assertEqual(len(working), 1, 'expected one order string on the Talents button')
        for raw in NEW_ABILITIES:
            mine = order_mods(raw)
            self.assertEqual(len(mine), 1, raw + ' must carry exactly one order string')
            self.assertEqual((mine[0][0], mine[0][1]), (working[0][0], working[0][1]),
                             raw + ' puts its order string in a different column from Talents')

    def test_each_new_ability_has_its_own_unused_order(self):
        abilities = read_objects(self.archive.read('war3map.w3a'), 'w3a')
        orders = {mod['value'] for obj in abilities['custom'] for group in obj['sets']
                  for mod in group['mods'] if mod['field'] == 'Ncl6'}
        self.assertNotEqual(catalog.BACKPACK_ORDER, catalog.RETURN_ORDER)
        for order in (catalog.BACKPACK_ORDER, catalog.RETURN_ORDER):
            self.assertNotIn(order, orders, order + ' is already an order in this map')

    def test_the_holder_is_quiet_and_answers_at_once(self):
        """No attacks and no acquisition range, so it is never busy fighting when a page
        button is clicked, and no cast point, so the page turns the moment it is asked."""
        quiet = dict((field, value) for field, _type, value in catalog.holder_fields())
        self.assertEqual(quiet['uaen'], 0)
        self.assertEqual(quiet['uacq'], 0.0)
        self.assertEqual(quiet['ucpt'], 0.0)

    def test_updating_a_map_that_already_has_the_holder_keeps_one_entry(self):
        units = read_objects(self.archive.read('war3map.w3u'), 'w3u')
        catalog.prepare_holder(units)
        catalog.update_holder(units)
        self.assertEqual(sum(1 for o in units['custom'] if o['id'] == catalog.HOLDER), 1)

if __name__ == '__main__':
    unittest.main()
