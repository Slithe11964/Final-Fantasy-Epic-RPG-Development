"""Exercise the actual QuestEngine lifecycle source with mocked Warcraft natives.

This deliberately supports only the JASS syntax used by these functions, including
their integer divisions; it is not a game simulator. Compilation and in-game
cinematics are checked separately.
Run: python tools/tests/test_quest_lifecycle.py
"""
from collections import defaultdict
from pathlib import Path
import re
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from jtok import functions, strip_comments, tokens

SOURCE = Path(__file__).resolve().parents[2] / 'src/triggers/06 Quests and story/QuestEngine.j'
SELECTED = ['Quest_Define', 'Quest_AddStep', 'Quest_Custom', 'Quest_Color', 'Quest_NotStory',
            'Quest_NoMarker', 'Quest_LogEntry', 'Quest_AliasMain', 'Quest_CompletionItem',
            'Quest_AnnounceStart', 'QuestEngine_Finish', 'Quest_StepDone', 'Quest_Start',
            'Quest_StartSilent', 'Quest_Fail', 'Quest_IsActive', 'Quest_IsDone',
            'Quest_IsFailed', 'Quest_CurrentStep']


def expression(source):
    rename = {'null': 'None', 'true': 'True', 'false': 'False', 'function': '', '/': '//'}
    return ' '.join(rename.get(token, token) for token in tokens(source))


def load_engine(extra_source='', extra_names=(), extra_env=None):
    source = SOURCE.read_text(encoding='utf-8') + '\n' + extra_source
    env = {'LIBRARY_TQuestCount': True, 'udg_MainQuest': defaultdict(lambda: None),
           'udg_SideQuest': defaultdict(lambda: None), 'udg_QuestsCompleted': 0,
           'udg_StoryProgress': 0, 'udg_ColorGold': '|cffffcc00',
           'bj_QUESTTYPE_REQ_DISCOVERED': 0, 'bj_QUESTMESSAGE_DISCOVERED': 'new',
           'bj_QUESTMESSAGE_UPDATED': 'updated', 'bj_QUESTMESSAGE_COMPLETED': 'done',
           'bj_QUESTMESSAGE_FAILED': 'failed', 'gg_trg_QuestCount_Milestones': object()}
    defaults = {'integer': 0, 'real': 0., 'boolean': False, 'string': ''}
    block = re.search(r'\nglobals\n(.*?)\nendglobals', source, re.S)[1]
    for line in strip_comments(block).splitlines():
        match = re.fullmatch(r'\s*(?:constant\s+)?(\w+)\s+(array\s+)?(\w+)(?:=(.*))?\s*', line)
        if not match:
            assert not line.strip(), line
            continue
        kind, array, name, value = match.groups()
        default = defaults.get(kind)
        env[name] = defaultdict(lambda d=default: d) if array else eval(expression(value), env) if value else default

    events = []
    env['events'] = events
    def log(kind, *args):
        events.append((kind, *args, env['udg_QuestsCompleted']))
    def create_quest(kind, name, description, icon):
        entry = {'name': name, 'description': description, 'completed': False, 'failed': False}
        log('create', entry)
        return entry
    def mark(entry, field, value):
        entry[field] = value
        log(field, value)
    env.update({'InitHashtable': lambda: {}, 'CreateQuestBJ': create_quest,
                'GetPlayersAll': lambda: 'all',
                'QuestMessageBJ': lambda audience, kind, text: log('message', audience, kind, text),
                'QuestSetDescriptionBJ': lambda entry, text: mark(entry, 'description', text),
                'QuestSetCompletedBJ': lambda entry, value: mark(entry, 'completed', value),
                'QuestSetFailedBJ': lambda entry, value: mark(entry, 'failed', value),
                'QuestItemSetDescriptionBJ': lambda item, text: mark(item, 'item_text', text),
                'QuestItemSetCompletedBJ': lambda item, value: mark(item, 'item_done', value)})
    for name in ['DisableTrigger', 'DestroyTrigger', 'DestroyEffect', 'FlushChildHashtable',
                 'GroupRemoveUnit', 'QuestEngine_Dialogue', 'QuestEngine_MoveMarker',
                 'ConditionalTriggerExecute']:
        env[name] = lambda *args: None
    env['GetHandleId'] = id
    def begin(q):
        env['QuestCurrent'][q] += 1
    env['QuestEngine_BeginStep'] = begin
    env['QuestEngine_BeginPending'] = lambda: begin(env['QuestPendingQuest'])
    env['ExecuteFunc'] = lambda name: env[name]()
    env.update(extra_env or {})

    for name in SELECTED + list(extra_names):
        body = strip_comments(functions(source)[name]).strip().splitlines()
        match = re.match(r'function \w+ takes (.*?) returns \w+', body[0])
        params = [] if match[1] == 'nothing' else [p.strip().split()[1] for p in match[1].split(',')]
        locals_ = {re.match(r'\s*local \w+ (\w+)', line)[1] for line in body if re.match(r'\s*local \w+ (\w+)', line)}
        globals_ = set(env) - set(params) - locals_
        code = [f'def {name}({", ".join(params)}):', '    global ' + ', '.join(sorted(globals_))]
        level = 1
        for raw in body[1:-1]:
            line = raw.strip()
            if not line:
                continue
            if line in ('endif', 'endloop'):
                level -= 1
                continue
            if line.startswith(('elseif ', 'else')):
                level -= 1
            if line.startswith('local '):
                match = re.fullmatch(r'local (\w+) (\w+)(?:=(.*))?', line)
                line = match[2] + ' = ' + (expression(match[3]) if match[3] else repr(defaults.get(match[1])))
            elif line.startswith('set '):
                line = expression(line[4:])
            elif line.startswith('call '):
                line = expression(line[5:])
            elif re.match(r'(?:static )?if(?=[\s(])', line):
                line = 'if ' + expression(re.sub(r'^(?:static )?if\s*|\s*then$', '', line)) + ':'
            elif line.startswith('elseif '):
                line = 'elif ' + expression(line[7:-5]) + ':'
            elif line == 'else':
                line = 'else:'
            elif line == 'loop':
                line = 'while True:'
            elif line.startswith('exitwhen '):
                line = 'if ' + expression(line[9:]) + ': break'
            elif line.startswith('return'):
                line = 'return ' + expression(line[6:])
            else:
                raise AssertionError(f'Unsupported JASS in {name}: {line}')
            code.append('    ' * level + line)
            if line.endswith(':'):
                level += 1
        exec('\n'.join(code), env)
    return env


