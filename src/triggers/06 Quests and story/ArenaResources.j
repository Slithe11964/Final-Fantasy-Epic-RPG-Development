library TArenaResources requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_ArenaResources_Prepare_Actions takes nothing returns nothing
    set udg_ArenaEscortReward=$DAC // $DAC = 3500
    set udg_SpecialEffect[59]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e008_0132,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_ArenaResources_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ArenaResources_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e008_0132,true,true,true))
endfunction

function Trig_ArenaResources_Start_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ArenaResources_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[59])
    if(Trig_ArenaResources_Start_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e008_0132,"Oh, hi there. My name is Limma.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello. How can we help you?",false)
        call Text_Say(gg_unit_e008_0132,"As we have recently established stronger ties to your settlement, I heard something that caught my interest.",false)
        call Text_Say(gg_unit_e008_0132,"It seems that your kin has constructed a Battle Arena to help potential heroes gain some experience and challenge strong foes.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That is correct. What are you getting at?",false)
        call Text_Say(gg_unit_e008_0132,"I think we Night Elves could help you expand on this project. We could import monsters we caught ourselves and maybe even use our magical abilities to simulate fights that would normally be impossible.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds great! Why ask us, specifically?",false)
        call Text_Say(gg_unit_e008_0132,"Because I do need help, and you are adventurers. You take an interest in gold, do you not? I am prepared to reward you generously if you are to aid me.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We're in. So what do you want us to do?",false)
        call Text_Say(gg_unit_e008_0132,"I need help transporting some resources to the arena. Your job is to protect the ship until it's safely arrived at its destination.",false)
        call Text_Say(gg_unit_e008_0132,"I will be waiting for you at the eastern part of the islands, with the ship. Meet me there and we can go.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Arena Resources|r")
    set udg_SideQuest[37]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Arena Resources"),"Limma, ranger from Lothlorien, has asked you to help her escort a ship of supplies to the arena. Meet her in the eastern part of the Naga Islands.","ReplaceableTextures\\CommandButtons\\BTNNightElfTransport.blp")
    call SetUnitOwner(gg_unit_e008_0132,Player(8),false)
    set udg_TempPoint=GetRectCenter(gg_rct_232)
    call SetUnitPositionLocFacingBJ(gg_unit_e008_0132,udg_TempPoint,180.)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_232)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,384.,0)
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'e00E',Player(9),udg_TempPoint2,180.) // 'e00E': unit "Night Elf Supply Ship"
    call RemoveLocation(udg_TempPoint2)
    set udg_SupplyShip=GetLastCreatedUnit()
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call TriggerRegisterUnitEvent(gg_trg_ArenaResources_ShipLost,udg_SupplyShip,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_ArenaResources_ShipDamaged,udg_SupplyShip,EVENT_UNIT_DAMAGED)
    call GroupAddUnitSimple(gg_unit_e008_0132,udg_BossUnits)
    call Wait_Polled(1.)
    set udg_SpecialEffect[59]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e008_0132,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_ArenaResources_Escort)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ArenaResources_Escort_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e008_0132,true,true,true))
endfunction

function Trig_ArenaResources_Escort_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ArenaResources_Escort_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[59])
    call GroupRemoveUnitSimple(gg_unit_e008_0132,udg_BossUnits)
    if(Trig_ArenaResources_Escort_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e008_0132,"Ah, there you are.",false)
        call Text_Say(gg_unit_e008_0132,"We will use this ship to transport the supplies. And don't let monsters steal them! Let's go.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Safely escort the ship to the battle arena.")
    call QuestSetDescriptionBJ(udg_SideQuest[37],"Safely escort the ship to the battle arena.")
    call SetUnitInvulnerable(udg_SupplyShip,false)
    call PauseUnitBJ(false,udg_SupplyShip)
    call UnitAddAbilityBJ('A11M',udg_SupplyShip) // 'A11M': ability "Aggressor"
    set udg_TempPoint=GetRectCenter(gg_rct_393)
    call IssuePointOrderLocBJ(udg_SupplyShip,"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_342)
    call IssuePointOrderLocBJ(gg_unit_e008_0132,"attack",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call SetUnitOwner(gg_unit_e008_0132,Player(9),false)
    call SetUnitAcquireRangeBJ(gg_unit_e008_0132,600.)
    call GroupAddUnitSimple(udg_SupplyShip,udg_BossUnits)
    call EnableTrigger(gg_trg_ArenaResources_ShipLost)
    call EnableTrigger(gg_trg_ArenaResources_ShipDamaged)
    call EnableTrigger(gg_trg_ArenaResources_Complete)
    set udg_ShipUndamaged=true
    call Wait_Polled(5.)
    call EnableTrigger(gg_trg_ArenaResources_ShipMove)
endfunction

function Trig_ArenaResources_ShipMove_Cond_LimmaTooFar takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)>=3000.)
endfunction

