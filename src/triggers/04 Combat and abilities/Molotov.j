library TMolotov
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Molotov_DamageOnAttack=null
endglobals

function Trig_Molotov_DamageOnAttack_Conditions takes nothing returns boolean
    return(UnitHasBuffBJ(GetAttacker(),'B002')) // 'B002': buff tooltip "Burn"
endfunction

function Trig_Molotov_DamageOnAttack_Actions takes nothing returns nothing
    set udg_DmgFlagUnavoidable=-1
    set udg_DamageElement=1
    call UnitDamageTargetBJ(LoadUnitHandleBJ(0,GetHandleIdBJ(GetAttacker()),udg_MolotovHash),GetAttacker(),LoadRealBJ(1,GetHandleIdBJ(GetAttacker()),udg_MolotovHash),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC)
endfunction

// World Editor calls InitTrig_Molotov automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Molotov (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Molotov takes nothing returns nothing
endfunction

function Register_Molotov_DamageOnAttack takes nothing returns nothing
    set gg_trg_Molotov_DamageOnAttack=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Molotov_DamageOnAttack,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Molotov_DamageOnAttack,Condition(function Trig_Molotov_DamageOnAttack_Conditions))
    call TriggerAddAction(gg_trg_Molotov_DamageOnAttack,function Trig_Molotov_DamageOnAttack_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Molotov takes nothing returns nothing
    call Register_Molotov_DamageOnAttack()
endfunction

endlibrary
