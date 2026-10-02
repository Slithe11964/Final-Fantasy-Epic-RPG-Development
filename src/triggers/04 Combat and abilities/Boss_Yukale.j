library TBossYukale requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Yukale_Death_Revive=null
endglobals

function Trig_Boss_Yukale_Death_Revive_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(2.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLocFacingLocBJ(gg_unit_H00Y_0022,udg_TempPoint,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    call RemoveUnit(GetTriggerUnit())
    call ShowUnitShow(gg_unit_H00Y_0022)
    call PauseUnitBJ(false,gg_unit_H00Y_0022)
    call SetUnitInvulnerable(gg_unit_H00Y_0022,false)
    call GroupAddUnitSimple(gg_unit_H00Y_0022,udg_BossUnits)
    call EnableTrigger(gg_trg_Boss_DarkRanger_Death)
    call Wait_Polled(.5)
    call IssueImmediateOrderBJ(gg_unit_H00Y_0022,"mirrorimage")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Yukale takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part8 (module Boss),
// which keeps the original registration order.

function Register_Boss_Yukale_Death_Revive takes nothing returns nothing
    set gg_trg_Boss_Yukale_Death_Revive=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Yukale_Death_Revive)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Yukale_Death_Revive,gg_unit_H00X_0133,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Yukale_Death_Revive,function Trig_Boss_Yukale_Death_Revive_Actions)
endfunction

endlibrary
