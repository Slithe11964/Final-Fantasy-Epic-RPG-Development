library TProvoke requires TGroup
function Trig_Provoke_Cast_IsProvoke takes nothing returns boolean
    return(GetSpellAbilityId()=='A15U')or(GetSpellAbilityId()=='A015') // 'A15U': ability "Provoke"; 'A015': ability "Provoke"
endfunction

function Trig_Provoke_Cast_Conditions takes nothing returns boolean
    return(Trig_Provoke_Cast_IsProvoke())
endfunction

function Trig_Provoke_Cast_IsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Provoke_Cast_NoBerserkBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetFilterUnit(),'B00K')==false) // 'B00K': buff tooltip "Rage"
endfunction

function Trig_Provoke_Cast_IsEnemyUntaunted takes nothing returns boolean
    return GetBooleanAnd(Trig_Provoke_Cast_IsEnemy(),Trig_Provoke_Cast_NoBerserkBuff())
endfunction

function Trig_Provoke_Cast_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Provoke_Cast_IsVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Provoke_Cast_IsAliveVulnerable takes nothing returns boolean
    return GetBooleanAnd(Trig_Provoke_Cast_IsAlive(),Trig_Provoke_Cast_IsVulnerable())
endfunction

function Trig_Provoke_Cast_IsProvokeTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Provoke_Cast_IsEnemyUntaunted(),Trig_Provoke_Cast_IsAliveVulnerable())
endfunction

function Trig_Provoke_Cast_TauntTarget takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A15V',GetLastCreatedUnit()) // 'A15V': ability "Provoke"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetEnumUnit())
endfunction

function Trig_Provoke_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_Provoke_Cast_IsProvokeTarget))
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Provoke_Cast_TauntTarget)
    call DestroyGroup(udg_TempGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Provoke takes nothing returns nothing
endfunction
function RegisterR11_Provoke_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Provoke_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Provoke_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Provoke_Cast,Condition(function Trig_Provoke_Cast_Conditions))
    call TriggerAddAction(gg_trg_Provoke_Cast,function Trig_Provoke_Cast_Actions)
endfunction




endlibrary
