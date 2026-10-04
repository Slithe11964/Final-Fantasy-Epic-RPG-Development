library TQuestEidolonChallenge requires TQuestEngine
// Side quest "Eidolon Challenge", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// The Brothers (Minotaur and Sacred) want the party to beat their four Eidolon friends - Titan, Pandemona,
// Typhon and Leviathan - so that they help defend Kalm. Made available by Brothers (Minotaur's alert after
// the first Kalm Siege), which calls QuestEidolonChallenge_Available. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_EidolonChallenge_Count=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_EIDOLON_CHALLENGE=0
    // Variables only this module uses.
    integer udg_EidolonsDefeated=0
endglobals

// Step 1 done (the party talked to the Brothers): the Eidolons can be found and fought.
function QuestEidolonChallenge_Started takes nothing returns nothing
    set udg_QuestReq[3]=CreateQuestItemBJ(Quest_LogEntry(QUEST_EIDOLON_CHALLENGE),"Eidolons defeated: 0/4")
    call ShowUnitShow(gg_unit_H01I_0070)
    call PauseUnitBJ(false,gg_unit_H01I_0070)
    call SetUnitInvulnerable(gg_unit_H01I_0070,false)
    call ShowUnitShow(gg_unit_H01J_0069)
    call PauseUnitBJ(false,gg_unit_H01J_0069)
    call SetUnitInvulnerable(gg_unit_H01J_0069,false)
    call ShowUnitShow(gg_unit_H01K_0068)
    call PauseUnitBJ(false,gg_unit_H01K_0068)
    call SetUnitInvulnerable(gg_unit_H01K_0068,false)
    call EnableTrigger(gg_trg_Eidolon_Found_Reveal)
    call EnableTrigger(gg_trg_Eidolon_Leviathan_Ambush)
    call EnableTrigger(gg_trg_Quest_EidolonChallenge_Count)
endfunction

// Quest done: the Eidolons are saved as recruited, and a minute later Minotaur offers the rematch.
function QuestEidolonChallenge_Done takes nothing returns nothing
    call SaveIntegerBJ(1,2,93,udg_GameStateHash)
    call SaveIntegerBJ(1,2,94,udg_GameStateHash)
    call SaveIntegerBJ(1,2,95,udg_GameStateHash)
    call SaveIntegerBJ(1,2,96,udg_GameStateHash)
    call StartTimerBJ(udg_SharedDelayTimer4,false,60.)
    call EnableTrigger(gg_trg_Brothers_Alert_Rematch)
endfunction

function QuestEidolonChallenge_Define takes nothing returns nothing
    local integer q=Quest_Define("Eidolon Challenge",QUEST_SIDE,32,"ReplaceableTextures\\WorldEditUI\\Editor-MultipleUnits.blp")
    set QUEST_EIDOLON_CHALLENGE=q
    call Quest_NotStory(q)
    // 1. Talk to the Brothers
    call Quest_Talk(q,gg_unit_Ocb2_0147,"The Brothers, Sacred and Minotaur, have tasked you with beating up their friends, Titan, Leviathan, Pandemona and Typhon, to have them help defend Kalm. Find and defeat them all!")
    call Quest_Say(q,gg_unit_Ocb2_0147,"Hey, you. Been talkin' with bro.")
    call Quest_Say(q,gg_unit_Ocbh_0148,"This town's been seeing some pretty hefty attacks lately. Can see why ya recruited us.")
    call Quest_Say(q,null,"Yes, you've been a tremendous help.")
    call Quest_Say(q,gg_unit_Ocbh_0148,"Well, we got an idea for you there.")
    call Quest_Say(q,gg_unit_Ocb2_0147,"Bro and I were thinking we could have our friends help defend the gates. Our Eidolon friends.")
    call Quest_Say(q,null,"More defenders? That sounds great. You can call them over right away!")
    call Quest_Say(q,gg_unit_Ocb2_0147,"Slow down there, mighty one.")
    call Quest_Say(q,gg_unit_Ocb2_0147,"We already contacted all of them. But us Eidolons have our pride you know.")
    call Quest_Say(q,gg_unit_Ocbh_0148,"We know you're very powerful, mighty ones, but our friends need to be convinced of that themselves!")
    call Quest_Say(q,gg_unit_Ocb2_0147,"So if you want to have them help defend the gates, you'll have to beat them in battle like you did us. Should be simple right?")
    call Quest_Say(q,null,"Hmm, that sounds fair. Alright we'll beat them up and drag them over here then. Where can I find them?")
    call Quest_Say(q,gg_unit_Ocb2_0147,"They're scattered around the world. Maybe you'll be able to tell where to find them when you hear a bit more.")
    call Quest_Say(q,gg_unit_Ocb2_0147,"We've four friends we asked for this little idea: Titan, Leviathan, Pandemona and Typhon.")
    call Quest_Say(q,gg_unit_Ocbh_0148,"Titan is a very old friend of ours. He's specialized on earth, just like we are. Even though he's an ogre, like Cyclops, his intelligence is quite something. Him and Cyclops aren't related to each other, by the way.")
    call Quest_Say(q,gg_unit_Ocbh_0148,"Leviathan is an Eidolon we met by coincidence. Just when we were fighting some guy who wanted us as his servants, he appeared and blew that guy away. We complained at first, but we eventually became good friends. His element is Water, by the way.")
    call Quest_Say(q,gg_unit_Ocbh_0148,"Pandemona and Typhon are the lords of wind. They're pretty famous in the world of the Eidolons, so it's nothing special we know them. They're great fighters and are good friends, so you'll likely find them together.")
    call Quest_Say(q,gg_unit_Ocb2_0147,"And that's all you need to know. Good Luck!")
    call Quest_OnDone(q,"QuestEidolonChallenge_Started")
    // 2. Defeat the four Eidolons (counted by the Count trigger below)
    call Quest_Custom(q,"Come back to the Brothers for a reward.")
    // 3. Talk to the Brothers again
    call Quest_Talk(q,gg_unit_Ocb2_0147,"")
    call Quest_Say(q,null,"Good news, we succeded in defeating Titan, Typhon, Pandemona and Leviathan.")
    call Quest_Say(q,gg_unit_Ocb2_0147,"Yeah, we know, they're right here.")
    call Quest_Say(q,null,"Oh, right.")
    call Quest_Say(q,gg_unit_Ocbh_0148,"You really are strong, o mighty one!")
    call Quest_Say(q,gg_unit_Ocb2_0147,"Defending this town will be much easier now. Also have this, a token of our respect.")
    call Quest_Reward(q,4000,4000)
    call Quest_OnDone(q,"QuestEidolonChallenge_Done")
