library TEnemy requires TUnit
function Trig_Enemy_Summon_Setup_Conditions takes nothing returns boolean
    return((IsUnitType(GetSummonedUnit(),UNIT_TYPE_RESISTANT)==false)and(IsUnitIllusionBJ(GetSummonedUnit())==false))!=null
endfunction

function Trig_Enemy_Summon_Setup_Actions takes nothing returns nothing
    call Unit_ScaleToLevel60(GetSummonedUnit())
endfunction

// World Editor calls InitTrig_Enemy automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Enemy (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Enemy takes nothing returns nothing
endfunction

function Register_Enemy_Summon_Setup takes nothing returns nothing
    set gg_trg_Enemy_Summon_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Enemy_Summon_Setup)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Enemy_Summon_Setup,Player($B),EVENT_PLAYER_UNIT_SUMMON) // $B = 11
    call TriggerAddCondition(gg_trg_Enemy_Summon_Setup,Condition(function Trig_Enemy_Summon_Setup_Conditions))
    call TriggerAddAction(gg_trg_Enemy_Summon_Setup,function Trig_Enemy_Summon_Setup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Enemy takes nothing returns nothing
    call Register_Enemy_Summon_Setup()
endfunction

endlibrary
