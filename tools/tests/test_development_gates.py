"""Regression cases for build refusal, quest definitions and save compatibility."""
from copy import deepcopy
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from build_stage import outputs, refuse_existing
from check_quests import validate, waiting_chain
from check_save_compat import assignments, compare, fixtures_check, CONTRACT
from source_checks import ROOT, sources
import savecode
from jtok import functions
import check_content

ENGINE_STUB = '''library TQuestEngine
function Quest_Define takes string name,integer kind,integer index,string icon returns integer
return 1
endfunction
function Quest_Custom takes integer q,string text returns nothing
endfunction
function Quest_Talk takes integer q,unit npc,string text returns nothing
endfunction
function Quest_Hunt takes integer q,integer row,integer count,string label,string text returns nothing
endfunction
function Quest_OnDone takes integer q,string hook returns nothing
endfunction
endlibrary
'''


def quest_source(steps='call Quest_Custom(q,"test")', extra=''):
    return {'QuestEngine': ENGINE_STUB, 'Test': '''library TTest requires TQuestEngine
function DefineTest takes nothing returns nothing
local integer q=Quest_Define("Test",QUEST_SIDE,61,"icon")
set QUEST_TEST=q
''' + steps + '\nendfunction\n' + extra + '\nendlibrary\n'}


class QuestChecksTests(unittest.TestCase):
    def check(self, texts):
        return validate(texts)[0]

    def test_valid_definition_and_inspection(self):
        errors, notes, rows = validate(quest_source())
        self.assertEqual(errors, [])
        self.assertEqual(rows[0]['steps'][0]['type'], 'Custom')
        self.assertEqual(rows[0]['index'], 61)

    def test_step_capacity(self):
        self.assertTrue(any('limit is 16' in e for e in self.check(quest_source('\n'.join(['call Quest_Custom(q,"x")'] * 17)))))

    def test_wrong_argument_count_is_diagnostic(self):
        self.assertTrue(any('argument count' in e for e in self.check(quest_source('call Quest_Hunt(q)'))))

    def test_invalid_hunt_row_and_count(self):
        errors = self.check(quest_source('call Quest_Hunt(q,17,0,"label","log")'))
        self.assertTrue(any('target count' in e for e in errors))
        self.assertTrue(any('row must be' in e for e in errors))

    def test_target_and_index(self):
        texts = quest_source('call Quest_Talk(q,null,"log")')
        texts['Test'] = texts['Test'].replace('QUEST_SIDE,61', 'QUEST_SIDE,8192')
        errors = self.check(texts)
        self.assertTrue(any('requires a target' in e for e in errors))
        self.assertTrue(any('log index' in e for e in errors))

    def test_required_library_and_cycle(self):
        texts = quest_source()
        texts['Test'] = texts['Test'].replace('requires TQuestEngine', '')
        self.assertTrue(any('missing requires' in e for e in self.check(texts)))
        texts = quest_source()
        texts['QuestEngine'] = texts['QuestEngine'].replace('library TQuestEngine', 'library TQuestEngine requires TTest')
        self.assertTrue(any('cycle' in e for e in self.check(texts)))

    def test_missing_and_waiting_hook(self):
        steps = 'call Quest_Custom(q,"log")\ncall Quest_OnDone(q,"Hook")'
        self.assertTrue(any('missing hook' in e for e in self.check(quest_source(steps))))
        extra = 'function Hook takes nothing returns nothing\ncall Next()\nendfunction\nfunction Next takes nothing returns nothing\ncall Wait_Polled(1.)\nendfunction'
        self.assertTrue(any('Hook -> Next' in e for e in self.check(quest_source(steps, extra))))

    def test_async_timer_is_allowed_but_synchronous_callback_is_not(self):
        extra = 'function Later takes nothing returns nothing\ncall TriggerSleepAction(1.)\nendfunction\nfunction Hook takes nothing returns nothing\ncall TimerStart(CreateTimer(),1.,false,function Later)\nendfunction'
        fs = functions(extra)
        self.assertIsNone(waiting_chain('Hook', fs))
        fs['Hook'] = fs['Hook'].replace('TimerStart(CreateTimer(),1.,false,function Later)', 'ForForce(GetPlayersAll(),function Later)')
        self.assertEqual(waiting_chain('Hook', fs), ('Hook', 'Later'))

    def test_synchronous_execute_and_trigger_callbacks_are_traced(self):
        extra = 'function Later takes nothing returns nothing\ncall TriggerSleepAction(1.)\nendfunction\nfunction Hook takes nothing returns nothing\ncall ExecuteFunc("Later")\nendfunction'
        fs = functions(extra)
        self.assertEqual(waiting_chain('Hook', fs), ('Hook', 'Later'))
        fs['Hook'] = fs['Hook'].replace('ExecuteFunc("Later")', 'TriggerExecute(gg_trg_Test)')
        self.assertEqual(waiting_chain('Hook', fs, trigger_actions={'gg_trg_Test': ['Later']}), ('Hook', 'Later'))

    def test_waiting_calls_in_conditions_returns_and_nested_arguments_are_traced(self):
        for line in ['if Later() then\nendif', 'return Later()', 'call Native(Later())']:
            with self.subTest(line=line):
                fs = functions('function Hook takes nothing returns nothing\n' + line + '\nendfunction\nfunction Later takes nothing returns boolean\ncall TriggerSleepAction(1.)\nreturn true\nendfunction')
                self.assertEqual(waiting_chain('Hook', fs), ('Hook', 'Later'))

    def test_silent_start_requires_custom_intro(self):
        texts = quest_source('call Quest_Talk(q,npc,"log")', 'function Start takes nothing returns nothing\ncall Quest_StartSilent(QUEST_TEST,null,null)\nendfunction')
        self.assertTrue(any('silent start' in e for e in self.check(texts)))


