library TLegendary
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legendary_Unlock=null
endglobals

function Trig_Legendary_Unlock_IsShrineUnlocked takes nothing returns boolean
    return(udg_ShrineUnlocked)
endfunction

function Trig_Legendary_Unlock_Actions takes nothing returns nothing
    set udg_LegendaryUnlocked=true
    call ShowUnitShow(udg_ShrineMenuUnit[18])
    if(Trig_Legendary_Unlock_IsShrineUnlocked())then
        call ShowUnitShow(udg_ShrineMenuUnit[19])
    endif
    call GroupAddUnitSimple(udg_ShrineMenuUnit[19],udg_SecondShrineUnits)
    call AddUnitToStockBJ('n0KL',gg_unit_n04U_0204,1,1) // 'n0KL': unit "Legendary Bonus Menu"
    call AddUnitToStockBJ('n0KL',gg_unit_n04U_0189,1,1) // 'n0KL': unit "Legendary Bonus Menu"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Legendary automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Legendary (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Legendary takes nothing returns nothing
endfunction

function Register_Legendary_Unlock takes nothing returns nothing
    set gg_trg_Legendary_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_Legendary_Unlock)
    call TriggerAddAction(gg_trg_Legendary_Unlock,function Trig_Legendary_Unlock_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Legendary takes nothing returns nothing
    call Register_Legendary_Unlock()
endfunction

endlibrary
