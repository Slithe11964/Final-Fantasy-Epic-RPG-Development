library TAncientHunt requires TQuestEngine, TCam, TCine, TPlayerHero, TText, TUnit
// Side quest "Ancient Hunt", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Krjn of the Hunt Club in Lothlorien wants 20 corrupted Ancients killed. Made available by Krjn, which
// shows the "!" and enables gg_trg_AncientHunt_Start. Does not count toward the story.
// Krjn's talk depends on whether the party has done a hunt before, so it stays a trigger of this module
// (custom step); the module shows its own "!" / "?" over Krjn.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_AncientHunt_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ANCIENT_HUNT=0
endglobals

// Quest done: the "?" over Krjn goes, and he offers the Exdeath hunt.
function AncientHunt_Done takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[75])
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_e012_0227) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0CN',gg_unit_e012_0227,1,1) // 'n0CN': unit "Hunt: Exdeath"
    set udg_HuntStock[7]=(udg_HuntStock[7]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
endfunction

function AncientHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Ancient Hunt",QUEST_SIDE,56,"ReplaceableTextures\\CommandButtons\\BTNCorruptedTreeOfLife.blp")
    set QUEST_ANCIENT_HUNT=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Krjn (gg_trg_AncientHunt_Start)
    call Quest_Custom(q,"Krjn from Lothlorien has asked you to kill 20 Ancients to decelerate the corruption in the forest.")
    // 2. Kill 20 Ancients (hunt leaderboard row 7)
    call Quest_Hunt(q,7,20,"Ancients to kill","Return to Krjn for a reward.")
    call Quest_Message(q,"You have killed enough ancients. Return to Krjn for a reward.")
    call Quest_HuntTarget(q,'nenp') // 'nenp': editor label "Poison Treant"
    call Quest_HuntTarget(q,'nepl') // 'nepl': editor label "Plague Treant"
    call Quest_HuntTarget(q,'nenc') // 'nenc': editor label "Corrupted Treant"
    call Quest_HuntTarget(q,'n00P') // 'n00P': unit "Corrupted Tree of Life"
    call Quest_HuntTarget(q,'n00N') // 'n00N': unit "Corrupted Ancient of War"
    call Quest_HuntTarget(q,'n00O') // 'n00O': unit "Corrupted Ancient Protector"
    // 3. Report back to Krjn
    call Quest_Return(q,gg_unit_e012_0227,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"We're back. We've slain the Ancients you asked us to.")
    call Quest_Say(q,gg_unit_e012_0227,"Amazing! Thank you for your efforts. Here's your just reward.")
    call Quest_Reward(q,3000,3000)
    call Quest_Say(q,gg_unit_e012_0227,"By the way, you've surely noticed as you were fighting, the corruption of the forest has even taken over the spirits of the forest itself?")
    call Quest_Say(q,gg_unit_e012_0227,"They float around and empower enemies and weaken you when you're nearby. And to make things worse they generally gather around any fights that break out.")
    call Quest_Say(q,gg_unit_e012_0227,"Lady Dana was in tune with them when she was still around, which made them powerful allies. But now they are against us. There must be some way to cleanse these spirits and return them to our side...")
    call Quest_Say(q,gg_unit_e012_0227,"Well apologies for rambling. Do speak to me if you wish to do some rare game hunts for the club.")
    call Quest_OnDone(q,"AncientHunt_Done")
endfunction

function Trig_AncientHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e012_0227,true,true,true))
endfunction

function Trig_AncientHunt_Start_HasHuntHistory takes nothing returns boolean
    return(udg_CommonHuntsDone>0)
endfunction

function Trig_AncientHunt_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: the party talks to Krjn; the quest starts.
function Trig_AncientHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[75])
    if(Trig_AncientHunt_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e012_0227,"Hello, I would like to speak with you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, what is it?",false)
        call Text_Say(gg_unit_e012_0227,"One of the few strong ties between us night elves and the humans is that we cooperate and exchange information in the Hunt Club. It is the only organization in the world with both humans and night elves taking part.",false)
        call Text_Say(gg_unit_e012_0227,"And I've heard that you've become something of a member of the club, is that right?",false)
        if(Trig_AncientHunt_Start_HasHuntHistory())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes we have. If you have a hunt for us to do and you're willing to pay for the job, we'll be glad to help.",false)
            call Text_Say(gg_unit_e012_0227,"Excellent. That's exactly what I wanted to ask.",false)
        else
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"No we actually haven't. We've merely helped out the head of Kalm personally, no involvement in the club itself. But if you have a hunt for us to do and you're willing to pay for the job, we'll be glad to help.",false)
            call Text_Say(gg_unit_e012_0227,"I see. And yes, that's exactly what I wanted to ask.",false)
        endif
        call Text_Say(gg_unit_e012_0227,"With the global increase in monster activity, the forest outside our gates has become more tainted than ever. It has become extremely dangerous even for our own rangers.",false)
        call Text_Say(gg_unit_e012_0227,"In order to keep the taint of our woods in check we sometimes go out and destroy corrupted ancients. However recently we've been unable to do that and their numbers are growing. If this goes on we might all be in danger and the forest will become impassable.",false)
        call Text_Say(gg_unit_e012_0227,"You seem strong however, so I'd like to ask you if you could take down 20 Ancients. That should keep the taint at bay for a while.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Worry not. We will ease the forest's corruption.",false)
        call Cine_ExitAction()
    endif
    set udg_SpecialEffect[75]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e012_0227,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_NaishaTownUnit=gg_unit_e012_0227
    if QUEST_ANCIENT_HUNT==0 then
        call AncientHunt_Define()
    endif
    // the quest log appears and the hunt leaderboard shows "Ancients to kill"
    call Quest_Start(QUEST_ANCIENT_HUNT,GetTriggerPlayer(),Player_GetHero(GetTriggerPlayer()))
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_AncientHunt automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_AncientHunt (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_AncientHunt takes nothing returns nothing
endfunction

function Register_AncientHunt_Start takes nothing returns nothing
    set gg_trg_AncientHunt_Start=CreateTrigger()
    call DisableTrigger(gg_trg_AncientHunt_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AncientHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_AncientHunt_Start,Condition(function Trig_AncientHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_AncientHunt_Start,function Trig_AncientHunt_Start_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_AncientHunt takes nothing returns nothing
    call Register_AncientHunt_Start() // starts off; enabled by Krjn
endfunction

endlibrary
