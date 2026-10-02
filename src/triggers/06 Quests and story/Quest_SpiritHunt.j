library TQuestSpiritHunt requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_SpiritHunt_Start=null
    trigger gg_trg_Quest_SpiritHunt_Count=null
    trigger gg_trg_Quest_SpiritHunt_Complete=null
endglobals

function Trig_Quest_SpiritHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_nsw2_0056,true,true,true))
endfunction

function Trig_Quest_SpiritHunt_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SpiritHunt_Start_Cond_FirstBoardQuest takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_Quest_SpiritHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[9])
    if(Trig_Quest_SpiritHunt_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_nsw2_0056,"Hello adventurers. I have a task for you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You do? What do you want from us?",false)
        call Text_Say(gg_unit_nsw2_0056,"Something rather unprecedented has occurred. A great number of evil spirits have invaded this world and they are posing quite a problem.",false)
        call Text_Say(gg_unit_nsw2_0056,"These spirits are not the souls of the dead. They are manifestations of chaos and envy and sow a dark madness among the beasts they intermingle with, causing more of them to manifest in turn. They are a parasitic existence that threatens the world's very balance.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That sounds very dangerous. They just suddenly appeared?",false)
        call Text_Say(gg_unit_nsw2_0056,"They are not native to Gaya. I am unsure where they came from but it is best we try and rid them before this grows out of hand.",false)
        call Text_Say(gg_unit_nsw2_0056,"At the very least I want you to kill 20 of these spirits and report back to me if their spread shows any signs of stopping.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That won't be a problem. We'll take care of these evil spirits.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Spirit Hunt|r")
    set udg_SideQuest[73]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Spirit Hunt"),"Frakir, a planeswalker residing in Kalm, has asked you to destroy 20 evil spirits.","ReplaceableTextures\\CommandButtons\\BTNShade.blp")
    set udg_SpecialEffect[9]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nsw2_0056,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_Quest_SpiritHunt_Start_Cond_FirstBoardQuest())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[$A]=20 // $A = 10
    set udg_HuntBoardLabel[$A]="Spirits to kill" // $A = 10
    call LeaderboardAddItemBJ(Player(9),udg_HuntLeaderboard,udg_HuntBoardLabel[$A],udg_HuntCounter[$A]) // $A = 10
    call LeaderboardSetPlayerItemLabelColorBJ(Player(9),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(9),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_Quest_SpiritHunt_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SpiritHunt_Count_Cond_IsEvilSpirit takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='nrvd')or(GetUnitTypeId(GetTriggerUnit())=='nvdg') // 'nrvd': unit "Etem"; 'nvdg': unit "Evil Spirit"
endfunction

function Trig_Quest_SpiritHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_Quest_SpiritHunt_Count_Cond_IsEvilSpirit())
endfunction

function Trig_Quest_SpiritHunt_Count_Cond_NoBoardQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_Quest_SpiritHunt_Count_Cond_AllSpiritsKilled takes nothing returns boolean
    return(udg_HuntCounter[$A]<=0) // $A = 10
endfunction

function Trig_Quest_SpiritHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[$A]=(udg_HuntCounter[$A]-1) // $A = 10
    call LeaderboardSetPlayerItemValueBJ(Player(9),udg_HuntLeaderboard,udg_HuntCounter[$A]) // $A = 10
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_Quest_SpiritHunt_Count_Cond_AllSpiritsKilled())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(9),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_Quest_SpiritHunt_Count_Cond_NoBoardQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough spirits. Return to Frakir for a reward.")
        call QuestSetDescriptionBJ(udg_SideQuest[73],"Return to Frakir for a reward.")
        call GroupAddUnitSimple(gg_unit_nsw2_0056,udg_BossUnits)
        call EnableTrigger(gg_trg_Quest_SpiritHunt_Complete)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Quest_SpiritHunt_Complete_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_SpiritHunt_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SpiritHunt_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[9])
    call GroupRemoveUnitSimple(gg_unit_nsw2_0056,udg_BossUnits)
    if(Trig_Quest_SpiritHunt_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_nsw2_0056,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"There truly are many evil spirits around these days. Their numbers do not seem to be dwindling but we have slain 20 of them as you asked.",false)
        call Text_Say(gg_unit_nsw2_0056,"The spirits may continue to be a problem, but this is all I could ask for already. We might need to find a way of keeping them from entering this world entirely.",false)
        call Text_Say(gg_unit_nsw2_0056,"It feels as though things have only gotten worse lately. But you have been instrumental in fighting these calamities. Here, have some gold for your future travels.",false)
        call Reward_Give(6500,6000,gg_unit_nsw2_0056)
        call Cine_ExitAction()
    else
        call Reward_Give(6500,6000,gg_unit_nsw2_0056)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Spirit Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[73],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_nsw2_0056) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0BE',gg_unit_nsw2_0056,1,1) // 'n0BE': unit "Hunt: Tonberry"
    set udg_HuntStock[$A]=(udg_HuntStock[$A]+1) // $A = 10
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_SpiritHunt takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part21 (module Quest),
// which keeps the original registration order.

function Register_Quest_SpiritHunt_Start takes nothing returns nothing
    set gg_trg_Quest_SpiritHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SpiritHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_SpiritHunt_Start,Condition(function Trig_Quest_SpiritHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_SpiritHunt_Start,function Trig_Quest_SpiritHunt_Start_Actions)
endfunction

function Register_Quest_SpiritHunt_Count takes nothing returns nothing
    set gg_trg_Quest_SpiritHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SpiritHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_SpiritHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Quest_SpiritHunt_Count,Condition(function Trig_Quest_SpiritHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_Quest_SpiritHunt_Count,function Trig_Quest_SpiritHunt_Count_Actions)
endfunction

function Register_Quest_SpiritHunt_Complete takes nothing returns nothing
    set gg_trg_Quest_SpiritHunt_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SpiritHunt_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SpiritHunt_Complete,450.,gg_unit_nsw2_0056)
    call TriggerAddCondition(gg_trg_Quest_SpiritHunt_Complete,Condition(function Trig_Quest_SpiritHunt_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_SpiritHunt_Complete,function Trig_Quest_SpiritHunt_Complete_Actions)
endfunction

endlibrary
