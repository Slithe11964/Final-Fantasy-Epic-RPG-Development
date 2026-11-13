"""Read-only slot invalidation and input recovery; no equipment mutation."""
from pathlib import Path
import re
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency

ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    fs=functions(source)
    if 'FFL_Commit' in fs:
        body=fs['FFL_Commit']
        marker='    call FFL_RestoreUnlocks(pid)'
        assert body.count(marker)==1
        return dependency(put(source,'FFL_Commit',body.replace(marker,marker+'\n    call QuickGear_Loaded(pid)')),'TEquip')
    if 'Trig_Cmd_Load_Code_LoadCodeV3' in fs:
        for name in ('Trig_Cmd_Load_Code_LoadCodeV2','Trig_Cmd_Load_Code_LoadCodeV3'):
            body=fs[name];marker='    set udg_HasLoadedCode[l_pid]=true'
            assert body.count(marker)==1
            source=put(source,name,body.replace(marker,marker+'\n    call QuickGear_Loaded(l_pid)'))
        return dependency(source,'TEquip')
    if 'QuickGear_Draw' not in fs:return source
    fragment=(ROOT/'experiments/Forsaken/GearRecovery53.j').read_text()
    declarations=re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]
    source=source.replace('endglobals',declarations+'endglobals',1)
    source=source.replace('function QuickGear_Poll takes',functions(fragment)['QuickGear_SlotsChanged']+'\n\nfunction QuickGear_Poll takes',1)
    source=source.replace('endlibrary','\n\n'.join(b for n,b in functions(fragment).items() if n!='QuickGear_SlotsChanged')+'\nendlibrary',1)
    body=fs['QuickGear_Draw'];marker='        set carried=QuickGear_Item(hero,slot)'
    assert body.count(marker)==1
    body=body.replace(marker,marker+'\n        set QuickGearObservedItem[slot]=carried\n        set QuickGearObservedRaw[slot]=GetItemTypeId(carried)')
    source=put(source,'QuickGear_Draw',body)
    body=fs['QuickGear_Poll'];marker='QuickGearSeenRevision!=QuickGearRevision[pid] or '
    assert body.count(marker)==1
    body=body.replace(marker,marker+'QuickGear_SlotsChanged(hero) or ',1)
    body=body.replace('            set QuickGearRetryUntil=now+1.','            set QuickGearChatOpen=false\n            set QuickGearRetryUntil=now+1.',1)
    source=put(source,'QuickGear_Poll',body)
    body=fs['QuickGear_Input']
    start='    set key=BlzGetTriggerPlayerKey()'
    body=body.replace(start,start+'\n    set QuickGearKeyEvents=QuickGearKeyEvents+1',1)
    # The native edit control can report its own visibility while its chat
    # container is closed. Enter/chat/Escape already track actual chat intent.
    block='        if QuickGearChatEdit!=null then\n            set QuickGearChatOpen=BlzFrameIsVisible(QuickGearChatEdit)\n        endif\n'
    assert body.count(block)==1
    body=body.replace(block,'',1)
    source=put(source,'QuickGear_Input',body)
    body=fs['QuickGear_Request'];marker='    call QuickGear_ClearPreview()'
    body=body.replace(marker,'    set QuickGearRequests=QuickGearRequests+1\n    set QuickGearReason="request raw="+I2S(raw)+" spell="+I2S(cast)\n'+marker,1)
    source=put(source,'QuickGear_Request',body)
    body=fs['QuickGear_Receive'];marker='    if slot<0 or slot>1'
    body=body.replace(marker,'    set QuickGearReceives[GetPlayerId(owner)]=QuickGearReceives[GetPlayerId(owner)]+1\n'+marker,1)
    source=put(source,'QuickGear_Receive',body)
    body=fs['Register_Forsaken_PanelAccess']
    body=body.replace('    call QuickGear_Init()','    call ExecuteFunc("QuickGear_InitDiagnostics")\n    call QuickGear_Init()',1)
    return put(source,'Register_Forsaken_PanelAccess',body)
