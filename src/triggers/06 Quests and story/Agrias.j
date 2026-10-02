library TAgrias
function Trig_Agrias_ShowMarker_Actions takes nothing returns nothing
    call ShowUnitShow(gg_unit_Ewrd_0120)
    set udg_SpecialEffect[50]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ewrd_0120,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_HolyKnight_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Agrias takes nothing returns nothing
endfunction

function RegisterR11_Agrias_ShowMarker takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Agrias_ShowMarker=CreateTrigger()

call DisableTrigger(gg_trg_Agrias_ShowMarker)

call TriggerAddAction(gg_trg_Agrias_ShowMarker,function Trig_Agrias_ShowMarker_Actions)

endfunction




endlibrary
