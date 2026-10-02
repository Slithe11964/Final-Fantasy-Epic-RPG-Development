library TMyriad requires TAbil, TProf
function Trig_Myriad_Arrows_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0R0') // 'A0R0': ability "!Myriad Arrows"
endfunction

function Trig_Myriad_Arrows_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Myriad_Arrows_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Myriad_Arrows_Actions takes nothing returns nothing
    if(Trig_Myriad_Arrows_NoTargetUnit())then
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
    if(Trig_Myriad_Arrows_IsHero())then
        // (udg_TempInteger) plus ((Agility of the triggering unit) times (1)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*1))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R002'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R002')) // $A = 10; 'R002': upgrade "Bow"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(12.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0X4',GetLastCreatedUnit()) // 'A0X4': ability "Myriad Arrows"
    call SetUnitAbilityLevelSwapped('A0X4',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0X4': ability "Myriad Arrows"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// World Editor calls InitTrig_Myriad automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Myriad (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Myriad takes nothing returns nothing
endfunction

function Register_Myriad_Arrows takes nothing returns nothing
    set gg_trg_Myriad_Arrows=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Myriad_Arrows,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Myriad_Arrows,Condition(function Trig_Myriad_Arrows_Conditions))
    call TriggerAddAction(gg_trg_Myriad_Arrows,function Trig_Myriad_Arrows_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Myriad takes nothing returns nothing
    call Register_Myriad_Arrows()
endfunction

endlibrary
