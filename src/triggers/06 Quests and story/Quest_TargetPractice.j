library TQuestTargetPractice requires TCam, TCine, TPlayerHero, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_TargetPractice_Start=null
endglobals

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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Target Practice|r")
    set udg_SideQuest[$E]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Target Practice"),"Aisha from the Phantom Village has asked you to show her your skills in a target practice session. Speak with her again to take her challenge!","ReplaceableTextures\\CommandButtons\\BTNMarksmanship.blp") // $E = 14
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
