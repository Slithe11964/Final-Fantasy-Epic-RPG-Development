library TQuestBeastslayer requires TCam, TCine, TForce, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Beastslayer_Available=null
    trigger gg_trg_Quest_Beastslayer_Start=null
    trigger gg_trg_Quest_Beastslayer_ArrowDropped=null
    trigger gg_trg_Quest_Beastslayer_Ping=null
    trigger gg_trg_Quest_Beastslayer_ArrowTaken=null
    trigger gg_trg_Quest_Beastslayer_Complete=null
endglobals

function Trig_Quest_Beastslayer_Available_Actions takes nothing returns nothing
    set udg_SpecialEffect[29]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00D_0091,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_Beastslayer_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Beastslayer_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n00D_0091,true,true,true))
endfunction

function Trig_Quest_Beastslayer_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Beastslayer_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[29])
    if(Trig_Quest_Beastslayer_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n00D_0091,"Greetings to you. I am Jessie. I have a small problem, could you help me please?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, why not?",false)
        call Text_Say(gg_unit_n00D_0091,"Recently I went hunting to Barrens and I took mistress Meliadoul's special arrow - the Beastslayer. It's a magical arrow that can kill any beast with one shot.",false)
        call Text_Say(gg_unit_n00D_0091,"I shot this arrow at a huge Thunder Lizard, but, to my dismay, it not only didn't die but charged at me with full speed. I barely escaped. Now I can't go back to mistress Meliadoul because I lost the Beastslayer. Please, find this arrow and bring it to me. If you do, I will offer you a reward and on top of that give you something special for your own archery training.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I'll see what can be done.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Find Beastslayer|r")
    set udg_SideQuest[$B]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Find Beastslayer"),"Jessie, archer from Kalm, asked you to find magical arrow called Beastslayer in the Barrens.","ReplaceableTextures\\CommandButtons\\BTNImprovedStrengthOfTheMoon.blp") // $B = 11
    set udg_SpecialEffect[29]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00D_0091,"Objects\\RandomObject\\RandomObject.mdl")
    // A random whole number from 1 through LoadIntegerBJ(2, 2, udg_SpawnDataHashRef).
    call CreateNUnitsAtLoc(1,'n011',Player($B),GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(2,2,udg_SpawnDataHashRef)),2,udg_SpawnRectHashRef)),bj_UNIT_FACING) // 'n011': unit "Tempest Lizard"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossUnits)
    call TriggerRegisterUnitEvent(gg_trg_Quest_Beastslayer_ArrowDropped,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Quest_Beastslayer_ArrowDropped)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Beastslayer_ArrowDropped_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[17]=CreateItemLoc('I00T',udg_TempPoint) // 'I00T': item "Beastslayer"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Quest_Beastslayer_Ping)
    call EnableTrigger(gg_trg_Quest_Beastslayer_ArrowTaken)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Beastslayer_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[17]!=null)
endfunction

function Trig_Quest_Beastslayer_Ping_Cond_ArrowCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[17]))
endfunction

function Trig_Quest_Beastslayer_Ping_Actions takes nothing returns nothing
    if(Trig_Quest_Beastslayer_Ping_Cond_ArrowCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n00D_0091)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[17])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Quest_Beastslayer_ArrowTaken_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I00T') // 'I00T': item "Beastslayer"
endfunction

