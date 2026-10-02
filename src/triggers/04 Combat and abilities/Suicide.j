library TSuicide requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Suicide_Command=null
endglobals

function Trig_Suicide_Command_Cond_HasMaxCharges takes nothing returns boolean
    return(udg_GatherState[GetConvertedPlayerId(GetTriggerPlayer())]>=3)
endfunction

function Trig_Suicide_Command_Cond_HasCharges takes nothing returns boolean
    return(udg_GatherState[GetConvertedPlayerId(GetTriggerPlayer())]>0)
endfunction

function Trig_Suicide_Command_Actions takes nothing returns nothing
    if(Trig_Suicide_Command_Cond_HasCharges())then
        if(Trig_Suicide_Command_Cond_HasMaxCharges())then
            call RemoveItem(udg_GatherItem[udg_TempInteger])
        endif
        call ConditionalTriggerExecute(gg_trg_Fishing_End)
    endif
    call KillUnit(Player_GetHero(GetTriggerPlayer()))
endfunction

// World Editor calls InitTrig_Suicide automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Suicide (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Suicide takes nothing returns nothing
endfunction

function Register_Suicide_Command takes nothing returns nothing
    set gg_trg_Suicide_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Suicide_Command,Player(0),"-suicide",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Suicide_Command,Player(1),"-suicide",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Suicide_Command,Player(2),"-suicide",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Suicide_Command,Player(3),"-suicide",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Suicide_Command,Player(4),"-suicide",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Suicide_Command,Player(5),"-suicide",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Suicide_Command,Player(6),"-suicide",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Suicide_Command,Player(7),"-suicide",true)
    call TriggerAddAction(gg_trg_Suicide_Command,function Trig_Suicide_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Suicide takes nothing returns nothing
    call Register_Suicide_Command()
endfunction

endlibrary
