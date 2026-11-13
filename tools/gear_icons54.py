"""Icon-only refresh independent of UI53's cached panel redraw."""
from pathlib import Path
import re
from jtok import functions
from priest_master import fields
from performance_runtime import put

ROOT=Path(__file__).resolve().parents[1]


def refresh(source,items):
    fs=functions(source)
    if 'QuickGear_Draw' not in fs:return source
    assert 'QuickGear_PaintIcon' not in fs
    active=set(re.findall(r"SaveInteger\(QuickGearData,0,'(.{4})',",fs['QuickGear_Init']))
    rows=[]
    for raw in sorted(active):
        path=fields(items[raw]).get(('iico',None),'')
        # Stock inherited item icons are not necessarily authored in w3t.
        # Those keep the native fallback; explicit custom art is authoritative.
        if not path:continue
        assert isinstance(path,str),raw+' invalid icon'
        assert not path.startswith('TRIGSTR_'),raw+' unresolved icon'
        escaped=path.replace('\\','\\\\').replace('"','\\"')
        rows.append(f'    call SaveStr(QuickGearIconPaths,0,\'{raw}\',"{escaped}")')
    batches=[];calls=[]
    for offset in range(0,len(rows),32):
        name='QuickGear_IconPaths'+str(offset//32)
        batches.append('function '+name+' takes nothing returns nothing\n'+'\n'.join(rows[offset:offset+32])+'\nendfunction')
        calls.append('    call ExecuteFunc("'+name+'")')
    batches.append('function QuickGear_InitIconPaths takes nothing returns nothing\n'+'\n'.join(calls)+'\nendfunction')
    fragment=(ROOT/'experiments/Forsaken/GearIcons54.j').read_text()
    declarations=re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]
    source=source.replace('endglobals',declarations+'endglobals',1)
    helpers='\n\n'.join(batches+list(functions(fragment).values()))
    source=source.replace('function QuickGear_Draw takes',helpers+'\n\nfunction QuickGear_Draw takes',1)
    body=fs['QuickGear_Draw']
    marker='            call BlzFrameSetTexture(QuickGearIcon[slot],BlzGetItemIconPath(carried),0,true)'
    assert body.count(marker)==1
    source=put(source,'QuickGear_Draw',body.replace(marker,'            call QuickGear_PaintIcon(slot,carried)',1))
    body=fs['QuickGear_Init'];marker='    call QuickGear_InitPreviews()'
    assert body.count(marker)==1
    source=put(source,'QuickGear_Init',body.replace(marker,'    call ExecuteFunc("QuickGear_InitIconPaths")\n'+marker,1))
    body=fs['QuickGear_Poll'];marker='    set hero=null'
    assert body.count(marker)==1
    # Icon painting has no dependency on the panel revision or active spell,
    # and never resets cooldowns, targeting, button visibility or input state.
    body=body.replace(marker,'    if pid<8 and hero!=null and FFL_Phase[pid]==0 and FFN_State[pid]==0 then\n        call QuickGear_RefreshIcons(hero)\n    endif\n'+marker,1)
    return put(source,'QuickGear_Poll',body)
