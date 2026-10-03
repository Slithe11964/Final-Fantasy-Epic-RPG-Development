library TSpellMeteor requires TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_Meteor_Wide=null
endglobals

function Trig_Spell_Meteor_Wide_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A028') // 'A028': ability "Meteor"
endfunction

function Trig_Spell_Meteor_Wide_IsPointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_Meteor_Wide_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Meteor_Wide_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local real l_tempReal
    if(Trig_Spell_Meteor_Wide_IsPointCast())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger='d'
    if(Trig_Spell_Meteor_Wide_IsCasterHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    set l_tempReal=Prof_InnerManaPower(GetTriggerUnit())
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0W0',GetLastCreatedUnit()) // 'A0W0': ability "Wide Meteor"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Spell_Meteor takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Meteor_Wide takes nothing returns nothing
    set gg_trg_Spell_Meteor_Wide=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Meteor_Wide,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Meteor_Wide,Condition(function Trig_Spell_Meteor_Wide_Conditions))
    call TriggerAddAction(gg_trg_Spell_Meteor_Wide,function Trig_Spell_Meteor_Wide_Actions)
endfunction

endlibrary
