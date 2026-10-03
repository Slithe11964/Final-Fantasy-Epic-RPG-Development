library TShiva requires TAbil
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Shiva_DiamondDust=null
endglobals

function Trig_Shiva_DiamondDust_IsCastAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A0RM')or(GetSpellAbilityId()=='A0TX') // 'A0RM': ability "!Diamond Dust"; 'A0TX': ability "!Diamond Dust"
endfunction

function Trig_Shiva_DiamondDust_Conditions takes nothing returns boolean
    return(Trig_Shiva_DiamondDust_IsCastAbility())
endfunction

function Trig_Shiva_DiamondDust_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Shiva_DiamondDust_UsesFirstWeapon takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Shiva_DiamondDust_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Shiva_DiamondDust_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    if(Trig_Shiva_DiamondDust_HasNoTargetUnit())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),l_tempPoint,0)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    // (l_tempInteger) plus ((unit level of the triggering unit) divided by (4)).
    set l_tempInteger=(l_tempInteger+(GetUnitLevel(GetTriggerUnit())/ 4))
    if(Trig_Shiva_DiamondDust_CasterIsHero())then
        // (l_tempInteger) plus ((Intelligence of the triggering unit) times (3)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*3))
    else
        if(Trig_Shiva_DiamondDust_UsesFirstWeapon())then
            // (l_tempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 0)) divided by (2)).
            set l_tempInteger=(l_tempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),0)/ 2))
        else
            // (l_tempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 1)) divided by (2)).
            set l_tempInteger=(l_tempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),1)/ 2))
        endif
    endif
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(l_tempInteger),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M2',GetLastCreatedUnit()) // 'A0M2': ability "Ice-elemental Damage"
    call UnitAddAbilityBJ('A0RL',GetLastCreatedUnit()) // 'A0RL': ability "Diamond Dust"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"breathoffrost",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Shiva automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Shiva (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Shiva takes nothing returns nothing
endfunction

function Register_Shiva_DiamondDust takes nothing returns nothing
    set gg_trg_Shiva_DiamondDust=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shiva_DiamondDust,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shiva_DiamondDust,Condition(function Trig_Shiva_DiamondDust_Conditions))
    call TriggerAddAction(gg_trg_Shiva_DiamondDust,function Trig_Shiva_DiamondDust_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Shiva takes nothing returns nothing
    call Register_Shiva_DiamondDust()
endfunction

endlibrary
