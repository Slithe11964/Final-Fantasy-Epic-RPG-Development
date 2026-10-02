library TQuestLog requires TTime
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Log_Update=null
endglobals

function Trig_Quest_Log_Update_Actions takes nothing returns nothing
    local string l_elapsed=Time_ElapsedString()
    // (udg_Difficulty) plus (6).
    call QuestItemSetDescription(udg_InfoQuestItem[1],(udg_ColorCyan+"Difficulty|r: "+udg_VoteOptionText[udg_Difficulty+6]))
    // (GetPlayerHandicap(Player(11))) times (100).
    call QuestItemSetDescription(udg_InfoQuestItem[2],(udg_ColorCyan+"Enemy Handicap|r: "+udg_ColorGreen+R2S(GetPlayerHandicap(Player($B))*'d')+"|r")) // $B = 11
    call QuestItemSetDescription(udg_InfoQuestItem[3],(udg_ColorCyan+"Quests Completed|r: "+udg_ColorOrange+I2S(udg_QuestsCompleted)+"|r/"+udg_ColorGreen+I2S(udg_QuestsTotal)+"|r"))
    // (StringLength(elapsed time)) minus (3).
    call QuestItemSetDescription(udg_InfoQuestItem[4],(udg_ColorCyan+"Time Played|r: "+udg_ColorOrange+SubString(l_elapsed,0,StringLength(l_elapsed)-3)+"|r"))
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Quest_Log takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part1 (module Quest),
// which keeps the original registration order.

function Register_Quest_Log_Update takes nothing returns nothing
    set gg_trg_Quest_Log_Update=CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_Quest_Log_Update,4.,true)
    call TriggerAddAction(gg_trg_Quest_Log_Update,function Trig_Quest_Log_Update_Actions)
endfunction

endlibrary
