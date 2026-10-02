library TForce
globals
    // Variables only this module uses.
    force udg_EnumForce=null
endglobals

function Force_OfPlayer takes player l_owner returns force
    set udg_EnumForce=CreateForce()
    call ForceAddPlayer(udg_EnumForce,l_owner)
    return udg_EnumForce
endfunction

function Force_Matching takes boolexpr l_filter returns force
    set udg_EnumForce=CreateForce()
    call ForceEnumPlayers(udg_EnumForce,l_filter)
    call DestroyBoolExpr(l_filter)
    return udg_EnumForce
endfunction

function InitTrig_Force takes nothing returns nothing
endfunction

endlibrary
