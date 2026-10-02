library TElemental requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Elemental_Setup=null
    trigger gg_trg_Elemental_Spawn=null
    trigger gg_trg_Elemental_Wander=null
    trigger gg_trg_Elemental_Aggro=null
    trigger gg_trg_Elemental_Assist_Attack=null
    trigger gg_trg_Elemental_Death=null
    // Variables only this module uses.
    location array udg_ElementalTargetLoc
endglobals

function Trig_Elemental_Setup_Cond_ElementDefined takes nothing returns boolean
    return(udg_AreaSpawnUnitA[GetForLoopIndexA()]!=0)
endfunction

function Trig_Elemental_Setup_Actions takes nothing returns nothing
    set udg_ElementRecord[1]=8
    set udg_ElementRecord[2]=2
    set udg_ElementRecord[3]=6
    set udg_ElementRecord[4]=4
    set udg_ElementRecord[5]=5
    set udg_ElementRecord[6]=3
    set udg_AreaSpawnUnitA[2]='n08A' // 'n08A': unit "Fire Elemental"
    set udg_AreaSpawnUnitB[2]='n0AF' // 'n0AF': unit "Salamander Entite"
    set udg_ZoneColor[2]=PLAYER_COLOR_RED
    set udg_AreaSpawnUnitA[3]='n08K' // 'n08K': unit "Earth Elemental"
    set udg_AreaSpawnUnitB[3]='n0AJ' // 'n0AJ': unit "Gnoma Entite"
    set udg_ZoneColor[3]=PLAYER_COLOR_ORANGE
    set udg_AreaSpawnUnitA[4]='n08I' // 'n08I': unit "Thunder Elemental"
    set udg_AreaSpawnUnitB[4]='n0AH' // 'n0AH': unit "Mardu Entite"
    set udg_ZoneColor[4]=PLAYER_COLOR_YELLOW
    set udg_AreaSpawnUnitA[5]='n08L' // 'n08L': unit "Wind Elemental"
    set udg_AreaSpawnUnitB[5]='n0AK' // 'n0AK': unit "Sylphi Entite"
    set udg_ZoneColor[5]=PLAYER_COLOR_GREEN
    set udg_AreaSpawnUnitA[6]='n08J' // 'n08J': unit "Water Elemental"
    set udg_AreaSpawnUnitB[6]='n0AI' // 'n0AI': unit "Undin Entite"
    set udg_ZoneColor[6]=PLAYER_COLOR_BLUE
    set udg_ZoneColor[7]=PLAYER_COLOR_SNOW
    set udg_AreaSpawnUnitA[8]='n08H' // 'n08H': unit "Ice Elemental"
    set udg_AreaSpawnUnitB[8]='n0AG' // 'n0AG': unit "Leshach Entite"
    set udg_ZoneColor[8]=PLAYER_COLOR_LIGHT_BLUE
    set udg_ZoneColor[9]=ConvertPlayerColor(24)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=9
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_ElementalAlive[GetForLoopIndexA()]=false
        set udg_ElementalKillStreak[GetForLoopIndexA()]=0
        if(Trig_Elemental_Setup_Cond_ElementDefined())then
            set udg_TempInteger=GetForLoopIndexA()
            call ConditionalTriggerExecute(gg_trg_Elemental_Spawn)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call EnableTrigger(gg_trg_Elemental_Wander)
    call EnableTrigger(gg_trg_Elemental_Assist_Attack)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Elemental_Spawn_Conditions takes nothing returns boolean
    return(udg_SpawnsPaused==false)
endfunction

function Trig_Elemental_Spawn_Cond_SpawnEntite takes nothing returns boolean
    // A random whole number from 1 through 4.
    return(GetRandomInt(1,4)<=udg_ElementalKillStreak[udg_TempInteger])and(IsQuestCompleted(udg_SideQuest[40]))
endfunction

function Trig_Elemental_Spawn_Actions takes nothing returns nothing
    // A random whole number from 1 through LoadIntegerBJ(udg_TempInteger, 2, udg_SpawnDataHashRef).
    set udg_ElementalTargetLoc[udg_TempInteger]=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_TempInteger,2,udg_SpawnDataHashRef)),udg_TempInteger,udg_SpawnRectHashRef))
    if(Trig_Elemental_Spawn_Cond_SpawnEntite())then
        call CreateNUnitsAtLoc(1,udg_AreaSpawnUnitB[udg_TempInteger],Player(8),udg_ElementalTargetLoc[udg_TempInteger],bj_UNIT_FACING)
    else
        call CreateNUnitsAtLoc(1,udg_AreaSpawnUnitA[udg_TempInteger],Player(8),udg_ElementalTargetLoc[udg_TempInteger],bj_UNIT_FACING)
    endif
    set udg_ZoneBoss[udg_TempInteger]=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_QuestNpcUnits)
    call UnitAddAbilityBJ('A0MV',GetLastCreatedUnit()) // 'A0MV': ability "Plentiful"
    call SetUnitColor(GetLastCreatedUnit(),udg_ZoneColor[udg_TempInteger])
    set udg_ElementalMoveTimer[udg_TempInteger]=2
    set udg_ElementalAlive[udg_TempInteger]=true
