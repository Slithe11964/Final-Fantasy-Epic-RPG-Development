library TQuestShimmerweed requires TQuestEngine
// Side quest "Find Shimmerweed", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Elena wants a Shimmerweed from the forest (module Shimmerweed spawns it). Made available by Cid and Mid,
// which run gg_trg_Quest_Shimmerweed_Offer.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Shimmerweed_Offer=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_SHIMMERWEED=0
endglobals

function QuestShimmerweed_Define takes nothing returns nothing
    local integer q=Quest_Define("Find Shimmerweed",QUEST_SIDE,1,"ReplaceableTextures\\CommandButtons\\BTNShimmerWeed.blp")
    set QUEST_SHIMMERWEED=q
    // 1. Talk to Elena
    call Quest_Talk(q,gg_unit_n008_0050,"Elena, woman in Kalm, asked you to bring her shimmerweed from forest.")
    call Quest_Say(q,gg_unit_n008_0050,"Hello, my name is Elena. Could you do me a favour?")
    call Quest_Say(q,null,"Yes, what do you want?")
    call Quest_Say(q,gg_unit_n008_0050,"I desperately need a plant called Shimmerweed. It grows in the forest but recently many monsters appeared there and it is too dangerous for me to go there.")
    call Quest_Say(q,gg_unit_n008_0050,"If you would go to the forest could you please look for Shimmerweed? And if you find it, please bring it to me, I will pay you for it.")
    // 2. Bring a Shimmerweed to Elena
    call Quest_Deliver(q,gg_unit_n008_0050,'I0FM',1,"","") // 'I0FM': item "Shimmerweed"
    call Quest_PingItem(q)
    call Quest_OnPickup(q,"Bring the Shimmerweed to Elena.","")
    call Quest_Say(q,gg_unit_n008_0050,"Thank you very much for bringing me Shimmerweed.")
    call Quest_Reward(q,400,300)
endfunction

function Trig_Quest_Shimmerweed_Offer_Actions takes nothing returns nothing
    if QUEST_SHIMMERWEED==0 then
        call QuestShimmerweed_Define()
    endif
    call Quest_MakeAvailable(QUEST_SHIMMERWEED)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Shimmerweed takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part8 (module Quest),
// which keeps the original registration order.

function Register_Quest_Shimmerweed_Offer takes nothing returns nothing
    set gg_trg_Quest_Shimmerweed_Offer=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Shimmerweed_Offer)
    call TriggerAddAction(gg_trg_Quest_Shimmerweed_Offer,function Trig_Quest_Shimmerweed_Offer_Actions)
endfunction

endlibrary
