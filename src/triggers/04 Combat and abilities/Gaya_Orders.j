library TGayaOrders requires TItemShared
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
    // (GetIssuedOrderId()) minus (852008).
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
    // (GetIssuedOrderId()) minus (852008).
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
    // (GetIssuedOrderId()) minus (852008).
    call Item_UseFromOtherUnit(GetTriggerUnit(),(GetIssuedOrderId()-$D0028),2) // $D0028 = 852008
endfunction

function InitTrig_Gaya_Orders takes nothing returns nothing
endfunction

endlibrary
