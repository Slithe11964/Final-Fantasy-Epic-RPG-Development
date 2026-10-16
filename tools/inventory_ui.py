"""Retain native backpack visibility through item-action UI refreshes."""
from pathlib import Path
from jtok import functions
from performance_runtime import put,replace_once
ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    fs=functions(source)
    if 'Forsaken_PollPanels' not in fs:return source
    if 'Forsaken_BackpackActivity' not in fs:
        source=source.replace('endglobals','    real ForsakenBackpackRestoreUntil=0.\nendglobals',1)
        at=source.index('function Forsaken_PollPanels')
        source=source[:at]+(ROOT/'experiments/Forsaken/BackpackVisibility.j').read_text()+'\n'+source[at:]
    name='Forsaken_PollPanels';body=functions(source)[name]
    body=body.replace('set visible=BlzFrameIsVisible(nativePanel)','set visible=Forsaken_BackpackVisible(nativePanel)')
    source=put(source,name,body)
    name='Forsaken_PanelAccess';body=functions(source)[name]
    if 'set ForsakenBackpackRestoreUntil=0.' not in body:
        body=body.replace('    if GetLocalPlayer()==viewer then','''    if GetLocalPlayer()==viewer then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_DESELECTED or (GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED and selected!=hero) or BlzGetTriggerPlayerKey()==OSKEY_ESCAPE or BlzGetTriggerPlayerKey()==OSKEY_B then
            set ForsakenBackpackRestoreUntil=0.
        endif''',1)
    source=put(source,name,body)
    name='Forsaken_RebuildPanels'
    if name in functions(source):
        body=functions(source)[name]
        body=replace_once(body,'    set ForsakenTalentAnchor=null','    set ForsakenBackpackRestoreUntil=0.\n    set ForsakenTalentAnchor=null')
        source=put(source,name,body)
    name='Register_Forsaken_PanelAccess';body=functions(source)[name]
    body=replace_once(body,'    local integer i=0','    local integer i=0')
    body=replace_once(body,'    set ForsakenStatName[0]="Fire"','    call Forsaken_RegisterBackpackActivity()\n    set ForsakenStatName[0]="Fire"')
    source=put(source,name,body)
    return source
