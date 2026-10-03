library TGayaOrders requires TItemShared
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Gaya_OrderImmediate=null
    trigger gg_trg_Gaya_OrderPoint=null
    trigger gg_trg_Gaya_OrderTarget=null
endglobals

function Trig_Gaya_OrderImmediate_Conditions takes nothing returns boolean
    if(not(GetUnitTypeId(GetTriggerUnit())=='H01D'))then // 'H01D': unit "Spirit of Gaya"
        return false
    endif
    if(GetIssuedOrderId()>=$D0028 and GetIssuedOrderId()<=$D002D)then // $D0028 = 852008; $D002D = 852013
        return true
    endif
    return false
endfunction

function Trig_Gaya_OrderImmediate_Actions takes nothing returns nothing
    call Item_UseFromOtherUnit(GetTriggerUnit(),(GetIssuedOrderId()-$D0028),0) // $D0028 = 852008
endfunction

function Trig_Gaya_OrderPoint_Conditions takes nothing returns boolean
    if(not(GetUnitTypeId(GetTriggerUnit())=='H01D'))then // 'H01D': unit "Spirit of Gaya"
        return false
    endif
    if(GetIssuedOrderId()>=$D0028 and GetIssuedOrderId()<=$D002D)then // $D0028 = 852008; $D002D = 852013
        return true
    endif
    return false
endfunction

function Trig_Gaya_OrderPoint_Actions takes nothing returns nothing
    call Item_UseFromOtherUnit(GetTriggerUnit(),(GetIssuedOrderId()-$D0028),1) // $D0028 = 852008
endfunction

function Trig_Gaya_OrderTarget_Conditions takes nothing returns boolean
    if(not(GetUnitTypeId(GetTriggerUnit())=='H01D'))then // 'H01D': unit "Spirit of Gaya"
        return false
    endif
    if(GetIssuedOrderId()>=$D0028 and GetIssuedOrderId()<=$D002D)then // $D0028 = 852008; $D002D = 852013
        return true
    endif
    return false
endfunction

function Trig_Gaya_OrderTarget_Actions takes nothing returns nothing
    call Item_UseFromOtherUnit(GetTriggerUnit(),(GetIssuedOrderId()-$D0028),2) // $D0028 = 852008
endfunction

function InitTrig_Gaya_Orders takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Gaya (module Gaya),
// which keeps the original registration order.

function Register_Gaya_OrderImmediate takes nothing returns nothing
    set gg_trg_Gaya_OrderImmediate=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_OrderImmediate,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerAddCondition(gg_trg_Gaya_OrderImmediate,Condition(function Trig_Gaya_OrderImmediate_Conditions))
    call TriggerAddAction(gg_trg_Gaya_OrderImmediate,function Trig_Gaya_OrderImmediate_Actions)
endfunction

function Register_Gaya_OrderPoint takes nothing returns nothing
    set gg_trg_Gaya_OrderPoint=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_OrderPoint,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerAddCondition(gg_trg_Gaya_OrderPoint,Condition(function Trig_Gaya_OrderPoint_Conditions))
    call TriggerAddAction(gg_trg_Gaya_OrderPoint,function Trig_Gaya_OrderPoint_Actions)
endfunction

function Register_Gaya_OrderTarget takes nothing returns nothing
    set gg_trg_Gaya_OrderTarget=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_OrderTarget,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerAddCondition(gg_trg_Gaya_OrderTarget,Condition(function Trig_Gaya_OrderTarget_Conditions))
    call TriggerAddAction(gg_trg_Gaya_OrderTarget,function Trig_Gaya_OrderTarget_Actions)
endfunction

endlibrary
