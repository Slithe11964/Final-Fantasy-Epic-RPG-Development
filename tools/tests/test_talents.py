"""Talent picks: mastery-gated rows, one choice per row, per player and job, reset, classic dialog."""
from collections import defaultdict
from pathlib import Path
import re
import unittest
from unittest.mock import patch
import test_quest_lifecycle as harness
from bazaar_legacy import convert_talents, convert_all

SOURCE = Path(__file__).resolve().parents[2] / 'src/triggers/03 Jobs and progression/Talents.j'
NAMES = ['Talent_Index', 'Talent_PickIndex', 'Talent_Rank', 'Talent_JobHasTalents', 'Talent_Has', 'Talent_Active',
         'Talent_Choose', 'Talent_ResetJob', 'Talent_RowStatus', 'Talents_InitData']
PRIEST = 12


def runtime():
    world = {'mastery': defaultdict(lambda: 1), 'job': {}, 'messages': [], 'spells': defaultdict(lambda: {'A00G', 'A0TZ', 'A00M'})}
    heroes = {p: ('hero', p) for p in range(8)}
    env = {name: defaultdict(str) for name in ['TalentName', 'TalentText', 'TalentRowLabel']}
    env.update(TalentPick=defaultdict(int), TALENT_ROWS=4, TALENT_ABILITY='tTal', udg_JobCount=22,
               bj_MAX_PLAYERS=24, world=world,
               Player_GetHero=lambda p: heroes.get(p),
               Job_GetIndex=lambda u: world['job'].get(u, PRIEST) if u else -1,
               GetOwningPlayer=lambda u: u[1], GetPlayerId=lambda p: p, I2S=str,
               IMinBJ=min, IMaxBJ=max,
               TALENT_JOB_PRIEST=PRIEST,
               GetUnitAbilityLevel=lambda u, raw: world['mastery'][u] if raw == 'A02F' else int(raw in world['spells'][u]),
               DisplayTimedTextToPlayer=lambda p, x, y, t, text: world['messages'].append((p, text)))
    with patch.object(harness, 'SELECTED', []):
        env = harness.load_engine(SOURCE.read_text(encoding='utf-8'), NAMES, env)
    env['Talents_InitData']()
    return env, heroes


class TalentTests(unittest.TestCase):
    def test_rows_unlock_with_mastery_and_allow_one_choice_each(self):
        e, heroes = runtime()
        hero = heroes[0]
        self.assertTrue(e['Talent_Choose'](0, 1, 2))
        self.assertFalse(e['Talent_Choose'](0, 1, 3))
        self.assertFalse(e['Talent_Choose'](0, 2, 1))
        self.assertTrue(e['Talent_Has'](hero, 1, 2))
        self.assertFalse(e['Talent_Has'](hero, 1, 3))
        for mastery, row in [(2, 2), (3, 3), (4, 4), (7, 4)]:
            e['world']['mastery'][hero] = mastery
            self.assertEqual(e['Talent_Rank'](hero), row)
        e['TalentName'][e['Talent_Index'](PRIEST, 4, 1)] = 'Test talent'
        self.assertTrue(e['Talent_Choose'](0, 4, 1))
        self.assertFalse(e['Talent_Choose'](0, 5, 1))

    def test_players_and_jobs_are_separate_and_reset_clears_only_current_job(self):
        e, heroes = runtime()
        e['Talent_Choose'](0, 1, 1)
        self.assertFalse(e['Talent_Choose'](1, 2, 1))  # rows 2-4 are not written yet
        e['Talent_Choose'](1, 1, 3)
        self.assertTrue(e['Talent_Has'](heroes[1], 1, 3))
        self.assertFalse(e['Talent_Has'](heroes[0], 1, 3))
        e['world']['job'][heroes[0]] = 0
        self.assertFalse(e['Talent_JobHasTalents'](0))
        self.assertFalse(e['Talent_Choose'](0, 1, 1))
        self.assertFalse(e['Talent_ResetJob'](0))
        e['world']['job'][heroes[0]] = PRIEST
        self.assertTrue(e['Talent_Has'](heroes[0], 1, 1))
        self.assertTrue(e['Talent_ResetJob'](0))
        self.assertFalse(e['Talent_Has'](heroes[0], 1, 1))
        self.assertTrue(e['Talent_Has'](heroes[1], 1, 3))
        self.assertTrue(e['Talent_Choose'](0, 1, 2))

    def test_talent_needs_current_priest_job_and_the_spell(self):
        e, heroes = runtime()
        hero = heroes[3]
        self.assertTrue(e['Talent_Choose'](3, 1, 1))
        self.assertTrue(e['Talent_Active'](hero, PRIEST, 1, 1, 'A00G'))
        self.assertFalse(e['Talent_Active'](hero, PRIEST, 1, 2, 'A0TZ'))
        e['world']['spells'][hero].discard('A00G')          # Protect swapped out
        self.assertFalse(e['Talent_Active'](hero, PRIEST, 1, 1, 'A00G'))
        e['world']['spells'][hero].add('A00G')
        e['world']['job'][hero] = 22                        # Freelancer with Protect swapped in
        self.assertFalse(e['Talent_Active'](hero, PRIEST, 1, 1, 'A00G'))
        e['world']['job'][hero] = 1                         # another job
        self.assertFalse(e['Talent_Active'](hero, PRIEST, 1, 1, 'A00G'))
        e['world']['job'][hero] = PRIEST
        self.assertTrue(e['Talent_Active'](hero, PRIEST, 1, 1, 'A00G'))

    def test_lost_mastery_disables_higher_rows_without_forgetting_them(self):
        e, heroes = runtime()
        hero = heroes[2]
        e['world']['mastery'][hero] = 4
        e['TalentName'][e['Talent_Index'](PRIEST, 3, 2)] = 'Test talent'
        self.assertTrue(e['Talent_Choose'](2, 3, 2))
        e['world']['mastery'][hero] = 2
        self.assertFalse(e['Talent_Has'](hero, 3, 2))
        e['world']['mastery'][hero] = 3
        self.assertTrue(e['Talent_Has'](hero, 3, 2))

    def test_classic_conversion_removes_frames_and_uses_the_dialog(self):
        text = SOURCE.read_text(encoding='utf-8')
        classic = convert_talents(text)
        self.assertIn('constant boolean TalentUseFrames=false', classic)
        self.assertNotRegex(classic, r'\bBlz|framehandle|FRAMEEVENT|FRAMEPOINT')
        self.assertIn('call Talent_ShowDialog(p)', classic)
        self.assertEqual(convert_all('function X takes nothing returns nothing\nendfunction\n'),
                         'function X takes nothing returns nothing\nendfunction\n')
        self.assertTrue(classic.endswith('endlibrary\r\n') or classic.rstrip().endswith('endlibrary'))


if __name__ == '__main__':
    unittest.main()
