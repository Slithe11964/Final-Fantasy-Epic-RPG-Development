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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Loop takes nothing returns nothing
endfunction

function RegisterR11_Loop_MadoushiChanneling takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Loop_MadoushiChanneling=CreateTrigger()

call DisableTrigger(gg_trg_Loop_MadoushiChanneling)

call TriggerRegisterTimerEventPeriodic(gg_trg_Loop_MadoushiChanneling,2.7)

call TriggerAddAction(gg_trg_Loop_MadoushiChanneling,function Trig_Loop_MadoushiChanneling_Actions)

endfunction




endlibrary
