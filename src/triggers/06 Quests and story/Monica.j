library TMonica
function Trig_Monica_ShowMarker_Actions takes nothing returns nothing
    set udg_SpecialEffect[72]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BW_0094,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_OgreHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Monica takes nothing returns nothing
endfunction

function RegisterR11_Monica_ShowMarker takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Monica_ShowMarker=CreateTrigger()

call DisableTrigger(gg_trg_Monica_ShowMarker)

call TriggerAddAction(gg_trg_Monica_ShowMarker,function Trig_Monica_ShowMarker_Actions)

endfunction




endlibrary
