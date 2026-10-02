library TDragonEgg requires TCam, TCine, TForce, TPlayerPart01, TReward, TText, TUnit
function Trig_DragonEgg_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e016_0019,true,true,true))
endfunction

function Trig_DragonEgg_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DragonEgg_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[79])
    if(Trig_DragonEgg_Start_IsDialogueOn())then
        call PauseUnitBJ(true,gg_unit_e016_0019)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e016_0019,"Well met, rare guests. My name is Kiemarl. It is not often that we see people from Gaya in our little village.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So we've heard. We're still not exactly sure what this place is exactly.",false)
        call Text_Say(gg_unit_e016_0019,"Ah, well we're originally from Lothlorien. We've secluded ourselves here at the behest of Lady Dana and Lord Famfrit. They told us that staying would be dangerous.",false)
        call Text_Say(gg_unit_e016_0019,"We have heard nothing from Gaya since, but we all trust Lady Dana.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Heard nothing from Gaya? What do you mean?",false)
        call Text_Say(gg_unit_e016_0019,"We phantom villagers... do not reside in Gaya. Rather in what you could call the underside of Gaya. You can merely speak to us thanks to the Maiden's Eye.",false)
        call Text_Say(gg_unit_e016_0019,"Lady Dana is the only one among us with the power to exist in both planes at once.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"She has that kind of power, does she...",false)
        call Text_Say(gg_unit_e016_0019,"Yep. It's a testament to her power. She is truly peerless.",false)
        call Text_Say(gg_unit_e016_0019,"Well since I heard you were adventurers, there's something I'd actually like to ask of you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, but can we help someone in another world at all?",false)
        call Text_Say(gg_unit_e016_0019,"That's precisely it. I said earlier that Lady Dana is the only one among us with the power to be in both worlds. But she is not the only being capable of it.",false)
        call Text_Say(gg_unit_e016_0019,"There is a marsh to the west of here populated by dragons. They are very powerful and dangerous beasts. And they, too, have the power to inhabit both worlds.",false)
        call Text_Say(gg_unit_e016_0019,"They are dangerous for us to encounter, however, if they were on our side they would be a great help in allowing us to affect Gaya as well. So if you consider yourselves powerful enough I'd like to ask you to sneak or fight your way in and steal an egg of dragons.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A dragon egg is it? Sounds dangerous, but we'll manage. Could you even give us a reward for this task, though?",false)
        call Text_Say(gg_unit_e016_0019,"Worry not, I will have Lady Dana prepare it. Thanks!",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_e016_0019)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Dragon Egg|r")
    set udg_SideQuest[59]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Dragon Egg"),"Kiemarl from the Phantom Village has asked you to bring him a Dragon Egg from the very dangerous Dark Dragon Marsh.","ReplaceableTextures\\CommandButtons\\BTNThunderLizardEgg.blp")
    set udg_SpecialEffect[79]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e016_0019,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_TempPoint=GetRectCenter(gg_rct_686)
    set udg_QuestItem[$C]=CreateItemLoc('I0I0',udg_TempPoint) // $C = 12; 'I0I0': item "Dragon Egg"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_DragonEgg_Ping)
    call EnableTrigger(gg_trg_DragonEgg_PickUp)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DragonEgg_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[$C]!=null) // $C = 12
endfunction

function Trig_DragonEgg_Ping_IsEggCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[$C])) // $C = 12
endfunction

function Trig_DragonEgg_Ping_Actions takes nothing returns nothing
    if(Trig_DragonEgg_Ping_IsEggCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_e016_0019)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[$C]) // $C = 12
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_DragonEgg_PickUp_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0I0') // 'I0I0': item "Dragon Egg"
endfunction

