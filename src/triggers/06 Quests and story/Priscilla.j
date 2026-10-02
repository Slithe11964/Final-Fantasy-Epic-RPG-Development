library TPriscilla
function Trig_Priscilla_Setup_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_n023_0121)
    call PauseUnitBJ(true,gg_unit_n023_0121)
    call SetUnitInvulnerable(gg_unit_n023_0121,true)
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_u007_0128,"Abilities\\Spells\\Human\\ManaShield\\ManaShieldCaster.mdl")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Priscilla_ShowMarker_Actions takes nothing returns nothing
    set udg_SpecialEffect[47]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u007_0128,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_SpiritOfWater_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Priscilla_ShowMarker_Eden_Actions takes nothing returns nothing
    set udg_SpecialEffect[51]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u007_0128,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_StrongestEidolon_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Priscilla automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Priscilla (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Priscilla takes nothing returns nothing
endfunction

function Register_Priscilla_Setup takes nothing returns nothing
    set gg_trg_Priscilla_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_Priscilla_Setup,function Trig_Priscilla_Setup_Actions)
endfunction

function Register_Priscilla_ShowMarker takes nothing returns nothing
    set gg_trg_Priscilla_ShowMarker=CreateTrigger()
    call DisableTrigger(gg_trg_Priscilla_ShowMarker)
    call TriggerAddAction(gg_trg_Priscilla_ShowMarker,function Trig_Priscilla_ShowMarker_Actions)
endfunction

function Register_Priscilla_ShowMarker_Eden takes nothing returns nothing
    set gg_trg_Priscilla_ShowMarker_Eden=CreateTrigger()
    call DisableTrigger(gg_trg_Priscilla_ShowMarker_Eden)
    call TriggerAddAction(gg_trg_Priscilla_ShowMarker_Eden,function Trig_Priscilla_ShowMarker_Eden_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Priscilla takes nothing returns nothing
    call Register_Priscilla_Setup()
    call Register_Priscilla_ShowMarker()
    call Register_Priscilla_ShowMarker_Eden()
endfunction

endlibrary
