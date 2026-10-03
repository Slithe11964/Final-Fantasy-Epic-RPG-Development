library TGnollHunt requires TQuestEngine
// Side quest "Gnoll Hunt", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Kiros, the Hunt Club's new Farm representative, wants 40 gnolls killed in retribution for his fallen
// predecessor. Made available by Kiros (GnollHunt_Available). Does not count toward the story.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_GNOLL_HUNT=0
endglobals

// Step 1 done (the party talked to Kiros): Priest X may appear.
function GnollHunt_Started takes nothing returns nothing
    call ConditionalTriggerExecute(gg_trg_PriestX_Appear)
endfunction

// Quest done: Kiros offers the Cu Chulainn hunt.
function GnollHunt_Done takes nothing returns nothing
    set udg_CommonHuntsDone=udg_CommonHuntsDone+1
    call UnitAddAbility(gg_unit_n0BV_0229,'Ane2') // 'Ane2': standard ability
    call AddUnitToStockBJ('n0C5',gg_unit_n0BV_0229,1,1) // 'n0C5': unit "Hunt: Cu Chulainn"
    set udg_HuntStock[5]=udg_HuntStock[5]+1
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
endfunction

function GnollHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Gnoll Hunt",QUEST_SIDE,54,"ReplaceableTextures\\CommandButtons\\BTNGnollWarden.blp")
    set QUEST_GNOLL_HUNT=q
    call Quest_NotStory(q)
    // 1. Talk to Kiros
    call Quest_Talk(q,gg_unit_n0BV_0229,"Kiros, newly appointed Farm representative of the Hunt Club, has asked you to take part in their retribution hunt for their fallen representative and kill 40 gnolls.")
    call Quest_Say(q,gg_unit_n0BV_0229,"Greetings, adventurers. I am Kiros. May I speak to you for a bit?")
    call Quest_Say(q,null,"Kiros? Haven't seen you around here much.")
    call Quest_Say(q,gg_unit_n0BV_0229,"I've only recently arrived here. After you reported the death of the previous Hunt Club representative of this region, I was dispatched to replace him.")
    call Quest_Say(q,null,"Oh... my condolences.")
    call Quest_Say(q,gg_unit_n0BV_0229,"We're quite shaken to have lost a valued member so suddenly. And as is tradition, we will initiate a retribution hunt shortly.")
    call Quest_Say(q,null,"A retribution hunt?")
    call Quest_Say(q,gg_unit_n0BV_0229,"You think we'll let those brutal gnolls get away with taking down one of our own? No way. By the time we're done with them they'll be scared to leave their caves.")
    call Quest_Say(q,null,"I see. Good riddance. They are bloodthirsty monsters. They don't deserve any mercy.")
    call Quest_Say(q,gg_unit_n0BV_0229,"Indeed. And on that note I was hoping to ask you to participate in our retribution hunt.")
    call Quest_Say(q,gg_unit_n0BV_0229,"There's no kill count too high to attain justice for our fallen comrade. But every man can only hunt so many. If you kill 40 gnolls, we of the Hunt Club will be proud to reimburse you for doing your part in our project.")
    call Quest_Say(q,null,"40 gnolls? Should be a piece of cake.")
    call Quest_OnDone(q,"GnollHunt_Started")
    // 2. Kill 40 gnolls (hunt leaderboard row 5)
    call Quest_Hunt(q,5,40,"Gnolls to kill","Return to Kiros for a reward.")
    call Quest_Message(q,"You have killed enough gnolls. Return to Kiros for a reward.")
    // the five standard Warcraft III gnolls
    call Quest_HuntTarget(q,'ngno')
    call Quest_HuntTarget(q,'ngna')
    call Quest_HuntTarget(q,'ngns')
    call Quest_HuntTarget(q,'ngnw')
    call Quest_HuntTarget(q,'ngnv')
    // 3. Report back to Kiros
    call Quest_Return(q,gg_unit_n0BV_0229,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"It is done. 40 more gnolls are history.")
    call Quest_Say(q,gg_unit_n0BV_0229,"You've done great work. We will continue the retribution from here.")
    call Quest_Reward(q,3500,2500)
    call Quest_OnDone(q,"GnollHunt_Done")
endfunction

// Called by Kiros when the quest becomes available.
function GnollHunt_Available takes nothing returns nothing
    if QUEST_GNOLL_HUNT==0 then
        call GnollHunt_Define()
    endif
    call Quest_MakeAvailable(QUEST_GNOLL_HUNT)
endfunction

// World Editor calls InitTrig_GnollHunt automatically; it is intentionally empty (the quest engine
// creates the triggers this quest waits on).
function InitTrig_GnollHunt takes nothing returns nothing
endfunction

endlibrary
