library TAncientHunt requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
function Trig_AncientHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e012_0227,true,true,true))
endfunction

function Trig_AncientHunt_Start_HasHuntHistory takes nothing returns boolean
    return(udg_CommonHuntsDone>0)
endfunction

function Trig_AncientHunt_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_AncientHunt_Start_IsFirstBoardEntry takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_AncientHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[75])
    if(Trig_AncientHunt_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e012_0227,"Hello, I would like to speak with you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, what is it?",false)
        call Text_Say(gg_unit_e012_0227,"One of the few strong ties between us night elves and the humans is that we cooperate and exchange information in the Hunt Club. It is the only organization in the world with both humans and night elves taking part.",false)
        call Text_Say(gg_unit_e012_0227,"And I've heard that you've become something of a member of the club, is that right?",false)
        if(Trig_AncientHunt_Start_HasHuntHistory())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes we have. If you have a hunt for us to do and you're willing to pay for the job, we'll be glad to help.",false)
            call Text_Say(gg_unit_e012_0227,"Excellent. That's exactly what I wanted to ask.",false)
        else
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"No we actually haven't. We've merely helped out the head of Kalm personally, no involvement in the club itself. But if you have a hunt for us to do and you're willing to pay for the job, we'll be glad to help.",false)
            call Text_Say(gg_unit_e012_0227,"I see. And yes, that's exactly what I wanted to ask.",false)
        endif
        call Text_Say(gg_unit_e012_0227,"With the global increase in monster activity, the forest outside our gates has become more tainted than ever. It has become extremely dangerous even for our own rangers.",false)
        call Text_Say(gg_unit_e012_0227,"In order to keep the taint of our woods in check we sometimes go out and destroy corrupted ancients. However recently we've been unable to do that and their numbers are growing. If this goes on we might all be in danger and the forest will become impassable.",false)
        call Text_Say(gg_unit_e012_0227,"You seem strong however, so I'd like to ask you if you could take down 20 Ancients. That should keep the taint at bay for a while.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Worry not. We will ease the forest's corruption.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Ancient Hunt|r")
    set udg_SideQuest[56]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Ancient Hunt"),"Krjn from Lothlorien has asked you to kill 20 Ancients to decelerate the corruption in the forest.","ReplaceableTextures\\CommandButtons\\BTNCorruptedTreeOfLife.blp")
    set udg_SpecialEffect[75]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e012_0227,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_NaishaTownUnit=gg_unit_e012_0227
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_AncientHunt_Start_IsFirstBoardEntry())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[7]=20
    set udg_HuntBoardLabel[7]="Ancients to kill"
    call LeaderboardAddItemBJ(Player(6),udg_HuntLeaderboard,udg_HuntBoardLabel[7],udg_HuntCounter[7])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(6),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(6),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_AncientHunt_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_AncientHunt_Count_IsAncientUnit takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='nenp')or(GetUnitTypeId(GetTriggerUnit())=='nepl')or(GetUnitTypeId(GetTriggerUnit())=='nenc')or(GetUnitTypeId(GetTriggerUnit())=='n00P')or(GetUnitTypeId(GetTriggerUnit())=='n00N')or(GetUnitTypeId(GetTriggerUnit())=='n00O') // 'nenp': editor label "Poison Treant"; 'nepl': editor label "Plague Treant"; 'nenc': editor label "Corrupted Treant"; 'n00P': unit "Corrupted Tree of Life"; 'n00N': unit "Corrupted Ancient of War"; 'n00O': unit "Corrupted Ancient Protector"
endfunction

function Trig_AncientHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_AncientHunt_Count_IsAncientUnit())
endfunction

function Trig_AncientHunt_Count_NoQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_AncientHunt_Count_IsCountDone takes nothing returns boolean
    return(udg_HuntCounter[7]<=0)
endfunction

function Trig_AncientHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[7]=(udg_HuntCounter[7]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(6),udg_HuntLeaderboard,udg_HuntCounter[7])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_AncientHunt_Count_IsCountDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(6),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_AncientHunt_Count_NoQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough ancients. Return to Krjn for a reward.")
        call QuestSetDescriptionBJ(udg_SideQuest[56],"Return to Krjn for a reward.")
        call GroupAddUnitSimple(gg_unit_e012_0227,udg_BossUnits)
        call EnableTrigger(gg_trg_AncientHunt_Reward)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_AncientHunt_Reward_Conditions takes nothing returns boolean
    return((IsUnitHiddenBJ(gg_unit_e012_0227)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_AncientHunt_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_AncientHunt_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[75])
    call GroupRemoveUnitSimple(gg_unit_e012_0227,udg_BossUnits)
    if(Trig_AncientHunt_Reward_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e012_0227,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We're back. We've slain the Ancients you asked us to.",false)
        call Text_Say(gg_unit_e012_0227,"Amazing! Thank you for your efforts. Here's your just reward.",false)
        call Reward_Give($BB8,$BB8,gg_unit_e012_0227) // $BB8 = 3000
        call Text_Say(gg_unit_e012_0227,"By the way, you've surely noticed as you were fighting, the corruption of the forest has even taken over the spirits of the forest itself?",false)
        call Text_Say(gg_unit_e012_0227,"They float around and empower enemies and weaken you when you're nearby. And to make things worse they generally gather around any fights that break out.",false)
        call Text_Say(gg_unit_e012_0227,"Lady Dana was in tune with them when she was still around, which made them powerful allies. But now they are against us. There must be some way to cleanse these spirits and return them to our side...",false)
        call Text_Say(gg_unit_e012_0227,"Well apologies for rambling. Do speak to me if you wish to do some rare game hunts for the club.",false)
        call Cine_ExitAction()
    else
        call Reward_Give($BB8,$BB8,gg_unit_e012_0227) // $BB8 = 3000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Ancient Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[56],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_e012_0227) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0CN',gg_unit_e012_0227,1,1) // 'n0CN': unit "Hunt: Exdeath"
    set udg_HuntStock[7]=(udg_HuntStock[7]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_AncientHunt takes nothing returns nothing
endfunction
function RegisterR11_AncientHunt_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AncientHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_AncientHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_AncientHunt_Start,Condition(function Trig_AncientHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_AncientHunt_Start,function Trig_AncientHunt_Start_Actions)
endfunction
function RegisterR11_AncientHunt_Count takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AncientHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_AncientHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_AncientHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_AncientHunt_Count,Condition(function Trig_AncientHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_AncientHunt_Count,function Trig_AncientHunt_Count_Actions)
endfunction
function RegisterR11_AncientHunt_Reward takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AncientHunt_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_AncientHunt_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_AncientHunt_Reward,450.,gg_unit_e012_0227)
    call TriggerAddCondition(gg_trg_AncientHunt_Reward,Condition(function Trig_AncientHunt_Reward_Conditions))
    call TriggerAddAction(gg_trg_AncientHunt_Reward,function Trig_AncientHunt_Reward_Actions)
endfunction




endlibrary
