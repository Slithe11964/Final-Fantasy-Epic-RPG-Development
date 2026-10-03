library TMelaniya requires TGroup, optional TQuestGreedIsGood
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Melaniya_Setup=null
endglobals

function Trig_Melaniya_Setup_Enum_HideGuard takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    call PauseUnitBJ(true,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),true)
endfunction

function Trig_Melaniya_Setup_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("chest",gg_unit_n01S_0082,"Abilities\\Spells\\Undead\\AntiMagicShell\\AntiMagicShell.mdl")
    static if LIBRARY_TQuestGreedIsGood then
        call ExecuteFunc("QuestGreedIsGood_Available") // the "!" over Melaniya; the Greed is Good quest can start
    endif
    set udg_HideoutGuards=Group_UnitsInRectOfPlayer(gg_rct_404,Player($B)) // $B = 11
    call ForGroupBJ(udg_HideoutGuards,function Trig_Melaniya_Setup_Enum_HideGuard)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Melaniya automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Melaniya (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Melaniya takes nothing returns nothing
endfunction

function Register_Melaniya_Setup takes nothing returns nothing
    set gg_trg_Melaniya_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_Melaniya_Setup,function Trig_Melaniya_Setup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Melaniya takes nothing returns nothing
    call Register_Melaniya_Setup() // run by MapBootstrap
endfunction

endlibrary
