library TInfo requires TForce
function Trig_Info_Item_Show_Lore_Conditions takes nothing returns boolean
    return(SubStringBJ(GetItemName(GetSoldItem()),1,$D)=="Information: ") // $D = 13
endfunction

function Trig_Info_Item_Show_Lore_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetBuyingUnit()))
    call DisplayTimedTextToForce(udg_TempForce,30.,(("|cffffcc00"+GetItemName(GetSoldItem()))+"|r"))
    call DisplayTimedTextToForce(udg_TempForce,30.,udg_LoreText[GetItemLevel(GetSoldItem())])
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Info takes nothing returns nothing
endfunction

function RegisterR11_Info_Item_Show_Lore takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Info_Item_Show_Lore=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Info_Item_Show_Lore,EVENT_PLAYER_UNIT_SELL_ITEM)

call TriggerAddCondition(gg_trg_Info_Item_Show_Lore,Condition(function Trig_Info_Item_Show_Lore_Conditions))

call TriggerAddAction(gg_trg_Info_Item_Show_Lore,function Trig_Info_Item_Show_Lore_Actions)

endfunction




endlibrary
