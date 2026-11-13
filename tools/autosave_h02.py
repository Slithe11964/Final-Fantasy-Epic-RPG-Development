"""Match-start ten-minute autosaves, explicit opt-out and retained failed work."""
import re
from jtok import functions
from performance_runtime import put
GLOBALS='''    timer FFL_AutoTimer=null
    boolean FFL_AutoStarted=false
    boolean array FFL_AutoOptOut
    boolean array FFL_AutoInFlight
    real array FFL_AutoRetryAfter
'''
BEGIN='''function FFL_BeginAutosave takes integer pid returns boolean
    // Use the existing staged capture pump rather than 400 inline steps.
    if FRC_Start(pid) then
        set FFL_SaveFile[pid]=true
        set FST_LegacySaveMessages[pid]=true
        set FFL_Phase[pid]=1
        call FFL_Message(pid,"Autosaving...")
        return true
    endif
    return false
endfunction
'''
HELPERS='''function FFL_QueueAutosave takes integer pid returns nothing
    if not FSC_PlayerValid(pid) or FFL_AutoOptOut[pid] or not IsPlayerInForce(Player(pid),udg_PlayingPlayers) then
        return
    endif
    set FFL_AutoPending[pid]=true
    if not FFL_AutoRetryActive then
        set FFL_AutoRetryActive=true
        call TimerStart(FFL_AutoRetryTimer,1.,true,function FFL_RetryAutosaves)
    endif
endfunction
function FFL_AutoStart takes nothing returns nothing
    if not FFL_AutoStarted and FFL_AutoTimer!=null then
        set FFL_AutoStarted=true
        call TimerStart(FFL_AutoTimer,600.,true,null)
    endif
endfunction
function FFL_AutoSchedule takes nothing returns nothing
    local integer pid=0
    if not udg_GameRunning then
        return
    endif
    loop
        exitwhen pid>=8
        call FFL_QueueAutosave(pid)
        set pid=pid+1
    endloop
endfunction
'''
TRY='''function FFL_TryAutosave takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return true
    endif
    if not IsPlayerInForce(Player(pid),udg_PlayingPlayers) or FFL_AutoOptOut[pid] or not udg_HardcoreOff then
        return true
    endif
    if TimerGetElapsed(FST_Clock)<FFL_AutoRetryAfter[pid] then
        return false
    endif
    if Inventory94Paused or udg_InCinematicMode or FFL_Phase[pid]!=0 or FFP_Locked[pid] or FRC_Phase[pid]!=0 or FSC_Writing[pid] or FSC_Busy[pid] or FST_Pending[pid] then
        return false
    endif
    if udg_PlayerHero[pid+1]==null or udg_SpiritOfGaya[pid+1]==null or udg_PlayerHouse[pid+1]==null then
        return false
    endif
    if BlzUnitExtendedInventorySize(udg_PlayerHero[pid+1])!=30 then
        return false
    endif
    if FST_SetFileStem(pid,"autosave") then
        if FFL_BeginAutosave(pid) then
            set FFL_AutoInFlight[pid]=true
            return true
        endif
    endif
    // Failed capture starts remain pending, with a bounded backoff.
    set FFL_AutoRetryAfter[pid]=TimerGetElapsed(FST_Clock)+30.
    return false
endfunction'''
COMMAND='''function Trig_Autosave_Command_Actions takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    local string command=StringCase(GetEventPlayerChatString(),false)
    if pid<0 or pid>=8 then
        return
    endif
    if command=="-autosave off" then
        set FFL_AutoOptOut[pid]=true
        set FFL_AutoPending[pid]=false
        call Collection_ForceRemovePlayerSimple(GetTriggerPlayer(),udg_AutosaveForce)
    elseif command=="-autosave on" then
        set FFL_AutoOptOut[pid]=false
        call Collection_ForceAddPlayerSimple(GetTriggerPlayer(),udg_AutosaveForce)
    elseif command=="-autosave now" then
        if FFL_AutoOptOut[pid] then
            call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Autosave is OFF. Use -autosave on to enable it.")
        else
            set Save_AutosavePid=pid
            call ExecuteFunc("FFL_Autosave")
            call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Autosave queued. It will write autosave.txt when your character is ready.")
        endif
        return
    elseif command!="-autosave" then
        return
    endif
    if FFL_AutoOptOut[pid] then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Autosave is OFF. Use -autosave on to enable it.")
    elseif not udg_HardcoreOff then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Autosave is ON, but saving is unavailable in Hardcore.")
    elseif FFL_AutoPending[pid] then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Autosave is ON. A save is queued until your character is ready.")
    else
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Autosave is ON. Saves every 10 minutes from match start. Only -autosave off disables it.")
    endif
endfunction'''

