library TThunderbloom
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Thunderbloom_Spawn=null
    trigger gg_trg_Thunderbloom_Pickup=null
endglobals

function Trig_Thunderbloom_Spawn_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_569)
    set udg_ThunderbloomItem=CreateItemLoc('I0FN',udg_TempPoint) // 'I0FN': item "Thunderbloom Bulb"
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Thunderbloom_Pickup)
endfunction

function Trig_Thunderbloom_Pickup_Conditions takes nothing returns boolean
    return(GetManipulatedItem()==udg_ThunderbloomItem)
endfunction

function Trig_Thunderbloom_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call StartTimerBJ(udg_HerbRespawnTimer[1],false,180.)
endfunction

// World Editor calls InitTrig_Thunderbloom automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Thunderbloom (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Thunderbloom takes nothing returns nothing
endfunction

function Register_Thunderbloom_Spawn takes nothing returns nothing
    set gg_trg_Thunderbloom_Spawn=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Thunderbloom_Spawn,udg_HerbRespawnTimer[1])
    call TriggerAddAction(gg_trg_Thunderbloom_Spawn,function Trig_Thunderbloom_Spawn_Actions)
endfunction

function Register_Thunderbloom_Pickup takes nothing returns nothing
    set gg_trg_Thunderbloom_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_Thunderbloom_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Thunderbloom_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Thunderbloom_Pickup,Condition(function Trig_Thunderbloom_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Thunderbloom_Pickup,function Trig_Thunderbloom_Pickup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Thunderbloom takes nothing returns nothing
    call Register_Thunderbloom_Spawn()
    call Register_Thunderbloom_Pickup()
endfunction

endlibrary
