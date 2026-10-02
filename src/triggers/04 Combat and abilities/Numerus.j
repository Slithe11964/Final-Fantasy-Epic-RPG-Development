library TNumerus requires TGroup, TWait
function Trig_Numerus_ChargeCommand_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A13Z') // 'A13Z': ability "!Charge Command"
endfunction

function Trig_Numerus_ChargeCommand_FilterSameOwner takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==GetOwningPlayer(GetFilterUnit()))
endfunction

function Trig_Numerus_ChargeCommand_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Numerus_ChargeCommand_FilterNotCaster takes nothing returns boolean
    return(GetTriggerUnit()!=GetFilterUnit())
endfunction

function Trig_Numerus_ChargeCommand_FilterValidAlly takes nothing returns boolean
    return GetBooleanAnd(Trig_Numerus_ChargeCommand_FilterNotStructure(),Trig_Numerus_ChargeCommand_FilterNotCaster())
endfunction

function Trig_Numerus_ChargeCommand_FilterOwnedAlly takes nothing returns boolean
    return GetBooleanAnd(Trig_Numerus_ChargeCommand_FilterSameOwner(),Trig_Numerus_ChargeCommand_FilterValidAlly())
endfunction

function Trig_Numerus_ChargeCommand_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Numerus_ChargeCommand_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Numerus_ChargeCommand_FilterAliveTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Numerus_ChargeCommand_FilterIsAlive(),Trig_Numerus_ChargeCommand_FilterNotInvulnerable())
endfunction

function Trig_Numerus_ChargeCommand_FilterAllyTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Numerus_ChargeCommand_FilterOwnedAlly(),Trig_Numerus_ChargeCommand_FilterAliveTarget())
endfunction

function Trig_Numerus_ChargeCommand_BuffAlly takes nothing returns nothing
    call SetUnitLifePercentBJ(GetEnumUnit(),'d')
    call SetUnitManaPercentBJ(GetEnumUnit(),'d')
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A140',GetLastCreatedUnit()) // 'A140': ability "Charge Command"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostarmor",GetEnumUnit())
endfunction

function Trig_Numerus_ChargeCommand_Actions takes nothing returns nothing
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    // Result 2: (result 1) plus (5).
    call SetUnitLifePercentBJ(GetTriggerUnit(),(GetUnitLifePercent(GetTriggerUnit())+5.))
    call SetUnitManaPercentBJ(GetTriggerUnit(),'d')
    call Wait_Polled(.5)
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
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Numerus_ChargeCommand_FilterAllyTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Numerus_ChargeCommand_BuffAlly)
    call DestroyGroup(udg_TempGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Numerus takes nothing returns nothing
endfunction

function RegisterR11_Numerus_ChargeCommand takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Numerus_ChargeCommand=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Numerus_ChargeCommand,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Numerus_ChargeCommand,Condition(function Trig_Numerus_ChargeCommand_Conditions))

call TriggerAddAction(gg_trg_Numerus_ChargeCommand,function Trig_Numerus_ChargeCommand_Actions)

endfunction




endlibrary
