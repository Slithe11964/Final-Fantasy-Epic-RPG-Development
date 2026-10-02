library TClear requires TForce
function Trig_Clear_Command_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    call ClearTextMessagesBJ(udg_TempForce)
    call DestroyForce(udg_TempForce)
endfunction

// World Editor calls InitTrig_Clear automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Clear (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Clear takes nothing returns nothing
endfunction

function Register_Clear_Command takes nothing returns nothing
    set gg_trg_Clear_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(0),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(1),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(2),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(3),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(4),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(5),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(6),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(7),"-clear",true)
    call TriggerAddAction(gg_trg_Clear_Command,function Trig_Clear_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Clear takes nothing returns nothing
    call Register_Clear_Command()
endfunction

endlibrary
