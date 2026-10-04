library TQuestKillSetag requires TQuestEngine, TCam, TCine, TReward, TText, TUnit, TWait
// Side quest "Kill Setag", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Archwizard Halaster asks the party to help him kill the warlock Setag; he teleports to the party when they
// attack Setag, and the quest fails if he dies. Made available by Cid and Epilogue, which run
// gg_trg_Quest_KillSetag_Offer.
// The ambush and the fight (Setag revived during cinematics, Halaster teleporting away) stay triggers of this
// module; Setag's death finishes the quest (custom step).
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_KillSetag_Hide=null
    trigger gg_trg_Quest_KillSetag_Offer=null
    trigger gg_trg_Quest_KillSetag_Ambush=null
    trigger gg_trg_Quest_KillSetag_Failed=null
    trigger gg_trg_Quest_KillSetag_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_KILL_SETAG=0
endglobals

function Trig_Quest_KillSetag_Hide_Actions takes nothing returns nothing
    call PauseUnitBJ(true,gg_unit_Hant_0059)
    call UnitAddAbilityBJ('A0VJ',gg_unit_Hant_0059) // 'A0VJ': ability "Unaffected by Cinematics"
    call ShowUnitHide(gg_unit_uabo_0061)
    call PauseUnitBJ(true,gg_unit_uabo_0061)
    call ShowUnitHide(gg_unit_uabo_0062)
    call PauseUnitBJ(true,gg_unit_uabo_0062)
    call ShowUnitHide(gg_unit_uabo_0002)
    call PauseUnitBJ(true,gg_unit_uabo_0002)
    call ShowUnitHide(gg_unit_Hgam_0060)
    call SetUnitInvulnerable(gg_unit_Hgam_0060,true)
    call PauseUnitBJ(true,gg_unit_Hgam_0060)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Step 1 done (the party talked to Halaster): Setag and his abominations appear, and the information shop
// sells a hint.
function QuestKillSetag_Started takes nothing returns nothing
    call ShowUnitShow(gg_unit_Hgam_0060)
    call PauseUnitBJ(false,gg_unit_Hgam_0060)
    call SetUnitInvulnerable(gg_unit_Hgam_0060,false)
    call GroupAddUnitSimple(gg_unit_Hgam_0060,udg_BossUnits)
    call ShowUnitShow(gg_unit_uabo_0061)
    call PauseUnitBJ(false,gg_unit_uabo_0061)
    call ShowUnitShow(gg_unit_uabo_0062)
    call PauseUnitBJ(false,gg_unit_uabo_0062)
    call ShowUnitShow(gg_unit_uabo_0002)
    call PauseUnitBJ(false,gg_unit_uabo_0002)
    call EnableTrigger(gg_trg_Quest_KillSetag_Ambush)
    call EnableTrigger(gg_trg_Quest_KillSetag_Failed)
    call EnableTrigger(gg_trg_Quest_KillSetag_Complete)
    call AddItemToStockBJ('I04Y',gg_unit_n02Y_0052,1,1) // 'I04Y': item "Information: Setag"
endfunction

function QuestKillSetag_Define takes nothing returns nothing
    local integer q=Quest_Define("Kill Setag",QUEST_SIDE,3,"ReplaceableTextures\\CommandButtons\\BTNAcolyte.blp")
    set QUEST_KILL_SETAG=q
    // 1. Talk to Halaster
    call Quest_Talk(q,gg_unit_Hant_0059,"Archwizard Halaster asked you to help him in defeating evil warlock named Setag.")
    call Quest_Say(q,gg_unit_Hant_0059,"I greet you. My name is Halaster. I am the Archwizard of Gransdale Castle. I traveled to this world in order to find evil warlock Setag who killed king Leoric in my homeworld.")
    call Quest_Say(q,gg_unit_Hant_0059,"I swore to avenge my king, but Setag escaped into this world. I followed him and finaly overtook him. We engaged in a magic duel and I was close to victory when something totally unexpected happened - some abominable monsters came to help Setag and I had to retreat.")
    call Quest_Say(q,gg_unit_Hant_0059,"I used my magic to locate him but he is now guarded by those monsters and my magic skills are simply not enough to fight all of them at once. However, if you help me, together we will be able to defeat him.")
    call Quest_Say(q,null,"Will you join us now?")
    call Quest_Say(q,gg_unit_Hant_0059,"No, but when you encounter Setag and attack him I will immediately teleport to your position and together we will be able to defeat him.")
    call Quest_OnDone(q,"QuestKillSetag_Started")
    // 2. Kill Setag (gg_trg_Quest_KillSetag_Complete); fails if Halaster dies (gg_trg_Quest_KillSetag_Failed)
    call Quest_Custom(q,"")
