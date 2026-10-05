library TQuestAoMadoushi requires TQuestEngine, TCine, TMusic, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_AoMadoushi_Talk=null
    trigger gg_trg_Quest_AoMadoushi_Report=null
    integer QUEST_AO_MADOUSHI=0
endglobals

// The existing triggers keep the branching cinematics, rewards and markers. Custom steps track
// Cid's request, the flute, the summon, the first talk and (if needed) the later report.
function QuestAoMadoushi_Define takes nothing returns nothing
    local integer q=Quest_Define("Ao Madoushi",QUEST_MAIN,4,"ReplaceableTextures\\CommandButtons\\BTNThrall.blp")
    set QUEST_AO_MADOUSHI=q
    call Quest_Color(q,"|cffff8040")
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    if udg_HashmalumStage>0 then
        call Quest_Custom(q,"Cid and Mid told you about the mysterious hermit who may know something about the demon Hashmalum. You must find him, but in order to call for his aid, Eiko's Flute is required. Find Reno and Rude, the Turks, to obtain it.")
    else
        call Quest_Custom(q,"Cid and Mid told you about the mysterious hermit who may know something about the Zodiac Stone and the entity that is imprisoned inside the Stone. You must find him, but in order to call for his aid, Eiko's Flute is required. Find Reno and Rude, the Turks, to obtain it.")
    endif
    // Updates retain their original playing-player announcements in the event triggers.
    call Quest_Custom(q,"") // Obtain Eiko's Flute.
    call Quest_Custom(q,"") // Summon Ao Madoushi.
    call Quest_Custom(q,"") // First talk: request the Stone, or finish if Hashmalum is already free.
    call Quest_Custom(q,"") // Report after the Stone breaks; skipped when the first talk finishes it.
endfunction

function QuestAoMadoushi_Start takes nothing returns nothing
    if QUEST_AO_MADOUSHI==0 then
        call QuestAoMadoushi_Define()
    endif
    call Quest_Start(QUEST_AO_MADOUSHI,null,null)
endfunction

function QuestAoMadoushi_FluteTaken takes nothing returns nothing
    call Quest_StepDone(QUEST_AO_MADOUSHI,null,null)
    call Quest_SetLog(QUEST_AO_MADOUSHI,"Find Ao Madoushi's hut and play the flute to make him appear.",false)
endfunction

function QuestAoMadoushi_Summoned takes nothing returns nothing
    call Quest_StepDone(QUEST_AO_MADOUSHI,null,null)
    call Quest_SetLog(QUEST_AO_MADOUSHI,"Talk to Ao Madoushi.",false)
endfunction

function QuestAoMadoushi_StoneBroke takes nothing returns nothing
    call Quest_SetLog(QUEST_AO_MADOUSHI,"Visit Ao Madoushi, tell him about what happened and ask him what he knows about it.",false)
endfunction

function Trig_Quest_AoMadoushi_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Othr_0106,true,true,true))
endfunction

function Trig_Quest_AoMadoushi_Talk_ShouldPayGold takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Quest_AoMadoushi_Talk_CameraOnSage takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_003,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_AoMadoushi_Talk_KnowsStoneStory takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[3]))
endfunction

function Trig_Quest_AoMadoushi_Talk_KnowsStoneFound takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[3]))
endfunction

