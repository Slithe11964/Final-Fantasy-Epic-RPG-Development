library TLiving requires TGroup, TLink
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Living_Wall=null
endglobals

function Trig_Living_Wall_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A13L') // 'A13L': ability "!Living Wall"
endfunction

function Trig_Living_Wall_FilterAlly takes nothing returns boolean
    return(IsUnitAlly(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Living_Wall_FilterNotPlayer9 takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(8))
endfunction

function Trig_Living_Wall_FilterNotNeutral takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())!=Player(PLAYER_NEUTRAL_PASSIVE))
endfunction

function Trig_Living_Wall_FilterRealPlayer takes nothing returns boolean
    return GetBooleanAnd(Trig_Living_Wall_FilterNotPlayer9(),Trig_Living_Wall_FilterNotNeutral())
endfunction

function Trig_Living_Wall_FilterAllyPlayer takes nothing returns boolean
    return GetBooleanAnd(Trig_Living_Wall_FilterAlly(),Trig_Living_Wall_FilterRealPlayer())
endfunction

function Trig_Living_Wall_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Living_Wall_FilterNotCaster takes nothing returns boolean
    return(GetTriggerUnit()!=GetFilterUnit())
endfunction

function Trig_Living_Wall_FilterNotStructureOrSelf takes nothing returns boolean
    return GetBooleanAnd(Trig_Living_Wall_FilterNotStructure(),Trig_Living_Wall_FilterNotCaster())
endfunction

function Trig_Living_Wall_FilterAllyUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_Living_Wall_FilterAllyPlayer(),Trig_Living_Wall_FilterNotStructureOrSelf())
endfunction

function Trig_Living_Wall_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Living_Wall_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Living_Wall_FilterAliveVulnerable takes nothing returns boolean
    return GetBooleanAnd(Trig_Living_Wall_FilterAlive(),Trig_Living_Wall_FilterNotInvulnerable())
endfunction

function Trig_Living_Wall_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Living_Wall_FilterAllyUnit(),Trig_Living_Wall_FilterAliveVulnerable())
endfunction

function Trig_Living_Wall_ShieldAlly takes nothing returns nothing
    local location l_tempPoint
    call Link_SaveCaster(GetTriggerUnit(),GetEnumUnit(),1000.)
    set l_tempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(l_tempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13O',GetLastCreatedUnit()) // 'A13O': ability "Cover"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetEnumUnit())
    set l_tempPoint=null
endfunction

function Trig_Living_Wall_Actions takes nothing returns nothing
    local group l_tempGroup
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13P',GetLastCreatedUnit()) // 'A13P': ability "Shell"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A09K',GetLastCreatedUnit()) // 'A09K': ability "Protect"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",GetTriggerUnit())
    set l_tempGroup=Group_UnitsInRangeOfLoc(1000.,l_tempPoint,Condition(function Trig_Living_Wall_FilterTarget))
    call RemoveLocation(l_tempPoint)
    call ForGroupBJ(l_tempGroup,function Trig_Living_Wall_ShieldAlly)
    call DestroyGroup(l_tempGroup)
    set l_tempGroup=null
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Living automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Living (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Living takes nothing returns nothing
endfunction

function Register_Living_Wall takes nothing returns nothing
    set gg_trg_Living_Wall=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Living_Wall,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Living_Wall,Condition(function Trig_Living_Wall_Conditions))
    call TriggerAddAction(gg_trg_Living_Wall,function Trig_Living_Wall_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Living takes nothing returns nothing
    call Register_Living_Wall()
endfunction

endlibrary
