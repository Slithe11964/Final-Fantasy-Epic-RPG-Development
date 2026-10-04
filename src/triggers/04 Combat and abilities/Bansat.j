library TBansat requires optional TAdamantHunt
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Bansat_ShowTalkIcon=null
endglobals

function Trig_Bansat_ShowTalkIcon_Actions takes nothing returns nothing
    static if LIBRARY_TAdamantHunt then
        call ExecuteFunc("AdamantHunt_Available") // the "!" over Bansat; the Adamant Hunt quest can start
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Bansat automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Bansat (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Bansat takes nothing returns nothing
endfunction

function Register_Bansat_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Bansat_ShowTalkIcon=CreateTrigger()
    call TriggerAddAction(gg_trg_Bansat_ShowTalkIcon,function Trig_Bansat_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Bansat takes nothing returns nothing
    call Register_Bansat_ShowTalkIcon() // run by MapBootstrap
endfunction

endlibrary
