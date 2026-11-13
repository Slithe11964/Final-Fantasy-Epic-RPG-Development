"""Read-only comparison of reported scenes with early story cinematics."""
import json,re
from pathlib import Path
from editor_pair import View
from jtok import functions,tokens
ROOT=Path(__file__).resolve().parents[1]
NAMES=['TMid','TQuestAoMadoushi','TKalmSiege1','TKalmSiege2','TKalmSiege3','TBossGilgamesh']
METRICS=['Cine_Enter','Cine_ExitAction','Text_Transmission','Text_Say','Text_Caption','Text_CaptionSay',
    'CinematicFadeBJ','CreateNUnitsAtLoc','CreateNUnitsAtLocFacingLocBJ','ReviveHeroLoc','RemoveUnit',
    'KillUnit','UnitAddItemByIdSwapped','TriggerRegisterUnitEvent','GetLocalPlayer']
def audit():
    paths=['QuickUI62/FFERPG-QuickUI62-Forsaken','VersionEHotfix10/FFERPG-0.9.7.5e-Hotfix10-Forsaken']
    report={}
    for path in paths:
        v=View(ROOT/f'release/development/{path}.w3x');fs=functions(v.runtime)
        rows={}
        for name in NAMES:
            source=v.modules[name]
            rows[name]={metric:len(re.findall(r'\b'+metric+r'\s*\(',source)) for metric in METRICS}
            rows[name]['functions']=len(functions(source))
            rows[name]['direct_local_player_branches']=bool(re.search(r'\bif\b[^\n]*GetLocalPlayer',source))
        report[path]={'metrics':rows,'shared_helpers':{name:fs[name] for name in ['Cine_Enter','Cine_Exit','Text_Transmission','Text_Caption']}}
    # Current scene implementation must be identical in native/no-new-jobs pair.
    a,b=report.values()
    assert a['metrics']==b['metrics']
    for name in a['shared_helpers']:
        assert tokens(a['shared_helpers'][name])==tokens(b['shared_helpers'][name])
    out=ROOT/'build/cinematic-comparison63.json';out.write_text(json.dumps(report,indent=2))
    print(json.dumps(a['metrics'],indent=2));print('PASS scene/helper parity across both tested branches')
if __name__=='__main__':audit()
