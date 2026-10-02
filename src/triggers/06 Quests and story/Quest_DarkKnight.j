library TQuestDarkKnight requires TMusic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_DarkKnight_Start=null
endglobals

function Trig_Quest_DarkKnight_Start_Actions takes nothing returns nothing
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Dark Knight|r")
    set udg_MainQuest[7]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cffff8040Dark Knight","Galadriel told you to destroy Gafgarion the Dark Knight. It seems he is guarding something important.","ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp")
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
