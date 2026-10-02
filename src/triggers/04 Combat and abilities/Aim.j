library TAim requires TAbil
function Trig_Aim_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14B') // 'A14B': ability "Aim"
endfunction

function Trig_Aim_Cast_MissingAimLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RH',GetTriggerUnit())<=0) // 'A0RH': ability "Aim"
endfunction

function Trig_Aim_Cast_Actions takes nothing returns nothing
    if(Trig_Aim_Cast_MissingAimLevel())then
        call UnitAddAbilityBJ('A0RH',GetTriggerUnit()) // 'A0RH': ability "Aim"
    endif
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (20).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 20)
    call SetUnitAbilityLevelSwapped('A0RH',GetTriggerUnit(),udg_TempInteger) // 'A0RH': ability "Aim"
    set udg_BlindSpotCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Aim takes nothing returns nothing
endfunction
function RegisterR11_Aim_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Aim_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Aim_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Aim_Cast,Condition(function Trig_Aim_Cast_Conditions))
    call TriggerAddAction(gg_trg_Aim_Cast,function Trig_Aim_Cast_Actions)
endfunction




endlibrary
