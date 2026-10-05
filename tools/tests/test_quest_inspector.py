"""Read-only developer inspector uses real engine state and reports legacy log overrides."""
from copy import deepcopy
from pathlib import Path
import unittest
from test_quest_lifecycle import load_engine, SOURCE


class InspectorTests(unittest.TestCase):
    def test_active_and_specific_quest_state_without_mutation(self):
        lines = []
        source = (SOURCE.parents[1] / '11 Developer tools/DevCommands.j').read_text(encoding='utf-8')
        env = {'LIBRARY_TQuestEngine': True, 'I2S': str,
               'DevCommands_Say': lambda p, text: lines.append(text),
               'IsQuestCompleted': lambda entry: entry['completed'], 'IsQuestFailed': lambda entry: entry['failed']}
        e = load_engine(source, ['DevCommands_QuestState'], env)
        q = e['Quest_Define']('Test', e['QUEST_MAIN'], 20, 'icon')
        e['Quest_Custom'](q, 'intro'); e['Quest_Custom'](q, '')
        hidden = e['Quest_Define']('Hidden', e['QUEST_SIDE'], 62, 'icon')
        e['Quest_Custom'](hidden, '')
        e['Quest_StartSilent'](q, None, None)
        e['Quest_LogEntry'](q)['completed'] = True
        # Native JASS arrays already contain null; materialize the mock's lazy default.
        e['Quest_LogEntry'](hidden)
        before = deepcopy({k: e[k] for k in ['QuestState', 'QuestCurrent', 'udg_MainQuest', 'udg_SideQuest', 'udg_QuestsCompleted']})
        e['DevCommands_QuestState'](0, 0)
        self.assertEqual(lines, ['#1 Test: active, step 2/2, MainQuest[20] log completed'])
        lines.clear()
        e['DevCommands_QuestState'](0, hidden)
        self.assertEqual(lines, ['#2 Hidden: hidden, step 0/1, SideQuest[62]'])
        self.assertEqual(before, {k: e[k] for k in before})
        lines.clear()
        e['DevCommands_QuestState'](0, 999)
        self.assertIn('usage:', lines[0])

    def test_engine_disabled_message(self):
        lines = []
        source = (SOURCE.parents[1] / '11 Developer tools/DevCommands.j').read_text(encoding='utf-8')
        e = load_engine(source, ['DevCommands_QuestState'], {'LIBRARY_TQuestEngine': False, 'DevCommands_Say': lambda p, text: lines.append(text)})
        e['DevCommands_QuestState'](0, 0)
        self.assertEqual(lines, ['the QuestEngine module is switched off'])


if __name__ == '__main__':
    unittest.main(verbosity=2)
