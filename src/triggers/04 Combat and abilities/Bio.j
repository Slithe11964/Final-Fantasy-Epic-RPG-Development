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
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (3).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 3)
    if(Trig_Bio_Cast_IsHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    set l_tempReal=Prof_InnerManaPower(GetTriggerUnit())
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(10.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A10I',GetLastCreatedUnit()) // 'A10I': ability "Bio"
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (20).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 20)
    call SetUnitAbilityLevelSwapped('A10I',GetLastCreatedUnit(),l_tempInteger) // 'A10I': ability "Bio"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
    set l_tempPoint=null
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