endfunction

function Trig_Elemental_Wander_Cond_NearTargetLoc takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_ElementalTargetLoc at position loop counter A.
    return(DistanceBetweenPoints(udg_TempPoint,udg_ElementalTargetLoc[GetForLoopIndexA()])<=512.)
endfunction

function Trig_Elemental_Wander_Cond_LacksWard takes nothing returns boolean
    return(UnitHasBuffBJ(udg_ZoneBoss[GetForLoopIndexA()],'B007')==false)or(UnitHasBuffBJ(udg_ZoneBoss[GetForLoopIndexA()],'B005')==false) // 'B007': buff "Protect"; 'B005': buff "Shell"
endfunction

function Trig_Elemental_Wander_Cond_CanCastWall takes nothing returns boolean
    return(GetOwningPlayer(udg_ZoneBoss[GetForLoopIndexA()])==Player($B))and(GetUnitAbilityLevelSwapped('A0UB',udg_ZoneBoss[GetForLoopIndexA()])>=1)and(Trig_Elemental_Wander_Cond_LacksWard()) // $B = 11; 'A0UB': ability "Wall"
endfunction

function Trig_Elemental_Wander_Cond_MoveDue takes nothing returns boolean
    return(udg_ElementalMoveTimer[GetForLoopIndexA()]>=3)
endfunction

function Trig_Elemental_Wander_Cond_ElementalAlive takes nothing returns boolean
    return(udg_ElementalAlive[GetForLoopIndexA()])
endfunction

function Trig_Elemental_Wander_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=9
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Elemental_Wander_Cond_ElementalAlive())then
            set udg_TempPoint=GetUnitLoc(udg_ZoneBoss[GetForLoopIndexA()])
            if(Trig_Elemental_Wander_Cond_NearTargetLoc())then
                // Increase udg_ElementalMoveTimer at position loop counter A by 2.
                set udg_ElementalMoveTimer[GetForLoopIndexA()]=(udg_ElementalMoveTimer[GetForLoopIndexA()]+2)
            else
                set udg_ElementalMoveTimer[GetForLoopIndexA()]=(udg_ElementalMoveTimer[GetForLoopIndexA()]+1)
            endif
            call RemoveLocation(udg_TempPoint)
            if(Trig_Elemental_Wander_Cond_MoveDue())then
                call RemoveLocation(udg_ElementalTargetLoc[GetForLoopIndexA()])
                set udg_ElementalMoveTimer[GetForLoopIndexA()]=1
                // A random whole number from 1 through LoadIntegerBJ(loop counter A, 2, udg_SpawnDataHashRef).
                set udg_ElementalTargetLoc[GetForLoopIndexA()]=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(GetForLoopIndexA(),2,udg_SpawnDataHashRef)),GetForLoopIndexA(),udg_SpawnRectHashRef))
                call IssuePointOrderLocBJ(udg_ZoneBoss[GetForLoopIndexA()],"attack",udg_ElementalTargetLoc[GetForLoopIndexA()])
            else
                if(Trig_Elemental_Wander_Cond_CanCastWall())then
                    call IssueTargetOrderBJ(udg_ZoneBoss[GetForLoopIndexA()],"frostarmor",udg_ZoneBoss[GetForLoopIndexA()])
                endif
            endif
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

function Trig_Elemental_Aggro_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_QuestNpcUnits))
endfunction

function Trig_Elemental_Aggro_Actions takes nothing returns nothing
    call SetUnitOwner(GetTriggerUnit(),Player($B),false) // $B = 11
    call IssueTargetOrderBJ(GetTriggerUnit(),"attack",GetAttacker())
endfunction

function Trig_Elemental_Assist_Attack_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_ElementRecordUnit),udg_ActivePlayers))
endfunction

function Trig_Elemental_Assist_Attack_Cond_ChosenInRange takes nothing returns boolean
    // The straight-line distance between udg_RetreatPoint and udg_TempPoint5.
    return(DistanceBetweenPoints(udg_RetreatPoint,udg_TempPoint5)<=1000.)
endfunction

