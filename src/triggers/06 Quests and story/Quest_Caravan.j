library TQuestCaravan requires TCam, TCine, TGroup, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Caravan_SamAvailable=null
    trigger gg_trg_Quest_Caravan_SamRequest=null
    trigger gg_trg_Quest_Caravan_DioRefuses=null
    trigger gg_trg_Quest_Caravan_Enable=null
    trigger gg_trg_Quest_Caravan_Start=null
    trigger gg_trg_Quest_Caravan_HorsesVulnerable=null
    trigger gg_trg_Quest_Caravan_Deliver=null
    trigger gg_trg_Quest_Caravan_Failed=null
    trigger gg_trg_Quest_Caravan_Ping=null
    trigger gg_trg_Quest_Caravan_Complete=null
    // Variables only this module uses.
    integer udg_CaravanReward=0
endglobals

function Trig_Quest_Caravan_SamAvailable_Cond_CaravanStage0 takes nothing returns boolean
    return(udg_CaravanStage==0)
endfunction

function Trig_Quest_Caravan_SamAvailable_Actions takes nothing returns nothing
    if(Trig_Quest_Caravan_SamAvailable_Cond_CaravanStage0())then
        set udg_SpecialEffect[$C]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00B_0054,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl") // $C = 12
        call EnableTrigger(gg_trg_Quest_Caravan_SamRequest)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Caravan_SamRequest_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n00B_0054,true,true,true))
endfunction

function Trig_Quest_Caravan_SamRequest_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Caravan_SamRequest_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[$C]) // $C = 12
    set udg_CaravanStage=1
    if(Trig_Quest_Caravan_SamRequest_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n00B_0054,"Hello there, you seem to have made quite a name for yourself as capable adventurers.",false)
        call Text_Say(gg_unit_n00B_0054,"I'm awaiting a delivery of goods from the Farm down south. It was supposed to arrive a while ago.",false)
        call Text_Say(gg_unit_n00B_0054,"We haven't received word from our farmers in a while and things are getting stressful. They tend to be a lazy bunch though. Could you go check on them and ask a man called Dio about this?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, it's no big deal.",false)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[$C]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00A_0101,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl") // $C = 12
    call EnableTrigger(gg_trg_Quest_Caravan_DioRefuses)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Caravan_DioRefuses_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n00A_0101,true,true,true))
endfunction

function Trig_Quest_Caravan_DioRefuses_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Caravan_DioRefuses_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[$C]) // $C = 12
    set udg_CaravanStage=2
    if(Trig_Quest_Caravan_DioRefuses_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sorry, are you Dio?",false)
        call Text_Say(gg_unit_n00A_0101,"Yes, that's me. How can I help you?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I've been sent by Sam from Kalm to check on your caravan. He seems stressed out. How are things looking?",false)
        call Text_Say(gg_unit_n00A_0101,"That goddamn... look, do we seem lazy to you?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I don't know, I just came here.",false)
        call Text_Say(gg_unit_n00A_0101,"We're bloody not lazy. We just lost half a dozen people to bloodthirsty monsters.",false)
        call Text_Say(gg_unit_n00A_0101,"I'm sorry but we're currently a little busy looking after ourselves. Tell Sam he has to deal with it.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I think I better not add fuel to this fire. Good bye.",false)
        call Cine_ExitAction()
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Caravan_Enable_Cond_CaravanStage0 takes nothing returns boolean
    return(udg_CaravanStage==0)
endfunction

function Trig_Quest_Caravan_Enable_Cond_CaravanNotStage1 takes nothing returns boolean
    return(udg_CaravanStage!=1)
endfunction

function Trig_Quest_Caravan_Enable_Actions takes nothing returns nothing
    if(Trig_Quest_Caravan_Enable_Cond_CaravanStage0())then
        call DestroyEffectBJ(udg_SpecialEffect[$C]) // $C = 12
        call DisableTrigger(gg_trg_Quest_Caravan_SamRequest)
        call DestroyTrigger(gg_trg_Quest_Caravan_SamRequest)
    endif
    if(Trig_Quest_Caravan_Enable_Cond_CaravanNotStage1())then
        set udg_SpecialEffect[$C]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00A_0101,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl") // $C = 12
    else
        call DisableTrigger(gg_trg_Quest_Caravan_DioRefuses)
        call DestroyTrigger(gg_trg_Quest_Caravan_DioRefuses)
    endif
    // Increase udg_CaravanStage by 3.
    set udg_CaravanStage=(udg_CaravanStage+3)
    call Unit_ScaleToLevel60(gg_unit_hrdh_0102)
    call Unit_ScaleToLevel60(gg_unit_hrdh_0103)
    call Unit_ScaleToLevel60(gg_unit_hrdh_0104)
    call EnableTrigger(gg_trg_Quest_Caravan_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Caravan_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n00A_0101,true,true,true))
