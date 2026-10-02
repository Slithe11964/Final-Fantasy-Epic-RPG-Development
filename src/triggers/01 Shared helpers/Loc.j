library TLoc
function Loc_PolarOffset takes location l_loc,real distance,real angle returns location
    // Move from the starting point by the requested distance and angle.
    // Cosine gives the left/right part; sine gives the up/down part. DEGTORAD converts degrees for those functions.
    return Location(GetLocationX(l_loc)+distance*Cos(angle*bj_DEGTORAD),GetLocationY(l_loc)+distance*Sin(angle*bj_DEGTORAD))
endfunction

function InitTrig_Loc takes nothing returns nothing
endfunction

endlibrary
