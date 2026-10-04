library TWendigoHunt requires TQuestEngine
// Side quest "Wendigo Hunt", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Ward of the Hunt Club wants 30 wendigos of the icy realm killed and studied.
// Made available by Ward once the icy realm opens (WendigoHunt_Available). Does not count toward the story.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_WENDIGO_HUNT=0
endglobals

// Quest done: Ward offers the Umaro hunt.
function WendigoHunt_Done takes nothing returns nothing
    set udg_CommonHuntsDone=udg_CommonHuntsDone+1
    call UnitAddAbility(gg_unit_h030_0243,'Ane2') // 'Ane2': standard ability
    call AddUnitToStockBJ('n0MB',gg_unit_h030_0243,1,1) // 'n0MB': unit "Hunt: Umaro"
    set udg_HuntStock[8]=udg_HuntStock[8]+1
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
endfunction

function WendigoHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Wendigo Hunt",QUEST_SIDE,57,"ReplaceableTextures\\CommandButtons\\BTNWendigo.blp")
    set QUEST_WENDIGO_HUNT=q
    call Quest_NotStory(q)
    // 1. Talk to Ward
    call Quest_Talk(q,gg_unit_h030_0243,"Ward of the Hunt Club has asked you to kill 30 wendigos to be able to study and give a report on them.")
    call Quest_Say(q,gg_unit_h030_0243,"The gate is open at last... didn't think I'd get to see it happen. We've been trying to make it happen for so long.")
    call Quest_Say(q,gg_unit_h030_0243,"Scouring ancient texts from elves and the Seekers order... to no avail. But now you've opened it at last. On behalf of our club, I express my gratitude.")
    call Quest_Say(q,null,"Are you a member of the Hunt Club?")
    call Quest_Say(q,gg_unit_h030_0243,"That I am. Ward is my name. You are intent on exploring the icy realm straight away, right?")
    call Quest_Say(q,null,"That's the plan, yes.")
    call Quest_Say(q,gg_unit_h030_0243,"We of the Hunt Club will surely mobilize an expedition ourselves soon. But if you are going in straight away, I'd greatly appreciate you helping us in gathering information. Of course I'll put a bounty on it.")
    call Quest_Say(q,null,"Sounds good to me. What do you want us to do?")
    call Quest_Say(q,gg_unit_h030_0243,"It seems this icy realm is populated by a number of species, but most interesting to us are the Wendigos. If you could slay 30 of them and report your findings, that would do nicely.")
    call Quest_Say(q,null,"Sure, we'll have the info you want in no time.")
    // 2. Kill 30 wendigos (hunt leaderboard row 8)
    call Quest_Hunt(q,8,30,"Wendigos to kill","Return to Ward for a reward.")
    call Quest_Message(q,"You have killed enough wendigos. Return to Ward for a reward.")
    call Quest_HuntTarget(q,'n027') // 'n027': unit "Elder Wendigo"
    call Quest_HuntTarget(q,'n025') // 'n025': unit "Wendigo Shaman"
    call Quest_HuntTarget(q,'n026') // 'n026': unit "Wendigo"
    call Quest_HuntTarget(q,'n0MQ') // 'n0MQ': unit "Wendigo Berserker"
    // 3. Report back to Ward
    call Quest_Return(q,gg_unit_h030_0243,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"We've gathered the data you wanted.\r\n\r\n|cffffcc00The hero gives a report on their fights with wendigos.|r")
    call Quest_Say(q,gg_unit_h030_0243,"This is good information. Should help our hunters deal with these beasts more easily. Here's your reward, as promised.")
    call Quest_Reward(q,6000,5000)
    call Quest_OnDone(q,"WendigoHunt_Done")
endfunction

// Called by Ward when the quest becomes available.
function WendigoHunt_Available takes nothing returns nothing
    if QUEST_WENDIGO_HUNT==0 then
        call WendigoHunt_Define()
    endif
    call Quest_MakeAvailable(QUEST_WENDIGO_HUNT)
endfunction

// World Editor calls InitTrig_WendigoHunt automatically; it is intentionally empty (the quest engine
// creates the triggers this quest waits on).
function InitTrig_WendigoHunt takes nothing returns nothing
endfunction

endlibrary
