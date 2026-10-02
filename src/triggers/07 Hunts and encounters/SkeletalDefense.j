library TSkeletalDefense requires TGroup, TLoc, TUnit
function Trig_SkeletalDefense_Spawn_RandomSubGroup takes integer l_want,group l_source returns group
    set bj_randomSubGroupGroup=CreateGroup()
    set bj_randomSubGroupWant=l_want
    set bj_randomSubGroupTotal=CountUnitsInGroup(l_source)
    if(bj_randomSubGroupWant<=0 or bj_randomSubGroupTotal<=0)then
        return bj_randomSubGroupGroup
    endif
    // Result 1: bj_randomSubGroupWant treated as a decimal-capable number.
    // Result 2: bj_randomSubGroupTotal treated as a decimal-capable number.
    // Result 3: (result 1) divided by (result 2).
    set bj_randomSubGroupChance=I2R(bj_randomSubGroupWant)/ I2R(bj_randomSubGroupTotal)
    call ForGroup(l_source,function GetRandomSubGroupEnum)
    return bj_randomSubGroupGroup
endfunction

function Trig_SkeletalDefense_MarkAttacker_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0YL',GetTriggerUnit())>0)and(IsUnitEnemy(GetAttacker(),GetOwningPlayer(GetTriggerUnit()))) // 'A0YL': ability "Skeletal Defense"
endfunction

function Trig_SkeletalDefense_MarkAttacker_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetAttacker(),udg_ArenaBoundUnits)
endfunction

function Trig_SkeletalDefense_ClearDead_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_ArenaBoundUnits))
endfunction

function Trig_SkeletalDefense_ClearDead_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ArenaBoundUnits)
endfunction

function Trig_SkeletalDefense_Spawn_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsUnitGroupEmptyBJ(udg_ArenaBoundUnits)==false)
endfunction

function Trig_SkeletalDefense_Spawn_Cond_TrackInGroup takes nothing returns boolean
    return(udg_EchelePhase==$A) // $A = 10
endfunction

function Trig_SkeletalDefense_Spawn_SpawnSkeleton takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    // A random decimal number between 64 and 96.
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,GetRandomReal(64.,96.),GetRandomDirectionDeg())
    call CreateNUnitsAtLocFacingLocBJ(1,'u00P',Player($B),udg_TempPoint2,udg_TempPoint) // 'u00P': unit "Skeleton Champion"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call UnitApplyTimedLifeBJ(30.,'Brai',GetLastCreatedUnit()) // 'Brai': buff tooltip "Raised"
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),50.)
    // (maximum health of GetLastCreatedUnit()) divided by (2).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())/ 2))
    call UnitAddAbilityBJ('A0ZU',GetLastCreatedUnit()) // 'A0ZU': ability "Double Vulnerable"
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if(Trig_SkeletalDefense_Spawn_Cond_TrackInGroup())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
endfunction

function Trig_SkeletalDefense_Spawn_Cond_UnderSkeletonCap takes nothing returns boolean
    return(CountUnitsInGroup(udg_TempGroup)<30)
endfunction

function Trig_SkeletalDefense_Spawn_Actions takes nothing returns nothing
    set udg_TempGroup=Group_UnitsOfPlayerAndType(Player($B),'u00P') // $B = 11; 'u00P': unit "Skeleton Champion"
    if(Trig_SkeletalDefense_Spawn_Cond_UnderSkeletonCap())then
        call DestroyGroup(udg_TempGroup)
        set udg_TempGroup=Trig_SkeletalDefense_Spawn_RandomSubGroup(2,udg_ArenaBoundUnits)
        call ForGroupBJ(udg_TempGroup,function Trig_SkeletalDefense_Spawn_SpawnSkeleton)
    endif
    call DestroyGroup(udg_TempGroup)
    call GroupClear(udg_ArenaBoundUnits)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_SkeletalDefense takes nothing returns nothing
endfunction

function RegisterR11_SkeletalDefense_MarkAttacker takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_SkeletalDefense_MarkAttacker=CreateTrigger()

call TriggerRegisterPlayerUnitEventSimple(gg_trg_SkeletalDefense_MarkAttacker,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11

call TriggerAddCondition(gg_trg_SkeletalDefense_MarkAttacker,Condition(function Trig_SkeletalDefense_MarkAttacker_Conditions))

call TriggerAddAction(gg_trg_SkeletalDefense_MarkAttacker,function Trig_SkeletalDefense_MarkAttacker_Actions)

endfunction




function RegisterR11_SkeletalDefense_ClearDead takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_SkeletalDefense_ClearDead=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_SkeletalDefense_ClearDead,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_SkeletalDefense_ClearDead,Condition(function Trig_SkeletalDefense_ClearDead_Conditions))

call TriggerAddAction(gg_trg_SkeletalDefense_ClearDead,function Trig_SkeletalDefense_ClearDead_Actions)

endfunction




function RegisterR11_SkeletalDefense_Spawn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_SkeletalDefense_Spawn=CreateTrigger()

call TriggerRegisterTimerEventPeriodic(gg_trg_SkeletalDefense_Spawn,1.)

call TriggerAddCondition(gg_trg_SkeletalDefense_Spawn,Condition(function Trig_SkeletalDefense_Spawn_Conditions))

call TriggerAddAction(gg_trg_SkeletalDefense_Spawn,function Trig_SkeletalDefense_Spawn_Actions)

endfunction




endlibrary
