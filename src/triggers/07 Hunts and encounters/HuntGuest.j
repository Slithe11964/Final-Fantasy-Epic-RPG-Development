library THuntGuest
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HuntGuest_DefaultKrjn=null
endglobals

function Trig_HuntGuest_DefaultKrjn_Actions takes nothing returns nothing
    set udg_NaishaTownUnit=gg_unit_e012_0227
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_HuntGuest automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HuntGuest (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HuntGuest takes nothing returns nothing
endfunction

function Register_HuntGuest_DefaultKrjn takes nothing returns nothing
    set gg_trg_HuntGuest_DefaultKrjn=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_HuntGuest_DefaultKrjn,12.)
    call TriggerAddAction(gg_trg_HuntGuest_DefaultKrjn,function Trig_HuntGuest_DefaultKrjn_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HuntGuest takes nothing returns nothing
    call Register_HuntGuest_DefaultKrjn()
endfunction

endlibrary
