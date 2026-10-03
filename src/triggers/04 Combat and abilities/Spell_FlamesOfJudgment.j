library TSpellFlamesOfJudgment requires TAbil, TLoc, TProf
function Trig_Spell_FlamesOfJudgment_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0YS') // 'A0YS': ability "Flames of Judgment"
endfunction

function Trig_Spell_FlamesOfJudgment_Cond_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_FlamesOfJudgment_Cond_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_FlamesOfJudgment_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local real l_tempReal
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (2).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 2)
    if(Trig_Spell_FlamesOfJudgment_Cond_IsHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) divided by (2); drop the remainder).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 2))
    endif
    set l_tempReal=Prof_RodPower(GetTriggerUnit())
    if(Trig_Spell_FlamesOfJudgment_Cond_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
    call UnitAddAbilityBJ('A0DQ',GetLastCreatedUnit()) // 'A0DQ': ability "Fire"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"flamestrike",udg_TempPoint)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,400.,(I2R(GetForLoopIndexA())*60.))
        call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,udg_TempPoint2) // 'h01B': unit "Proxy Dummy"
        set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
        call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
        // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
        call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
        call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
        call ShowUnitHide(GetLastCreatedUnit())
        call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
        call UnitAddAbilityBJ('A0DQ',GetLastCreatedUnit()) // 'A0DQ': ability "Fire"
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"flamestrike",udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Spell_FlamesOfJudgment takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part4 (module Spell),
// which keeps the original registration order.

function Register_Spell_FlamesOfJudgment takes nothing returns nothing
    set gg_trg_Spell_FlamesOfJudgment=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_FlamesOfJudgment,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_FlamesOfJudgment,Condition(function Trig_Spell_FlamesOfJudgment_Conditions))
    call TriggerAddAction(gg_trg_Spell_FlamesOfJudgment,function Trig_Spell_FlamesOfJudgment_Actions)
endfunction

endlibrary
