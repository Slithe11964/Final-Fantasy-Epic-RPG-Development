library TAngbar requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Angbar_Pickup=null
    trigger gg_trg_Angbar_Drop=null
endglobals

function Trig_Angbar_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0HU')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit()))) // 'I0HU': item "Angbar"
endfunction

function Trig_Angbar_Pickup_Actions takes nothing returns nothing
    call StartTimerBJ(udg_PostReviveTimer,false,.01)
endfunction

function Trig_Angbar_Drop_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0HU')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit()))) // 'I0HU': item "Angbar"
endfunction

function Trig_Angbar_Drop_Actions takes nothing returns nothing
    call SetUnitVertexColorBJ(GetTriggerUnit(),'d','d','d',0)
    call StartTimerBJ(udg_PostReviveTimer,false,.01)
endfunction

// World Editor calls InitTrig_Angbar automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Angbar (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Angbar takes nothing returns nothing
endfunction

function Register_Angbar_Pickup takes nothing returns nothing
    set gg_trg_Angbar_Pickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Angbar_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Angbar_Pickup,Condition(function Trig_Angbar_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Angbar_Pickup,function Trig_Angbar_Pickup_Actions)
endfunction

function Register_Angbar_Drop takes nothing returns nothing
    set gg_trg_Angbar_Drop=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Angbar_Drop,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Angbar_Drop,Condition(function Trig_Angbar_Drop_Conditions))
    call TriggerAddAction(gg_trg_Angbar_Drop,function Trig_Angbar_Drop_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Angbar takes nothing returns nothing
    call Register_Angbar_Pickup()
    call Register_Angbar_Drop()
endfunction

endlibrary
