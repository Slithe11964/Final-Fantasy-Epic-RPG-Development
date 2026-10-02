library TQuestWorldLiberation requires TPlayerHero, TReward
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_WorldLiberation_Count=null
    trigger gg_trg_Quest_WorldLiberation_Reward=null
endglobals

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
            call QuestSetCompletedBJ(udg_MainQuest[8],true)
            set udg_QuestsCompleted=(udg_QuestsCompleted+1)
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
    set udg_TempPoint=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    call CreateItemLoc('I0LL',udg_TempPoint) // 'I0LL': item "Celestium"
    call RemoveLocation(udg_TempPoint)
    call SetItemUserData(GetLastCreatedItem(),GetConvertedPlayerId(GetEnumPlayer()))
    call UnitAddItemSwapped(GetLastCreatedItem(),Player_GetHero(GetEnumPlayer()))
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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00World Liberation|r")
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
