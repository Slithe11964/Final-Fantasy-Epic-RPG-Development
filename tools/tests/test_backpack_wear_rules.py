"""Gear on an equipment page follows the original Equip rules: Spirit of Gaya level, Legendary
Masters for job gear, one of each piece, and two weapons only with Dual Wield."""
import unittest
from pathlib import Path
from unittest.mock import patch
import test_quest_lifecycle as harness

SOURCE = Path(__file__).resolve().parents[2] / 'src/triggers/05 Items crafting and shops/Backpack.j'
KINDS = {'sword': 1, 'dagger': 1, 'shield': 2, 'helm': 3, 'cap': 3}


class WearRuleTests(unittest.TestCase):
    def setUp(self):
        self.pages = {0: [None] * 6, 1: [None] * 6, 2: [None] * 6}
        self.life = {}
        self.level = {}
        self.gaya = 20
        self.jobs = {}
        self.dual = False
        self.messages = []
        self.dropped = []

        def store(pid, holder, item):
            for page in range(2, 3):
                if None in self.pages[page]:
                    self.pages[holder][self.pages[holder].index(item)] = None
                    self.pages[page][self.pages[page].index(None)] = item
                    return True
            return False

        def remove(holder, item):
            self.pages[holder][self.pages[holder].index(item)] = None
            self.dropped.append(item)

        env = dict(
            BACKPACK_SLOTS=6, BACKPACK_EQUIPMENT_PAGES=2, BACKPACK_LOCKED='tBlk', GEAR_KINDS=8,
            GEAR_PRIMARY=1, GEAR_OFFHAND=2, GEAR_BOOTS=6, GEAR_RING=7, GEAR_TRINKET=8,
            BackpackHolder={0: 0, 1: 1}, BackpackKindSeen={k: 0 for k in range(9)},
            udg_SpeedrunFlag={4: False}, udg_PlayingPlayers={0}, udg_DarkJobsUnlocked=False,
            udg_PlayerName={1: 'Jake'}, udg_SpiritOfGaya={1: 'gaya'},
            Player=lambda pid: pid, Player_GetHero=lambda p: 'hero',
            IsPlayerInForce=lambda p, force: p in force,
            GetHeroLevel=lambda u: self.gaya, I2R=float, R2I=int, I2S=str,
            GetWidgetLife=lambda item: self.life.get(item, 1.),
            GetItemLevel=lambda item: self.level.get(item, 0),
            GetItemName=lambda item: item, GetItemTypeId=lambda item: item or 0,
            Gear_KindOf=lambda raw: KINDS.get(raw, 0), Gear_KindName=str,
            # The harness keeps rawcodes as text, so job level 100 ('d') is compared as text too.
            Job_GetSavedLevel=lambda p, job: self.jobs.get(job, 'a'),
            GetUnitAbilityLevel=lambda u, raw: 1 if raw == 'A0HP' and self.dual else 0,
            UnitItemInSlot=lambda holder, slot: self.pages[holder][slot],
            Backpack_Store=store, UnitRemoveItem=remove, SetItemPosition=lambda *a: None,
            GetUnitX=lambda u: 0., GetUnitY=lambda u: 0.,
            DisplayTimedTextToPlayer=lambda p, x, y, t, text: self.messages.append(text),
            Backpack_ApplyBonuses=lambda pid: None)
        names = ['Backpack_WearBlock', 'Backpack_Refuse', 'Backpack_PageLimit', 'Backpack_CheckPage',
                 'Gear_WornWeapons']
        with patch.object(harness, 'SELECTED', []):
            self.e = harness.load_engine(SOURCE.read_text(), names, env)

    def wear(self, *items):
        for slot, item in enumerate(items):
            self.pages[0][slot] = item
        self.e['Backpack_CheckPage'](0, 0)
        return [i for i in self.pages[0] if i]

    def test_gaya_level_gates_wearing_but_not_carrying(self):
        self.life['helm'] = 30.
        self.assertEqual(self.wear('helm'), [])
        self.assertIn('helm', self.pages[2])
        self.assertIn('your Spirit of Gaya must be at least Level 30', self.messages[0])
        self.gaya = 30
        self.pages[2] = [None] * 6
        self.assertEqual(self.wear('helm'), ['helm'])

    def test_job_gear_needs_a_legendary_master(self):
        self.life['sword'] = 145.
        self.level['sword'] = 2
        self.assertEqual(self.wear('sword'), [])
        self.assertIn('you must have a Legendary Master Knight', self.messages[0])
        self.jobs['H003'] = 'd'
        self.pages[2] = [None] * 6
        self.assertEqual(self.wear('sword'), ['sword'])

    def test_refused_gear_is_dropped_when_the_bag_is_full(self):
        self.life['helm'] = 99.
        self.pages[2] = ['x'] * 6
        self.assertEqual(self.wear('helm'), [])
        self.assertEqual(self.dropped, ['helm'])
        self.assertIn('so it was dropped', self.messages[0])

    def test_wearing_gear_ends_the_no_gear_accolade(self):
        self.assertFalse(self.e['udg_SpeedrunFlag'][4])
        self.wear('cap')
        self.assertTrue(self.e['udg_SpeedrunFlag'][4])

    def test_two_weapons_only_with_dual_wield(self):
        self.assertEqual(self.wear('sword', 'dagger'), ['sword'])
        self.pages = {0: [None] * 6, 1: [None] * 6, 2: [None] * 6}
        self.dual = True
        self.assertEqual(self.wear('sword', 'dagger'), ['sword', 'dagger'])
        self.assertEqual(self.e['Gear_WornWeapons'](0), 2)

    def test_dual_wield_still_has_only_two_hands(self):
        self.dual = True
        self.assertEqual(self.wear('shield', 'sword', 'dagger'), ['shield', 'sword'])
        self.assertIn('both of your hands', self.messages[0])


if __name__ == '__main__':
    unittest.main()
