library TClemydar
function Trig_Clemydar_ShowMarker_Actions takes nothing returns nothing
    set udg_SpecialEffect[83]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nemi_0078,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_SeekDestroy_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Clemydar takes nothing returns nothing
endfunction

function RegisterR11_Clemydar_ShowMarker takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Clemydar_ShowMarker=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Clemydar_ShowMarker,12.)

call TriggerAddAction(gg_trg_Clemydar_ShowMarker,function Trig_Clemydar_ShowMarker_Actions)

endfunction




endlibrary
