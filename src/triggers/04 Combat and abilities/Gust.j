library TGust requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Gust_Cast=null
endglobals

function Trig_Gust_Cast_IsGustAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A1AD')or(GetSpellAbilityId()=='A044')or(GetSpellAbilityId()=='A1FG') // 'A1AD': ability "Gust"; 'A044': ability "Gust"; 'A1FG': ability "Gust"
endfunction

function Trig_Gust_Cast_Conditions takes nothing returns boolean
    return(Trig_Gust_Cast_IsGustAbility())
endfunction

function Trig_Gust_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Gust_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Gust_Cast_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    if(Trig_Gust_Cast_NoTargetUnit())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),l_tempPoint,0)
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (6).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*6)
    if(Trig_Gust_Cast_IsCasterHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) times (5)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*5))
    endif
    set l_tempReal=Prof_RodPower(GetTriggerUnit())
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M6',GetLastCreatedUnit()) // 'A0M6': ability "Wind-elemental Damage"
    call UnitAddAbilityBJ('A1AC',GetLastCreatedUnit()) // 'A1AC': ability "Gust"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"firebolt",GetSpellTargetUnit())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Gust automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Gust (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Gust takes nothing returns nothing
endfunction

function Register_Gust_Cast takes nothing returns nothing
    set gg_trg_Gust_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gust_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Gust_Cast,Condition(function Trig_Gust_Cast_Conditions))
    call TriggerAddAction(gg_trg_Gust_Cast,function Trig_Gust_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Gust takes nothing returns nothing
    call Register_Gust_Cast()
endfunction

endlibrary
