library TQuestTrialByFire requires TQuestEngine, TCam, TCine, TMusic, TPlayerHero, TReward, TText, TWait
// Side quest "Trial By Fire", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// McBurn challenges the party to hold out against him in the arena for 30 seconds. Steps: talk to
// McBurn (data), buy his arena battle (Begin), survive 30 seconds (Countdown -> Survive). Losing the
// battle fails the quest (Fail, run by Arena_BattleResults). Made available by McBurn
// (QuestTrialByFire_Available). It does not count toward the story progress.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_TrialByFire_Begin=null
    trigger gg_trg_Quest_TrialByFire_Countdown=null
    trigger gg_trg_Quest_TrialByFire_Fail=null
    trigger gg_trg_Quest_TrialByFire_Survive=null
    // Variables only this module uses.
    integer udg_TrialByFireSeconds=0
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_TRIAL_BY_FIRE=0
endglobals

// Step 1 done (the party talked to McBurn): his battle is sold by the arena organizer.
function QuestTrialByFire_Started takes nothing returns nothing
    call AddUnitToStockBJ('n0AY',udg_ArenaOrganizer[6],1,1) // 'n0AY': unit "Arena: Almighty Conflagration Battle"
    call GroupAddUnitSimple(gg_unit_n0AX_0188,udg_BossUnits)
    call EnableTrigger(gg_trg_Quest_TrialByFire_Begin)
endfunction

function QuestTrialByFire_Define takes nothing returns nothing
    local integer q=Quest_Define("Trial By Fire",QUEST_SIDE,50,"ReplaceableTextures\\CommandButtons\\BTNWallOfFire.blp")
    set QUEST_TRIAL_BY_FIRE=q
    call Quest_NotStory(q)
    // 1. Talk to McBurn
    call Quest_Talk(q,gg_unit_n0AX_0188,"McBurn, a demon who seems bored, asked you if you could withstand his flames for 30 seconds. Prove your worth to him!")
    call Quest_Say(q,gg_unit_n0AX_0188,"Hey you there. The name's McBurn.")
    call Quest_Say(q,null,"McBurn is it? You've been watching us fight, haven't you?")
    call Quest_Say(q,gg_unit_n0AX_0188,"Yeah. You've been doing pretty good.")
    call Quest_Say(q,gg_unit_n0AX_0188,"Been looking for someone who can take some heat. I figured my best chances of finding someone like that are right here.")
    call Quest_Say(q,null,"That's surprising. You don't give off the vibe of needing the help of strong people.")
    call Quest_Say(q,gg_unit_n0AX_0188,"Help? Nah that's not what I'm looking for. I'm looking for a challenge, that's all.")
    call Quest_Say(q,null,"A challenge...?")
    call Quest_Say(q,gg_unit_n0AX_0188,"Can't say I feel like I've found my equal just yet, but you could at least help me get a bit more fired up.")
    call Quest_Say(q,gg_unit_n0AX_0188,"So I have a proposal for you: entertain me with a dance. If you can hold out, I'll give you a handsome reward.")
    call Quest_Say(q,null,"You want us to dance?")
    call Quest_Say(q,gg_unit_n0AX_0188,"I'll get to the point. Face me in this arena. I'm not asking you to beat me. Just to be entertaining for at least a little while.")
    call Quest_Say(q,gg_unit_n0AX_0188,"Not going to ask too much of you either. If I can heat up for just 30 seconds, I'm content.")
    call Quest_Say(q,null,"Aren't you overconfident. What if we beat you?")
    call Quest_Say(q,gg_unit_n0AX_0188,"You won't.")
    call Quest_Say(q,gg_unit_n0AX_0188,"30 seconds is all I'm asking for. If you think you can do it, let's go.")
    call Quest_OnDone(q,"QuestTrialByFire_Started")
    // 2. Buy the arena battle: gg_trg_Quest_TrialByFire_Begin calls Quest_StepDone
    call Quest_Custom(q,"Survive against McBurn for 30 seconds.")
    // 3. Survive 30 seconds: gg_trg_Quest_TrialByFire_Survive calls Quest_StepDone (or Fail fails the quest)
    call Quest_Custom(q,"")