endfunction

function Trig_Quest_Caravan_Start_Cond_CaravanStage4 takes nothing returns boolean
    return(udg_CaravanStage==4)
endfunction

function Trig_Quest_Caravan_Start_Cond_CaravanStage5 takes nothing returns boolean
    return(udg_CaravanStage==5)
endfunction

function Trig_Quest_Caravan_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Caravan_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[$C]) // $C = 12
    if(Trig_Quest_Caravan_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n00A_0101,"Ah it's you! The heroes who saved our youngest member!",false)
        if(Trig_Quest_Caravan_Start_Cond_CaravanStage5())then
            call Text_Say(gg_unit_n00A_0101,"You told me Sam is stressing out waiting for a caravan of ours correct? Apologies for asking, but we could really use your help with that.",false)
        else
            if(Trig_Quest_Caravan_Start_Cond_CaravanStage4())then
                call Text_Say(gg_unit_n00A_0101,"My name is Dio. Is there something you wish to ask of me?",false)
                call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes. A man named Sam told me to speak with you, to check up on a caravan he's awaiting.",false)
                call Text_Say(gg_unit_n00A_0101,"Ah yes, we were getting that ready just now. Though... could we ask for your assistance?",false)
            else
                call Text_Say(gg_unit_n00A_0101,"I'd greatly appreciate if we could enlist your help once more. This caravan is supposed to be delivered to Sam in Kalm, but the monsters on the road are vicious.",false)
            endif
        endif
        call Text_Say(gg_unit_n00A_0101,"These pack horses need to be protected on their way to Kalm. And since you are such capable heroes, it'd be great if you could be the one to protect them.",false)
        call Text_Say(gg_unit_n00A_0101,"I know they are depending on our wares, but we... don't want to send out any of our men again just yet. I'm sure you understand.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, we understand. We will make sure these horses safely reach their destination.",false)
        call Text_Say(gg_unit_n00A_0101,"Thank you. Please ensure that the horses survive the journey. Ideally all three, but at least one. Of course you will be handsomely rewarded for this task. Good luck !",false)
        call Cine_ExitAction()
    endif
    call SetUnitOwner(gg_unit_hrdh_0102,Player($A),true) // $A = 10
    call SetUnitOwner(gg_unit_hrdh_0103,Player($A),true) // $A = 10
    call SetUnitOwner(gg_unit_hrdh_0104,Player($A),true) // $A = 10
    call RemoveAllGuardPositions(Player($A)) // $A = 10
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Caravan|r")
    set udg_SideQuest[5]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffCaravan","Dio, from the farm, asked you to bring caravan of pack horses to Sam in Kalm.","ReplaceableTextures\\CommandButtons\\BTNRiderlessHorse.blp")
    set udg_QuestReq[1]=CreateQuestItemBJ(udg_SideQuest[5],"At least one pack horse must reach Kalm")
    set udg_SpecialEffect[$D]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00B_0054,"Objects\\RandomObject\\RandomObject.mdl") // $D = 13
    call GroupAddUnitSimple(gg_unit_n00B_0054,udg_BossUnits)
    call EnableTrigger(gg_trg_Quest_Caravan_HorsesVulnerable)
    call EnableTrigger(gg_trg_Quest_Caravan_Deliver)
    call EnableTrigger(gg_trg_Quest_Caravan_Failed)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Caravan_HorsesVulnerable_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='hrdh') // 'hrdh': object name not found in map data
endfunction

function Trig_Quest_Caravan_HorsesVulnerable_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetUnitInvulnerable(gg_unit_hrdh_0102,false)
    call SetUnitInvulnerable(gg_unit_hrdh_0103,false)
    call SetUnitInvulnerable(gg_unit_hrdh_0104,false)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Caravan_Deliver_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='hrdh')and(GetOwningPlayer(GetTriggerUnit())==Player($A))and(udg_InCinematicMode==false) // 'hrdh': object name not found in map data; $A = 10
endfunction

function Trig_Quest_Caravan_Deliver_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Caravan_Deliver_Cond_HorseNearby takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<=1280.)
endfunction

function Trig_Quest_Caravan_Deliver_Cond_NotArrivedHorse takes nothing returns boolean
    return(GetTriggerUnit()!=GetEnumUnit())
endfunction