def refresh(s,classic=False):
 fs=functions(s)
 if 'FFL_TryAutosave' in fs:
  s=s.replace('endglobals',GLOBALS+'endglobals',1)
  retry=fs['FFL_RetryAutosaves'];s=put(s,'FFL_RetryAutosaves',retry+'\n'+HELPERS)
  body=TRY
  if classic:body=body.replace('Inventory94Paused or ','').replace('BlzUnitExtendedInventorySize(udg_PlayerHero[pid+1])!=30','not SaveSlots_Ready(pid)')
  s=put(s,'FFL_TryAutosave',BEGIN+'\n'+body)
  s=put(s,'FFL_Autosave','function FFL_Autosave takes nothing returns nothing\n    call FFL_QueueAutosave(Save_AutosavePid)\nendfunction')
  b=fs['FFL_Tick'];b=b.replace('    local integer pid=0','    local integer pid=0\n    local boolean autoWritten=false',1)
  anchor='            set FFL_Phase[pid]=0\n            if FRC_Ready[pid] then';assert anchor in b
  b=b.replace(anchor,'            set FFL_Phase[pid]=0\n            set autoWritten=false\n            if FRC_Ready[pid] then',1)
  anchor='                    if (not FST_Write(pid,FRC_Result[pid],FRC_Account(pid))) then';assert anchor in b
  b=b.replace(anchor,'                    set autoWritten=FST_Write(pid,FRC_Result[pid],FRC_Account(pid))\n                    if not autoWritten then',1)
  anchor='        elseif ((FFL_Phase[pid] == 2) and (not FST_Pending[pid])) then';assert anchor in b
  b=b.replace(anchor,'''            if FFL_AutoInFlight[pid] then
                set FFL_AutoInFlight[pid]=false
                if not autoWritten then
                    set FFL_AutoRetryAfter[pid]=TimerGetElapsed(FST_Clock)+30.
                    call FFL_QueueAutosave(pid)
                endif
            endif
'''+anchor,1)
  s=put(s,'FFL_Tick',b)
  b=fs['InitTrig_ForsakenFreshLoad'];anchor='        exitwhen (pid >= 8)';assert anchor in b
  b=b.replace(anchor,anchor+'\n        set FFL_AutoOptOut[pid]=false\n        call Collection_ForceAddPlayerSimple(Player(pid),udg_AutosaveForce)',1)
  s=put(s,'InitTrig_ForsakenFreshLoad',b)
 if 'Save_InitCommands' in fs:
  b=fs['Save_InitCommands'];anchor='    call DisableTrigger(udg_AutosaveTimerTrig)\n    call TriggerRegisterTimerEvent(udg_AutosaveTimerTrig,60.,true)';assert anchor in b
  b=b.replace(anchor,'    set FFL_AutoTimer=CreateTimer()\n    call TriggerRegisterTimerExpireEvent(udg_AutosaveTimerTrig,FFL_AutoTimer)',1);s=put(s,'Save_InitCommands',b)
  s=put(s,'Save_Autosave','function Save_Autosave takes nothing returns nothing\n    call ExecuteFunc("FFL_AutoSchedule")\nendfunction')
 if 'Trig_Game_Start_Actions' in fs:
  b=fs['Trig_Game_Start_Actions'];anchor='    set udg_GameRunning=true';assert anchor in b
  s=put(s,'Trig_Game_Start_Actions',b.replace(anchor,anchor+'\n    call ExecuteFunc("FFL_AutoStart")',1))
 if 'Trig_Game_Start_AddPlayerToForces' in fs:
  b=fs['Trig_Game_Start_AddPlayerToForces'];anchor='    call Collection_ForceAddPlayerSimple(GetEnumPlayer(),udg_AutosaveForce)';assert anchor in b
  b=b.replace(anchor,'    if not FFL_AutoOptOut[GetPlayerId(GetEnumPlayer())] then\n'+anchor+'\n    endif',1);s=put(s,'Trig_Game_Start_AddPlayerToForces',b)
 if 'Trig_Autosave_Command_Actions' in fs:s=put(s,'Trig_Autosave_Command_Actions',COMMAND)
 return s
