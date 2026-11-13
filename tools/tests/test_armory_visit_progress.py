"""Regression coverage for owner-scoped read-only armory inspections."""
from collections import defaultdict
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))

from jtok import functions
from mpq import MPQ
from test_armory_materia import execute
from test_shared_context import mocks

MAPS = (
    ROOT / "release/0.9.7.5h/Armory01/FFERPG-0.9.7.5h-Armory01.w3x",
    ROOT / "release/development/V38/FFERPG-V38.w3x",
)


class ArmoryVisitProgressTests(unittest.TestCase):
    def test_collection_owner_changes_even_when_revisions_match(self):
        for map_path in MAPS:
            with self.subTest(map=map_path.name):
                fs = functions(MPQ(str(map_path)).read("war3map.j").decode())
                source = fs["Armory_PollCounter"]
                selected = set()
                calls = []
                env = mocks(source)
                env.update(
                    GetLocalPlayer=lambda: 0, GetPlayerId=lambda player: player,
                    Player=lambda index: index, IsUnitSelected=lambda unit, viewer: unit in selected,
                    ArmoryViewOwner={1: 2}, udg_ArmoryUnit={1: "shop"},
                    udg_PlayerHouse={2: "house"}, CollectionArmoryRevision={0: 4, 1: 4},
                    ArmoryCounterOwner=-1, ArmoryCounterRevision=-1,
                    Armory_RefreshCounter=calls.append,
                )
                env = execute(source, ["Armory_PollCounter"], env)
                poll = env["Armory_PollCounter"]
                poll()
                selected.add("shop")
                poll()
                poll()
                env["CollectionArmoryRevision"][1] += 1
                poll()
                selected.clear()
                selected.add("house")
                poll()
                selected.clear()
                poll()
                self.assertEqual(calls, [0, 1, 1, 0])
                self.assertIn("Armory_CollectionText(collectionOwner)", fs["Armory_RefreshCounter"])
                self.assertIn("Armory_CountProgress(collectionOwner)", fs["Armory_RefreshCounter"])

    def test_visitor_cannot_withdraw_even_with_same_item(self):
        source = functions(MPQ(str(MAPS[0])).read("war3map.j").decode())["Trig_Armory_Select_CanWithdraw"]
        env = mocks(source)
        env.update(
            GetTriggerUnit=lambda: "shop", GetOwningPlayer=lambda unit: 0,
            GetConvertedPlayerId=lambda player: player + 1,
            ArmoryViewOwner={1: 2}, GetSoldUnit=lambda: "entry",
            BlzGetUnitMaxMana=lambda unit: 5, udg_SaveFlagCount=358,
            udg_SaveFlagForce=defaultdict(int), udg_TitleForce=defaultdict(int),
            IsPlayerInForce=lambda player, force: True,
        )
        env = execute(source, ["Trig_Armory_Select_CanWithdraw"], env)
        self.assertFalse(env["Trig_Armory_Select_CanWithdraw"]())
        env["ArmoryViewOwner"][1] = 0
        self.assertTrue(env["Trig_Armory_Select_CanWithdraw"]())
