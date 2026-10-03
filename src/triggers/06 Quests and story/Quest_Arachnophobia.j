library TQuestArachnophobia requires TQuestEngine
// Side quest "Arachnophobia", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Kollin of the Hunt Club wants 15 spiders killed. Made available by Cid and Mid, which run
// gg_trg_Quest_Arachnophobia_Offer. Completing it makes Harpy Hunt available.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Arachnophobia_Offer=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ARACHNOPHOBIA=0
endglobals

function QuestArachnophobia_OfferHarpyHunt takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call ExecuteFunc("QuestHarpyHunt_Available") // module Quest_HarpyHunt
endfunction

// Quest done: Kollin offers the Thextera hunt, and 2 seconds later Caroline has the Harpy Hunt.
function QuestArachnophobia_Done takes nothing returns nothing
    set udg_CommonHuntsDone=udg_CommonHuntsDone+1
    call UnitAddAbility(gg_unit_n009_0051,'Ane2') // 'Ane2': standard ability
    call AddUnitToStockBJ('n0B2',gg_unit_n009_0051,1,1) // 'n0B2': unit "Hunt: Thextera"
    set udg_HuntStock[1]=udg_HuntStock[1]+1
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call TimerStart(CreateTimer(),2.,false,function QuestArachnophobia_OfferHarpyHunt)
endfunction

function QuestArachnophobia_Define takes nothing returns nothing
    local integer q=Quest_Define("Arachnophobia",QUEST_SIDE,2,"ReplaceableTextures\\CommandButtons\\BTNSpiderGreen.blp")
    set QUEST_ARACHNOPHOBIA=q
    // 1. Talk to Kollin
    call Quest_Talk(q,gg_unit_n009_0051,"Kollin, high elf in Kalm, asked you to kill 15 spiders.")
    call Quest_Say(q,gg_unit_n009_0051,"Greetings, adventurers. You seem to be experienced warriors.")
    call Quest_Say(q,gg_unit_n009_0051,"Allow me to welcome you here on behalf of the Hunt Club. We are an organization active all over Gaya, hunting down fiends and keeping the monster issues in check.")
    call Quest_Say(q,gg_unit_n009_0051,"As of late, the monsters have grown more aggressive. It would be a great help if you could join our cause.")
    call Quest_Say(q,gg_unit_n009_0051,"My current client is an arachnophobe. They hate, despise and fear spiders.")
    call Quest_Say(q,gg_unit_n009_0051,"They sent in a request for us to kill 15 spiders. If you take on this job, I would reward you with gold.")
    call Quest_Say(q,null,"This sounds like a tempting offer. We will take care of these pests!")
    // 2. Kill 15 spiders (hunt leaderboard row 1)
    call Quest_Hunt(q,1,15,"Spiders to kill","Return to Kollin for reward.")
    call Quest_Message(q,"You have killed enough spiders. Return to Kollin for a reward.")
    // the six standard Warcraft III spiders, then the map's own Vile Spider
    call Quest_HuntTarget(q,'nspg')
    call Quest_HuntTarget(q,'nspb')
    call Quest_HuntTarget(q,'nspr')
    call Quest_HuntTarget(q,'nssp')
    call Quest_HuntTarget(q,'nsgt')
    call Quest_HuntTarget(q,'nsbm')
    call Quest_HuntTarget(q,'n010') // 'n010': unit "Vile Spider"
    // 3. Report back to Kollin
    call Quest_Return(q,gg_unit_n009_0051,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,gg_unit_n009_0051,"You've done a good job clearing this quest. Here's your due reward.")
    call Quest_Reward(q,600,400)
    call Quest_Say(q,gg_unit_n009_0051,"I'm glad to welcome you as an honorary member of the Hunt Club. Some of my fellow members will gladly provide you with more jobs to do if you are willing to take them.")
    call Quest_Say(q,gg_unit_n009_0051,"Also, the Hunt Club does both Common Game hunts and Rare Game hunts. If you are interested in partaking in Rare Game hunts, you may want to talk to members of ours you've already done a Common Game hunt for.")
    call Quest_Say(q,gg_unit_n009_0051,"I currently am on the lookout for someone to hunt down a rare wolf. If you're interested in giving it a shot, come talk to me again, I'll tell you more about it.")
    call Quest_OnDone(q,"QuestArachnophobia_Done")
endfunction

function Trig_Quest_Arachnophobia_Offer_Actions takes nothing returns nothing
    if QUEST_ARACHNOPHOBIA==0 then
        call QuestArachnophobia_Define()
    endif
    call Quest_MakeAvailable(QUEST_ARACHNOPHOBIA)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Arachnophobia takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Arachnophobia_Offer takes nothing returns nothing
    set gg_trg_Quest_Arachnophobia_Offer=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Arachnophobia_Offer)
    call TriggerAddAction(gg_trg_Quest_Arachnophobia_Offer,function Trig_Quest_Arachnophobia_Offer_Actions)
endfunction

endlibrary
