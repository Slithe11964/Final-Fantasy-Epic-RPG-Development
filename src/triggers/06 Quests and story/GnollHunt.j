library TGnollHunt requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
function Trig_GnollHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0BV_0229,true,true,true))
endfunction

function Trig_GnollHunt_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_GnollHunt_Start_IsFirstBoardEntry takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_GnollHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[73])
    if(Trig_GnollHunt_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0BV_0229,"Greetings, adventurers. I am Kiros. May I speak to you for a bit?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Kiros? Haven't seen you around here much.",false)
        call Text_Say(gg_unit_n0BV_0229,"I've only recently arrived here. After you reported the death of the previous Hunt Club representative of this region, I was dispatched to replace him.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh... my condolences.",false)
        call Text_Say(gg_unit_n0BV_0229,"We're quite shaken to have lost a valued member so suddenly. And as is tradition, we will initiate a retribution hunt shortly.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A retribution hunt?",false)
        call Text_Say(gg_unit_n0BV_0229,"You think we'll let those brutal gnolls get away with taking down one of our own? No way. By the time we're done with them they'll be scared to leave their caves.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. Good riddance. They are bloodthirsty monsters. They don't deserve any mercy.",false)
        call Text_Say(gg_unit_n0BV_0229,"Indeed. And on that note I was hoping to ask you to participate in our retribution hunt.",false)
        call Text_Say(gg_unit_n0BV_0229,"There's no kill count too high to attain justice for our fallen comrade. But every man can only hunt so many. If you kill 40 gnolls, we of the Hunt Club will be proud to reimburse you for doing your part in our project.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"40 gnolls? Should be a piece of cake.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Gnoll Hunt|r")
    set udg_SideQuest[54]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Gnoll Hunt"),"Kiros, newly appointed Farm representative of the Hunt Club, has asked you to take part in their retribution hunt for their fallen representative and kill 40 gnolls.","ReplaceableTextures\\CommandButtons\\BTNGnollWarden.blp")
    set udg_SpecialEffect[73]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BV_0229,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_GnollHunt_Start_IsFirstBoardEntry())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[5]=40
    set udg_HuntBoardLabel[5]="Gnolls to kill"
    call LeaderboardAddItemBJ(Player(4),udg_HuntLeaderboard,udg_HuntBoardLabel[5],udg_HuntCounter[5])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(4),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(4),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_GnollHunt_Count)
    call ConditionalTriggerExecute(gg_trg_PriestX_Appear)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GnollHunt_Count_IsGnollUnit takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='ngno')or(GetUnitTypeId(GetTriggerUnit())=='ngna')or(GetUnitTypeId(GetTriggerUnit())=='ngns')or(GetUnitTypeId(GetTriggerUnit())=='ngnw')or(GetUnitTypeId(GetTriggerUnit())=='ngnv') // 'ngno': object name not found in map data; 'ngna': object name not found in map data; 'ngns': object name not found in map data; 'ngnw': object name not found in map data; 'ngnv': object name not found in map data
endfunction

function Trig_GnollHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_GnollHunt_Count_IsGnollUnit())
endfunction

function Trig_GnollHunt_Count_NoQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_GnollHunt_Count_IsCountDone takes nothing returns boolean
    return(udg_HuntCounter[5]<=0)
endfunction

function Trig_GnollHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[5]=(udg_HuntCounter[5]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(4),udg_HuntLeaderboard,udg_HuntCounter[5])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_GnollHunt_Count_IsCountDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(4),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_GnollHunt_Count_NoQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough gnolls. Return to Kiros for a reward.")
        call QuestSetDescriptionBJ(udg_SideQuest[54],"Return to Kiros for a reward.")
        call GroupAddUnitSimple(gg_unit_n0BV_0229,udg_BossUnits)
        call EnableTrigger(gg_trg_GnollHunt_Reward)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_GnollHunt_Reward_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_GnollHunt_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_GnollHunt_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[73])
    call GroupRemoveUnitSimple(gg_unit_n0BV_0229,udg_BossUnits)
    if(Trig_GnollHunt_Reward_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0BV_0229,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"It is done. 40 more gnolls are history.",false)
        call Text_Say(gg_unit_n0BV_0229,"You've done great work. We will continue the retribution from here.",false)
        call Reward_Give($DAC,$9C4,gg_unit_n0BV_0229) // $DAC = 3500; $9C4 = 2500
        call Cine_ExitAction()
    else
        call Reward_Give($DAC,$9C4,gg_unit_n0BV_0229) // $DAC = 3500; $9C4 = 2500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Gnoll Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[54],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_n0BV_0229) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0C5',gg_unit_n0BV_0229,1,1) // 'n0C5': unit "Hunt: Cu Chulainn"
    set udg_HuntStock[5]=(udg_HuntStock[5]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_GnollHunt automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_GnollHunt (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_GnollHunt takes nothing returns nothing
endfunction

function Register_GnollHunt_Start takes nothing returns nothing
    set gg_trg_GnollHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_GnollHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_GnollHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_GnollHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_GnollHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_GnollHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_GnollHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_GnollHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_GnollHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_GnollHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_GnollHunt_Start,Condition(function Trig_GnollHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_GnollHunt_Start,function Trig_GnollHunt_Start_Actions)
endfunction

function Register_GnollHunt_Count takes nothing returns nothing
    set gg_trg_GnollHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_GnollHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_GnollHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_GnollHunt_Count,Condition(function Trig_GnollHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_GnollHunt_Count,function Trig_GnollHunt_Count_Actions)
endfunction

function Register_GnollHunt_Reward takes nothing returns nothing
    set gg_trg_GnollHunt_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_GnollHunt_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_GnollHunt_Reward,450.,gg_unit_n0BV_0229)
    call TriggerAddCondition(gg_trg_GnollHunt_Reward,Condition(function Trig_GnollHunt_Reward_Conditions))
    call TriggerAddAction(gg_trg_GnollHunt_Reward,function Trig_GnollHunt_Reward_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_GnollHunt takes nothing returns nothing
    call Register_GnollHunt_Start()
    call Register_GnollHunt_Count()
    call Register_GnollHunt_Reward()
endfunction

endlibrary
