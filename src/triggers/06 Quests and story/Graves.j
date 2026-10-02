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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Graves takes nothing returns nothing
endfunction

function RegisterR11_Graves_Reveal takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Graves_Reveal=CreateTrigger()

call TriggerRegisterTimerExpireEventBJ(gg_trg_Graves_Reveal,udg_StoryDelayTimer)

call TriggerAddAction(gg_trg_Graves_Reveal,function Trig_Graves_Reveal_Actions)

endfunction




endlibrary
