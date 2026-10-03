library TKiros requires optional TGnollHunt
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Kiros_Hide=null
    trigger gg_trg_Kiros_ShowTalkIcon=null
endglobals

function Trig_Kiros_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_n0BV_0229)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Kiros_ShowTalkIcon_Actions takes nothing returns nothing
    static if LIBRARY_TGnollHunt then
        call ExecuteFunc("GnollHunt_Available") // the "!" over Kiros; the Gnoll Hunt quest can start
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Kiros automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Kiros (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Kiros takes nothing returns nothing
endfunction

function Register_Kiros_Hide takes nothing returns nothing
    set gg_trg_Kiros_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_Kiros_Hide,function Trig_Kiros_Hide_Actions)
endfunction

function Register_Kiros_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Kiros_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Kiros_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Kiros_ShowTalkIcon,function Trig_Kiros_ShowTalkIcon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Kiros takes nothing returns nothing
    call Register_Kiros_Hide() // run by MapBootstrap
    call Register_Kiros_ShowTalkIcon() // starts off; run by Quest_SaveTimmy
endfunction

endlibrary
