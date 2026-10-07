"""Execute quest definitions/hooks and all three blue-girl spawn branches."""
from collections import defaultdict
from pathlib import Path
import unittest

from test_quest_lifecycle import load_engine

SOURCE = Path(__file__).resolve().parents[2] / 'src/triggers/06 Quests and story'


class HuntOfferTests(unittest.TestCase):
    def test_acceptance_unlocks_harpies_without_completing_spiders(self):
        scheduled = []
        destroyed = []
        source = '\n'.join((SOURCE / name).read_text() for name in
                           ['Quest_Arachnophobia.j', 'Quest_HarpyHunt.j'])
        names = ['Quest_Talk', 'Quest_Return', 'Quest_Hunt', 'Quest_HuntTarget',
                 'Quest_Say', 'Quest_Reward', 'Quest_OnDone', 'Quest_Message',
                 'Quest_MakeAvailable', 'QuestArachnophobia_Define',
                 'QuestArachnophobia_Started', 'QuestArachnophobia_OfferHarpyHunt',
                 'QuestArachnophobia_Done', 'QuestHarpyHunt_Define',
                 'QuestHarpyHunt_Available']
        env = load_engine(source, names, {
            'QUEST_ARACHNOPHOBIA': 0, 'QUEST_HARPY_HUNT': 0,
            'gg_unit_n009_0051': 'Kollin', 'gg_unit_n0B3_0049': 'Caroline',
            'udg_CommonHuntsDone': 0, 'udg_HuntStock': defaultdict(int),
            'gg_trg_Hunt_Board_Markers': 'markers',
            'CreateTimer': object, 'GetExpiredTimer': lambda: 'expired',
            'DestroyTimer': destroyed.append,
            'TimerStart': lambda timer, seconds, repeat, callback: scheduled.append((seconds, repeat, callback)),
            'SaveBoolean': lambda *args: None, 'Quest_PingUnit': lambda *args: None,
            'AddSpecialEffectTarget': lambda *args: 'marker',
            'UnitAddAbility': lambda *args: None, 'AddUnitToStockBJ': lambda *args: None,
        })
        env['QuestArachnophobia_Define']()
        q = env['QUEST_ARACHNOPHOBIA']
        stride = env['QUEST_MAX_STEPS']
        self.assertEqual(env['QUEST_HARPY_HUNT'], 0)
        env[env['QuestStepHook'][q * stride + 1]]()
        self.assertEqual([(s, r) for s, r, _ in scheduled], [(2., False)])
        scheduled.pop()[2]()
        h = env['QUEST_HARPY_HUNT']
        self.assertEqual(env['QuestState'][h], env['QUEST_STATE_AVAILABLE'])
        self.assertEqual(env['udg_CommonHuntsDone'], 0)
        self.assertEqual(destroyed, ['expired'])
        self.assertEqual((env['QuestStepBoard'][q * stride + 2], env['QuestStepNeeded'][q * stride + 2]), (1, 15))
        self.assertEqual((env['QuestStepBoard'][h * stride + 2], env['QuestStepNeeded'][h * stride + 2]), (2, 20))
        env['QuestState'][h] = env['QUEST_STATE_ACTIVE']
        env['QuestCurrent'][h] = 2
        env['QuestArachnophobia_Done']()
        env['QuestHarpyHunt_Available']()
        self.assertEqual(env['QuestCurrent'][h], 2)
        self.assertEqual(env['QuestState'][h], env['QUEST_STATE_ACTIVE'])
        self.assertEqual(env['udg_CommonHuntsDone'], 1)
        self.assertEqual(env['udg_HuntStock'][1], 1)
        self.assertFalse(scheduled)


class BlueGirlTests(unittest.TestCase):
    def test_every_visit_stays_stationary_with_five_minute_timer(self):
        source = (SOURCE / 'Bernkastel.j').read_text()
        for visit, trigger in [(0, 'first'), (2, 'second'), (3, 'hint')]:
            with self.subTest(visit=visit):
                calls = []
                stage = defaultdict(int)
                def party(force, callback):
                    stage[0] = visit
                env = load_engine(source, [
                    'Trig_Bernkastel_Try_Spawn_Cond_NeverMet',
                    'Trig_Bernkastel_Try_Spawn_Cond_FirstVisitRoll',
                    'Trig_Bernkastel_Try_Spawn_Cond_SecondVisitDue',
                    'Trig_Bernkastel_Try_Spawn_Cond_ThirdVisitRoll',
                    'Trig_Bernkastel_Try_Spawn_Actions'], {
                    'udg_MiracleStage': stage, 'udg_TempInteger': 0,
                    'udg_TempPoint': None, 'udg_BlueGirl': None,
                    'udg_PlayingPlayers': 'party', 'gg_rct_572': 'spawn',
                    'udg_BlueGirlTimer': 'timer', 'PLAYER_COLOR_BLUE': 'blue',
                    'gg_trg_Bernkastel_First_Talk': 'first',
                    'gg_trg_Bernkastel_Second_Talk': 'second',
                    'gg_trg_Bernkastel_Hint_Talk': 'hint',
                    'Trig_Bernkastel_Try_Spawn_Enum_SumLuck': lambda: None,
                    'ForForce': party, 'GetRandomInt': lambda *args: 1,
                    'GetRectCenter': lambda rect: rect, 'Player': lambda i: i,
                    'CreateNUnitsAtLoc': lambda *args: None,
                    'RemoveLocation': lambda *args: None,
                    'GetLastCreatedUnit': lambda: 'girl',
                    'SetUnitColor': lambda *args: None,
                    'SetUnitVertexColorBJ': lambda *args: None,
                    'PauseUnit': lambda *args: calls.append(('pause', *args)),
                    'SetUnitPropWindow': lambda *args: calls.append(('movement', *args)),
                    'StartTimerBJ': lambda *args: calls.append(('timer', *args)),
                    'EnableTrigger': lambda *args: calls.append(('talk', *args)),
                })
                env['Trig_Bernkastel_Try_Spawn_Actions']()
                self.assertEqual(calls, [('pause', 'girl', True), ('movement', 'girl', 0.),
                                         ('timer', 'timer', False, 300.), ('talk', trigger)])


if __name__ == '__main__':
    unittest.main()
