library TLiving requires TGroup, TLink
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
    call Link_SaveCaster(GetTriggerUnit(),GetEnumUnit(),1000.)
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13O',GetLastCreatedUnit()) // 'A13O': ability "Cover"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetEnumUnit())
endfunction

function Trig_Living_Wall_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13P',GetLastCreatedUnit()) // 'A13P': ability "Shell"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"drunkenhaze",GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A09K',GetLastCreatedUnit()) // 'A09K': ability "Protect"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(1000.,udg_TempPoint,Condition(function Trig_Living_Wall_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Living_Wall_ShieldAlly)
    call DestroyGroup(udg_TempGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Living takes nothing returns nothing
endfunction
function RegisterR11_Living_Wall takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Living_Wall=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Living_Wall,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Living_Wall,Condition(function Trig_Living_Wall_Conditions))
    call TriggerAddAction(gg_trg_Living_Wall,function Trig_Living_Wall_Actions)
endfunction




endlibrary
