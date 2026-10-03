library TVote requires TDifficulty, TForce, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Vote_TextSpeed_Show=null
    trigger gg_trg_Vote_TextSpeed_Click=null
    trigger gg_trg_Vote_TextSpeed_Result=null
    trigger gg_trg_Vote_Difficulty_Show=null
    trigger gg_trg_Vote_Difficulty_Click=null
    trigger gg_trg_Vote_Difficulty_Result=null
    trigger gg_trg_Vote_GameMode_Show=null
    trigger gg_trg_Vote_GameMode_Click=null
    // Variables only this module uses.
    button array udg_VoteButton
    real udg_VoteSum=0
endglobals

function Trig_Vote_TextSpeed_Show_IsMultiplayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Vote_TextSpeed_Show_ShowDialogToPlayer takes nothing returns nothing
    call DialogDisplayBJ(true,udg_VoteDialog,GetEnumPlayer())
endfunction

function Trig_Vote_TextSpeed_Show_Actions takes nothing returns nothing
    call SetUserControlForceOn(GetPlayersAll())
    call TimerDialogSetTitleBJ(udg_VoteTimerDialog,"Vote for Text Speed")
    call EnableTrigger(gg_trg_Vote_TextSpeed_Result)
    call DialogClearBJ(udg_VoteDialog)
    if(Trig_Vote_TextSpeed_Show_IsMultiplayer())then
        call DialogSetMessageBJ(udg_VoteDialog,"|cff4080ffVote for Text Speed|nduring Cinematics|r")
        call StartTimerBJ(udg_VoteTimer,false,20.)
        set udg_VoteTimerDialog=CreateTimerDialogBJ(udg_VoteTimer,"Dialog Speed")
    else
        call DialogSetMessageBJ(udg_VoteDialog,"|cff4080ffSelect Text Speed|nduring Cinematics|r")
    endif
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_VoteButton[GetForLoopIndexA()]=DialogAddButtonBJ(udg_VoteDialog,udg_VoteOptionText[GetForLoopIndexA()])
        set udg_VoteCount[GetForLoopIndexA()]=0
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_VotesCast=0
    set udg_VoteSum=.0
    call EnableTrigger(gg_trg_Vote_TextSpeed_Click)
    call Wait_Polled(.05)
    call ForForce(udg_PlayingPlayers,function Trig_Vote_TextSpeed_Show_ShowDialogToPlayer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Vote_TextSpeed_Click_IsMultiplayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Vote_TextSpeed_Click_ClickedSpeedButton takes nothing returns boolean
    return(GetClickedButtonBJ()==udg_VoteButton[GetForLoopIndexA()])
endfunction

function Trig_Vote_TextSpeed_Click_IsMultiplayer2 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Vote_TextSpeed_Click_ClickedSkipScenes takes nothing returns boolean
    return(GetClickedButtonBJ()==udg_VoteButton[6])
endfunction

function Trig_Vote_TextSpeed_Click_IsMultiplayer3 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Vote_TextSpeed_Click_ClickedSkipText takes nothing returns boolean
    return(GetClickedButtonBJ()==udg_VoteButton[5])
endfunction

function Trig_Vote_TextSpeed_Click_VotesPending takes nothing returns boolean
    return(udg_VotesCast<CountPlayersInForceBJ(udg_PlayingPlayers))
endfunction

function Trig_Vote_TextSpeed_Click_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetTriggerPlayer())
    call SetUserControlForceOff(l_tempForce)
    call DestroyForce(l_tempForce)
    set udg_VotesCast=(udg_VotesCast+1)
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Vote_TextSpeed_Click_ClickedSpeedButton())then
            if(Trig_Vote_TextSpeed_Click_IsMultiplayer())then
                call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+(" voted for |cffffcc00"+(udg_VoteOptionText[GetForLoopIndexA()]+"|r text speed."))))
            endif
            set udg_VoteSum=(udg_VoteSum+I2R(GetForLoopIndexA()))
            set udg_VoteCount[GetForLoopIndexA()]=(udg_VoteCount[GetForLoopIndexA()]+1)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Vote_TextSpeed_Click_ClickedSkipText())then
        if(Trig_Vote_TextSpeed_Click_IsMultiplayer3())then
            call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" voted for |cffffcc00skipping cinematic text|r."))
        endif
        set udg_VoteSum=(udg_VoteSum+5.)
        set udg_VoteCount[5]=(udg_VoteCount[5]+1)
    else
        if(Trig_Vote_TextSpeed_Click_ClickedSkipScenes())then
            if(Trig_Vote_TextSpeed_Click_IsMultiplayer2())then
                call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" voted for |cffffcc00skipping cinematics|r."))
            endif
            set udg_VoteSum=(udg_VoteSum+6.)
            set udg_VoteCount[6]=(udg_VoteCount[6]+1)
        endif
    endif
    if(Trig_Vote_TextSpeed_Click_VotesPending())then
        call DisplayTimedTextToForce(udg_PlayingPlayers,8.,("Players to vote: "+I2S((CountPlayersInForceBJ(udg_PlayingPlayers)-udg_VotesCast))))
    else
        call TriggerExecute(gg_trg_Vote_TextSpeed_Result)
    endif
    set l_tempForce=null
