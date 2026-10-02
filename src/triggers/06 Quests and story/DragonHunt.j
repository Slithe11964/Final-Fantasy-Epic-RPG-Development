library TDragonHunt requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DragonHunt_Start=null
    trigger gg_trg_DragonHunt_Count=null
    trigger gg_trg_DragonHunt_Reward=null
endglobals

function Trig_DragonHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h032_0007,true,true,true))
endfunction

function Trig_DragonHunt_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DragonHunt_Start_IsFirstBoardEntry takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_DragonHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[84])
    if(Trig_DragonHunt_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h032_0007,"Greetings once more. You've done a lot of good work for the club and proven your strength considerably. As such I have a special task for you.",false)
        call Text_Say(gg_unit_h032_0007,"There is a region of Gaya the Hunt Club has not dared venture into as of yet. The dark marshes in the southwest, populated by dragons.",false)
        call Text_Say(gg_unit_h032_0007,"They are highly dangerous and powerful. Even our best fighters would not hold out against them. But you just might be able to.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds like a dangerous task. I expect the reward will be worth the risk?",false)
        call Text_Say(gg_unit_h032_0007,"Of course. Gaining control of the area is one of the major goals of our club. If you can hold your own and exterminate at least 30 dragons living there, you will be handsomely rewarded.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We fear no dragons. We shall slay as many as we need to.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Dragon Hunt|r")
    set udg_SideQuest[63]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Dragon Hunt"),"Ma'kenroh, sage of the Hunt Club, tasked you to kill 30 dragons in the Dark Dragon Marsh.","ReplaceableTextures\\CommandButtons\\BTNBlackDragon.blp")
    set udg_SpecialEffect[84]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h032_0007,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_DragonHunt_Start_IsFirstBoardEntry())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[9]=30
    set udg_HuntBoardLabel[9]="Dragons to kill"
    call LeaderboardAddItemBJ(Player(8),udg_HuntLeaderboard,udg_HuntBoardLabel[9],udg_HuntCounter[9])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(8),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(8),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_DragonHunt_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DragonHunt_Count_IsDragonUnit takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n03G')or(GetUnitTypeId(GetTriggerUnit())=='n03H')or(GetUnitTypeId(GetTriggerUnit())=='n03F')or(GetUnitTypeId(GetTriggerUnit())=='n03E') // 'n03G': unit "Dusk Wyrm"; 'n03H': unit "Black Dragon"; 'n03F': unit "Marsh Whelp"; 'n03E': unit "Nether Drake"
endfunction

function Trig_DragonHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_DragonHunt_Count_IsDragonUnit())
endfunction

function Trig_DragonHunt_Count_NoQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_DragonHunt_Count_IsCountDone takes nothing returns boolean
    return(udg_HuntCounter[9]<=0)
endfunction

function Trig_DragonHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[9]=(udg_HuntCounter[9]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(8),udg_HuntLeaderboard,udg_HuntCounter[9])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_DragonHunt_Count_IsCountDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(8),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_DragonHunt_Count_NoQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough dragons. Return to Ma'kenroh for a reward.")
        call QuestSetDescriptionBJ(udg_SideQuest[63],"Return to Ma'kenroh for a reward.")
        call GroupAddUnitSimple(gg_unit_h032_0007,udg_BossUnits)
        call EnableTrigger(gg_trg_DragonHunt_Reward)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_DragonHunt_Reward_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DragonHunt_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DragonHunt_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[84])
    call GroupRemoveUnitSimple(gg_unit_h032_0007,udg_BossUnits)
    if(Trig_DragonHunt_Reward_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h032_0007,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Those dragons are seriously powerful! But we did manage to kill 30 of them in the end.",false)
        call Text_Say(gg_unit_h032_0007,"I am most impressed and thankful. Take this, you've certainly earned it.",false)
        call Reward_Give(8000,8000,gg_unit_h032_0007)
        call Text_Say(gg_unit_h032_0007,"Maybe you will be the one to take down our club's primary target after all... but that is for Montblanc to decide.",false)
        call Cine_ExitAction()
    else
        call Reward_Give(8000,8000,gg_unit_h032_0007)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Dragon Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[63],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call EnableTrigger(gg_trg_Montblanc_Hint_Timer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DragonHunt automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DragonHunt (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DragonHunt takes nothing returns nothing
endfunction

function Register_DragonHunt_Start takes nothing returns nothing
    set gg_trg_DragonHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_DragonHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_DragonHunt_Start,Condition(function Trig_DragonHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_DragonHunt_Start,function Trig_DragonHunt_Start_Actions)
endfunction

function Register_DragonHunt_Count takes nothing returns nothing
    set gg_trg_DragonHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_DragonHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_DragonHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_DragonHunt_Count,Condition(function Trig_DragonHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_DragonHunt_Count,function Trig_DragonHunt_Count_Actions)
endfunction

function Register_DragonHunt_Reward takes nothing returns nothing
    set gg_trg_DragonHunt_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_DragonHunt_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_DragonHunt_Reward,450.,gg_unit_h032_0007)
    call TriggerAddCondition(gg_trg_DragonHunt_Reward,Condition(function Trig_DragonHunt_Reward_Conditions))
    call TriggerAddAction(gg_trg_DragonHunt_Reward,function Trig_DragonHunt_Reward_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DragonHunt takes nothing returns nothing
    call Register_DragonHunt_Start() // starts off; enabled by Makenroh
    call Register_DragonHunt_Count() // starts off; enabled by DragonHunt
    call Register_DragonHunt_Reward() // starts off; enabled by DragonHunt
endfunction

endlibrary
