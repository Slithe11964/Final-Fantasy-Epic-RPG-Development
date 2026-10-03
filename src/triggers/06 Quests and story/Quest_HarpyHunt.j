library TQuestHarpyHunt requires TQuestEngine
// Side quest "Harpy Hunt", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Caroline, the Hunt Club's Barrens representative, wants 20 harpies killed.
// Made available by Arachnophobia when it is completed (QuestHarpyHunt_Available).
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_HARPY_HUNT=0
endglobals

// Quest done: Caroline offers the Cactuar hunt.
function QuestHarpyHunt_Done takes nothing returns nothing
    set udg_CommonHuntsDone=udg_CommonHuntsDone+1
    call UnitAddAbility(gg_unit_n0B3_0049,'Ane2') // 'Ane2': standard ability
    call AddUnitToStockBJ('n0B6',gg_unit_n0B3_0049,1,1) // 'n0B6': unit "Hunt: Cactuar"
    set udg_HuntStock[2]=udg_HuntStock[2]+1
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
endfunction

function QuestHarpyHunt_Define takes nothing returns nothing
    local integer q=Quest_Define("Harpy Hunt",QUEST_SIDE,45,"ReplaceableTextures\\CommandButtons\\BTNHarpyQueen.blp")
    set QUEST_HARPY_HUNT=q
    // 1. Talk to Caroline
    call Quest_Talk(q,gg_unit_n0B3_0049,"Caroline, the Hunt Club Barrens representative, asked you to slay evil harpies who live in the Barrens south of Kalm. Report back after killing at least 20!")
    call Quest_Say(q,gg_unit_n0B3_0049,"Hello. I've heard from Kollin that you are now an honorary member of our Hunt Club.")
    call Quest_Say(q,gg_unit_n0B3_0049,"As such, I have another task for you to complete. For a gold reward, of course.")
    call Quest_Say(q,null,"So you want us to slay more dangerous monsters?")
    call Quest_Say(q,gg_unit_n0B3_0049,"Indeed. The club received a request from a Kalm resident who was recently cursed by an evil spell. The perpetrator was an arrogant harpy from the Barrens.")
    call Quest_Say(q,gg_unit_n0B3_0049,"He continues to work in poor failing health, but he won't be able to go on like this. Unfortunately the only way to break the curse is to kill the harpy that inflicted it. But we do not know which harpy it was.")
    call Quest_Say(q,null,"That is unfortunate. What would you have us do then?")
    call Quest_Say(q,gg_unit_n0B3_0049,"I'd say simply go by trial and error. The harpy in question must be out there somewhere.")
    call Quest_Say(q,null,"Fair enough. We will return to you once we've killed a number of harpies. Hopefully your friend will be healthy again then.")
    // 2. Kill 20 harpies (hunt leaderboard row 2)
    call Quest_Hunt(q,2,20,"Harpys to kill","Return to Caroline for a reward.")
    call Quest_Message(q,"You have killed enough harpies. Return to Caroline for a reward.")
    // the five standard Warcraft III harpies, then the map's own two
    call Quest_HuntTarget(q,'nhar')
    call Quest_HuntTarget(q,'nhrr')
    call Quest_HuntTarget(q,'nhrw')
    call Quest_HuntTarget(q,'nhrh')
    call Quest_HuntTarget(q,'nhrq')
    call Quest_HuntTarget(q,'n0L0') // 'n0L0': unit "Harpy Trickster"
    call Quest_HuntTarget(q,'n0KZ') // 'n0KZ': unit "Harpy Matriarch"
    // 3. Report back to Caroline
    call Quest_Return(q,gg_unit_n0B3_0049,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"Well, we have killed 20 harpies. Has your client recovered yet?")
    call Quest_Say(q,gg_unit_n0B3_0049,"Indeed he has. It seems the harpy that cursed him was among the ones you killed.")
    call Quest_Say(q,gg_unit_n0B3_0049,"Of course the bounty for this task is all yours. Here, take it.")
    call Quest_Reward(q,1500,1500)
    call Quest_OnDone(q,"QuestHarpyHunt_Done")
endfunction

// Called by Arachnophobia when the quest becomes available.
function QuestHarpyHunt_Available takes nothing returns nothing
    if QUEST_HARPY_HUNT==0 then
        call QuestHarpyHunt_Define()
    endif
    call Quest_MakeAvailable(QUEST_HARPY_HUNT)
endfunction

function InitTrig_Quest_HarpyHunt takes nothing returns nothing
endfunction

endlibrary
