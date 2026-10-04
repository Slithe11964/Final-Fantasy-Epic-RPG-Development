library TQuestLadyNashj requires TQuestEngine
// Side quest "Lady Nashj", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Lenna, master ranger of Lothlorien, gives the party a charm that reveals the Naga Matriarch Lady Nashj and
// asks them to slay her. Made available by Epilogue, Quest_NightElves and Talk, which run
// gg_trg_Quest_LadyNashj_Available. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_LadyNashj_Init=null
    trigger gg_trg_Quest_LadyNashj_Available=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_LADY_NASHJ=0
    // Variables only this module uses.
    boolean udg_NashjDead=false
endglobals

// Step 1 done (the party talked to Lenna): the talking hero gets the charm, and Lady Nashj appears.
function QuestLadyNashj_Started takes nothing returns nothing
    set udg_QuestItem[27]=UnitAddItemByIdSwapped('I0BO',QuestDoneUnit) // 'I0BO': item "Grattheos Charm"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call ShowUnitShow(gg_unit_Hvsh_0145)
    call SetUnitInvulnerable(gg_unit_Hvsh_0145,false)
    call PauseUnitBJ(false,gg_unit_Hvsh_0145)
endfunction

// Step 2 done (Lady Nashj was slain): she drops her loot, and Dana's story can go on.
function QuestLadyNashj_Slain takes nothing returns nothing
    local location l_tempPoint
    set udg_NashjDead=true
    call SaveIntegerBJ(1,2,'i',udg_GameStateHash)
    set l_tempPoint=GetUnitLoc(gg_unit_Hvsh_0145)
    call CreateItemLoc('I00I',l_tempPoint) // 'I00I': item "Germinas Boots"
    call CreateItemLoc('I0HS',l_tempPoint) // 'I0HS': item "Maiden's Eye"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(l_tempPoint)
    call ConditionalTriggerExecute(gg_trg_Dana_Prepare)
    set l_tempPoint=null
endfunction

function QuestLadyNashj_Define takes nothing returns nothing
    local integer q=Quest_Define("Lady Nashj",QUEST_SIDE,12,"ReplaceableTextures\\CommandButtons\\BTNNagaSeaWitch.blp")
    set QUEST_LADY_NASHJ=q
    call Quest_NotStory(q)
    // 1. Talk to Lenna
    call Quest_Talk(q,gg_unit_eshd_0143,"Lenna, ranger from Lothlorien, asked you to slay evil Naga Matriarch named Lady Nashj.")
    call Quest_Say(q,gg_unit_eshd_0143,"Welcome to Lothlorien. I am Lenna, master ranger.")
    call Quest_Say(q,null,"You seem troubled. Do you need help?")
    call Quest_Say(q,gg_unit_eshd_0143,"In fact, I do. The Naga, our evil neighbours, ceaselessly attack our fishing ships. Their Matriarch, Lady Nashj, commands them to do so. We are not strong enough to fight Naga but here, in Lothlorien, we are protected by ancient magic of the forest.")
    call Quest_Say(q,gg_unit_eshd_0143,"Lady Nashj herself unfortunately also has special protection of waters and can't be seen without this charm here. If you feel strong enough I will give it to you so you can try assasinating her. If you succeed a great reward will be given to you.")
    call Quest_Say(q,null,"Sure, we'll take your charm and hunt down this sea witch.")
    call Quest_Say(q,gg_unit_eshd_0143,"You have my gratitude. Here's the charm and good luck to you.")
    call Quest_OnDone(q,"QuestLadyNashj_Started")
    // 2. Kill Lady Nashj
    call Quest_Kill(q,gg_unit_Hvsh_0145,"Come back to Lenna for reward.")
    call Quest_PingUnit(q)
    call Quest_OnDone(q,"QuestLadyNashj_Slain")
    // 3. Report back to Lenna
    call Quest_Return(q,gg_unit_eshd_0143,"")
    call Quest_Say(q,null,"Lady Nashj is dead. I don't know if Naga will stop harassing your ships but our part of the deal is done.")
    call Quest_Say(q,gg_unit_eshd_0143,"I hope it will help. Thank you very much.")
    call Quest_Reward(q,3000,2500)
    call Quest_Say(q,null,"So, do you want your charm back now?")
    call Quest_Say(q,gg_unit_eshd_0143,"No, you can just throw it away. It proved to be invaluable this time but to be honest it's known as a charm of misfortune amongst our kind. None of us fully understand how it works either.")
    call Quest_Say(q,null,"A charm of misfortune? Curious how it was the key to finding this witch nonetheless.")
endfunction

function Trig_Quest_LadyNashj_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_Hvsh_0145)
    call SetUnitInvulnerable(gg_unit_Hvsh_0145,true)
    call PauseUnitBJ(true,gg_unit_Hvsh_0145)
    set udg_NashjDead=false
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_LadyNashj_Available_Actions takes nothing returns nothing
    if QUEST_LADY_NASHJ==0 then
        call QuestLadyNashj_Define()
    endif
    call Quest_MakeAvailable(QUEST_LADY_NASHJ)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_LadyNashj takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_LadyNashj_Init takes nothing returns nothing
    set gg_trg_Quest_LadyNashj_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Quest_LadyNashj_Init,function Trig_Quest_LadyNashj_Init_Actions)
endfunction

function Register_Quest_LadyNashj_Available takes nothing returns nothing
    set gg_trg_Quest_LadyNashj_Available=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_LadyNashj_Available)
    call TriggerAddAction(gg_trg_Quest_LadyNashj_Available,function Trig_Quest_LadyNashj_Available_Actions)
endfunction

endlibrary
