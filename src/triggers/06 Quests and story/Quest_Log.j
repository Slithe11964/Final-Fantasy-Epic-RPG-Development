library TQuestLog requires TTime
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

endlibrary
