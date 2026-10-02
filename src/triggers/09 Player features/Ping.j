library TPing
function Trig_Ping_ArenaTarget_IsTargetHidden takes nothing returns boolean
    return(IsLocationMaskedToPlayer(udg_TempPoint,ForcePickRandomPlayer(udg_PlayingPlayers)))
endfunction

function Trig_Ping_ArenaTarget_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_373)
    if(Trig_Ping_ArenaTarget_IsTargetHidden())then
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=GetUnitLoc(gg_unit_h02T_0064)
    endif
    call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',80.,.0)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Ping_EyeOfJenova_Conditions takes nothing returns boolean
    return(udg_QuestItem[$B]!=null) // $B = 11
endfunction

function Trig_Ping_EyeOfJenova_IsEyeCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[$B])) // $B = 11
endfunction

function Trig_Ping_EyeOfJenova_Actions takes nothing returns nothing
    if(Trig_Ping_EyeOfJenova_IsEyeCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_Othr_0106)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[$B]) // $B = 11
    endif
    call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',80.,.0)
    call RemoveLocation(udg_TempPoint)
endfunction

// World Editor calls InitTrig_Ping automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ping (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ping takes nothing returns nothing
endfunction

function Register_Ping_ArenaTarget takes nothing returns nothing
    set gg_trg_Ping_ArenaTarget=CreateTrigger()
    call DisableTrigger(gg_trg_Ping_ArenaTarget)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Ping_ArenaTarget,15.)
    call TriggerAddAction(gg_trg_Ping_ArenaTarget,function Trig_Ping_ArenaTarget_Actions)
endfunction

function Register_Ping_EyeOfJenova takes nothing returns nothing
    set gg_trg_Ping_EyeOfJenova=CreateTrigger()
    call DisableTrigger(gg_trg_Ping_EyeOfJenova)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Ping_EyeOfJenova,15.)
    call TriggerAddCondition(gg_trg_Ping_EyeOfJenova,Condition(function Trig_Ping_EyeOfJenova_Conditions))
    call TriggerAddAction(gg_trg_Ping_EyeOfJenova,function Trig_Ping_EyeOfJenova_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ping takes nothing returns nothing
    call Register_Ping_ArenaTarget()
    call Register_Ping_EyeOfJenova()
endfunction

endlibrary
