library TQuestOgreHunt requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_OgreHunt_Start=null
    trigger gg_trg_Quest_OgreHunt_Count=null
    trigger gg_trg_Quest_OgreHunt_Complete=null
endglobals

function Trig_Quest_OgreHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0BW_0094,true,true,true))
endfunction

function Trig_Quest_OgreHunt_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_OgreHunt_Start_Cond_FirstBoardQuest takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_Quest_OgreHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[72])
    if(Trig_Quest_OgreHunt_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0BW_0094,"Hello there. My name is Monica and I'm a member of the Hunt Club. I have a request you could take on.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We are ready for anything. Tell us what you've got.",false)
        call Text_Say(gg_unit_n0BW_0094,"We've been tasked to clear out Ogres. Those dirty, filthy, stupid imbeciles. One of their tribes now inhabits mountains near Kalm. These brutes are some of the most dangerous among the monsters threatening Kalm.",false)
        call Text_Say(gg_unit_n0BW_0094,"Ogres are cannibals and also they enjoy eating human and elven flesh. These creatures must not be allowed to live. So we received a request to have at least 25 ogres exterminated. Naturally you'll receive the bounty on this quest if you do it.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Those ogres need to be taught to fear humans. We will gladly take your request.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Ogre Hunt|r")
    set udg_SideQuest[24]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Ogre Hunt"),"Monica, high elf Hunt Club member in Kalm, hired you to slay 25 ogres who live in the mountains northwest of Kalm. ","ReplaceableTextures\\CommandButtons\\BTNOgre.blp")
    set udg_SpecialEffect[72]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BW_0094,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_Quest_OgreHunt_Start_Cond_FirstBoardQuest())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[4]=25
    set udg_HuntBoardLabel[4]="Ogres to kill"
    call LeaderboardAddItemBJ(Player(3),udg_HuntLeaderboard,udg_HuntBoardLabel[4],udg_HuntCounter[4])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(3),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(3),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_Quest_OgreHunt_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_OgreHunt_Count_Cond_IsOgre takes nothing returns boolean
    return(GetUnitTypeId(GetDyingUnit())=='nogr')or(GetUnitTypeId(GetDyingUnit())=='nomg')or(GetUnitTypeId(GetDyingUnit())=='nogm')or(GetUnitTypeId(GetDyingUnit())=='nogl')or(GetUnitTypeId(GetDyingUnit())=='n0MO')or(GetUnitTypeId(GetDyingUnit())=='H00W') // 'nogr': object name not found in map data; 'nomg': object name not found in map data; 'nogm': object name not found in map data; 'nogl': object name not found in map data; 'n0MO': unit "Ogre Berserker"; 'H00W': unit "Ogre Crusher"
endfunction

function Trig_Quest_OgreHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_Quest_OgreHunt_Count_Cond_IsOgre())
endfunction

function Trig_Quest_OgreHunt_Count_Cond_NoBoardQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_Quest_OgreHunt_Count_Cond_AllOgresKilled takes nothing returns boolean
    return(udg_HuntCounter[4]<=0)
endfunction

function Trig_Quest_OgreHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[4]=(udg_HuntCounter[4]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(3),udg_HuntLeaderboard,udg_HuntCounter[4])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_Quest_OgreHunt_Count_Cond_AllOgresKilled())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(3),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_Quest_OgreHunt_Count_Cond_NoBoardQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough ogres. Return to Monica for a reward.\r\n")
        call QuestSetDescriptionBJ(udg_SideQuest[24],"Return to Monica for a reward.")
        call GroupAddUnitSimple(gg_unit_n0BW_0094,udg_BossUnits)
        call EnableTrigger(gg_trg_Quest_OgreHunt_Complete)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Quest_OgreHunt_Complete_Conditions takes nothing returns boolean
    return((IsUnitHiddenBJ(gg_unit_n0BW_0094)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_OgreHunt_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_OgreHunt_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[72])
    call GroupRemoveUnitSimple(gg_unit_n0BW_0094,udg_BossUnits)
    if(Trig_Quest_OgreHunt_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0BW_0094,0)
        call Text_Say(gg_unit_n0BW_0094,"I see you've cleared the task. You've done great work. Here's your due reward.",false)
        call Reward_Give($7D0,$7D0,gg_unit_n0BW_0094) // $7D0 = 2000
        call Cine_ExitAction()
    else
        call Reward_Give($7D0,$7D0,gg_unit_n0BW_0094) // $7D0 = 2000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Ogre Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[24],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call UnitAddAbilityBJ('Ane2',gg_unit_n0BW_0094) // 'Ane2': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_OgreHunt takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_OgreHunt_Start takes nothing returns nothing
    set gg_trg_Quest_OgreHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_OgreHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_OgreHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_OgreHunt_Start,Condition(function Trig_Quest_OgreHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_OgreHunt_Start,function Trig_Quest_OgreHunt_Start_Actions)
endfunction

function Register_Quest_OgreHunt_Count takes nothing returns nothing
    set gg_trg_Quest_OgreHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_OgreHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_OgreHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Quest_OgreHunt_Count,Condition(function Trig_Quest_OgreHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_Quest_OgreHunt_Count,function Trig_Quest_OgreHunt_Count_Actions)
endfunction

function Register_Quest_OgreHunt_Complete takes nothing returns nothing
    set gg_trg_Quest_OgreHunt_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_OgreHunt_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_OgreHunt_Complete,450.,gg_unit_n0BW_0094)
    call TriggerAddCondition(gg_trg_Quest_OgreHunt_Complete,Condition(function Trig_Quest_OgreHunt_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_OgreHunt_Complete,function Trig_Quest_OgreHunt_Complete_Actions)
endfunction

endlibrary
