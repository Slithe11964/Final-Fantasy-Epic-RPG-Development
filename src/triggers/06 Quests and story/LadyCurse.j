library TLadyCurse
// Lady Curse: her "Annoying Monster" quest (module Quest_AnnoyingMonster) becomes available when QuestCount
// runs gg_trg_LadyCurse_ShowMarker.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_LadyCurse_ShowMarker=null
endglobals

function Trig_LadyCurse_ShowMarker_Actions takes nothing returns nothing
    static if LIBRARY_TQuestAnnoyingMonster then
        call ExecuteFunc("QuestAnnoyingMonster_Available") // the "!" over Lady Curse; the Annoying Monster quest can start
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_LadyCurse automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_LadyCurse (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_LadyCurse takes nothing returns nothing
endfunction

function Register_LadyCurse_ShowMarker takes nothing returns nothing
    set gg_trg_LadyCurse_ShowMarker=CreateTrigger()
    call DisableTrigger(gg_trg_LadyCurse_ShowMarker)
    call TriggerAddAction(gg_trg_LadyCurse_ShowMarker,function Trig_LadyCurse_ShowMarker_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_LadyCurse takes nothing returns nothing
    call Register_LadyCurse_ShowMarker() // starts off; run by QuestCount
endfunction

endlibrary
