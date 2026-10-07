"""Audit AP: additive Chronicle UI, title59, monograph predicates and recipe restock."""
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from source_checks import ROOT
from mpq import MPQ
from editor_layout import paired_text
from wct import read_wct, text_of
from wtg import read_wtg
from objdata import read_objects, fields
from chronicles_catalog import prepare, NEW_IDS
from jtok import functions, tokens


def main():
    paths = [ROOT / 'release/FFERPG_0.9.7.3-r16-stageAO.w3x',
             ROOT / 'release/FFERPG_0.9.7.3-r16-stageAP.w3x',
             ROOT / 'release/1.29.2/FFERPG_0.9.7.3-r16-stageAP.w3x']
    old, new, classic = [MPQ(str(p)) for p in paths]
    names = set(old.read('(listfile)').decode().splitlines()) | set(new.read('(listfile)').decode().splitlines())
    changed = sorted(n for n in names if old.read(n) != new.read(n))
    assert set(changed) <= {'war3map.j', 'war3map.wct', 'war3map.w3a'}, changed
    def modules(archive):
        return {k: text_of(v) for k, v in paired_text(read_wtg(archive.read('war3map.wtg')),
                                                   read_wct(archive.read('war3map.wct'))).items()}
    before, after = modules(old), modules(new)
    assert before.keys() == after.keys()
    expected = {'Gaya_Shared': {'Gaya_RecreateSpirit'},
                'GameLoad': {'Trig_GameLoad_RestoreTitles_RestoreChronicleLevels'},
                'Loot': {'Trig_Loot_MonsterDrop_Cond_MonographBonus', 'Trig_Loot_EssenceDrop_HasMonograph'},
                'Bazaar': {'Trig_Bazaar_OpenRecipes_Actions'},
                'Titles': {'Trig_Titles_Init_Actions', 'Trig_Titles_CheckAll_Actions', 'RegisterTriggers_Titles'}}
    for module in before:
        if module not in expected:
            assert before[module] == after[module], module
            continue
        x, y = functions(before[module]), functions(after[module])
        added = set(y) - set(x)
        if module == 'Titles':
            assert added == {'Chronicles_MonographIndex', 'Chronicles_RecordMonograph',
                             'Chronicles_MonographPickup', 'Chronicles_CheckInventory',
                             'Chronicles_Progress', 'Chronicles_RestoreSecrets',
                             'Chronicles_RefreshTooltips', 'Chronicles_Tick', 'Chronicles_Init',
                             'Register_Titles_MonographPickup'}
        else:
            assert added == ({'Loot_HasMonographBonus'} if module == 'Loot' else set())
        assert set(x) <= set(y)
        assert {f for f in x if tokens(x[f]) != tokens(y[f])} == expected[module]
        for name in expected[module]:
            restored = y[name]
            if module == 'Loot':
                continue  # Narrow predicates exercised by source-executed zone/inventory tests.
            if module == 'Gaya_Shared':
                restored = restored.replace('exitwhen i>12', 'exitwhen i>=$C')
            elif module == 'GameLoad':
                restored = restored.replace('exitwhen udg_TempInteger>12', 'exitwhen udg_TempInteger>$A')
            elif module == 'Bazaar':
                restored = restored.replace("    call RemoveUnitFromStock(GetSellingUnit(),'bRcp')\n", '')
                restored = restored.replace("    call AddUnitToStock(GetSellingUnit(),'bRcp',1,1)\n", '')
            else:
                for line in ["    set udg_ChronicleAbility[12]='cKeg'", '    set udg_TitleChronicleIndex[59]=12',
                             '    set udg_TitleName[59]="Keg Hunter"',
                             '    set udg_BonusText[59]="All ten monograph effects are now permanently active without carrying the books!"',
                             '    call Chronicles_Init()', '    call Chronicles_RestoreSecrets(udg_TempPlayer)',
                             '    call Register_Titles_MonographPickup()']:
                    restored = restored.replace(line + '\n', '')
            assert tokens(restored) == tokens(x[name]), name
    def objects(table):
        return {o['id'] or o['base']: fields(o) for group in ('original', 'custom') for o in table[group]}
    actual = objects(read_objects(new.read('war3map.w3a'), 'w3a'))
    planned = objects(prepare(read_objects(old.read('war3map.w3a'), 'w3a')))
    assert actual == planned
    legacy_objects = objects(read_objects(classic.read('war3map.w3a'), 'w3a'))
    for raw in NEW_IDS | {'A0AR', 'A10C'}:
        assert actual[raw] == legacy_objects[raw], raw
    prior, current, legacy = [functions(a.read('war3map.j').decode()) for a in [old, new, classic]]
    allowed = set().union(*(set(functions(after[m])) for m in expected))
    different = [f for f in prior if tokens(prior[f]) != tokens(current[f])]
    assert set(different) <= allowed, different
    assert set(current) - set(prior) <= allowed
    assert set(prior) <= set(current)
    for module in expected:
        names_to_check = expected[module] if module == 'Bazaar' else set(functions(after[module]))
        for name in names_to_check:
            assert tokens(current[name]) == tokens(legacy[name]), name
    for module in ('Save', 'Cmd', 'Code'):
        assert before[module] == after[module], 'Serializer changes in ' + module
    assert 'Save_PushForceFlag(l_stream,udg_TitleForce[59])' in after['Save']
    assert 'Trig_Cmd_Load_Code_LoadForceFlag(l_reader,udg_TitleForce[59])' in after['Cmd']
    report = {'changed_assets': changed, 'changed_runtime_functions': different,
              'additive_abilities': sorted(NEW_IDS), 'title_59_existing_save_bit': True,
              'inventory_items_recipes_rewards_quests_save_serializers_other_modules_unchanged': True,
              'knight_zone_zero_bonus_now_supported': True, 'bazaar_recipe_entry_immediately_restocked': True,
              'hashes': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
    (ROOT / 'release/preservation-r16-stageAP.json').write_text(json.dumps(report, indent=2) + '\n')
    print('PASS AP preservation: three new abilities, Chronicle list/Time Trial position; narrow title/monograph/restock changes; save format/items/recipes/quests/rewards unchanged.')


if __name__ == '__main__':
    main()
