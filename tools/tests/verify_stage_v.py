"""Reverse the exact local/parameter refactor and compare all source/runtime functions.

python tools/tests/verify_stage_v.py [--map release/...stageV.w3x]
This audit is specific to stage V (parent source commit 64809ce).
"""
import argparse
from pathlib import Path
import re
import subprocess
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from jtok import functions, tokens
from source_checks import ROOT
from mpq import MPQ

PARENT = '64809ce'
FOLDER = 'src/triggers/06 Quests and story/'
CHANGES = {
    'Trig_Cartographer_Start_Actions': {'l_rewardTotal': 'udg_TempInteger'},
    'Trig_Cartographer_Report_Actions': {'l_rewardTotal': 'udg_TempInteger'},
    'Trig_Cartographer_Update_Actions': {'l_scanPoint': 'udg_TempPoint', 'l_mapPlayer': 'udg_TempPlayer'},
    'Trig_Cartographer_Update_IsPointExplored': {'l_point': 'udg_TempPoint', 'l_player': 'udg_TempPlayer'},
    'Trig_TrueIceAge_Summon_Actions': {'l_nearbyHeroes': 'udg_TempGroup', 'l_summoner': 'udg_TempPlayer', 'l_dropPoint': 'udg_TempPoint2'},
    'Trig_TrueIceAge_Summon_AnyHeroNearby': {'l_heroes': 'udg_TempGroup'},
}

def undo(name, body):
    if name not in CHANGES:
        return body
    names = '|'.join(CHANGES[name])
    body = re.sub(r'^\s*(?:local \w+ (' + names + r')\s*|set (' + names + r')=null)\s*\n', '', body, flags=re.M)
    body = body.replace('Trig_Cartographer_Update_IsPointExplored(l_scanPoint,l_mapPlayer)', 'Trig_Cartographer_Update_IsPointExplored()')
    body = body.replace('Trig_TrueIceAge_Summon_AnyHeroNearby(l_nearbyHeroes)', 'Trig_TrueIceAge_Summon_AnyHeroNearby()')
    if name in ('Trig_Cartographer_Update_IsPointExplored', 'Trig_TrueIceAge_Summon_AnyHeroNearby'):
        body = re.sub(r' takes .*? returns', ' takes nothing returns', body, count=1)
    for new, old in CHANGES[name].items():
        body = re.sub(r'\b' + new + r'\b', old, body)
    return body

def compare(before, after, label):
    old, new = functions(before), functions(after)
    assert set(old) == set(new), label + ': function set changed'
    errors = [name for name in old if tokens(old[name]) != tokens(undo(name, new[name]))]
    assert not errors, label + ': unexpected changes ' + str(errors)
    print(f'PASS {label}: {len(old)} functions identical after reversing only declared local/parameter changes')

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--map', type=Path)
    a = p.parse_args()
    for module in ['Cartographer', 'TrueIceAge']:
        old = subprocess.check_output(['git', 'show', PARENT + ':' + FOLDER + module + '.j'], cwd=ROOT).decode('utf-8')
        path = ROOT / FOLDER / (module + '.j')
        raw = path.read_bytes()
        assert b'\n' not in raw.replace(b'\r\n', b''), 'CRLF required'
        compare(old, raw.decode('utf-8'), 'source/' + module)
    if a.map:
        base = MPQ(str(ROOT / 'release/FFERPG_0.9.7.3-r16-stageU.w3x'))
        new = MPQ(str(a.map))
        compare(base.read('war3map.j').decode(), new.read('war3map.j').decode(), 'playable script')
        names = set(base.read('(listfile)').decode().splitlines()) | {'(listfile)'}
        changed = {name for name in names if base.read(name) != new.read(name)}
        assert changed == {'war3map.j', 'war3map.wct'}, changed
        print('PASS all listed terrain/object/asset/trigger-tree files unchanged')
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