endfunction

function Trig_Vote_TextSpeed_Result_HideDialogForPlayer takes nothing returns nothing
    call DialogDisplayBJ(false,udg_VoteDialog,GetEnumPlayer())
endfunction

function Trig_Vote_TextSpeed_Result_IsTiedTop takes nothing returns boolean
    return(udg_VoteCount[GetForLoopIndexA()]==udg_TopVoteCount)
endfunction

function Trig_Vote_TextSpeed_Result_IsAtLeastTop takes nothing returns boolean
    return(udg_VoteCount[GetForLoopIndexA()]>0)and(udg_VoteCount[GetForLoopIndexA()]>=udg_TopVoteCount)
endfunction

function Trig_Vote_TextSpeed_Result_HasWinner takes nothing returns boolean
    return(udg_WinningOption>=0)
endfunction

function Trig_Vote_TextSpeed_Result_NoVotes takes nothing returns boolean
    return(udg_VotesCast==0)
endfunction

function Trig_Vote_TextSpeed_Result_IsSkipText takes nothing returns boolean
    return(udg_VoteSum>4.5)
endfunction

function Trig_Vote_TextSpeed_Result_IsSkipScenes takes nothing returns boolean
    return(udg_VoteSum>5.5)
endfunction

function Trig_Vote_TextSpeed_Result_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Vote_TextSpeed_Click)
    call PauseTimerBJ(true,udg_VoteTimer)
    call ForForce(udg_PlayingPlayers,function Trig_Vote_TextSpeed_Result_HideDialogForPlayer)
    if(Trig_Vote_TextSpeed_Result_NoVotes())then
        set udg_VoteSum=2.
    else
        set udg_TopVoteCount=0
        set udg_WinningOption=-1
        set bj_forLoopAIndex=0
        set bj_forLoopAIndexEnd=6
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Vote_TextSpeed_Result_IsAtLeastTop())then
                if(Trig_Vote_TextSpeed_Result_IsTiedTop())then
                    set udg_WinningOption=-1
                else
                    set udg_WinningOption=GetForLoopIndexA()
                    set udg_TopVoteCount=udg_VoteCount[GetForLoopIndexA()]
                endif
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        if(Trig_Vote_TextSpeed_Result_HasWinner())then
            set udg_VoteSum=I2R(udg_WinningOption)
        else
            set udg_VoteSum=(udg_VoteSum/(I2R(udg_VotesCast)+.5))
        endif
    endif
    call DisplayTimedTextToForce(GetPlayersAll(),15.,("Cinematic Speed: |cffffcc00"+(udg_VoteOptionText[R2I(udg_VoteSum)]+"|r")))
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"You can change cinematic speed at any time during the game using the \"-text\" command.")
    if(Trig_Vote_TextSpeed_Result_IsSkipText())then
        set udg_TextSpeed=.0
    else
        set udg_TextSpeed=(100.+(100.*I2R(R2I(udg_VoteSum))))
    endif
    if(Trig_Vote_TextSpeed_Result_IsSkipScenes())then
        set udg_CinematicsDisabled=true
    else
        set udg_CinematicsDisabled=false
    endif
    call TriggerExecute(gg_trg_Game_Start)
endfunction

function Trig_Vote_Difficulty_Show_IsMultiplayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Vote_Difficulty_Show_ShowDialogToPlayer takes nothing returns nothing
    call DialogDisplayBJ(true,udg_VoteDialog,GetEnumPlayer())
endfunction

