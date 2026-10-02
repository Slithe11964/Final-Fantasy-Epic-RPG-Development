library TLink
function Link_SaveCaster takes unit u,unit targetUnit,real l_maxRange returns nothing
    call SaveUnitHandle(udg_LinkedCasterHash,GetHandleId(targetUnit),1,u)
    call SaveReal(udg_LinkedCasterHash,GetHandleId(targetUnit),2,l_maxRange)
    set u=null
    set targetUnit=null
endfunction

function InitTrig_Link takes nothing returns nothing
endfunction

endlibrary
