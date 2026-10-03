library TAssault requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Assault_Cast=null
endglobals

function Trig_Assault_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14L') // 'A14L': ability "!Assault"
endfunction

function Trig_Assault_Cast_FilterAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Assault_Cast_FilterNotPlayer9 takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(8))
endfunction

function Trig_Assault_Cast_FilterNotNeutral takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))
endfunction

function Trig_Assault_Cast_FilterRealPlayer takes nothing returns boolean
    return GetBooleanAnd(Trig_Assault_Cast_FilterNotPlayer9(),Trig_Assault_Cast_FilterNotNeutral())
endfunction

function Trig_Assault_Cast_FilterAllyPlayer takes nothing returns boolean
    return GetBooleanAnd(Trig_Assault_Cast_FilterAlly(),Trig_Assault_Cast_FilterRealPlayer())
endfunction

function Trig_Assault_Cast_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Assault_Cast_FilterAllyUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_Assault_Cast_FilterAllyPlayer(),Trig_Assault_Cast_FilterNotStructure())
endfunction

function Trig_Assault_Cast_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Assault_Cast_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Assault_Cast_FilterAliveVulnerable takes nothing returns boolean
    return GetBooleanAnd(Trig_Assault_Cast_FilterAlive(),Trig_Assault_Cast_FilterNotInvulnerable())
endfunction

function Trig_Assault_Cast_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Assault_Cast_FilterAllyUnit(),Trig_Assault_Cast_FilterAliveVulnerable())
endfunction

function Trig_Assault_Cast_BuffTarget takes nothing returns nothing
    local location l_tempPoint
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(l_tempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A14K',GetLastCreatedUnit()) // 'A14K': ability "Assault"
    call SetUnitAbilityLevelSwapped('A14K',GetLastCreatedUnit(),udg_TempInteger) // 'A14K': ability "Assault"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetEnumUnit())
    set l_tempPoint=null
endfunction

function Trig_Assault_Cast_Actions takes nothing returns nothing
    local group l_tempGroup
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set l_tempGroup=Group_UnitsInRangeOfLoc(1000.,l_tempPoint,Condition(function Trig_Assault_Cast_FilterTarget))
    call RemoveLocation(l_tempPoint)
    set udg_TempInteger=GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())
    call ForGroupBJ(l_tempGroup,function Trig_Assault_Cast_BuffTarget)
    call DestroyGroup(l_tempGroup)
    set l_tempGroup=null
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Assault automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Assault (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Assault takes nothing returns nothing
endfunction

function Register_Assault_Cast takes nothing returns nothing
    set gg_trg_Assault_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Assault_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Assault_Cast,Condition(function Trig_Assault_Cast_Conditions))
    call TriggerAddAction(gg_trg_Assault_Cast,function Trig_Assault_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Assault takes nothing returns nothing
    call Register_Assault_Cast()
endfunction

endlibrary
