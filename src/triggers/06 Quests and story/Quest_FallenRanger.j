library TQuestFallenRanger requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText
// Side quest "Fallen Ranger", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Liniel, sentry from Lothlorien, asks the party to slay her sister Yukale, who turned to dark magic.
// Made available by Liniel (QuestFallenRanger_Available). Yukale rises again as the Dark Ranger
// (Boss_Yukale); the Dark Ranger's death (Boss_DarkRanger) calls QuestFallenRanger_DarkRangerSlain. The
// last step stays in gg_trg_Quest_FallenRanger_Complete: its dialogue ends with a notice that is shown even
// when the cinematic is skipped. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_FallenRanger_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_FALLEN_RANGER=0
endglobals

// Step 1 done (the party talked to Liniel): Yukale appears as a boss.
function QuestFallenRanger_Started takes nothing returns nothing
    call ShowUnitShow(gg_unit_H00X_0133)
    call PauseUnitBJ(false,gg_unit_H00X_0133)
    call SetUnitInvulnerable(gg_unit_H00X_0133,false)
    call GroupAddUnitSimple(gg_unit_H00X_0133,udg_BossUnits)
    call EnableTrigger(gg_trg_Boss_Yukale_Death_Revive)
endfunction

function QuestFallenRanger_Define takes nothing returns nothing
    local integer q=Quest_Define("Fallen Ranger",QUEST_SIDE,28,"ReplaceableTextures\\CommandButtons\\BTNShandris.blp")
    set QUEST_FALLEN_RANGER=q
    call Quest_NotStory(q)
    // 1. Talk to Liniel
    call Quest_Talk(q,gg_unit_n01Y_0131,"Liniel, sentry from Lothlorien, asked you to slay her sister Yukale.")
    call Quest_Say(q,gg_unit_n01Y_0131,"Yukale... how could you... how?")
    call Quest_Say(q,null,"You seem troubled. Is there something you need help with?")
    call Quest_Say(q,gg_unit_n01Y_0131,"I don't know. My sister Yukale ... she betrayed us. Her hunger for power led her to the forbidden dark magic.")
    call Quest_Say(q,gg_unit_n01Y_0131,"We both experimented with dark magic but I was too afraid to fully harness its power. Dark magic is dangerous but not too uncommon for us Night Elves.")
    call Quest_Say(q,gg_unit_n01Y_0131,"After all, we are creatures of the night. It is not difficult for us to master the basics of the dark magic. But deeper knowledge leads to eternal damnation. ")
    call Quest_Say(q,gg_unit_n01Y_0131,"There is no salvation for my sister now. She became obsessed with dark magic. She even joined those foul Satyrs. Please, kill Yukale before she is able to harm someone.")
    call Quest_Say(q,null,"We'll do what we can.")
    call Quest_OnDone(q,"QuestFallenRanger_Started")
    // 2. Kill Yukale, then the Dark Ranger she becomes (Boss_DarkRanger)
    call Quest_Custom(q,"Come back to Liniel for reward.")
    // 3. Return to Liniel (gg_trg_Quest_FallenRanger_Complete)
    call Quest_Custom(q,"")
endfunction

// Called by Liniel when the quest becomes available.
function QuestFallenRanger_Available takes nothing returns nothing
    if QUEST_FALLEN_RANGER==0 then
        call QuestFallenRanger_Define()
    endif
    call Quest_MakeAvailable(QUEST_FALLEN_RANGER)
endfunction

// The Dark Ranger died (called by Boss_DarkRanger, which runs before the quest engine).
function QuestFallenRanger_DarkRangerSlain takes nothing returns nothing
    call Quest_StepDone(QUEST_FALLEN_RANGER,null,null)
endfunction

function Trig_Quest_FallenRanger_Complete_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_FallenRanger_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 3: a hero returns to Liniel. The Ancient of Wonders starts selling the Absorber.
function Trig_Quest_FallenRanger_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_n01Y_0131,udg_BossUnits)
    if(Trig_Quest_FallenRanger_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n01Y_0131,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Yukale is dead. Truly dead.",false)
        call Text_Say(gg_unit_n01Y_0131,"Too bad I couldn't persuade Yukale to abandon her dark path.",false)
        call Reward_Give($DAC,$DAC,gg_unit_n01Y_0131) // $DAC = 3500
        call Text_Say(gg_unit_n01Y_0131,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give($DAC,$DAC,gg_unit_n01Y_0131) // $DAC = 3500
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
    endif
    call AddItemToStockBJ('I018',gg_unit_n00L_0153,1,1) // 'I018': item "Absorber"
    call Quest_StepDone(QUEST_FALLEN_RANGER,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_FallenRanger takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_FallenRanger_Complete takes nothing returns nothing
    set gg_trg_Quest_FallenRanger_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FallenRanger_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FallenRanger_Complete,450.,gg_unit_n01Y_0131)
    call TriggerAddCondition(gg_trg_Quest_FallenRanger_Complete,Condition(function Trig_Quest_FallenRanger_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_FallenRanger_Complete,function Trig_Quest_FallenRanger_Complete_Actions)
endfunction

endlibrary
