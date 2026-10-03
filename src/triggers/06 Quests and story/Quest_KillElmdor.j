library TQuestKillElmdor requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_KillElmdor_Init=null
    trigger gg_trg_Quest_KillElmdor_Available=null
    trigger gg_trg_Quest_KillElmdor_Start=null
    trigger gg_trg_Quest_KillElmdor_Slain=null
    trigger gg_trg_Quest_KillElmdor_Complete=null
endglobals

function Trig_Quest_KillElmdor_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_Nbbc_0006)
    call PauseUnitBJ(true,gg_unit_Nbbc_0006)
    call SetUnitInvulnerable(gg_unit_Nbbc_0006,true)
    call PauseUnitBJ(true,gg_unit_h007_0089)
    call UnitAddAbilityBJ('A0VJ',gg_unit_h007_0089) // 'A0VJ': ability "Unaffected by Cinematics"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillElmdor_Available_Actions takes nothing returns nothing
    set udg_SpecialEffect[$F]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h007_0089,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl") // $F = 15
    call EnableTrigger(gg_trg_Quest_KillElmdor_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillElmdor_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h007_0089,true,true,true))
endfunction

function Trig_Quest_KillElmdor_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_KillElmdor_Start_Cond_InfoNotStocked takes nothing returns boolean
    return(udg_QuestFlag[2]==false)
endfunction

function Trig_Quest_KillElmdor_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[$F]) // $F = 15
    if(Trig_Quest_KillElmdor_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h007_0089,"Greetings. My name is Biggs and I am the captain here.",false)
        call Text_Say(gg_unit_h007_0089,"So, you're adventurers, right? Well, if you are strong enough you may try to kill Elmdor the Corrupted Samurai. He caused many troubles lately and I will pay handsomely for his death.",false)
        call Text_Say(gg_unit_h007_0089,"I don't know where he came from but he killed two of my people and I want him dead. Do that - and the reward will be generous.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"His life is forfeit.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Kill Elmdor|r")
    set udg_SideQuest[6]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffKill Elmdor","Biggs, captain in Kalm, promised reward for killing Elmdor the Corrupted Samurai.","ReplaceableTextures\\CommandButtons\\BTNChaosBlademaster.blp")
    set udg_SpecialEffect[16]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h007_0089,"Objects\\RandomObject\\RandomObject.mdl")
    call ShowUnitShow(gg_unit_Nbbc_0006)
    call PauseUnitBJ(false,gg_unit_Nbbc_0006)
    call SetUnitInvulnerable(gg_unit_Nbbc_0006,false)
    call GroupAddUnitSimple(gg_unit_Nbbc_0006,udg_BossUnits)
    call EnableTrigger(gg_trg_Quest_KillElmdor_Slain)
    if(Trig_Quest_KillElmdor_Start_Cond_InfoNotStocked())then
        call AddItemToStockBJ('I05E',gg_unit_n02Y_0052,1,1) // 'I05E': item "Information: Grand Vampire"
        set udg_QuestFlag[2]=true
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillElmdor_Slain_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I00N',l_tempPoint) // 'I00N': item "Kotetsu"
    call RemoveLocation(l_tempPoint)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Come back to Biggs for reward.")
    call QuestSetDescriptionBJ(udg_SideQuest[6],"Come back to Biggs for reward.")
    call EnableTrigger(gg_trg_Quest_KillElmdor_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Quest_KillElmdor_Complete_Conditions takes nothing returns boolean
    return((IsUnitHiddenBJ(gg_unit_h007_0089)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_KillElmdor_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_KillElmdor_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[16])
    if(Trig_Quest_KillElmdor_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h007_0089,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Elmdor is dead.",false)
        call Text_Say(gg_unit_h007_0089,"So you killed him? That is great to hear. Here's your reward.",false)
        call Reward_Give($5DC,$5DC,gg_unit_h007_0089) // $5DC = 1500
        call Text_Say(gg_unit_h007_0089,"You are strong indeed - Elmdor was no easy opponent to fight with. Izlude has a problem and he needs the help of powerful warriors to solve it. Perhaps you can help him.",false)
        call Cine_ExitAction()
    else
        call Reward_Give($5DC,$5DC,gg_unit_h007_0089) // $5DC = 1500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Kill Elmdor|r")
    call QuestSetCompletedBJ(udg_SideQuest[6],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Elmdor Has Been Slain!|r"
    set udg_NewsText[4]="Elmdor, the corrupted samurai, has been slain by the adventurers! Congratulations!"
    call ConditionalTriggerExecute(gg_trg_Quest_Brothers_Available)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DisableTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_KillElmdor takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_KillElmdor_Init takes nothing returns nothing
    set gg_trg_Quest_KillElmdor_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Quest_KillElmdor_Init,function Trig_Quest_KillElmdor_Init_Actions)
endfunction

function Register_Quest_KillElmdor_Available takes nothing returns nothing
    set gg_trg_Quest_KillElmdor_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillElmdor_Available)
    call TriggerAddAction(gg_trg_Quest_KillElmdor_Available,function Trig_Quest_KillElmdor_Available_Actions)
endfunction

function Register_Quest_KillElmdor_Start takes nothing returns nothing
    set gg_trg_Quest_KillElmdor_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillElmdor_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_KillElmdor_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_KillElmdor_Start,Condition(function Trig_Quest_KillElmdor_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_KillElmdor_Start,function Trig_Quest_KillElmdor_Start_Actions)
endfunction

function Register_Quest_KillElmdor_Slain takes nothing returns nothing
    set gg_trg_Quest_KillElmdor_Slain=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillElmdor_Slain)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KillElmdor_Slain,gg_unit_Nbbc_0006,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_KillElmdor_Slain,function Trig_Quest_KillElmdor_Slain_Actions)
endfunction

function Register_Quest_KillElmdor_Complete takes nothing returns nothing
    set gg_trg_Quest_KillElmdor_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillElmdor_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_KillElmdor_Complete,450.,gg_unit_h007_0089)
    call TriggerAddCondition(gg_trg_Quest_KillElmdor_Complete,Condition(function Trig_Quest_KillElmdor_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_KillElmdor_Complete,function Trig_Quest_KillElmdor_Complete_Actions)
endfunction

endlibrary
