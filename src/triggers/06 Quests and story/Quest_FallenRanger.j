library TQuestFallenRanger requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_FallenRanger_Start=null
    trigger gg_trg_Quest_FallenRanger_Complete=null
endglobals

function Trig_Quest_FallenRanger_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n01Y_0131,true,true,true))
endfunction

function Trig_Quest_FallenRanger_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FallenRanger_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[46])
    if(Trig_Quest_FallenRanger_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n01Y_0131,"Yukale... how could you... how?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You seem troubled. Is there something you need help with?",false)
        call Text_Say(gg_unit_n01Y_0131,"I don't know. My sister Yukale ... she betrayed us. Her hunger for power led her to the forbidden dark magic.",false)
        call Text_Say(gg_unit_n01Y_0131,"We both experimented with dark magic but I was too afraid to fully harness its power. Dark magic is dangerous but not too uncommon for us Night Elves.",false)
        call Text_Say(gg_unit_n01Y_0131,"After all, we are creatures of the night. It is not difficult for us to master the basics of the dark magic. But deeper knowledge leads to eternal damnation. ",false)
        call Text_Say(gg_unit_n01Y_0131,"There is no salvation for my sister now. She became obsessed with dark magic. She even joined those foul Satyrs. Please, kill Yukale before she is able to harm someone.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We'll do what we can.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Fallen Ranger|r")
    set udg_SideQuest[28]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffFallen Ranger","Liniel, sentry from Lothlorien, asked you to slay her sister Yukale.","ReplaceableTextures\\CommandButtons\\BTNShandris.blp")
    set udg_SpecialEffect[46]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n01Y_0131,"Objects\\RandomObject\\RandomObject.mdl")
    call ShowUnitShow(gg_unit_H00X_0133)
    call PauseUnitBJ(false,gg_unit_H00X_0133)
    call SetUnitInvulnerable(gg_unit_H00X_0133,false)
    call GroupAddUnitSimple(gg_unit_H00X_0133,udg_BossUnits)
    call EnableTrigger(gg_trg_Boss_Yukale_Death_Revive)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_FallenRanger_Complete_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Quest_FallenRanger_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FallenRanger_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[46])
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
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Fallen Ranger|r")
    call QuestSetCompletedBJ(udg_SideQuest[28],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_FallenRanger takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_FallenRanger_Start takes nothing returns nothing
    set gg_trg_Quest_FallenRanger_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FallenRanger_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FallenRanger_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_FallenRanger_Start,Condition(function Trig_Quest_FallenRanger_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_FallenRanger_Start,function Trig_Quest_FallenRanger_Start_Actions)
endfunction

function Register_Quest_FallenRanger_Complete takes nothing returns nothing
    set gg_trg_Quest_FallenRanger_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FallenRanger_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FallenRanger_Complete,450.,gg_unit_n01Y_0131)
    call TriggerAddCondition(gg_trg_Quest_FallenRanger_Complete,Condition(function Trig_Quest_FallenRanger_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_FallenRanger_Complete,function Trig_Quest_FallenRanger_Complete_Actions)
endfunction

endlibrary
