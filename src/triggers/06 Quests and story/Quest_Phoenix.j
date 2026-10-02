library TQuestPhoenix requires TCine, TForce, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Phoenix_Available=null
    trigger gg_trg_Quest_Phoenix_Start=null
    trigger gg_trg_Quest_Phoenix_Ping=null
    trigger gg_trg_Quest_Phoenix_EggTaken=null
    trigger gg_trg_Quest_Phoenix_Complete=null
endglobals

function Trig_Quest_Phoenix_Available_Actions takes nothing returns nothing
    set udg_SpecialEffect[$A]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hjai_0093,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl") // $A = 10
    call EnableTrigger(gg_trg_Quest_Phoenix_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Phoenix_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hjai_0093,true,true,true))
endfunction

function Trig_Quest_Phoenix_Start_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_004,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_Phoenix_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Phoenix_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[$A]) // $A = 10
    if(Trig_Quest_Phoenix_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_Phoenix_Start_Enum_ApplyCamera)
        call Text_Say(gg_unit_Hjai_0093,"Ah you're the adventurers that have been the talk of the town lately. Maybe you could help me as well? ... Oh, sorry, I forgot to introduce myself - I am Alma the Cleric.",false)
        call Text_Say(gg_unit_Hjai_0093,"I'll explain to you what kind of help I need. For hundreds of years on the islands to the west from here lived a Phoenix. This Phoenix aided the High Elves in battle many times when hordes of monsters attacked Kalm.",false)
        call Text_Say(gg_unit_Hjai_0093,"The Phoenix not only helped High Elves fight off monsters but also healed the wounds of their warriors. In return, High Elves protected the Phoenix Egg.",false)
        call Text_Say(gg_unit_Hjai_0093,"Phoenix lives for a long time, but when her life comes to an end she creates a nest, lays an egg and then burns herself with intense heat. Only by sacrificing herself may Phoenix give life to her fledgling.",false)
        call Text_Say(gg_unit_Hjai_0093,"Phoenix was not seen for a long time now. The High Elves don't know if she is still alive or not and all our efforts to find her were unsuccessful - the monsters that spawned in great numbers everywhere prevented us from reaching the islands.",false)
        call Text_Say(gg_unit_Hjai_0093,"We can't risk losing people in such desperate times. But you seem very capable fighters. Maybe you could go to the islands and find out what happened with Phoenix. I would appreciate it a lot if you do that.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We'll look into this matter.",false)
        call Cine_ExitAction()
    endif
    set udg_QuestItem[2]=CreateItemLoc('kybl',GetRectCenter(gg_rct_215)) // 'kybl': item "Phoenix Egg"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Phoenix|r")
    set udg_SideQuest[4]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffPhoenix","Alma, Cleric from Kalm, asked you to find out what happened with Phoenix.","ReplaceableTextures\\CommandButtons\\BTNMarkOfFire.blp")
    set udg_SpecialEffect[$B]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hjai_0093,"Objects\\RandomObject\\RandomObject.mdl") // $B = 11
    call EnableTrigger(gg_trg_Quest_Phoenix_Ping)
    call EnableTrigger(gg_trg_Quest_Phoenix_EggTaken)
    call AddItemToStockBJ('I04X',gg_unit_n02Y_0052,1,1) // 'I04X': item "Information: Phoenix"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Phoenix_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[2]!=null)
endfunction

function Trig_Quest_Phoenix_Ping_Cond_EggCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[2]))
endfunction

function Trig_Quest_Phoenix_Ping_Actions takes nothing returns nothing
    if(Trig_Quest_Phoenix_Ping_Cond_EggCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_Hjai_0093)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[2])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Quest_Phoenix_EggTaken_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='kybl') // 'kybl': item "Phoenix Egg"
endfunction

