library TSeekers
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Seekers_TrackEngaged=null
endglobals

function Trig_Seekers_TrackEngaged_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SeekerLeaders))and(IsUnitInGroup(GetTriggerUnit(),udg_BossUnits)==false)
endfunction

function Trig_Seekers_TrackEngaged_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetTriggerUnit(),udg_BossUnits)
endfunction

// World Editor calls InitTrig_Seekers automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Seekers (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Seekers takes nothing returns nothing
endfunction

function Register_Seekers_TrackEngaged takes nothing returns nothing
    set gg_trg_Seekers_TrackEngaged=CreateTrigger()
    call DisableTrigger(gg_trg_Seekers_TrackEngaged)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Seekers_TrackEngaged,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Seekers_TrackEngaged,Condition(function Trig_Seekers_TrackEngaged_Conditions))
    call TriggerAddAction(gg_trg_Seekers_TrackEngaged,function Trig_Seekers_TrackEngaged_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Seekers takes nothing returns nothing
    call Register_Seekers_TrackEngaged()
endfunction

endlibrary
