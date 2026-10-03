library TAim requires TAbil
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Aim_Cast=null
endglobals

function Trig_Aim_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14B') // 'A14B': ability "Aim"
endfunction

function Trig_Aim_Cast_MissingAimLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RH',GetTriggerUnit())<=0) // 'A0RH': ability "Aim"
endfunction

function Trig_Aim_Cast_Actions takes nothing returns nothing
    local integer l_tempInteger
    if(Trig_Aim_Cast_MissingAimLevel())then
        call UnitAddAbilityBJ('A0RH',GetTriggerUnit()) // 'A0RH': ability "Aim"
    endif
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (20).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 20)
    call SetUnitAbilityLevelSwapped('A0RH',GetTriggerUnit(),l_tempInteger) // 'A0RH': ability "Aim"
    set udg_BlindSpotCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
endfunction

// World Editor calls InitTrig_Aim automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Aim (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Aim takes nothing returns nothing
endfunction

function Register_Aim_Cast takes nothing returns nothing
    set gg_trg_Aim_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Aim_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Aim_Cast,Condition(function Trig_Aim_Cast_Conditions))
    call TriggerAddAction(gg_trg_Aim_Cast,function Trig_Aim_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Aim takes nothing returns nothing
    call Register_Aim_Cast()
endfunction

endlibrary
