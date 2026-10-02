library TAnabel
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Anabel_Appear=null
endglobals

function Trig_Anabel_Appear_Actions takes nothing returns nothing
    set udg_SeaKingQuestStarted=true
    call RemoveItemFromStockBJ('I0HB',gg_unit_n02Y_0052) // 'I0HB': item "Information: Fishing"
    call SetUnitFacingTimed(gg_unit_n0AV_0247,270.,.2)
    set udg_SpecialEffect[68]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0AV_0247,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_NebraAngler_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Anabel automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Anabel (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Anabel takes nothing returns nothing
endfunction

function Register_Anabel_Appear takes nothing returns nothing
    set gg_trg_Anabel_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_Anabel_Appear)
    call TriggerAddAction(gg_trg_Anabel_Appear,function Trig_Anabel_Appear_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Anabel takes nothing returns nothing
    call Register_Anabel_Appear() // starts off; run by Fishing_ReelingAndCatch
endfunction

endlibrary
