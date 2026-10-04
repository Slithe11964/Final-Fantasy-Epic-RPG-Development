library TQuestTargetPractice requires TQuestEngine, TCam, TCine, TPlayerHero, TText, TUnit
// Side quest "Target Practice", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Aisha from the Phantom Village challenges the party to her target practice gauntlet (TargetPractice
// module). The talk stays a module trigger (Aisha is paused during it); TargetPractice moves the quest on
// and hands out the reward. The quest fails if Dana dies (TargetPractice_Fail, run by Dana).
// Does not count toward the story; Aisha's own markers (udg_SpecialEffect[81]) are kept.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_TargetPractice_Start=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_TARGET_PRACTICE=0
endglobals

function QuestTargetPractice_Define takes nothing returns nothing
    local integer q=Quest_Define("Target Practice",QUEST_SIDE,14,"ReplaceableTextures\\CommandButtons\\BTNMarksmanship.blp")
    set QUEST_TARGET_PRACTICE=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Aisha (gg_trg_Quest_TargetPractice_Start)
    call Quest_Custom(q,"Aisha from the Phantom Village has asked you to show her your skills in a target practice session. Speak with her again to take her challenge!")
    // 2. Hit every target in time (gg_trg_TargetPractice_TargetHit)
    call Quest_Custom(q,"Return to Aisha for a reward.")
    // 3. Report back to Aisha (gg_trg_TargetPractice_Reward)
    call Quest_Custom(q,"")
endfunction

function Trig_Quest_TargetPractice_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e017_0018,true,true,true))
endfunction

function Trig_Quest_TargetPractice_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_TargetPractice_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[81])
    call PauseUnitBJ(true,gg_unit_e017_0018)
    if(Trig_Quest_TargetPractice_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e017_0018,"You there! I heard you're quite a swift fighter!",false)
        call Text_Say(gg_unit_e017_0018,"In which case I'll have to challenge you to a game!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What kind of game?",false)
        call Text_Say(gg_unit_e017_0018,"We rangers pride ourselves on our speed and accuracy. And the ultimate test of speed and accuracy is of course ... Aisha's patented Target Practice gauntlet!",false)
        call Text_Say(gg_unit_e017_0018,"Here's how it goes down! You tell me when you want to start and targets will prop up all over the place. Over 50 of them!",false)
        call Text_Say(gg_unit_e017_0018,"Your goal is to hit all of them as fast as you can! If you set a record on our leaderboard, I'll recognize your skill!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Now that's what I call a challenge. You're on!",false)
        call Text_Say(gg_unit_e017_0018,"That's what I like to hear! The lowest time on our leaderboard is 120 seconds. But that won't be easy to beat either! Give it your all!",false)
        call Cine_ExitAction()
    endif
    call PauseUnitBJ(false,gg_unit_e017_0018)
    if QUEST_TARGET_PRACTICE==0 then
        call QuestTargetPractice_Define()
    endif
    call Quest_Start(QUEST_TARGET_PRACTICE,GetTriggerPlayer(),Player_GetHero(GetTriggerPlayer()))
    set udg_SpecialEffect[81]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e017_0018,"Objects\\RandomObject\\RandomObject.mdl")
    call UnitAddAbilityBJ('Aneu',gg_unit_e017_0018) // 'Aneu': standard ability reference "Neutral Building"
    call AddUnitToStockBJ('n0CF',gg_unit_e017_0018,1,1) // 'n0CF': unit "Target Practice Start"
    call EnableTrigger(gg_trg_TargetPractice_Begin)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_TargetPractice takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_TargetPractice_Start takes nothing returns nothing
    set gg_trg_Quest_TargetPractice_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_TargetPractice_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TargetPractice_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_TargetPractice_Start,Condition(function Trig_Quest_TargetPractice_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_TargetPractice_Start,function Trig_Quest_TargetPractice_Start_Actions)
endfunction

endlibrary
