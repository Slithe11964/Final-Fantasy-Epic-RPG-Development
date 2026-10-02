library THydraEgg requires TCam, TCine, TForce, TLoc, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_HydraEgg_Prepare_Actions takes nothing returns nothing
    set udg_SpecialEffect[36]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hapm_0179,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HydraEgg_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hapm_0179,true,true,true))
endfunction

function Trig_HydraEgg_Start_Cond_ShowJackTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HydraEgg_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[36])
    if(Trig_HydraEgg_Start_Cond_ShowJackTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hapm_0179,"Greetings to you. My name is Jack Adams but you can call me Captain Jack.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hi Jack. You say you are a captain but where is your ship?",false)
        call Text_Say(gg_unit_Hapm_0179,"Destroyed by those foul Naga. And my whole crew was slain by those evil creatures. I am the only survivor. I can swim very fast, so I got away while they butchered my crew. Believe me, I am no coward but the Naga are too strong for me too handle.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We specialize on eradicating evil in all forms. For a reasonable price we could deal with those Naga that attacked you.",false)
        call Text_Say(gg_unit_Hapm_0179,"I lost everything when my ship sank so I have no gold. And I doubt you will be able to kill those Naga because their lair is located underwater. But I have already devised a plan of vengeance.",false)
        call Text_Say(gg_unit_Hapm_0179,"During my travels I learned that if you are the first person Hydra Hatchling sees when it hatches out it will think you are its parent.",false)
        call Text_Say(gg_unit_Hapm_0179,"And with proper skills you can train Hydra to be your loyal pet. When it grows you will have a formidable ally at your side. I know what I am talking about - I met a Beastmaster who told me everything about it.",false)
        call Text_Say(gg_unit_Hapm_0179,"And if I have a strong Hydra who obeys my commands not even the Naga will be a problem and I will have my vengeance.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"But now I see no Hydra near you.",false)
        call Text_Say(gg_unit_Hapm_0179,"That's where you come in. First I need Hydra egg. You can only get it when killing Hydra because Hydras carry their eggs inside their belly. Hydras may be found on the island to the east but there are many other monsters there so I don't dare to go there.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And what if we bring you the Hydra Egg?",false)
        call Text_Say(gg_unit_Hapm_0179,"I have no gold but I have one precious item that may be very useful for adventurers like you. I will give it to you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It's a deal then.",false)
        call Text_Say(gg_unit_Hapm_0179,"Great. But please remember that chance of getting an undamaged egg when killing a Hydra is low. You will probably have to kill many Hydras before you get a proper egg. Good luck to you.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Hydra Egg|r")
    set udg_SideQuest[18]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffHydra Egg","Jack, captain who resides near Shipyard, asked you to bring him Hydra egg.","ReplaceableTextures\\CommandButtons\\BTNGreenHydra.blp")
    set udg_SpecialEffect[36]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hapm_0179,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_HydraEgg_Drop)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HydraEgg_Drop_Cond_DyingIsHydra takes nothing returns boolean
    return(GetUnitTypeId(GetDyingUnit())=='nhyh')or(GetUnitTypeId(GetDyingUnit())=='nhyd')or(GetUnitTypeId(GetDyingUnit())=='nehy')or(GetUnitTypeId(GetDyingUnit())=='nahy') // 'nhyh': object name not found in map data; 'nhyd': object name not found in map data; 'nehy': object name not found in map data; 'nahy': object name not found in map data
endfunction

function Trig_HydraEgg_Drop_Conditions takes nothing returns boolean
    // A random whole number from 1 through 10.
    return((IsUnitType(GetDyingUnit(),UNIT_TYPE_SUMMONED)==false)and(Trig_HydraEgg_Drop_Cond_DyingIsHydra())and(GetRandomInt(1,$A)<=3)and(GetUnitUserData(GetTriggerUnit())<=9))!=null // $A = 10
endfunction

function Trig_HydraEgg_Drop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[19]=CreateItemLoc('thle',udg_TempPoint) // 'thle': item "Hydra Egg"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_HydraEgg_Ping)
    call EnableTrigger(gg_trg_HydraEgg_Pickup)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HydraEgg_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='thle') // 'thle': item "Hydra Egg"
endfunction

function Trig_HydraEgg_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Hydra Egg to Captain Jack.")
    call DestroyForce(udg_TempForce)
    call QuestSetDescriptionBJ(udg_SideQuest[18],"Bring the Hydra Egg to Captain Jack.")
    call EnableTrigger(gg_trg_HydraEgg_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HydraEgg_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[19]!=null)
endfunction

function Trig_HydraEgg_Ping_Cond_EggCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[19]))
endfunction

function Trig_HydraEgg_Ping_Actions takes nothing returns nothing
    if(Trig_HydraEgg_Ping_Cond_EggCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_Hapm_0179)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[19])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_HydraEgg_Deliver_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'thle'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'thle': item "Hydra Egg"
endfunction

