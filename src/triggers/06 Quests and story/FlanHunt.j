library TFlanHunt requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText, TUnit
// Side quest "Flan Hunt", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Olga, Lady Dana's first ranger in the Phantom Village, wants 20 flans killed.
// The talks stay module triggers: Olga is paused during them and the hand-in needs her to be visible
// (only with the Maiden's Eye). The quest fails if Dana dies (FlanHunt_Fail, run by Dana).
// Does not count toward the story; Olga's own "!" / "?" markers (udg_SpecialEffect[74]) are kept.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_FlanHunt_Start=null
    trigger gg_trg_FlanHunt_Fail=null
    trigger gg_trg_FlanHunt_Reward=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_FLAN_HUNT=0
endglobals

// Step 1 done (the party talked to Olga): the "?" over her.
function FlanHunt_Started takes nothing returns nothing
    set udg_SpecialEffect[74]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e014_0149,"Objects\\RandomObject\\RandomObject.mdl")
endfunction

// Step 2 done (20 flans killed): Olga is pinged and waits for the party.
function FlanHunt_Hunted takes nothing returns nothing
    call GroupAddUnitSimple(gg_unit_e014_0149,udg_BossUnits)
    call EnableTrigger(gg_trg_FlanHunt_Reward)
endfunction

function FlanHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Flan Hunt",QUEST_SIDE,55,"ReplaceableTextures\\CommandButtons\\BTNSludgeCreature.blp")
    set QUEST_FLAN_HUNT=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Olga (gg_trg_FlanHunt_Start)
    call Quest_Custom(q,"Olga from the Phantom Village has asked you to clean 20 flans off the face of Gaya.")
    call Quest_OnDone(q,"FlanHunt_Started")
    // 2. Kill 20 flans (hunt leaderboard row 6)
    call Quest_Hunt(q,6,20,"Flans to kill","Return to Olga for a reward.")
    call Quest_Message(q,"You have killed enough flans. Return to Olga for a reward.")
    call Quest_HuntTarget(q,'n01P') // 'n01P': unit "Lesser Flan"
    call Quest_HuntTarget(q,'n01O') // 'n01O': unit "Flan"
    call Quest_HuntTarget(q,'n01Q') // 'n01Q': unit "Aqua Flan"
    call Quest_HuntTarget(q,'n01N') // 'n01N': unit "Greater Flan"
    call Quest_HuntTarget(q,'n042') // 'n042': unit "Dark Flan"
    call Quest_OnDone(q,"FlanHunt_Hunted")
    // 3. Report back to Olga (gg_trg_FlanHunt_Reward)
    call Quest_Custom(q,"")
endfunction

function Trig_FlanHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e014_0149,true,true,true))
endfunction

