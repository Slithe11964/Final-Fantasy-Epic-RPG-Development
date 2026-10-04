library TQuestOgreHunt requires TQuestEngine
// Side quest "Ogre Hunt", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Monica, a Hunt Club member in Kalm, wants 25 ogres killed.
// Made available by Monica (QuestOgreHunt_Available).
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_OGRE_HUNT=0
endglobals

// Quest done: one more common hunt for the Hunt Club; Monica becomes a plain shop again.
function QuestOgreHunt_Done takes nothing returns nothing
    set udg_CommonHuntsDone=udg_CommonHuntsDone+1
    call UnitAddAbility(gg_unit_n0BW_0094,'Ane2') // 'Ane2': standard ability
endfunction

function QuestOgreHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Ogre Hunt",QUEST_SIDE,24,"ReplaceableTextures\\CommandButtons\\BTNOgre.blp")
    set QUEST_OGRE_HUNT=q
    // 1. Talk to Monica
    call Quest_Talk(q,gg_unit_n0BW_0094,"Monica, high elf Hunt Club member in Kalm, hired you to slay 25 ogres who live in the mountains northwest of Kalm. ")
    call Quest_Say(q,gg_unit_n0BW_0094,"Hello there. My name is Monica and I'm a member of the Hunt Club. I have a request you could take on.")
    call Quest_Say(q,null,"We are ready for anything. Tell us what you've got.")
    call Quest_Say(q,gg_unit_n0BW_0094,"We've been tasked to clear out Ogres. Those dirty, filthy, stupid imbeciles. One of their tribes now inhabits mountains near Kalm. These brutes are some of the most dangerous among the monsters threatening Kalm.")
    call Quest_Say(q,gg_unit_n0BW_0094,"Ogres are cannibals and also they enjoy eating human and elven flesh. These creatures must not be allowed to live. So we received a request to have at least 25 ogres exterminated. Naturally you'll receive the bounty on this quest if you do it.")
    call Quest_Say(q,null,"Those ogres need to be taught to fear humans. We will gladly take your request.")
    // 2. Kill 25 ogres (hunt leaderboard row 4)
    call Quest_Hunt(q,4,25,"Ogres to kill","Return to Monica for a reward.")
    call Quest_Message(q,"You have killed enough ogres. Return to Monica for a reward.")
    // four standard Warcraft III ogres, then the map's own two
    call Quest_HuntTarget(q,'nogr')
    call Quest_HuntTarget(q,'nomg')
    call Quest_HuntTarget(q,'nogm')
    call Quest_HuntTarget(q,'nogl')
    call Quest_HuntTarget(q,'n0MO') // 'n0MO': unit "Ogre Berserker"
    call Quest_HuntTarget(q,'H00W') // 'H00W': unit "Ogre Crusher"
    // 3. Report back to Monica
    call Quest_Return(q,gg_unit_n0BW_0094,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,gg_unit_n0BW_0094,"I see you've cleared the task. You've done great work. Here's your due reward.")
    call Quest_Reward(q,2000,2000)
    call Quest_OnDone(q,"QuestOgreHunt_Done")
endfunction

// Called by Monica when the quest becomes available.
function QuestOgreHunt_Available takes nothing returns nothing
    if QUEST_OGRE_HUNT==0 then
        call QuestOgreHunt_Define()
    endif
    call Quest_MakeAvailable(QUEST_OGRE_HUNT)
endfunction

// World Editor calls InitTrig_Quest_OgreHunt automatically; it is intentionally empty (the quest engine
// creates the triggers this quest waits on).
function InitTrig_Quest_OgreHunt takes nothing returns nothing
endfunction

endlibrary
