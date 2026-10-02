library TMontblanc
function Trig_Montblanc_Hint_Timer_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[62]))and(IsQuestCompleted(udg_SideQuest[63]))and(udg_MontblancHasNews==false)
endfunction

function Trig_Montblanc_Hint_Timer_HuntStillOpen takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[61])==false)and(IsQuestFailed(udg_SideQuest[61])==false)
endfunction

function Trig_Montblanc_Hint_Timer_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Montblanc_Hint_Timer_HuntStillOpen())then
        call DestroyEffectBJ(udg_SpecialEffect[82])
    endif
    set udg_MontblancHasNews=true
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffMontblanc has something to tell you !!|r")
    set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_GodDragon_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Montblanc takes nothing returns nothing
endfunction

function RegisterR11_Montblanc_Hint_Timer takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Montblanc_Hint_Timer=CreateTrigger()

call DisableTrigger(gg_trg_Montblanc_Hint_Timer)

call TriggerRegisterTimerEventPeriodic(gg_trg_Montblanc_Hint_Timer,20.)

call TriggerAddCondition(gg_trg_Montblanc_Hint_Timer,Condition(function Trig_Montblanc_Hint_Timer_Conditions))

call TriggerAddAction(gg_trg_Montblanc_Hint_Timer,function Trig_Montblanc_Hint_Timer_Actions)

endfunction




endlibrary
