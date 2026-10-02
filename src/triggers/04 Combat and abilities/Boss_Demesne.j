library TBossDemesne requires TBattleLog, TLink, TLoc, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Demesne_CoverSwap=null
    trigger gg_trg_Boss_Demesne_Death_Revive=null
    trigger gg_trg_Boss_Demesne_Revived=null
endglobals

function Trig_Boss_Demesne_CoverSwap_Conditions takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<50.)and(IsUnitAliveBJ(GetTriggerUnit()))
endfunction

function Trig_Boss_Demesne_CoverSwap_Cond_MateusHasNoCover takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0X2',gg_unit_U00L_0207)<=0) // 'A0X2': ability "Perma Cover"
endfunction

function Trig_Boss_Demesne_CoverSwap_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Demesne_CoverSwap_Cond_MateusHasNoCover())then
        call UnitAddAbilityBJ('A0X2',gg_unit_U00M_0206) // 'A0X2': ability "Perma Cover"
        call Link_SaveCaster(gg_unit_U00L_0207,gg_unit_U00M_0206,.0)
    endif
endfunction

function Trig_Boss_Demesne_Death_Revive_Cond_CanCastRaise takes nothing returns boolean
    return(udg_MateusDefeated==false)and(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_Boss_Demesne_Death_Revive_Cond_CanRevive takes nothing returns boolean
    return(udg_MateusDefeated==false)and(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_Boss_Demesne_Death_Revive_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitRemoveAbilityBJ('A0X2',gg_unit_U00L_0207) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',gg_unit_U00L_0207) // 'B064': buff "Perma Cover"
    call Wait_Polled(5.)
    if(Trig_Boss_Demesne_Death_Revive_Cond_CanRevive())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(gg_unit_U00M_0206,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(gg_unit_U00M_0206)
        call SetUnitInvulnerable(gg_unit_U00M_0206,true)
        call Wait_Polled(10.)
        if(Trig_Boss_Demesne_Death_Revive_Cond_CanCastRaise())then
            call UnitAddAbilityBJ('A12C',gg_unit_U00L_0207) // 'A12C': ability "!Raise"
            call IssueImmediateOrderBJ(gg_unit_U00L_0207,"stomp")
            call EnableTrigger(gg_trg_Boss_Demesne_Revived)
        endif
    endif
endfunction

function Trig_Boss_Demesne_Revived_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A12C')and(IsQuestDiscovered(udg_MainQuest[20])==false) // 'A12C': ability "!Raise"
endfunction

function Trig_Boss_Demesne_Revived_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call BattleLog_ShowUnit("is revived.",gg_unit_U00M_0206)
    call ShowUnitShow(gg_unit_U00M_0206)
    call SetUnitInvulnerable(gg_unit_U00M_0206,false)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,GetUnitFacing(GetTriggerUnit()))
    call RemoveLocation(udg_TempPoint)
    call SetUnitPositionLocFacingBJ(gg_unit_U00M_0206,udg_TempPoint2,GetUnitFacing(GetTriggerUnit()))
    call RemoveLocation(udg_TempPoint2)
    call SetUnitLifePercentBJ(gg_unit_U00M_0206,25.)
    call SetUnitManaPercentBJ(gg_unit_U00M_0206,.0)
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00M_0206,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitAddAbilityBJ('A0X2',gg_unit_U00L_0207) // 'A0X2': ability "Perma Cover"
    call Link_SaveCaster(gg_unit_U00M_0206,gg_unit_U00L_0207,.0)
    call EnableTrigger(gg_trg_Boss_Demesne_Death_Revive)
    call Wait_Polled(1.)
    call UnitRemoveAbilityBJ('A12C',gg_unit_U00L_0207) // 'A12C': ability "!Raise"
endfunction

function InitTrig_Boss_Demesne takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part5, RegisterTriggers_Boss_Part6 (module Boss),
// which keeps the original registration order.

function Register_Boss_Demesne_CoverSwap takes nothing returns nothing
    set gg_trg_Boss_Demesne_CoverSwap=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Demesne_CoverSwap)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Demesne_CoverSwap,gg_unit_U00M_0206,EVENT_UNIT_DAMAGED)
    call TriggerAddCondition(gg_trg_Boss_Demesne_CoverSwap,Condition(function Trig_Boss_Demesne_CoverSwap_Conditions))
    call TriggerAddAction(gg_trg_Boss_Demesne_CoverSwap,function Trig_Boss_Demesne_CoverSwap_Actions)
endfunction

function Register_Boss_Demesne_Death_Revive takes nothing returns nothing
    set gg_trg_Boss_Demesne_Death_Revive=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Demesne_Death_Revive)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Demesne_Death_Revive,gg_unit_U00M_0206,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Demesne_Death_Revive,function Trig_Boss_Demesne_Death_Revive_Actions)
endfunction

function Register_Boss_Demesne_Revived takes nothing returns nothing
    set gg_trg_Boss_Demesne_Revived=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Demesne_Revived)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Demesne_Revived,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boss_Demesne_Revived,Condition(function Trig_Boss_Demesne_Revived_Conditions))
    call TriggerAddAction(gg_trg_Boss_Demesne_Revived,function Trig_Boss_Demesne_Revived_Actions)
endfunction

endlibrary