function Trig_Quest_Phoenix_EggTaken_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(Force_OfPlayer(GetOwningPlayer(GetManipulatingUnit())),bj_QUESTMESSAGE_UPDATED,"Bring the Phoenix Egg to Alma.")
    call QuestSetDescriptionBJ(udg_SideQuest[4],"Bring the Phoenix Egg to Alma.")
    call RemoveItemFromStockBJ('I04X',gg_unit_n02Y_0052) // 'I04X': item "Information: Phoenix"
    call EnableTrigger(gg_trg_Quest_Phoenix_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Phoenix_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'kybl'))and(IsUnitHiddenBJ(gg_unit_Hjai_0093)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'kybl': item "Phoenix Egg"
endfunction

function Trig_Quest_Phoenix_Complete_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_004,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_Phoenix_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Phoenix_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_Phoenix_Ping)
    call DestroyTrigger(gg_trg_Quest_Phoenix_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'kybl')) // 'kybl': item "Phoenix Egg"
    call DestroyEffectBJ(udg_SpecialEffect[$B]) // $B = 11
    if(Trig_Quest_Phoenix_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_Phoenix_Complete_Enum_ApplyCamera)
        call Text_Say(gg_unit_Hjai_0093,"So, you found the egg but there was no trace of Phoenix herself? I am afraid she was killed because she wouldn't have left the egg. Anyway, thanks for your efforts. Here's the promised reward.",false)
        call Reward_Give($7D0,$7D0,gg_unit_Hjai_0093) // $7D0 = 2000
        call Text_Say(gg_unit_Hjai_0093,"Thank you for your help and don't let some monster eat you - I might need your help again.",false)
        call Cine_ExitAction()
    else
        call Reward_Give($7D0,$7D0,gg_unit_Hjai_0093) // $7D0 = 2000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Phoenix|r")
    call QuestSetCompletedBJ(udg_SideQuest[4],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call EnableTrigger(gg_trg_Quest_FireGolem_Alert)
    call StartTimerBJ(udg_SharedDelayTimer1,false,60.)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Phoenix takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Phoenix_Available takes nothing returns nothing
    set gg_trg_Quest_Phoenix_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Phoenix_Available)
    call TriggerAddAction(gg_trg_Quest_Phoenix_Available,function Trig_Quest_Phoenix_Available_Actions)
endfunction

function Register_Quest_Phoenix_Start takes nothing returns nothing
    set gg_trg_Quest_Phoenix_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Phoenix_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Phoenix_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Phoenix_Start,Condition(function Trig_Quest_Phoenix_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Phoenix_Start,function Trig_Quest_Phoenix_Start_Actions)
endfunction

function Register_Quest_Phoenix_Ping takes nothing returns nothing
    set gg_trg_Quest_Phoenix_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Phoenix_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_Phoenix_Ping,15.)
    call TriggerAddCondition(gg_trg_Quest_Phoenix_Ping,Condition(function Trig_Quest_Phoenix_Ping_Conditions))
    call TriggerAddAction(gg_trg_Quest_Phoenix_Ping,function Trig_Quest_Phoenix_Ping_Actions)
endfunction

function Register_Quest_Phoenix_EggTaken takes nothing returns nothing
    set gg_trg_Quest_Phoenix_EggTaken=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Phoenix_EggTaken)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Phoenix_EggTaken,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Quest_Phoenix_EggTaken,Condition(function Trig_Quest_Phoenix_EggTaken_Conditions))
    call TriggerAddAction(gg_trg_Quest_Phoenix_EggTaken,function Trig_Quest_Phoenix_EggTaken_Actions)
endfunction

function Register_Quest_Phoenix_Complete takes nothing returns nothing
    set gg_trg_Quest_Phoenix_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Phoenix_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Phoenix_Complete,450.,gg_unit_Hjai_0093)
    call TriggerAddCondition(gg_trg_Quest_Phoenix_Complete,Condition(function Trig_Quest_Phoenix_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_Phoenix_Complete,function Trig_Quest_Phoenix_Complete_Actions)
endfunction

endlibrary
