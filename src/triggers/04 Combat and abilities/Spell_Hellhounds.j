library TSpellHellhounds requires TAbil, TLoc
function Trig_Spell_Hellhounds_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0YZ') // 'A0YZ': ability "Hellhounds"
endfunction

function Trig_Spell_Hellhounds_Cond_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Hellhounds_Cond_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_Hellhounds_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (3).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Spell_Hellhounds_Cond_IsHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) times (4)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*4))
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Spell_Hellhounds_Cond_NoTargetUnit())then
        set udg_TempPoint2=GetSpellTargetLoc()
    else
        set udg_TempPoint2=GetUnitLoc(GetSpellTargetUnit())
    endif
    set l_tempReal=AngleBetweenPoints(l_tempPoint,udg_TempPoint2)
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,udg_TempPoint2) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(l_tempInteger),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,l_tempHandleId,udg_ProxyDamageHash)
    call SaveBooleanBJ(true,4,l_tempHandleId,udg_ProxyDamageHash)
    call SaveBooleanBJ(true,5,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(4.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
    call UnitAddAbilityBJ('A0Y1',GetLastCreatedUnit()) // 'A0Y1': ability "Sinister Wave"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"carrionswarm",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((l_tempReal) plus (30)) by (360).
    set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,256,ModuloReal((l_tempReal+30.),360.))
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,udg_TempPoint2) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(l_tempInteger),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,l_tempHandleId,udg_ProxyDamageHash)
    call SaveBooleanBJ(true,4,l_tempHandleId,udg_ProxyDamageHash)
    call SaveBooleanBJ(true,5,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(4.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
    call UnitAddAbilityBJ('A0Y1',GetLastCreatedUnit()) // 'A0Y1': ability "Sinister Wave"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"carrionswarm",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    // The remainder after dividing ((l_tempReal) plus (330)) by (360).
    set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,256,ModuloReal((l_tempReal+330.),360.))
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,udg_TempPoint2) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(l_tempInteger),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,l_tempHandleId,udg_ProxyDamageHash)
    call SaveBooleanBJ(true,4,l_tempHandleId,udg_ProxyDamageHash)
    call SaveBooleanBJ(true,5,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(4.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
    call UnitAddAbilityBJ('A0Y1',GetLastCreatedUnit()) // 'A0Y1': ability "Sinister Wave"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"carrionswarm",udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function InitTrig_Spell_Hellhounds takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part4 (module Spell),
// which keeps the original registration order.

function Register_Spell_Hellhounds takes nothing returns nothing
    set gg_trg_Spell_Hellhounds=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Hellhounds,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Hellhounds,Condition(function Trig_Spell_Hellhounds_Conditions))
    call TriggerAddAction(gg_trg_Spell_Hellhounds,function Trig_Spell_Hellhounds_Actions)
endfunction

endlibrary
