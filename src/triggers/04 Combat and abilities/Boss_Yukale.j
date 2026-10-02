library TBossYukale requires TWait
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

endlibrary
