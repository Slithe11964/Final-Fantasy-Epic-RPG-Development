library TMonica requires optional TQuestOgreHunt
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Monica_ShowMarker=null
endglobals

function Trig_Monica_ShowMarker_Actions takes nothing returns nothing
    static if LIBRARY_TQuestOgreHunt then
        call ExecuteFunc("QuestOgreHunt_Available") // the "!" over Monica; the Ogre Hunt quest can start
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Monica automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Monica (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Monica takes nothing returns nothing
endfunction

function Register_Monica_ShowMarker takes nothing returns nothing
    set gg_trg_Monica_ShowMarker=CreateTrigger()
    call DisableTrigger(gg_trg_Monica_ShowMarker)
    call TriggerAddAction(gg_trg_Monica_ShowMarker,function Trig_Monica_ShowMarker_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Monica takes nothing returns nothing
    call Register_Monica_ShowMarker() // starts off; run by Cid, Epilogue
endfunction

endlibrary
