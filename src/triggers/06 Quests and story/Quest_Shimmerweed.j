library TQuestShimmerweed requires TCam, TCine, TForce, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Shimmerweed_Offer=null
    trigger gg_trg_Quest_Shimmerweed_Start=null
    trigger gg_trg_Quest_Shimmerweed_Ping=null
    trigger gg_trg_Quest_Shimmerweed_Pickup=null
    trigger gg_trg_Quest_Shimmerweed_Deliver=null
endglobals

function Trig_Quest_Shimmerweed_Offer_Actions takes nothing returns nothing
    set udg_SpecialEffect[1]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n008_0050,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_Shimmerweed_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Shimmerweed_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n008_0050,true,true,true))
endfunction

function Trig_Quest_Shimmerweed_Start_CinematicsOnElena takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Shimmerweed_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[1])
    if(Trig_Quest_Shimmerweed_Start_CinematicsOnElena())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n008_0050,"Hello, my name is Elena. Could you do me a favour?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, what do you want?",false)
        call Text_Say(gg_unit_n008_0050,"I desperately need a plant called Shimmerweed. It grows in the forest but recently many monsters appeared there and it is too dangerous for me to go there.",false)
        call Text_Say(gg_unit_n008_0050,"If you would go to the forest could you please look for Shimmerweed? And if you find it, please bring it to me, I will pay you for it.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Find Shimmerweed|r")
    set udg_SideQuest[1]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Find Shimmerweed"),"Elena, woman in Kalm, asked you to bring her shimmerweed from forest.","ReplaceableTextures\\CommandButtons\\BTNShimmerWeed.blp")
    set udg_SpecialEffect[2]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n008_0050,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_Shimmerweed_Ping)
    call EnableTrigger(gg_trg_Quest_Shimmerweed_Pickup)
    call EnableTrigger(gg_trg_Quest_Shimmerweed_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Shimmerweed_Ping_Conditions takes nothing returns boolean
    return(udg_ShimmerweedItem!=null)
endfunction

function Trig_Quest_Shimmerweed_Ping_WeedPickedUp takes nothing returns boolean
    return(IsItemOwned(udg_ShimmerweedItem))
endfunction

function Trig_Quest_Shimmerweed_Ping_Actions takes nothing returns nothing
    if(Trig_Quest_Shimmerweed_Ping_WeedPickedUp())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n008_0050)
    else
        set udg_TempPoint=GetItemLoc(udg_ShimmerweedItem)
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Quest_Shimmerweed_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0FM') // 'I0FM': item "Shimmerweed"
endfunction

function Trig_Quest_Shimmerweed_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(Force_OfPlayer(GetOwningPlayer(GetManipulatingUnit())),bj_QUESTMESSAGE_UPDATED,"Bring the Shimmerweed to Elena.")
    call QuestSetDescriptionBJ(udg_SideQuest[1],"Bring Shimmerweed to Elena.")
endfunction

function Trig_Quest_Shimmerweed_Deliver_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0FM'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0FM': item "Shimmerweed"
endfunction

function Trig_Quest_Shimmerweed_Deliver_HasSpareCharge takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FM'))>=2) // 'I0FM': item "Shimmerweed"
endfunction

function Trig_Quest_Shimmerweed_Deliver_CinematicsOnDeliver takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Shimmerweed_Deliver_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[2])
    if(Trig_Quest_Shimmerweed_Deliver_HasSpareCharge())then
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FM'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FM'))-1)) // 'I0FM': item "Shimmerweed"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FM')) // 'I0FM': item "Shimmerweed"
    endif
    call DisableTrigger(gg_trg_Quest_Shimmerweed_Ping)
    call DestroyTrigger(gg_trg_Quest_Shimmerweed_Ping)
    call DisableTrigger(gg_trg_Quest_Shimmerweed_Pickup)
    call DestroyTrigger(gg_trg_Quest_Shimmerweed_Pickup)
    if(Trig_Quest_Shimmerweed_Deliver_CinematicsOnDeliver())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n008_0050,0)
        call Text_Say(gg_unit_n008_0050,"Thank you very much for bringing me Shimmerweed.",false)
        call Reward_Give(400,300,gg_unit_n008_0050)
        call Cine_ExitAction()
    else
        call Reward_Give(400,300,gg_unit_n008_0050)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Find Shimmerweed|r")
    call QuestSetCompletedBJ(udg_SideQuest[1],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Shimmerweed takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part8, RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Shimmerweed_Offer takes nothing returns nothing
    set gg_trg_Quest_Shimmerweed_Offer=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Shimmerweed_Offer)
    call TriggerAddAction(gg_trg_Quest_Shimmerweed_Offer,function Trig_Quest_Shimmerweed_Offer_Actions)
endfunction

function Register_Quest_Shimmerweed_Start takes nothing returns nothing
    set gg_trg_Quest_Shimmerweed_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Shimmerweed_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Shimmerweed_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Shimmerweed_Start,Condition(function Trig_Quest_Shimmerweed_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Shimmerweed_Start,function Trig_Quest_Shimmerweed_Start_Actions)
endfunction

function Register_Quest_Shimmerweed_Ping takes nothing returns nothing
    set gg_trg_Quest_Shimmerweed_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Shimmerweed_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_Shimmerweed_Ping,15.)
    call TriggerAddCondition(gg_trg_Quest_Shimmerweed_Ping,Condition(function Trig_Quest_Shimmerweed_Ping_Conditions))
    call TriggerAddAction(gg_trg_Quest_Shimmerweed_Ping,function Trig_Quest_Shimmerweed_Ping_Actions)
endfunction

function Register_Quest_Shimmerweed_Pickup takes nothing returns nothing
    set gg_trg_Quest_Shimmerweed_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Shimmerweed_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_Shimmerweed_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Quest_Shimmerweed_Pickup,Condition(function Trig_Quest_Shimmerweed_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Quest_Shimmerweed_Pickup,function Trig_Quest_Shimmerweed_Pickup_Actions)
endfunction

function Register_Quest_Shimmerweed_Deliver takes nothing returns nothing
    set gg_trg_Quest_Shimmerweed_Deliver=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Shimmerweed_Deliver)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Shimmerweed_Deliver,450.,gg_unit_n008_0050)
    call TriggerAddCondition(gg_trg_Quest_Shimmerweed_Deliver,Condition(function Trig_Quest_Shimmerweed_Deliver_Conditions))
    call TriggerAddAction(gg_trg_Quest_Shimmerweed_Deliver,function Trig_Quest_Shimmerweed_Deliver_Actions)
endfunction

endlibrary
