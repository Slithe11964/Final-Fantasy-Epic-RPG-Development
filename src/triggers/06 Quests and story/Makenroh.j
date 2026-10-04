library TMakenroh requires TCam, TCine, TText, TUnit, optional TDragonHunt
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Makenroh_Greet=null
    trigger gg_trg_Makenroh_ShowTalkIcon=null
endglobals

function Trig_Makenroh_Greet_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h032_0007,true,true,true))
endfunction

function Trig_Makenroh_Greet_NotInCinematic takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Makenroh_Greet_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[84])
    if(Trig_Makenroh_Greet_NotInCinematic())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h032_0007,"I see Montblanc officially welcomed you to our Hunt Club. Allow me to welcome you as well.",false)
        call Text_Say(gg_unit_h032_0007,"My name is Ma'kenroh. I am not a fighter myself, but I support the club with my wisdom and trading.",false)
        call Text_Say(gg_unit_h032_0007,"We are willing and glad to support active contributors to our club. Come speak to me at times, depending on your contributions I'll be offering you with some good gear or items.",false)
        call Text_Say(gg_unit_h032_0007,"Happy hunting!",false)
        call Cine_ExitAction()
    endif
    call UnitAddAbilityBJ('Aneu',gg_unit_h032_0007) // 'Aneu': standard ability reference "Neutral Building"
    call EnableTrigger(gg_trg_Makenroh_ShowTalkIcon)
    call EnableTrigger(gg_trg_Hunt_Shop_Unlock)
    call ConditionalTriggerExecute(gg_trg_Hunt_Shop_Unlock)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Makenroh_ShowTalkIcon_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[9]))and(udg_CommonHuntsDone>=6)and(udg_RareHuntsDone>=$A) // $A = 10
endfunction

function Trig_Makenroh_ShowTalkIcon_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    static if LIBRARY_TDragonHunt then
        call ExecuteFunc("DragonHunt_Available") // the "!" over Ma'kenroh; the Dragon Hunt quest can start
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Makenroh automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Makenroh_Part1 / RegisterTriggers_Makenroh_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Makenroh takes nothing returns nothing
endfunction

function Register_Makenroh_Greet takes nothing returns nothing
    set gg_trg_Makenroh_Greet=CreateTrigger()
    call DisableTrigger(gg_trg_Makenroh_Greet)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Makenroh_Greet,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Makenroh_Greet,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Makenroh_Greet,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Makenroh_Greet,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Makenroh_Greet,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Makenroh_Greet,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Makenroh_Greet,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Makenroh_Greet,Player(7),true)
    call TriggerAddCondition(gg_trg_Makenroh_Greet,Condition(function Trig_Makenroh_Greet_Conditions))
    call TriggerAddAction(gg_trg_Makenroh_Greet,function Trig_Makenroh_Greet_Actions)
endfunction

function Register_Makenroh_ShowTalkIcon takes nothing returns nothing
    set gg_trg_Makenroh_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Makenroh_ShowTalkIcon)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Makenroh_ShowTalkIcon,20.)
    call TriggerAddCondition(gg_trg_Makenroh_ShowTalkIcon,Condition(function Trig_Makenroh_ShowTalkIcon_Conditions))
    call TriggerAddAction(gg_trg_Makenroh_ShowTalkIcon,function Trig_Makenroh_ShowTalkIcon_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Makenroh_Part1 takes nothing returns nothing
    call Register_Makenroh_Greet() // starts off; enabled by Cartographer
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Makenroh_Part2 takes nothing returns nothing
    call Register_Makenroh_ShowTalkIcon() // starts off; enabled by Makenroh
endfunction

endlibrary
