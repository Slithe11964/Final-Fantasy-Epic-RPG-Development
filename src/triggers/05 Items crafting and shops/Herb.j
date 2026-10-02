library THerb
function Trig_Herb_Spawn_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call StartTimerBJ(udg_HerbRespawnTimer[0],false,1.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Herb takes nothing returns nothing
endfunction
function RegisterR11_Herb_Spawn_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Herb_Spawn_Start=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Herb_Spawn_Start,10.)
    call TriggerAddAction(gg_trg_Herb_Spawn_Start,function Trig_Herb_Spawn_Start_Actions)
endfunction




endlibrary
