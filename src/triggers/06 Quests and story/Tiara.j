library TTiara
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Tiara_Ping=null
endglobals

function Trig_Tiara_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[22]!=null)
endfunction

function Trig_Tiara_Ping_Cond_TiaraCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[22]))
endfunction

function Trig_Tiara_Ping_Actions takes nothing returns nothing
    if(Trig_Tiara_Ping_Cond_TiaraCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_u007_0128)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[22])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

// World Editor calls InitTrig_Tiara automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Tiara (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Tiara takes nothing returns nothing
endfunction

function Register_Tiara_Ping takes nothing returns nothing
    set gg_trg_Tiara_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Tiara_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Tiara_Ping,15.)
    call TriggerAddCondition(gg_trg_Tiara_Ping,Condition(function Trig_Tiara_Ping_Conditions))
    call TriggerAddAction(gg_trg_Tiara_Ping,function Trig_Tiara_Ping_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Tiara takes nothing returns nothing
    call Register_Tiara_Ping() // starts off; enabled by Vodyan; disabled by Quest_SpiritOfWater
endfunction

endlibrary
