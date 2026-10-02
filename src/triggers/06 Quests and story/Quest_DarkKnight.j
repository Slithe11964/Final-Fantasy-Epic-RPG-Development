library TQuestDarkKnight requires TMusic
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

endlibrary
