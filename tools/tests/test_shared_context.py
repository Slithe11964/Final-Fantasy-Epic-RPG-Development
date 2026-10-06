"""Stage V: execute changed quest source with scratch-variable interference.

The summon test stops after the third hero line; later world-story actions are
covered by the full-function reversal audit, not simulated Warcraft execution.
"""
from collections import defaultdict
import re
import unittest
from test_quest_lifecycle import load_engine, SOURCE
from jtok import functions
from source_checks import invocations
import verify_stage_v
import subprocess
import keyword


def mocks(source):
    env = {}
    for name in set(re.findall(r'\b(?:udg_|gg_)\w+', source)):
        env[name] = defaultdict(lambda: None) if re.search(r'\b' + name + r'\[', source) else 0
    for name in set(functions(source)) | {n for n, _ in invocations(source)}:
        if re.fullmatch(r'[A-Za-z_]\w*', name) and not keyword.iskeyword(name) and name != 'elseif' and not name.startswith('Quest_'):
            env[name] = lambda *args: None
    return env


class SharedContextTests(unittest.TestCase):
    def test_cartographer_grid_uses_its_selected_player_and_owns_every_location(self):
        source = SOURCE.with_name('Cartographer.j').read_text(encoding='utf-8')
        points, samples, removed = [], [], []
        env = mocks(source)
        env.update({'udg_PlayingPlayers': ['explorer'], 'udg_MapExploredPct': 0.,
                    'udg_TempPlayer': 'original scratch', 'udg_TempPoint': 'original point',
                    'bj_forLoopAIndex': 0, 'bj_forLoopBIndex': 0,
                    'bj_forLoopAIndexEnd': 0, 'bj_forLoopBIndexEnd': 0,
                    'Trig_Cartographer_Update_IsFogCheat': lambda: False,
                    'Trig_Cartographer_Update_IsFogCheatFlagged': lambda: False,
                    'Trig_Cartographer_Update_IsMapQuestActive': lambda: False,
                    'Trig_Cartographer_Update_HasNewRewardTier': lambda: False,
                    'ForcePickRandomPlayer': lambda force: force[0], 'I2R': float,
                    'GetPlayableMapRect': lambda: (0., 0., 200., 100.),
                    'GetRectMinX': lambda r: r[0], 'GetRectMinY': lambda r: r[1],
                    'GetRectWidthBJ': lambda r: r[2], 'GetRectHeightBJ': lambda r: r[3],
                    'RemoveLocation': removed.append})
        def location(x, y):
            e['udg_TempPlayer'] = 'nested player'
            e['udg_TempPoint'] = 'nested point'
            point = (x, y); points.append(point)
            return point
        def masked(point, player):
            samples.append((point, player))
            return point[0] > 100.
        env.update(Location=location, IsLocationMaskedToPlayer=masked)
        e = load_engine(source, ['Trig_Cartographer_Update_IsPointExplored', 'Trig_Cartographer_Update_Actions'], env)
        e['GetForLoopIndexA'] = lambda: e['bj_forLoopAIndex']
        e['GetForLoopIndexB'] = lambda: e['bj_forLoopBIndex']
        e['Trig_Cartographer_Update_Actions']()
        self.assertEqual(e['udg_MapExploredPct'], 50.)
        self.assertEqual(len(samples), 2500)
        self.assertTrue(all(player == 'explorer' for _, player in samples))
        self.assertEqual(points, removed)
        self.assertEqual(e['udg_TempPlayer'], 'nested player')

    def test_true_ice_age_selected_speaker_survives_waits_and_dialogue(self):
        class IntroFinished(Exception):
            pass
        for nearby in [True, False]:
            with self.subTest(nearby=nearby):
                source = SOURCE.with_name('TrueIceAge.j').read_text(encoding='utf-8')
                env = mocks(source)
                heroes = [{'owner': 'nearby'}] if nearby else []
                destroyed, dialogue = [], []
                env.update({'QUEST_TRUE_ICE_AGE': 1, 'udg_PlayingPlayers': ['fallback'],
                            'udg_TempPlayer': 'scratch', 'udg_TempGroup': 'scratch group',
                            'bj_CINEFADETYPE_FADEOUT': 0, 'bj_CINEFADETYPE_FADEIN': 1,
                            'GetUnitLoc': lambda u: (0., 0.), 'GetRectCenter': lambda r: (0., 0.),
                            'Group_UnitsInRangeOfLoc': lambda *a: heroes,
                            'IsUnitGroupEmptyBJ': lambda group: len(group) == 0,
                            'GroupPickRandomUnit': lambda group: group[0],
                            'GetOwningPlayer': lambda u: u['owner'],
                            'ForcePickRandomPlayer': lambda force: force[0],
                            'DestroyGroup': destroyed.append, 'Condition': lambda fn: fn,
                            'Player_GetHero': lambda p: 'hero/' + str(p),
                            'Player': lambda i: i, 'GetLastCreatedUnit': lambda: 'demon actor'})
                def interfere(*args):
                    e['udg_TempPlayer'] = 'nested player'
                    e['udg_TempGroup'] = ['nested group']
                def say(speaker, text, *args):
                    dialogue.append((speaker, text))
                    interfere()
                    if text.startswith("Suddenly I'm not sure"):
                        raise IntroFinished
                env.update(Wait_Polled=interfere, Text_Say=say)
                e = load_engine(source, ['Trig_TrueIceAge_Summon_AnyHeroNearby', 'Trig_TrueIceAge_Summon_Actions'], env)
                q = e['Quest_Define']('Test', e['QUEST_MAIN'], 20, 'icon')
                self.assertEqual(q, 1)
                e['Quest_Custom'](q, 'intro'); e['Quest_Custom'](q, '')
                with self.assertRaises(IntroFinished):
                    e['Trig_TrueIceAge_Summon_Actions']()
                speakers = [speaker for speaker, _ in dialogue if speaker.startswith('hero/')]
                self.assertEqual(speakers, ['hero/' + ('nearby' if nearby else 'fallback')] * 3)
                self.assertEqual(destroyed, [heroes])

    def test_every_changed_source_function_reverses_to_stage_u(self):
        for module in ['Cartographer', 'TrueIceAge']:
            old = subprocess.check_output(['git', 'show', '64809ce:' + verify_stage_v.FOLDER + module + '.j'], cwd=verify_stage_v.ROOT).decode()
            new = SOURCE.with_name(module + '.j').read_text(encoding='utf-8')
            verify_stage_v.compare(old, new, module)


if __name__ == '__main__':
    unittest.main(verbosity=2)
