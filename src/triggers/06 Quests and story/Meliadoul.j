library TMeliadoul
function Trig_Meliadoul_Hint_Timer_QuestNotDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[$D])==false) // $D = 13
endfunction

function Trig_Meliadoul_Hint_Timer_Actions takes nothing returns nothing
    if(Trig_Meliadoul_Hint_Timer_QuestNotDiscovered())then
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffMeliadoul has something to tell you !!!|r")
        set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hvwd_0098,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_Quest_CorruptedOrcs_Start)
    else
        call DestroyTrigger(gg_trg_Quest_CorruptedOrcs_Start)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Meliadoul takes nothing returns nothing
endfunction
function RegisterR11_Meliadoul_Hint_Timer takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Meliadoul_Hint_Timer=CreateTrigger()
    call DisableTrigger(gg_trg_Meliadoul_Hint_Timer)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Meliadoul_Hint_Timer,udg_SiegeTimer)
    call TriggerAddAction(gg_trg_Meliadoul_Hint_Timer,function Trig_Meliadoul_Hint_Timer_Actions)
endfunction




endlibrary
