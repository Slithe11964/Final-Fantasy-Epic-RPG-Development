library TMechanical requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Mechanical_Drill=null
endglobals

function Trig_Mechanical_Drill_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1D9') // 'A1D9': ability "Drill"
endfunction

function Trig_Mechanical_Drill_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Mechanical_Drill_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 2)
    if(Trig_Mechanical_Drill_IsHero())then
        // (udg_TempInteger) plus (Strength of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true))
        // (udg_TempInteger) plus (Agility of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true))
        // (udg_TempInteger) plus (Intelligence of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R000'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R000')) // $A = 10; 'R000': upgrade "Tools"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(3.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1DA',GetLastCreatedUnit()) // 'A1DA': ability "Drill"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
endfunction

// World Editor calls InitTrig_Mechanical automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Mechanical (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Mechanical takes nothing returns nothing
endfunction

function Register_Mechanical_Drill takes nothing returns nothing
    set gg_trg_Mechanical_Drill=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Mechanical_Drill,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Mechanical_Drill,Condition(function Trig_Mechanical_Drill_Conditions))
    call TriggerAddAction(gg_trg_Mechanical_Drill,function Trig_Mechanical_Drill_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Mechanical takes nothing returns nothing
    call Register_Mechanical_Drill()
endfunction

endlibrary
