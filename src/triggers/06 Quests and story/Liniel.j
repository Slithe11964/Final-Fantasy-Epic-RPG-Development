library TLiniel
function Trig_Liniel_ShowMarker_Actions takes nothing returns nothing
    set udg_SpecialEffect[46]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n01Y_0131,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_FallenRanger_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Liniel takes nothing returns nothing
endfunction

function RegisterR11_Liniel_ShowMarker takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Liniel_ShowMarker=CreateTrigger()

call DisableTrigger(gg_trg_Liniel_ShowMarker)

call TriggerAddAction(gg_trg_Liniel_ShowMarker,function Trig_Liniel_ShowMarker_Actions)

endfunction




endlibrary
