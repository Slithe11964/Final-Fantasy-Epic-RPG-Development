library TAdamantHunt requires TQuestEngine
// Side quest "Adamant Hunt", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Bansat, the Hunt Club's representative at the Shipyard, wants 10 adamants killed.
// Made available at startup by Bansat (AdamantHunt_Available). Does not count toward the story.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ADAMANT_HUNT=0
endglobals

// Quest done: Bansat offers the Girimehkala hunt.
function AdamantHunt_Done takes nothing returns nothing
    set udg_CommonHuntsDone=udg_CommonHuntsDone+1
    call UnitAddAbility(gg_unit_h02Z_0230,'Ane2') // 'Ane2': standard ability
    call AddUnitToStockBJ('n0C6',gg_unit_h02Z_0230,1,1) // 'n0C6': unit "Hunt: Girimehkala"
    set udg_HuntStock[3]=udg_HuntStock[3]+1
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
endfunction

function AdamantHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Adamant Hunt",QUEST_SIDE,53,"ReplaceableTextures\\CommandButtons\\BTNSeaTurtleGreen.blp")
    set QUEST_ADAMANT_HUNT=q
    call Quest_NotStory(q)
    // 1. Talk to Bansat
    call Quest_Talk(q,gg_unit_h02Z_0230,"Bansat from the Hunt Club hired you to kill 10 adamants. Adamants are gigantic turtles predominantly found on the Central Islands.")
    call Quest_Say(q,gg_unit_h02Z_0230,"Greetings, adventurers. My name is Bansat. Have you come from Kalm?")
    call Quest_Say(q,null,"We have. What is this place exactly?")
    call Quest_Say(q,gg_unit_h02Z_0230,"This place is an important checkpoint outside of Kalm, the Shipyard. There aren't too many waters around here but you still need a boat to reach the islands on the other side of this river. You can purchase your own right over there. And if you're planning on heading over there I may have a proposal for you.")
    call Quest_Say(q,null,"We're listening.")
    call Quest_Say(q,gg_unit_h02Z_0230,"Perhaps you've heard of the Hunt Club? Well I'm the representative in charge of these islands and we're in a bit of a pickle. These islands contain a highly diverse fauna and there's a lot to hunt. However there's one type of monster that we generally do not engage in hunting: the Adamants.")
    call Quest_Say(q,gg_unit_h02Z_0230,"They are gigantic turtles and most weapons won't even make a dent in their shells. Normally they wouldn't be a problem since they are quite rare but since we've been leaving them alone for so long their numbers have started to multiply.")
    call Quest_Say(q,gg_unit_h02Z_0230,"I'm not asking for a genocide, but if you can thin their numbers by 10 that would be a great help already, and I'd be willing to give you a handsome reward on behalf of the club. And hey if you're lucky you may be able to harvest their valuable shells. They're incredibly durable and will net you a good amount of gold on the market.")
    call Quest_Say(q,null,"Worry not. We will thin their numbers and restore balance.")
    // 2. Kill 10 adamants (hunt leaderboard row 3)
    call Quest_Hunt(q,3,10,"Adamants to kill","Return to Bansat for a reward.")
    call Quest_Message(q,"You have killed enough adamants. Return to Bansat for a reward.")
    call Quest_HuntTarget(q,'ntrg') // 'ntrg': unit "Adamanchelid"
    call Quest_HuntTarget(q,'ntrd') // 'ntrd': unit "Adaman Tortoise"
    call Quest_HuntTarget(q,'n02P') // 'n02P': unit "Adamantoise"
    call Quest_HuntTarget(q,'n02Q') // 'n02Q': unit "Adaman Taimai"
    call Quest_HuntTarget(q,'n0N1') // 'n0N1': unit "Xiao Long Gui"
    // 3. Report back to Bansat
    call Quest_Return(q,gg_unit_h02Z_0230,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"Those turtles are HUGE! But we still managed to take 10 of them down.")
    call Quest_Say(q,gg_unit_h02Z_0230,"Great work! This'll surely give our hunters on the islands an easier time.")
    call Quest_Say(q,gg_unit_h02Z_0230,"Here's your reward, as promised.")
    call Quest_Reward(q,4000,4000)
    call Quest_Say(q,gg_unit_h02Z_0230,"By the way, did you know that if you use physical techs, you gain more experience from killing enemies?")
    call Quest_Say(q,gg_unit_h02Z_0230,"Not just you yourself either, everyone around you gains more experience from watching you finish off a foe in graceful fashion.")
    call Quest_Say(q,gg_unit_h02Z_0230,"So keep that in mind if you want to become a professional hunter more efficiently!")
    call Quest_OnDone(q,"AdamantHunt_Done")
endfunction

// Called by Bansat at startup: the quest is available from the start.
function AdamantHunt_Available takes nothing returns nothing
    if QUEST_ADAMANT_HUNT==0 then
        call AdamantHunt_Define()
    endif
    call Quest_MakeAvailable(QUEST_ADAMANT_HUNT)
endfunction

// World Editor calls InitTrig_AdamantHunt automatically; it is intentionally empty (the quest engine
// creates the triggers this quest waits on).
function InitTrig_AdamantHunt takes nothing returns nothing
endfunction

endlibrary
