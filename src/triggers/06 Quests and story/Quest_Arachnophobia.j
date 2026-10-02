library TQuestArachnophobia requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_Quest_Arachnophobia_Offer_Actions takes nothing returns nothing
    set udg_SpecialEffect[3]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n009_0051,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_Arachnophobia_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Arachnophobia_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n009_0051,true,true,true))
endfunction

function Trig_Quest_Arachnophobia_Start_CinematicsOnKollin takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Arachnophobia_Start_FirstBoardEntry takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_Quest_Arachnophobia_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[3])
    if(Trig_Quest_Arachnophobia_Start_CinematicsOnKollin())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n009_0051,"Greetings, adventurers. You seem to be experienced warriors.",false)
        call Text_Say(gg_unit_n009_0051,"Allow me to welcome you here on behalf of the Hunt Club. We are an organization active all over Gaya, hunting down fiends and keeping the monster issues in check.",false)
        call Text_Say(gg_unit_n009_0051,"As of late, the monsters have grown more aggressive. It would be a great help if you could join our cause.",false)
        call Text_Say(gg_unit_n009_0051,"My current client is an arachnophobe. They hate, despise and fear spiders.",false)
        call Text_Say(gg_unit_n009_0051,"They sent in a request for us to kill 15 spiders. If you take on this job, I would reward you with gold.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"This sounds like a tempting offer. We will take care of these pests!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Arachnophobia|r")
    set udg_SideQuest[2]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffArachnophobia","Kollin, high elf in Kalm, asked you to kill 15 spiders.","ReplaceableTextures\\CommandButtons\\BTNSpiderGreen.blp")
    set udg_SpecialEffect[4]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n009_0051,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_Quest_Arachnophobia_Start_FirstBoardEntry())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[1]=$F // $F = 15
    set udg_HuntBoardLabel[1]="Spiders to kill"
    call LeaderboardAddItemBJ(Player(0),udg_HuntLeaderboard,udg_HuntBoardLabel[1],udg_HuntCounter[1])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(0),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(0),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_Quest_Arachnophobia_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Arachnophobia_Count_IsSpider takes nothing returns boolean
    return(GetUnitTypeId(GetDyingUnit())=='nspg')or(GetUnitTypeId(GetDyingUnit())=='nspb')or(GetUnitTypeId(GetDyingUnit())=='nspr')or(GetUnitTypeId(GetDyingUnit())=='nssp')or(GetUnitTypeId(GetDyingUnit())=='nsgt')or(GetUnitTypeId(GetDyingUnit())=='nsbm')or(GetUnitTypeId(GetDyingUnit())=='n010') // 'nspg': editor label "Forest Spider"; 'nspb': object name not found in map data; 'nspr': object name not found in map data; 'nssp': object name not found in map data; 'nsgt': object name not found in map data; 'nsbm': editor label "Brood Mother"; 'n010': unit "Vile Spider"
endfunction

function Trig_Quest_Arachnophobia_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_Quest_Arachnophobia_Count_IsSpider())
endfunction

function Trig_Quest_Arachnophobia_Count_NoBoardEntries takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_Quest_Arachnophobia_Count_AllSpidersKilled takes nothing returns boolean
    return(udg_HuntCounter[1]<=0)
endfunction

function Trig_Quest_Arachnophobia_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[1]=(udg_HuntCounter[1]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(0),udg_HuntLeaderboard,udg_HuntCounter[1])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_Quest_Arachnophobia_Count_AllSpidersKilled())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(0),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_Quest_Arachnophobia_Count_NoBoardEntries())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough spiders. Return to Kollin for a reward.\r\n")
        call QuestSetDescriptionBJ(udg_SideQuest[2],"Return to Kollin for reward.")
        call GroupAddUnitSimple(gg_unit_n009_0051,udg_BossUnits)
        call EnableTrigger(gg_trg_Quest_Arachnophobia_Reward)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Quest_Arachnophobia_Reward_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_Arachnophobia_Reward_CinematicsOnReward takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Arachnophobia_Reward_Actions takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[4])
    call GroupRemoveUnitSimple(gg_unit_n009_0051,udg_BossUnits)
    if(Trig_Quest_Arachnophobia_Reward_CinematicsOnReward())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n009_0051,0)
        call Text_Say(gg_unit_n009_0051,"You've done a good job clearing this quest. Here's your due reward.",false)
        call Reward_Give(600,400,gg_unit_n009_0051)
        call Text_Say(gg_unit_n009_0051,"I'm glad to welcome you as an honorary member of the Hunt Club. Some of my fellow members will gladly provide you with more jobs to do if you are willing to take them.",false)
        call Text_Say(gg_unit_n009_0051,"Also, the Hunt Club does both Common Game hunts and Rare Game hunts. If you are interested in partaking in Rare Game hunts, you may want to talk to members of ours you've already done a Common Game hunt for.",false)
        call Text_Say(gg_unit_n009_0051,"I currently am on the lookout for someone to hunt down a rare wolf. If you're interested in giving it a shot, come talk to me again, I'll tell you more about it.",false)
        call Cine_ExitAction()
    else
        call Reward_Give(600,400,gg_unit_n009_0051)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Arachnophobia|r")
    call QuestSetCompletedBJ(udg_SideQuest[2],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_n009_0051) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0B2',gg_unit_n009_0051,1,1) // 'n0B2': unit "Hunt: Thextera"
    set udg_HuntStock[1]=(udg_HuntStock[1]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call Wait_Polled(2)
    set udg_SpecialEffect[3]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0B3_0049,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_HarpyHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Arachnophobia takes nothing returns nothing
endfunction

endlibrary
