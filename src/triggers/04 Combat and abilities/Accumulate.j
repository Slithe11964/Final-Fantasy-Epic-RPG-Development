library TAccumulate
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Accumulate_Cast=null
endglobals

function Trig_Accumulate_Cast_IsAccumulate takes nothing returns boolean
    return(GetSpellAbilityId()=='A003')or(GetSpellAbilityId()=='A03Z') // 'A003': ability "Accumulate"; 'A03Z': ability "Accumulate"
endfunction

function Trig_Accumulate_Cast_Conditions takes nothing returns boolean
    return(Trig_Accumulate_Cast_IsAccumulate())
endfunction

function Trig_Accumulate_Cast_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B03D',GetTriggerUnit()) // 'B03D': buff tooltip "Spawn Protection"
    set udg_DmgFlagPure=true
    set udg_IsPureDamage=true
    // (maximum health of the triggering unit) times (0.3).
    call UnitDamageTargetBJ(GetTriggerUnit(),GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())*.3),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
endfunction

// World Editor calls InitTrig_Accumulate automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Accumulate (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Accumulate takes nothing returns nothing
endfunction

function Register_Accumulate_Cast takes nothing returns nothing
    set gg_trg_Accumulate_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Accumulate_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Accumulate_Cast,Condition(function Trig_Accumulate_Cast_Conditions))
    call TriggerAddAction(gg_trg_Accumulate_Cast,function Trig_Accumulate_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Accumulate takes nothing returns nothing
    call Register_Accumulate_Cast()
endfunction

endlibrary