function Trig_HydraEgg_Deliver_Cond_ShowThanksTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HydraEgg_Deliver_GiveWaterMateria takes nothing returns nothing
    call UnitAddItemByIdSwapped('I023',Player_GetHero(GetEnumPlayer())) // 'I023': item "Water Materia"
endfunction

function Trig_HydraEgg_Deliver_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_HydraEgg_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thle')) // 'thle': item "Hydra Egg"
    call DestroyEffectBJ(udg_SpecialEffect[36])
    if(Trig_HydraEgg_Deliver_Cond_ShowThanksTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Hapm_0179,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hello Jack. We brought you the Hydra Egg.",false)
        call Text_Say(gg_unit_Hapm_0179,"Thank you. And please take this item as a reward.",false)
        call Reward_Give(0,$5DC,gg_unit_Hapm_0179) // $5DC = 1500
        call Text_Say(gg_unit_Hapm_0179,"|n|cffffcc00All players get a piece of Water Materia.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give(0,$5DC,gg_unit_Hapm_0179) // $5DC = 1500
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00All players get a piece of Water Materia.|r")
    endif
    call ForForce(udg_PlayingPlayers,function Trig_HydraEgg_Deliver_GiveWaterMateria)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Hydra Egg|r")
    call QuestSetCompletedBJ(udg_SideQuest[18],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call Wait_Polled(600.)
    set udg_TempPoint=GetUnitLoc(gg_unit_Hapm_0179)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,260.)
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'n02X',Player(9),udg_TempPoint2,208.) // 'n02X': unit "Jack's Little Hydra"
    call RemoveLocation(udg_TempPoint2)
    set udg_QuestMarkerEffect[21]=AddSpecialEffectTargetUnitBJ("head",gg_unit_Hapm_0179,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call EnableTrigger(gg_trg_Npc_Talk_Jack)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_HydraEgg automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HydraEgg (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HydraEgg takes nothing returns nothing
endfunction

function Register_HydraEgg_Prepare takes nothing returns nothing
    set gg_trg_HydraEgg_Prepare=CreateTrigger()
    call TriggerAddAction(gg_trg_HydraEgg_Prepare,function Trig_HydraEgg_Prepare_Actions)
endfunction

function Register_HydraEgg_Start takes nothing returns nothing
    set gg_trg_HydraEgg_Start=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HydraEgg_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HydraEgg_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HydraEgg_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HydraEgg_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HydraEgg_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HydraEgg_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HydraEgg_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HydraEgg_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_HydraEgg_Start,Condition(function Trig_HydraEgg_Start_Conditions))
    call TriggerAddAction(gg_trg_HydraEgg_Start,function Trig_HydraEgg_Start_Actions)
endfunction

function Register_HydraEgg_Drop takes nothing returns nothing
    set gg_trg_HydraEgg_Drop=CreateTrigger()
    call DisableTrigger(gg_trg_HydraEgg_Drop)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HydraEgg_Drop,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_HydraEgg_Drop,Condition(function Trig_HydraEgg_Drop_Conditions))
    call TriggerAddAction(gg_trg_HydraEgg_Drop,function Trig_HydraEgg_Drop_Actions)
endfunction

function Register_HydraEgg_Pickup takes nothing returns nothing
    set gg_trg_HydraEgg_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_HydraEgg_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HydraEgg_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_HydraEgg_Pickup,Condition(function Trig_HydraEgg_Pickup_Conditions))
    call TriggerAddAction(gg_trg_HydraEgg_Pickup,function Trig_HydraEgg_Pickup_Actions)
endfunction

function Register_HydraEgg_Ping takes nothing returns nothing
    set gg_trg_HydraEgg_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_HydraEgg_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_HydraEgg_Ping,15.)
    call TriggerAddCondition(gg_trg_HydraEgg_Ping,Condition(function Trig_HydraEgg_Ping_Conditions))
    call TriggerAddAction(gg_trg_HydraEgg_Ping,function Trig_HydraEgg_Ping_Actions)
endfunction

function Register_HydraEgg_Deliver takes nothing returns nothing
    set gg_trg_HydraEgg_Deliver=CreateTrigger()
    call DisableTrigger(gg_trg_HydraEgg_Deliver)
    call TriggerRegisterUnitInRangeSimple(gg_trg_HydraEgg_Deliver,450.,gg_unit_Hapm_0179)
    call TriggerAddCondition(gg_trg_HydraEgg_Deliver,Condition(function Trig_HydraEgg_Deliver_Conditions))
    call TriggerAddAction(gg_trg_HydraEgg_Deliver,function Trig_HydraEgg_Deliver_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HydraEgg takes nothing returns nothing
    call Register_HydraEgg_Prepare()
    call Register_HydraEgg_Start()
    call Register_HydraEgg_Drop()
    call Register_HydraEgg_Pickup()
    call Register_HydraEgg_Ping()
    call Register_HydraEgg_Deliver()
endfunction

endlibrary
