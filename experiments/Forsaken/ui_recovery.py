"""Native Forsaken presentation patches; never change character or recipe state."""
import re
from jtok import functions,tokens

SECRETS = '|cff00ff00Keg Hunter|r|n|n-increases rare drops in all areas'


def startup_baseline(original, candidate):
    """Approve exactly the two intentional UI registration changes; audit everything else."""
    before,after=functions(original),functions(candidate)
    edits={
        'Register_Forsaken_TalentClick':(
            '    set ForsakenTalentState=InitHashtable()',
            '    if ForsakenTalentState==null then\n    set ForsakenTalentState=InitHashtable()\n    endif'),
        'RegisterTriggers_Equip':(
            '    call Register_Forsaken_PanelAccess()',
            '    call TimerStart(CreateTimer(),0.,false,function Forsaken_StartPanels)'),
    }
    for name,(old,new) in edits.items():
        if before[name].count(old)!=1:
            raise ValueError('DW UI registration changed: '+name)
        expected=before[name].replace(old,new,1)
        if tokens(after[name])!=tokens(expected):
            raise ValueError('unapproved UI registration change: '+name)
        original=re.sub(r'^function '+name+r' takes\b.*?^endfunction',lambda _:expected,
                        original,count=1,flags=re.M|re.S)
    return original


def secrets_source(source):
    old = '    set tooltip=ChroniclesSecretsBase\n'
    if source.count(old) != 1:
        raise ValueError('DW Secrets tooltip changed')
    return source.replace(old, '    set tooltip=ChroniclesSecretsBase+"|n|n|cffffcc00Chronicles unlocked:|r "+Chronicles_Progress(p,12)\n', 1)


def simple_notice_source(source):
    old = '''        if(Trig_Vote_Difficulty_Result_SaveLoadEnabled())then
            call DisplayTimedTextToForce(GetPlayersAll(),15.," ")
            call DisplayTimedTextToForce(GetPlayersAll(),15.,"Saves from Simple mode cannot be loaded in other difficulties besides Nightmare.")
        endif
'''
    if source.count(old) != 1:
        raise ValueError('Simple difficulty notice changed')
    return source.replace(old, '', 1)


def panel_source(source):
    # The saved talent table is gameplay state, so rebinding click handlers must retain it.
    old = '    set ForsakenTalentState=InitHashtable()'
    if source.count(old) != 1:
        raise ValueError('DW talent state initializer changed')
    source = source.replace(old, '    if ForsakenTalentState==null then\n'+old+'\n    endif', 1)
    old = '    call Register_Forsaken_PanelAccess()'
    if source.count(old) != 1:
        raise ValueError('DW panel registration changed')
    source = source.replace(old, '    call TimerStart(CreateTimer(),0.,false,function Forsaken_StartPanels)', 1)
    # Newer native UI layouts may not expose the same equipment-panel frame name.
    old = '    call BlzFrameSetVisible(ForsakenTalentToggle,visible or ForsakenInspectTarget!=null)'
    new = ('    call BlzFrameSetVisible(ForsakenTalentToggle,visible or ForsakenInspectTarget!=null or '
           '(nativePanel==null and hero!=null and IsUnitSelected(hero,viewer)))')
    if source.count(old) != 1:
        raise ValueError('DW panel visibility changed')
    source = source.replace(old, new, 1)
    helpers = '''function Forsaken_StartPanels takes nothing returns nothing
    call Register_Forsaken_PanelAccess()
    call DestroyTimer(GetExpiredTimer())
endfunction

function Forsaken_RebuildPanels takes nothing returns nothing
    call PauseTimer(ForsakenUITimer)
    call DestroyTimer(ForsakenUITimer)
    call PauseTimer(ForsakenPanelClock)
    call DestroyTimer(ForsakenPanelClock)
    call DestroyTrigger(gg_trg_Forsaken_PanelAccess)
    call DestroyTrigger(gg_trg_Forsaken_TalentClick)
    call DestroyTrigger(gg_trg_Forsaken_TalentSync)
    set ForsakenTalentAnchor=null
    set ForsakenInspectTarget=null
    set ForsakenSelectedTarget=null
    set ForsakenPanelOpen=false
    set ForsakenPanelNeedsRefresh=false
    call Register_Forsaken_TalentClick()
    call Register_Forsaken_TalentSync()
    // Saved custom frame handles are stale; recreate them without touching talent choices.
    call Register_Forsaken_PanelAccess()
endfunction

'''
    # Both worker and initial timer callback come after all the functions they call.
    marker = 'function Forsaken_UpdatePanels takes'
    if source.count(marker) != 1:
        raise ValueError('DW panel creation boundary changed')
    return source.replace(marker, helpers+marker, 1)
