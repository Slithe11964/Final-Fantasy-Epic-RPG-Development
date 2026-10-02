library TForestSpirit requires TLoc
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_ForestSpirit_Spawn=null
    trigger gg_trg_ForestSpirit_Wander=null
    trigger gg_trg_ForestSpirit_Flee=null
    // Variables only this module uses.
    location array udg_SpiritPoint
endglobals

function Trig_ForestSpirit_Spawn_Actions takes nothing returns nothing
    set udg_SpiritsCleansed=0
    set udg_SpiritPoint[1]=GetRandomLocInRect(gg_rct_570)
    call CreateNUnitsAtLoc(1,'n089',Player($B),udg_SpiritPoint[1],bj_UNIT_FACING) // 'n089': unit "Forest Spirit"; $B = 11
    set udg_SpiritUnit[1]=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A0OU',GetLastCreatedUnit()) // 'A0OU': ability "Spirit Aura"
    call UnitAddAbilityBJ('A0OV',GetLastCreatedUnit()) // 'A0OV': ability "Spirit Aura"
    set udg_SpiritCalm[1]=true
    set udg_SpiritPoint[2]=GetRandomLocInRect(gg_rct_570)
    call CreateNUnitsAtLoc(1,'n089',Player($B),udg_SpiritPoint[2],bj_UNIT_FACING) // 'n089': unit "Forest Spirit"; $B = 11
    set udg_SpiritUnit[2]=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A0OY',GetLastCreatedUnit()) // 'A0OY': ability "Spirit Aura"
    call UnitAddAbilityBJ('A0OZ',GetLastCreatedUnit()) // 'A0OZ': ability "Spirit Aura"
    set udg_SpiritCalm[2]=true
    set udg_SpiritPoint[3]=GetRandomLocInRect(gg_rct_570)
    call CreateNUnitsAtLoc(1,'n089',Player($B),udg_SpiritPoint[3],bj_UNIT_FACING) // 'n089': unit "Forest Spirit"; $B = 11
    set udg_SpiritUnit[3]=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A0OW',GetLastCreatedUnit()) // 'A0OW': ability "Spirit Aura"
    call UnitAddAbilityBJ('A0OX',GetLastCreatedUnit()) // 'A0OX': ability "Spirit Aura"
    set udg_SpiritCalm[3]=true
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ForestSpirit_Wander_SpiritAtTarget takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_SpiritPoint at position loop counter A.
    return(DistanceBetweenPoints(udg_TempPoint,udg_SpiritPoint[GetForLoopIndexA()])<=512.)
endfunction

function Trig_ForestSpirit_Wander_SpiritReadyToMove takes nothing returns boolean
    return(udg_SpiritWanderTick[GetForLoopIndexA()]>=3)
endfunction

function Trig_ForestSpirit_Wander_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=3
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_SpiritCalm[GetForLoopIndexA()]=true
        set udg_TempPoint=GetUnitLoc(udg_SpiritUnit[GetForLoopIndexA()])
        if(Trig_ForestSpirit_Wander_SpiritAtTarget())then
            // Increase udg_SpiritWanderTick at position loop counter A by 2.
            set udg_SpiritWanderTick[GetForLoopIndexA()]=(udg_SpiritWanderTick[GetForLoopIndexA()]+2)
        else
            set udg_SpiritWanderTick[GetForLoopIndexA()]=(udg_SpiritWanderTick[GetForLoopIndexA()]+1)
        endif
        call RemoveLocation(udg_TempPoint)
        if(Trig_ForestSpirit_Wander_SpiritReadyToMove())then
            call RemoveLocation(udg_SpiritPoint[GetForLoopIndexA()])
            set udg_SpiritWanderTick[GetForLoopIndexA()]=1
            // A random whole number from 1 through LoadIntegerBJ(7, 2, udg_SpawnDataHashRef).
            set udg_SpiritPoint[GetForLoopIndexA()]=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(7,2,udg_SpawnDataHashRef)),7,udg_SpawnRectHashRef))
            call IssuePointOrderLocBJ(udg_SpiritUnit[GetForLoopIndexA()],"move",udg_SpiritPoint[GetForLoopIndexA()])
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

function Trig_ForestSpirit_Flee_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))and(GetUnitUserData(GetAttacker())==7)
endfunction

function Trig_ForestSpirit_Flee_SpiritIsCalm takes nothing returns boolean
    return(udg_SpiritCalm[udg_TempInteger])
endfunction

function Trig_ForestSpirit_Flee_Actions takes nothing returns nothing
    // A random whole number from 1 through 3.
    set udg_TempInteger=GetRandomInt(1,3)
    if(Trig_ForestSpirit_Flee_SpiritIsCalm())then
        call RemoveLocation(udg_SpiritPoint[udg_TempInteger])
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        // A random decimal number between 150 and 650.
        set udg_SpiritPoint[udg_TempInteger]=Loc_PolarOffset(udg_TempPoint,GetRandomReal(150.,650.),GetRandomDirectionDeg())
        call RemoveLocation(udg_TempPoint)
        set udg_SpiritWanderTick[udg_TempInteger]=0
        set udg_SpiritCalm[udg_TempInteger]=false
        call IssuePointOrderLocBJ(udg_SpiritUnit[udg_TempInteger],"move",udg_SpiritPoint[udg_TempInteger])
    endif
endfunction

// World Editor calls InitTrig_ForestSpirit automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_ForestSpirit (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_ForestSpirit takes nothing returns nothing
endfunction

function Register_ForestSpirit_Spawn takes nothing returns nothing
    set gg_trg_ForestSpirit_Spawn=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_ForestSpirit_Spawn,10.)
    call TriggerAddAction(gg_trg_ForestSpirit_Spawn,function Trig_ForestSpirit_Spawn_Actions)
endfunction

function Register_ForestSpirit_Wander takes nothing returns nothing
    set gg_trg_ForestSpirit_Wander=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_ForestSpirit_Wander,20.)
    call TriggerAddAction(gg_trg_ForestSpirit_Wander,function Trig_ForestSpirit_Wander_Actions)
endfunction

function Register_ForestSpirit_Flee takes nothing returns nothing
    set gg_trg_ForestSpirit_Flee=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ForestSpirit_Flee,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_ForestSpirit_Flee,Condition(function Trig_ForestSpirit_Flee_Conditions))
    call TriggerAddAction(gg_trg_ForestSpirit_Flee,function Trig_ForestSpirit_Flee_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_ForestSpirit takes nothing returns nothing
    call Register_ForestSpirit_Spawn()
    call Register_ForestSpirit_Wander() // disabled by VoiceOfForest; destroyed by VoiceOfForest
    call Register_ForestSpirit_Flee() // disabled by VoiceOfForest; destroyed by VoiceOfForest
endfunction

endlibrary
