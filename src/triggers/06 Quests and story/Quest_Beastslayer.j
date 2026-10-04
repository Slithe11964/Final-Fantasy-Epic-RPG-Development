library TQuestBeastslayer requires TQuestEngine, TUnit
// Side quest "Find Beastslayer", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Jessie, archer from Kalm, lost Meliadoul's magic arrow to a Tempest Lizard in the Barrens; the party kills
// the lizard and brings the arrow back. Made available by Cid and Epilogue, which run
// gg_trg_Quest_Beastslayer_Available.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Beastslayer_Available=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_BEASTSLAYER=0
endglobals

// The Tempest Lizard died: it drops the Beastslayer, and the party has to bring it to Jessie.
function QuestBeastslayer_ArrowDropped takes nothing returns nothing
    local location l_tempPoint
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call SetItemInvulnerable(CreateItemLoc('I00T',l_tempPoint),true) // 'I00T': item "Beastslayer"
    call RemoveLocation(l_tempPoint)
    call Quest_StepDone(QUEST_BEASTSLAYER,GetOwningPlayer(GetKillingUnit()),GetKillingUnit())
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// Step 1 done (the party talked to Jessie): the Tempest Lizard appears somewhere in the Barrens.
function QuestBeastslayer_Started takes nothing returns nothing
    local trigger t=CreateTrigger()
    // A random whole number from 1 through LoadIntegerBJ(2, 2, udg_SpawnDataHashRef).
    call CreateNUnitsAtLoc(1,'n011',Player($B),GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(2,2,udg_SpawnDataHashRef)),2,udg_SpawnRectHashRef)),bj_UNIT_FACING) // 'n011': unit "Tempest Lizard"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossUnits)
    call TriggerRegisterUnitEvent(t,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call TriggerAddAction(t,function QuestBeastslayer_ArrowDropped)
    set t=null
endfunction

// Quest done: the Tempest Wyrm hunt, and Jessie sells archery gear.
function QuestBeastslayer_Done takes nothing returns nothing
    if udg_CinematicsDisabled then
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00Jessie now sells Archery gear.|r")
    endif
    call AddUnitToStockBJ('n0B7',gg_unit_n0B3_0049,1,1) // 'n0B7': unit "Hunt: Tempest Wyrm"
    set udg_HuntStock[2]=(udg_HuntStock[2]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call UnitAddAbilityBJ('Aneu',gg_unit_n00D_0091) // 'Aneu': standard ability reference "Neutral Building"
    call AddItemToStockBJ('I0F4',gg_unit_n00D_0091,1,1) // 'I0F4': item "Longbow"
    call AddItemToStockBJ('I0HN',gg_unit_n00D_0091,1,1) // 'I0HN': item "Onion Arrows"
    call AddItemToStockBJ('I0HP',gg_unit_n00D_0091,1,1) // 'I0HP': item "Icecloud Arrows"
endfunction

function QuestBeastslayer_Define takes nothing returns nothing
    local integer q=Quest_Define("Find Beastslayer",QUEST_SIDE,11,"ReplaceableTextures\\CommandButtons\\BTNImprovedStrengthOfTheMoon.blp")
    set QUEST_BEASTSLAYER=q
    // 1. Talk to Jessie
    call Quest_Talk(q,gg_unit_n00D_0091,"Jessie, archer from Kalm, asked you to find magical arrow called Beastslayer in the Barrens.")
    call Quest_Say(q,gg_unit_n00D_0091,"Greetings to you. I am Jessie. I have a small problem, could you help me please?")
    call Quest_Say(q,null,"Sure, why not?")
    call Quest_Say(q,gg_unit_n00D_0091,"Recently I went hunting to Barrens and I took mistress Meliadoul's special arrow - the Beastslayer. It's a magical arrow that can kill any beast with one shot.")
    call Quest_Say(q,gg_unit_n00D_0091,"I shot this arrow at a huge Thunder Lizard, but, to my dismay, it not only didn't die but charged at me with full speed. I barely escaped. Now I can't go back to mistress Meliadoul because I lost the Beastslayer. Please, find this arrow and bring it to me. If you do, I will offer you a reward and on top of that give you something special for your own archery training.")
    call Quest_Say(q,null,"I'll see what can be done.")
    call Quest_OnDone(q,"QuestBeastslayer_Started")
    // 2. Kill the Tempest Lizard (created in step 1, so the step is finished by QuestBeastslayer_ArrowDropped)
    call Quest_Custom(q,"")
    // 3. Bring the Beastslayer to Jessie
    call Quest_Deliver(q,gg_unit_n00D_0091,'I00T',1,"","") // 'I00T': item "Beastslayer"
    call Quest_PingItem(q)
    call Quest_OnPickup(q,"Bring the Beastslayer to Jessie.","")
    call Quest_Say(q,gg_unit_n00D_0091,"Oh, thank you! I'm saved !!")
    call Quest_Reward(q,1500,1000)
    call Quest_Say(q,gg_unit_n00D_0091,"|n|cffffcc00Jessie now sells Archery gear.|r")
    call Quest_Say(q,gg_unit_n00D_0091,"By the way, when you use arrows with an elemental affinity, the Rapid Fire technique changes its elemental affinity with them! Try it out sometime.")
    call Quest_OnDone(q,"QuestBeastslayer_Done")
endfunction

function Trig_Quest_Beastslayer_Available_Actions takes nothing returns nothing
    if QUEST_BEASTSLAYER==0 then
        call QuestBeastslayer_Define()
    endif
    call Quest_MakeAvailable(QUEST_BEASTSLAYER)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Beastslayer takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Beastslayer_Available takes nothing returns nothing
    set gg_trg_Quest_Beastslayer_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Beastslayer_Available)
    call TriggerAddAction(gg_trg_Quest_Beastslayer_Available,function Trig_Quest_Beastslayer_Available_Actions)
endfunction

endlibrary
