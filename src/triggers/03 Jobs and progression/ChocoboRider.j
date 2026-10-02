library TChocoboRider requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_ChocoboRider_Start=null
    trigger gg_trg_ChocoboRider_StartWithChocobo=null
    trigger gg_trg_ChocoboRider_Progress=null
    trigger gg_trg_ChocoboRider_FoundTreasure=null
    trigger gg_trg_ChocoboRider_Reward=null
endglobals

function Trig_ChocoboRider_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0KE_0072,true,true,true))
endfunction

function Trig_ChocoboRider_Start_IsTimmyQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[9]))
endfunction

function Trig_ChocoboRider_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ChocoboRider_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[86])
    if(Trig_ChocoboRider_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        if(Trig_ChocoboRider_Start_IsTimmyQuestDone())then
            call Text_Say(gg_unit_n0KE_0072,"Hello! Are you those adventurers that saved Timmy?",false)
        else
            call Text_Say(gg_unit_n0KE_0072,"Hello! Are you those notorious adventurers I've heard about?",false)
        endif
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's us, yes. Who are you, little one?",false)
        call Text_Say(gg_unit_n0KE_0072,"I'm Billy. My father used to be the one in charge of chocobos around here, but now that falls to me.",false)
        call Text_Say(gg_unit_n0KE_0072,"If you've never used a chocobo before I'll help you get the hang of it. They are lovely birds that can carry you places and even dig up treasures for you if you know what they need.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure that sounds good.",false)
        call Text_Say(gg_unit_n0KE_0072,"First things first, you need to get a chocobo. I'll sell you some Pram Nuts. They are rather ordinary nuts but are still enough to tame chocobos in either Guardia Forest or Central Islands. Don't bother trying them on any other chocobos though.",false)
        call Text_Say(gg_unit_n0KE_0072,"Once you've tamed a chocobo, bring it to me. We can continue then.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Chocobo Rider|r")
    set udg_SideQuest[64]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Chocobo Rider"),"Billy, taking over his father Bill's work of taking care of chocobos, is teaching you how to handle chocobos. Tame a chocobo using a Nut and bring it back to him!","ReplaceableTextures\\CommandButtons\\BTNCritterChicken.blp")
    set udg_SpecialEffect[86]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0KE_0072,"Objects\\RandomObject\\RandomObject.mdl")
    call AddItemToStockBJ('I045',gg_unit_n0KE_0072,5,5) // 'I045': item "Pram Nut"
    call DisableTrigger(gg_trg_ChocoboRider_StartWithChocobo)
    call DestroyTrigger(gg_trg_ChocoboRider_StartWithChocobo)
    call EnableTrigger(gg_trg_ChocoboRider_Progress)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ChocoboRider_StartWithChocobo_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitName(GetTriggerUnit())=="Chocobo")and(udg_InCinematicMode==false)
endfunction

function Trig_ChocoboRider_StartWithChocobo_HasSelectAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Aneu',gg_unit_n0KE_0072)>0) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_ChocoboRider_StartWithChocobo_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ChocoboRider_StartWithChocobo_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_ChocoboRider_StartWithChocobo_HasSelectAbility())then
        call DestroyEffectBJ(udg_SpecialEffect[86])
        call DisableTrigger(gg_trg_ChocoboRider_Start)
        call DestroyTrigger(gg_trg_ChocoboRider_Start)
    else
        call UnitAddAbilityBJ('Aneu',gg_unit_n0KE_0072) // 'Aneu': standard ability reference "Neutral Building"
    endif
    if(Trig_ChocoboRider_StartWithChocobo_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0KE_0072,0)
        call Text_Say(gg_unit_n0KE_0072,"Oh wow, is that a chocobo you have there?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That is a chocobo alright. Who are you, little one?",false)
        call Text_Say(gg_unit_n0KE_0072,"I'm Billy. My father used to be the one in charge of chocobos around here, but now that falls to me.",false)
        call Text_Say(gg_unit_n0KE_0072,"Glad to see you already got the hang of taming them, but did you know chocobos can dig up special treasures too?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Now you've caught my interest. What do I need for that?",false)
        call Text_Say(gg_unit_n0KE_0072,"Here I'll sell you some Dead Pepper. Feed it to a chocobo of yours and it will dig straight into the ground. Now you probably won't happen upon a hidden treasure immediately, but the chocobo's reaction will tell you how close you are to one.",false)
        call Text_Say(gg_unit_n0KE_0072,"If the chocobo reacts excitedly, a treasure is nearby. The more excited, the closer you are. Use Dead Peppers repeatedly to find and close in on a hidden treasure!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So feed Dead Peppers and watch the chocobo's reaction to see how close by a treasure is... sounds simple enough.",false)
        call Text_Say(gg_unit_n0KE_0072,"I've hidden a treasure myself somewhere on this Farm. For practice, why don't you try finding it?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That sounds like a challenge. I'll find your treasure.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Chocobo Rider|r")
    set udg_SideQuest[64]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Chocobo Rider"),"Billy, taking over his father Bill's work of taking care of chocobos, has hidden a treasure somewhere on the Farm for you to dig up. Use the Dead Peppers he sells to find it!","ReplaceableTextures\\CommandButtons\\BTNCritterChicken.blp")
    set udg_SpecialEffect[86]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0KE_0072,"Objects\\RandomObject\\RandomObject.mdl")
    call AddItemToStockBJ('I045',gg_unit_n0KE_0072,5,5) // 'I045': item "Pram Nut"
    call AddItemToStockBJ('I07V',gg_unit_n0KE_0072,$A,$A) // 'I07V': item "Dead Pepper"; $A = 10
    set udg_ChocoboGreensFed=false
    call EnableTrigger(gg_trg_ChocoboRider_FoundTreasure)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ChocoboRider_Progress_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitName(GetTriggerUnit())=="Chocobo")and(udg_InCinematicMode==false)