endfunction

// Halaster is ready: the quest can be accepted from him.
function Trig_Quest_KillSetag_Offer_Actions takes nothing returns nothing
    call Unit_ScaleToLevel60(gg_unit_Hant_0059)
    if QUEST_KILL_SETAG==0 then
        call QuestKillSetag_Define()
    endif
    call Quest_MakeAvailable(QUEST_KILL_SETAG)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillSetag_Ambush_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)
endfunction

function Trig_Quest_KillSetag_Ambush_WasAttacked takes nothing returns boolean
    return(GetAttacker()!=null)
endfunction

function Trig_Quest_KillSetag_Ambush_CinematicsOnAmbush takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_KillSetag_Ambush_EternityMode takes nothing returns boolean
    return(udg_EternityMode)
endfunction

// Setag or a guard was attacked: Halaster teleports in, and four more abominations join the fight.
function Trig_Quest_KillSetag_Ambush_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetUnitInvulnerable(gg_unit_Hant_0059,false)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_Hant_0059) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(false,gg_unit_Hant_0059)
    if(Trig_Quest_KillSetag_Ambush_WasAttacked())then
        set udg_TempPoint=GetUnitLoc(GetAttacker())
    else
        call BlzSetEventDamage(.0)
        set udg_TempPoint=GetUnitLoc(GetEventDamageSource())
    endif
    call SetUnitPositionLocFacingBJ(gg_unit_Hant_0059,udg_TempPoint,bj_UNIT_FACING)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call SetUnitInvulnerable(gg_unit_Hgam_0060,true)
    if(Trig_Quest_KillSetag_Ambush_CinematicsOnAmbush())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Hant_0059,0)
        call Text_Say(gg_unit_Hant_0059,"Setag !!! Now you will not escape ! You will pay for your crimes !",false)
        call Cam_PanToUnit(gg_unit_Hgam_0060,.5)
        call Text_Say(gg_unit_Hgam_0060,"You again, old man. If my memory serves me right it was you who escaped last time we met. Nevertheless, your death is near. And your puny allies will not help you. Prepare to die, Halaster.",false)
        call Cine_ExitAction()
    endif
    call SetUnitInvulnerable(gg_unit_Hgam_0060,false)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetUnitLoc(gg_unit_Hgam_0060)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,300.,300.)
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,'uabo',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'uabo': object name not found in map data; $B = 11
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Quest_KillSetag_Ambush_EternityMode())then
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        else
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)/ 2),(1-1))
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)/ 2),1)
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())/ 2))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        endif
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"attack",GetAttacker())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveItemFromStockBJ('I04Y',gg_unit_n02Y_0052) // 'I04Y': item "Information: Setag"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Halaster died: the quest fails.
function Trig_Quest_KillSetag_Failed_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTextToForce(GetPlayersAll(),"Halaster is dead.")
    call Quest_Fail(QUEST_KILL_SETAG)
    set udg_QuestsTotal=(udg_QuestsTotal-1)
    call GroupRemoveUnitSimple(gg_unit_Hgam_0060,udg_BossUnits)
    call DisableTrigger(gg_trg_Quest_KillSetag_Complete)
    call DestroyTrigger(gg_trg_Quest_KillSetag_Complete)
    call SaveIntegerBJ(1,2,99,udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillSetag_Complete_Cond_CinematicRunning takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Quest_KillSetag_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 2: Setag died. During a cinematic he comes back to life; otherwise Halaster rewards the party and
// teleports away.
function Trig_Quest_KillSetag_Complete_Actions takes nothing returns nothing
    local unit l_killer=GetKillingUnitBJ()
    if(Trig_Quest_KillSetag_Complete_Cond_CinematicRunning())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(gg_unit_Hgam_0060,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitLifeBJ(GetTriggerUnit(),10.)
        set l_killer=null
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_Hgam_0060,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I02R',udg_TempPoint) // 'I02R': item "Headgear of the Damned"
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(gg_unit_Hant_0059,true)
    if(Trig_Quest_KillSetag_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Hant_0059,0)
        call Text_Say(gg_unit_Hant_0059,"Thank you, my friends for helping me in this difficult task. As I promised, I will reward you greatly.",false)
        call Reward_Give($7D0,$5DC,gg_unit_Hant_0059) // $7D0 = 2000; $5DC = 1500
        call Text_Say(gg_unit_Hant_0059,"Thank you once again and good bye.",false)
        call SetUnitAnimation(gg_unit_Hant_0059,"stand channel")
        set udg_SpecialEffect[7]=AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_Hant_0059),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl")
        call Wait_Polled(2.)
        call DestroyEffectBJ(udg_SpecialEffect[7])
        call AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_Hant_0059),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveUnit(gg_unit_Hant_0059)
        call Wait_Polled(1.5)
        call Cine_ExitAction()
    else
        call Reward_Give($7D0,$5DC,gg_unit_Hant_0059) // $7D0 = 2000; $5DC = 1500
        call RemoveUnit(gg_unit_Hant_0059)
    endif
    call DestroyTrigger(gg_trg_Quest_KillSetag_Failed)
    call Quest_StepDone(QUEST_KILL_SETAG,GetOwningPlayer(l_killer),l_killer)
    call SaveIntegerBJ(1,2,99,udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_killer=null
endfunction

function InitTrig_Quest_KillSetag takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_KillSetag_Hide takes nothing returns nothing
    set gg_trg_Quest_KillSetag_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_Quest_KillSetag_Hide,function Trig_Quest_KillSetag_Hide_Actions)
