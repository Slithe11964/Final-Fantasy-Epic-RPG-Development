library TQuestImperviousBeast requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText
// Side quest "Impervious Beast", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Ziegfried, clad in his new Arcanium gear, sets out to slay the great beast Fafnir; the party helps him.
// Made available by Ziegfried (QuestImperviousBeast_Available) when he arrives at the mine. Step 2 stays
// in this module's trigger gg_trg_Quest_ImperviousBeast_Complete (Fafnir registers its death event): its
// dialogue is spoken by whoever killed Fafnir. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_ImperviousBeast_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_IMPERVIOUS_BEAST=0
endglobals

// Step 1 done (the party talked to Ziegfried): he fights on the party's side and marches on Fafnir.
function QuestImperviousBeast_Started takes nothing returns nothing
    call UnitRemoveTypeBJ(UNIT_TYPE_PEON,gg_unit_H036_0254)
    call SetUnitAbilityLevelSwapped('A0SF',gg_unit_H036_0254,2) // 'A0SF': ability "Command AI"
    call UnitAddAbilityBJ('A0ZR',gg_unit_H036_0254) // 'A0ZR': ability "Immortal"
    call UnitAddAbilityBJ('A0Y2',gg_unit_H036_0254) // 'A0Y2': ability "Arcanium Immortality"
    call SetUnitInvulnerable(gg_unit_H036_0254,false)
    call EnableTrigger(gg_trg_Ziegfried_Advance_Order)
    call EnableTrigger(gg_trg_Fafnir_Battle_Begin)
endfunction

function QuestImperviousBeast_Define takes nothing returns nothing
    local integer q=Quest_Define("Impervious Beast",QUEST_SIDE,65,"ReplaceableTextures\\CommandButtons\\BTNMagnataur.blp")
    set QUEST_IMPERVIOUS_BEAST=q
    call Quest_NotStory(q)
    // 1. Talk to Ziegfried
    call Quest_Talk(q,gg_unit_H036_0254,"Ziegfried, the Thunder Striker and champion of the dwarves, has set out to defeat the great beast Fafnir in the abandoned mine of the Northern Mountains. Help him in his battle!")
    call Quest_Say(q,gg_unit_H036_0254,"Hello, I recall you were adventurers.")
    call Quest_Say(q,null,"Hello... wait, aren't you the champion of those dwarves? What are you doing here?")
    call Quest_Say(q,gg_unit_H036_0254,"I do guard those dwarves, but I am meant for far greater things.")
    call Quest_Say(q,null,"Greater things...?")
    call Quest_OnDone(q,"QuestImperviousBeast_Started")
    // 2. Fafnir dies once Ziegfried fights it (gg_trg_Quest_ImperviousBeast_Complete)
    call Quest_Custom(q,"")
endfunction

// Called by Ziegfried when he arrives at the mine.
function QuestImperviousBeast_Available takes nothing returns nothing
    if QUEST_IMPERVIOUS_BEAST==0 then
        call QuestImperviousBeast_Define()
    endif
    call Quest_MakeAvailable(QUEST_IMPERVIOUS_BEAST)
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

// Step 2: Fafnir died. It drops the Grand Armor; Ziegfried rewards the party and leaves (Siegfried, envoy of
// the Northern God, appears 3 minutes later).
function Trig_Quest_ImperviousBeast_Complete_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Ziegfried_Attack_Fafnir)
    if(Trig_Quest_ImperviousBeast_Complete_BossLogEnabled())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0BX',l_tempPoint) // 'I0BX': item "Grand Armor"
    call RemoveLocation(l_tempPoint)
    call Quest_StepDone(QUEST_IMPERVIOUS_BEAST,GetOwningPlayer(GetKillingUnitBJ()),GetKillingUnitBJ())
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

function Register_Quest_ImperviousBeast_Complete takes nothing returns nothing
    set gg_trg_Quest_ImperviousBeast_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ImperviousBeast_Complete)
    call TriggerAddCondition(gg_trg_Quest_ImperviousBeast_Complete,Condition(function Trig_Quest_ImperviousBeast_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_ImperviousBeast_Complete,function Trig_Quest_ImperviousBeast_Complete_Actions)
endfunction

endlibrary