function Trig_Vote_Difficulty_Show_Actions takes nothing returns nothing
    call SetUserControlForceOn(GetPlayersAll())
    call TimerDialogSetTitleBJ(udg_VoteTimerDialog,"Vote for Difficulty")
    call EnableTrigger(gg_trg_Vote_Difficulty_Result)
    call DialogClearBJ(udg_VoteDialog)
    if(Trig_Vote_Difficulty_Show_IsMultiplayer())then
        call DialogSetMessageBJ(udg_VoteDialog,"|cff4080ffVote for Difficulty|r")
        call StartTimerBJ(udg_VoteTimer,false,20.)
    else
        call DialogSetMessageBJ(udg_VoteDialog,"|cff4080ffSelect Difficulty|r")
    endif
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=5
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_VoteButton[GetForLoopIndexA()]=DialogAddButtonBJ(udg_VoteDialog,udg_VoteOptionText[(GetForLoopIndexA()+7)])
        set udg_VoteCount[GetForLoopIndexA()]=0
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_VotesCast=0
    set udg_VoteSum=.0
    call EnableTrigger(gg_trg_Vote_Difficulty_Click)
    call Wait_Polled(.05)
    call ForForce(udg_PlayingPlayers,function Trig_Vote_Difficulty_Show_ShowDialogToPlayer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Vote_Difficulty_Click_IsMultiplayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Vote_Difficulty_Click_ClickedDifficultyButton takes nothing returns boolean
    return(GetClickedButtonBJ()==udg_VoteButton[GetForLoopIndexA()])
endfunction

function Trig_Vote_Difficulty_Click_VotesPending takes nothing returns boolean
    return(udg_VotesCast<CountPlayersInForceBJ(udg_PlayingPlayers))
endfunction

function Trig_Vote_Difficulty_Click_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetTriggerPlayer())
    call SetUserControlForceOff(l_tempForce)
    call DestroyForce(l_tempForce)
    set udg_VotesCast=(udg_VotesCast+1)
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=5
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Vote_Difficulty_Click_ClickedDifficultyButton())then
            if(Trig_Vote_Difficulty_Click_IsMultiplayer())then
                // (loop counter A) plus (7).
                call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+(" voted for "+(udg_VoteOptionText[(GetForLoopIndexA()+7)]+" difficulty."))))
            endif
            set udg_VoteSum=(udg_VoteSum+I2R(GetForLoopIndexA()))
            set udg_VoteCount[GetForLoopIndexA()]=(udg_VoteCount[GetForLoopIndexA()]+1)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Vote_Difficulty_Click_VotesPending())then
        call DisplayTimedTextToForce(udg_PlayingPlayers,8.,("Players to vote: "+I2S((CountPlayersInForceBJ(udg_PlayingPlayers)-udg_VotesCast))))
    else
        call TriggerExecute(gg_trg_Vote_Difficulty_Result)
    endif
    set l_tempForce=null
endfunction

function Trig_Vote_Difficulty_Result_HideDialogForPlayer takes nothing returns nothing
    call DialogDisplayBJ(false,udg_VoteDialog,GetEnumPlayer())
endfunction

function Trig_Vote_Difficulty_Result_GiveStartGold takes nothing returns nothing
    call AdjustPlayerStateBJ(300,GetEnumPlayer(),PLAYER_STATE_RESOURCE_GOLD)
endfunction

function Trig_Vote_Difficulty_Result_IsTiedTop takes nothing returns boolean
    return(udg_VoteCount[GetForLoopIndexA()]==udg_TopVoteCount)
endfunction

function Trig_Vote_Difficulty_Result_IsAtLeastTop takes nothing returns boolean
    return(udg_VoteCount[GetForLoopIndexA()]>0)and(udg_VoteCount[GetForLoopIndexA()]>=udg_TopVoteCount)
endfunction

function Trig_Vote_Difficulty_Result_IsUpperHalf takes nothing returns boolean
    return(udg_VoteSum>=2.)
endfunction

function Trig_Vote_Difficulty_Result_HasWinner takes nothing returns boolean
    return(udg_WinningOption>=0)
endfunction

function Trig_Vote_Difficulty_Result_NoVotes takes nothing returns boolean
    return(udg_VotesCast==0)
endfunction

function Trig_Vote_Difficulty_Result_SaveLoadEnabled takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Vote_Difficulty_Result_IsSimple takes nothing returns boolean
    return(udg_Difficulty==1)