endfunction

function Trig_ChocoboRider_Progress_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ChocoboRider_Progress_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_ChocoboRider_Progress_IsDialogueOn())then
        call DestroyEffectBJ(udg_SpecialEffect[86])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0KE_0072,0)
        call Text_Say(gg_unit_n0KE_0072,"Ah now there's a chocobo. Well done!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So, what was that about them able to dig up treasure?",false)
        call Text_Say(gg_unit_n0KE_0072,"To make a chocobo dig up treasure, you'll need Dead Pepper.",false)
        call Text_Say(gg_unit_n0KE_0072,"Feed the peppers to a chocobo of yours and it will dig straight into the ground. Now you probably won't happen upon a hidden treasure immediately, but the chocobo's reaction will tell you how close you are to one.",false)
        call Text_Say(gg_unit_n0KE_0072,"If the chocobo reacts excitedly, a treasure is nearby. The more excited, the closer you are. Use Dead Peppers repeatedly to find and close in on a hidden treasure!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So feed Dead Peppers and watch the chocobo's reaction to see how close by a treasure is... sounds simple enough.",false)
        call Text_Say(gg_unit_n0KE_0072,"I've hidden a treasure myself somewhere on this Farm. For practice, why don't you try finding it?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That sounds like a challenge. I'll find your treasure.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[86]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0KE_0072,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call AddItemToStockBJ('I07V',gg_unit_n0KE_0072,$A,$A) // 'I07V': item "Dead Pepper"; $A = 10
    call EnableTrigger(gg_trg_ChocoboRider_FoundTreasure)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Dig up the treasure Billy hid somewhere on the Farm.")
    call QuestSetDescriptionBJ(udg_SideQuest[64],"Dig up the treasure Billy hid somewhere on the Farm. Use Dead Pepper sold by Billy for this task.")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ChocoboRider_FoundTreasure_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I027') // 'I027': item "Gysahl Greens"
endfunction

function Trig_ChocoboRider_FoundTreasure_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Return to Billy.")
    call QuestSetDescriptionBJ(udg_SideQuest[64],"Return to Billy.")
    call EnableTrigger(gg_trg_ChocoboRider_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ChocoboRider_Reward_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_ChocoboRider_Reward_HasNotFedGreens takes nothing returns boolean
    return(udg_ChocoboGreensFed==false)
endfunction

function Trig_ChocoboRider_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ChocoboRider_Reward_IsSideQuestReady takes nothing returns boolean
    return(udg_BossDefeated[3])
endfunction

function Trig_ChocoboRider_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[86])
    if(Trig_ChocoboRider_Reward_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n0KE_0072,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We found your treasure. This is a pretty simple process.",false)
        call Text_Say(gg_unit_n0KE_0072,"Congratulations. I've taught you all I can for now. Keep in mind that better chocobos will only be charmed by better quality nuts than the Pram Nuts I have.",false)
        call Text_Say(gg_unit_n0KE_0072,"Also if you find your chocobos dying to monsters very easily, I can help you with that and improve their defenses. I can't do that for free though.",false)
        call Reward_Give(0,$BB8,gg_unit_n0KE_0072) // $BB8 = 3000
        if(Trig_ChocoboRider_Reward_HasNotFedGreens())then
            call Text_Say(gg_unit_n0KE_0072,"And don't forget to feed those greens to your chocobo! I'm sure an adventurer like you will enjoy the result.",false)
        endif
        call Cine_ExitAction()
    else
        call Reward_Give(0,$BB8,gg_unit_n0KE_0072) // $BB8 = 3000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Chocobo Rider|r")
    call QuestSetCompletedBJ(udg_SideQuest[64],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddItemToStockBJ('I04O',gg_unit_n0KE_0072,1,1) // 'I04O': item "Chocobo Defending"
    if(Trig_ChocoboRider_Reward_IsSideQuestReady())then
        call StartTimerBJ(udg_StoryDelayTimer,false,180.)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_ChocoboRider automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_ChocoboRider (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_ChocoboRider takes nothing returns nothing
endfunction

function Register_ChocoboRider_Start takes nothing returns nothing
    set gg_trg_ChocoboRider_Start=CreateTrigger()
    call DisableTrigger(gg_trg_ChocoboRider_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ChocoboRider_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ChocoboRider_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ChocoboRider_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ChocoboRider_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ChocoboRider_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ChocoboRider_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ChocoboRider_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ChocoboRider_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_ChocoboRider_Start,Condition(function Trig_ChocoboRider_Start_Conditions))
    call TriggerAddAction(gg_trg_ChocoboRider_Start,function Trig_ChocoboRider_Start_Actions)
endfunction

function Register_ChocoboRider_StartWithChocobo takes nothing returns nothing
    set gg_trg_ChocoboRider_StartWithChocobo=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_ChocoboRider_StartWithChocobo,450.,gg_unit_n0KE_0072)
    call TriggerAddCondition(gg_trg_ChocoboRider_StartWithChocobo,Condition(function Trig_ChocoboRider_StartWithChocobo_Conditions))
    call TriggerAddAction(gg_trg_ChocoboRider_StartWithChocobo,function Trig_ChocoboRider_StartWithChocobo_Actions)
endfunction

function Register_ChocoboRider_Progress takes nothing returns nothing
    set gg_trg_ChocoboRider_Progress=CreateTrigger()
    call DisableTrigger(gg_trg_ChocoboRider_Progress)
    call TriggerRegisterUnitInRangeSimple(gg_trg_ChocoboRider_Progress,450.,gg_unit_n0KE_0072)
    call TriggerAddCondition(gg_trg_ChocoboRider_Progress,Condition(function Trig_ChocoboRider_Progress_Conditions))
    call TriggerAddAction(gg_trg_ChocoboRider_Progress,function Trig_ChocoboRider_Progress_Actions)
endfunction

function Register_ChocoboRider_FoundTreasure takes nothing returns nothing
    set gg_trg_ChocoboRider_FoundTreasure=CreateTrigger()
    call DisableTrigger(gg_trg_ChocoboRider_FoundTreasure)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ChocoboRider_FoundTreasure,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_ChocoboRider_FoundTreasure,Condition(function Trig_ChocoboRider_FoundTreasure_Conditions))
    call TriggerAddAction(gg_trg_ChocoboRider_FoundTreasure,function Trig_ChocoboRider_FoundTreasure_Actions)
endfunction

function Register_ChocoboRider_Reward takes nothing returns nothing
    set gg_trg_ChocoboRider_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_ChocoboRider_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_ChocoboRider_Reward,450.,gg_unit_n0KE_0072)
    call TriggerAddCondition(gg_trg_ChocoboRider_Reward,Condition(function Trig_ChocoboRider_Reward_Conditions))
    call TriggerAddAction(gg_trg_ChocoboRider_Reward,function Trig_ChocoboRider_Reward_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_ChocoboRider takes nothing returns nothing
    call Register_ChocoboRider_Start() // starts off; enabled by Billy; disabled by ChocoboRider; destroyed by ChocoboRider
    call Register_ChocoboRider_StartWithChocobo() // disabled by ChocoboRider; destroyed by ChocoboRider
    call Register_ChocoboRider_Progress() // starts off; enabled by ChocoboRider
    call Register_ChocoboRider_FoundTreasure() // starts off; enabled by ChocoboRider
    call Register_ChocoboRider_Reward() // starts off; enabled by ChocoboRider
endfunction

endlibrary
