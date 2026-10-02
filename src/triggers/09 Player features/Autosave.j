library TAutosave requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Autosave_Command=null
endglobals

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

// World Editor calls InitTrig_Autosave automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Autosave (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Autosave takes nothing returns nothing
endfunction

function Register_Autosave_Command takes nothing returns nothing
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

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Autosave takes nothing returns nothing
    call Register_Autosave_Command()
endfunction

endlibrary
