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
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    if(Trig_Spell_Water_IsPointCast())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),l_tempPoint,0)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*5)
    if(Trig_Spell_Water_IsCasterHero())then
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*6))
    endif
    set l_tempReal=Prof_RodPower(GetTriggerUnit())
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M4',GetLastCreatedUnit()) // 'A0M4': ability "Water-elemental Damage"
    call UnitAddAbilityBJ('A0PZ',GetLastCreatedUnit()) // 'A0PZ': ability "Water"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"carrionswarm",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
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
