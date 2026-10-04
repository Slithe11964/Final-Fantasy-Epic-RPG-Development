library TQuestSpiritHunt requires TQuestEngine
// Side quest "Spirit Hunt", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Frakir the planeswalker wants 20 evil spirits destroyed. Made available by Frakir, which calls
// QuestSpiritHunt_Available. Does not count toward the story.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_SPIRIT_HUNT=0
endglobals

// Quest done: Frakir joins the Hunt Club and offers the Tonberry hunt.
function QuestSpiritHunt_Done takes nothing returns nothing
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_nsw2_0056) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0BE',gg_unit_nsw2_0056,1,1) // 'n0BE': unit "Hunt: Tonberry"
    set udg_HuntStock[$A]=(udg_HuntStock[$A]+1) // $A = 10
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
endfunction

function QuestSpiritHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Spirit Hunt",QUEST_SIDE,73,"ReplaceableTextures\\CommandButtons\\BTNShade.blp")
    set QUEST_SPIRIT_HUNT=q
    call Quest_NotStory(q)
    // 1. Talk to Frakir
    call Quest_Talk(q,gg_unit_nsw2_0056,"Frakir, a planeswalker residing in Kalm, has asked you to destroy 20 evil spirits.")
    call Quest_Say(q,gg_unit_nsw2_0056,"Hello adventurers. I have a task for you.")
    call Quest_Say(q,null,"You do? What do you want from us?")
    call Quest_Say(q,gg_unit_nsw2_0056,"Something rather unprecedented has occurred. A great number of evil spirits have invaded this world and they are posing quite a problem.")
    call Quest_Say(q,gg_unit_nsw2_0056,"These spirits are not the souls of the dead. They are manifestations of chaos and envy and sow a dark madness among the beasts they intermingle with, causing more of them to manifest in turn. They are a parasitic existence that threatens the world's very balance.")
    call Quest_Say(q,null,"That sounds very dangerous. They just suddenly appeared?")
    call Quest_Say(q,gg_unit_nsw2_0056,"They are not native to Gaya. I am unsure where they came from but it is best we try and rid them before this grows out of hand.")
    call Quest_Say(q,gg_unit_nsw2_0056,"At the very least I want you to kill 20 of these spirits and report back to me if their spread shows any signs of stopping.")
    call Quest_Say(q,null,"That won't be a problem. We'll take care of these evil spirits.")
    // 2. Kill 20 evil spirits (hunt leaderboard row 10)
    call Quest_Hunt(q,10,20,"Spirits to kill","Return to Frakir for a reward.")
    call Quest_Message(q,"You have killed enough spirits. Return to Frakir for a reward.")
    call Quest_HuntTarget(q,'nrvd') // 'nrvd': unit "Etem"
    call Quest_HuntTarget(q,'nvdg') // 'nvdg': unit "Evil Spirit"
    // 3. Report back to Frakir
    call Quest_Return(q,gg_unit_nsw2_0056,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"There truly are many evil spirits around these days. Their numbers do not seem to be dwindling but we have slain 20 of them as you asked.")
    call Quest_Say(q,gg_unit_nsw2_0056,"The spirits may continue to be a problem, but this is all I could ask for already. We might need to find a way of keeping them from entering this world entirely.")
    call Quest_Say(q,gg_unit_nsw2_0056,"It feels as though things have only gotten worse lately. But you have been instrumental in fighting these calamities. Here, have some gold for your future travels.")
    call Quest_Reward(q,6500,6000)
    call Quest_OnDone(q,"QuestSpiritHunt_Done")
endfunction

// Called by Frakir when he has the task for the party.
function QuestSpiritHunt_Available takes nothing returns nothing
    if QUEST_SPIRIT_HUNT==0 then
        call QuestSpiritHunt_Define()
    endif
    call Quest_MakeAvailable(QUEST_SPIRIT_HUNT)
endfunction

function InitTrig_Quest_SpiritHunt takes nothing returns nothing
endfunction

endlibrary
