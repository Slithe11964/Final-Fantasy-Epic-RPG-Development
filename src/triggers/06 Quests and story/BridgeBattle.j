library TBridgeBattle requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_BridgeBattle_Prepare=null
    trigger gg_trg_BridgeBattle_Start=null
    trigger gg_trg_BridgeBattle_Complete=null
endglobals

function Trig_BridgeBattle_Prepare_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[40]))and(udg_StoryProgress>=$F) // $F = 15
endfunction

function Trig_BridgeBattle_Prepare_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_SpecialEffect[63]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n02Y_0052,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_BridgeBattle_Start)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Mae'chen calls out to adventurers|r"
    set udg_NewsText[4]="Mae'chen has a special message for the adventurers: \"Please help me avenge my friend's humiliation!\""
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_BridgeBattle_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n02Y_0052,true,true,true))
endfunction

function Trig_BridgeBattle_Start_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_BridgeBattle_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[63])
    if(Trig_BridgeBattle_Start_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n02Y_0052,"You there. Hold on a minute.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What is it?",false)
        call Text_Say(gg_unit_n02Y_0052,"I wondered if you could help my friend.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"With what?",false)
        call Text_Say(gg_unit_n02Y_0052,"You see, my friend recently fought with a mysterious four-armed man, but he was defeated. And as if this shame wouldn't have been enough, the man also took his sword! This was too much for my friend and he asked me for assistance.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you want us to go beat this guy up and return the sword?",false)
        call Text_Say(gg_unit_n02Y_0052,"I think defeating him would suffice. If the man has my friend's sword with him by any chance, you may keep it.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Where can we find this man? Where has your friend fought him?",false)
        call Text_Say(gg_unit_n02Y_0052,"My friend fought him on a big bridge. The man seems to like bridges as a place for a battle.",false)
        call Text_Say(gg_unit_n02Y_0052,"Also, my friend just called him \"Mr. X\". Nobody knows his real name, but another of his nicknames is \"The Planeswalker\".",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A battle on the Big Bridge, huh?\r\nAlright, I'll try to find this Mr. X.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00The Bridge-Battle|r")
    set udg_SideQuest[41]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"The Bridge-Battle"),"Mae'chen, a wise old man from Spira, has asked you to find and defeat Mr. X. Mr. X has defeated one of Mae'chen's friends and took his sword. Now Mae'chen's friend asked Mae'chen for help for revenge.","ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp")
    set udg_SpecialEffect[63]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n02Y_0052,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Gilgamesh_Appear)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_BridgeBattle_Complete_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_BridgeBattle_Complete_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_BridgeBattle_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[63])
    if(Trig_BridgeBattle_Complete_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n02Y_0052,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We have fought and defeated Mr. X. As it turns out, he is the planeswalker Gilgamesh. Unfortunately he was able to escape.",false)
        call Text_Say(gg_unit_n02Y_0052,"That's fine. At least my friend no longer has to be ashamed.",false)
        call Text_Say(gg_unit_n02Y_0052,"Thank you for your efforts. I will tell the night elves of your accomplishments.",false)
        call Reward_Give($2710,$2710,gg_unit_n02Y_0052) // $2710 = 10000
        call Cine_ExitAction()
    else
        call Reward_Give($2710,$2710,gg_unit_n02Y_0052) // $2710 = 10000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00The Bridge-Battle|r")
    call QuestSetCompletedBJ(udg_SideQuest[41],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_BridgeBattle automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BridgeBattle (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BridgeBattle takes nothing returns nothing
endfunction

function Register_BridgeBattle_Prepare takes nothing returns nothing
    set gg_trg_BridgeBattle_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_BridgeBattle_Prepare)
    call TriggerRegisterTimerEventPeriodic(gg_trg_BridgeBattle_Prepare,15.)
    call TriggerAddCondition(gg_trg_BridgeBattle_Prepare,Condition(function Trig_BridgeBattle_Prepare_Conditions))
    call TriggerAddAction(gg_trg_BridgeBattle_Prepare,function Trig_BridgeBattle_Prepare_Actions)
endfunction

function Register_BridgeBattle_Start takes nothing returns nothing
    set gg_trg_BridgeBattle_Start=CreateTrigger()
    call DisableTrigger(gg_trg_BridgeBattle_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_BridgeBattle_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_BridgeBattle_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_BridgeBattle_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_BridgeBattle_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_BridgeBattle_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_BridgeBattle_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_BridgeBattle_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_BridgeBattle_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_BridgeBattle_Start,Condition(function Trig_BridgeBattle_Start_Conditions))
    call TriggerAddAction(gg_trg_BridgeBattle_Start,function Trig_BridgeBattle_Start_Actions)
endfunction

function Register_BridgeBattle_Complete takes nothing returns nothing
    set gg_trg_BridgeBattle_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_BridgeBattle_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_BridgeBattle_Complete,450.,gg_unit_n02Y_0052)
    call TriggerAddCondition(gg_trg_BridgeBattle_Complete,Condition(function Trig_BridgeBattle_Complete_Conditions))
    call TriggerAddAction(gg_trg_BridgeBattle_Complete,function Trig_BridgeBattle_Complete_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BridgeBattle takes nothing returns nothing
    call Register_BridgeBattle_Prepare() // starts off; enabled by Epilogue, Quest_NightElves, Talk
    call Register_BridgeBattle_Start() // starts off; enabled by BridgeBattle
    call Register_BridgeBattle_Complete() // starts off; enabled by Gilgamesh
endfunction

endlibrary
