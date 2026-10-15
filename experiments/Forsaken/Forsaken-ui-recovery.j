library TForsakenUIRecovery requires TEquip, TBazaar
// Custom frame handles are presentation state, not part of the saved character.
globals
    trigger gg_trg_Forsaken_UIRecovery=null
endglobals

function ForsakenUI_Rebuild takes nothing returns nothing
    call ExecuteFunc("Forsaken_RebuildPanels")
    call ExecuteFunc("BazaarFrame_Rebuild")
    call DestroyTimer(GetExpiredTimer())
endfunction

function ForsakenUI_Loaded takes nothing returns nothing
    // Rebuild after Warcraft has finished restoring its native UI.
    call TimerStart(CreateTimer(),0.,false,function ForsakenUI_Rebuild)
endfunction

function InitTrig_ForsakenUIRecovery takes nothing returns nothing
    set gg_trg_Forsaken_UIRecovery=CreateTrigger()
    call TriggerRegisterGameEvent(gg_trg_Forsaken_UIRecovery,EVENT_GAME_LOADED)
    call TriggerAddAction(gg_trg_Forsaken_UIRecovery,function ForsakenUI_Loaded)
endfunction
endlibrary
