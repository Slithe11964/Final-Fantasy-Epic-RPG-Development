library TQuestCorruptedOrcs requires TQuestEngine, TCam, TCine, TPlayerHero, TText, TUnit
// Main quest "Corrupted Orcs" (udg_MainQuest[13]), run by the quest engine (QuestEngine module,
// docs/QUEST_ENGINE.md). Meliadoul asks the party to raze the base of the red-skinned orcs east of the Farm;
// the party may also find the base first (OrcBase, when its gate guard dies), which starts the quest with
// another text. All steps are custom: the base is cleared (OrcBase), the Fountain of Blood is destroyed and
// Shemhazai, the Zodiac Brave of Soul, appears (Shemhazai), and Shemhazai dies (Boss_Shemhazai). Those
// modules call the functions below through ExecuteFunc. If the demon lord Echele was summoned early
// ("True Ice Age"), Shemhazai does not appear and the quest is done when the fountain falls. The "!" over
// Meliadoul is Meliadoul's own effect. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_CorruptedOrcs_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_CORRUPTED_ORCS=0
endglobals

// l_firstLog: the quest's first description, which depends on how the quest starts.
function QuestCorruptedOrcs_Define takes string l_firstLog returns nothing
    local integer q=Quest_Define("Corrupted Orcs",QUEST_MAIN,13,"ReplaceableTextures\\CommandButtons\\BTNChaosGrom.blp")
    set QUEST_CORRUPTED_ORCS=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Meliadoul (gg_trg_Quest_CorruptedOrcs_Start), or find the base (OrcBase)
    call Quest_Custom(q,l_firstLog)
    // 2. Kill every orc of the base (OrcBase)
    call Quest_Custom(q,"Destroy the Fountain of Blood in the Corrupted Orcs base.")
    call Quest_Message(q,"Destroy the Fountain of Blood.")
    // 3. Destroy the Fountain of Blood (Shemhazai); the log then changes when Shemhazai shows himself
    call Quest_Custom(q,"")
    // 4. Defeat Shemhazai (Boss_Shemhazai)
    call Quest_Custom(q,"")
endfunction

// The party found the base before Meliadoul asked them (called by OrcBase when the gate guard dies).
function QuestCorruptedOrcs_StartAtBase takes nothing returns nothing
    if QUEST_CORRUPTED_ORCS==0 then
        call QuestCorruptedOrcs_Define("You found a base full of corrupted orcs. Clear it all out!")
    endif
    call Quest_Start(QUEST_CORRUPTED_ORCS,null,null)
endfunction

// Every orc of the base is dead (called by OrcBase): the Fountain of Blood can be destroyed.
function QuestCorruptedOrcs_BaseCleared takes nothing returns nothing
    call Quest_StepDone(QUEST_CORRUPTED_ORCS,null,null)
endfunction

// The fountain fell and Shemhazai is ready to fight (called by Shemhazai).
function QuestCorruptedOrcs_ShemhazaiAppears takes nothing returns nothing
    call Quest_StepDone(QUEST_CORRUPTED_ORCS,null,null)
    call Quest_SetLog(QUEST_CORRUPTED_ORCS,"Destroy Shemhazai, the Zodiac Brave of Soul.",true)
endfunction

// The fountain fell after Echele was summoned early: Shemhazai does not come, the quest is done
// (called by Shemhazai).
function QuestCorruptedOrcs_DoneWithoutShemhazai takes nothing returns nothing
    call Quest_StepDone(QUEST_CORRUPTED_ORCS,null,null)
    call Quest_StepDone(QUEST_CORRUPTED_ORCS,null,null)
endfunction

// Shemhazai is dead: the quest is done (called by Boss_Shemhazai).
function QuestCorruptedOrcs_ShemhazaiSlain takes nothing returns nothing
    call Quest_StepDone(QUEST_CORRUPTED_ORCS,null,null)
endfunction

function Trig_Quest_CorruptedOrcs_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hvwd_0098,true,true,true))
endfunction

function Trig_Quest_CorruptedOrcs_Start_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: a hero talks to Meliadoul.
function Trig_Quest_CorruptedOrcs_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_Quest_CorruptedOrcs_Start_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hvwd_0098,"Ah, you came.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings. Is there something amiss still?",false)
        call Text_Say(gg_unit_Hvwd_0098,"As you may recall we were attacked not just by monsters but also by strange beasts during the sieges. They were of the same race as Ao Madoushi, but that red skin tone was unnatural.",false)
        call Text_Say(gg_unit_Hvwd_0098,"After conferring with Ao Madoushi on the matter we also asked our scouts and it seems these beasts were seen sailing towards Kalm from an island to the east of the Farm.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That is good information. Now we can strike before they attack us again!",false)
        call Text_Say(gg_unit_Hvwd_0098,"Yes, that is what I'd like to ask of you. The island is far from Kalm so it'd take a lot of effort and resources to mobilize our forces there, and while we may have defeated the demon it's still too risky to leave the town on low defenses.",false)
        call Text_Say(gg_unit_Hvwd_0098,"I realize that I am asking a lot of you. You are likely going to be met with an entire settlement of these beasts given their numbers. But we cannot afford any other ways, and any day they remain untouched is another day they may yet attack us again.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Worry not. We will raze their entire settlement to the ground!",false)
        call Cine_ExitAction()
    endif
    if QUEST_CORRUPTED_ORCS==0 then
        call QuestCorruptedOrcs_Define("Meliadoul, First Ranger of Kalm, asked you to attack the enemy base located on an island east of the Farm. Destroy every last building!")
    endif
    call Quest_Start(QUEST_CORRUPTED_ORCS,GetTriggerPlayer(),GetTriggerUnit())
    call GroupAddUnitSimple(gg_unit_nbfl_0170,udg_BossUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_CorruptedOrcs takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part5 (module Quest),
// which keeps the original registration order.

function Register_Quest_CorruptedOrcs_Start takes nothing returns nothing
    set gg_trg_Quest_CorruptedOrcs_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_CorruptedOrcs_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_CorruptedOrcs_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_CorruptedOrcs_Start,Condition(function Trig_Quest_CorruptedOrcs_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_CorruptedOrcs_Start,function Trig_Quest_CorruptedOrcs_Start_Actions)
endfunction

endlibrary