function Trig_Elemental_Assist_Attack_Cond_ChosenElementalFree takes nothing returns boolean
    return(IsUnitAliveBJ(udg_ZoneBoss[udg_ElementRecord[udg_ElementRecord[0]]]))and(GetOwningPlayer(udg_ZoneBoss[udg_ElementRecord[udg_ElementRecord[0]]])==Player(8))
endfunction

function Trig_Elemental_Assist_Attack_Cond_HolyInRange takes nothing returns boolean
    // The straight-line distance between udg_RetreatPoint and udg_TempPoint5.
    return(DistanceBetweenPoints(udg_RetreatPoint,udg_TempPoint5)<=1000.)
endfunction

function Trig_Elemental_Assist_Attack_Cond_HolyElementalFree takes nothing returns boolean
    return(IsUnitAliveBJ(udg_ZoneBoss[7]))and(GetOwningPlayer(udg_ZoneBoss[7])==Player(8))
endfunction

function Trig_Elemental_Assist_Attack_Actions takes nothing returns nothing
    set udg_RetreatPoint=GetUnitLoc(udg_ElementRecordUnit)
    if(Trig_Elemental_Assist_Attack_Cond_ChosenElementalFree())then
        set udg_TempPoint5=GetUnitLoc(udg_ZoneBoss[udg_ElementRecord[udg_ElementRecord[0]]])
        if(Trig_Elemental_Assist_Attack_Cond_ChosenInRange())then
            call SetUnitOwner(udg_ZoneBoss[udg_ElementRecord[udg_ElementRecord[0]]],Player($B),false) // $B = 11
            call IssueTargetOrderBJ(udg_ZoneBoss[udg_ElementRecord[udg_ElementRecord[0]]],"attack",udg_ElementRecordUnit)
        endif
        call RemoveLocation(udg_TempPoint5)
    endif
    if(Trig_Elemental_Assist_Attack_Cond_HolyElementalFree())then
        set udg_TempPoint5=GetUnitLoc(udg_ZoneBoss[7])
        if(Trig_Elemental_Assist_Attack_Cond_HolyInRange())then
            call SetUnitOwner(udg_ZoneBoss[7],Player($B),false) // $B = 11
            call IssueTargetOrderBJ(udg_ZoneBoss[7],"attack",udg_ElementRecordUnit)
        endif
        call RemoveLocation(udg_TempPoint5)
    endif
    call RemoveLocation(udg_RetreatPoint)
endfunction

function Trig_Elemental_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_QuestNpcUnits))
endfunction

function Trig_Elemental_Death_Cond_DarkNotUnlocked takes nothing returns boolean
    return(udg_AreaSpawnUnitA[9]==0)
endfunction

function Trig_Elemental_Death_Cond_IsHolyElemental takes nothing returns boolean
    return(GetUnitPointValue(GetTriggerUnit())==7)
endfunction

function Trig_Elemental_Death_Cond_ElementalDropRoll takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Elemental_Death_Cond_IsDarkElemental takes nothing returns boolean
    return(GetUnitPointValue(GetTriggerUnit())==9)
endfunction

function Trig_Elemental_Death_Cond_AllElementalsKilled takes nothing returns boolean
    return(udg_ElementalKilledOnce[2])and(udg_ElementalKilledOnce[3])and(udg_ElementalKilledOnce[4])and(udg_ElementalKilledOnce[5])and(udg_ElementalKilledOnce[6])and(udg_ElementalKilledOnce[7])and(udg_ElementalKilledOnce[8])and(udg_ElementalKilledOnce[9])
endfunction

function Trig_Elemental_Death_Cond_FirstKillOfElement takes nothing returns boolean
    return(udg_ElementalKilledOnce[GetUnitPointValue(GetTriggerUnit())]==false)
endfunction

function Trig_Elemental_Death_Cond_LowLevelKill takes nothing returns boolean
    return(GetUnitLevel(GetTriggerUnit())<=50)
endfunction

function Trig_Elemental_Death_Cond_HasKiller takes nothing returns boolean
    return(GetKillingUnitBJ()!=null)
endfunction

