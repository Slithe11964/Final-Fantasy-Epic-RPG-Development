library TQuestHarpyHunt requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_HarpyHunt_Start=null
    trigger gg_trg_Quest_HarpyHunt_Count=null
    trigger gg_trg_Quest_HarpyHunt_Reward=null
endglobals

function Trig_Quest_HarpyHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0B3_0049,true,true,true))
endfunction

function Trig_Quest_HarpyHunt_Start_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_HarpyHunt_Start_Cond_FirstBoardItem takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_Quest_HarpyHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[3])
    if(Trig_Quest_HarpyHunt_Start_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0B3_0049,"Hello. I've heard from Kollin that you are now an honorary member of our Hunt Club.",false)
        call Text_Say(gg_unit_n0B3_0049,"As such, I have another task for you to complete. For a gold reward, of course.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you want us to slay more dangerous monsters?",false)
        call Text_Say(gg_unit_n0B3_0049,"Indeed. The club received a request from a Kalm resident who was recently cursed by an evil spell. The perpetrator was an arrogant harpy from the Barrens.",false)
        call Text_Say(gg_unit_n0B3_0049,"He continues to work in poor failing health, but he won't be able to go on like this. Unfortunately the only way to break the curse is to kill the harpy that inflicted it. But we do not know which harpy it was.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That is unfortunate. What would you have us do then?",false)
        call Text_Say(gg_unit_n0B3_0049,"I'd say simply go by trial and error. The harpy in question must be out there somewhere.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Fair enough. We will return to you once we've killed a number of harpies. Hopefully your friend will be healthy again then.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Harpy Hunt|r")
    set udg_SideQuest[45]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffHarpy Hunt","Caroline, the Hunt Club Barrens representative, asked you to slay evil harpies who live in the Barrens south of Kalm. Report back after killing at least 20!","ReplaceableTextures\\CommandButtons\\BTNHarpyQueen.blp")
    set udg_SpecialEffect[4]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0B3_0049,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_Quest_HarpyHunt_Start_Cond_FirstBoardItem())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[2]=20
    set udg_HuntBoardLabel[2]="Harpys to kill"
    call LeaderboardAddItemBJ(Player(1),udg_HuntLeaderboard,udg_HuntBoardLabel[2],udg_HuntCounter[2])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(1),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(1),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_Quest_HarpyHunt_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_HarpyHunt_Count_Cond_IsHarpy takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='nhar')or(GetUnitTypeId(GetTriggerUnit())=='nhrr')or(GetUnitTypeId(GetTriggerUnit())=='nhrw')or(GetUnitTypeId(GetTriggerUnit())=='nhrh')or(GetUnitTypeId(GetTriggerUnit())=='nhrq')or(GetUnitTypeId(GetTriggerUnit())=='n0L0')or(GetUnitTypeId(GetTriggerUnit())=='n0KZ') // 'nhar': object name not found in map data; 'nhrr': object name not found in map data; 'nhrw': object name not found in map data; 'nhrh': object name not found in map data; 'nhrq': object name not found in map data; 'n0L0': unit "Harpy Trickster"; 'n0KZ': unit "Harpy Matriarch"
endfunction

function Trig_Quest_HarpyHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_Quest_HarpyHunt_Count_Cond_IsHarpy())
endfunction

function Trig_Quest_HarpyHunt_Count_Cond_BoardEmpty takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_Quest_HarpyHunt_Count_Cond_QuotaReached takes nothing returns boolean
    return(udg_HuntCounter[2]<=0)
endfunction

function Trig_Quest_HarpyHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[2]=(udg_HuntCounter[2]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(1),udg_HuntLeaderboard,udg_HuntCounter[2])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_Quest_HarpyHunt_Count_Cond_QuotaReached())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(1),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_Quest_HarpyHunt_Count_Cond_BoardEmpty())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough harpies. Return to Caroline for a reward.\r\n")
        call QuestSetDescriptionBJ(udg_SideQuest[45],"Return to Caroline for a reward.")
        call GroupAddUnitSimple(gg_unit_n0B3_0049,udg_BossUnits)
        call EnableTrigger(gg_trg_Quest_HarpyHunt_Reward)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Quest_HarpyHunt_Reward_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_HarpyHunt_Reward_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_HarpyHunt_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[4])
    call GroupRemoveUnitSimple(gg_unit_n0B3_0049,udg_BossUnits)
    if(Trig_Quest_HarpyHunt_Reward_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0B3_0049,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well, we have killed 20 harpies. Has your client recovered yet?",false)
        call Text_Say(gg_unit_n0B3_0049,"Indeed he has. It seems the harpy that cursed him was among the ones you killed.",false)
        call Text_Say(gg_unit_n0B3_0049,"Of course the bounty for this task is all yours. Here, take it.",false)
        call Reward_Give($5DC,$5DC,gg_unit_n0B3_0049) // $5DC = 1500
        call Cine_ExitAction()
    else
        call Reward_Give($5DC,$5DC,gg_unit_n0B3_0049) // $5DC = 1500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Harpy Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[45],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_n0B3_0049) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0B6',gg_unit_n0B3_0049,1,1) // 'n0B6': unit "Hunt: Cactuar"
    set udg_HuntStock[2]=(udg_HuntStock[2]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_HarpyHunt takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part15 (module Quest),
// which keeps the original registration order.

function Register_Quest_HarpyHunt_Start takes nothing returns nothing
    set gg_trg_Quest_HarpyHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_HarpyHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_HarpyHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_HarpyHunt_Start,Condition(function Trig_Quest_HarpyHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_HarpyHunt_Start,function Trig_Quest_HarpyHunt_Start_Actions)
endfunction

function Register_Quest_HarpyHunt_Count takes nothing returns nothing
    set gg_trg_Quest_HarpyHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_HarpyHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_HarpyHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Quest_HarpyHunt_Count,Condition(function Trig_Quest_HarpyHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_Quest_HarpyHunt_Count,function Trig_Quest_HarpyHunt_Count_Actions)
endfunction

function Register_Quest_HarpyHunt_Reward takes nothing returns nothing
    set gg_trg_Quest_HarpyHunt_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_HarpyHunt_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_HarpyHunt_Reward,450.,gg_unit_n0B3_0049)
    call TriggerAddCondition(gg_trg_Quest_HarpyHunt_Reward,Condition(function Trig_Quest_HarpyHunt_Reward_Conditions))
    call TriggerAddAction(gg_trg_Quest_HarpyHunt_Reward,function Trig_Quest_HarpyHunt_Reward_Actions)
endfunction

endlibrary
