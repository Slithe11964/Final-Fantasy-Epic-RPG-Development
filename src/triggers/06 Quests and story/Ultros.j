library TUltros requires TLoc, TWait
function Trig_Ultros_Spawn_IsQuestActive takes nothing returns boolean
    return(IsQuestFailed(udg_SideQuest[58])==false)
endfunction

function Trig_Ultros_Spawn_Actions takes nothing returns nothing
    call CreateNUnitsAtLoc(1,'n0C1',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0C1': unit "Ultros"; $B = 11
    call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_PINK)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossUnits)
    // (udg_Difficulty) plus (1).
    set udg_TentacleCount=(udg_Difficulty+1)
    call TriggerRegisterUnitEvent(gg_trg_Ultros_SummonTentacle,GetLastCreatedUnit(),EVENT_UNIT_ATTACKED)
    call TriggerRegisterUnitEvent(gg_trg_Ultros_Death,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Ultros_SummonTentacle)
    call EnableTrigger(gg_trg_Ultros_Death)
    call EnableTrigger(gg_trg_Ultros_TentacleDeath)
    if(Trig_Ultros_Spawn_IsQuestActive())then
        call QuestSetDescriptionBJ(udg_SideQuest[58],"Defeat Ultros.")
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat Ultros.")
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Ultros_SummonTentacle_Conditions takes nothing returns boolean
    // A random whole number from 1 through 3.
    return(udg_TentacleCount>0)and(GetRandomInt(1,3)==1)
endfunction

function Trig_Ultros_SummonTentacle_Actions takes nothing returns nothing
    set udg_TentacleCount=(udg_TentacleCount-1)
    set udg_TempPoint=GetUnitLoc(GetAttacker())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,300.,GetRandomDirectionDeg())
    call CreateNUnitsAtLocFacingLocBJ(1,'n0C9',Player($B),udg_TempPoint2,udg_TempPoint) // 'n0C9': object name not found in map data; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call SetUnitAnimation(GetLastCreatedUnit(),"birth")
    call QueueUnitAnimationBJ(GetLastCreatedUnit(),"stand")
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TentacleGroup)
    call UnitApplyTimedLifeBJ(15.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
endfunction

function Trig_Ultros_TentacleDeath_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_TentacleGroup))
endfunction

function Trig_Ultros_TentacleDeath_Actions takes nothing returns nothing
    call Wait_Polled(3.)
    set udg_TentacleCount=(udg_TentacleCount+1)
endfunction

function Trig_Ultros_Death_IsDropBonusOn takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Ultros_Death_KillEnumUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Ultros_Death_IsQuestActive takes nothing returns boolean
    return(IsQuestFailed(udg_SideQuest[58])==false)
endfunction

function Trig_Ultros_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Ultros_Death_IsDropBonusOn())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call DisableTrigger(gg_trg_Ultros_SummonTentacle)
    call DestroyTrigger(gg_trg_Ultros_SummonTentacle)
    call DisableTrigger(gg_trg_Ultros_TentacleDeath)
    call DestroyTrigger(gg_trg_Ultros_TentacleDeath)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0HT',udg_TempPoint) // 'I0HT': item "Prominent Cloak"
    call CreateTextTagLocBJ("ARGH! YOU... DAMN...",udg_TempPoint,0,12.,'d',50.,'d',0)
    call RemoveLocation(udg_TempPoint)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
    call ForGroupBJ(udg_TentacleGroup,function Trig_Ultros_Death_KillEnumUnit)
    call GroupClear(udg_TentacleGroup)
    set udg_TentacleCount=-2
    call EnableTrigger(gg_trg_Monstrum_Ambush_Arm)
    if(Trig_Ultros_Death_IsQuestActive())then
        call QuestSetDescriptionBJ(udg_SideQuest[58],"Return to Sarai.")
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Return to Sarai.")
        call GroupAddUnitSimple(gg_unit_e013_0176,udg_BossUnits)
        call EnableTrigger(gg_trg_Tentacles_Reward)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Ultros automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ultros (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ultros takes nothing returns nothing
endfunction

function Register_Ultros_Spawn takes nothing returns nothing
    set gg_trg_Ultros_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Ultros_Spawn)
    call TriggerAddAction(gg_trg_Ultros_Spawn,function Trig_Ultros_Spawn_Actions)
endfunction

function Register_Ultros_SummonTentacle takes nothing returns nothing
    set gg_trg_Ultros_SummonTentacle=CreateTrigger()
    call DisableTrigger(gg_trg_Ultros_SummonTentacle)
    call TriggerAddCondition(gg_trg_Ultros_SummonTentacle,Condition(function Trig_Ultros_SummonTentacle_Conditions))
    call TriggerAddAction(gg_trg_Ultros_SummonTentacle,function Trig_Ultros_SummonTentacle_Actions)
endfunction

function Register_Ultros_TentacleDeath takes nothing returns nothing
    set gg_trg_Ultros_TentacleDeath=CreateTrigger()
    call DisableTrigger(gg_trg_Ultros_TentacleDeath)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Ultros_TentacleDeath,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Ultros_TentacleDeath,Condition(function Trig_Ultros_TentacleDeath_Conditions))
    call TriggerAddAction(gg_trg_Ultros_TentacleDeath,function Trig_Ultros_TentacleDeath_Actions)
endfunction

function Register_Ultros_Death takes nothing returns nothing
    set gg_trg_Ultros_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Ultros_Death)
    call TriggerAddAction(gg_trg_Ultros_Death,function Trig_Ultros_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ultros takes nothing returns nothing
    call Register_Ultros_Spawn()
    call Register_Ultros_SummonTentacle()
    call Register_Ultros_TentacleDeath()
    call Register_Ultros_Death()
endfunction

endlibrary
