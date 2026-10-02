library TGayaStats
function Trig_Gaya_RefreshStats_Cond_ManaNearlyFull takes nothing returns boolean
    return(GetUnitStateSwap(UNIT_STATE_MANA,udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())])>990000.)
endfunction

function Trig_Gaya_RefreshStats_RefreshGayaStats takes nothing returns nothing
    call UnitRemoveBuffsExBJ(bj_BUFF_POLARITY_EITHER,bj_BUFF_RESIST_EITHER,udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],false,false)
    call BlzSetUnitMaxHP(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],$F4240) // $F4240 = 1000000
    call BlzSetUnitMaxMana(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],$F4240) // $F4240 = 1000000
    call SetUnitLifeBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],990000.)
    if(Trig_Gaya_RefreshStats_Cond_ManaNearlyFull())then
        call SetUnitManaBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],990000.)
    endif
endfunction

function Trig_Gaya_RefreshStats_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Gaya_RefreshStats_RefreshGayaStats)
    call StartTimerBJ(udg_LoadRefreshTimer,false,1.)
endfunction

function InitTrig_Gaya_Stats takes nothing returns nothing
endfunction

endlibrary
