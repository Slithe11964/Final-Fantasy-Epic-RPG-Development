library TDragonHunt requires TQuestEngine
// Side quest "Dragon Hunt", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Ma'kenroh, sage of the Hunt Club, wants 30 dragons of the Dark Dragon Marsh killed.
// Made available by Ma'kenroh (DragonHunt_Available). Does not count toward the story.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_DRAGON_HUNT=0
endglobals

// Quest done: Montblanc may have news (the hint timer starts checking).
function DragonHunt_Done takes nothing returns nothing
    set udg_CommonHuntsDone=udg_CommonHuntsDone+1
    call EnableTrigger(gg_trg_Montblanc_Hint_Timer)
endfunction

function DragonHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Dragon Hunt",QUEST_SIDE,63,"ReplaceableTextures\\CommandButtons\\BTNBlackDragon.blp")
    set QUEST_DRAGON_HUNT=q
    call Quest_NotStory(q)
    // 1. Talk to Ma'kenroh
    call Quest_Talk(q,gg_unit_h032_0007,"Ma'kenroh, sage of the Hunt Club, tasked you to kill 30 dragons in the Dark Dragon Marsh.")
    call Quest_Say(q,gg_unit_h032_0007,"Greetings once more. You've done a lot of good work for the club and proven your strength considerably. As such I have a special task for you.")
    call Quest_Say(q,gg_unit_h032_0007,"There is a region of Gaya the Hunt Club has not dared venture into as of yet. The dark marshes in the southwest, populated by dragons.")
    call Quest_Say(q,gg_unit_h032_0007,"They are highly dangerous and powerful. Even our best fighters would not hold out against them. But you just might be able to.")
    call Quest_Say(q,null,"Sounds like a dangerous task. I expect the reward will be worth the risk?")
    call Quest_Say(q,gg_unit_h032_0007,"Of course. Gaining control of the area is one of the major goals of our club. If you can hold your own and exterminate at least 30 dragons living there, you will be handsomely rewarded.")
    call Quest_Say(q,null,"We fear no dragons. We shall slay as many as we need to.")
    // 2. Kill 30 dragons (hunt leaderboard row 9)
    call Quest_Hunt(q,9,30,"Dragons to kill","Return to Ma'kenroh for a reward.")
    call Quest_Message(q,"You have killed enough dragons. Return to Ma'kenroh for a reward.")
    call Quest_HuntTarget(q,'n03G') // 'n03G': unit "Dusk Wyrm"
    call Quest_HuntTarget(q,'n03H') // 'n03H': unit "Black Dragon"
    call Quest_HuntTarget(q,'n03F') // 'n03F': unit "Marsh Whelp"
    call Quest_HuntTarget(q,'n03E') // 'n03E': unit "Nether Drake"
    // 3. Report back to Ma'kenroh
    call Quest_Return(q,gg_unit_h032_0007,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"Those dragons are seriously powerful! But we did manage to kill 30 of them in the end.")
    call Quest_Say(q,gg_unit_h032_0007,"I am most impressed and thankful. Take this, you've certainly earned it.")
    call Quest_Reward(q,8000,8000)
    call Quest_Say(q,gg_unit_h032_0007,"Maybe you will be the one to take down our club's primary target after all... but that is for Montblanc to decide.")
    call Quest_OnDone(q,"DragonHunt_Done")
endfunction

// Called by Ma'kenroh when the quest becomes available.
function DragonHunt_Available takes nothing returns nothing
    if QUEST_DRAGON_HUNT==0 then
        call DragonHunt_Define()
    endif
    call Quest_MakeAvailable(QUEST_DRAGON_HUNT)
endfunction

// World Editor calls InitTrig_DragonHunt automatically; it is intentionally empty (the quest engine
// creates the triggers this quest waits on).
function InitTrig_DragonHunt takes nothing returns nothing
endfunction

endlibrary
