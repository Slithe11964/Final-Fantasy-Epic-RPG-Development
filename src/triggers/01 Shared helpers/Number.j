library TNumber requires TForce
function Trig_Number_Command_Actions takes nothing returns nothing
    call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),("Your number is: "+I2S(GetConvertedPlayerId(GetTriggerPlayer()))))
endfunction

// World Editor calls InitTrig_Number automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Number (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Number takes nothing returns nothing
endfunction

function Register_Number_Command takes nothing returns nothing
    set gg_trg_Number_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(0),"-number",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(1),"-number",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(2),"-number",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(3),"-number",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(4),"-number",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(5),"-number",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(6),"-number",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(7),"-number",true)
    call TriggerAddAction(gg_trg_Number_Command,function Trig_Number_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Number takes nothing returns nothing
    call Register_Number_Command()
endfunction

endlibrary
