"""The generated equipment-slot table must match the map it was generated from."""
import os
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
import gear_slots


def latest_map():
    maps = sorted((ROOT / 'release').glob('FFERPG_*-stage*.w3x'))
    return maps[-1] if maps else None


class GearSlotTable(unittest.TestCase):
    def test_generated_file_is_current(self):
        """Regenerating from the newest release must reproduce the checked-in file."""
        base = latest_map()
        if base is None:
            self.skipTest('no release map to generate from')
        rows = gear_slots.classify(base)
        self.assertEqual(len(rows), 276, 'the reviewed gear set is 276 items')
        self.assertEqual(gear_slots.render(rows, gear_slots.item_casts(base)).encode('utf-8'),
                         gear_slots.OUT.read_bytes(),
                         'run tools/gear_slots.py against the newest release map')

    def test_every_kind_is_known(self):
        kinds = {kind for _, _, kind, _, _ in gear_slots.classify(latest_map())}
        self.assertTrue(kinds <= set(gear_slots.KINDS), kinds)
        self.assertEqual(set(gear_slots.LABELS), set(gear_slots.KINDS))

    def test_items_that_cast_name_their_spell(self):
        """Clicking an item is judged by the spell it casts, so the items the shared cooldowns
        are about must each name one."""
        casts = gear_slots.item_casts(latest_map())
        self.assertEqual(casts.get('I025'), 'A0Q2')   # Wateraga Materia
        self.assertEqual(casts.get('I05X'), 'A08X')   # Book of Depths
        self.assertEqual(casts.get('I0HX'), 'A0FW')   # Tome of Life
        self.assertEqual(casts.get('I0HY'), 'A07D')   # Tome of the Tortoise

    def test_worn_kinds_come_before_rings(self):
        """Equipment page 1 is laid out in kind order, so the six worn pieces must be 1 to 6
        and the ring and trinket must follow them; the backpack's page rules rely on it."""
        self.assertEqual(gear_slots.KINDS[:6],
                         ['Primary', 'Offhand', 'Head', 'Chest', 'Gloves', 'Boots'])
        self.assertEqual(gear_slots.KINDS[6:], ['Ring', 'Trinket'])

    def test_backpack_uses_the_generated_names(self):
        source = (ROOT / 'src/triggers/05 Items crafting and shops/Backpack.j').read_text(encoding='utf-8')
        for name in ('GEAR_PRIMARY', 'GEAR_BOOTS', 'GEAR_RING', 'GEAR_TRINKET',
                     'Gear_KindOf', 'Gear_BonusCount', 'Gear_Bonus(', 'Gear_IsGearAbility',
                     'GearSlots_Init'):
            self.assertIn(name, source, name)


if __name__ == '__main__':
    unittest.main()
