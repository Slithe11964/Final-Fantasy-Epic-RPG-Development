library TExdeath
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Exdeath_Drop_Scroll=null
endglobals

function Trig_Exdeath_Drop_Scroll_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0EV',l_tempPoint) // 'I0EV': item "Spirit Scroll"
    call RemoveLocation(l_tempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Exdeath automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Exdeath (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Exdeath takes nothing returns nothing
endfunction

function Register_Exdeath_Drop_Scroll takes nothing returns nothing
    set gg_trg_Exdeath_Drop_Scroll=CreateTrigger()
    call TriggerAddAction(gg_trg_Exdeath_Drop_Scroll,function Trig_Exdeath_Drop_Scroll_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Exdeath takes nothing returns nothing
    call Register_Exdeath_Drop_Scroll() // used by Hunt_Encounters
endfunction

endlibrary
