library TAlly
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ally_Death_Cleanup=null
endglobals

function Trig_Ally_Death_Cleanup_IsDefenderUnit takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_AllyBrothersGroup))or(IsUnitInGroup(GetTriggerUnit(),udg_AllyRangerGroup))or(IsUnitInGroup(GetTriggerUnit(),udg_AllyEngineerGroup))
endfunction

function Trig_Ally_Death_Cleanup_Conditions takes nothing returns boolean
    return(Trig_Ally_Death_Cleanup_IsDefenderUnit())
endfunction

function Trig_Ally_Death_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AllyBrothersGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AllyRangerGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AllyEngineerGroup)
    call GroupAddUnitSimple(GetTriggerUnit(),udg_InactiveUnits)
endfunction

// World Editor calls InitTrig_Ally automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ally (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ally takes nothing returns nothing
endfunction

function Register_Ally_Death_Cleanup takes nothing returns nothing
    set gg_trg_Ally_Death_Cleanup=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Ally_Death_Cleanup,Player(9),EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Ally_Death_Cleanup,Condition(function Trig_Ally_Death_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Ally_Death_Cleanup,function Trig_Ally_Death_Cleanup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ally takes nothing returns nothing
    call Register_Ally_Death_Cleanup()
endfunction

endlibrary
