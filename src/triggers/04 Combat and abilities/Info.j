library TInfo requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Info_Item_Show_Lore=null
endglobals

function Trig_Info_Item_Show_Lore_Conditions takes nothing returns boolean
    return(SubStringBJ(GetItemName(GetSoldItem()),1,$D)=="Information: ") // $D = 13
endfunction

function Trig_Info_Item_Show_Lore_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetBuyingUnit()))
    call DisplayTimedTextToForce(l_tempForce,30.,(("|cffffcc00"+GetItemName(GetSoldItem()))+"|r"))
    call DisplayTimedTextToForce(l_tempForce,30.,udg_LoreText[GetItemLevel(GetSoldItem())])
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_Info automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Info (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Info takes nothing returns nothing
endfunction

function Register_Info_Item_Show_Lore takes nothing returns nothing
    set gg_trg_Info_Item_Show_Lore=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Info_Item_Show_Lore,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Info_Item_Show_Lore,Condition(function Trig_Info_Item_Show_Lore_Conditions))
    call TriggerAddAction(gg_trg_Info_Item_Show_Lore,function Trig_Info_Item_Show_Lore_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Info takes nothing returns nothing
    call Register_Info_Item_Show_Lore()
endfunction

endlibrary