class LifecycleTests(unittest.TestCase):
    def setUp(self):
        self.e = load_engine()

    def quest(self, name='Test', kind='QUEST_SIDE', index=61):
        e = self.e
        q = e['Quest_Define'](name, e[kind], index, 'icon')
        e['Quest_NotStory'](q)
        e['Quest_NoMarker'](q)
        e['Quest_Custom'](q, 'description')
        e['Quest_Custom'](q, '')
        return q

    def messages(self):
        return [event[2] for event in self.e['events'] if event[0] == 'message']

    def test_existing_normal_start_and_completion(self):
        e, q = self.e, self.quest()
        e['Quest_Start'](q, None, None)
        self.assertEqual(self.messages(), ['new'])
        self.assertEqual(e['events'][0][0], 'message')
        self.assertEqual(e['Quest_CurrentStep'](q), 2)
        e['Quest_StepDone'](q, None, None)
        e['Quest_StepDone'](q, None, None)
        self.assertEqual(self.messages(), ['new', 'done'])
        self.assertEqual(e['udg_QuestsCompleted'], 1)

    def test_silent_log_then_delayed_announcement_once(self):
        e, q = self.e, self.quest()
        e['Quest_StartSilent'](q, None, None)
        self.assertTrue(e['Quest_IsActive'](q))
        self.assertEqual(e['Quest_LogEntry'](q)['description'], 'description')
        self.assertEqual(self.messages(), [])
        e['Quest_AnnounceStart'](q)
        e['Quest_AnnounceStart'](q)
        self.assertEqual(self.messages(), ['new'])
        e['Quest_StartSilent'](q, None, None)
        self.assertEqual(e['Quest_CurrentStep'](q), 2)

    def test_cartographer_completes_during_intro_without_new_message(self):
        e, q = self.e, self.quest('Cartographer')
        e['Quest_StartSilent'](q, None, None)
        item = {}
        e['Quest_CompletionItem'](q, item, 'Sufficiently explored!')
        e['Quest_StepDone'](q, None, None)
        e['Quest_AnnounceStart'](q)
        self.assertEqual(self.messages(), ['done'])
        self.assertEqual(item, {'item_text': 'Sufficiently explored!', 'item_done': True})
        self.assertEqual([x[0] for x in e['events']], ['create', 'message', 'completed', 'item_text', 'item_done'])
        self.assertTrue(all(x[-1] == 0 for x in e['events']))
        self.assertEqual(e['udg_QuestsCompleted'], 1)
        self.assertEqual(e['udg_StoryProgress'], 0)

    def test_actual_cartographer_reports_pay_unpaid_tiers_and_finish_at_90_percent(self):
        rewards = []
        e = load_engine(SOURCE.with_name('Cartographer.j').read_text(encoding='utf-8'),
                        ['Trig_Cartographer_Report_IsMapDone_Quiet',
                         'Trig_Cartographer_Report_IsMapDone_Talk',
                         'Trig_Cartographer_Report_IsDialogueOn',
                         'Trig_Cartographer_Report_Actions'],
                        {'QUEST_CARTOGRAPHER': 0, 'udg_MapRewardStage': 0,
                         'udg_MapExploredPct': 0., 'udg_MontblancHasNews': True,
                         'udg_TempInteger': 0, 'bj_forLoopAIndex': 0, 'bj_forLoopAIndexEnd': 0,
                         'udg_MapRewardTier': [1000, 2000, 3000, 4000, 6000, 8000],
                         'udg_CinematicsDisabled': True, 'udg_SpecialEffect': defaultdict(lambda: None),
                         'gg_unit_n0CE_0020': object(), 'gg_trg_Cartographer_Update': object(),
                         'gg_trg_Cartographer_Fail': object(),
                         'GetTriggeringTrigger': lambda: None, 'GetTriggerPlayer': lambda: None,
                         'GetTriggerUnit': lambda: None, 'DestroyEffectBJ': lambda *args: None,
                         'AddSpecialEffectTargetUnitBJ': lambda *args: object(), 'R2I': int,
                         'Reward_GiveAll': lambda gold, xp, unit: rewards.append((gold, xp))})
        e['GetForLoopIndexA'] = lambda: e['bj_forLoopAIndex']
        self.e = e
        q = self.quest('Cartographer')
        e['QUEST_CARTOGRAPHER'] = q
        e['Quest_StartSilent'](q, None, None)
        e['Quest_AnnounceStart'](q)
        for percent, expected in [(15., 1000), (45., 5000), (45., 0), (90., 18000)]:
            e['udg_MapExploredPct'] = percent
            e['Trig_Cartographer_Report_Actions']()
            self.assertEqual(rewards[-1], (expected, expected))
            self.assertEqual(e['udg_QuestsCompleted'], int(percent >= 90.))
        self.assertEqual(sum(gold for gold, _ in rewards), 24000)
        self.assertTrue(e['Quest_IsDone'](q))
        self.assertEqual(self.messages(), ['new', 'done'])

    def test_true_ice_age_shared_log_and_retry_then_single_completion(self):
        e, q = self.e, self.quest('True Ice Age', 'QUEST_MAIN', 20)
        e['Quest_StartSilent'](q, None, None)
        for index in [8, 9, 11, 19]:
            e['Quest_AliasMain'](q, index)
        log = e['udg_MainQuest'][20]
        self.assertTrue(all(e['udg_MainQuest'][index] is log for index in [8, 9, 11, 19]))
        e['Quest_AnnounceStart'](q)
        # Battle timeouts have no engine lifecycle call: the same step survives the retry.
        self.assertTrue(e['Quest_IsActive'](q))
        e['Quest_StepDone'](q, None, None)
        e['Quest_StepDone'](q, None, None)
        self.assertTrue(all(e['udg_MainQuest'][index]['completed'] for index in [8, 9, 11, 19, 20]))
        self.assertEqual(e['udg_QuestsCompleted'], 1)
        self.assertEqual(e['udg_StoryProgress'], 0)
        self.assertEqual(self.messages(), ['new', 'done'])

    def test_cartographer_failure_once_without_completion_or_count(self):
        e, q = self.e, self.quest('Cartographer')
        e['Quest_StartSilent'](q, None, None)
        e['Quest_Fail'](q)
        e['Quest_Fail'](q)
        e['Quest_AnnounceStart'](q)
        self.assertTrue(e['Quest_IsFailed'](q))
        self.assertEqual(self.messages(), ['failed'])
        self.assertEqual(e['udg_QuestsCompleted'], 0)

    def test_silent_start_does_not_change_other_quests(self):
        e, first, second = self.e, self.quest('Silent'), self.quest('Normal')
        e['Quest_StartSilent'](first, None, None)
        e['Quest_Start'](second, None, None)
        self.assertEqual(self.messages(), ['new'])
        self.assertFalse(e['QuestStartSilent'][second])
        e['Quest_StartSilent'](0, None, None)
        e['Quest_AnnounceStart'](0)
        e['Quest_AliasMain'](second, 8)
        self.assertIsNone(e['udg_MainQuest'][8])


if __name__ == '__main__':
    unittest.main(verbosity=2)
