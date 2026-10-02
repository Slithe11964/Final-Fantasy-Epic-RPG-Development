library TShinra
function Trig_Shinra_TalkPrepare_Actions takes nothing returns nothing
    set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_DimensionalBoundary_Start)
    call AddItemToStockBJ('I08Q',gg_unit_n02Y_0052,1,1) // 'I08Q': item "Information: Al Bhed Child"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Shinra automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Shinra (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Shinra takes nothing returns nothing
endfunction

function Register_Shinra_TalkPrepare takes nothing returns nothing
    set gg_trg_Shinra_TalkPrepare=CreateTrigger()
    call DisableTrigger(gg_trg_Shinra_TalkPrepare)
    call TriggerAddAction(gg_trg_Shinra_TalkPrepare,function Trig_Shinra_TalkPrepare_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Shinra takes nothing returns nothing
    call Register_Shinra_TalkPrepare()
endfunction

endlibrary