endfunction

// Called by McBurn when the quest becomes available.
function QuestTrialByFire_Available takes nothing returns nothing
    if QUEST_TRIAL_BY_FIRE==0 then
        call QuestTrialByFire_Define()
    endif
    call Quest_MakeAvailable(QUEST_TRIAL_BY_FIRE)
endfunction

function Trig_Quest_TrialByFire_Begin_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n0AX_0188)
endfunction

// McBurn was bought as an arena battle: the 30-second fight starts.
function Trig_Quest_TrialByFire_Begin_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_n0AX_0188)
    call GroupRemoveUnitSimple(gg_unit_n0AX_0188,udg_BossUnits)
    set udg_TrialByFireSeconds=30
    call StartTimerBJ(udg_PostReviveTimer,false,1.)
    if Quest_IsActive(QUEST_TRIAL_BY_FIRE) and Quest_CurrentStep(QUEST_TRIAL_BY_FIRE)==2 then
        call Quest_StepDone(QUEST_TRIAL_BY_FIRE,GetOwningPlayer(GetBuyingUnit()),GetBuyingUnit())
    else
        // bought again after the quest failed or was done: the old trigger showed the update anyway
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Survive against McBurn for 30 seconds.")
        call QuestSetDescriptionBJ(Quest_LogEntry(QUEST_TRIAL_BY_FIRE),"Survive against McBurn for 30 seconds.")
    endif
    call Music_SetTrack(33)
endfunction

function Trig_Quest_TrialByFire_Countdown_Cond_TimeUp takes nothing returns boolean
    return(udg_TrialByFireSeconds<=0)
endfunction

function Trig_Quest_TrialByFire_Countdown_Cond_FightRunning takes nothing returns boolean
    return(IsUnitPausedBJ(udg_ScriptedBossUnit)==false)and(udg_InCinematicMode==false)
endfunction

function Trig_Quest_TrialByFire_Countdown_Actions takes nothing returns nothing
    if(Trig_Quest_TrialByFire_Countdown_Cond_FightRunning())then
        set udg_TrialByFireSeconds=(udg_TrialByFireSeconds-1)
        if(Trig_Quest_TrialByFire_Countdown_Cond_TimeUp())then
            call ConditionalTriggerExecute(gg_trg_Quest_TrialByFire_Survive)
        else
            // (50) plus ((udg_TrialByFireSeconds treated as a decimal-capable number) times ((5) divided by (3))).
            call SetUnitLifePercentBJ(udg_ScriptedBossUnit,(50.+(I2R(udg_TrialByFireSeconds)*(5./ 3.))))
            set udg_TempPoint=GetRectCenter(gg_rct_046)
            call CreateTextTagLocBJ(I2S(udg_TrialByFireSeconds),udg_TempPoint,0,$A,'d',(I2R(udg_TrialByFireSeconds)*5.),(I2R(udg_TrialByFireSeconds)*5.),0) // $A = 10
            call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
            call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
            call SetTextTagFadepointBJ(GetLastCreatedTextTag(),.5)
            call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),GetPlayersAll())
            call RemoveLocation(udg_TempPoint)
        endif
    endif
endfunction

function Trig_Quest_TrialByFire_Fail_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_TrialByFire_Fail_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_TrialByFire_Countdown)
    call DestroyTrigger(gg_trg_Quest_TrialByFire_Countdown)
    call DestroyTrigger(gg_trg_Quest_TrialByFire_Survive)
    if(Trig_Quest_TrialByFire_Fail_Cond_ShowDialog())then
        call Cine_Enter()
        set udg_TempPoint=GetUnitLoc(udg_ScriptedBossUnit)
        call CreateNUnitsAtLoc(1,'U00G',Player(8),udg_TempPoint,GetUnitFacing(udg_ScriptedBossUnit)) // 'U00G': unit "Blazing Demon"
        set udg_CinematicActor=GetLastCreatedUnit()
        call RemoveLocation(udg_TempPoint)
        call Cam_PanToUnit(udg_CinematicActor,0)
        set udg_ScriptedBossUnit=null
        call Wait_Polled(1.)
        call Text_Say(udg_CinematicActor,"Hmph. What a disappointing result.",false)
        call Text_Say(udg_CinematicActor,"You still have a long way to go.",false)
        set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call RemoveUnit(udg_CinematicActor)
        call Cine_ExitAction()
    endif
    call Quest_Fail(QUEST_TRIAL_BY_FIRE)
    set udg_QuestsTotal=(udg_QuestsTotal-1)
    call Music_ClearTrack(33)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_TrialByFire_Survive_Cond_ShowDialog takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_TrialByFire_Survive_Cond_SpecialHeroInFight takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_E00D_0043,udg_DarkEidolonGroup))or(IsUnitInGroup(gg_unit_H021_0034,udg_DarkEidolonGroup))
