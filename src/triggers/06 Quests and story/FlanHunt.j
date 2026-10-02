library TFlanHunt requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
function Trig_FlanHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e014_0149,true,true,true))
endfunction

function Trig_FlanHunt_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_FlanHunt_Start_IsFirstBoardEntry takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_FlanHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[74])
    if(Trig_FlanHunt_Start_IsDialogueOn())then
        call PauseUnitBJ(true,gg_unit_e014_0149)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e014_0149,"Greetings to you, rare guests. My name is Olga, and I am Lady Dana's first ranger. I have heard about your arrival in our village. We haven't had a visitor in a long time.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah makes sense. You're not exactly in contact much with the outside world, are you?",false)
        call Text_Say(gg_unit_e014_0149,"We are not. However do not pity us. We have all we need, and all of us are intimately familiar with this world. Our days of adventuring and traveling are long past us.",false)
        call Text_Say(gg_unit_e014_0149,"Besides, we have a purpose here. Being on 'this side' allows us to work to keep the world in balance. Such is the important work bestowed on us by our lords, the Lady Dana and her ally, Famfrit.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. It seems you have all you could ask for.",false)
        call Text_Say(gg_unit_e014_0149,"Well as long as you are here, there is something I have to ask of you.",false)
        call Text_Say(gg_unit_e014_0149,"There are pests on 'your side' whose taint slowly creeps into the core of the world itself. It manifests itself as a sort of black slime.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You mean flans?",false)
        call Text_Say(gg_unit_e014_0149,"Yes. Back when we were still in Lothlorien it was my duty as its first ranger to oversee their hunt, but I cannot do that anymore. It is outside of our jurisdiction, but I'd like to ask you to do what I no longer can.",false)
        call Text_Say(gg_unit_e014_0149,"You must be quite strong if you managed to make it here. If you can kill 20 flans, I'd be most grateful, and I'll have Lady Dana see that you are rewarded for your efforts.",false)
        call Text_Say(gg_unit_e014_0149,"Of course I'm sure you're aware, but physical attacks won't do much against them. You must use magic if you wish to affect them.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds good to me. We'll have those pests cut down in no time!",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_e014_0149)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Flan Hunt|r")
    set udg_SideQuest[55]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Flan Hunt"),"Olga from the Phantom Village has asked you to clean 20 flans off the face of Gaya.","ReplaceableTextures\\CommandButtons\\BTNSludgeCreature.blp")
    set udg_SpecialEffect[74]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e014_0149,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_FlanHunt_Start_IsFirstBoardEntry())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[6]=20
    set udg_HuntBoardLabel[6]="Flans to kill"
    call LeaderboardAddItemBJ(Player(5),udg_HuntLeaderboard,udg_HuntBoardLabel[6],udg_HuntCounter[6])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(5),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(5),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_FlanHunt_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_FlanHunt_Count_IsFlanUnit takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n01P')or(GetUnitTypeId(GetTriggerUnit())=='n01O')or(GetUnitTypeId(GetTriggerUnit())=='n01Q')or(GetUnitTypeId(GetTriggerUnit())=='n01N')or(GetUnitTypeId(GetTriggerUnit())=='n042') // 'n01P': unit "Lesser Flan"; 'n01O': unit "Flan"; 'n01Q': unit "Aqua Flan"; 'n01N': unit "Greater Flan"; 'n042': unit "Dark Flan"
endfunction

function Trig_FlanHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_FlanHunt_Count_IsFlanUnit())
endfunction

function Trig_FlanHunt_Count_NoQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_FlanHunt_Count_IsCountDone takes nothing returns boolean
    return(udg_HuntCounter[6]<=0)
endfunction

