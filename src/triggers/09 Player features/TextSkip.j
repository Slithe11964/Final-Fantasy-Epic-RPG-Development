library TTextSkip
function Trig_TextSkip_Command_Actions takes nothing returns nothing
    set udg_CinematicsDisabled=true
    set udg_TextSpeed=.0
    call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" changed text speed to |cffffcc00Skip|r"))
endfunction

// World Editor calls InitTrig_TextSkip automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_TextSkip (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_TextSkip takes nothing returns nothing
endfunction

function Register_TextSkip_Command takes nothing returns nothing
    set gg_trg_TextSkip_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSkip_Command,Player(0),"-skip",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSkip_Command,Player(1),"-skip",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSkip_Command,Player(2),"-skip",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSkip_Command,Player(3),"-skip",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSkip_Command,Player(4),"-skip",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSkip_Command,Player(5),"-skip",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSkip_Command,Player(6),"-skip",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSkip_Command,Player(7),"-skip",true)
    call TriggerAddAction(gg_trg_TextSkip_Command,function Trig_TextSkip_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_TextSkip takes nothing returns nothing
    call Register_TextSkip_Command()
endfunction

endlibrary
