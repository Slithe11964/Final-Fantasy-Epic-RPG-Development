library TQuestDarkKnight requires TQuestEngine, TMusic
// Main quests "Dark Knight" and "Necrophobe", written for the quest engine (QuestEngine module,
// docs/QUEST_ENGINE.md). After the Night Elves quest, Galadriel's scrying shows the party either Gafgarion
// the Dark Knight guarding Zalera ("Dark Knight", started by gg_trg_Quest_DarkKnight_Start, which Cine runs)
// or, if the Zodiac Age quest has already begun, Zalera himself ("Necrophobe", started by Cine through
// QuestDarkKnight_StartNecrophobe). Only one of the two ever starts; both use udg_MainQuest[7].
// All steps are custom: Boss_Zalera finishes them (its intro and its death). Neither counts toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_DarkKnight_Start=null
    // The quests' numbers in the quest engine (0 until they are defined).
    integer QUEST_DARK_KNIGHT=0
    integer QUEST_NECROPHOBE=0
endglobals

function QuestDarkKnight_Define takes nothing returns nothing
    local integer q=Quest_Define("Dark Knight",QUEST_MAIN,7,"ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp")
    set QUEST_DARK_KNIGHT=q
    call Quest_Color(q,"|cffff8040")
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Galadriel's scrying shows Gafgarion (gg_trg_Quest_DarkKnight_Start)
    call Quest_Custom(q,"Galadriel told you to destroy Gafgarion the Dark Knight. It seems he is guarding something important.")
    // 2. Zalera shows himself (Boss_Zalera_Intro)
    call Quest_Custom(q,"Destroy Zalera, the Zodiac Brave of Death.")
    // 3. Zalera dies (Boss_Zalera_Death)
    call Quest_Custom(q,"")
endfunction

function QuestDarkKnight_NecrophobeDefine takes nothing returns nothing
    local integer q=Quest_Define("Necrophobe",QUEST_MAIN,7,"ReplaceableTextures\\CommandButtons\\BTNLichVersion2.blp")
    set QUEST_NECROPHOBE=q
    call Quest_Color(q,"|cffff8040")
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Galadriel's scrying shows Zalera (Cine_ScryingVision)
    call Quest_Custom(q,"Galadriel told you to attack the demon who appeared before he's gathered back his full power. Destroy him quickly!")
    // 2. Zalera wakes up (Boss_Zalera_Intro)
    call Quest_Custom(q,"Destroy Zalera, the Zodiac Brave of Death.")
    // 3. Zalera dies (Boss_Zalera_Death)
    call Quest_Custom(q,"")
endfunction

// "Necrophobe" starts (called by Cine_ScryingVision through ExecuteFunc).
function QuestDarkKnight_StartNecrophobe takes nothing returns nothing
    if QUEST_NECROPHOBE==0 then
        call QuestDarkKnight_NecrophobeDefine()
    endif
    call Quest_Start(QUEST_NECROPHOBE,null,null)
endfunction

// Zalera shows himself: the active one of the two quests moves on (called by Boss_Zalera_Intro).
function QuestDarkKnight_ZaleraAppears takes nothing returns nothing
    call Quest_StepDone(QUEST_DARK_KNIGHT,null,null)
    call Quest_StepDone(QUEST_NECROPHOBE,null,null)
endfunction

// Zalera died: the active one of the two quests is done (called by Boss_Zalera_Death).
function QuestDarkKnight_ZaleraSlain takes nothing returns nothing
    call Quest_StepDone(QUEST_DARK_KNIGHT,null,null)
    call Quest_StepDone(QUEST_NECROPHOBE,null,null)
endfunction

// "Dark Knight" starts: Gafgarion waits for the party (Cine runs this trigger).
function Trig_Quest_DarkKnight_Start_Actions takes nothing returns nothing
    if QUEST_DARK_KNIGHT==0 then
        call QuestDarkKnight_Define()
    endif
    call Quest_Start(QUEST_DARK_KNIGHT,null,null)
    call GroupAddUnitSimple(udg_StoryBoss,udg_QuestUnits)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Gafgarion_Intro,700.,udg_StoryBoss)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Gafgarion_Intro,250.,udg_StoryBoss)
    call EnableTrigger(gg_trg_Boss_Gafgarion_Intro)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Gafgarion_Death,udg_StoryBoss,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Boss_Gafgarion_Death)
    call Music_SetZoneTrack(9)
    call SetUnitAcquireRangeBJ(udg_StoryBoss,900.)
    set udg_ZaleraStage=1
    call ConditionalTriggerExecute(gg_trg_Elemental_Setup)
    set udg_ShadowForcedSpawn=25
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_DarkKnight takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part4 (module Quest),
// which keeps the original registration order.

function Register_Quest_DarkKnight_Start takes nothing returns nothing
    set gg_trg_Quest_DarkKnight_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DarkKnight_Start)
    call TriggerAddAction(gg_trg_Quest_DarkKnight_Start,function Trig_Quest_DarkKnight_Start_Actions)
endfunction

endlibrary