function Trig_Quest_AoMadoushi_Talk_HasSeenDemon takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Quest_AoMadoushi_Talk_ShowSageScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_AoMadoushi_Talk_ShouldGiveEyeQuest takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Quest_AoMadoushi_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[21])
    call GroupRemoveUnitSimple(gg_unit_Othr_0106,udg_QuestUnits)
    set udg_CidQuestStage=$C // $C = 12
    call SetUnitPositionLoc(gg_unit_Othr_0106,udg_AoMadoushiLoc)
    call SetUnitFacingTimed(gg_unit_Othr_0106,udg_AoMadoushiFacing,0)
    if(Trig_Quest_AoMadoushi_Talk_ShowSageScene())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_AoMadoushi_Talk_CameraOnSage)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings. Are you the one known as Ao Madoushi?",false)
        call Text_Say(gg_unit_Othr_0106,"People call me that.",false)
        call Text_Transmission(gg_unit_Othr_0106,"Ao Madoushi","People call me that. ... ","People call me that.",null,0,false)
        call Text_Transmission(gg_unit_Othr_0106,"Ao Madoushi","People call me that. ... Hmm ...","People call me that. ... ",null,0,false)
        call Text_Transmission(gg_unit_Othr_0106,"Ao Madoushi","People call me that. ... Hmm ... I assume since you have called me that you are anxious about something ...","People call me that. ... Hmm ...",null,0,false)
        call Text_Transmission(gg_unit_Othr_0106,"Ao Madoushi","People call me that. ... Hmm ... I assume since you have called me that you are anxious about something ... You need my help?","People call me that. ... Hmm ... I assume since you have called me that you are anxious about something ...",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You are right, wise one.",false)
        if(Trig_Quest_AoMadoushi_Talk_HasSeenDemon())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),(("|cffffcc00"+udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())])+" tells Ao Madoushi about Hashmalum.|r"),false)
            call Text_Say(gg_unit_Othr_0106,"Truly, these are ill news. The demon was long imprisoned but now he is free. I'm sure he will bring only destruction and chaos to the world.",false)
            call Text_Say(gg_unit_Othr_0106,"Let me tell you a story from long ago so you know what you are dealing with.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"I am all ears.",false)
            if(Trig_Quest_AoMadoushi_Talk_KnowsStoneStory())then
                call Text_Say(gg_unit_Othr_0106,"The truth is it's not the first time in my life I encountered the Zodiac Stone. You know, I am very old, although I don't look like I am. I've lived in this world for more than a thousand years.",false)
            else
                call Text_Say(gg_unit_Othr_0106,"This is not the first time in my life I encountered demons. You know, I am very old, although I don't look like I am. I've lived in this world for more than a thousand years.",false)
            endif
            call Text_Say(gg_unit_Othr_0106,"Maybe you heard that before Elves came here this land was inhabited by my kinsmen.",false)
            call Text_Say(gg_unit_Othr_0106,"I was a young and promising Shaman when those tragic events happened, nearly a thousand years ago.",false)
            if(Trig_Quest_AoMadoushi_Talk_KnowsStoneFound())then
                call Text_Say(gg_unit_Othr_0106,"The Zodiac Stone (not yours, but another one) was found in the woods near our village. I carefully researched the stone and found out that it contains incredible power and that I could use it for myself.",false)
            else
                call Text_Say(gg_unit_Othr_0106,"We found an artifact in the woods near our village. It was a Zodiac Stone, a prison for demons. Of course I didn't know that at the time. So I carefully researched the stone and found out that it contains incredible power and that I could use it for myself.",false)
            endif
            call Text_Say(gg_unit_Othr_0106,"I succeeded and absorbed power from the Stone. I gained great power and became the most powerful Shaman of my time.",false)
            call Text_Say(gg_unit_Othr_0106,"But with my actions, I broke the seal that kept a terrible demon locked inside the Stone. I took the power that imprisoned the demon for myself and he easily gained freedom.",false)
            call Text_Say(gg_unit_Othr_0106,"One day I saw the Zodiac Stone acting strangely, as if burning from inside. Then a blinding flash followed and I witnessed a terrible demon appearing seemingly out of nowhere.",false)
            call Text_Say(gg_unit_Othr_0106,"My people had encountered demons before - this world is very accessible from other planes and demons often came here to hunt or for other evil purposes.",false)
            call Text_Say(gg_unit_Othr_0106,"We learned how to fight them and we attacked the Demon who, as I guessed, came from the Stone.",false)
            call Text_Say(gg_unit_Othr_0106,"But we couldn't defeat him. I was shocked that my newly gained power which I thought to be incredible was absolutely no match for the Demon's!",false)
            call Text_Say(gg_unit_Othr_0106,"And I ran in fear. When I found the courage to return to the village I found everyone slaughtered. No one survived.",false)
            call Text_Say(gg_unit_Othr_0106,"I don't know what happened with that demon, where he went after destroying my village but the power of the Stone gave me a near-infinite life span and I remained here. Soon the Elves came here and I helped them to build Kalm.",false)
            call Text_Say(gg_unit_Othr_0106,"After that I left Gaya and traveled many worlds seeking the demon who slew my kinsmen in order to kill him or die trying. But I was unsuccessful. I was only able to learn his name: Archimonde.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's a sad story. Seems this Hashmalum is more dangerous than I imagined.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"What would you advise me to do?",false)
            call Text_Say(gg_unit_Othr_0106,"I am afraid that this Hashmalum may be extremely dangerous once he regains his power. He seems to be able to dominate people and that may be very bad for us all.",false)
            call Text_Say(gg_unit_Othr_0106,"However, I know of a way to resist any mind affecting spells. Ancient texts of my people speak that on one of the southern islands a powerful artifact, called the Eye of Jenova, is located. By using this artifact I will be a able to create a protective aura that will shield all of us from Hashmalum",false)
            call Text_Say(gg_unit_Othr_0106,"Unfortunately, an undead creature stole this artifact. The only way to recover it is to kill this creature.",false)
            call Text_Say(gg_unit_Othr_0106,"The very same creature was captured by Kalm Guards some time ago. They were unable to kill it, however, and imprisoned it in their arena instead.",false)
            call Text_Say(gg_unit_Othr_0106,"You have to find him in the arena and obtain the Eye of Jenova. If you are going to fight him, make sure you're properly prepared. It might be a difficult battle.",false)
            call Text_Say(gg_unit_Othr_0106,"Still, you are experienced adventurer and I am sure that you will be able to deal with it. Good luck and take this gold, it might prove useful.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, we'll be looking for it.",false)
            call Reward_Give($5DC,$5DC,gg_unit_Othr_0106) // $5DC = 1500
        else
            call Text_Say(Player_GetHero(GetTriggerPlayer()),(("|cffffcc00"+udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())])+" tells Ao Madoushi everything he knows about the Zodiac Stone.|r"),false)
            call Text_Say(gg_unit_Othr_0106,"Truly, these are ill news. For your friends were right, the Zodiac Stone indeed holds a powerful and malevolent entity imprisoned. And this prison is about to be broken.",false)
            call Text_Say(gg_unit_Othr_0106,"I will tell you the whole story later. Now you must hurry and bring the stone to me before it is too late.",false)
        endif
        call Cine_ExitAction()
    else
        if(Trig_Quest_AoMadoushi_Talk_ShouldPayGold())then
            call Reward_Give($5DC,$5DC,gg_unit_Othr_0106) // $5DC = 1500
        endif
    endif
    call Quest_StepDone(QUEST_AO_MADOUSHI,GetTriggerPlayer(),GetTriggerUnit())
    if(Trig_Quest_AoMadoushi_Talk_ShouldGiveEyeQuest())then
        call Quest_StepDone(QUEST_AO_MADOUSHI,GetTriggerPlayer(),GetTriggerUnit())
        // "Eye of Jenova" starts (the engine announces it now; it used to be announced 4 seconds later)
        call ExecuteFunc("QuestEyeOfJenova_Start")
        call SaveIntegerBJ(2,2,$8B,udg_GameStateHash) // $8B = 139
        call EnableTrigger(gg_trg_Loot_Cuchulainn_EyeDrop)
        call EnableTrigger(gg_trg_Ping_ArenaTarget)
        call Wait_Polled(4.)
        call Music_SetZoneTrack(6)
    else
        call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Bring the Zodiac Stone to Ao Madoushi.")
        call Quest_SetLog(QUEST_AO_MADOUSHI,"Hurry and bring the Zodiac Stone to Ao Madoushi.",false)
        call GroupAddUnitSimple(udg_ZodiacStone,udg_QuestUnits)
        call EnableTrigger(gg_trg_Cine_StoneBreaks)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_AoMadoushi_Report_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Othr_0106,true,true,true))
