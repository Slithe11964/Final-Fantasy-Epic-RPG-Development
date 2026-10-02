library TNightElf
function Trig_NightElf_TalkPrepare_Conditions takes nothing returns boolean
    return(GetOwningPlayer(udg_ShadowUnit)==Player($A)) // $A = 10
endfunction

function Trig_NightElf_TalkPrepare_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_SpecialEffect[66]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e00V_0009,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_LostMemories_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_NightElf takes nothing returns nothing
endfunction

function RegisterR11_NightElf_TalkPrepare takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_NightElf_TalkPrepare=CreateTrigger()

call DisableTrigger(gg_trg_NightElf_TalkPrepare)

call TriggerRegisterTimerEventPeriodic(gg_trg_NightElf_TalkPrepare,5.)

call TriggerAddCondition(gg_trg_NightElf_TalkPrepare,Condition(function Trig_NightElf_TalkPrepare_Conditions))

call TriggerAddAction(gg_trg_NightElf_TalkPrepare,function Trig_NightElf_TalkPrepare_Actions)

endfunction




endlibrary