function Trig_FlanHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[74])
    if udg_CinematicsDisabled==false then
        call PauseUnitBJ(true,gg_unit_e014_0149)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e014_0149,"Greetings to you, rare guests. My name is Olga, and I am Lady Dana's first ranger. I have heard about your arrival in our village. We haven't had a visitor in a long time.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah makes sense. You're not exactly in contact much with the outside world, are you?",false)
        call Text_Say(gg_unit_e014_0149,"We are not. However do not pity us. We have all we need, and all of us are intimately familiar with this world. Our days of adventuring and traveling are long past us.",false)
        call Text_Say(gg_unit_e014_0149,"Besides, we have a purpose here. Being on 'this side' allows us to work to keep the world in balance. Such is the important work bestowed on us by our lords, the Lady Dana and her ally, Famfrit.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. It seems you have all you could ask for.",false)
        call Text_Say(gg_unit_e014_0149,"Well as long as you are here, there is something I have to ask of you.",false)
        call Text_Say(gg_unit_e014_0149,"There are pests on 'your side' whose taint slowly creeps into the core of the world itself. It manifests itself as a sort of black slime.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You mean flans?",false)
        call Text_Say(gg_unit_e014_0149,"Yes. Back when we were still in Lothlorien it was my duty as its first ranger to oversee their hunt, but I cannot do that anymore. It is outside of our jurisdiction, but I'd like to ask you to do what I no longer can.",false)
        call Text_Say(gg_unit_e014_0149,"You must be quite strong if you managed to make it here. If you can kill 20 flans, I'd be most grateful, and I'll have Lady Dana see that you are rewarded for your efforts.",false)
        call Text_Say(gg_unit_e014_0149,"Of course I'm sure you're aware, but physical attacks won't do much against them. You must use magic if you wish to affect them.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds good to me. We'll have those pests cut down in no time!",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_e014_0149)
    endif
    if QUEST_FLAN_HUNT==0 then
        call FlanHunt_Define()
    endif
    // log entry, "New Quest Received", Olga's "?" and the flan count on the hunt board
    call Quest_Start(QUEST_FLAN_HUNT,GetTriggerPlayer(),Player_GetHero(GetTriggerPlayer()))
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Run by Dana when she dies before the quest is done: the quest fails and its hunt count leaves the board.
function Trig_FlanHunt_Fail_Actions takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[74])
    call Quest_Fail(QUEST_FLAN_HUNT)
    if udg_HuntCounter[6]>0 then
        set udg_HuntCounter[6]=0
        call LeaderboardRemovePlayerItemBJ(Player(5),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=udg_HuntCounter[0]-1
        if udg_HuntCounter[0]<=0 then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
    else
        call GroupRemoveUnitSimple(gg_unit_e014_0149,udg_BossUnits)
    endif
    call DestroyTrigger(gg_trg_FlanHunt_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_FlanHunt_Reward_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false)and(IsUnitVisible(gg_unit_e014_0149,GetOwningPlayer(GetTriggerUnit()))))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_FlanHunt_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[74])
    call GroupRemoveUnitSimple(gg_unit_e014_0149,udg_BossUnits)
    if udg_CinematicsDisabled==false then
        call PauseUnitBJ(true,gg_unit_e014_0149)
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_e014_0149,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We've killed 20 flans, as you asked.",false)
        call Text_Say(gg_unit_e014_0149,"You have my gratitude. This should help keep the world in further balance.",false)
        call Reward_Give(4000,3500,gg_unit_e014_0149)
        call Text_Say(gg_unit_e014_0149,"I'm also afraid that some fiends from our side have crossed over to your world of late. If I could ask you to help us out some more in exterminating these dangers, come speak to me some more.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_e014_0149)
    else
        call Reward_Give(4000,3500,gg_unit_e014_0149)
    endif
    call Quest_StepDone(QUEST_FLAN_HUNT,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    // Olga offers the Arahabaki hunt
    set udg_PhantomVillagersMet=udg_PhantomVillagersMet+1
    set udg_CommonHuntsDone=udg_CommonHuntsDone+1
    call UnitAddAbilityBJ('Ane2',gg_unit_e014_0149) // 'Ane2': standard ability
    call AddUnitToStockBJ('n0C4',gg_unit_e014_0149,1,1) // 'n0C4': unit "Hunt: Arahabaki"
    set udg_HuntStock[6]=udg_HuntStock[6]+1
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(gg_trg_FlanHunt_Fail)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_FlanHunt automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_FlanHunt (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_FlanHunt takes nothing returns nothing
endfunction

function Register_FlanHunt_Start takes nothing returns nothing
    set gg_trg_FlanHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_FlanHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_FlanHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_FlanHunt_Start,Condition(function Trig_FlanHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_FlanHunt_Start,function Trig_FlanHunt_Start_Actions)
endfunction

function Register_FlanHunt_Fail takes nothing returns nothing
    set gg_trg_FlanHunt_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_FlanHunt_Fail)
    call TriggerAddAction(gg_trg_FlanHunt_Fail,function Trig_FlanHunt_Fail_Actions)
endfunction

function Register_FlanHunt_Reward takes nothing returns nothing
    set gg_trg_FlanHunt_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_FlanHunt_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_FlanHunt_Reward,200.,gg_unit_e014_0149)
    call TriggerRegisterUnitInRangeSimple(gg_trg_FlanHunt_Reward,450.,gg_unit_e014_0149)
    call TriggerAddCondition(gg_trg_FlanHunt_Reward,Condition(function Trig_FlanHunt_Reward_Conditions))
    call TriggerAddAction(gg_trg_FlanHunt_Reward,function Trig_FlanHunt_Reward_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_FlanHunt takes nothing returns nothing
    call Register_FlanHunt_Start() // starts off; enabled by Olga
    call Register_FlanHunt_Fail() // starts off; run by Dana; destroyed by FlanHunt
    call Register_FlanHunt_Reward() // starts off; enabled by FlanHunt; destroyed by FlanHunt
endfunction

endlibrary
