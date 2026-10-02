library TTextInstant
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_TextInstant_Command=null
endglobals

function Trig_TextInstant_Command_Actions takes nothing returns nothing
    set udg_CinematicsDisabled=false
    set udg_TextSpeed=.0
    call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" changed text speed to |cffffcc00Instant|r"))
endfunction

// World Editor calls InitTrig_TextInstant automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_TextInstant (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_TextInstant takes nothing returns nothing
endfunction

function Register_TextInstant_Command takes nothing returns nothing
    set gg_trg_TextInstant_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(0),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(1),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(2),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(3),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(4),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(5),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(6),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(7),"-instant",true)
    call TriggerAddAction(gg_trg_TextInstant_Command,function Trig_TextInstant_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_TextInstant takes nothing returns nothing
    call Register_TextInstant_Command()
endfunction

endlibrary
