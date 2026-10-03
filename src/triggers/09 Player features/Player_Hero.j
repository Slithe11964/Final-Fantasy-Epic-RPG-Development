library TPlayerHero
// Player

function Player_GetHero takes player l_p returns unit
    return udg_PlayerHero[GetPlayerId(l_p)+1]
endfunction

function InitTrig_Player_Hero takes nothing returns nothing
endfunction

endlibrary
