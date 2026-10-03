library TQuestImperviousBeast requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_ImperviousBeast_Start=null
    trigger gg_trg_Quest_ImperviousBeast_Complete=null
endglobals

function Trig_Quest_ImperviousBeast_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_H036_0254,true,true,true))
endfunction

function Trig_Quest_ImperviousBeast_Start_PlayIntroScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ImperviousBeast_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[90])
    if(Trig_Quest_ImperviousBeast_Start_PlayIntroScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_H036_0254,"Hello, I recall you were adventurers.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello... wait, aren't you the champion of those dwarves? What are you doing here?",false)
        call Text_Say(gg_unit_H036_0254,"I do guard those dwarves, but I am meant for far greater things.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greater things...?",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Impervious Beast|r")
    set udg_SideQuest[65]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Impervious Beast"),"Ziegfried, the Thunder Striker and champion of the dwarves, has set out to defeat the great beast Fafnir in the abandoned mine of the Northern Mountains. Help him in his battle!","ReplaceableTextures\\CommandButtons\\BTNMagnataur.blp")
    set udg_SpecialEffect[90]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H036_0254,"Objects\\RandomObject\\RandomObject.mdl")
    call UnitRemoveTypeBJ(UNIT_TYPE_PEON,gg_unit_H036_0254)
    call SetUnitAbilityLevelSwapped('A0SF',gg_unit_H036_0254,2) // 'A0SF': ability "Command AI"
    call UnitAddAbilityBJ('A0ZR',gg_unit_H036_0254) // 'A0ZR': ability "Immortal"
    call UnitAddAbilityBJ('A0Y2',gg_unit_H036_0254) // 'A0Y2': ability "Arcanium Immortality"
    call SetUnitInvulnerable(gg_unit_H036_0254,false)
    call EnableTrigger(gg_trg_Ziegfried_Advance_Order)
    call EnableTrigger(gg_trg_Fafnir_Battle_Begin)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_ImperviousBeast_Complete_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_Fafnir)
endfunction

function Trig_Quest_ImperviousBeast_Complete_BossLogEnabled takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_ImperviousBeast_Complete_KillerNotInForce takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers)==false)
endfunction

function Trig_Quest_ImperviousBeast_Complete_PlayVictoryScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_ImperviousBeast_Complete_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Ziegfried_Attack_Fafnir)
    call DestroyEffectBJ(udg_SpecialEffect[90])
    if(Trig_Quest_ImperviousBeast_Complete_BossLogEnabled())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0BX',l_tempPoint) // 'I0BX': item "Grand Armor"
    call RemoveLocation(l_tempPoint)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Impervious Beast|r")
    call QuestSetCompletedBJ(udg_SideQuest[65],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    if(Trig_Quest_ImperviousBeast_Complete_PlayVictoryScene())then
        if(Trig_Quest_ImperviousBeast_Complete_KillerNotInForce())then
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        else
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        endif
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_H036_0254,"It is finished...",false)
        call Text_Say(gg_unit_H036_0254,"I've slain it... the legendary northern beast has fallen to my blades.",false)
        call Text_Say(udg_CinematicActor,"Those weapons you're wielding really are the real deal. Those smiths are incredible.",false)
        call Text_Say(gg_unit_H036_0254,"They truly are. There could be no more worthy weapons for me.",false)
        call Text_Say(udg_CinematicActor,"(I see his ego is as big as ever)",false)
        call Text_Say(gg_unit_H036_0254,"I may not look it, but I'm no stranger to gratitude. You did help me in my conquest of this beast, and so you are well-deserving of some of the spoils.",false)
        call Reward_Give($FA0,$2EE0,gg_unit_H036_0254) // $FA0 = 4000; $2EE0 = 12000
        call Text_Say(gg_unit_H036_0254,"It seem the beast also dropped a powerful armor. Of course there is no way it can match up to mine. You may take it as yours.",false)
        call Text_Say(udg_CinematicActor,"Well, congratulations on your achievement still.",false)
        call Text_Say(gg_unit_H036_0254,"The northern legends... with this I will go down as the hero. The one who stands up to even the northern god.",false)
        call Text_Say(udg_CinematicActor,"The northern god?",false)
        call Text_Say(gg_unit_H036_0254,"Well that is enough for now. I will continue to ascend as I am meant to.",false)
        call Cine_ExitAction()
    else
        call Reward_Give($FA0,$2EE0,gg_unit_H036_0254) // $FA0 = 4000; $2EE0 = 12000
    endif
    set l_tempPoint=GetUnitLoc(gg_unit_H036_0254)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call SetUnitAbilityLevelSwapped('A0SF',gg_unit_H036_0254,1) // 'A0SF': ability "Command AI"
    call UnitRemoveBuffBJ('B063',gg_unit_H036_0254) // 'B063': buff "Cover"
    call UnitRemoveBuffBJ('B051',gg_unit_H036_0254) // 'B051': buff "Divine Shield"
    call ShowUnitHide(gg_unit_H036_0254)
    call PauseUnitBJ(true,gg_unit_H036_0254)
    call SetUnitInvulnerable(gg_unit_H036_0254,true)
    call SetUnitOwner(gg_unit_H036_0254,Player(8),false)
    call EnableTrigger(gg_trg_Siegfried_Appear)
    call StartTimerBJ(udg_SharedDelayTimer5,false,180.)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Quest_ImperviousBeast takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part17 (module Quest),
// which keeps the original registration order.

function Register_Quest_ImperviousBeast_Start takes nothing returns nothing
    set gg_trg_Quest_ImperviousBeast_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ImperviousBeast_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_ImperviousBeast_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_ImperviousBeast_Start,Condition(function Trig_Quest_ImperviousBeast_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_ImperviousBeast_Start,function Trig_Quest_ImperviousBeast_Start_Actions)
endfunction

function Register_Quest_ImperviousBeast_Complete takes nothing returns nothing
    set gg_trg_Quest_ImperviousBeast_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ImperviousBeast_Complete)
    call TriggerAddCondition(gg_trg_Quest_ImperviousBeast_Complete,Condition(function Trig_Quest_ImperviousBeast_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_ImperviousBeast_Complete,function Trig_Quest_ImperviousBeast_Complete_Actions)
endfunction

endlibrary