endfunction

// Called by Brothers when Minotaur has something to tell the party.
function QuestEidolonChallenge_Available takes nothing returns nothing
    if QUEST_EIDOLON_CHALLENGE==0 then
        call QuestEidolonChallenge_Define()
    endif
    call Quest_MakeAvailable(QUEST_EIDOLON_CHALLENGE)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_IsLeviathan takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01L_0067)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_IsWindLordB takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01K_0068)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_IsWindLordA takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01J_0069)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_IsTitan takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01I_0070)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_SiegeInProgress takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_AllyRangerGroup)==false)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_AllEidolonsBeaten takes nothing returns boolean
    return(udg_EidolonsDefeated==4)
endfunction

// An Eidolon was beaten: it is revived at its post in Kalm as an ally. After the fourth, step 2 is done.
function Trig_Quest_EidolonChallenge_Count_Actions takes nothing returns nothing
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    set udg_EidolonsDefeated=(udg_EidolonsDefeated+1)
    call QuestItemSetDescriptionBJ(udg_QuestReq[3],("Eidolons defeated: "+(I2S(udg_EidolonsDefeated)+"/4")))
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    if(Trig_Quest_EidolonChallenge_Count_Cond_IsTitan())then
        set udg_TempPoint=GetRectCenter(gg_rct_405)
    else
        if(Trig_Quest_EidolonChallenge_Count_Cond_IsWindLordA())then
            set udg_TempPoint=GetRectCenter(gg_rct_407)
        else
            if(Trig_Quest_EidolonChallenge_Count_Cond_IsWindLordB())then
                set udg_TempPoint=GetRectCenter(gg_rct_369)
            else
                if(Trig_Quest_EidolonChallenge_Count_Cond_IsLeviathan())then
                    set udg_TempPoint=GetRectCenter(gg_rct_228)
                endif
            endif
        endif
    endif
    call ReviveHeroLoc(GetTriggerUnit(),udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitManaPercentBJ(GetTriggerUnit(),'d')
    call SetUnitFacingTimed(GetTriggerUnit(),GetUnitFacing(gg_unit_hhes_0087),0)
    call GroupAddUnitSimple(GetTriggerUnit(),udg_RecruitedAllies)
    if(Trig_Quest_EidolonChallenge_Count_Cond_SiegeInProgress())then
        call ShowUnitHide(GetTriggerUnit())
    endif
    call SetUnitOwner(GetTriggerUnit(),Player(9),true)
    call UnitAddAbilityBJ('A0VJ',GetTriggerUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
    call SetUnitInvulnerable(GetTriggerUnit(),true)
    call PauseUnitBJ(true,GetTriggerUnit())
    call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_ALL,GetTriggerUnit())
    if(Trig_Quest_EidolonChallenge_Count_Cond_AllEidolonsBeaten())then
        call DisableTrigger(GetTriggeringTrigger())
        call DisableTrigger(gg_trg_Eidolon_Found_Reveal)
        call DestroyTrigger(gg_trg_Eidolon_Found_Reveal)
        call QuestItemSetCompletedBJ(udg_QuestReq[3],true)
        call Quest_StepDone(QUEST_EIDOLON_CHALLENGE,GetOwningPlayer(GetKillingUnit()),GetKillingUnit())
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function InitTrig_Quest_EidolonChallenge takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part12 (module Quest),
// which keeps the original registration order.

function Register_Quest_EidolonChallenge_Count takes nothing returns nothing
    set gg_trg_Quest_EidolonChallenge_Count=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_EidolonChallenge_Count)
    call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01I_0070,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01J_0069,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01K_0068,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01L_0067,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_EidolonChallenge_Count,function Trig_Quest_EidolonChallenge_Count_Actions)
endfunction

endlibrary
