library TQuestTotal
function Trig_QuestTotal_Add_Actions takes nothing returns nothing
    // Increase udg_QuestsTotal by 19.
    set udg_QuestsTotal=(udg_QuestsTotal+19)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_QuestTotal_Add71_Actions takes nothing returns nothing
    // Increase udg_QuestsTotal by 71.
    set udg_QuestsTotal=(udg_QuestsTotal+71)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_QuestTotal takes nothing returns nothing
endfunction

function RegisterR11_QuestTotal_Add takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_QuestTotal_Add=CreateTrigger()

call TriggerAddAction(gg_trg_QuestTotal_Add,function Trig_QuestTotal_Add_Actions)

endfunction




function RegisterR11_QuestTotal_Add71 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_QuestTotal_Add71=CreateTrigger()

call TriggerAddAction(gg_trg_QuestTotal_Add71,function Trig_QuestTotal_Add71_Actions)

endfunction




endlibrary
