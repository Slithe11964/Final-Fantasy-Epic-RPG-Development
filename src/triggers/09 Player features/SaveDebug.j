library TSaveDebug
function Trig_SaveDebug_Command_Cond_DebugOff takes nothing returns boolean
    return(udg_SaveDebug==false)
endfunction

function Trig_SaveDebug_Command_Actions takes nothing returns nothing
    if(Trig_SaveDebug_Command_Cond_DebugOff())then
        set udg_SaveDebug=true
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"Save debug logging enabled.")
    else
        set udg_SaveDebug=false
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"Save debug logging disabled.")
    endif
endfunction

// World Editor calls InitTrig_SaveDebug automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_SaveDebug (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_SaveDebug takes nothing returns nothing
endfunction

function Register_SaveDebug_Command takes nothing returns nothing
    set gg_trg_SaveDebug_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(0),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(1),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(2),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(3),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(4),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(5),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(6),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(7),"-sdebug",true)
    call TriggerAddAction(gg_trg_SaveDebug_Command,function Trig_SaveDebug_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_SaveDebug takes nothing returns nothing
    call Register_SaveDebug_Command()
endfunction

endlibrary
