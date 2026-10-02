library TMeliadoul
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Meliadoul_Hint_Timer=null
endglobals

function Trig_Meliadoul_Hint_Timer_QuestNotDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[$D])==false) // $D = 13
endfunction

function Trig_Meliadoul_Hint_Timer_Actions takes nothing returns nothing
    if(Trig_Meliadoul_Hint_Timer_QuestNotDiscovered())then
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffMeliadoul has something to tell you !!!|r")
        set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_Quest_CorruptedOrcs_Start)
    else
        call DestroyTrigger(gg_trg_Quest_CorruptedOrcs_Start)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Meliadoul automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Meliadoul (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Meliadoul takes nothing returns nothing
endfunction

function Register_Meliadoul_Hint_Timer takes nothing returns nothing
    set gg_trg_Meliadoul_Hint_Timer=CreateTrigger()
    call DisableTrigger(gg_trg_Meliadoul_Hint_Timer)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Meliadoul_Hint_Timer,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_Meliadoul_Hint_Timer,function Trig_Meliadoul_Hint_Timer_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Meliadoul takes nothing returns nothing
    call Register_Meliadoul_Hint_Timer()
endfunction

endlibrary