function Trig_FlanHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[6]=(udg_HuntCounter[6]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(5),udg_HuntLeaderboard,udg_HuntCounter[6])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_FlanHunt_Count_IsCountDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(5),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_FlanHunt_Count_NoQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough flans. Return to Olga for a reward.")
        call QuestSetDescriptionBJ(udg_SideQuest[55],"Return to Olga for a reward.")
        call GroupAddUnitSimple(gg_unit_e014_0149,udg_BossUnits)
        call EnableTrigger(gg_trg_FlanHunt_Reward)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_FlanHunt_Fail_NoQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_FlanHunt_Fail_IsCountPending takes nothing returns boolean
    return(udg_HuntCounter[6]>0)
endfunction

function Trig_FlanHunt_Fail_Actions takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[74])
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Flan Hunt|r")
    call QuestSetFailedBJ(udg_SideQuest[55],true)
    if(Trig_FlanHunt_Fail_IsCountPending())then
        call DisableTrigger(gg_trg_FlanHunt_Count)
        set udg_HuntCounter[6]=0
        call LeaderboardRemovePlayerItemBJ(Player(5),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_FlanHunt_Fail_NoQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call DestroyTrigger(gg_trg_FlanHunt_Count)
    else
        call GroupRemoveUnitSimple(gg_unit_e014_0149,udg_BossUnits)
    endif
    call DestroyTrigger(gg_trg_FlanHunt_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_FlanHunt_Reward_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false)and(IsUnitVisible(gg_unit_e014_0149,GetOwningPlayer(GetTriggerUnit()))))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_FlanHunt_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_FlanHunt_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[74])
    call GroupRemoveUnitSimple(gg_unit_e014_0149,udg_BossUnits)
    if(Trig_FlanHunt_Reward_IsDialogueOn())then
        call PauseUnitBJ(true,gg_unit_e014_0149)
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e014_0149,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We've killed 20 flans, as you asked.",false)
        call Text_Say(gg_unit_e014_0149,"You have my gratitude. This should help keep the world in further balance.",false)
        call Reward_Give($FA0,$DAC,gg_unit_e014_0149) // $FA0 = 4000; $DAC = 3500
        call Text_Say(gg_unit_e014_0149,"I'm also afraid that some fiends from our side have crossed over to your world of late. If I could ask you to help us out some more in exterminating these dangers, come speak to me some more.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_e014_0149)
    else
        call Reward_Give($FA0,$DAC,gg_unit_e014_0149) // $FA0 = 4000; $DAC = 3500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Flan Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[55],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_PhantomVillagersMet=(udg_PhantomVillagersMet+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_e014_0149) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0C4',gg_unit_e014_0149,1,1) // 'n0C4': unit "Hunt: Arahabaki"
    set udg_HuntStock[6]=(udg_HuntStock[6]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(gg_trg_FlanHunt_Fail)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_FlanHunt takes nothing returns nothing
endfunction
function RegisterR11_FlanHunt_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_FlanHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_FlanHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_FlanHunt_Start,Condition(function Trig_FlanHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_FlanHunt_Start,function Trig_FlanHunt_Start_Actions)
endfunction
function RegisterR11_FlanHunt_Count takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_FlanHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_FlanHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_FlanHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_FlanHunt_Count,Condition(function Trig_FlanHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_FlanHunt_Count,function Trig_FlanHunt_Count_Actions)
endfunction
function RegisterR11_FlanHunt_Fail takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_FlanHunt_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_FlanHunt_Fail)
    call TriggerAddAction(gg_trg_FlanHunt_Fail,function Trig_FlanHunt_Fail_Actions)
endfunction
function RegisterR11_FlanHunt_Reward takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_FlanHunt_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_FlanHunt_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_FlanHunt_Reward,200.,gg_unit_e014_0149)
    call TriggerRegisterUnitInRangeSimple(gg_trg_FlanHunt_Reward,450.,gg_unit_e014_0149)
    call TriggerAddCondition(gg_trg_FlanHunt_Reward,Condition(function Trig_FlanHunt_Reward_Conditions))
    call TriggerAddAction(gg_trg_FlanHunt_Reward,function Trig_FlanHunt_Reward_Actions)
endfunction




endlibrary
