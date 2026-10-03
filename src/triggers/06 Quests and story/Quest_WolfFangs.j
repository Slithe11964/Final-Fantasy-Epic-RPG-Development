library TQuestWolfFangs requires TQuestEngine
// Side quest "Wolf Fangs", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Valera, a villager in Kalm, wants 3 wolf fangs. Made available by Valera (QuestWolfFangs_Available).
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_WOLF_FANGS=0
endglobals

// Quest done: Valera also sells goods at the bazaar from now on (10 fangs' worth of material).
function QuestWolfFangs_Done takes nothing returns nothing
    set udg_MaterialOwnedCount[61]=udg_MaterialOwnedCount[61]+10
    set udg_LastBazaarShop=gg_unit_n01R_0081
    call ConditionalTriggerExecute(gg_trg_Bazaar_UpdateStock)
endfunction

function QuestWolfFangs_Define takes nothing returns nothing
    local integer q=Quest_Define("Wolf Fangs",QUEST_SIDE,26,"ReplaceableTextures\\CommandButtons\\BTNINV_Misc_Bone_06.blp")
    set QUEST_WOLF_FANGS=q
    // 1. Talk to Valera
    call Quest_Talk(q,gg_unit_n01R_0081,"Valera, villager from Kalm, asked you to bring him 3 wolf fangs. To get such fangs you must kill wolves, for example, Forest Wolves found in Guardia Forest.")
    call Quest_Say(q,gg_unit_n01R_0081,"Hello. I need help from a hunter. Do you happen to be the person I am looking for?")
    call Quest_Say(q,null,"Perhaps. What do you need?")
    call Quest_Say(q,gg_unit_n01R_0081,"I need someone to hunt Wolves and bring me their fangs.")
    call Quest_Say(q,null,"That should not be too difficult, but will take some time. Will the reward be worth the effort?")
    call Quest_Say(q,gg_unit_n01R_0081,"Of course. But there are some conditions.")
    call Quest_Say(q,gg_unit_n01R_0081,"First, I only need special fangs, few Wolves have such fangs. Here, look at this fang - I only need fangs like this one.\r\n|cffffcc00Valera shows you wolf's fang|r")
    call Quest_Say(q,gg_unit_n01R_0081,"And second, the fangs must be in perfect condition - I don't need damaged ones.")
    call Quest_Say(q,gg_unit_n01R_0081,"I recommend you go and hunt Forest Wolves in Guardia Forest - they are weakest of their kind but still have the fangs I need.")
    call Quest_Say(q,null,"And how many fangs do you need?")
    call Quest_Say(q,gg_unit_n01R_0081,"Three will be enough. And please remember - wolves are dangerous beasts or else I would have collected fangs myself. Good luck.")
    // 2. Bring 3 fangs to Valera (they can be handed over a few at a time)
    call Quest_Deliver(q,gg_unit_n01R_0081,'I08H',3,"Fangs brought to Valera","") // 'I08H': item "Wolf Fang"
    call Quest_Say(q,gg_unit_n01R_0081,"Thank you very much. You are a great hunter indeed.")
    call Quest_Reward(q,1000,500)
    call Quest_OnDone(q,"QuestWolfFangs_Done")
endfunction

// Called by Valera when the quest becomes available.
function QuestWolfFangs_Available takes nothing returns nothing
    if QUEST_WOLF_FANGS==0 then
        call QuestWolfFangs_Define()
    endif
    call Quest_MakeAvailable(QUEST_WOLF_FANGS)
endfunction

function InitTrig_Quest_WolfFangs takes nothing returns nothing
endfunction

endlibrary
