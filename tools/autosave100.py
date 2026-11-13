"""Restore production autosave actions; retain the existing 60s x10slot cadence."""
import re
from jtok import functions
from performance_runtime import put
GLOBALS='''    timer FFL_AutoRetryTimer=null
    boolean FFL_AutoRetryActive=false
    boolean array FFL_AutoPending
    integer FFL_AutoRetryCursor=0
'''
HELPERS='''function FFL_TryAutosave takes integer pid returns boolean
    if not FSC_PlayerValid(pid) or not udg_HardcoreOff then
        return true
    endif
    if not IsPlayerInForce(Player(pid),udg_PlayingPlayers) or not IsPlayerInForce(Player(pid),udg_AutosaveForce) then
        return true
    endif
    if Inventory94Paused or udg_InCinematicMode or FFL_Phase[pid]!=0 or FFP_Locked[pid] or FRC_Phase[pid]!=0 or FSC_Writing[pid] or FSC_Busy[pid] or FST_Pending[pid] then
        return false
    endif
    if udg_PlayerHero[pid+1]==null or udg_SpiritOfGaya[pid+1]==null or udg_PlayerHouse[pid+1]==null then
        return true
    endif
    if BlzUnitExtendedInventorySize(udg_PlayerHero[pid+1])!=30 then
        return false
    endif
    if FST_SetFileStem(pid,"autosave") then
        // Preserve the existing full-profile capture, validation and local file readback.
        call FFL_BeginSave(pid,true,true)
    endif
    return true
endfunction
function FFL_RetryAutosaves takes nothing returns nothing
    local integer i=0
    local integer pid=0
    local boolean waiting=false
    loop
        exitwhen i>=8
        set pid=ModuloInteger(FFL_AutoRetryCursor+i,8)
        if FFL_AutoPending[pid] then
            if FFL_TryAutosave(pid) then
                set FFL_AutoPending[pid]=false
                set FFL_AutoRetryCursor=ModuloInteger(pid+1,8)
                // At most one complete profile capture per retry tick.
                return
            endif
            set waiting=true
        endif
        set i=i+1
    endloop
    if not waiting then
        call PauseTimer(FFL_AutoRetryTimer)
        set FFL_AutoRetryActive=false
    endif
endfunction
'''
AUTO='''function FFL_Autosave takes nothing returns nothing
    local integer pid=Save_AutosavePid
    if not FFL_TryAutosave(pid) then
        set FFL_AutoPending[pid]=true
        if not FFL_AutoRetryActive then
            set FFL_AutoRetryActive=true
            call TimerStart(FFL_AutoRetryTimer,1.,true,function FFL_RetryAutosaves)
        endif
    endif
endfunction'''
def refresh(s,classic=False):
 f=functions(s)
 if 'Forsaken_PrepareInventories' in f:
  b=f['Forsaken_PrepareInventories'];needle='        call TriggerClearActions(udg_AutosaveTimerTrig)';assert b.count(needle)==1
  s=put(s,'Forsaken_PrepareInventories',b.replace(needle,'        // Autosave retains Save_Autosave; the current save system routes it safely.',1))
 if 'FFL_Autosave' not in f:return s
 assert 'FFL_TryAutosave' not in f
 s=s.replace('endglobals',GLOBALS+'endglobals',1)
 helpers=HELPERS.replace('BlzUnitExtendedInventorySize(udg_PlayerHero[pid+1])!=30','not SaveSlots_Ready(pid)').replace('if Inventory94Paused or udg_InCinematicMode','if udg_InCinematicMode') if classic else HELPERS
 s=put(s,'FFL_Autosave',helpers+'\n'+AUTO)
 f=functions(s);b=f['FFL_Guard'];matches=re.findall(r'    call FFL_OneGuard\(udg_AutosaveTimerTrig,\d+,block\)',b);assert len(matches)==1;needle=matches[0]
 s=put(s,'FFL_Guard',b.replace(needle,'    // Autosave stays scheduled; FFL_TryAutosave defers while a profile is locked.',1))
 b=f['FFL_CloseWindow'];assert 'set FFL_WindowOpen=false' in b
 b=b.replace('    set FFL_WindowOpen=false','''    set FFL_WindowOpen=false
    if udg_HardcoreOff and udg_AutosaveTimerTrig!=null then
        call EnableTrigger(udg_AutosaveTimerTrig)
    endif''',1)
 s=put(s,'FFL_CloseWindow',b)
 b=f['InitTrig_ForsakenFreshLoad'];needle='    set FFL_Window=CreateTimer()';assert needle in b
 s=put(s,'InitTrig_ForsakenFreshLoad',b.replace(needle,needle+'\n    set FFL_AutoRetryTimer=CreateTimer()',1))
 return s

