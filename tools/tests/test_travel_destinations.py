"""Exercise a travel entry event while membership queries are still stale."""
from collections import defaultdict
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from source_checks import ROOT
from test_shared_context import mocks
from test_armory_materia import execute


class TravelEntryTests(unittest.TestCase):
    def test_event_region_unlocks_only_entered_stop_and_opens_menu(self):
        source = (ROOT / 'src/triggers/08 World and travel/Warp.j').read_text(encoding='utf-8')
        state = mocks(source)
        shown, effects, rebuilt = [], [], []
        state.update(udg_TravelCount=13, udg_TravelRegion=dict((i, i) for i in range(1, 14)),
                     udg_WarpUnlocked=defaultdict(bool), udg_WarpEffect={},
                     udg_TravelX=dict((i, i * 10) for i in range(1, 14)),
                     udg_TravelY=dict((i, i * 20) for i in range(1, 14)),
                     udg_PlayingPlayers={0}, udg_WarpDialog='menu',
                     GetTriggerUnit=lambda: 'hero', GetTriggeringRegion=lambda: 12,
                     IsUnitInRegion=lambda *args: False,
                     GetOwningPlayer=lambda u: 0,
                     DialogDisplay=lambda *args: shown.append(args),
                     Travel_Show=lambda p,page:shown.append((p,'menu',True)),
                     ForForce=lambda *args: None,
                     AddSpecialEffect=lambda *args: effects.append(args) or 'effect',
                     Trig_Quest_52_Scorching_TravelDialog_Rebuild=lambda: rebuilt.append(True),
                     IssueImmediateOrderById=lambda *args: None)
        runtime = execute(source, ['Warp_OnEnterPoint'], state)
        runtime['Warp_OnEnterPoint']()
        self.assertTrue(runtime['udg_WarpUnlocked'][12])
        self.assertFalse(runtime['udg_WarpUnlocked'][13])
        self.assertEqual(shown, [(0, 'menu', True)])
        runtime['Warp_OnEnterPoint']()
        self.assertEqual(len(effects), 1)
        self.assertEqual(len(rebuilt), 1)

    def test_original_destination_indexes_are_preserved(self):
        source = (ROOT / 'src/triggers/08 World and travel/Travel.j').read_text(encoding='utf-8')
        calls = [line for line in source.splitlines() if 'call Travel_AddDestination(' in line]
        self.assertEqual(len(calls), 13)
        self.assertIn('gg_rct_403', calls[8])
        self.assertIn('gg_rct_456', calls[9])
        self.assertIn('gg_rct_402', calls[10])
        self.assertIn('gg_rct_Shipyard', calls[11])
        self.assertIn('gg_rct_ArenaDarkness', calls[12])


if __name__ == '__main__':
    unittest.main()
