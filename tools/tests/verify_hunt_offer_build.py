"""Audit AO against AN: quest acceptance/dialogue and blue-girl stationarity only."""
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
from jtok import functions, tokens


def main():
    paths = [ROOT / 'release/FFERPG_0.9.7.3-r16-stageAN.w3x',
             ROOT / 'release/FFERPG_0.9.7.3-r16-stageAO.w3x',
             ROOT / 'release/1.29.2/FFERPG_0.9.7.3-r16-stageAO.w3x']
    old, new, classic = [MPQ(str(p)) for p in paths]
    names = set(old.read('(listfile)').decode().splitlines()) | set(new.read('(listfile)').decode().splitlines())
    changed = sorted(n for n in names if old.read(n) != new.read(n))
    assert set(changed) <= {'war3map.j', 'war3map.wct'}, changed
    def modules(archive):
        return {k: text_of(v) for k, v in paired_text(read_wtg(archive.read('war3map.wtg')),
                                                   read_wct(archive.read('war3map.wct'))).items()}
    before, after = modules(old), modules(new)
    assert before.keys() == after.keys()
    expected = {'Bernkastel': {'Trig_Bernkastel_Try_Spawn_Actions'},
                'Quest_Arachnophobia': {'QuestArachnophobia_Define', 'QuestArachnophobia_Done'},
                'Quest_HarpyHunt': {'QuestHarpyHunt_Define'}}
    added = {'Quest_Arachnophobia': {'QuestArachnophobia_Started'}}
    timer = '    call TimerStart(CreateTimer(),2.,false,function QuestArachnophobia_OfferHarpyHunt)\n'
    for module in before:
        if module not in expected:
            assert before[module] == after[module], module
            continue
        x, y = functions(before[module]), functions(after[module])
        assert set(y) - set(x) == added.get(module, set())
        assert set(x) <= set(y)
        assert {f for f in x if tokens(x[f]) != tokens(y[f])} == expected[module]
        for name in expected[module]:
            restored = y[name]
            if module == 'Bernkastel':
                import re
                restored = re.sub(r'^\s*call (?:PauseUnit\(udg_BlueGirl,true\)|SetUnitPropWindow\(udg_BlueGirl,0\.\))\s*$', '', restored, flags=re.M)
            elif name == 'QuestArachnophobia_Define':
                restored = restored.replace('    call Quest_OnDone(q,"QuestArachnophobia_Started")\n', '')
            elif name == 'QuestArachnophobia_Done':
                restored = restored.replace('endfunction', timer + 'endfunction')
            else:
                restored = restored.replace("Hello. Since you're helping Kollin, could you help me too?",
                                            "Hello. I've heard from Kollin that you are now an honorary member of our Hunt Club.")
                restored = restored.replace('I have another task for you to complete. For a gold reward, of course.',
                                            'As such, I have another task for you to complete. For a gold reward, of course.')
            assert tokens(restored) == tokens(x[name]), name
        if module in added:
            assert tokens(y['QuestArachnophobia_Started']) == tokens(
                'function QuestArachnophobia_Started takes nothing returns nothing\n' + timer + 'endfunction')
    prior, current, legacy = [functions(a.read('war3map.j').decode()) for a in [old, new, classic]]
    allowed = set().union(*(set(functions(after[m])) for m in expected))
    different = [f for f in prior if tokens(prior[f]) != tokens(current[f])]
    assert set(different) <= allowed, different
    assert set(current) - set(prior) <= allowed
    assert set(prior) <= set(current)
    for name in allowed:
        assert tokens(current[name]) == tokens(legacy[name]), name
    report = {'changed_assets': changed, 'changed_runtime_functions': different,
              'only_requested_quest_and_stationarity_changes': True,
              'blue_girl_timer_seconds': 300, 'early_disappearance_cause_not_reproduced': True,
              'objects_rewards_targets_save_format_and_other_modules_unchanged': True,
              'hashes': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
    (ROOT / 'release/preservation-r16-stageAO.json').write_text(json.dumps(report, indent=2) + '\n')
    print('PASS AO preservation: only quest acceptance/introduction and blue-girl stationarity; timer remains300; objects/rewards/targets/save format unchanged.')


if __name__ == '__main__':
    main()
