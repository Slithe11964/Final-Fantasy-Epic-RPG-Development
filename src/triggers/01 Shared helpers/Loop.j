library TLoop
function Trig_Loop_MadoushiChanneling_ShouldStopChanneling takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[18]))
endfunction

function Trig_Loop_MadoushiChanneling_Actions takes nothing returns nothing
    if(Trig_Loop_MadoushiChanneling_ShouldStopChanneling())then
        call DisableTrigger(GetTriggeringTrigger())
        call DestroyEffectBJ(udg_SpecialEffect[55])
        call DestroyEffectBJ(udg_SpecialEffect[56])
        call ResetUnitAnimation(gg_unit_Othr_0106)
    else
        call SetUnitAnimation(gg_unit_Othr_0106,"spell")
    endif
endfunction

// World Editor calls InitTrig_Loop automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Loop (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Loop takes nothing returns nothing
endfunction

function Register_Loop_MadoushiChanneling takes nothing returns nothing
    set gg_trg_Loop_MadoushiChanneling=CreateTrigger()
    call DisableTrigger(gg_trg_Loop_MadoushiChanneling)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Loop_MadoushiChanneling,2.7)
    call TriggerAddAction(gg_trg_Loop_MadoushiChanneling,function Trig_Loop_MadoushiChanneling_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Loop takes nothing returns nothing
    call Register_Loop_MadoushiChanneling()
endfunction

endlibrary
