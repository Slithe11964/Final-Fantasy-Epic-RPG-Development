library TShimmerweed
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Shimmerweed_Spawn=null
    trigger gg_trg_Shimmerweed_Pickup=null
endglobals

function Trig_Shimmerweed_Spawn_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetRectCenter(gg_rct_568)
    set udg_ShimmerweedItem=CreateItemLoc('I0FM',l_tempPoint) // 'I0FM': item "Shimmerweed"
    call RemoveLocation(l_tempPoint)
    call EnableTrigger(gg_trg_Shimmerweed_Pickup)
    set l_tempPoint=null
endfunction

function Trig_Shimmerweed_Pickup_Conditions takes nothing returns boolean
    return(GetManipulatedItem()==udg_ShimmerweedItem)
endfunction

function Trig_Shimmerweed_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call StartTimerBJ(udg_HerbRespawnTimer[0],false,180.)
endfunction

// World Editor calls InitTrig_Shimmerweed automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Shimmerweed (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Shimmerweed takes nothing returns nothing
endfunction

function Register_Shimmerweed_Spawn takes nothing returns nothing
    set gg_trg_Shimmerweed_Spawn=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Shimmerweed_Spawn,udg_HerbRespawnTimer[0])
    call TriggerAddAction(gg_trg_Shimmerweed_Spawn,function Trig_Shimmerweed_Spawn_Actions)
endfunction

function Register_Shimmerweed_Pickup takes nothing returns nothing
    set gg_trg_Shimmerweed_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_Shimmerweed_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shimmerweed_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Shimmerweed_Pickup,Condition(function Trig_Shimmerweed_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Shimmerweed_Pickup,function Trig_Shimmerweed_Pickup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Shimmerweed takes nothing returns nothing
    call Register_Shimmerweed_Spawn()
    call Register_Shimmerweed_Pickup() // starts off; enabled by Shimmerweed
endfunction

endlibrary
