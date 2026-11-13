"""Reuse the confirmed Dragoon rune bank/timer without changing released F/G."""
import re
from functools import lru_cache
from pathlib import Path
from jtok import functions
from performance_runtime import put
from editor_pair import View
from damage_tooltips import merged
from priest_master import fields

ROOT=Path(__file__).resolve().parents[1]


@lru_cache(maxsize=1)
def item_definitions():
    view=View(ROOT/'release/development/QuickUI40/FFERPG-QuickUI40-Forsaken.w3x')
    items=merged(view.object_bytes('war3map.w3t'),view.object_bytes('war3mapSkin.w3t'),'w3t')
    water={'A08X','A0Q0','A0Q1','A0Q2','A0SM','A0TP','A0SA','A150'}
    ice={'A17S','A0TM','A0UY'}
    rows=[]
    for raw,item in sorted(items.items()):
        abilities=set(str(fields(item).get(('iabi',None),'')).split(','))
        mode=2 if abilities&ice else 1 if abilities&water else 0
        if mode:rows.append(f"    call SaveInteger(Wave_Spells,0,'{raw}',{mode})")
    return '\n'.join(rows)


def refresh(source):
    fs=functions(source)
    if 'Register_Forsaken_PanelAccess' in fs:
        # Native bag children are initialized with the panel controls, after
        # Damage's earlier startup callback. Rebind the read-only observers then
        # and after checkpoint UI reconstruction, without touching F/G handlers.
        name='Register_Forsaken_PanelAccess'
        body=fs[name]
        if 'call ExecuteFunc("Wave_Init")' not in body:
            body=body.replace('endfunction','    call ExecuteFunc("Wave_Init")\nendfunction')
        return put(source,name,body)
    if 'DG_UIUpdate' not in functions(source):return source
    fragment=(ROOT/'experiments/Dragoon/WaveRunes.j').read_text()
    fragment=fragment.replace('    // WAVE ITEM DEFINITIONS',item_definitions())
    declarations=re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]
    source=source.replace('endglobals',declarations+'endglobals',1)
    source=source.replace('function DG_UIUpdate takes','\n\n'.join(functions(fragment).values())+'\n\nfunction DG_UIUpdate takes',1)
    fs=functions(source)
    body=fs['DG_UIUpdate']
    marker=' if p<8 and u!=null then'
    assert body.count(marker)==1
    # Keep Life/1000 Cuts ready glows running, then use the same rune images for
    # the selected wave. There is no second renderer or UI initialization path.
    body=body.replace(marker,' call Wave_Poll()\n'+marker,1)
    marker=' if DG_UIMode>0 and not IsUnitSelected(u,GetLocalPlayer()) then'
    assert body.count(marker)==1
    body=body.replace(marker,' if Wave_Mode>0 then\n call Wave_Draw(u)\n set u=null\n return\n endif\n'+marker,1)
    source=put(source,'DG_UIUpdate',body)
    source=put(source,'DG_UIInit',fs['DG_UIInit'].replace('endfunction',' call ExecuteFunc("Wave_Init")\nendfunction'))
    source=put(source,'DG_UIMouse',fs['DG_UIMouse'].replace('endfunction',' call Wave_MouseCommit()\nendfunction'))
    source=put(source,'DG_UIKey',fs['DG_UIKey'].replace(' if GetLocalPlayer()==GetTriggerPlayer() then',' if GetLocalPlayer()==GetTriggerPlayer() then\n set Wave_Mode=0\n set Wave_FromGear=false',1))
    # UI52 native bag discovery crashed in client testing. Keep the default
    # builder on the recovery policy until a native bag observer is verified.
    from wave_recovery53 import refresh as recovery
    return recovery(source)
