"""Item checks across the map must see the backpack: worn gear on the equipment pages, and
anything carried anywhere in it. Only a few checks stay on a unit's own six slots."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TRIGGERS = ROOT / 'src/triggers'
# Units that are never a player's hero (bosses), or items the hero must use itself (the
# automatic potion drinks from the hero's own slots), keep the native lookup.
NATIVE_OK = {'Auto', 'Boss_Judges', 'Boss_Gilgamesh', 'Backpack'}
# Effects of wearing gear: these must read the equipment pages, not the bag.
WORN = {'MagicDefense', 'Dead', 'Revive', 'LionHeart'}
WORN_LOOPS = {'Prof': 1, 'Damage': 2, 'Unit': 1, 'TwoHanded': 4}


def modules():
    for path in TRIGGERS.rglob('*.j'):
        if '12 Save system' in path.parts:
            continue
        yield path.stem, path.read_bytes().decode('latin-1')


class GearQueryTests(unittest.TestCase):
    def test_no_item_check_ignores_the_backpack(self):
        for name, text in modules():
            if name in NATIVE_OK:
                continue
            self.assertNotIn('UnitHasItemOfTypeBJ(', text, name)
            self.assertNotIn('GetItemOfTypeFromUnitBJ(', text, name)

    def test_wearing_effects_read_the_equipment_pages(self):
        found = dict(modules())
        for name in WORN:
            self.assertIn('Gear_Wears(', found[name], name)
            self.assertNotIn('Gear_HasCarried(', found[name], name)
        for name, count in WORN_LOOPS.items():
            self.assertEqual(found[name].count('Gear_WornInSlot('), count, name)
            self.assertNotIn('UnitItemInSlot(u,i)', found[name], name)

    def test_users_require_the_backpack_without_a_cycle(self):
        requires = {}
        users = set()
        for name, text in modules():
            first = text.split('\n', 1)[0]
            match = re.match(r'library (\w+)(?:\s+requires\s+(.*))?', first.strip())
            if not match:
                continue
            requires[match[1]] = [r.replace('optional', '').strip() for r in (match[2] or '').split(',') if r.strip()]
            if re.search(r'\bGear_(Carried|HasCarried|Wears|WornOfType|WornInSlot|DropFrom)\(', text) and name != 'Backpack':
                users.add(match[1])
                self.assertIn('TBackpack', requires[match[1]], name)
        closure, todo = set(), ['TBackpack']
        while todo:
            library = todo.pop()
            if library not in closure:
                closure.add(library)
                todo += requires.get(library, [])
        self.assertFalse(users & closure, 'the backpack would depend on a module that depends on it')


if __name__ == '__main__':
    unittest.main()
