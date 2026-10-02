library TRoll
function Trig_Roll_Command_Actions takes nothing returns nothing
    // A random whole number from 1 through 100.
    call DisplayTimedTextToForce(GetPlayersAll(),15.,((udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" rolled |cffffcc00")+(I2S(GetRandomInt(1,'d'))+"|r (1-100)!")))
endfunction

// World Editor calls InitTrig_Roll automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Roll (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Roll takes nothing returns nothing
endfunction

function Register_Roll_Command takes nothing returns nothing
    set gg_trg_Roll_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(0),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(1),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(2),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(3),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(4),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(5),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(6),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(7),"-roll",true)
    call TriggerAddAction(gg_trg_Roll_Command,function Trig_Roll_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Roll takes nothing returns nothing
    call Register_Roll_Command()
endfunction

endlibrary
