library TBlock
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Block_Item_Destroy=null
endglobals

function Trig_Block_Item_Destroy_Conditions takes nothing returns boolean
    return(GetIssuedOrderIdBJ()==$D000F) // $D000F = 851983
endfunction

function Trig_Block_Item_Destroy_IsRealItem takes nothing returns boolean
    return(GetItemType(GetOrderTargetItem())!=ITEM_TYPE_ANY)and(GetOrderTargetItem()!=null)and('I04O'!=GetItemTypeId(GetOrderTargetItem())) // 'I04O': item "Chocobo Defending"
endfunction

function Trig_Block_Item_Destroy_Actions takes nothing returns nothing
    if(Trig_Block_Item_Destroy_IsRealItem())then
        call PauseUnitBJ(true,GetOrderedUnit())
        call IssueImmediateOrderBJ(GetOrderedUnit(),"stop")
        call PauseUnitBJ(false,GetOrderedUnit())
        call DisplayTextToForce(GetPlayersAll(),("|cFFFF0000"+(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))+", don't be stupid and sell the item rather than destroying it.|r")))
    endif
endfunction

// World Editor calls InitTrig_Block automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Block (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Block takes nothing returns nothing
endfunction

function Register_Block_Item_Destroy takes nothing returns nothing
    set gg_trg_Block_Item_Destroy=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Block_Item_Destroy,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerAddCondition(gg_trg_Block_Item_Destroy,Condition(function Trig_Block_Item_Destroy_Conditions))
    call TriggerAddAction(gg_trg_Block_Item_Destroy,function Trig_Block_Item_Destroy_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Block takes nothing returns nothing
    call Register_Block_Item_Destroy()
endfunction

endlibrary
