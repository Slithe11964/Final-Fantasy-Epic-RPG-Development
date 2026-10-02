library TSpellWave requires TLoc
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_Wave_Cannon=null
endglobals

function Trig_Spell_Wave_Cannon_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A022') // 'A022': ability "!Wave Cannon"
endfunction

function Trig_Spell_Wave_Cannon_IsCasterHeroCenter takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Wave_Cannon_IsCasterHeroLeft takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Wave_Cannon_IsCasterHeroRight takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Wave_Cannon_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=5
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        // ((loop counter A treated as a decimal-capable number) times (220)) minus (120).
        set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,((I2R(GetForLoopIndexA())*220.)-120.),GetUnitFacing(GetTriggerUnit()))
        call RemoveLocation(udg_TempPoint2)
        call CreateNUnitsAtLoc(1,'u01O',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetUnitFacing(GetTriggerUnit())) // 'u01O': unit "Wave Cannon"
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Orc\\LightningBolt\\LightningBoltMissile.mdl")
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\SpellSteal\\SpellStealMissile.mdl")
        // ((loop counter A) plus (2) treated as a decimal-capable number) times (0.25).
        call UnitApplyTimedLifeBJ((I2R((GetForLoopIndexA()+2))*.25),'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        if(Trig_Spell_Wave_Cannon_IsCasterHeroCenter())then
            call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
        else
            call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
        endif
        // (facing in degrees of the triggering unit) plus (90).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,280.,(GetUnitFacing(GetTriggerUnit())+90.))
        call CreateNUnitsAtLoc(1,'u01O',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetUnitFacing(GetTriggerUnit())) // 'u01O': unit "Wave Cannon"
        call RemoveLocation(udg_TempPoint2)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Orc\\LightningBolt\\LightningBoltMissile.mdl")
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\SpellSteal\\SpellStealMissile.mdl")
        // ((loop counter A) plus (2) treated as a decimal-capable number) times (0.25).
        call UnitApplyTimedLifeBJ((I2R((GetForLoopIndexA()+2))*.25),'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        if(Trig_Spell_Wave_Cannon_IsCasterHeroLeft())then
            call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
        else
            call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
        endif
        // (facing in degrees of the triggering unit) plus (270).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,280.,(GetUnitFacing(GetTriggerUnit())+270.))
        call CreateNUnitsAtLoc(1,'u01O',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,GetUnitFacing(GetTriggerUnit())) // 'u01O': unit "Wave Cannon"
        call RemoveLocation(udg_TempPoint2)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Weapons\\Bolt\\BoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Orc\\LightningBolt\\LightningBoltMissile.mdl")
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Human\\SpellSteal\\SpellStealMissile.mdl")
        // ((loop counter A) plus (2) treated as a decimal-capable number) times (0.25).
        call UnitApplyTimedLifeBJ((I2R((GetForLoopIndexA()+2))*.25),'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        if(Trig_Spell_Wave_Cannon_IsCasterHeroRight())then
            call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
        else
            call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
        endif
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

function InitTrig_Spell_Wave takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Wave_Cannon takes nothing returns nothing
    set gg_trg_Spell_Wave_Cannon=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Wave_Cannon,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Wave_Cannon,Condition(function Trig_Spell_Wave_Cannon_Conditions))
    call TriggerAddAction(gg_trg_Spell_Wave_Cannon,function Trig_Spell_Wave_Cannon_Actions)
endfunction

endlibrary
