library TDrainAttack
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DrainAttack_LevelSync=null
endglobals

function Trig_DrainAttack_LevelSync_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0R1') // 'A0R1': ability "Drain Attack"
endfunction

function Trig_DrainAttack_LevelSync_LacksPassiveAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0R2',GetTriggerUnit())<=0) // 'A0R2': ability "Drain Attack"
endfunction

function Trig_DrainAttack_LevelSync_Actions takes nothing returns nothing
    if(Trig_DrainAttack_LevelSync_LacksPassiveAbility())then
        call UnitAddAbilityBJ('A0R2',GetTriggerUnit()) // 'A0R2': ability "Drain Attack"
    endif
    call SetUnitAbilityLevelSwapped('A0R2',GetTriggerUnit(),GetUnitAbilityLevelSwapped('A0R1',GetTriggerUnit())) // 'A0R2': ability "Drain Attack"; 'A0R1': ability "Drain Attack"
endfunction

// World Editor calls InitTrig_DrainAttack automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DrainAttack (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DrainAttack takes nothing returns nothing
endfunction

function Register_DrainAttack_LevelSync takes nothing returns nothing
    set gg_trg_DrainAttack_LevelSync=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_DrainAttack_LevelSync,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_DrainAttack_LevelSync,Condition(function Trig_DrainAttack_LevelSync_Conditions))
    call TriggerAddAction(gg_trg_DrainAttack_LevelSync,function Trig_DrainAttack_LevelSync_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DrainAttack takes nothing returns nothing
    call Register_DrainAttack_LevelSync()
endfunction

endlibrary
