library TFogCheat
function Trig_FogCheat_Reset_Actions takes nothing returns nothing
    set udg_FogDisabled=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_FogCheat takes nothing returns nothing
endfunction

function RegisterR11_FogCheat_Reset takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_FogCheat_Reset=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_FogCheat_Reset,5)

call TriggerAddAction(gg_trg_FogCheat_Reset,function Trig_FogCheat_Reset_Actions)

endfunction




endlibrary
