library TQuestWorldLiberation requires TQuestEngine, TPlayerHero, TReward
// Main quest "World Liberation" (udg_MainQuest[8]), written for the quest engine (QuestEngine module,
// docs/QUEST_ENGINE.md). After Zalera falls, the party must defeat all 12 Zodiac Braves. Boss_Zalera starts
// it (through QuestWorldLiberation_Start); every Zodiac Brave's death runs gg_trg_Quest_WorldLiberation_Count,
// which updates the "Zodiac Braves defeated" line (udg_QuestReq[4]) and finishes the quest at 12.
// The reward follows 6 seconds later (gg_trg_Quest_WorldLiberation_Reward). Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_WorldLiberation_Count=null
    trigger gg_trg_Quest_WorldLiberation_Reward=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_WORLD_LIBERATION=0
endglobals

function QuestWorldLiberation_Define takes nothing returns nothing
    local integer q=Quest_Define("World Liberation",QUEST_MAIN,8,"ReplaceableTextures\\CommandButtons\\BTNArchimonde.blp")
    set QUEST_WORLD_LIBERATION=q
    call Quest_Color(q,udg_QuestTitleColor)
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Zalera falls (Boss_Zalera_Death)
    call Quest_Custom(q,"The war against the 12 Zodiac Braves has begun! Return Gaya to the hands of humans and night elves and destroy the demonic usurpers.")
    // 2. All 12 Zodiac Braves are defeated (gg_trg_Quest_WorldLiberation_Count)
    call Quest_Custom(q,"")
endfunction

// The quest starts, with its "Zodiac Braves defeated" line (called by Boss_Zalera_Death through ExecuteFunc).
function QuestWorldLiberation_Start takes nothing returns nothing
    if QUEST_WORLD_LIBERATION==0 then
        call QuestWorldLiberation_Define()
    endif
    call Quest_Start(QUEST_WORLD_LIBERATION,null,null)
    set udg_QuestReq[4]=CreateQuestItemBJ(Quest_LogEntry(QUEST_WORLD_LIBERATION),("Zodiac Braves defeated: "+(I2S(udg_BravesDefeated)+"/12")))
endfunction

function Trig_Quest_WorldLiberation_Count_StoneNotBroken takes nothing returns boolean
    return(udg_HashmalumStage<=0)
endfunction

function Trig_Quest_WorldLiberation_Count_HasBonusBrave takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[17]))
endfunction

function Trig_Quest_WorldLiberation_Count_IsSecretUnlocked takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[46]))
endfunction

function Trig_Quest_WorldLiberation_Count_AllBravesDefeated takes nothing returns boolean
    return(udg_BravesDefeated>=$C) // $C = 12
endfunction

function Trig_Quest_WorldLiberation_Count_HasLiberationQuest takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[8]))
endfunction

function Trig_Quest_WorldLiberation_Count_Actions takes nothing returns nothing
    set udg_BravesDefeated=(udg_BravesDefeated+1)
    if(Trig_Quest_WorldLiberation_Count_HasLiberationQuest())then
        if(Trig_Quest_WorldLiberation_Count_HasBonusBrave())then
            // (udg_BravesDefeated) plus (1).
            call QuestItemSetDescriptionBJ(udg_QuestReq[4],("Zodiac Braves defeated: "+(I2S((udg_BravesDefeated+1))+"/13")))
        else
            call QuestItemSetDescriptionBJ(udg_QuestReq[4],("Zodiac Braves defeated: "+(I2S(udg_BravesDefeated)+"/12")))
        endif
        if(Trig_Quest_WorldLiberation_Count_AllBravesDefeated())then
            if Quest_IsActive(QUEST_WORLD_LIBERATION) then
                call Quest_StepDone(QUEST_WORLD_LIBERATION,null,null)
            else
                // not on the engine: either Zalera never fell, so "World Liberation" never started and
                // udg_MainQuest[8] is the "True Ice Age" entry (TrueIceAge), or another Zodiac Brave fell
                // after the quest was done. The entry is completed and counted here, as before.
                call QuestSetCompletedBJ(udg_MainQuest[8],true)
                set udg_QuestsCompleted=(udg_QuestsCompleted+1)
            endif
            call ConditionalTriggerExecute(gg_trg_ShinrasPlan_Prepare)
            if(Trig_Quest_WorldLiberation_Count_IsSecretUnlocked())then
                call SetUnitInvulnerable(gg_unit_N022_0125,false)
                call PauseUnitBJ(false,gg_unit_N022_0125)
                call ShowUnitShow(gg_unit_N022_0125)
            endif
            call StartTimerBJ(udg_LiberationRewardTimer,false,6.)
        endif
    else
        if(Trig_Quest_WorldLiberation_Count_StoneNotBroken())then
            call ConditionalTriggerExecute(gg_trg_Cine_StoneBreaks_Alt)
        endif
    endif
endfunction

function Trig_Quest_WorldLiberation_Reward_GiveCelestium takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    call CreateItemLoc('I0LL',l_tempPoint) // 'I0LL': item "Celestium"
    call RemoveLocation(l_tempPoint)
    call SetItemUserData(GetLastCreatedItem(),GetConvertedPlayerId(GetEnumPlayer()))
    call UnitAddItemSwapped(GetLastCreatedItem(),Player_GetHero(GetEnumPlayer()))
    set l_tempPoint=null
endfunction

function Trig_Quest_WorldLiberation_Reward_NeedsAchievement takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[43])==false)
endfunction

function Trig_Quest_WorldLiberation_Reward_GrantAchievement takes nothing returns nothing
    if(Trig_Quest_WorldLiberation_Reward_NeedsAchievement())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=43
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Quest_WorldLiberation_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if not Quest_IsDone(QUEST_WORLD_LIBERATION) then
        // the engine already announced it when the quest was done (see Count)
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00World Liberation|r")
    endif
    call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00All players get 10000 exp and Celestium.|r")
    call Reward_Give(0,$2710,null) // $2710 = 10000
    call ForForce(udg_PlayingPlayers,function Trig_Quest_WorldLiberation_Reward_GiveCelestium)
    call ForForce(udg_PlayingPlayers,function Trig_Quest_WorldLiberation_Reward_GrantAchievement)
    call AddUnitToStockBJ('n0BG',gg_unit_nsw2_0056,1,1) // 'n0BG': unit "Hunt: Vercingetorix"
    set udg_HuntStock[$A]=(udg_HuntStock[$A]+1) // $A = 10
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_WorldLiberation takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part4 (module Quest),
// which keeps the original registration order.

function Register_Quest_WorldLiberation_Count takes nothing returns nothing
    set gg_trg_Quest_WorldLiberation_Count=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_WorldLiberation_Count)
    call TriggerAddAction(gg_trg_Quest_WorldLiberation_Count,function Trig_Quest_WorldLiberation_Count_Actions)
endfunction

function Register_Quest_WorldLiberation_Reward takes nothing returns nothing
    set gg_trg_Quest_WorldLiberation_Reward=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Quest_WorldLiberation_Reward,udg_LiberationRewardTimer)
    call TriggerAddAction(gg_trg_Quest_WorldLiberation_Reward,function Trig_Quest_WorldLiberation_Reward_Actions)
endfunction

endlibrary
