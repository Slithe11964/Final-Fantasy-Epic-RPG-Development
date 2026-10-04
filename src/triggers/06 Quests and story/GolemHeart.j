library TGolemHeart requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_GolemHeart_Ping=null
    trigger gg_trg_GolemHeart_Pickup=null
endglobals

function Trig_GolemHeart_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[2]!=null)
endfunction

function Trig_GolemHeart_Ping_Cond_HeartCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[2]))
endfunction

function Trig_GolemHeart_Ping_Actions takes nothing returns nothing
    if(Trig_GolemHeart_Ping_Cond_HeartCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_Hjai_0093)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[2])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_GolemHeart_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I022') // 'I022': item "Mithril Golem's Heart"
endfunction

function Trig_GolemHeart_Pickup_Actions takes nothing returns nothing
    local force l_tempForce
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(l_tempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Mithril Golem's heart to Alma.")
    call DestroyForce(l_tempForce)
    call ExecuteFunc("MithrilGolem_HeartTaken") // the quest log: "Bring the Mithril Golem's heart to Alma."
    call EnableTrigger(gg_trg_MithrilGolem_Activate)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_GolemHeart automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_GolemHeart (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_GolemHeart takes nothing returns nothing
endfunction

function Register_GolemHeart_Ping takes nothing returns nothing
    set gg_trg_GolemHeart_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_GolemHeart_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_GolemHeart_Ping,15.)
    call TriggerAddCondition(gg_trg_GolemHeart_Ping,Condition(function Trig_GolemHeart_Ping_Conditions))
    call TriggerAddAction(gg_trg_GolemHeart_Ping,function Trig_GolemHeart_Ping_Actions)
endfunction

function Register_GolemHeart_Pickup takes nothing returns nothing
    set gg_trg_GolemHeart_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_GolemHeart_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_GolemHeart_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_GolemHeart_Pickup,Condition(function Trig_GolemHeart_Pickup_Conditions))
    call TriggerAddAction(gg_trg_GolemHeart_Pickup,function Trig_GolemHeart_Pickup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_GolemHeart takes nothing returns nothing
    call Register_GolemHeart_Ping() // starts off; enabled by MithrilGolem; disabled by MithrilGolem
    call Register_GolemHeart_Pickup() // starts off; enabled by MithrilGolem
endfunction

endlibrary
