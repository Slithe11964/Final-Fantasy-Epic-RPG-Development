"""Changes first made in the Forsaken line must stay in the normal map."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import forsaken_parity

ROOT = Path(__file__).resolve().parents[2]
COMBAT = ROOT / 'src/triggers/04 Combat and abilities'


def text(path):
    return path.read_bytes().decode('latin-1').replace('\r\n', '\n')


class ParityTests(unittest.TestCase):
    def test_slot_line_goes_under_the_required_level_once(self):
        tooltip = 'Damage +5.|n|cffffcc00Required level|r: 54|nFlavour'
        once = forsaken_parity.slot_tooltip(tooltip, 'Weapon')
        self.assertEqual(once, 'Damage +5.|n|cffffcc00Required level|r: 54|n|cffffcc00Slot|r: Weapon|nFlavour')
        self.assertEqual(forsaken_parity.slot_tooltip(once, 'Weapon'), once)
        self.assertEqual(forsaken_parity.slot_tooltip('Plain', 'Ring'), 'Plain|n|cffffcc00Slot|r: Ring')

    def test_every_gear_item_has_a_slot_label(self):
        slots = forsaken_parity.gear_slots()
        self.assertGreater(len(slots), 200)
        self.assertEqual(set(slots.values()), set(forsaken_parity.LABELS.values()))

    def test_gaya_strength_counts_once_for_elements(self):
        damage = text(COMBAT / 'Damage.j')
        self.assertIn('set l_val=1.+Damage_ElementDamageBonus(u,l_element,l_physical)', damage)
        self.assertIn("set bonus=bonus-.33333*.5", damage)

    def test_spear_accuracy_from_the_tooltip(self):
        damage = text(COMBAT / 'Damage.j')
        self.assertIn("if Gear_Wears(u,'I033') then", damage)
        self.assertIn("if Gear_Wears(u,'I0D1') then", damage)

    def test_ammunition_element_follows_the_weapon_in_hand(self):
        element = text(COMBAT / 'Element.j')
        self.assertNotIn("Prof_GetLevel(u,'R002')", element)
        self.assertNotIn("Prof_GetLevel(u,'R00M')", element)
        self.assertEqual(element.count('Gear_WieldsWeaponLevel(u,3)'), 1)
        self.assertEqual(element.count('Gear_WieldsWeaponLevel(u,11)'), 2)

    def test_item_spells_have_a_rank_while_cast(self):
        self.assertIn('if l_level<=0 and l_abilId!=0 and GetSpellAbilityId()==l_abilId then',
                      text(COMBAT / 'Abil.j'))


if __name__ == '__main__':
    unittest.main()
