library TQuestPhoenix requires TQuestEngine
// Side quest "Phoenix", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Alma the Cleric asks the party to find out what happened to the Phoenix; they find its egg on the
// western islands and bring it to her. Made available by QuestCount, which runs gg_trg_Quest_Phoenix_Available.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Phoenix_Available=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_PHOENIX=0
endglobals

// Step 1 done (the party talked to Alma): the egg lies on the islands; the information shop sells a hint.
function QuestPhoenix_Started takes nothing returns nothing
    local location l_center=GetRectCenter(gg_rct_215)
    call SetItemInvulnerable(CreateItemLoc('kybl',l_center),true) // 'kybl': item "Phoenix Egg"
    call RemoveLocation(l_center)
    call AddItemToStockBJ('I04X',gg_unit_n02Y_0052,1,1) // 'I04X': item "Information: Phoenix"
    set l_center=null
endfunction

// The egg was picked up: the hint is no longer sold.
function QuestPhoenix_EggTaken takes nothing returns nothing
    call RemoveItemFromStockBJ('I04X',gg_unit_n02Y_0052) // 'I04X': item "Information: Phoenix"
endfunction

// Quest done: the Fire Golem alert starts in 60 seconds.
function QuestPhoenix_Done takes nothing returns nothing
    call EnableTrigger(gg_trg_Quest_FireGolem_Alert)
    call StartTimerBJ(udg_SharedDelayTimer1,false,60.)
endfunction

function QuestPhoenix_Define takes nothing returns nothing
    local integer q=Quest_Define("Phoenix",QUEST_SIDE,4,"ReplaceableTextures\\CommandButtons\\BTNMarkOfFire.blp")
    set QUEST_PHOENIX=q
    // 1. Talk to Alma
    call Quest_Talk(q,gg_unit_Hjai_0093,"Alma, Cleric from Kalm, asked you to find out what happened with Phoenix.")
    call Quest_Camera(q,gg_cam_004)
    call Quest_Say(q,gg_unit_Hjai_0093,"Ah you're the adventurers that have been the talk of the town lately. Maybe you could help me as well? ... Oh, sorry, I forgot to introduce myself - I am Alma the Cleric.")
    call Quest_Say(q,gg_unit_Hjai_0093,"I'll explain to you what kind of help I need. For hundreds of years on the islands to the west from here lived a Phoenix. This Phoenix aided the High Elves in battle many times when hordes of monsters attacked Kalm.")
    call Quest_Say(q,gg_unit_Hjai_0093,"The Phoenix not only helped High Elves fight off monsters but also healed the wounds of their warriors. In return, High Elves protected the Phoenix Egg.")
    call Quest_Say(q,gg_unit_Hjai_0093,"Phoenix lives for a long time, but when her life comes to an end she creates a nest, lays an egg and then burns herself with intense heat. Only by sacrificing herself may Phoenix give life to her fledgling.")
    call Quest_Say(q,gg_unit_Hjai_0093,"Phoenix was not seen for a long time now. The High Elves don't know if she is still alive or not and all our efforts to find her were unsuccessful - the monsters that spawned in great numbers everywhere prevented us from reaching the islands.")
    call Quest_Say(q,gg_unit_Hjai_0093,"We can't risk losing people in such desperate times. But you seem very capable fighters. Maybe you could go to the islands and find out what happened with Phoenix. I would appreciate it a lot if you do that.")
    call Quest_Say(q,null,"We'll look into this matter.")
    call Quest_OnDone(q,"QuestPhoenix_Started")
    // 2. Bring the egg to Alma
    call Quest_Deliver(q,gg_unit_Hjai_0093,'kybl',1,"","") // 'kybl': item "Phoenix Egg"
    call Quest_PingItem(q)
    call Quest_OnPickup(q,"Bring the Phoenix Egg to Alma.","QuestPhoenix_EggTaken")
    call Quest_Camera(q,gg_cam_004)
    call Quest_Say(q,gg_unit_Hjai_0093,"So, you found the egg but there was no trace of Phoenix herself? I am afraid she was killed because she wouldn't have left the egg. Anyway, thanks for your efforts. Here's the promised reward.")
    call Quest_Reward(q,2000,2000)
    call Quest_Say(q,gg_unit_Hjai_0093,"Thank you for your help and don't let some monster eat you - I might need your help again.")
    call Quest_OnDone(q,"QuestPhoenix_Done")
endfunction

function Trig_Quest_Phoenix_Available_Actions takes nothing returns nothing
    if QUEST_PHOENIX==0 then
        call QuestPhoenix_Define()
    endif
    call Quest_MakeAvailable(QUEST_PHOENIX)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Phoenix takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_Phoenix_Available takes nothing returns nothing
    set gg_trg_Quest_Phoenix_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Phoenix_Available)
    call TriggerAddAction(gg_trg_Quest_Phoenix_Available,function Trig_Quest_Phoenix_Available_Actions)
endfunction

endlibrary
