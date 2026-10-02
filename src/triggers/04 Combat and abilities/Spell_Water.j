library TSpellWater requires TAbil, TProf
function Trig_Spell_Water_IsWaterSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A08X')or(GetSpellAbilityId()=='A0Q0')or(GetSpellAbilityId()=='A0Q1')or(GetSpellAbilityId()=='A0Q2')or(GetSpellAbilityId()=='A0SM')or(GetSpellAbilityId()=='A0TP')or(GetSpellAbilityId()=='A0SA')or(GetSpellAbilityId()=='A150') // 'A08X': ability "Water"; 'A0Q0': ability "Water"; 'A0Q1': ability "Watera"; 'A0Q2': ability "Wateraga"; 'A0SM': ability "Water"; 'A0TP': ability "Water"; 'A0SA': ability "Water"; 'A150': ability "Water"
endfunction

function Trig_Spell_Water_Conditions takes nothing returns boolean
    return(Trig_Spell_Water_IsWaterSpell())
endfunction

function Trig_Spell_Water_IsPointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_Water_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Water_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Spell_Water_IsPointCast())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (5).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*5)
    if(Trig_Spell_Water_IsCasterHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (6)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*6))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M4',GetLastCreatedUnit()) // 'A0M4': ability "Water-elemental Damage"
    call UnitAddAbilityBJ('A0PZ',GetLastCreatedUnit()) // 'A0PZ': ability "Water"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"carrionswarm",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Spell_Water takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Water takes nothing returns nothing
    set gg_trg_Spell_Water=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Water,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Water,Condition(function Trig_Spell_Water_Conditions))
    call TriggerAddAction(gg_trg_Spell_Water,function Trig_Spell_Water_Actions)
endfunction

endlibrary
