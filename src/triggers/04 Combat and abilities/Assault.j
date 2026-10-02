library TAssault requires TGroup
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
    call AddSpecialEffectTargetUnitBJ("origin",GetEnumUnit(),"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A14K',GetLastCreatedUnit()) // 'A14K': ability "Assault"
    call SetUnitAbilityLevelSwapped('A14K',GetLastCreatedUnit(),udg_TempInteger) // 'A14K': ability "Assault"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetEnumUnit())
endfunction

function Trig_Assault_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(1000.,udg_TempPoint,Condition(function Trig_Assault_Cast_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    set udg_TempInteger=GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())
    call ForGroupBJ(udg_TempGroup,function Trig_Assault_Cast_BuffTarget)
    call DestroyGroup(udg_TempGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Assault takes nothing returns nothing
endfunction

function RegisterR11_Assault_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Assault_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Assault_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Assault_Cast,Condition(function Trig_Assault_Cast_Conditions))

call TriggerAddAction(gg_trg_Assault_Cast,function Trig_Assault_Cast_Actions)

endfunction




endlibrary
