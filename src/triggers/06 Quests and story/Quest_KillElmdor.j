library TQuestKillElmdor requires TQuestEngine
// Side quest "Kill Elmdor", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Biggs, captain in Kalm, asks the party to kill Elmdor the Corrupted Samurai, then rewards them.
// Made available by Cid (and Epilogue), which run gg_trg_Quest_KillElmdor_Available.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_KillElmdor_Init=null
    trigger gg_trg_Quest_KillElmdor_Available=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_KILL_ELMDOR=0
endglobals

// Step 1 done (the party talked to Biggs): Elmdor appears and becomes a boss.
function QuestKillElmdor_ElmdorAppears takes nothing returns nothing
    call ShowUnitShow(gg_unit_Nbbc_0006)
    call PauseUnitBJ(false,gg_unit_Nbbc_0006)
    call SetUnitInvulnerable(gg_unit_Nbbc_0006,false)
    call GroupAddUnitSimple(gg_unit_Nbbc_0006,udg_BossUnits)
    if udg_QuestFlag[2]==false then
        call AddItemToStockBJ('I05E',gg_unit_n02Y_0052,1,1) // 'I05E': item "Information: Grand Vampire"
        set udg_QuestFlag[2]=true
    endif
endfunction

// Step 2 done (Elmdor died): he drops his katana.
function QuestKillElmdor_ElmdorSlain takes nothing returns nothing
    call GroupRemoveUnitSimple(gg_unit_Nbbc_0006,udg_BossUnits)
    call CreateItem('I00N',GetUnitX(gg_unit_Nbbc_0006),GetUnitY(gg_unit_Nbbc_0006)) // 'I00N': item "Kotetsu"
endfunction

// Quest done: the news board reports it and the Brothers quest becomes available.
function QuestKillElmdor_Done takes nothing returns nothing
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Elmdor Has Been Slain!|r"
    set udg_NewsText[4]="Elmdor, the corrupted samurai, has been slain by the adventurers! Congratulations!"
    call ConditionalTriggerExecute(gg_trg_Quest_Brothers_Available)
endfunction

function QuestKillElmdor_Define takes nothing returns nothing
    local integer q=Quest_Define("Kill Elmdor",QUEST_SIDE,6,"ReplaceableTextures\\CommandButtons\\BTNChaosBlademaster.blp")
    set QUEST_KILL_ELMDOR=q
    // 1. Talk to Biggs
    call Quest_Talk(q,gg_unit_h007_0089,"Biggs, captain in Kalm, promised reward for killing Elmdor the Corrupted Samurai.")
    call Quest_Say(q,gg_unit_h007_0089,"Greetings. My name is Biggs and I am the captain here.")
    call Quest_Say(q,gg_unit_h007_0089,"So, you're adventurers, right? Well, if you are strong enough you may try to kill Elmdor the Corrupted Samurai. He caused many troubles lately and I will pay handsomely for his death.")
    call Quest_Say(q,gg_unit_h007_0089,"I don't know where he came from but he killed two of my people and I want him dead. Do that - and the reward will be generous.")
    call Quest_Say(q,null,"His life is forfeit.")
    call Quest_OnDone(q,"QuestKillElmdor_ElmdorAppears")
    // 2. Kill Elmdor
    call Quest_Kill(q,gg_unit_Nbbc_0006,"Come back to Biggs for reward.")
    call Quest_OnDone(q,"QuestKillElmdor_ElmdorSlain")
    // 3. Report back to Biggs
    call Quest_Return(q,gg_unit_h007_0089,"")
    call Quest_Say(q,null,"Elmdor is dead.")
    call Quest_Say(q,gg_unit_h007_0089,"So you killed him? That is great to hear. Here's your reward.")
    call Quest_Reward(q,1500,1500)
    call Quest_Say(q,gg_unit_h007_0089,"You are strong indeed - Elmdor was no easy opponent to fight with. Izlude has a problem and he needs the help of powerful warriors to solve it. Perhaps you can help him.")
    call Quest_OnDone(q,"QuestKillElmdor_Done")
endfunction

// Map start: Elmdor waits hidden until the quest starts; Biggs ignores cinematics.
function Trig_Quest_KillElmdor_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_Nbbc_0006)
    call PauseUnitBJ(true,gg_unit_Nbbc_0006)
    call SetUnitInvulnerable(gg_unit_Nbbc_0006,true)
    call PauseUnitBJ(true,gg_unit_h007_0089)
    call UnitAddAbilityBJ('A0VJ',gg_unit_h007_0089) // 'A0VJ': ability "Unaffected by Cinematics"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillElmdor_Available_Actions takes nothing returns nothing
    if QUEST_KILL_ELMDOR==0 then
        call QuestKillElmdor_Define()
    endif
    call Quest_MakeAvailable(QUEST_KILL_ELMDOR)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_KillElmdor takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_KillElmdor_Init takes nothing returns nothing
    set gg_trg_Quest_KillElmdor_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Quest_KillElmdor_Init,function Trig_Quest_KillElmdor_Init_Actions)
endfunction

function Register_Quest_KillElmdor_Available takes nothing returns nothing
    set gg_trg_Quest_KillElmdor_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillElmdor_Available)
    call TriggerAddAction(gg_trg_Quest_KillElmdor_Available,function Trig_Quest_KillElmdor_Available_Actions)
endfunction

endlibrary