function Trig_ArenaResources_ShipMove_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_393)
    call IssuePointOrderLocBJ(udg_SupplyShip,"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(udg_SupplyShip)
    set udg_TempPoint2=GetUnitLoc(gg_unit_e008_0132)
    if(Trig_ArenaResources_ShipMove_Cond_LimmaTooFar())then
        call IssuePointOrderLocBJ(gg_unit_e008_0132,"move",udg_TempPoint)
    else
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=GetRectCenter(gg_rct_352)
        call IssuePointOrderLocBJ(gg_unit_e008_0132,"attack",udg_TempPoint)
    endif
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
endfunction

function Trig_ArenaResources_ShipDamaged_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_SupplyShip)and(GetEventDamage()>.0)and(udg_IsPureDamage==false)
endfunction

function Trig_ArenaResources_ShipDamaged_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_ShipUndamaged=false
endfunction

function Trig_ArenaResources_ShipLost_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_SupplyShip)
endfunction

function Trig_ArenaResources_ShipLost_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ArenaResources_ShipLost_Cond_CanReduceReward takes nothing returns boolean
    return(udg_ArenaEscortReward>500)
endfunction

function Trig_ArenaResources_ShipLost_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_ArenaResources_ShipMove)
    call DisableTrigger(gg_trg_ArenaResources_Complete)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    if(Trig_ArenaResources_ShipLost_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e008_0132,0)
        call Text_Say(gg_unit_e008_0132,"Oh no, the ship has been destroyed! We have to go back and get another ship!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Talk to Limma to try again.")
    call QuestSetDescriptionBJ(udg_SideQuest[37],"The ship has been destroyed! Talk to Limma once again.")
    call RemoveUnit(udg_SupplyShip)
    call SetUnitOwner(gg_unit_e008_0132,Player(8),false)
    if(Trig_ArenaResources_ShipLost_Cond_CanReduceReward())then
        // Decrease udg_ArenaEscortReward by 1000.
        set udg_ArenaEscortReward=(udg_ArenaEscortReward-$3E8) // $3E8 = 1000
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_232)
    call SetUnitPositionLocFacingBJ(gg_unit_e008_0132,udg_TempPoint,180.)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_232)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,384.,0)
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'e00E',Player(9),udg_TempPoint2,180.) // 'e00E': unit "Night Elf Supply Ship"
    call RemoveLocation(udg_TempPoint2)
    set udg_SupplyShip=GetLastCreatedUnit()
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call TriggerRegisterUnitEvent(gg_trg_ArenaResources_ShipLost,udg_SupplyShip,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_ArenaResources_ShipDamaged,udg_SupplyShip,EVENT_UNIT_DAMAGED)
    set udg_SpecialEffect[59]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e008_0132,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_ArenaResources_Escort)
    call GroupAddUnitSimple(gg_unit_e008_0132,udg_BossUnits)
endfunction

function Trig_ArenaResources_Complete_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_SupplyShip)
endfunction

function Trig_ArenaResources_Complete_Cond_ShipUndamagedNoTalk takes nothing returns boolean
    return(udg_ShipUndamaged)
endfunction

function Trig_ArenaResources_Complete_Cond_ShipUndamaged takes nothing returns boolean
    return(udg_ShipUndamaged)
endfunction

function Trig_ArenaResources_Complete_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_ArenaResources_Complete_Cond_GateStillClosed takes nothing returns boolean
    return(udg_ArenaGateOpened==false)
endfunction

