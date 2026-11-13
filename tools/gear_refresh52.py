"""Refresh released gear controls and re-seat equipment after either load format."""
from pathlib import Path
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
import gear_load_refresh

ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    source=gear_load_refresh.refresh(source)
    fs=functions(source)
    if 'Trig_Cmd_Load_Code_LoadCodeV3' in fs:
        for name in ('Trig_Cmd_Load_Code_LoadCodeV2','Trig_Cmd_Load_Code_LoadCodeV3'):
            body=fs[name]
            marker='    set udg_HasLoadedCode[l_pid]=true'
            assert body.count(marker)==1
            source=put(source,name,body.replace(marker,marker+'\n    call QuickGear_QueueLoaded(Player_GetHero(p))'))
        return dependency(source,'TEquip')
    if 'QuickGear_Draw' not in fs:return source
    helpers=functions((ROOT/'experiments/Forsaken/GearRefresh52.j').read_text())
    source=put(source,'QuickGear_LoadRefresh',helpers['QuickGear_LoadRefresh'])
    source=source.replace('function QuickGear_LoadRefresh takes',helpers['QuickGear_Reseat']+'\n\nfunction QuickGear_LoadRefresh takes',1)
    # Always read the two live slots. No equipment event or revision is required
    # for a texture update, including replacing an item with the same raw ID.
    body=functions(source)['QuickGear_Poll']
    marker='        if not QuickGearReady or QuickGearHero!=hero or QuickGearSeenRevision!='
    line=next(l for l in body.splitlines() if l.startswith(marker))
    body=body.replace(line,'        if true then',1)
    return put(source,'QuickGear_Poll',body)
