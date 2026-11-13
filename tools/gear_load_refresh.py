"""Small live-slot and post-load corrections on top of released F/G."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency

ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    fs=functions(source)
    if 'FFL_Commit' in fs:
        name='FFL_Commit'
        body=fs[name]
        marker='    call FFL_RestoreUnlocks(pid)'
        assert body.count(marker)==1
        if 'call QuickGear_QueueLoaded' not in body:
            body=body.replace(marker,marker+'\n    call QuickGear_QueueLoaded(Player_GetHero(Player(pid)))',1)
        return dependency(put(source,name,body),'TEquip')
    if 'QuickGear_Draw' not in fs:return source
    fragment=(ROOT/'experiments/Forsaken/GearLoadRefresh.j').read_text()
    declarations=re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]
    source=source.replace('endglobals',declarations+'endglobals',1)
    helpers=functions(fragment)
    source=source.replace('function QuickGear_Poll takes',helpers['QuickGear_EquipmentChanged']+'\n\nfunction QuickGear_Poll takes',1)
    tail='\n\n'.join(body for name,body in helpers.items() if name!='QuickGear_EquipmentChanged')
    source=source.replace('endlibrary',tail+'\n\nendlibrary',1)
    body=fs['QuickGear_Draw']
    marker='        set carried=QuickGear_Item(hero,slot)'
    assert body.count(marker)==1
    body=body.replace(marker,marker+'\n        set QuickGearSeenItem[slot]=carried\n        set QuickGearSeenRaw[slot]=GetItemTypeId(carried)',1)
    source=put(source,'QuickGear_Draw',body)
    body=fs['QuickGear_Poll']
    marker='QuickGearSeenRevision!=QuickGearRevision[pid] or '
    assert body.count(marker)==1
    body=body.replace(marker,marker+'QuickGear_EquipmentChanged(hero) or ',1)
    return put(source,'QuickGear_Poll',body)
