library TMelaniya requires TGroup
function Trig_Melaniya_Setup_Enum_HideGuard takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    call PauseUnitBJ(true,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),true)
endfunction

function Trig_Melaniya_Setup_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("chest",gg_unit_n01S_0082,"Abilities\\Spells\\Undead\\AntiMagicShell\\AntiMagicShell.mdl")
    set udg_SpecialEffect[45]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n01S_0082,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
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
    call Register_Melaniya_Setup()
endfunction

endlibrary
