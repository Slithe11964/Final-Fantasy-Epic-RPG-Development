library TBridgeBattle requires TQuestEngine
// Side quest "The Bridge-Battle", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Mae'chen asks the party to defeat Mr. X (Gilgamesh) on the Big Bridge. Steps: talk to Mae'chen
// (data), defeat Gilgamesh (Gilgamesh's Defeat trigger calls BridgeBattle_GilgameshDefeated), return
// to Mae'chen (data). Made available by Prepare, which Talk, Quest_NightElves and Epilogue enable.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_BridgeBattle_Prepare=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_BRIDGE_BATTLE=0
endglobals

// Step 1 done (the party talked to Mae'chen): Gilgamesh waits on the Big Bridge.
function BridgeBattle_Started takes nothing returns nothing
    call EnableTrigger(gg_trg_Gilgamesh_Appear)
endfunction

function BridgeBattle_Define takes nothing returns nothing
    local integer q=Quest_Define("The Bridge-Battle",QUEST_SIDE,41,"ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp")
    set QUEST_BRIDGE_BATTLE=q
    // 1. Talk to Mae'chen
    call Quest_Talk(q,gg_unit_n02Y_0052,"Mae'chen, a wise old man from Spira, has asked you to find and defeat Mr. X. Mr. X has defeated one of Mae'chen's friends and took his sword. Now Mae'chen's friend asked Mae'chen for help for revenge.")
    call Quest_Say(q,gg_unit_n02Y_0052,"You there. Hold on a minute.")
    call Quest_Say(q,null,"What is it?")
    call Quest_Say(q,gg_unit_n02Y_0052,"I wondered if you could help my friend.")
    call Quest_Say(q,null,"With what?")
    call Quest_Say(q,gg_unit_n02Y_0052,"You see, my friend recently fought with a mysterious four-armed man, but he was defeated. And as if this shame wouldn't have been enough, the man also took his sword! This was too much for my friend and he asked me for assistance.")
    call Quest_Say(q,null,"So you want us to go beat this guy up and return the sword?")
    call Quest_Say(q,gg_unit_n02Y_0052,"I think defeating him would suffice. If the man has my friend's sword with him by any chance, you may keep it.")
    call Quest_Say(q,null,"Where can we find this man? Where has your friend fought him?")
    call Quest_Say(q,gg_unit_n02Y_0052,"My friend fought him on a big bridge. The man seems to like bridges as a place for a battle.")
    call Quest_Say(q,gg_unit_n02Y_0052,"Also, my friend just called him \"Mr. X\". Nobody knows his real name, but another of his nicknames is \"The Planeswalker\".")
    call Quest_Say(q,null,"A battle on the Big Bridge, huh?\r\nAlright, I'll try to find this Mr. X.")
    call Quest_OnDone(q,"BridgeBattle_Started")
    // 2. Defeat Gilgamesh (Gilgamesh's Defeat trigger calls BridgeBattle_GilgameshDefeated)
    call Quest_Custom(q,"You have found and defeated Gilgamesh, but he escaped. Return to Mae'chen.")
    call Quest_Message(q,"Return to Mae'chen.")
    // 3. Return to Mae'chen
    call Quest_Return(q,gg_unit_n02Y_0052,"")
    call Quest_Say(q,null,"We have fought and defeated Mr. X. As it turns out, he is the planeswalker Gilgamesh. Unfortunately he was able to escape.")
    call Quest_Say(q,gg_unit_n02Y_0052,"That's fine. At least my friend no longer has to be ashamed.")
    call Quest_Say(q,gg_unit_n02Y_0052,"Thank you for your efforts. I will tell the night elves of your accomplishments.")
    call Quest_Reward(q,10000,10000)
endfunction

// Called by Gilgamesh (through ExecuteFunc) when Gilgamesh is defeated and escapes.
function BridgeBattle_GilgameshDefeated takes nothing returns nothing
    call Quest_StepDone(QUEST_BRIDGE_BATTLE,null,null)
endfunction

function Trig_BridgeBattle_Prepare_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[40]))and(udg_StoryProgress>=$F) // $F = 15
endfunction

function Trig_BridgeBattle_Prepare_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if QUEST_BRIDGE_BATTLE==0 then
        call BridgeBattle_Define()
    endif
    call Quest_MakeAvailable(QUEST_BRIDGE_BATTLE)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Mae'chen calls out to adventurers|r"
    set udg_NewsText[4]="Mae'chen has a special message for the adventurers: \"Please help me avenge my friend's humiliation!\""
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_BridgeBattle automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BridgeBattle (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BridgeBattle takes nothing returns nothing
endfunction

function Register_BridgeBattle_Prepare takes nothing returns nothing
    set gg_trg_BridgeBattle_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_BridgeBattle_Prepare)
    call TriggerRegisterTimerEventPeriodic(gg_trg_BridgeBattle_Prepare,15.)
    call TriggerAddCondition(gg_trg_BridgeBattle_Prepare,Condition(function Trig_BridgeBattle_Prepare_Conditions))
    call TriggerAddAction(gg_trg_BridgeBattle_Prepare,function Trig_BridgeBattle_Prepare_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BridgeBattle takes nothing returns nothing
    call Register_BridgeBattle_Prepare() // starts off; enabled by Epilogue, Quest_NightElves, Talk
endfunction

endlibrary
