library TValera requires optional TQuestWolfFangs
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Valera_ShowMarker=null
endglobals

function Trig_Valera_ShowMarker_Actions takes nothing returns nothing
    static if LIBRARY_TQuestWolfFangs then
        call ExecuteFunc("QuestWolfFangs_Available") // the "!" over Valera; the Wolf Fangs quest can start
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Valera automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Valera (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Valera takes nothing returns nothing
endfunction

function Register_Valera_ShowMarker takes nothing returns nothing
    set gg_trg_Valera_ShowMarker=CreateTrigger()
    call DisableTrigger(gg_trg_Valera_ShowMarker)
    call TriggerAddAction(gg_trg_Valera_ShowMarker,function Trig_Valera_ShowMarker_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Valera takes nothing returns nothing
    call Register_Valera_ShowMarker() // starts off; run by Cid, Mid
endfunction

endlibrary