endfunction

function Trig_Quest_AoMadoushi_Report_CameraOnMadoushi takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_003,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_AoMadoushi_Report_ShowReportScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_AoMadoushi_Report_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[21])
    call SetUnitPositionLoc(gg_unit_Othr_0106,udg_AoMadoushiLoc)
    call SetUnitFacingTimed(gg_unit_Othr_0106,udg_AoMadoushiFacing,0)
    call GroupRemoveUnitSimple(gg_unit_Othr_0106,udg_QuestUnits)
    if(Trig_Quest_AoMadoushi_Report_ShowReportScene())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_AoMadoushi_Report_CameraOnMadoushi)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You will never believe what has just happened !!!",false)
        call Text_Say(gg_unit_Othr_0106,"The Zodiac Stone exploded and a horrible Demon appeared. He promised to slay you in the most brutal way but eventually teleported away.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hey, how did you know that?",false)
        call Text_Say(gg_unit_Othr_0106,"I used Far Sight spell.",false)
        call Text_Say(gg_unit_Othr_0106,"Let me tell you a story from long ago.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I am all ears.",false)
        call Text_Say(gg_unit_Othr_0106,"The truth is it's not the first time in my life I encountered the Zodiac Stone. You know, I am very old, although I don't look like I am. I've lived in this world for more than a thousand years.",false)
        call Text_Say(gg_unit_Othr_0106,"Maybe you heard that before Elves came here this land was inhabited by my kinsmen.",false)
        call Text_Say(gg_unit_Othr_0106,"I was a young and promising Shaman when those tragic events happened, nearly a thousand years ago.",false)
        call Text_Say(gg_unit_Othr_0106,"The Zodiac Stone (not yours, but another one) was found in the woods near our village. I carefully researched the stone and found out that it contains incredible power and that I could use it for myself.",false)
        call Text_Say(gg_unit_Othr_0106,"I succeeded and absorbed power from the Stone. I gained great power and became the most powerful Shaman of my time.",false)
        call Text_Say(gg_unit_Othr_0106,"But with my actions, I broke the seal that kept a terrible demon locked inside the Stone. I took the power that imprisoned the demon for myself and he easily gained freedom.",false)
        call Text_Say(gg_unit_Othr_0106,"One day I saw the Zodiac Stone acting strangely, as if burning from inside. Then a blinding flash followed and I witnessed a terrible demon appearing seemingly out of nowhere.",false)
        call Text_Say(gg_unit_Othr_0106,"My people had encountered demons before - this world is very accessible from other planes and demons often came here to hunt or for other evil purposes.",false)
        call Text_Say(gg_unit_Othr_0106,"We learned how to fight them and we attacked the Demon who, as I guessed, came from the Stone.",false)
        call Text_Say(gg_unit_Othr_0106,"But we couldn't defeat him. I was shocked that my newly gained power which I thought to be incredible was absolutely no match for the Demon's!",false)
        call Text_Say(gg_unit_Othr_0106,"And I ran in fear. When I found the courage to return to the village I found everyone slaughtered. No one survived.",false)
        call Text_Say(gg_unit_Othr_0106,"I don't know what happened with that demon, where he went after destroying my village but the power of the Stone gave me a near-infinite life span and I remained here. Soon the Elves came here and I helped them to build Kalm.",false)
        call Text_Say(gg_unit_Othr_0106,"After that I left Gaya and traveled many worlds seeking the demon who slew my kinsmen in order to kill him or die trying. But I was unsuccessful. I was only able to learn his name: Archimonde.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's a sad story and now I am starting to think that I underestimated Hashmalum.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What would you advise me to do?",false)
        call Text_Say(gg_unit_Othr_0106,"I am afraid that this Hashmalum may be extremely dangerous once he regains his power. He seems to be able to dominate people and that may be very bad for us all.",false)
        call Text_Say(gg_unit_Othr_0106,"However, I know of a way to resist any mind affecting spells. Ancient texts of my people speak that on one of the southern islands a powerful artifact, called the Eye of Jenova, is located. By using this artifact I will be a able to create a protective aura that will shield all of us from Hashmalum",false)
        call Text_Say(gg_unit_Othr_0106,"Unfortunately, an undead creature stole this artifact. The only way to recover it is to kill this creature.",false)
        call Text_Say(gg_unit_Othr_0106,"The very same creature was captured by Kalm Guards some time ago. They were unable to kill it, however, and imprisoned it in their arena instead.",false)
        call Text_Say(gg_unit_Othr_0106,"You have to find him in the arena and obtain the Eye of Jenova. If you are going to fight him, make sure you're properly prepared. It might be a difficult battle.",false)
        call Text_Say(gg_unit_Othr_0106,"Still, you are experienced adventurer and I am sure that you will be able to deal with it. Good luck and take this gold, it might prove useful.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, we'll be looking for it.",false)
        call Reward_Give($5DC,$5DC,gg_unit_Othr_0106) // $5DC = 1500
        call Cine_ExitAction()
    else
        call Reward_Give($5DC,$5DC,gg_unit_Othr_0106) // $5DC = 1500
    endif
    call Quest_StepDone(QUEST_AO_MADOUSHI,GetTriggerPlayer(),GetTriggerUnit())
    // "Eye of Jenova" starts (the engine announces it now; it used to be announced 4 seconds later)
    call ExecuteFunc("QuestEyeOfJenova_Start")
    set udg_SpecialEffect[21]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Othr_0106,"Objects\\RandomObject\\RandomObject.mdl")
    call SaveIntegerBJ(2,2,$8B,udg_GameStateHash) // $8B = 139
    call EnableTrigger(gg_trg_Loot_Cuchulainn_EyeDrop)
    call EnableTrigger(gg_trg_Ping_ArenaTarget)
    call Wait_Polled(4.)
    call Music_SetZoneTrack(6)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_AoMadoushi takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part2 (module Quest),
// which keeps the original registration order.

function Register_Quest_AoMadoushi_Talk takes nothing returns nothing
    set gg_trg_Quest_AoMadoushi_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_AoMadoushi_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_AoMadoushi_Talk,Condition(function Trig_Quest_AoMadoushi_Talk_Conditions))
    call TriggerAddAction(gg_trg_Quest_AoMadoushi_Talk,function Trig_Quest_AoMadoushi_Talk_Actions)
endfunction

function Register_Quest_AoMadoushi_Report takes nothing returns nothing
    set gg_trg_Quest_AoMadoushi_Report=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_AoMadoushi_Report)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AoMadoushi_Report,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_AoMadoushi_Report,Condition(function Trig_Quest_AoMadoushi_Report_Conditions))
    call TriggerAddAction(gg_trg_Quest_AoMadoushi_Report,function Trig_Quest_AoMadoushi_Report_Actions)
endfunction

endlibrary
