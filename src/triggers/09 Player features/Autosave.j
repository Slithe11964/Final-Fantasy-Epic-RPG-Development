library TAutosave requires TForce
function Trig_Autosave_Command_Cond_InAutosaveForce takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_AutosaveForce))
endfunction

function Trig_Autosave_Command_Cond_AutosaveToggle takes nothing returns boolean
    return(GetEventPlayerChatString()=="-autosave")
endfunction

function Trig_Autosave_Command_Cond_AutosaveOffArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-autosave off")
endfunction

function Trig_Autosave_Command_Cond_AutosaveOnArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-autosave on")
endfunction

function Trig_Autosave_Command_Cond_AutosaveNowOn takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_AutosaveForce))
endfunction

function Trig_Autosave_Command_Actions takes nothing returns nothing
    if(Trig_Autosave_Command_Cond_AutosaveOnArg())then
        call ForceAddPlayerSimple(GetTriggerPlayer(),udg_AutosaveForce)
    else
        if(Trig_Autosave_Command_Cond_AutosaveOffArg())then
            call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_AutosaveForce)
        else
            if(Trig_Autosave_Command_Cond_AutosaveToggle())then
                if(Trig_Autosave_Command_Cond_InAutosaveForce())then
                    call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_AutosaveForce)
                else
                    call ForceAddPlayerSimple(GetTriggerPlayer(),udg_AutosaveForce)
                endif
            else
                return
            endif
        endif
    endif
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    if(Trig_Autosave_Command_Cond_AutosaveNowOn())then
        call DisplayTimedTextToForce(udg_TempForce,10.,"Your game will now save automatically.")
    else
        call DisplayTimedTextToForce(udg_TempForce,10.,"Your game will no longer save automatically.")
    endif
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Autosave takes nothing returns nothing
endfunction
function RegisterR11_Autosave_Command takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Autosave_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Autosave_Command,Player(0),"-autosave",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Autosave_Command,Player(1),"-autosave",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Autosave_Command,Player(2),"-autosave",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Autosave_Command,Player(3),"-autosave",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Autosave_Command,Player(4),"-autosave",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Autosave_Command,Player(5),"-autosave",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Autosave_Command,Player(6),"-autosave",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Autosave_Command,Player(7),"-autosave",false)
    call TriggerAddAction(gg_trg_Autosave_Command,function Trig_Autosave_Command_Actions)
endfunction




endlibrary
