library TCrystalBall requires TForce
function Trig_CrystalBall_Drop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[20]=CreateItemLoc('I02B',udg_TempPoint) // 'I02B': item "Crystal Ball"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call CreateItemLoc('I02S',udg_TempPoint) // 'I02S': item "Cursed Wand"
    call CreateItemLoc('I0EV',udg_TempPoint) // 'I0EV': item "Spirit Scroll"
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_CrystalBall_Ping)
    call EnableTrigger(gg_trg_CrystalBall_Pickup)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_CrystalBall_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[20]!=null)
endfunction

function Trig_CrystalBall_Ping_Cond_BallCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[20]))
endfunction

function Trig_CrystalBall_Ping_Actions takes nothing returns nothing
    if(Trig_CrystalBall_Ping_Cond_BallCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_E004_0190)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[20])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_CrystalBall_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I02B') // 'I02B': item "Crystal Ball"
endfunction

function Trig_CrystalBall_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Crystal Ball to Undomiel.")
    call DestroyForce(udg_TempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[21],"Bring the Crystal Ball to Undomiel.")
    call EnableTrigger(gg_trg_Nimphrodel_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_CrystalBall automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_CrystalBall (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_CrystalBall takes nothing returns nothing
endfunction

function Register_CrystalBall_Drop takes nothing returns nothing
    set gg_trg_CrystalBall_Drop=CreateTrigger()
    call DisableTrigger(gg_trg_CrystalBall_Drop)
    call TriggerAddAction(gg_trg_CrystalBall_Drop,function Trig_CrystalBall_Drop_Actions)
endfunction

function Register_CrystalBall_Ping takes nothing returns nothing
    set gg_trg_CrystalBall_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_CrystalBall_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_CrystalBall_Ping,15.)
    call TriggerAddCondition(gg_trg_CrystalBall_Ping,Condition(function Trig_CrystalBall_Ping_Conditions))
    call TriggerAddAction(gg_trg_CrystalBall_Ping,function Trig_CrystalBall_Ping_Actions)
endfunction

function Register_CrystalBall_Pickup takes nothing returns nothing
    set gg_trg_CrystalBall_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_CrystalBall_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_CrystalBall_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_CrystalBall_Pickup,Condition(function Trig_CrystalBall_Pickup_Conditions))
    call TriggerAddAction(gg_trg_CrystalBall_Pickup,function Trig_CrystalBall_Pickup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_CrystalBall takes nothing returns nothing
    call Register_CrystalBall_Drop()
    call Register_CrystalBall_Ping()
    call Register_CrystalBall_Pickup()
endfunction

endlibrary