endfunction

function Register_Quest_KillSetag_Offer takes nothing returns nothing
    set gg_trg_Quest_KillSetag_Offer=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillSetag_Offer)
    call TriggerAddAction(gg_trg_Quest_KillSetag_Offer,function Trig_Quest_KillSetag_Offer_Actions)
endfunction

function Register_Quest_KillSetag_Ambush takes nothing returns nothing
    set gg_trg_Quest_KillSetag_Ambush=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillSetag_Ambush)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_Hgam_0060,EVENT_UNIT_DAMAGED)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_Hgam_0060,EVENT_UNIT_ATTACKED)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_uabo_0061,EVENT_UNIT_ATTACKED)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_uabo_0062,EVENT_UNIT_ATTACKED)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Ambush,gg_unit_uabo_0002,EVENT_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Quest_KillSetag_Ambush,Condition(function Trig_Quest_KillSetag_Ambush_Conditions))
    call TriggerAddAction(gg_trg_Quest_KillSetag_Ambush,function Trig_Quest_KillSetag_Ambush_Actions)
endfunction

function Register_Quest_KillSetag_Failed takes nothing returns nothing
    set gg_trg_Quest_KillSetag_Failed=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillSetag_Failed)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Failed,gg_unit_Hant_0059,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_KillSetag_Failed,function Trig_Quest_KillSetag_Failed_Actions)
endfunction

function Register_Quest_KillSetag_Complete takes nothing returns nothing
    set gg_trg_Quest_KillSetag_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_KillSetag_Complete)
    call TriggerRegisterUnitEvent(gg_trg_Quest_KillSetag_Complete,gg_unit_Hgam_0060,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_KillSetag_Complete,function Trig_Quest_KillSetag_Complete_Actions)
endfunction

endlibrary