endfunction

function Trig_Vote_Difficulty_Result_IsEasy takes nothing returns boolean
    return(udg_Difficulty==2)
endfunction

function Trig_Vote_Difficulty_Result_IsNormal takes nothing returns boolean
    return(udg_Difficulty==3)
endfunction

function Trig_Vote_Difficulty_Result_IsHard takes nothing returns boolean
    return(udg_Difficulty==4)
endfunction

function Trig_Vote_Difficulty_Result_SaveLoadEnabled2 takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Vote_Difficulty_Result_IsInferno takes nothing returns boolean
    return(udg_Difficulty==5)
endfunction

function Trig_Vote_Difficulty_Result_SaveLoadEnabled3 takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Vote_Difficulty_Result_IsNightmare takes nothing returns boolean
    return(udg_Difficulty==6)
endfunction

function Trig_Vote_Difficulty_Result_IsBelowInferno takes nothing returns boolean
    return(udg_Difficulty<5)
endfunction

function Trig_Vote_Difficulty_Result_IsSpeedrunMode takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Vote_Difficulty_Result_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Vote_Difficulty_Click)
    call PauseTimerBJ(true,udg_VoteTimer)
    call ForForce(udg_PlayingPlayers,function Trig_Vote_Difficulty_Result_HideDialogForPlayer)
    call ForForce(udg_PlayingPlayers,function Trig_Vote_Difficulty_Result_GiveStartGold)
    if(Trig_Vote_Difficulty_Result_NoVotes())then
        set udg_Difficulty=3
    else
        set udg_TopVoteCount=0
        set udg_WinningOption=-1
        set bj_forLoopAIndex=0
        set bj_forLoopAIndexEnd=5
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Vote_Difficulty_Result_IsAtLeastTop())then
                if(Trig_Vote_Difficulty_Result_IsTiedTop())then
                    set udg_WinningOption=-1
                else
                    set udg_WinningOption=GetForLoopIndexA()
                    set udg_TopVoteCount=udg_VoteCount[GetForLoopIndexA()]
                endif
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        if(Trig_Vote_Difficulty_Result_HasWinner())then
            set udg_Difficulty=(udg_WinningOption+1)
        else
            set udg_VoteSum=(udg_VoteSum/ I2R(udg_VotesCast))
            if(Trig_Vote_Difficulty_Result_IsUpperHalf())then
                set udg_VoteSum=(udg_VoteSum+.49)
            else
                set udg_VoteSum=(udg_VoteSum+.51)
            endif
            set udg_Difficulty=(R2I(udg_VoteSum)+1)
        endif
    endif
    if(Trig_Vote_Difficulty_Result_IsSimple())then
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff00ff00Simple|r: Enemies have heavily reduced damage, defense and attack speed.")
        if(Trig_Vote_Difficulty_Result_SaveLoadEnabled())then
            call DisplayTimedTextToForce(GetPlayersAll(),15.," ")
            call DisplayTimedTextToForce(GetPlayersAll(),15.,"Saves from Simple mode cannot be loaded in other difficulties besides Nightmare.")
        endif
        set udg_DifficultyScale=2.
        set udg_EnemyHpPerPlayer=50.
        set udg_ExpRate=.5
        call UnitAddAbilityBJ('A06L',udg_NarratorUnit) // 'A06L': ability "General Information"
        call UnitAddAbilityBJ('S000',udg_NarratorUnit) // 'S000': ability "Attack Speed"
        call QuestSetDescriptionBJ(udg_DifficultyQuest,"|cffffcc00Enemy Damage Taken|r: 200%|n|cffffcc00Enemy Damage Dealt|r: 50%|n|cffffcc00Enemy Attack Speed|r: -30%|n|cffffcc00Enemy HP+ per Player|r: 50%|n|cffffcc00Experience gain rate|r: 50%")
    endif
    if(Trig_Vote_Difficulty_Result_IsEasy())then
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff22cc22Easy|r: Enemies have reduced damage, defense and attack speed.")
        set udg_DifficultyScale=1.5
        set udg_EnemyHpPerPlayer=75.
        set udg_ExpRate=.7
        call UnitAddAbilityBJ('A06M',udg_NarratorUnit) // 'A06M': ability "General Information"
        call UnitAddAbilityBJ('S001',udg_NarratorUnit) // 'S001': ability "Attack Speed"
        call QuestSetDescriptionBJ(udg_DifficultyQuest,"|cffffcc00Enemy Damage Taken|r: 150%|n|cffffcc00Enemy Damage Dealt|r: 66%|n|cffffcc00Enemy Attack Speed|r: -15%|n|cffffcc00Enemy HP+ per Player|r: 75%|n|cffffcc00Experience gain rate|r: 70%")
    endif
    if(Trig_Vote_Difficulty_Result_IsNormal())then
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cffffff00Normal|r: Enemies have normal damage, defense and attack speed.")
        set udg_DifficultyScale=1.
        set udg_EnemyHpPerPlayer=100.
        set udg_ExpRate=1.
        call UnitAddAbilityBJ('A06X',udg_NarratorUnit) // 'A06X': ability "General Information"
        call QuestSetDescriptionBJ(udg_DifficultyQuest,"|cffffcc00Enemy Damage Taken|r: 100%|n|cffffcc00Enemy Damage Dealt|r: 100%|n|cffffcc00Enemy Attack Speed|r: normal|n|cffffcc00Enemy HP+ per Player|r: 100%|n|cffffcc00Experience gain rate|r: 100%")
    endif
    if(Trig_Vote_Difficulty_Result_IsHard())then
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cffcc2222Hard|r: Enemies have increased damage, defense and attack speed.")
        set udg_DifficultyScale=(2./ 3.)
        set udg_EnemyHpPerPlayer=150.
        set udg_ExpRate=1.3
        call UnitAddAbilityBJ('A06N',udg_NarratorUnit) // 'A06N': ability "General Information"
        call UnitAddAbilityBJ('S002',udg_NarratorUnit) // 'S002': ability "Attack Speed"
        call QuestSetDescriptionBJ(udg_DifficultyQuest,"|cffffcc00Enemy Damage Taken|r: 66%|n|cffffcc00Enemy Damage Dealt|r: 150%|n|cffffcc00Enemy Attack Speed|r: +50%|n|cffffcc00Enemy HP+ per Player|r: 150%|n|cffffcc00Experience gain rate|r: 130%")
    endif
    if(Trig_Vote_Difficulty_Result_IsInferno())then
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cffdd0000Inferno|r: Enemies have heavily increased damage, defense and attack speed.")
        if(Trig_Vote_Difficulty_Result_SaveLoadEnabled2())then
            call DisplayTimedTextToForce(GetPlayersAll(),15.," ")
            call DisplayTimedTextToForce(GetPlayersAll(),15.,"Only saves created on Inferno difficulty level may be loaded.")
        endif
        set udg_DifficultyScale=.5
        set udg_EnemyHpPerPlayer=200.
        set udg_ExpRate=1.5
        call UnitAddAbilityBJ('A06O',udg_NarratorUnit) // 'A06O': ability "General Information"
        call UnitAddAbilityBJ('S003',udg_NarratorUnit) // 'S003': ability "Attack Speed"
        call QuestSetDescriptionBJ(udg_DifficultyQuest,"|cffffcc00Enemy Damage Taken|r: 50%|n|cffffcc00Enemy Damage Dealt|r: 200%|n|cffffcc00Enemy Attack Speed|r: +100%|n|cffffcc00Enemy HP+ per Player|r: 200%|n|cffffcc00Experience gain rate|r: 150%")
    endif
    if(Trig_Vote_Difficulty_Result_IsNightmare())then
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"|cff330000Nightmare|r: Enemies have insane damage, defense and speed.")
        if(Trig_Vote_Difficulty_Result_SaveLoadEnabled3())then
            call DisplayTimedTextToForce(GetPlayersAll(),15.," ")
            call DisplayTimedTextToForce(GetPlayersAll(),15.,"Can load any codes. Does not change their difficulty association.")
        endif
        set udg_DifficultyScale=(1/ 3.)
        set udg_EnemyHpPerPlayer=250.
        set udg_ExpRate=1.5
        call UnitAddAbilityBJ('A154',udg_NarratorUnit) // 'A154': ability "General Information"
        call UnitAddAbilityBJ('S00M',udg_NarratorUnit) // 'S00M': ability "Attack Speed"
        call QuestSetDescriptionBJ(udg_DifficultyQuest,"|cffffcc00Enemy Damage Taken|r: 33%|n|cffffcc00Enemy Damage Dealt|r: 300%|n|cffffcc00Enemy Attack Speed|r: +120%|n|cffffcc00Enemy Move Speed|r: +20%|n|cffffcc00Enemy HP+ per Player|r: 250%|n|cffffcc00Experience gain rate|r: 150%")
    endif
    if(Trig_Vote_Difficulty_Result_IsBelowInferno())then
        call AddItemToStockBJ('stwp',gg_unit_hvlt_0162,1,1) // 'stwp': item "Scroll of Portal"
    endif
    call SetPlayerTechResearchedSwap('R01R',udg_Difficulty,Player($B)) // 'R01R': upgrade "Dark Dragon Marsh"; $B = 11
    call Difficulty_SumHandicap(udg_PlayingPlayers)
    call SetPlayerHandicapBJ(Player($B),udg_EnemyHandicap) // $B = 11
    set udg_DifficultyName=udg_VoteOptionText[(udg_Difficulty+6)]
    call QuestSetTitleBJ(udg_DifficultyQuest,udg_DifficultyName)
    if(Trig_Vote_Difficulty_Result_IsSpeedrunMode())then
        call TriggerExecute(gg_trg_Game_Start)
    else
        call Wait_Polled(2.)
        call ConditionalTriggerExecute(gg_trg_Vote_TextSpeed_Show)
    endif
