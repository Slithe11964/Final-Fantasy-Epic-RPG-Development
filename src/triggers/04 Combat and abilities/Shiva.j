library TShiva requires TAbil
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
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Shiva_DiamondDust_HasNoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    // (udg_TempInteger) plus ((unit level of the triggering unit) divided by (4)).
    set udg_TempInteger=(udg_TempInteger+(GetUnitLevel(GetTriggerUnit())/ 4))
    if(Trig_Shiva_DiamondDust_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (3)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*3))
    else
        if(Trig_Shiva_DiamondDust_UsesFirstWeapon())then
            // (udg_TempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 0)) divided by (2)).
            set udg_TempInteger=(udg_TempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),0)/ 2))
        else
            // (udg_TempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 1)) divided by (2)).
            set udg_TempInteger=(udg_TempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),1)/ 2))
        endif
    endif
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(udg_TempInteger),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M2',GetLastCreatedUnit()) // 'A0M2': ability "Ice-elemental Damage"
    call UnitAddAbilityBJ('A0RL',GetLastCreatedUnit()) // 'A0RL': ability "Diamond Dust"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"breathoffrost",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
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