function Trig_Elemental_Death_Actions takes nothing returns nothing
    call RemoveLocation(udg_ElementalTargetLoc[GetUnitPointValue(GetTriggerUnit())])
    if(Trig_Elemental_Death_Cond_HasKiller())then
        set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
        if(Trig_Elemental_Death_Cond_LowLevelKill())then
            set udg_ElementalKillStreak[GetUnitPointValue(GetTriggerUnit())]=(udg_ElementalKillStreak[GetUnitPointValue(GetTriggerUnit())]+1)
        else
            set udg_ElementalKillStreak[GetUnitPointValue(GetTriggerUnit())]=0
            if(Trig_Elemental_Death_Cond_IsDarkElemental())then
                if(Trig_Elemental_Death_Cond_ElementalDropRoll())then
                    call CreateItemLoc('I01Z',udg_TempPoint3) // 'I01Z': item "Crystal Shard"
                else
                    call CreateItemLoc('I0CV',udg_TempPoint3) // 'I0CV': item "10000 Gold Coins"
                endif
            else
                if(Trig_Elemental_Death_Cond_IsHolyElemental())then
                    if(Trig_Elemental_Death_Cond_DarkNotUnlocked())then
                        set udg_AreaSpawnUnitA[9]='n0AM' // 'n0AM': unit "Dark Elemental"
                        set udg_AreaSpawnUnitB[9]='n0AO' // 'n0AO': unit "Leamonde Entite"
                        set udg_TempInteger=9
                        call ConditionalTriggerExecute(gg_trg_Elemental_Spawn)
                    endif
                endif
                call CreateItemLoc('I021',udg_TempPoint3) // 'I021': item "1500 Gold Coins"
            endif
            if(Trig_Elemental_Death_Cond_FirstKillOfElement())then
                set udg_ElementalKilledOnce[GetUnitPointValue(GetTriggerUnit())]=true
                if(Trig_Elemental_Death_Cond_AllElementalsKilled())then
                    call CreateItemLoc('I0BK',udg_TempPoint3) // 'I0BK': item "Horn of Madain Sari"
                    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
                endif
            endif
        endif
        call RemoveLocation(udg_TempPoint3)
    endif
    set udg_ElementalAlive[GetUnitPointValue(GetTriggerUnit())]=false
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_QuestNpcUnits)
    call Wait_Polled(30.)
    set udg_TempInteger=GetUnitPointValue(GetTriggerUnit())
    call ConditionalTriggerExecute(gg_trg_Elemental_Spawn)
endfunction

// World Editor calls InitTrig_Elemental automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Elemental (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Elemental takes nothing returns nothing
endfunction

function Register_Elemental_Setup takes nothing returns nothing
    set gg_trg_Elemental_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Elemental_Setup)
    call TriggerAddAction(gg_trg_Elemental_Setup,function Trig_Elemental_Setup_Actions)
endfunction

function Register_Elemental_Spawn takes nothing returns nothing
    set gg_trg_Elemental_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Elemental_Spawn)
    call TriggerAddCondition(gg_trg_Elemental_Spawn,Condition(function Trig_Elemental_Spawn_Conditions))
    call TriggerAddAction(gg_trg_Elemental_Spawn,function Trig_Elemental_Spawn_Actions)
endfunction

function Register_Elemental_Wander takes nothing returns nothing
    set gg_trg_Elemental_Wander=CreateTrigger()
    call DisableTrigger(gg_trg_Elemental_Wander)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Elemental_Wander,20.)
    call TriggerAddAction(gg_trg_Elemental_Wander,function Trig_Elemental_Wander_Actions)
endfunction

function Register_Elemental_Aggro takes nothing returns nothing
    set gg_trg_Elemental_Aggro=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Elemental_Aggro,Player(8),EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Elemental_Aggro,Condition(function Trig_Elemental_Aggro_Conditions))
    call TriggerAddAction(gg_trg_Elemental_Aggro,function Trig_Elemental_Aggro_Actions)
endfunction

function Register_Elemental_Assist_Attack takes nothing returns nothing
    set gg_trg_Elemental_Assist_Attack=CreateTrigger()
    call DisableTrigger(gg_trg_Elemental_Assist_Attack)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Elemental_Assist_Attack,udg_ElementRecordTimer)
    call TriggerAddCondition(gg_trg_Elemental_Assist_Attack,Condition(function Trig_Elemental_Assist_Attack_Conditions))
    call TriggerAddAction(gg_trg_Elemental_Assist_Attack,function Trig_Elemental_Assist_Attack_Actions)
endfunction

function Register_Elemental_Death takes nothing returns nothing
    set gg_trg_Elemental_Death=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Elemental_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Elemental_Death,Condition(function Trig_Elemental_Death_Conditions))
    call TriggerAddAction(gg_trg_Elemental_Death,function Trig_Elemental_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Elemental takes nothing returns nothing
    call Register_Elemental_Setup()
    call Register_Elemental_Spawn()
    call Register_Elemental_Wander()
    call Register_Elemental_Aggro()
    call Register_Elemental_Assist_Attack()
    call Register_Elemental_Death()
endfunction

endlibrary
