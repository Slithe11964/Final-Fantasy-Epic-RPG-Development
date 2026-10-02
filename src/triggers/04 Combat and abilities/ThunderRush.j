library TThunderRush requires TLoc, TWait
function Trig_ThunderRush_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0ZQ') // 'A0ZQ': ability "!Thunder Rush"
endfunction

function Trig_ThunderRush_Cast_IsCasterHeroLeft takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_ThunderRush_Cast_IsCasterHeroRight takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_ThunderRush_Cast_IsCritical takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<25.)or(UnitHasBuffBJ(GetTriggerUnit(),'B05V')) // 'B05V': buff tooltip "Disease"
endfunction

function Trig_ThunderRush_Cast_IsBelow75 takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<75.)
endfunction

function Trig_ThunderRush_Cast_IsBelow50 takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<50.)
endfunction

function Trig_ThunderRush_Cast_UseMaxLevel takes nothing returns boolean
    return(Trig_ThunderRush_Cast_IsCritical())
endfunction

function Trig_ThunderRush_Cast_FreeCastOn takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_ThunderRush_Cast_IsEnraged takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<50.)or(UnitHasBuffBJ(GetTriggerUnit(),'B05V')) // 'B05V': buff tooltip "Disease"
endfunction

function Trig_ThunderRush_Cast_ShouldResetSurge takes nothing returns boolean
    return(Trig_ThunderRush_Cast_IsEnraged())
endfunction

function Trig_ThunderRush_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    // The remainder after dividing ((facing in degrees of the triggering unit) plus (90)) by (360).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,100.,ModuloReal((GetUnitFacing(GetTriggerUnit())+90.),360.))
    call CreateNUnitsAtLoc(1,'u013',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'u013': unit "Thunder Rush"
    call RemoveLocation(udg_TempPoint2)
    if(Trig_ThunderRush_Cast_IsCasterHeroLeft())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitAddAbilityBJ('A0YK',GetLastCreatedUnit()) // 'A0YK': ability "Permanent Lightning Shield"
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShockAuraUnitGroup)
    call UnitApplyTimedLifeBJ(8.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_YELLOW)
    // The remainder after dividing ((facing in degrees of the triggering unit) plus (270)) by (360).
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,100.,ModuloReal((GetUnitFacing(GetTriggerUnit())+270.),360.))
    call CreateNUnitsAtLoc(1,'u013',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'u013': unit "Thunder Rush"
    call RemoveLocation(udg_TempPoint2)
    if(Trig_ThunderRush_Cast_IsCasterHeroRight())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitAddAbilityBJ('A0YK',GetLastCreatedUnit()) // 'A0YK': ability "Permanent Lightning Shield"
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ShockAuraUnitGroup)
    call UnitApplyTimedLifeBJ(8.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_YELLOW)
    call RemoveLocation(udg_TempPoint)
    if(Trig_ThunderRush_Cast_UseMaxLevel())then
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),4)
    else
        if(Trig_ThunderRush_Cast_IsBelow50())then
            call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),3)
        else
            if(Trig_ThunderRush_Cast_IsBelow75())then
                call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),2)
            else
                call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),1)
            endif
        endif
    endif
    if(Trig_ThunderRush_Cast_FreeCastOn())then
        // (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) minus (1).
        call BlzSetUnitAbilityManaCost(GetTriggerUnit(),GetSpellAbilityId(),(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())-1),0)
    else
        call BlzSetUnitAbilityManaCost(GetTriggerUnit(),GetSpellAbilityId(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit()),0)
    endif
    call Wait_Polled(1.5)
    if(Trig_ThunderRush_Cast_ShouldResetSurge())then
        call BlzEndUnitAbilityCooldown(GetTriggerUnit(),'A0Z0') // 'A0Z0': ability "Surge"
    endif
    call IssueImmediateOrderBJ(GetTriggerUnit(),"berserk")
endfunction

function Trig_ThunderRush_Cleanup_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='u013') // 'u013': unit "Thunder Rush"
endfunction

function Trig_ThunderRush_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ShockAuraUnitGroup)
endfunction

// World Editor calls InitTrig_ThunderRush automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_ThunderRush (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_ThunderRush takes nothing returns nothing
endfunction

function Register_ThunderRush_Cast takes nothing returns nothing
    set gg_trg_ThunderRush_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ThunderRush_Cast,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_ThunderRush_Cast,Condition(function Trig_ThunderRush_Cast_Conditions))
    call TriggerAddAction(gg_trg_ThunderRush_Cast,function Trig_ThunderRush_Cast_Actions)
endfunction

function Register_ThunderRush_Cleanup takes nothing returns nothing
    set gg_trg_ThunderRush_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ThunderRush_Cleanup,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_ThunderRush_Cleanup,Condition(function Trig_ThunderRush_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_ThunderRush_Cleanup,function Trig_ThunderRush_Cleanup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_ThunderRush takes nothing returns nothing
    call Register_ThunderRush_Cast()
    call Register_ThunderRush_Cleanup()
endfunction

endlibrary
