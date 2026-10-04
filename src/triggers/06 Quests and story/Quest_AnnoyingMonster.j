library TQuestAnnoyingMonster requires TQuestEngine, TUnit
// Side quest "Annoying Monster", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Lady Curse wants back the belongings a very annoying monster stole from her; as thanks she curses items for
// the party. Made available by Lady Curse (module LadyCurse), which calls QuestAnnoyingMonster_Available.
globals
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_ANNOYING_MONSTER=0
endglobals

// The Annoying Monster died: it drops the Lady's belongings, which the party has to bring back.
function QuestAnnoyingMonster_DropBelongings takes nothing returns nothing
    local location l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call SetItemInvulnerable(CreateItemLoc('ktrm',l_tempPoint),true) // 'ktrm': item "A Lady's Belongings"
    call RemoveLocation(l_tempPoint)
    call Quest_StepDone(QUEST_ANNOYING_MONSTER,GetOwningPlayer(GetKillingUnit()),GetKillingUnit())
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// Step 1 done (the party talked to Lady Curse): the Annoying Monster roams the Northern Mountains.
function QuestAnnoyingMonster_Started takes nothing returns nothing
    local location l_tempPoint
    local trigger t=CreateTrigger()
    set l_tempPoint=GetRandomLocInRect(gg_rct_150)
    call CreateNUnitsAtLoc(1,'n02V',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n02V': unit "Annoying Monster"; $B = 11
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRandomLocInRect(gg_rct_269)
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call TriggerRegisterUnitEvent(t,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call TriggerAddAction(t,function QuestAnnoyingMonster_DropBelongings)
    set l_tempPoint=null
    set t=null
endfunction

// Quest done: Lady Curse shows her true form and sells cursing scrolls, and the Very Annoying Monster hunt
// is offered.
function QuestAnnoyingMonster_Done takes nothing returns nothing
    if udg_CinematicsDisabled then
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00Lady Curse now sells cursing scrolls.|r")
    endif
    call ReplaceUnitBJ(gg_unit_h01P_0017,'h01Q',bj_UNIT_STATE_METHOD_RELATIVE) // 'h01Q': unit "Lady Curse"
    call AddUnitToStockBJ('n0B9',gg_unit_n0BW_0094,1,1) // 'n0B9': unit "Hunt: Very Annoying Monster"
    set udg_HuntStock[4]=(udg_HuntStock[4]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
endfunction

function QuestAnnoyingMonster_Define takes nothing returns nothing
    local integer q=Quest_Define("Annoying Monster",QUEST_SIDE,36,"ReplaceableTextures\\WorldEditUI\\Editor-Random-Item.blp")
    set QUEST_ANNOYING_MONSTER=q
    // 1. Talk to Lady Curse
    call Quest_Talk(q,gg_unit_h01P_0017,"Lady Curse asked you to search for a really annoying monster which stole something really important from her. Find the Monster, get it back and bring it to Lady Curse.")
    call Quest_Say(q,gg_unit_h01P_0017,"*looks around nervously*")
    call Quest_Say(q,null,"Erm...")
    call Quest_Say(q,gg_unit_h01P_0017,"You there. You're the adventurers right? Hunting monsters? Taking on any job for the right reward?")
    call Quest_Say(q,null,"Sure, for a good amount of gold, we'll get done anything you need.")
    call Quest_Say(q,gg_unit_h01P_0017,"Unfortunately I have no gold. But I have other services I can offer you.")
    call Quest_Say(q,gg_unit_h01P_0017,"In the world I come from, a common practice is the art of putting curses onto items. This will empower them greatly, but make them come with a tradeoff. Sound interesting no?")
    call Quest_Say(q,null,"That does sound tempting. If you can do some of that free of charge in place of a gold reward, that'd do nicely.")
    call Quest_Say(q,gg_unit_h01P_0017,"Great! Because I've been looking for someone who's willing to do a job without asking any unnecessary questions.")
    call Quest_Say(q,null,"That's a bit ominous. How can I be sure this isn't a trap?")
    call Quest_Say(q,gg_unit_h01P_0017,"It's not. It's very simple - a monster stole something important from me. All I need you to do is to locate this particular monster, take it down, and return it to me.")
    call Quest_Say(q,gg_unit_h01P_0017,"Nothing more to it than that. Simple enough right?")
    call Quest_Say(q,null,"Okay, if that's all I'll try and find this monster. Where did you encounter it?")
    call Quest_Say(q,gg_unit_h01P_0017,"I met it around the western side of the Northern Mountains. It's a very slippery and nimble monster so catching it can be hard. But thank you for your help !")
    call Quest_OnDone(q,"QuestAnnoyingMonster_Started")
    // 2. Kill the Annoying Monster (created in step 1, so the step is finished by QuestAnnoyingMonster_DropBelongings)
    call Quest_Custom(q,"")
    // 3. Bring the belongings back to Lady Curse
    call Quest_Deliver(q,gg_unit_h01P_0017,'ktrm',1,"","") // 'ktrm': item "A Lady's Belongings"
    call Quest_PingItem(q)
    call Quest_OnPickup(q,"Bring the belongings back to Lady Curse.","")
    call Quest_Say(q,null,"Here you go. This is what you wanted back, right?")
    call Quest_Say(q,gg_unit_h01P_0017,"Yes that's it. Thank you so much.")
    call Quest_Say(q,null,"Definitely not what I expected, but now it makes sense why you were being so vague.")
    call Quest_Say(q,gg_unit_h01P_0017,"I appreciate your help without asking much. It was so hard finding someone to approach about this you understand right?")
    call Quest_Say(q,null,"I sure do. So the deal was that now you will curse some gear for us, right?")
    call Quest_Say(q,gg_unit_h01P_0017,"Yes. So this is how it works, I will need a particular piece of gear to draw out the cursed power from, as well as a curse scroll to do so with. Curse scrolls are rare and only work on a particular piece of equipment each, but I can also craft some of them myself with Crystal Shards. I'll tell you beforehand what a curse on an item will do to it, don't worry.")
    call Quest_Say(q,null,"Sounds good. I'll see what curses would do well.")
    call Quest_Reward(q,0,2000)
    call Quest_Say(q,gg_unit_h01P_0017,"|n|cffffcc00Lady Curse now sells cursing scrolls.|r")
    call Quest_OnDone(q,"QuestAnnoyingMonster_Done")
endfunction

// Called by Lady Curse when she appears.
function QuestAnnoyingMonster_Available takes nothing returns nothing
    if QUEST_ANNOYING_MONSTER==0 then
        call QuestAnnoyingMonster_Define()
    endif
    call Quest_MakeAvailable(QUEST_ANNOYING_MONSTER)
endfunction

function InitTrig_Quest_AnnoyingMonster takes nothing returns nothing
endfunction

endlibrary