function Trig_ArenaResources_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_ArenaResources_ShipMove)
    call DisableTrigger(gg_trg_ArenaResources_ShipDamaged)
    call DisableTrigger(gg_trg_ArenaResources_ShipLost)
    call SetUnitOwner(gg_unit_e008_0132,Player(8),false)
    if(Trig_ArenaResources_Complete_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e008_0132,0)
        call Text_Say(gg_unit_e008_0132,"Thank you very much. The ship has been successfully escorted.",false)
        if(Trig_ArenaResources_Complete_Cond_ShipUndamaged())then
            call Text_Say(gg_unit_e008_0132,"Wow, it seems like none of the goods have been scratched in the slightest! Very impressive!",false)
            // Increase udg_ArenaEscortReward by 2500.
            set udg_ArenaEscortReward=(udg_ArenaEscortReward+$9C4) // $9C4 = 2500
        endif
        call Reward_Give(udg_ArenaEscortReward,$DAC,gg_unit_e008_0132) // $DAC = 3500
        call Text_Say(gg_unit_e008_0132,"I will make some preparations. I might need your help some more later.",false)
        call Cine_ExitAction()
    else
        if(Trig_ArenaResources_Complete_Cond_ShipUndamagedNoTalk())then
            // Increase udg_ArenaEscortReward by 2500.
            set udg_ArenaEscortReward=(udg_ArenaEscortReward+$9C4) // $9C4 = 2500
        endif
        call Reward_Give(udg_ArenaEscortReward,$DAC,gg_unit_e008_0132) // $DAC = 3500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Arena Resources|r")
    call QuestSetCompletedBJ(udg_SideQuest[37],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddUnitToStockBJ('n0BA',gg_unit_e014_0149,1,1) // 'n0BA': unit "Hunt: Adamantaimai"
    set udg_HuntStock[6]=(udg_HuntStock[6]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call RemoveUnit(udg_SupplyShip)
    if(Trig_ArenaResources_Complete_Cond_GateStillClosed())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,"Limma opened the gate to the Battle Arena.")
        set udg_ArenaGateOpened=true
        call DisableTrigger(gg_trg_Arena_GateWrongSide)
        call DisableTrigger(gg_trg_Arena_GateOpen)
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_ZTsg_0025)
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_233)
    call SetUnitPositionLocFacingBJ(gg_unit_e008_0132,udg_TempPoint,270.)
    call RemoveLocation(udg_TempPoint)
    call UnitRemoveAbilityBJ('A03N',gg_unit_e008_0132) // 'A03N': ability "Night Might"
    call EnableTrigger(gg_trg_ArenaExpansion_Prepare)
    call StartTimerBJ(udg_SharedDelayTimer2,false,180.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_ArenaResources takes nothing returns nothing
endfunction

function RegisterR11_ArenaResources_Prepare takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaResources_Prepare=CreateTrigger()

call DisableTrigger(gg_trg_ArenaResources_Prepare)

call TriggerAddAction(gg_trg_ArenaResources_Prepare,function Trig_ArenaResources_Prepare_Actions)

endfunction




function RegisterR11_ArenaResources_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaResources_Start=CreateTrigger()

call DisableTrigger(gg_trg_ArenaResources_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Start,Player(7),true)

call TriggerAddCondition(gg_trg_ArenaResources_Start,Condition(function Trig_ArenaResources_Start_Conditions))

call TriggerAddAction(gg_trg_ArenaResources_Start,function Trig_ArenaResources_Start_Actions)

endfunction




function RegisterR11_ArenaResources_Escort takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaResources_Escort=CreateTrigger()

call DisableTrigger(gg_trg_ArenaResources_Escort)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Escort,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Escort,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Escort,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Escort,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Escort,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Escort,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Escort,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ArenaResources_Escort,Player(7),true)

call TriggerAddCondition(gg_trg_ArenaResources_Escort,Condition(function Trig_ArenaResources_Escort_Conditions))

call TriggerAddAction(gg_trg_ArenaResources_Escort,function Trig_ArenaResources_Escort_Actions)

endfunction




function RegisterR11_ArenaResources_ShipMove takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaResources_ShipMove=CreateTrigger()

call DisableTrigger(gg_trg_ArenaResources_ShipMove)

call TriggerRegisterTimerEventPeriodic(gg_trg_ArenaResources_ShipMove,4.)

call TriggerAddAction(gg_trg_ArenaResources_ShipMove,function Trig_ArenaResources_ShipMove_Actions)

endfunction




function RegisterR11_ArenaResources_ShipDamaged takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaResources_ShipDamaged=CreateTrigger()

call DisableTrigger(gg_trg_ArenaResources_ShipDamaged)

call TriggerAddCondition(gg_trg_ArenaResources_ShipDamaged,Condition(function Trig_ArenaResources_ShipDamaged_Conditions))

call TriggerAddAction(gg_trg_ArenaResources_ShipDamaged,function Trig_ArenaResources_ShipDamaged_Actions)

endfunction




function RegisterR11_ArenaResources_ShipLost takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaResources_ShipLost=CreateTrigger()

call DisableTrigger(gg_trg_ArenaResources_ShipLost)

call TriggerAddCondition(gg_trg_ArenaResources_ShipLost,Condition(function Trig_ArenaResources_ShipLost_Conditions))

call TriggerAddAction(gg_trg_ArenaResources_ShipLost,function Trig_ArenaResources_ShipLost_Actions)

endfunction




function RegisterR11_ArenaResources_Complete takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_ArenaResources_Complete=CreateTrigger()

call DisableTrigger(gg_trg_ArenaResources_Complete)

call TriggerRegisterEnterRectSimple(gg_trg_ArenaResources_Complete,gg_rct_393)

call TriggerAddCondition(gg_trg_ArenaResources_Complete,Condition(function Trig_ArenaResources_Complete_Conditions))

call TriggerAddAction(gg_trg_ArenaResources_Complete,function Trig_ArenaResources_Complete_Actions)

endfunction




endlibrary