function Trig_Quest_Beastslayer_ArrowTaken_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Beastslayer to Jessie.")
    call DestroyForce(udg_TempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[$B],"Bring the Beastslayer to Jessie.") // $B = 11
    call EnableTrigger(gg_trg_Quest_Beastslayer_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Beastslayer_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I00T'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I00T': item "Beastslayer"
endfunction

function Trig_Quest_Beastslayer_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Beastslayer_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_Beastslayer_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I00T')) // 'I00T': item "Beastslayer"
    call DestroyEffectBJ(udg_SpecialEffect[29])
    if(Trig_Quest_Beastslayer_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n00D_0091,0)
        call Text_Say(gg_unit_n00D_0091,"Oh, thank you! I'm saved !!",false)
        call Reward_Give($5DC,$3E8,gg_unit_n00D_0091) // $5DC = 1500; $3E8 = 1000
        call Text_Say(gg_unit_n00D_0091,"|n|cffffcc00Jessie now sells Archery gear.|r",true)
        call Text_Say(gg_unit_n00D_0091,"By the way, when you use arrows with an elemental affinity, the Rapid Fire technique changes its elemental affinity with them! Try it out sometime.",false)
        call Cine_ExitAction()
    else
        call Reward_Give($5DC,$3E8,gg_unit_n00D_0091) // $5DC = 1500; $3E8 = 1000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00Jessie now sells Archery gear.|r")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Find Beastslayer|r")
    call QuestSetCompletedBJ(udg_SideQuest[$B],true) // $B = 11
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddUnitToStockBJ('n0B7',gg_unit_n0B3_0049,1,1) // 'n0B7': unit "Hunt: Tempest Wyrm"
    set udg_HuntStock[2]=(udg_HuntStock[2]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call UnitAddAbilityBJ('Aneu',gg_unit_n00D_0091) // 'Aneu': standard ability reference "Neutral Building"
    call AddItemToStockBJ('I0F4',gg_unit_n00D_0091,1,1) // 'I0F4': item "Longbow"
    call AddItemToStockBJ('I0HN',gg_unit_n00D_0091,1,1) // 'I0HN': item "Onion Arrows"
    call AddItemToStockBJ('I0HP',gg_unit_n00D_0091,1,1) // 'I0HP': item "Icecloud Arrows"
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Beastslayer takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Beastslayer_Available takes nothing returns nothing
    set gg_trg_Quest_Beastslayer_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Beastslayer_Available)
    call TriggerAddAction(gg_trg_Quest_Beastslayer_Available,function Trig_Quest_Beastslayer_Available_Actions)
endfunction

function Register_Quest_Beastslayer_Start takes nothing returns nothing
    set gg_trg_Quest_Beastslayer_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Beastslayer_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Beastslayer_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Beastslayer_Start,Condition(function Trig_Quest_Beastslayer_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Beastslayer_Start,function Trig_Quest_Beastslayer_Start_Actions)
endfunction

function Register_Quest_Beastslayer_ArrowDropped takes nothing returns nothing
    set gg_trg_Quest_Beastslayer_ArrowDropped=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Beastslayer_ArrowDropped)
    call TriggerAddAction(gg_trg_Quest_Beastslayer_ArrowDropped,function Trig_Quest_Beastslayer_ArrowDropped_Actions)
endfunction

function Register_Quest_Beastslayer_Ping takes nothing returns nothing
    set gg_trg_Quest_Beastslayer_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Beastslayer_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_Beastslayer_Ping,15.)
    call TriggerAddCondition(gg_trg_Quest_Beastslayer_Ping,Condition(function Trig_Quest_Beastslayer_Ping_Conditions))
    call TriggerAddAction(gg_trg_Quest_Beastslayer_Ping,function Trig_Quest_Beastslayer_Ping_Actions)
endfunction

function Register_Quest_Beastslayer_ArrowTaken takes nothing returns nothing
    set gg_trg_Quest_Beastslayer_ArrowTaken=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Beastslayer_ArrowTaken)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Beastslayer_ArrowTaken,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Quest_Beastslayer_ArrowTaken,Condition(function Trig_Quest_Beastslayer_ArrowTaken_Conditions))
    call TriggerAddAction(gg_trg_Quest_Beastslayer_ArrowTaken,function Trig_Quest_Beastslayer_ArrowTaken_Actions)
endfunction

function Register_Quest_Beastslayer_Complete takes nothing returns nothing
    set gg_trg_Quest_Beastslayer_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Beastslayer_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Beastslayer_Complete,450.,gg_unit_n00D_0091)
    call TriggerAddCondition(gg_trg_Quest_Beastslayer_Complete,Condition(function Trig_Quest_Beastslayer_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_Beastslayer_Complete,function Trig_Quest_Beastslayer_Complete_Actions)
endfunction

endlibrary
