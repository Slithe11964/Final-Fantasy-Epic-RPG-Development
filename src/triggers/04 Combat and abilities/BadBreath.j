library TBadBreath requires TGroup
function Trig_BadBreath_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0EX') // 'A0EX': ability "!Bad Breath"
endfunction

function Trig_BadBreath_Cast_Filter_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_BadBreath_Cast_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_BadBreath_Cast_Filter_NotMagicImmune takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_MAGIC_IMMUNE)==false)!=null
endfunction

function Trig_BadBreath_Cast_Filter_NotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_BadBreath_Cast_Filter_ValidType takes nothing returns boolean
    return GetBooleanAnd(Trig_BadBreath_Cast_Filter_NotMagicImmune(),Trig_BadBreath_Cast_Filter_NotStructure())
endfunction

function Trig_BadBreath_Cast_Filter_Targetable takes nothing returns boolean
    return GetBooleanAnd(Trig_BadBreath_Cast_Filter_NotInvulnerable(),Trig_BadBreath_Cast_Filter_ValidType())
endfunction

function Trig_BadBreath_Cast_Filter_EnemyTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_BadBreath_Cast_Filter_IsEnemy(),Trig_BadBreath_Cast_Filter_Targetable())
endfunction

function Trig_BadBreath_Cast_ApplyDebuffs takes nothing returns nothing
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('ACcs',GetLastCreatedUnit()) // 'ACcs': ability "Blind"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"curse",GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A12D',GetLastCreatedUnit()) // 'A12D': ability "Dewall"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"faeriefire",GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1DP',GetLastCreatedUnit()) // 'A1DP': ability "Slow"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"slow",GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1DQ',GetLastCreatedUnit()) // 'A1DQ': ability "Pain"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"curse",GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1DR',GetLastCreatedUnit()) // 'A1DR': ability "Fog"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"curse",GetEnumUnit())
    // Result 1: current mana divided by maximum mana for the unit being visited, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    // Result 2: (result 1) minus (25).
    call SetUnitManaPercentBJ(GetEnumUnit(),(GetUnitManaPercent(GetEnumUnit())-25.))
endfunction

function Trig_BadBreath_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(1024.,udg_TempPoint,Condition(function Trig_BadBreath_Cast_Filter_EnemyTarget))
    call ForGroupBJ(udg_TempGroup,function Trig_BadBreath_Cast_ApplyDebuffs)
    call RemoveLocation(udg_TempPoint)
    call DestroyGroup(udg_TempGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_BadBreath takes nothing returns nothing
endfunction

function RegisterR11_BadBreath_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_BadBreath_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_BadBreath_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_BadBreath_Cast,Condition(function Trig_BadBreath_Cast_Conditions))

call TriggerAddAction(gg_trg_BadBreath_Cast,function Trig_BadBreath_Cast_Actions)

endfunction




endlibrary
