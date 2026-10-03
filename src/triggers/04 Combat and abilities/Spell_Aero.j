library TSpellAero requires TAbil, TProf
function Trig_Spell_Aero_IsAeroSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A029')or(GetSpellAbilityId()=='A0Q3')or(GetSpellAbilityId()=='A0Q5')or(GetSpellAbilityId()=='A0Q6')or(GetSpellAbilityId()=='A0SR')or(GetSpellAbilityId()=='A0SS')or(GetSpellAbilityId()=='A14Y') // 'A029': ability "Aero"; 'A0Q3': ability "Aero"; 'A0Q5': ability "Aerora"; 'A0Q6': ability "Aeroga"; 'A0SR': ability "Aero"; 'A0SS': ability "Aero"; 'A14Y': ability "Aero"
endfunction

function Trig_Spell_Aero_Conditions takes nothing returns boolean
    return(Trig_Spell_Aero_IsAeroSpell())
endfunction

function Trig_Spell_Aero_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Aero_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (2).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_Spell_Aero_IsCasterHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) divided by (2); drop the remainder).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 2))
    endif
    set l_tempReal=Prof_RodPower(GetTriggerUnit())
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(10.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M6',GetLastCreatedUnit()) // 'A0M6': ability "Wind-elemental Damage"
    call UnitAddAbilityBJ('A0Q4',GetLastCreatedUnit()) // 'A0Q4': ability "Aero"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
    set l_tempPoint=null
endfunction

function InitTrig_Spell_Aero takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Aero takes nothing returns nothing
    set gg_trg_Spell_Aero=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Aero,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Aero,Condition(function Trig_Spell_Aero_Conditions))
    call TriggerAddAction(gg_trg_Spell_Aero,function Trig_Spell_Aero_Actions)
endfunction

endlibrary
