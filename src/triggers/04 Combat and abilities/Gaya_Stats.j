library TGayaStats
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Gaya_RefreshStats=null
endglobals

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

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Gaya (module Gaya),
// which keeps the original registration order.

function Register_Gaya_RefreshStats takes nothing returns nothing
    set gg_trg_Gaya_RefreshStats=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Gaya_RefreshStats,udg_LoadRefreshTimer)
    call TriggerAddAction(gg_trg_Gaya_RefreshStats,function Trig_Gaya_RefreshStats_Actions)
endfunction

endlibrary