endfunction

function Trig_Quest_TrialByFire_Survive_Cond_BonusEarned takes nothing returns boolean
    return(udg_Difficulty>=3)and(Trig_Quest_TrialByFire_Survive_Cond_SpecialHeroInFight())
endfunction

function Trig_Quest_TrialByFire_Survive_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_TrialByFire_Countdown)
    call DestroyTrigger(gg_trg_Quest_TrialByFire_Countdown)
    call DestroyTrigger(gg_trg_Quest_TrialByFire_Fail)
    if(Trig_Quest_TrialByFire_Survive_Cond_ShowDialog())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_ScriptedBossUnit,0)
        call Wait_Polled(1.)
        call Text_Say(udg_ScriptedBossUnit,"Not bad at all.",false)
        call Text_Say(udg_ScriptedBossUnit,"I acknowledge it. You've got quite a bit of potential.",false)
        call Text_Say(udg_ScriptedBossUnit,"We'll meet again. Next time you'll have to do more than dance.",false)
        call Reward_Give(6666,6666,udg_ScriptedBossUnit)
        call Text_Say(udg_ScriptedBossUnit,"See ya.",false)
        set udg_TempPoint=GetUnitLoc(udg_ScriptedBossUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(udg_ScriptedBossUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Reward_Give(6666,6666,udg_ScriptedBossUnit)
    endif
    call KillUnit(udg_ScriptedBossUnit)
    call ShowUnitHide(udg_ScriptedBossUnit)
    set udg_ScriptedBossUnit=null
    call Music_ClearTrack(33)
    call Quest_StepDone(QUEST_TRIAL_BY_FIRE,null,null)
    if(Trig_Quest_TrialByFire_Survive_Cond_BonusEarned())then
        set udg_DarkFireStage=(udg_DarkFireStage+1)
        set udg_QuestsTotal=(udg_QuestsTotal+1)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_TrialByFire takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part15 (module Quest),
// which keeps the original registration order.

function Register_Quest_TrialByFire_Begin takes nothing returns nothing
    set gg_trg_Quest_TrialByFire_Begin=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_TrialByFire_Begin)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Quest_TrialByFire_Begin,Player(8),EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Quest_TrialByFire_Begin,Condition(function Trig_Quest_TrialByFire_Begin_Conditions))
    call TriggerAddAction(gg_trg_Quest_TrialByFire_Begin,function Trig_Quest_TrialByFire_Begin_Actions)
endfunction

function Register_Quest_TrialByFire_Countdown takes nothing returns nothing
    set gg_trg_Quest_TrialByFire_Countdown=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_TrialByFire_Countdown)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_TrialByFire_Countdown,1.)
    call TriggerAddAction(gg_trg_Quest_TrialByFire_Countdown,function Trig_Quest_TrialByFire_Countdown_Actions)
endfunction

function Register_Quest_TrialByFire_Fail takes nothing returns nothing
    set gg_trg_Quest_TrialByFire_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_TrialByFire_Fail)
    call TriggerAddAction(gg_trg_Quest_TrialByFire_Fail,function Trig_Quest_TrialByFire_Fail_Actions)
endfunction

function Register_Quest_TrialByFire_Survive takes nothing returns nothing
    set gg_trg_Quest_TrialByFire_Survive=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_TrialByFire_Survive)
    call TriggerAddAction(gg_trg_Quest_TrialByFire_Survive,function Trig_Quest_TrialByFire_Survive_Actions)
endfunction

endlibrary
