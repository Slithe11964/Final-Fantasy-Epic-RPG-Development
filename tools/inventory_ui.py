"""Keep native backpack open until an explicit local close action."""
from pathlib import Path
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    fs=functions(source)
    if 'Forsaken_PollPanels' not in fs:return source
    declarations={
        'boolean ForsakenBackpackWanted=false':'ForsakenBackpackWanted',
        'real ForsakenBackpackCloseUntil=0.':'ForsakenBackpackCloseUntil',
        'trigger ForsakenBackpackEvents=null':'ForsakenBackpackEvents',
        'trigger ForsakenBackpackCloseEvents=null':'ForsakenBackpackCloseEvents',
        'framehandle ForsakenBackpackClose=null':'ForsakenBackpackClose',
        'framehandle ForsakenBackpackHookRoot=null':'ForsakenBackpackHookRoot',
        'framehandle ForsakenBackpackNativeClose=null':'ForsakenBackpackNativeClose',
        'integer ForsakenBackpackScanBudget=0':'ForsakenBackpackScanBudget',
    }
    import re
    for declaration,name in declarations.items():
        if not re.search(r'^\s*(?:boolean|real|trigger|framehandle|integer) '+name+r'\s*(?:=|$)',source,re.M):
            source=source.replace('endglobals','    '+declaration+'\nendglobals',1)
    # Replace the previous half-second restoration helpers, including older masters.
    helper=(ROOT/'experiments/Forsaken/BackpackVisibility.j').read_text()
    for name in set(functions(helper))|{'Forsaken_BackpackActivity','Forsaken_BackpackVisible','Forsaken_RegisterBackpackActivity'}:
        pattern=r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*'
        source=re.sub(pattern,'',source,flags=re.M|re.S)
    for line in helper.splitlines():
        if line.startswith('//'):source=source.replace(line+'\n','')
    source=re.sub(r'^// Local presentation only\.[^\n]*\n','',source,flags=re.M)
    source=re.sub(r'^    real ForsakenBackpackRestoreUntil=0\.\n','',source,flags=re.M)
    source=re.sub(r'\n{3,}','\n\n',source)
    at=source.index('function Forsaken_PanelAccess')
    source=source[:at]+helper.rstrip()+'\n\n'+source[at:]
    name='Forsaken_PollPanels';body=functions(source)[name]
    body=body.replace('set visible=BlzFrameIsVisible(nativePanel)','set visible=Forsaken_BackpackVisible(nativePanel)')
    if 'call Forsaken_BackpackControls' not in body:
        body=body.replace('    set ForsakenBackpackWasVisible=visible',
                          '    call Forsaken_BackpackControls(nativePanel,anchor,visible and ForsakenInspectTarget==null)\n    set ForsakenBackpackWasVisible=visible')
    source=put(source,name,body)
    name='Forsaken_PanelAccess';body=functions(source)[name]
    # Remove PAIR017's cancellation on selection, which erased user intent.
    body=re.sub(r'        if GetTriggerEventId\(\)==EVENT_PLAYER_UNIT_DESELECTED or .*?\n            set ForsakenBackpackRestoreUntil=0\.\n        endif\n','',body,count=1)
    if 'call Forsaken_BackpackAccess' not in body:
        body=body.replace('    if GetLocalPlayer()==viewer then',
                          '    if GetLocalPlayer()==viewer then\n        call Forsaken_BackpackAccess(viewer,hero)',1)
    source=put(source,name,body)
    name='Forsaken_RebuildPanels'
    if name in functions(source):
        body=functions(source)[name]
        body=body.replace('    set ForsakenBackpackRestoreUntil=0.\n','')
        if 'call Forsaken_ResetBackpackControls()' not in body:
            body=body.replace('    set ForsakenTalentAnchor=null',
                              '    call Forsaken_ResetBackpackControls()\n    set ForsakenTalentAnchor=null',1)
        source=put(source,name,body)
    name='Register_Forsaken_PanelAccess';body=functions(source)[name]
    if 'call Forsaken_RegisterBackpackActivity()' not in body:
        body=body.replace('    set ForsakenStatName[0]="Fire"',
                          '    call Forsaken_RegisterBackpackActivity()\n    set ForsakenStatName[0]="Fire"',1)
    # This fragment is also used by builds before performance maintenance runs.
    if 'OSKEY_B,0,true' not in body:
        line='        call BlzTriggerRegisterPlayerKeyEvent(gg_trg_Forsaken_PanelAccess,Player(i),OSKEY_ESCAPE,0,true)'
        body=body.replace(line,line+'\n        call BlzTriggerRegisterPlayerKeyEvent(gg_trg_Forsaken_PanelAccess,Player(i),OSKEY_B,0,true)',1)
    source=put(source,name,body)
    return source