endfunction

function Trig_Vote_GameMode_Show_IsMultiplayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Vote_GameMode_Show_ShowDialogToPlayer takes nothing returns nothing
    call DialogDisplayBJ(true,udg_VoteDialog,GetEnumPlayer())
endfunction

function Trig_Vote_GameMode_Show_Actions takes nothing returns nothing
    call SetUserControlForceOn(GetPlayersAll())
    call TimerDialogSetTitleBJ(udg_VoteTimerDialog,"Vote for Game Mode")
    call EnableTrigger(gg_trg_GameMode_Apply)
    call DialogClearBJ(udg_VoteDialog)
    if(Trig_Vote_GameMode_Show_IsMultiplayer())then
        call DialogSetMessageBJ(udg_VoteDialog,"|cff4080ffVote for Game Mode|r")
        call StartTimerBJ(udg_VoteTimer,false,15.)
    else
        call DialogSetMessageBJ(udg_VoteDialog,"|cff4080ffSelect Game Mode|r")
    endif
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=3
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_VoteButton[GetForLoopIndexA()]=DialogAddButtonBJ(udg_VoteDialog,udg_VoteOptionText[(GetForLoopIndexA()+$D)]) // $D = 13
        set udg_VoteCount[GetForLoopIndexA()]=0
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_VotesCast=0
    set udg_VoteSum=.0
    call EnableTrigger(gg_trg_Vote_GameMode_Click)
    call Wait_Polled(.05)
    call ForForce(udg_PlayingPlayers,function Trig_Vote_GameMode_Show_ShowDialogToPlayer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Vote_GameMode_Click_IsMultiplayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Vote_GameMode_Click_ClickedModeButton takes nothing returns boolean
    return(GetClickedButtonBJ()==udg_VoteButton[GetForLoopIndexA()])
endfunction

function Trig_Vote_GameMode_Click_VotesPending takes nothing returns boolean
    return(udg_VotesCast<CountPlayersInForceBJ(udg_PlayingPlayers))
endfunction

function Trig_Vote_GameMode_Click_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetTriggerPlayer())
    call SetUserControlForceOff(l_tempForce)
    call DestroyForce(l_tempForce)
    set udg_VotesCast=(udg_VotesCast+1)
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Vote_GameMode_Click_ClickedModeButton())then
            if(Trig_Vote_GameMode_Click_IsMultiplayer())then
                // (loop counter A) plus (13).
                call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+(" voted for "+(udg_VoteOptionText[(GetForLoopIndexA()+$D)]+" game mode.")))) // $D = 13
            endif
            set udg_VoteSum=(udg_VoteSum+I2R(GetForLoopIndexA()))
            set udg_VoteCount[GetForLoopIndexA()]=(udg_VoteCount[GetForLoopIndexA()]+1)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Vote_GameMode_Click_VotesPending())then
        call DisplayTimedTextToForce(udg_PlayingPlayers,8.,("Players to vote: "+I2S((CountPlayersInForceBJ(udg_PlayingPlayers)-udg_VotesCast))))
    else
        call TriggerExecute(gg_trg_GameMode_Apply)
    endif
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_Vote automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Vote (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Vote takes nothing returns nothing
endfunction

function Register_Vote_TextSpeed_Show takes nothing returns nothing
    set gg_trg_Vote_TextSpeed_Show=CreateTrigger()
    call DisableTrigger(gg_trg_Vote_TextSpeed_Show)
    call TriggerAddAction(gg_trg_Vote_TextSpeed_Show,function Trig_Vote_TextSpeed_Show_Actions)
endfunction

function Register_Vote_TextSpeed_Click takes nothing returns nothing
    set gg_trg_Vote_TextSpeed_Click=CreateTrigger()
    call DisableTrigger(gg_trg_Vote_TextSpeed_Click)
    call TriggerRegisterDialogEventBJ(gg_trg_Vote_TextSpeed_Click,udg_VoteDialog)
    call TriggerAddAction(gg_trg_Vote_TextSpeed_Click,function Trig_Vote_TextSpeed_Click_Actions)
endfunction

function Register_Vote_TextSpeed_Result takes nothing returns nothing
    set gg_trg_Vote_TextSpeed_Result=CreateTrigger()
    call DisableTrigger(gg_trg_Vote_TextSpeed_Result)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Vote_TextSpeed_Result,udg_VoteTimer)
    call TriggerAddAction(gg_trg_Vote_TextSpeed_Result,function Trig_Vote_TextSpeed_Result_Actions)
