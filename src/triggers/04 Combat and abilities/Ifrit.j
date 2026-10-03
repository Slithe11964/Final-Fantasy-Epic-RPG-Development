library TIfrit requires TAbil, TLoc
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ifrit_Hellfire=null
endglobals

function Trig_Ifrit_Hellfire_IsCastAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0RK')or(GetSpellAbilityId()=='A14J') // 'A0RK': ability "!Hellfire"; 'A14J': ability "!Hellfire"
endfunction

function Trig_Ifrit_Hellfire_Conditions takes nothing returns boolean
    return(Trig_Ifrit_Hellfire_IsCastAbility())
endfunction

function Trig_Ifrit_Hellfire_UsesFirstWeapon takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Ifrit_Hellfire_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Ifrit_Hellfire_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Ifrit_Hellfire_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (2).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 2)
    // (l_tempInteger) plus ((unit level of the triggering unit) divided by (3)).
    set l_tempInteger=(l_tempInteger+(GetUnitLevel(GetTriggerUnit())/ 3))
    if(Trig_Ifrit_Hellfire_CasterIsHero())then
        // (l_tempInteger) plus (Intelligence of the triggering unit).
        set l_tempInteger=(l_tempInteger+GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))
    else
        if(Trig_Ifrit_Hellfire_UsesFirstWeapon())then
            // (l_tempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 0)) divided by (3)).
            set l_tempInteger=(l_tempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),0)/ 3))
        else
            // (l_tempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 1)) divided by (3)).
            set l_tempInteger=(l_tempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),1)/ 3))
        endif
    endif
    if(Trig_Ifrit_Hellfire_HasNoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(l_tempInteger),1,l_tempHandleId,udg_ProxyDamageHash)
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
        call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint2) // 'h01B': unit "Proxy Dummy"
        set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
        call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
        // Udg_TempInteger treated as a decimal-capable number.
        call SaveRealBJ(I2R(l_tempInteger),1,l_tempHandleId,udg_ProxyDamageHash)
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

// World Editor calls InitTrig_Ifrit automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ifrit (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ifrit takes nothing returns nothing
endfunction

function Register_Ifrit_Hellfire takes nothing returns nothing
    set gg_trg_Ifrit_Hellfire=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ifrit_Hellfire,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ifrit_Hellfire,Condition(function Trig_Ifrit_Hellfire_Conditions))
    call TriggerAddAction(gg_trg_Ifrit_Hellfire,function Trig_Ifrit_Hellfire_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ifrit takes nothing returns nothing
    call Register_Ifrit_Hellfire()
endfunction

endlibrary
