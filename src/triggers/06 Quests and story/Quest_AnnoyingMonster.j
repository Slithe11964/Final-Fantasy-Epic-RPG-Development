library TQuestAnnoyingMonster requires TCam, TCine, TPlayerHero, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_AnnoyingMonster_Start=null
endglobals

function Trig_Quest_AnnoyingMonster_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h01P_0017,true,true,true))
endfunction

function Trig_Quest_AnnoyingMonster_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_AnnoyingMonster_Start_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[54])
    if(Trig_Quest_AnnoyingMonster_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h01P_0017,"*looks around nervously*",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Erm...",false)
        call Text_Say(gg_unit_h01P_0017,"You there. You're the adventurers right? Hunting monsters? Taking on any job for the right reward?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sure, for a good amount of gold, we'll get done anything you need.",false)
        call Text_Say(gg_unit_h01P_0017,"Unfortunately I have no gold. But I have other services I can offer you.",false)
        call Text_Say(gg_unit_h01P_0017,"In the world I come from, a common practice is the art of putting curses onto items. This will empower them greatly, but make them come with a tradeoff. Sound interesting no?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That does sound tempting. If you can do some of that free of charge in place of a gold reward, that'd do nicely.",false)
        call Text_Say(gg_unit_h01P_0017,"Great! Because I've been looking for someone who's willing to do a job without asking any unnecessary questions.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's a bit ominous. How can I be sure this isn't a trap?",false)
        call Text_Say(gg_unit_h01P_0017,"It's not. It's very simple - a monster stole something important from me. All I need you to do is to locate this particular monster, take it down, and return it to me.",false)
        call Text_Say(gg_unit_h01P_0017,"Nothing more to it than that. Simple enough right?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Okay, if that's all I'll try and find this monster. Where did you encounter it?",false)
        call Text_Say(gg_unit_h01P_0017,"I met it around the western side of the Northern Mountains. It's a very slippery and nimble monster so catching it can be hard. But thank you for your help !",false)
        call Cine_ExitAction()
    endif
    set l_tempPoint=GetRandomLocInRect(gg_rct_150)
    call CreateNUnitsAtLoc(1,'n02V',Player($B),l_tempPoint,bj_UNIT_FACING) // 'n02V': unit "Annoying Monster"; $B = 11
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRandomLocInRect(gg_rct_269)
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"patrol",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call TriggerRegisterUnitEvent(gg_trg_AnnoyingMonster_DropBelongings,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Annoying Monster|r")
    set udg_SideQuest[36]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Annoying Monster"),"Lady Curse asked you to search for a really annoying monster which stole something really important from her. Find the Monster, get it back and bring it to Lady Curse.","ReplaceableTextures\\WorldEditUI\\Editor-Random-Item.blp")
    set udg_SpecialEffect[54]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h01P_0017,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_AnnoyingMonster_DropBelongings)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Quest_AnnoyingMonster takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part14 (module Quest),
// which keeps the original registration order.

function Register_Quest_AnnoyingMonster_Start takes nothing returns nothing
    set gg_trg_Quest_AnnoyingMonster_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_AnnoyingMonster_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_AnnoyingMonster_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_AnnoyingMonster_Start,Condition(function Trig_Quest_AnnoyingMonster_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_AnnoyingMonster_Start,function Trig_Quest_AnnoyingMonster_Start_Actions)
endfunction

endlibrary
