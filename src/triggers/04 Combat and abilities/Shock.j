library TShock requires TAbil, TLoc, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Shock_Cast=null
endglobals

function Trig_Shock_Cast_IsShock takes nothing returns boolean
    return(GetSpellAbilityId()=='A13K')or(GetSpellAbilityId()=='A15A') // 'A13K': ability "Shock"; 'A15A': ability "Shock"
endfunction

function Trig_Shock_Cast_Conditions takes nothing returns boolean
    return(Trig_Shock_Cast_IsShock())
endfunction

function Trig_Shock_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Shock_Cast_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (facing in degrees of the triggering unit) plus ((loop counter A treated as a decimal-capable number) times
        // (60)).
        set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,220.,(GetUnitFacing(GetTriggerUnit())+(I2R(GetForLoopIndexA())*60.)))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (3).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Shock_Cast_IsHero())then
        // (l_tempInteger) plus ((Strength of the triggering unit) times (4)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*4))
    endif
    // Result 1: (10) plus (Prof_GetLevel(the triggering unit, 'R001')).
    // Result 2: (result 1) plus (Prof_GetLevel(the triggering unit, 'R00I')).
    // Result 3: (0.1) times (result 2).
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R001')+Prof_GetLevel(GetTriggerUnit(),'R00I')) // $A = 10; 'R001': upgrade "Sword"; 'R00I': upgrade "Heavens Forged Axe"
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M3',GetLastCreatedUnit()) // 'A0M3': ability "Thunder-elemental Damage"
    call UnitAddAbilityBJ('A13J',GetLastCreatedUnit()) // 'A13J': ability "Shock"
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (20).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 20)
    call SetUnitAbilityLevelSwapped('A13J',GetLastCreatedUnit(),l_tempInteger) // 'A13J': ability "Shock"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"thunderclap")
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Shock automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Shock (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Shock takes nothing returns nothing
endfunction

function Register_Shock_Cast takes nothing returns nothing
    set gg_trg_Shock_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shock_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shock_Cast,Condition(function Trig_Shock_Cast_Conditions))
    call TriggerAddAction(gg_trg_Shock_Cast,function Trig_Shock_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Shock takes nothing returns nothing
    call Register_Shock_Cast()
endfunction

endlibrary
