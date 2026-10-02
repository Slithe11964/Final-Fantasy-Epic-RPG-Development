library TGraves
function Trig_Graves_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call EnableTrigger(gg_trg_Npc_Talk_Gravedigger)
    set udg_QuestMarkerEffect[27]=AddSpecialEffectTargetUnitBJ("head",gg_unit_nvl2_0266,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call SetDoodadAnimationRectBJ("show",'LOpg',gg_rct_648) // 'LOpg': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'ZPfw',gg_rct_648) // 'ZPfw': object name not found in map data
    set udg_SecretDigSpotRevealed=true
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Graves automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Graves (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Graves takes nothing returns nothing
endfunction

function Register_Graves_Reveal takes nothing returns nothing
    set gg_trg_Graves_Reveal=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Graves_Reveal,udg_StoryDelayTimer)
    call TriggerAddAction(gg_trg_Graves_Reveal,function Trig_Graves_Reveal_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Graves takes nothing returns nothing
    call Register_Graves_Reveal()
endfunction

endlibrary
