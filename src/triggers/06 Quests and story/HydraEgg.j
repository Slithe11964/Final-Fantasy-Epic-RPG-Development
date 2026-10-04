library THydraEgg requires TQuestEngine, TCam, TCine, TForce, TLoc, TPlayerHero, TReward, TText, TWait
// Side quest "Hydra Egg", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Captain Jack wants a Hydra Egg to raise a Hydra and take revenge on the Naga. Available from the start
// (MapBootstrap runs gg_trg_HydraEgg_Prepare). After the talk, hydras may drop the egg (gg_trg_HydraEgg_Drop);
// the hand-in stays in gg_trg_HydraEgg_Deliver: its dialogue ends with a notice that is shown even when the
// cinematic is skipped, and Jack's little Hydra appears 10 minutes later. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HydraEgg_Prepare=null
    trigger gg_trg_HydraEgg_Drop=null
    trigger gg_trg_HydraEgg_Pickup=null
    trigger gg_trg_HydraEgg_Ping=null
    trigger gg_trg_HydraEgg_Deliver=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_HYDRA_EGG=0
endglobals

// Step 1 done (the party talked to Jack): hydras may now drop the egg.
function HydraEgg_Started takes nothing returns nothing
    call EnableTrigger(gg_trg_HydraEgg_Drop)
endfunction

function HydraEgg_Define takes nothing returns nothing
    local integer q=Quest_Define("Hydra Egg",QUEST_SIDE,18,"ReplaceableTextures\\CommandButtons\\BTNGreenHydra.blp")
    set QUEST_HYDRA_EGG=q
    call Quest_NotStory(q)
    // 1. Talk to Captain Jack
    call Quest_Talk(q,gg_unit_Hapm_0179,"Jack, captain who resides near Shipyard, asked you to bring him Hydra egg.")
    call Quest_Say(q,gg_unit_Hapm_0179,"Greetings to you. My name is Jack Adams but you can call me Captain Jack.")
    call Quest_Say(q,null,"Hi Jack. You say you are a captain but where is your ship?")
    call Quest_Say(q,gg_unit_Hapm_0179,"Destroyed by those foul Naga. And my whole crew was slain by those evil creatures. I am the only survivor. I can swim very fast, so I got away while they butchered my crew. Believe me, I am no coward but the Naga are too strong for me too handle.")
    call Quest_Say(q,null,"We specialize on eradicating evil in all forms. For a reasonable price we could deal with those Naga that attacked you.")
    call Quest_Say(q,gg_unit_Hapm_0179,"I lost everything when my ship sank so I have no gold. And I doubt you will be able to kill those Naga because their lair is located underwater. But I have already devised a plan of vengeance.")
    call Quest_Say(q,gg_unit_Hapm_0179,"During my travels I learned that if you are the first person Hydra Hatchling sees when it hatches out it will think you are its parent.")
    call Quest_Say(q,gg_unit_Hapm_0179,"And with proper skills you can train Hydra to be your loyal pet. When it grows you will have a formidable ally at your side. I know what I am talking about - I met a Beastmaster who told me everything about it.")
    call Quest_Say(q,gg_unit_Hapm_0179,"And if I have a strong Hydra who obeys my commands not even the Naga will be a problem and I will have my vengeance.")
    call Quest_Say(q,null,"But now I see no Hydra near you.")
    call Quest_Say(q,gg_unit_Hapm_0179,"That's where you come in. First I need Hydra egg. You can only get it when killing Hydra because Hydras carry their eggs inside their belly. Hydras may be found on the island to the east but there are many other monsters there so I don't dare to go there.")
    call Quest_Say(q,null,"And what if we bring you the Hydra Egg?")
    call Quest_Say(q,gg_unit_Hapm_0179,"I have no gold but I have one precious item that may be very useful for adventurers like you. I will give it to you.")
    call Quest_Say(q,null,"It's a deal then.")
    call Quest_Say(q,gg_unit_Hapm_0179,"Great. But please remember that chance of getting an undamaged egg when killing a Hydra is low. You will probably have to kill many Hydras before you get a proper egg. Good luck to you.")
    call Quest_OnDone(q,"HydraEgg_Started")
    // 2. Bring Jack a Hydra Egg (gg_trg_HydraEgg_Pickup / gg_trg_HydraEgg_Deliver)
    call Quest_Custom(q,"")
endfunction

// At map start: the "!" over Jack; the quest can start.
function Trig_HydraEgg_Prepare_Actions takes nothing returns nothing
    if QUEST_HYDRA_EGG==0 then
        call HydraEgg_Define()
    endif
    call Quest_MakeAvailable(QUEST_HYDRA_EGG)
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
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[19]=CreateItemLoc('thle',l_tempPoint) // 'thle': item "Hydra Egg"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(l_tempPoint)
    call EnableTrigger(gg_trg_HydraEgg_Ping)
    call EnableTrigger(gg_trg_HydraEgg_Pickup)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_HydraEgg_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='thle') // 'thle': item "Hydra Egg"
endfunction

// Someone picked up the egg: only that player is told; the quest log changes for everyone.
function Trig_HydraEgg_Pickup_Actions takes nothing returns nothing
    local force l_tempForce
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call QuestMessageBJ(l_tempForce,bj_QUESTMESSAGE_UPDATED,"Bring the Hydra Egg to Captain Jack.")
    call DestroyForce(l_tempForce)
    call Quest_SetLog(QUEST_HYDRA_EGG,"Bring the Hydra Egg to Captain Jack.",false)
    call EnableTrigger(gg_trg_HydraEgg_Deliver)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempForce=null
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

// Step 2: a hero brings the egg to Jack. Every player gets Water Materia; 10 minutes later Jack's little
// Hydra has hatched.
function Trig_HydraEgg_Deliver_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_HydraEgg_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thle')) // 'thle': item "Hydra Egg"
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
    call Quest_StepDone(QUEST_HYDRA_EGG,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call Wait_Polled(600.)
    set l_tempPoint=GetUnitLoc(gg_unit_Hapm_0179)
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,128.,260.)
    call RemoveLocation(l_tempPoint)
    call CreateNUnitsAtLoc(1,'n02X',Player(9),l_tempPoint2,208.) // 'n02X': unit "Jack's Little Hydra"
    call RemoveLocation(l_tempPoint2)
    set udg_QuestMarkerEffect[21]=AddSpecialEffectTargetUnitBJ("head",gg_unit_Hapm_0179,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call EnableTrigger(gg_trg_Npc_Talk_Jack)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
    set l_tempPoint2=null
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
    call Register_HydraEgg_Prepare() // run by MapBootstrap
    call Register_HydraEgg_Drop() // starts off; enabled by HydraEgg
    call Register_HydraEgg_Pickup() // starts off; enabled by HydraEgg
    call Register_HydraEgg_Ping() // starts off; enabled by HydraEgg; disabled by HydraEgg
    call Register_HydraEgg_Deliver() // starts off; enabled by HydraEgg
endfunction

endlibrary
