library TClemydar requires optional TQuestSeekDestroy
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Clemydar_ShowMarker=null
endglobals

function Trig_Clemydar_ShowMarker_Actions takes nothing returns nothing
    static if LIBRARY_TQuestSeekDestroy then
        call ExecuteFunc("QuestSeekDestroy_Available") // the "!" over Clemydar; Seek and Destroy can start
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Clemydar automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Clemydar (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Clemydar takes nothing returns nothing
endfunction

function Register_Clemydar_ShowMarker takes nothing returns nothing
    set gg_trg_Clemydar_ShowMarker=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Clemydar_ShowMarker,12.)
    call TriggerAddAction(gg_trg_Clemydar_ShowMarker,function Trig_Clemydar_ShowMarker_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Clemydar takes nothing returns nothing
    call Register_Clemydar_ShowMarker()
endfunction

endlibrary
