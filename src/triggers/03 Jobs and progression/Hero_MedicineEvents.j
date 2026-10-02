library THeroMedicineEvents
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hero_Medicine_Pickup=null
endglobals

function Trig_Hero_Medicine_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0A7')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)) // 'I0A7': item "Hidden Hero Medicine"
endfunction

function Trig_Hero_Medicine_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call EnableTrigger(gg_trg_HeroMedicine_Refill)
    call EnableTrigger(gg_trg_HeroMedicine_Pickup)
endfunction

function InitTrig_Hero_MedicineEvents takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Hero_Part3 (module Hero),
// which keeps the original registration order.

function Register_Hero_Medicine_Pickup takes nothing returns nothing
    set gg_trg_Hero_Medicine_Pickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Hero_Medicine_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Hero_Medicine_Pickup,Condition(function Trig_Hero_Medicine_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Hero_Medicine_Pickup,function Trig_Hero_Medicine_Pickup_Actions)
endfunction

endlibrary
