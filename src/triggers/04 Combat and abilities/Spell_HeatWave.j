library TSpellHeatWave
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_HeatWave_Cast=null
endglobals

function Trig_Spell_HeatWave_Cast_IsHeatWave takes nothing returns boolean
    return(GetSpellAbilityId()=='A0U3')or(GetSpellAbilityId()=='A019') // 'A0U3': ability "Heat Wave"; 'A019': ability "Heat Wave"
endfunction

function Trig_Spell_HeatWave_Cast_Conditions takes nothing returns boolean
    return(Trig_Spell_HeatWave_Cast_IsHeatWave())
endfunction

function Trig_Spell_HeatWave_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_HeatWave_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Spell_HeatWave_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // ((Strength of the triggering unit) times (5)) plus (4000) treated as a decimal-capable number.
    call SaveRealBJ(I2R(((GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*5)+$FA0)),1,udg_TempHandleId,udg_ProxyDamageHash) // $FA0 = 4000
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0FA',GetLastCreatedUnit()) // 'A0FA': ability "Heat Wave"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"breathoffrost",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Spell_HeatWave takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part5 (module Spell),
// which keeps the original registration order.

function Register_Spell_HeatWave_Cast takes nothing returns nothing
    set gg_trg_Spell_HeatWave_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_HeatWave_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_HeatWave_Cast,Condition(function Trig_Spell_HeatWave_Cast_Conditions))
    call TriggerAddAction(gg_trg_Spell_HeatWave_Cast,function Trig_Spell_HeatWave_Cast_Actions)
endfunction

endlibrary