class SaveGuardsTests(unittest.TestCase):
    def setUp(self):
        self.base = json.loads(CONTRACT.read_text(encoding='utf-8'))

    def test_tested_contract_passes(self):
        self.assertEqual(compare(self.base, self.base), [])

    def test_reorder_item_charge_job_serializer_and_armory_are_blocked(self):
        for key in ['items', 'charged', 'jobs', 'serializers', 'armory_flags', 'item_classes', 'item_bases']:
            with self.subTest(key=key):
                changed = deepcopy(self.base)
                first = next(iter(changed[key]))
                changed[key][first] = 'changed'
                self.assertTrue(compare(changed, self.base))

    def test_append_item_allowed_with_classification(self):
        changed = deepcopy(self.base)
        changed['items']['352'] = 'Inew'
        changed['save_flag_count'] = 352
        changed['charged']['352'] = False
        changed['item_classes']['Inew'] = 'Permanent'
        changed['item_bases']['Inew'] = 'rat9'
        self.assertEqual(compare(changed, self.base), [])
        del changed['charged']['352']
        self.assertTrue(any('classification' in e for e in compare(changed, self.base)))

    def test_save_flag_count_tracks_appended_items(self):
        changed = deepcopy(self.base)
        changed['save_flag_count'] -= 1
        self.assertTrue(any('udg_SaveFlagCount' in e for e in compare(changed, self.base)))

    def test_duplicate_gap_and_reserved_capacity(self):
        changed = deepcopy(self.base)
        changed['items']['352'] = changed['items']['1']
        self.assertTrue(any('duplicate' in e for e in compare(changed, self.base)))
        changed['items']['501'] = 'Inew'
        errors = compare(changed, self.base)
        self.assertTrue(any('contiguous' in e for e in errors))
        self.assertTrue(any('exceeds 500' in e for e in errors))

    def test_existing_repeated_armory_assignments_are_preserved(self):
        values, errors = assignments({'Test': "set udg_SaveFlagUnitID[145]='Iaaa'\nset udg_SaveFlagUnitID[$91]='Ibbb'"}, 'udg_SaveFlagUnitID', repeated=True)
        self.assertEqual(values, {'145': ['Iaaa', 'Ibbb']})
        self.assertEqual(errors, [])

    def test_fixed_vectors_and_corrupted_checksum(self):
        table = savecode.load_items(str(ROOT / 'src/itemtable.txt'))
        self.assertEqual(fixtures_check(table), [])
        data = json.loads((ROOT / 'tools/tests/fixtures/savecodes.json').read_text(encoding='utf-8'))
        for case in data['cases']:
            code = case['code']
            damaged = code[:10] + ('A' if code[10] != 'A' else 'B') + code[11:]
            with self.assertRaises(savecode.CodeError):
                savecode.decode(damaged, lambda i: table[i]['charged'])


class BuildSafetyTests(unittest.TestCase):
    def test_stage_cannot_escape_release_directory(self):
        for stage in ['../T', 't', 'T/../../x', '', 'T.w3x']:
            with self.assertRaises(ValueError):
                outputs(stage)
        self.assertEqual(outputs('AA')[0].parent, ROOT / 'release')

    def test_existing_output_is_never_overwritten(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'existing.w3x'
            path.write_bytes(b'existing archive')
            with self.assertRaises(ValueError):
                refuse_existing([path])
            self.assertEqual(path.read_bytes(), b'existing archive')


class ContentChecksTests(unittest.TestCase):
    def test_new_missing_typed_reference_rejected_and_existing_stock_calls_preserved(self):
        texts = {'Test': "function Test takes nothing returns nothing\ncall UnitAddAbility(u,'Anew')\ncall CreateItem('Inew',0,0)\nendfunction"}
        unknown = check_content.unresolved(texts, {'item': {'Inew'}, 'ability': set()})
        self.assertEqual(len(unknown), 1)
        self.assertTrue(check_content.compare(unknown, {}))
        self.assertEqual(check_content.compare(unknown, unknown), [])
        doubled = {key: 2 * value for key, value in unknown.items()}
        self.assertTrue(check_content.compare(doubled, unknown))

    def test_object_kind_is_checked(self):
        texts = {'Test': "function Test takes nothing returns nothing\ncall UnitAddAbility(u,'Inew')\nendfunction"}
        self.assertTrue(check_content.unresolved(texts, {'item': {'Inew'}, 'ability': set()}))

    def test_buff_removal_is_a_valid_native_reference(self):
        texts = {'Test': "function Test takes nothing returns nothing\ncall UnitRemoveAbility(u,'Bnew')\nendfunction"}
        self.assertEqual(check_content.unresolved(texts, {'ability': set(), 'buff': {'Bnew'}}), {})


if __name__ == '__main__':
    unittest.main(verbosity=2)