function Trig_Quest_Caravan_Deliver_Enum_ScoreHorse takes nothing returns nothing
    if(Trig_Quest_Caravan_Deliver_Cond_NotArrivedHorse())then
        set udg_TempPoint2=GetUnitLoc(GetEnumUnit())
        if(Trig_Quest_Caravan_Deliver_Cond_HorseNearby())then
            // Increase udg_CaravanReward by 2000.
            set udg_CaravanReward=(udg_CaravanReward+$7D0) // $7D0 = 2000
        endif
        call RemoveLocation(udg_TempPoint2)
    endif
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Quest_Caravan_Deliver_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[$D]) // $D = 13
    call GroupRemoveUnitSimple(gg_unit_n00B_0054,udg_BossUnits)
    set udg_StoryFlag[1]=true
    if(Trig_Quest_Caravan_Deliver_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n00B_0054,0)
        call Text_Say(gg_unit_n00B_0054,"Ah! The caravan from Dio!? Thank you, my friend! We've been expecting this caravan for a long time. Here, take this paper - it confirms the delivery of the goods. Bring it to Dio and he will reward you for completing this job.",false)
        call Cine_ExitAction()
    endif
    set udg_CaravanReward=$3E8 // $3E8 = 1000
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsOfPlayerAndType(Player($A),'hrdh') // $A = 10; 'hrdh': object name not found in map data
    call ForGroupBJ(udg_TempGroup,function Trig_Quest_Caravan_Deliver_Enum_ScoreHorse)
    call DestroyGroup(udg_TempGroup)
    call RemoveLocation(udg_TempPoint)
    call QuestItemSetCompletedBJ(udg_QuestReq[1],true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring the paper to Dio.")
    call QuestSetDescriptionBJ(udg_SideQuest[5],"Bring the paper to Dio to get reward.")
    call DisableTrigger(gg_trg_Quest_Caravan_Ping)
    set udg_SpecialEffect[$E]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00A_0101,"Objects\\RandomObject\\RandomObject.mdl") // $E = 14
    set udg_TempPoint=GetUnitLoc(gg_unit_n00B_0054)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,0,-150.)
    call RemoveLocation(udg_TempPoint)
    call CreateItemLoc('mort',udg_TempPoint2) // 'mort': item "Delivery Confirmation"
    call RemoveLocation(udg_TempPoint2)
    set udg_QuestItem[25]=GetLastCreatedItem()
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call EnableTrigger(gg_trg_Quest_Caravan_Ping)
    call EnableTrigger(gg_trg_Quest_Caravan_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Caravan_Failed_Conditions takes nothing returns boolean
    return(IsUnitDeadBJ(gg_unit_hrdh_0102))and(IsUnitDeadBJ(gg_unit_hrdh_0103))and(IsUnitDeadBJ(gg_unit_hrdh_0104))
endfunction

function Trig_Quest_Caravan_Failed_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTextToForce(GetPlayersAll(),"All pack horses died !!!")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Caravan|r")
    call QuestSetFailedBJ(udg_SideQuest[5],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call QuestItemSetCompletedBJ(udg_QuestReq[1],false)
    call DestroyEffectBJ(udg_SpecialEffect[$D]) // $D = 13
    call GroupRemoveUnitSimple(gg_unit_n00B_0054,udg_BossUnits)
    call DisableTrigger(gg_trg_Quest_Caravan_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Caravan_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[25]!=null)
endfunction

function Trig_Quest_Caravan_Ping_Cond_PaperCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[25]))
endfunction

function Trig_Quest_Caravan_Ping_Actions takes nothing returns nothing
    if(Trig_Quest_Caravan_Ping_Cond_PaperCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_n00A_0101)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[25])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Quest_Caravan_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'mort'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'mort': item "Delivery Confirmation"
endfunction

function Trig_Quest_Caravan_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Caravan_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_Caravan_Ping)
    call DestroyEffectBJ(udg_SpecialEffect[$E]) // $E = 14
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'mort')) // 'mort': item "Delivery Confirmation"
    if(Trig_Quest_Caravan_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n00A_0101,0)
        call Text_Say(gg_unit_n00A_0101,"So, you say you delivered goods to Sam? Can I see the paper he gave you? Hmm... yes, everything seems OK. As promised, I will reward you with gold. And thank you again!",false)
        call Reward_Give(udg_CaravanReward,$3E8,gg_unit_n00A_0101) // $3E8 = 1000
        call Cine_ExitAction()
    else
        call Reward_Give(udg_CaravanReward,$3E8,gg_unit_n00A_0101) // $3E8 = 1000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Caravan|r")
    call QuestSetCompletedBJ(udg_SideQuest[5],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Caravan takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Caravan_SamAvailable takes nothing returns nothing
    set gg_trg_Quest_Caravan_SamAvailable=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_SamAvailable)
    call TriggerAddAction(gg_trg_Quest_Caravan_SamAvailable,function Trig_Quest_Caravan_SamAvailable_Actions)
