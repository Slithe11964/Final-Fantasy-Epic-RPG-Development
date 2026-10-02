library TExdeath
function Trig_Exdeath_Drop_Scroll_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0EV',udg_TempPoint) // 'I0EV': item "Spirit Scroll"
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
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
    call Register_Exdeath_Drop_Scroll()
endfunction

endlibrary
