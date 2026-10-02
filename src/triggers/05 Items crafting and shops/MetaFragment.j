library TMetaFragment
function Trig_MetaFragment_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='ciri') // 'ciri': item "Meta Fragment"
endfunction

function Trig_MetaFragment_Pickup_Actions takes nothing returns nothing
    set udg_MetaFragments[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_MetaFragments[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
endfunction

// World Editor calls InitTrig_MetaFragment automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MetaFragment (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MetaFragment takes nothing returns nothing
endfunction

function Register_MetaFragment_Pickup takes nothing returns nothing
    set gg_trg_MetaFragment_Pickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MetaFragment_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_MetaFragment_Pickup,Condition(function Trig_MetaFragment_Pickup_Conditions))
    call TriggerAddAction(gg_trg_MetaFragment_Pickup,function Trig_MetaFragment_Pickup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_MetaFragment takes nothing returns nothing
    call Register_MetaFragment_Pickup()
endfunction

endlibrary
