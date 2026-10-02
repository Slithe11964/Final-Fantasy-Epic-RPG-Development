library TPlayerPart01
// Player

function Player_GetHero takes player l_p returns unit
    // (GetPlayerId(l_p)) plus (1).
    return udg_PlayerHero[GetPlayerId(l_p)+1]
endfunction

function InitTrig_Player_Part01 takes nothing returns nothing
endfunction

endlibrary
