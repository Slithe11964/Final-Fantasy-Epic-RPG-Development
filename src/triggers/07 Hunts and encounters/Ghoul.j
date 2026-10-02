library TGhoul requires TLoc, TUnit
function Trig_Ghoul_Group_Cleanup_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_GhoulGroup))
endfunction

function Trig_Ghoul_Group_Cleanup_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_GhoulGroup)
endfunction

function Trig_Ghoul_Master_Decay_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RB',gg_unit_Uvng_0076)>1)and(CountUnitsInGroup(udg_GhoulGroup)<5) // 'A0RB': ability "Ghoul Master"
endfunction

function Trig_Ghoul_Master_Decay_Actions takes nothing returns nothing
    call DecUnitAbilityLevelSwapped('A0RB',gg_unit_Uvng_0076) // 'A0RB': ability "Ghoul Master"
endfunction

function Trig_Ghoul_Master_Spawn_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RB',GetTriggerUnit())>0)and(GetUnitAbilityLevelSwapped('A0RB',GetTriggerUnit())<=5) // 'A0RB': ability "Ghoul Master"
endfunction

function Trig_Ghoul_Master_Spawn_Cond_IsGrandVampire takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_Uvng_0076)
endfunction

function Trig_Ghoul_Master_Spawn_Cond_InSecondArenaGroup takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SummonedUnits))
endfunction

function Trig_Ghoul_Master_Spawn_Cond_InFirstArenaGroup takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SpecialUnits))
endfunction

function Trig_Ghoul_Master_Spawn_Actions takes nothing returns nothing
    call IncUnitAbilityLevelSwapped('A0RB',GetTriggerUnit()) // 'A0RB': ability "Ghoul Master"
    set udg_TempPoint=GetUnitLoc(GetAttacker())
    // A random decimal number between 64 and 96.
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,GetRandomReal(64.,96.),GetRandomDirectionDeg())
    call CreateNUnitsAtLocFacingLocBJ(1,'ugho',Player($B),udg_TempPoint2,udg_TempPoint) // 'ugho': object name not found in map data; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call UnitAddTypeBJ(UNIT_TYPE_SUMMONED,GetLastCreatedUnit())
    if(Trig_Ghoul_Master_Spawn_Cond_IsGrandVampire())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_GhoulGroup)
    endif
    if(Trig_Ghoul_Master_Spawn_Cond_InFirstArenaGroup())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SpecialUnits)
    else
        if(Trig_Ghoul_Master_Spawn_Cond_InSecondArenaGroup())then
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_SummonedUnits)
        endif
    endif
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Ghoul takes nothing returns nothing
endfunction
function RegisterR11_Ghoul_Group_Cleanup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ghoul_Group_Cleanup=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Ghoul_Group_Cleanup,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Ghoul_Group_Cleanup,Condition(function Trig_Ghoul_Group_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Ghoul_Group_Cleanup,function Trig_Ghoul_Group_Cleanup_Actions)
endfunction
function RegisterR11_Ghoul_Master_Decay takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ghoul_Master_Decay=CreateTrigger()
    call DisableTrigger(gg_trg_Ghoul_Master_Decay)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Ghoul_Master_Decay,3.)
    call TriggerAddCondition(gg_trg_Ghoul_Master_Decay,Condition(function Trig_Ghoul_Master_Decay_Conditions))
    call TriggerAddAction(gg_trg_Ghoul_Master_Decay,function Trig_Ghoul_Master_Decay_Actions)
endfunction
function RegisterR11_Ghoul_Master_Spawn takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ghoul_Master_Spawn=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Ghoul_Master_Spawn,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Ghoul_Master_Spawn,Condition(function Trig_Ghoul_Master_Spawn_Conditions))
    call TriggerAddAction(gg_trg_Ghoul_Master_Spawn,function Trig_Ghoul_Master_Spawn_Actions)
endfunction




endlibrary
