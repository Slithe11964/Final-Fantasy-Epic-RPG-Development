library TMegalixir
function Trig_Megalixir_Remove_Stock_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetSoldItem())=='I03P') // 'I03P': item "Megalixir"
endfunction

function Trig_Megalixir_Remove_Stock_Actions takes nothing returns nothing
    call RemoveItemFromStockBJ(GetItemTypeId(GetSoldItem()),GetSellingUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Megalixir takes nothing returns nothing
endfunction
function RegisterR11_Megalixir_Remove_Stock takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Megalixir_Remove_Stock=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Megalixir_Remove_Stock,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Megalixir_Remove_Stock,Condition(function Trig_Megalixir_Remove_Stock_Conditions))
    call TriggerAddAction(gg_trg_Megalixir_Remove_Stock,function Trig_Megalixir_Remove_Stock_Actions)
endfunction




endlibrary
