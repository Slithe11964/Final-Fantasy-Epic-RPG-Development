library TPortalStone requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_PortalStone_Ping=null
    trigger gg_trg_PortalStone_PickedUp=null
endglobals

function Trig_PortalStone_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[21]!=null)
endfunction

function Trig_PortalStone_Ping_Cond_StoneCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[21]))
endfunction

function Trig_PortalStone_Ping_Actions takes nothing returns nothing
    if(Trig_PortalStone_Ping_Cond_StoneCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n01S_0082)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[21])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_PortalStone_PickedUp_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I034') // 'I034': item "Portal Stone"
endfunction

function Trig_PortalStone_PickedUp_Actions takes nothing returns nothing
    local force l_tempForce
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(l_tempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Portal Stone to Melaniya.")
    call DestroyForce(l_tempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[27],"Bring the Portal Stone to Melaniya.")
    call EnableTrigger(gg_trg_Quest_GreedIsGood_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_PortalStone automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PortalStone (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PortalStone takes nothing returns nothing
endfunction

function Register_PortalStone_Ping takes nothing returns nothing
    set gg_trg_PortalStone_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_PortalStone_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_PortalStone_Ping,15.)
    call TriggerAddCondition(gg_trg_PortalStone_Ping,Condition(function Trig_PortalStone_Ping_Conditions))
    call TriggerAddAction(gg_trg_PortalStone_Ping,function Trig_PortalStone_Ping_Actions)
endfunction

function Register_PortalStone_PickedUp takes nothing returns nothing
    set gg_trg_PortalStone_PickedUp=CreateTrigger()
    call DisableTrigger(gg_trg_PortalStone_PickedUp)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_PortalStone_PickedUp,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_PortalStone_PickedUp,Condition(function Trig_PortalStone_PickedUp_Conditions))
    call TriggerAddAction(gg_trg_PortalStone_PickedUp,function Trig_PortalStone_PickedUp_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PortalStone takes nothing returns nothing
    call Register_PortalStone_Ping() // starts off; enabled by GreedIsGood; disabled by Quest_GreedIsGood
    call Register_PortalStone_PickedUp() // starts off; enabled by GreedIsGood
endfunction

endlibrary
