library TWendigoHunt requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_WendigoHunt_Start=null
    trigger gg_trg_WendigoHunt_Count=null
    trigger gg_trg_WendigoHunt_Reward=null
endglobals

function Trig_WendigoHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h030_0243,true,true,true))
endfunction

function Trig_WendigoHunt_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_WendigoHunt_Start_IsFirstBoardEntry takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_WendigoHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[76])
    if(Trig_WendigoHunt_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h030_0243,"The gate is open at last... didn't think I'd get to see it happen. We've been trying to make it happen for so long.",false)
        call Text_Say(gg_unit_h030_0243,"Scouring ancient texts from elves and the Seekers order... to no avail. But now you've opened it at last. On behalf of our club, I express my gratitude.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Are you a member of the Hunt Club?",false)
        call Text_Say(gg_unit_h030_0243,"That I am. Ward is my name. You are intent on exploring the icy realm straight away, right?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's the plan, yes.",false)
        call Text_Say(gg_unit_h030_0243,"We of the Hunt Club will surely mobilize an expedition ourselves soon. But if you are going in straight away, I'd greatly appreciate you helping us in gathering information. Of course I'll put a bounty on it.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds good to me. What do you want us to do?",false)
        call Text_Say(gg_unit_h030_0243,"It seems this icy realm is populated by a number of species, but most interesting to us are the Wendigos. If you could slay 30 of them and report your findings, that would do nicely.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, we'll have the info you want in no time.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Wendigo Hunt|r")
    set udg_SideQuest[57]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Wendigo Hunt"),"Ward of the Hunt Club has asked you to kill 30 wendigos to be able to study and give a report on them.","ReplaceableTextures\\CommandButtons\\BTNWendigo.blp")
    set udg_SpecialEffect[76]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h030_0243,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_WendigoHunt_Start_IsFirstBoardEntry())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[8]=30
    set udg_HuntBoardLabel[8]="Wendigos to kill"
    call LeaderboardAddItemBJ(Player(7),udg_HuntLeaderboard,udg_HuntBoardLabel[8],udg_HuntCounter[8])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(7),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(7),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_WendigoHunt_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_WendigoHunt_Count_IsWendigoUnit takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n027')or(GetUnitTypeId(GetTriggerUnit())=='n025')or(GetUnitTypeId(GetTriggerUnit())=='n026')or(GetUnitTypeId(GetTriggerUnit())=='n0MQ') // 'n027': unit "Elder Wendigo"; 'n025': unit "Wendigo Shaman"; 'n026': unit "Wendigo"; 'n0MQ': unit "Wendigo Berserker"
endfunction

function Trig_WendigoHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_WendigoHunt_Count_IsWendigoUnit())
endfunction

function Trig_WendigoHunt_Count_NoQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_WendigoHunt_Count_IsCountDone takes nothing returns boolean
    return(udg_HuntCounter[8]<=0)
endfunction

function Trig_WendigoHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[8]=(udg_HuntCounter[8]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(7),udg_HuntLeaderboard,udg_HuntCounter[8])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_WendigoHunt_Count_IsCountDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(7),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_WendigoHunt_Count_NoQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough wendigos. Return to Ward for a reward.")
        call QuestSetDescriptionBJ(udg_SideQuest[57],"Return to Ward for a reward.")
        call GroupAddUnitSimple(gg_unit_h030_0243,udg_BossUnits)
        call EnableTrigger(gg_trg_WendigoHunt_Reward)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_WendigoHunt_Reward_Conditions takes nothing returns boolean
    return((IsUnitHiddenBJ(gg_unit_h030_0243)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_WendigoHunt_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_WendigoHunt_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[76])
    call GroupRemoveUnitSimple(gg_unit_h030_0243,udg_BossUnits)
    if(Trig_WendigoHunt_Reward_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h030_0243,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We've gathered the data you wanted.\r\n\r\n|cffffcc00The hero gives a report on their fights with wendigos.|r",false)
        call Text_Say(gg_unit_h030_0243,"This is good information. Should help our hunters deal with these beasts more easily. Here's your reward, as promised.",false)
        call Reward_Give(6000,5000,gg_unit_h030_0243)
        call Cine_ExitAction()
    else
        call Reward_Give(6000,5000,gg_unit_h030_0243)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Wendigo Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[57],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_h030_0243) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0MB',gg_unit_h030_0243,1,1) // 'n0MB': unit "Hunt: Umaro"
    set udg_HuntStock[8]=(udg_HuntStock[8]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_WendigoHunt automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_WendigoHunt (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_WendigoHunt takes nothing returns nothing
endfunction

function Register_WendigoHunt_Start takes nothing returns nothing
    set gg_trg_WendigoHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_WendigoHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_WendigoHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_WendigoHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_WendigoHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_WendigoHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_WendigoHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_WendigoHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_WendigoHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_WendigoHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_WendigoHunt_Start,Condition(function Trig_WendigoHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_WendigoHunt_Start,function Trig_WendigoHunt_Start_Actions)
endfunction

function Register_WendigoHunt_Count takes nothing returns nothing
    set gg_trg_WendigoHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_WendigoHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_WendigoHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_WendigoHunt_Count,Condition(function Trig_WendigoHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_WendigoHunt_Count,function Trig_WendigoHunt_Count_Actions)
endfunction

function Register_WendigoHunt_Reward takes nothing returns nothing
    set gg_trg_WendigoHunt_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_WendigoHunt_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_WendigoHunt_Reward,450.,gg_unit_h030_0243)
    call TriggerAddCondition(gg_trg_WendigoHunt_Reward,Condition(function Trig_WendigoHunt_Reward_Conditions))
    call TriggerAddAction(gg_trg_WendigoHunt_Reward,function Trig_WendigoHunt_Reward_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_WendigoHunt takes nothing returns nothing
    call Register_WendigoHunt_Start()
    call Register_WendigoHunt_Count()
    call Register_WendigoHunt_Reward()
endfunction

endlibrary