endfunction

function Register_Vote_Difficulty_Show takes nothing returns nothing
    set gg_trg_Vote_Difficulty_Show=CreateTrigger()
    call DisableTrigger(gg_trg_Vote_Difficulty_Show)
    call TriggerAddAction(gg_trg_Vote_Difficulty_Show,function Trig_Vote_Difficulty_Show_Actions)
endfunction

function Register_Vote_Difficulty_Click takes nothing returns nothing
    set gg_trg_Vote_Difficulty_Click=CreateTrigger()
    call DisableTrigger(gg_trg_Vote_Difficulty_Click)
    call TriggerRegisterDialogEventBJ(gg_trg_Vote_Difficulty_Click,udg_VoteDialog)
    call TriggerAddAction(gg_trg_Vote_Difficulty_Click,function Trig_Vote_Difficulty_Click_Actions)
endfunction

function Register_Vote_Difficulty_Result takes nothing returns nothing
    set gg_trg_Vote_Difficulty_Result=CreateTrigger()
    call DisableTrigger(gg_trg_Vote_Difficulty_Result)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Vote_Difficulty_Result,udg_VoteTimer)
    call TriggerAddAction(gg_trg_Vote_Difficulty_Result,function Trig_Vote_Difficulty_Result_Actions)
endfunction

