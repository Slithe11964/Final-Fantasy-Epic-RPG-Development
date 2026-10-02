library TBio requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Bio_Cast=null
endglobals

function Trig_Bio_Cast_IsBio takes nothing returns boolean
    return(GetSpellAbilityId()=='A10J')or(GetSpellAbilityId()=='A10N')or(GetSpellAbilityId()=='A126') // 'A10J': ability "Bio"; 'A10N': ability "Bio"; 'A126': ability "Bio"
endfunction

function Trig_Bio_Cast_Conditions takes nothing returns boolean
    return(Trig_Bio_Cast_IsBio())
endfunction

function Trig_Bio_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Bio_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (3).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 3)
    if(Trig_Bio_Cast_IsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    set udg_TempReal=Prof_InnerManaPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(10.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A10I',GetLastCreatedUnit()) // 'A10I': ability "Bio"
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (20).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 20)
    call SetUnitAbilityLevelSwapped('A10I',GetLastCreatedUnit(),udg_TempInteger) // 'A10I': ability "Bio"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
endfunction

// World Editor calls InitTrig_Bio automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Bio (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Bio takes nothing returns nothing
endfunction

function Register_Bio_Cast takes nothing returns nothing
    set gg_trg_Bio_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Bio_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Bio_Cast,Condition(function Trig_Bio_Cast_Conditions))
    call TriggerAddAction(gg_trg_Bio_Cast,function Trig_Bio_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Bio takes nothing returns nothing
    call Register_Bio_Cast()
endfunction

endlibrary
