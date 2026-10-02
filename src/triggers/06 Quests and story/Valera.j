library TValera
function Trig_Valera_ShowMarker_Actions takes nothing returns nothing
    set udg_SpecialEffect[44]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n01R_0081,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_WolfFangs_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Valera takes nothing returns nothing
endfunction

function RegisterR11_Valera_ShowMarker takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Valera_ShowMarker=CreateTrigger()

call DisableTrigger(gg_trg_Valera_ShowMarker)

call TriggerAddAction(gg_trg_Valera_ShowMarker,function Trig_Valera_ShowMarker_Actions)

endfunction




endlibrary
