"""Exercise the actual teleporter dev helper and the existing single-player gate."""
from collections import defaultdict
import unittest
from unittest.mock import patch
import test_quest_lifecycle as harness
from test_shared_context import mocks
from source_checks import ROOT


class DevTeleporterTests(unittest.TestCase):
    def test_unlock_rebuilds_destinations_and_repeated_command_does_not_duplicate_effects(self):
        source = (ROOT/'src/triggers/11 Developer tools/DevCommands.j').read_text(encoding='utf-8')
        env = mocks(source)
        effects, rebuilt, said = [], [], []
        unlocked = defaultdict(bool, {0: True, 2: True})
        handles = defaultdict(lambda: None, {2: 'existing'})
        def effect(path, x, y):
            effects.append((path, x, y))
            return 'effect'+str(len(effects))
        env.update(LIBRARY_TWarp=True, DEV_COMMANDS_ON=True, udg_PlayingPlayers=[0],
                   udg_TravelCount=6, udg_WarpUnlocked=unlocked, udg_WarpEffect=handles,
                   udg_TravelX=defaultdict(int), udg_TravelY=defaultdict(int),
                   CountPlayersInForceBJ=len, AddSpecialEffect=effect,
                   Warp_HideDialog=lambda: None,
                   DevCommands_Say=lambda p, text: said.append(text),
                   Trig_Quest_52_Scorching_TravelDialog_Rebuild=lambda: rebuilt.append(True))
        with patch.object(harness, 'SELECTED', []):
            e = harness.load_engine(source, ['DevCommands_Active', 'DevCommands_UnlockTeleporters'], env)
        self.assertTrue(e['DevCommands_Active']())
        e['udg_PlayingPlayers'] = [0, 1]
        self.assertFalse(e['DevCommands_Active']())
        e['udg_PlayingPlayers'] = [0]
        e['DevCommands_UnlockTeleporters'](0)
        self.assertTrue(all(unlocked[i] for i in range(7)))
        self.assertEqual(len(effects), 5)
        self.assertEqual(handles[2], 'existing')
        e['DevCommands_UnlockTeleporters'](0)
        self.assertEqual(len(effects), 5)
        self.assertEqual(len(rebuilt), 2)
        e['udg_TravelCount'] = 0
        e['DevCommands_UnlockTeleporters'](0)
        self.assertIn('not initialized', said[-1])
        self.assertEqual(len(rebuilt), 2)


if __name__ == '__main__':
    unittest.main()
