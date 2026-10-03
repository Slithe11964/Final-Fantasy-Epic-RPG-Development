library TCover requires TAbil, TLink
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Cover_Cast=null
endglobals

function Trig_Cover_Cast_IsCover takes nothing returns boolean
    return(GetSpellAbilityId()=='A023')or(GetSpellAbilityId()=='A0XZ')or(GetSpellAbilityId()=='A027')or(GetSpellAbilityId()=='A1DZ')or(GetSpellAbilityId()=='A01O') // 'A023': ability "Cover"; 'A0XZ': ability "Cover"; 'A027': ability "Cover"; 'A1DZ': ability "Cover"; 'A01O': ability "Cover"
endfunction

function Trig_Cover_Cast_Conditions takes nothing returns boolean
    return(Trig_Cover_Cast_IsCover())
endfunction

function Trig_Cover_Cast_IsSquireMaster takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[0])==false)and(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3)and(GetUnitTypeId(GetTriggerUnit())=='H000') // 'A02F': ability "Mastery"; 'H000': unit "Squire"
endfunction

function Trig_Cover_Cast_Actions takes nothing returns nothing
    local integer l_tempInteger
    if(Trig_Cover_Cast_IsSquireMaster())then
        set udg_CoverAwardCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
        call UnitAddAbilityBJ('A0O4',GetSpellTargetUnit()) // 'A0O4': ability "Cover"
        call SetUnitAbilityLevelSwapped('A0O4',GetSpellTargetUnit(),GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))) // 'A0O4': ability "Cover"
    else
        call UnitRemoveAbilityBJ('A0O4',GetSpellTargetUnit()) // 'A0O4': ability "Cover"
    endif
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) times (5).
    // Result 2: (result 1) plus (250).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*5)+$FA // $FA = 250
    // Udg_TempInteger treated as a decimal-capable number.
    call Link_SaveCaster(GetTriggerUnit(),GetSpellTargetUnit(),I2R(l_tempInteger))
endfunction

// World Editor calls InitTrig_Cover automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cover (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cover takes nothing returns nothing
endfunction

function Register_Cover_Cast takes nothing returns nothing
    set gg_trg_Cover_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cover_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Cover_Cast,Condition(function Trig_Cover_Cast_Conditions))
    call TriggerAddAction(gg_trg_Cover_Cast,function Trig_Cover_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cover takes nothing returns nothing
    call Register_Cover_Cast()
endfunction

endlibrary