function Register_Vote_GameMode_Show takes nothing returns nothing
    set gg_trg_Vote_GameMode_Show=CreateTrigger()
    call DisableTrigger(gg_trg_Vote_GameMode_Show)
    call TriggerAddAction(gg_trg_Vote_GameMode_Show,function Trig_Vote_GameMode_Show_Actions)
endfunction

function Register_Vote_GameMode_Click takes nothing returns nothing
    set gg_trg_Vote_GameMode_Click=CreateTrigger()
    call DisableTrigger(gg_trg_Vote_GameMode_Click)
    call TriggerRegisterDialogEventBJ(gg_trg_Vote_GameMode_Click,udg_VoteDialog)
    call TriggerAddAction(gg_trg_Vote_GameMode_Click,function Trig_Vote_GameMode_Click_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Vote takes nothing returns nothing
    call Register_Vote_TextSpeed_Show() // starts off; run by Vote
    call Register_Vote_TextSpeed_Click() // starts off; enabled by Vote; disabled by Vote; destroyed by Game
    call Register_Vote_TextSpeed_Result() // starts off; enabled by Vote; run by Vote
    call Register_Vote_Difficulty_Show() // starts off; run by GameMode
    call Register_Vote_Difficulty_Click() // starts off; enabled by Vote; disabled by Vote; destroyed by Game
    call Register_Vote_Difficulty_Result() // starts off; enabled by Vote; run by Vote
    call Register_Vote_GameMode_Show() // starts off; run by Intro
    call Register_Vote_GameMode_Click() // starts off; enabled by Vote; disabled by GameMode; destroyed by Game
endfunction

endlibrary
