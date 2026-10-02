library TCalculator requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Calculator_Firaga=null
    trigger gg_trg_Calculator_Thundaga=null
    trigger gg_trg_Calculator_Imperil=null
endglobals

function Trig_Calculator_Firaga_IsFiragaSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QD')or(GetSpellAbilityId()=='A0UX')or(GetSpellAbilityId()=='A0SG') // 'A0QD': ability "Firaga"; 'A0UX': ability "Firaga"; 'A0SG': ability "Firaga"
endfunction

function Trig_Calculator_Firaga_Conditions takes nothing returns boolean
    return(Trig_Calculator_Firaga_IsFiragaSpell())
endfunction

function Trig_Calculator_Firaga_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Calculator_Firaga_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Calculator_Firaga_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Calculator_Firaga_HasNoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Calculator_Firaga_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (3)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*3))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M1',GetLastCreatedUnit()) // 'A0M1': ability "Fire-elemental Damage"
    call UnitAddAbilityBJ('A0QC',GetLastCreatedUnit()) // 'A0QC': ability "Firaga"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"thunderbolt",GetSpellTargetUnit())
endfunction

function Trig_Calculator_Thundaga_IsThundagaSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QF')or(GetSpellAbilityId()=='A0UZ')or(GetSpellAbilityId()=='A0TN') // 'A0QF': ability "Thundaga"; 'A0UZ': ability "Thundaga"; 'A0TN': ability "Thundaga"
endfunction

function Trig_Calculator_Thundaga_Conditions takes nothing returns boolean
    return(Trig_Calculator_Thundaga_IsThundagaSpell())
endfunction

function Trig_Calculator_Thundaga_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Calculator_Thundaga_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Calculator_Thundaga_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B013',GetSpellTargetUnit()) // 'B013': buff tooltip "Shock"
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13V',GetLastCreatedUnit()) // 'A13V': ability "Shock Arrows"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Calculator_Thundaga_HasNoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_Calculator_Thundaga_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (3)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*3))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M3',GetLastCreatedUnit()) // 'A0M3': ability "Thunder-elemental Damage"
    call UnitAddAbilityBJ('A0QE',GetLastCreatedUnit()) // 'A0QE': ability "Thundaga"
    call SetUnitAbilityLevelSwapped('A0QE',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0QE': ability "Thundaga"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"forkedlightning",GetSpellTargetUnit())
endfunction

function Trig_Calculator_Imperil_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0I4') // 'A0I4': ability "!Imperil"
endfunction

function Trig_Calculator_Imperil_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Calculator_Imperil_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Calculator_Imperil_HasNoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(4.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0RX',GetLastCreatedUnit()) // 'A0RX': ability "Imperil"
    call SetUnitAbilityLevelSwapped('A0RX',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0RX': ability "Imperil"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetSpellTargetUnit())
endfunction

// World Editor calls InitTrig_Calculator automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Calculator (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Calculator takes nothing returns nothing
endfunction

function Register_Calculator_Firaga takes nothing returns nothing
    set gg_trg_Calculator_Firaga=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Calculator_Firaga,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Calculator_Firaga,Condition(function Trig_Calculator_Firaga_Conditions))
    call TriggerAddAction(gg_trg_Calculator_Firaga,function Trig_Calculator_Firaga_Actions)
endfunction

function Register_Calculator_Thundaga takes nothing returns nothing
    set gg_trg_Calculator_Thundaga=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Calculator_Thundaga,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Calculator_Thundaga,Condition(function Trig_Calculator_Thundaga_Conditions))
    call TriggerAddAction(gg_trg_Calculator_Thundaga,function Trig_Calculator_Thundaga_Actions)
endfunction

function Register_Calculator_Imperil takes nothing returns nothing
    set gg_trg_Calculator_Imperil=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Calculator_Imperil,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Calculator_Imperil,Condition(function Trig_Calculator_Imperil_Conditions))
    call TriggerAddAction(gg_trg_Calculator_Imperil,function Trig_Calculator_Imperil_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Calculator takes nothing returns nothing
    call Register_Calculator_Firaga()
    call Register_Calculator_Thundaga()
    call Register_Calculator_Imperil()
endfunction

endlibrary
