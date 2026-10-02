library TSpellQuake requires TAbil, TProf
function Trig_Spell_Quake_IsQuakeSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A090')or(GetSpellAbilityId()=='A0PV')or(GetSpellAbilityId()=='A0PX')or(GetSpellAbilityId()=='A0PY')or(GetSpellAbilityId()=='A0S7')or(GetSpellAbilityId()=='A14Z') // 'A090': ability "Quake"; 'A0PV': ability "Quake"; 'A0PX': ability "Quakera"; 'A0PY': ability "Quakeraga"; 'A0S7': ability "Quake"; 'A14Z': ability "Quake"
endfunction

function Trig_Spell_Quake_Conditions takes nothing returns boolean
    return(Trig_Spell_Quake_IsQuakeSpell())
endfunction

function Trig_Spell_Quake_IsPointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_Quake_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Quake_Actions takes nothing returns nothing
    if(Trig_Spell_Quake_IsPointCast())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 2)
    if(Trig_Spell_Quake_IsCasterHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) divided by (4); drop the remainder).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 4))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M5',GetLastCreatedUnit()) // 'A0M5': ability "Earth-elemental Damage"
    call UnitAddAbilityBJ('A0PW',GetLastCreatedUnit()) // 'A0PW': ability "Quake"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"flamestrike",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Spell_Quake takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Quake takes nothing returns nothing
    set gg_trg_Spell_Quake=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Quake,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Quake,Condition(function Trig_Spell_Quake_Conditions))
    call TriggerAddAction(gg_trg_Spell_Quake,function Trig_Spell_Quake_Actions)
endfunction

endlibrary
