library TOkuu
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Okuu_Leash=null
    trigger gg_trg_Okuu_Death=null
endglobals

function Trig_Okuu_Leash_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_HuntTarget[28])and(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Okuu_Leash_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_714)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,270.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Okuu_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Okuu_Leash)
    call DestroyTrigger(gg_trg_Okuu_Leash)
    call GroupRemoveUnitSimple(udg_HuntTarget[28],udg_BossGroup)
    set udg_OkuuStage=2
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Okuu automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Okuu (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Okuu takes nothing returns nothing
endfunction

function Register_Okuu_Leash takes nothing returns nothing
    set gg_trg_Okuu_Leash=CreateTrigger()
    call DisableTrigger(gg_trg_Okuu_Leash)
    call TriggerRegisterEnterRectSimple(gg_trg_Okuu_Leash,gg_rct_638)
    call TriggerRegisterEnterRectSimple(gg_trg_Okuu_Leash,gg_rct_631)
    call TriggerAddCondition(gg_trg_Okuu_Leash,Condition(function Trig_Okuu_Leash_Conditions))
    call TriggerAddAction(gg_trg_Okuu_Leash,function Trig_Okuu_Leash_Actions)
endfunction

function Register_Okuu_Death takes nothing returns nothing
    set gg_trg_Okuu_Death=CreateTrigger()
    call TriggerAddAction(gg_trg_Okuu_Death,function Trig_Okuu_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Okuu takes nothing returns nothing
    call Register_Okuu_Leash() // starts off; enabled by Hunt_Encounters; disabled by Okuu; destroyed by Okuu
    call Register_Okuu_Death() // disabled by Quest_ScorchedEarth; destroyed by Quest_ScorchedEarth; used by Hunt_Encounters
endfunction

endlibrary
