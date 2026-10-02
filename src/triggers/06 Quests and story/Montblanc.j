library TMontblanc
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Montblanc_Hint_Timer=null
endglobals

function Trig_Montblanc_Hint_Timer_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[62]))and(IsQuestCompleted(udg_SideQuest[63]))and(udg_MontblancHasNews==false)
endfunction

function Trig_Montblanc_Hint_Timer_HuntStillOpen takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[61])==false)and(IsQuestFailed(udg_SideQuest[61])==false)
endfunction

function Trig_Montblanc_Hint_Timer_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Montblanc_Hint_Timer_HuntStillOpen())then
        call DestroyEffectBJ(udg_SpecialEffect[82])
    endif
    set udg_MontblancHasNews=true
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffMontblanc has something to tell you !!|r")
    set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_GodDragon_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Montblanc automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Montblanc (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Montblanc takes nothing returns nothing
endfunction

function Register_Montblanc_Hint_Timer takes nothing returns nothing
    set gg_trg_Montblanc_Hint_Timer=CreateTrigger()
    call DisableTrigger(gg_trg_Montblanc_Hint_Timer)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Montblanc_Hint_Timer,20.)
    call TriggerAddCondition(gg_trg_Montblanc_Hint_Timer,Condition(function Trig_Montblanc_Hint_Timer_Conditions))
    call TriggerAddAction(gg_trg_Montblanc_Hint_Timer,function Trig_Montblanc_Hint_Timer_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Montblanc takes nothing returns nothing
    call Register_Montblanc_Hint_Timer()
endfunction

endlibrary
