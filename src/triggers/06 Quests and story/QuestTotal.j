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

// World Editor calls InitTrig_QuestTotal automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_QuestTotal (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_QuestTotal takes nothing returns nothing
endfunction

function Register_QuestTotal_Add takes nothing returns nothing
    set gg_trg_QuestTotal_Add=CreateTrigger()
    call TriggerAddAction(gg_trg_QuestTotal_Add,function Trig_QuestTotal_Add_Actions)
endfunction

function Register_QuestTotal_Add71 takes nothing returns nothing
    set gg_trg_QuestTotal_Add71=CreateTrigger()
    call TriggerAddAction(gg_trg_QuestTotal_Add71,function Trig_QuestTotal_Add71_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_QuestTotal takes nothing returns nothing
    call Register_QuestTotal_Add()
    call Register_QuestTotal_Add71()
endfunction

endlibrary
