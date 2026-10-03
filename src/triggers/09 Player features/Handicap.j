library THandicap requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Handicap_Command=null
endglobals

function Trig_Handicap_Command_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetTriggerPlayer())
    call DisplayTimedTextToForce(l_tempForce,10.,("Enemy base HP: |cffffcc00 "+(R2S(GetPlayerHandicapBJ(Player($B)))+"%|r"))) // $B = 11
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_Handicap automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Handicap (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Handicap takes nothing returns nothing
endfunction

function Register_Handicap_Command takes nothing returns nothing
    set gg_trg_Handicap_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(0),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(1),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(2),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(3),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(4),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(5),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(6),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(7),"-handicap",true)
    call TriggerAddAction(gg_trg_Handicap_Command,function Trig_Handicap_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Handicap takes nothing returns nothing
    call Register_Handicap_Command()
endfunction

endlibrary
