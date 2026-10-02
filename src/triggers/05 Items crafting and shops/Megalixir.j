library TMegalixir
function Trig_Megalixir_Remove_Stock_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetSoldItem())=='I03P') // 'I03P': item "Megalixir"
endfunction

function Trig_Megalixir_Remove_Stock_Actions takes nothing returns nothing
    call RemoveItemFromStockBJ(GetItemTypeId(GetSoldItem()),GetSellingUnit())
endfunction

// World Editor calls InitTrig_Megalixir automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Megalixir (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Megalixir takes nothing returns nothing
endfunction

function Register_Megalixir_Remove_Stock takes nothing returns nothing
    set gg_trg_Megalixir_Remove_Stock=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Megalixir_Remove_Stock,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Megalixir_Remove_Stock,Condition(function Trig_Megalixir_Remove_Stock_Conditions))
    call TriggerAddAction(gg_trg_Megalixir_Remove_Stock,function Trig_Megalixir_Remove_Stock_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Megalixir takes nothing returns nothing
    call Register_Megalixir_Remove_Stock()
endfunction

endlibrary