endfunction

function Register_Quest_Caravan_SamRequest takes nothing returns nothing
    set gg_trg_Quest_Caravan_SamRequest=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_SamRequest)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_SamRequest,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Caravan_SamRequest,Condition(function Trig_Quest_Caravan_SamRequest_Conditions))
    call TriggerAddAction(gg_trg_Quest_Caravan_SamRequest,function Trig_Quest_Caravan_SamRequest_Actions)
endfunction

function Register_Quest_Caravan_DioRefuses takes nothing returns nothing
    set gg_trg_Quest_Caravan_DioRefuses=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_DioRefuses)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_DioRefuses,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Caravan_DioRefuses,Condition(function Trig_Quest_Caravan_DioRefuses_Conditions))
    call TriggerAddAction(gg_trg_Quest_Caravan_DioRefuses,function Trig_Quest_Caravan_DioRefuses_Actions)
endfunction

function Register_Quest_Caravan_Enable takes nothing returns nothing
    set gg_trg_Quest_Caravan_Enable=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_Enable)
    call TriggerAddAction(gg_trg_Quest_Caravan_Enable,function Trig_Quest_Caravan_Enable_Actions)
endfunction

function Register_Quest_Caravan_Start takes nothing returns nothing
    set gg_trg_Quest_Caravan_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Caravan_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Caravan_Start,Condition(function Trig_Quest_Caravan_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Caravan_Start,function Trig_Quest_Caravan_Start_Actions)
endfunction

function Register_Quest_Caravan_HorsesVulnerable takes nothing returns nothing
    set gg_trg_Quest_Caravan_HorsesVulnerable=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_HorsesVulnerable)
    call TriggerRegisterLeaveRectSimple(gg_trg_Quest_Caravan_HorsesVulnerable,gg_rct_498)
    call TriggerAddCondition(gg_trg_Quest_Caravan_HorsesVulnerable,Condition(function Trig_Quest_Caravan_HorsesVulnerable_Conditions))
    call TriggerAddAction(gg_trg_Quest_Caravan_HorsesVulnerable,function Trig_Quest_Caravan_HorsesVulnerable_Actions)
endfunction

function Register_Quest_Caravan_Deliver takes nothing returns nothing
    set gg_trg_Quest_Caravan_Deliver=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_Deliver)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Caravan_Deliver,450.,gg_unit_n00B_0054)
    call TriggerAddCondition(gg_trg_Quest_Caravan_Deliver,Condition(function Trig_Quest_Caravan_Deliver_Conditions))
    call TriggerAddAction(gg_trg_Quest_Caravan_Deliver,function Trig_Quest_Caravan_Deliver_Actions)
endfunction

function Register_Quest_Caravan_Failed takes nothing returns nothing
    set gg_trg_Quest_Caravan_Failed=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_Failed)
    call TriggerRegisterUnitEvent(gg_trg_Quest_Caravan_Failed,gg_unit_hrdh_0102,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_Caravan_Failed,gg_unit_hrdh_0103,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_Caravan_Failed,gg_unit_hrdh_0104,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Quest_Caravan_Failed,Condition(function Trig_Quest_Caravan_Failed_Conditions))
    call TriggerAddAction(gg_trg_Quest_Caravan_Failed,function Trig_Quest_Caravan_Failed_Actions)
endfunction

function Register_Quest_Caravan_Ping takes nothing returns nothing
    set gg_trg_Quest_Caravan_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_Caravan_Ping,15.)
    call TriggerAddCondition(gg_trg_Quest_Caravan_Ping,Condition(function Trig_Quest_Caravan_Ping_Conditions))
    call TriggerAddAction(gg_trg_Quest_Caravan_Ping,function Trig_Quest_Caravan_Ping_Actions)
endfunction

function Register_Quest_Caravan_Complete takes nothing returns nothing
    set gg_trg_Quest_Caravan_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Caravan_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Caravan_Complete,450.,gg_unit_n00A_0101)
    call TriggerAddCondition(gg_trg_Quest_Caravan_Complete,Condition(function Trig_Quest_Caravan_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_Caravan_Complete,function Trig_Quest_Caravan_Complete_Actions)
endfunction

endlibrary
