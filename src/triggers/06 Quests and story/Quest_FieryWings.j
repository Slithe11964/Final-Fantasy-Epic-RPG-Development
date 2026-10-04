library TQuestFieryWings requires TQuestEngine, TUnit
// Side quest "Fiery Wings", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Zone and Watts, dwarves in the Barrens, want the Harpy Matriarch who united the harpy clans killed.
// Made available by Watts (QuestFieryWings_Available). The Matriarch only exists once the quest starts, so
// her death is a custom step finished by gg_trg_Quest_FieryWings_Matriarch_Dead.
// Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_FieryWings_Matriarch_Dead=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_FIERY_WINGS=0
endglobals

// Step 1 done (the party talked to Watts): the Harpy Matriarch appears on her hill, with five tricksters
// around the Barrens.
function QuestFieryWings_Started takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetRectCenter(gg_rct_569)
    call CreateNUnitsAtLoc(1,'n0KZ',Player($B),l_tempPoint,255.) // 'n0KZ': unit "Harpy Matriarch"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(l_tempPoint)
    set udg_HarpyMatriarch=GetLastCreatedUnit()
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossUnits)
    call TriggerRegisterUnitEvent(gg_trg_Quest_FieryWings_Matriarch_Dead,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Quest_FieryWings_Matriarch_Dead)
    call EnableTrigger(gg_trg_Harpy_Matriarch_CallAid)
    call EnableTrigger(gg_trg_Harpy_Trickster_Cleanup)
    set l_tempPoint=GetRectCenter(gg_rct_111)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set l_tempPoint=GetRectCenter(gg_rct_087)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set l_tempPoint=GetRectCenter(gg_rct_108)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set l_tempPoint=GetRectCenter(gg_rct_096)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set l_tempPoint=GetRectCenter(gg_rct_062)
    call CreateNUnitsAtLoc(1,'n0L0',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n0L0': unit "Harpy Trickster"; $B = 11
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call RemoveLocation(l_tempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HarpyTricksters)
    set l_tempPoint=null
endfunction

function QuestFieryWings_Define takes nothing returns nothing
    local integer q=Quest_Define("Fiery Wings",QUEST_SIDE,68,"ReplaceableTextures\\CommandButtons\\BTNHarpy.blp")
    set QUEST_FIERY_WINGS=q
    call Quest_NotStory(q)
    // 1. Talk to Zone and Watts
    call Quest_Talk(q,gg_unit_h00Q_0255,"Zone and Watts, a duo of dwarves in the Barrens, tasked you with taking down the Harpy Matriarch in the center of the Barrens that united the harpy clans.")
    call Quest_Say(q,gg_unit_h00Q_0255,"Lali-ho to ye! If ye're adventurers, we got a job for ye to take on.")
    call Quest_Say(q,null,"Sure, what've you got for us?")
    call Quest_Say(q,gg_unit_h00Q_0255,"See we heard from our pals in Kalm that monster activity has been on the rise and it's been kinda scary. We're in this remote corner but the monsters be leavin' us alone entirely.")
    call Quest_Say(q,gg_unit_h00Q_0255,"We hired the striker over there to protect us if it's necessary, but not even a single attack has hit us so far.")
    call Quest_Say(q,null,"That's strange. The monsters have certainly been aggressive lately. Why would they just leave you alone entirely?")
    call Quest_Say(q,gg_unit_h00Q_0255,"Well we been thinkin', what if they are gathering their forces for one big strike? Maybe they be scoutin' our defenses and aim to overwhelm us all at once.")
    call Quest_Say(q,gg_unit_h00Q_0255,"So the lads been lookin' around and saw that there's a big harpy uniting the harpy tribes all at once underneath her. It's right in the middle of the Barrens on a hill, ye can't miss it.")
    call Quest_Say(q,gg_unit_h00Q_0255,"If ye think ye're strong enough to take it on, kill it for us, will ye? We don' mind harpies too much but they can be seriously scheming and dangerous. If they be gearin' up for a big attack, losin' their leader should throw them in disorder an' keep us all safe.")
    call Quest_Say(q,gg_unit_h00Q_0255,"Careful though. Like I said, she's their leader, she'll call for aid when she's attacked. Might be wiser to take down the little ones all over the place first, lest ye get swarmed. But that's up to ye to decide.")
    call Quest_Say(q,null,"Worry not. We will take down this Harpy so you may feel safe once more.")
    call Quest_OnDone(q,"QuestFieryWings_Started")
    // 2. Kill the Harpy Matriarch (gg_trg_Quest_FieryWings_Matriarch_Dead)
    call Quest_Custom(q,"Return to Zone and Watts.")
    // 3. Return to Zone and Watts
    call Quest_Return(q,gg_unit_h00Q_0255,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"We have taken down the Harpy Matriarch. These harpies will bother you no longer.")
    call Quest_Say(q,gg_unit_h00Q_0255,"Aye many thanks. This'll help us sleep better at night.")
    call Quest_Reward(q,4000,2000)
endfunction

// Called by Watts when the dwarves first trust the party.
function QuestFieryWings_Available takes nothing returns nothing
    if QUEST_FIERY_WINGS==0 then
        call QuestFieryWings_Define()
    endif
    call Quest_MakeAvailable(QUEST_FIERY_WINGS)
endfunction

function Trig_Quest_FieryWings_Matriarch_Dead_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_HarpyMatriarch)
endfunction

function Trig_Quest_FieryWings_Matriarch_Dead_ReleaseHiddenHarpy takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

// Step 2: the Harpy Matriarch died. Her hidden tricksters come out; the party returns to Watts.
function Trig_Quest_FieryWings_Matriarch_Dead_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call DisableTrigger(gg_trg_Harpy_Matriarch_CallAid)
    call DisableTrigger(gg_trg_Harpy_Trickster_Cleanup)
    call ForGroupBJ(udg_HarpyTricksters,function Trig_Quest_FieryWings_Matriarch_Dead_ReleaseHiddenHarpy)
    call GroupClear(udg_HarpyTricksters)
    call Quest_StepDone(QUEST_FIERY_WINGS,GetOwningPlayer(GetKillingUnitBJ()),GetKillingUnitBJ())
    call StartTimerBJ(udg_HerbRespawnTimer[1],false,.5)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_FieryWings takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part19 (module Quest),
// which keeps the original registration order.

function Register_Quest_FieryWings_Matriarch_Dead takes nothing returns nothing
    set gg_trg_Quest_FieryWings_Matriarch_Dead=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FieryWings_Matriarch_Dead)
    call TriggerAddCondition(gg_trg_Quest_FieryWings_Matriarch_Dead,Condition(function Trig_Quest_FieryWings_Matriarch_Dead_Conditions))
    call TriggerAddAction(gg_trg_Quest_FieryWings_Matriarch_Dead,function Trig_Quest_FieryWings_Matriarch_Dead_Actions)
endfunction

endlibrary
