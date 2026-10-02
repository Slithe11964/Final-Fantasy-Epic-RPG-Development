library TCombo
function Trig_Combo_CancelOnAttack_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A137',GetAttacker())>0)and(GetTriggerUnit()!=LoadUnitHandleBJ(1,GetHandleIdBJ(GetAttacker()),udg_ComboHash))and(UnitHasBuffBJ(GetTriggerUnit(),'B063')==false) // 'A137': ability "Combo Strike"; 'B063': buff "Cover"
endfunction

function Trig_Combo_CancelOnAttack_Actions takes nothing returns nothing
    call UnitRemoveAbilityBJ('A137',GetAttacker()) // 'A137': ability "Combo Strike"
    call FlushChildHashtableBJ(GetHandleIdBJ(GetAttacker()),udg_ComboHash)
    call UnitRemoveBuffBJ('B07L',GetAttacker()) // 'B07L': buff tooltip "Renzokuken"
endfunction

function Trig_Combo_CancelOnCast_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A137',GetTriggerUnit())>0)and(GetSpellAbilityId()!='A18P') // 'A137': ability "Combo Strike"; 'A18P': ability "!Iainuki"
endfunction

function Trig_Combo_CancelOnCast_Actions takes nothing returns nothing
    call UnitRemoveAbilityBJ('A137',GetTriggerUnit()) // 'A137': ability "Combo Strike"
    call FlushChildHashtableBJ(GetHandleIdBJ(GetTriggerUnit()),udg_ComboHash)
    call UnitRemoveBuffBJ('B07L',GetTriggerUnit()) // 'B07L': buff tooltip "Renzokuken"
endfunction

// World Editor calls InitTrig_Combo automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Combo (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Combo takes nothing returns nothing
endfunction

function Register_Combo_CancelOnAttack takes nothing returns nothing
    set gg_trg_Combo_CancelOnAttack=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Combo_CancelOnAttack,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Combo_CancelOnAttack,Condition(function Trig_Combo_CancelOnAttack_Conditions))
    call TriggerAddAction(gg_trg_Combo_CancelOnAttack,function Trig_Combo_CancelOnAttack_Actions)
endfunction

function Register_Combo_CancelOnCast takes nothing returns nothing
    set gg_trg_Combo_CancelOnCast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Combo_CancelOnCast,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Combo_CancelOnCast,Condition(function Trig_Combo_CancelOnCast_Conditions))
    call TriggerAddAction(gg_trg_Combo_CancelOnCast,function Trig_Combo_CancelOnCast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Combo takes nothing returns nothing
    call Register_Combo_CancelOnAttack()
    call Register_Combo_CancelOnCast()
endfunction

endlibrary