function Trig_DragonEgg_PickUp_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Dragon Egg to Kiemarl.")
    call DestroyForce(udg_TempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[59],"Bring the Dragon Egg to Kiemarl.")
    call EnableTrigger(gg_trg_DragonEgg_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DragonEgg_Fail_Actions takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[79])
    call RemoveItem(udg_QuestItem[$C]) // $C = 12
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Dragon Egg|r")
    call QuestSetFailedBJ(udg_SideQuest[59],true)
    call DisableTrigger(gg_trg_DragonEgg_Ping)
    call DestroyTrigger(gg_trg_DragonEgg_Ping)
    call DestroyTrigger(gg_trg_DragonEgg_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DragonEgg_Reward_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0I0'))and(IsUnitVisible(gg_unit_e016_0019,GetOwningPlayer(GetTriggerUnit())))and(udg_InCinematicMode==false) // 'I0I0': item "Dragon Egg"
endfunction

function Trig_DragonEgg_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DragonEgg_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_DragonEgg_Ping)
    call DestroyTrigger(gg_trg_DragonEgg_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0I0')) // 'I0I0': item "Dragon Egg"
    call DestroyEffectBJ(udg_SpecialEffect[79])
    if(Trig_DragonEgg_Reward_IsDialogueOn())then
        call PauseUnitBJ(true,gg_unit_e016_0019)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here you go. We found a dragon egg for you.",false)
        call Text_Say(gg_unit_e016_0019,"Wonderful. We shall take good care of it.",false)
        call Reward_Give($BB8,$BB8,gg_unit_e016_0019) // $BB8 = 3000
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_e016_0019)
    else
        call Reward_Give($BB8,$BB8,gg_unit_e016_0019) // $BB8 = 3000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Dragon Egg|r")
    call QuestSetCompletedBJ(udg_SideQuest[59],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_PhantomVillagersMet=(udg_PhantomVillagersMet+1)
    call DestroyTrigger(gg_trg_DragonEgg_Fail)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DragonEgg takes nothing returns nothing
endfunction

function RegisterR11_DragonEgg_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DragonEgg_Start=CreateTrigger()

call DisableTrigger(gg_trg_DragonEgg_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonEgg_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonEgg_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonEgg_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonEgg_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonEgg_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonEgg_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonEgg_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DragonEgg_Start,Player(7),true)

call TriggerAddCondition(gg_trg_DragonEgg_Start,Condition(function Trig_DragonEgg_Start_Conditions))

call TriggerAddAction(gg_trg_DragonEgg_Start,function Trig_DragonEgg_Start_Actions)

endfunction




function RegisterR11_DragonEgg_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DragonEgg_Ping=CreateTrigger()

call DisableTrigger(gg_trg_DragonEgg_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_DragonEgg_Ping,15.)

call TriggerAddCondition(gg_trg_DragonEgg_Ping,Condition(function Trig_DragonEgg_Ping_Conditions))

call TriggerAddAction(gg_trg_DragonEgg_Ping,function Trig_DragonEgg_Ping_Actions)

endfunction




function RegisterR11_DragonEgg_PickUp takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DragonEgg_PickUp=CreateTrigger()

call DisableTrigger(gg_trg_DragonEgg_PickUp)

call TriggerRegisterAnyUnitEventBJ(gg_trg_DragonEgg_PickUp,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_DragonEgg_PickUp,Condition(function Trig_DragonEgg_PickUp_Conditions))

call TriggerAddAction(gg_trg_DragonEgg_PickUp,function Trig_DragonEgg_PickUp_Actions)

endfunction




function RegisterR11_DragonEgg_Fail takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DragonEgg_Fail=CreateTrigger()

call DisableTrigger(gg_trg_DragonEgg_Fail)

call TriggerAddAction(gg_trg_DragonEgg_Fail,function Trig_DragonEgg_Fail_Actions)

endfunction




function RegisterR11_DragonEgg_Reward takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DragonEgg_Reward=CreateTrigger()

call DisableTrigger(gg_trg_DragonEgg_Reward)

call TriggerRegisterUnitInRangeSimple(gg_trg_DragonEgg_Reward,200.,gg_unit_e016_0019)

call TriggerRegisterUnitInRangeSimple(gg_trg_DragonEgg_Reward,450.,gg_unit_e016_0019)

call TriggerAddCondition(gg_trg_DragonEgg_Reward,Condition(function Trig_DragonEgg_Reward_Conditions))

call TriggerAddAction(gg_trg_DragonEgg_Reward,function Trig_DragonEgg_Reward_Actions)

endfunction




endlibrary
