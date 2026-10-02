library TBelongings requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Belongings_Ping=null
    trigger gg_trg_Belongings_PickedUp=null
endglobals

function Trig_Belongings_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[23]!=null)
endfunction

function Trig_Belongings_Ping_Cond_BelongingsCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[23]))
endfunction

function Trig_Belongings_Ping_Actions takes nothing returns nothing
    if(Trig_Belongings_Ping_Cond_BelongingsCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_h01P_0017)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[23])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Belongings_PickedUp_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='ktrm') // 'ktrm': item "A Lady's Belongings"
endfunction

function Trig_Belongings_PickedUp_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(Force_OfPlayer(GetOwningPlayer(GetManipulatingUnit())),bj_QUESTMESSAGE_UPDATED,"Bring the belongings back to Lady Curse.")
    call QuestSetDescriptionBJ(udg_SideQuest[36],"Bring the belongings back to Lady Curse.")
    call EnableTrigger(gg_trg_LadyCurse_ReturnBelongings)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Belongings automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Belongings (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Belongings takes nothing returns nothing
endfunction

function Register_Belongings_Ping takes nothing returns nothing
    set gg_trg_Belongings_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Belongings_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Belongings_Ping,15.)
    call TriggerAddCondition(gg_trg_Belongings_Ping,Condition(function Trig_Belongings_Ping_Conditions))
    call TriggerAddAction(gg_trg_Belongings_Ping,function Trig_Belongings_Ping_Actions)
endfunction

function Register_Belongings_PickedUp takes nothing returns nothing
    set gg_trg_Belongings_PickedUp=CreateTrigger()
    call DisableTrigger(gg_trg_Belongings_PickedUp)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Belongings_PickedUp,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Belongings_PickedUp,Condition(function Trig_Belongings_PickedUp_Conditions))
    call TriggerAddAction(gg_trg_Belongings_PickedUp,function Trig_Belongings_PickedUp_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Belongings takes nothing returns nothing
    call Register_Belongings_Ping() // starts off; enabled by AnnoyingMonster; disabled by LadyCurse
    call Register_Belongings_PickedUp() // starts off; enabled by AnnoyingMonster
endfunction

endlibrary
