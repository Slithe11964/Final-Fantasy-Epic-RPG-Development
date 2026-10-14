"""-stats shows the Forsaken stat pages as text, with nothing 1.29.2 lacks."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'src/triggers/09 Player features/HeroStats.j'
# Reforged-only natives that 1.29.2 lacks; BlzGetUnitArmor exists in 1.29.2.
REFORGED_ONLY = re.compile(r'\bBlz(?!GetUnitArmor\b)\w+')


def body():
    return re.sub(r'//[^\n]*', '', SOURCE.read_bytes().decode('utf-8').replace('\r\n', '\n'))


class HeroStatsTests(unittest.TestCase):
    def test_no_forsaken_or_reforged_only_names(self):
        text = body()
        self.assertNotRegex(text, r'\bForsaken')
        self.assertIsNone(REFORGED_ONLY.search(text))

    def test_worn_gear_comes_from_the_equipment_pages(self):
        text = body()
        self.assertIn('Gear_WornInSlot(', text)
        self.assertNotRegex(text, r'exitwhen \w+>=15\b')

    def test_four_pages_and_the_chat_command(self):
        text = body()
        for title in ('"Damage bonuses"', '"Defenses"', '"Resistances"', '"Other bonuses"'):
            self.assertIn(title, text)
        self.assertIn('TriggerRegisterPlayerChatEvent(gg_trg_HeroStats_Command,Player(pid),"-stats",false)', text)

    def test_every_called_stat_function_is_defined(self):
        text = body()
        defined = set(re.findall(r'^function (Stats_\w+)', text, re.M))
        called = set(re.findall(r'\b(Stats_\w+)\(', text))
        self.assertEqual(called - defined, set())


if __name__ == '__main__':
    unittest.main()
