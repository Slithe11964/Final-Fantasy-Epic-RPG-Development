library TQuestIllusions requires TQuestEngine, TCam, TCine, TMusic, TPlayerHero, TText, TUnit
// Main quest "Illusions to Illusions" (udg_MainQuest[15]), run by the quest engine (QuestEngine module,
// docs/QUEST_ENGINE.md). Dana asks the party to give her back her eye and strike her down, to draw out
// Famfrit, the Zodiac Brave of Water. All steps are custom: Start (talk to Dana) calls Quest_Start, Famfrit
// shows himself (Famfrit calls QuestIllusions_FamfritAppears) and Famfrit dies (Boss_Famfrit calls
// QuestIllusions_FamfritSlain). The "!" and "?" over Dana are this module's and Dana's own effects.
// Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Illusions_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ILLUSIONS=0
endglobals

function QuestIllusions_Define takes nothing returns nothing
    local integer q=Quest_Define("Illusions to Illusions",QUEST_MAIN,15,"ReplaceableTextures\\CommandButtons\\BTNNightElfRunner.blp")
    set QUEST_ILLUSIONS=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Dana (gg_trg_Quest_Illusions_Start)
    call Quest_Custom(q,"In order to draw out Famfrit, the Zodiac Brave of Water, you must give Dana back her eye to manifest her in Gaya, and then strike her down.")
    // 2. Famfrit appears after Dana's death (Famfrit)
    call Quest_Custom(q,"Defeat Famfrit, the Zodiac Brave of Water.")
    // 3. Defeat Famfrit (Boss_Famfrit)
    call Quest_Custom(q,"")
endfunction

// The party meets Famfrit and the fight begins (called by Famfrit through ExecuteFunc).
function QuestIllusions_FamfritAppears takes nothing returns nothing
    call Quest_StepDone(QUEST_ILLUSIONS,null,null)
endfunction

// Famfrit is dead: the quest is done (called by Boss_Famfrit through ExecuteFunc).
function QuestIllusions_FamfritSlain takes nothing returns nothing
    call Quest_StepDone(QUEST_ILLUSIONS,null,null)
endfunction

function Trig_Quest_Illusions_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0BN_0171,true,true,true))
endfunction

function Trig_Quest_Illusions_Start_KnowsHashmalum takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Quest_Illusions_Start_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: a hero talks to Dana.
function Trig_Quest_Illusions_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[70])
    if(Trig_Quest_Illusions_Start_CinematicsEnabled())then
        call PauseUnitBJ(true,gg_unit_n0BN_0171)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0BN_0171,"Greetings again. It's been a while. Have you gotten to know our village a little better?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yeah we've talked with a few people here. This is quite a mysterious place.",false)
        call Text_Say(gg_unit_n0BN_0171,"It certainly is. Long ago I never would've imagined we'd end up here like this myself.",false)
        call Text_Say(gg_unit_n0BN_0171,"We from the Phantom Village used to live in Lothlorien. We had the protection of Famfrit, the Zodiac Brave of Water, and Chaos, the Zodiac Brave of Wind, and I was in direct contact with their leader, Hashmalum, so we could all cooperate.",false)
        if(Trig_Quest_Illusions_Start_KnowsHashmalum())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hashmalum!?",false)
        else
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Demons!?",false)
        endif
        call Text_Say(gg_unit_n0BN_0171,"That's right. But Celeborn and Galadriel felt differently. They did not trust the demons, and many other night elves felt the same way.",false)
        call Text_Say(gg_unit_n0BN_0171,"Eventually things turned ugly and one thing led to another and... well here we are. I would not be welcome back at Lothlorien anymore. All we can do here is help to keep this world in order.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you are outcasts now. It's not surprising though. How could you ever think to cooperate with those demons?",false)
        call Text_Say(gg_unit_n0BN_0171,"You are fighting them now, aren't you?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes. We are trying to liberate the world from them once and for all.",false)
        call Text_Say(gg_unit_n0BN_0171,"Hashmalum... the leader of the Zodiac Braves, is planning something terrifying. If you intend on stopping him I will lend you my aid.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You will? That's great to hear. Any help in the battle against him is very welcome.",false)
        call Text_Say(gg_unit_n0BN_0171,"Unfortunately I can't help you fight him. But there is something else I can help you with.",false)
        call Text_Say(gg_unit_n0BN_0171,"As you may have guessed, we of the Phantom Village are still in close ties with the Zodiac Brave of Water, Famfrit. However, he is a being of Gaya, not Terra. I am the only point of contact we have with him.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I thought you are a being of Terra as well?",false)
        call Text_Say(gg_unit_n0BN_0171,"No, my body may be in Terra, but that is only because you hold my Eye. If you give it back to me, I will manifest in both worlds at once.",false)
        call Text_Say(gg_unit_n0BN_0171,"Once I do, you must strike me down.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What!?",false)
        call Text_Say(gg_unit_n0BN_0171,"Famfrit is a being from Gaya. He won't notice anything going on in Terra. If you wish to draw his attention, you need to create a situation he cannot ignore, here in Gaya.",false)
        call Text_Say(gg_unit_n0BN_0171,"If you strike my physical body down, he will surely take notice and appear here. It's the least I can do for your quest.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's insane. What about you!? What about the rest of the Phantom Village!?",false)
        call Text_Say(gg_unit_n0BN_0171,"Don't worry. I won't die, I will merely lose all contact with your world for good. Even if you can't perceive us anymore, rest assured that I and the Phantom Village will continue to support this world from Terra.",false)
        call Text_Say(gg_unit_n0BN_0171,"So please, don't hesitate. For all of our sakes.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),". . .",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_n0BN_0171)
    endif
    set udg_DanaQuestStage=(udg_DanaQuestStage+1)
    set udg_SpecialEffect[70]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BN_0171,"Objects\\RandomObject\\RandomObject.mdl")
    if QUEST_ILLUSIONS==0 then
        call QuestIllusions_Define()
    endif
    call Quest_Start(QUEST_ILLUSIONS,GetTriggerPlayer(),GetTriggerUnit())
    call SetUnitOwner(gg_unit_n0BN_0171,Player(9),false)
    call UnitAddAbilityBJ('AInv',gg_unit_n0BN_0171) // 'AInv': standard ability reference "Inventory"
    call UnitAddAbilityBJ('Abun',gg_unit_n0BN_0171) // 'Abun': object name not found in map data
    call Music_SetZoneTrack(21)
    call EnableTrigger(gg_trg_Dana_Receive_Eye)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Illusions takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part7 (module Quest),
// which keeps the original registration order.

function Register_Quest_Illusions_Start takes nothing returns nothing
    set gg_trg_Quest_Illusions_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Illusions_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_Illusions_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_Illusions_Start,Condition(function Trig_Quest_Illusions_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Illusions_Start,function Trig_Quest_Illusions_Start_Actions)
endfunction

endlibrary
