library TCowPortal requires TLoc, TWait
function Trig_CowPortal_Open_Conditions takes nothing returns boolean
    return(udg_PortalRitualActive==false)
endfunction

function Trig_CowPortal_Open_Actions takes nothing returns nothing
    // (4) plus ((udg_Difficulty) times (2)).
    set udg_CowSpawnCount=(4+(udg_Difficulty*2))
    set udg_PortalRitualActive=true
    call CreateNUnitsAtLoc(1,'h02V',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'h02V': unit "Cow Portal"
    call RemoveLocation(udg_TempPoint)
    set udg_CowPortal=GetLastCreatedUnit()
    call SetUnitAnimation(udg_CowPortal,"birth")
    call QueueUnitAnimationBJ(udg_CowPortal,"stand")
    call StartTimerBJ(udg_CowSpawnTimer,false,9.9)
    call EnableTrigger(gg_trg_CowPortal_Spawn_Cows)
    call Wait_Polled(.5)
    call RemoveItem(udg_WirtsLegItem)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_CowPortal_Spawn_Cows_Enum_AddGhostVision takes nothing returns nothing
    call UnitAddAbilityBJ('Aeth',GetEnumUnit()) // 'Aeth': object name not found in map data
endfunction

function Trig_CowPortal_Spawn_Cows_Cond_MoreCowsLeft takes nothing returns boolean
    return(udg_CowSpawnCount>0)
endfunction

function Trig_CowPortal_Spawn_Cows_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(udg_CowPortal)
    if(Trig_CowPortal_Spawn_Cows_Cond_MoreCowsLeft())then
        // Calculation 1:
        // (udg_CowSpawnCount treated as a decimal-capable number) times (45).
        // Calculation 2:
        // A random decimal number between 200 and 340.
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,(I2R(udg_CowSpawnCount)*45.),GetRandomReal(200.,340.))
        call CreateNUnitsAtLocFacingLocBJ(1,'n0AE',Player($B),udg_TempPoint,udg_TempPoint2) // 'n0AE': unit "Hell Bovine"; $B = 11
        call RemoveLocation(udg_TempPoint)
        call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_CowGroup)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_CowSpawnCount=(udg_CowSpawnCount-1)
        call StartTimerBJ(udg_CowSpawnTimer,false,.6)
    else
        call DisableTrigger(GetTriggeringTrigger())
        call SetUnitPositionLoc(gg_unit_O00I_0239,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call ShowUnitShow(gg_unit_O00I_0239)
        call PauseUnitBJ(false,gg_unit_O00I_0239)
        call SetUnitInvulnerable(gg_unit_O00I_0239,false)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_O00I_0239,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call KillUnit(udg_CowPortal)
        call Wait_Polled(15.)
        call ForGroupBJ(udg_CowGroup,function Trig_CowPortal_Spawn_Cows_Enum_AddGhostVision)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_CowPortal takes nothing returns nothing
endfunction
function RegisterR11_CowPortal_Open takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_CowPortal_Open=CreateTrigger()
    call DisableTrigger(gg_trg_CowPortal_Open)
    call TriggerAddCondition(gg_trg_CowPortal_Open,Condition(function Trig_CowPortal_Open_Conditions))
    call TriggerAddAction(gg_trg_CowPortal_Open,function Trig_CowPortal_Open_Actions)
endfunction
function RegisterR11_CowPortal_Spawn_Cows takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_CowPortal_Spawn_Cows=CreateTrigger()
    call DisableTrigger(gg_trg_CowPortal_Spawn_Cows)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_CowPortal_Spawn_Cows,udg_CowSpawnTimer)
    call TriggerAddAction(gg_trg_CowPortal_Spawn_Cows,function Trig_CowPortal_Spawn_Cows_Actions)
endfunction




endlibrary
