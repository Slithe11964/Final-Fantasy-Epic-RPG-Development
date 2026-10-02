library TTransfusion requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Transfusion_Cast=null
endglobals

function Trig_Transfusion_Cast_IsTransfusion takes nothing returns boolean
    return(GetSpellAbilityId()=='A0HY')or(GetSpellAbilityId()=='A0GL') // 'A0HY': ability "Transfusion"; 'A0GL': ability "Transfusion"
endfunction

function Trig_Transfusion_Cast_Conditions takes nothing returns boolean
    return(Trig_Transfusion_Cast_IsTransfusion())
endfunction

function Trig_Transfusion_Cast_WouldKillCaster takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(udg_TempReal>=GetUnitLifePercent(GetTriggerUnit()))
endfunction

function Trig_Transfusion_Cast_IsBahamutZero takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_BahamutZeroSummon)
endfunction

function Trig_Transfusion_Cast_IsNeoBahamut takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_NeoBahamutSummon)
endfunction

function Trig_Transfusion_Cast_IsBahamut takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_BahamutSummon)
endfunction

function Trig_Transfusion_Cast_IsCyclops takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_Eidolon3)
endfunction

function Trig_Transfusion_Cast_IsIfrit takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_Eidolon2)
endfunction

function Trig_Transfusion_Cast_IsShiva takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_Eidolon1)
endfunction

function Trig_Transfusion_Cast_IsGolem takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_GolemSummon)
endfunction

function Trig_Transfusion_Cast_HasNoMana takes nothing returns boolean
    return(BlzGetUnitMaxMana(GetSpellTargetUnit())<=0)
endfunction

function Trig_Transfusion_Cast_NotEmpowered takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0I3',GetSpellTargetUnit())<=0) // 'A0I3': ability "Transfusion Powerup"
endfunction

function Trig_Transfusion_Cast_IsEidolon takes nothing returns boolean
    return((IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_SUMMONED))and(GetUnitAbilityLevelSwapped('A087',GetSpellTargetUnit())>0)and(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO)==false))!=null // 'A087': ability "Solid Skin"
endfunction

function Trig_Transfusion_Cast_Actions takes nothing returns nothing
    if(Trig_Transfusion_Cast_IsEidolon())then
        call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Items\\AIsm\\AIsmTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Items\\AIam\\AIamTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Items\\AIim\\AIimTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
        // missing or its maximum is 0).
        // Result 2: current health divided by maximum health for the spell target, times 100 (or 0 if the unit is
        // missing or its maximum is 0).
        // Result 3: (100) minus (result 2).
        // Result 4: (result 3) divided by (2).
        // Result 5: the smaller of (result 1) and (result 4).
        set udg_TempReal=RMinBJ(GetUnitLifePercent(GetTriggerUnit()),((100.-GetUnitLifePercent(GetSpellTargetUnit()))/ 2.))
        if(Trig_Transfusion_Cast_WouldKillCaster())then
            call SetUnitLifeBJ(GetTriggerUnit(),1.)
        else
            // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
            // missing or its maximum is 0).
            // Result 2: (result 1) minus (udg_TempReal).
            call SetUnitLifePercentBJ(GetTriggerUnit(),(GetUnitLifePercent(GetTriggerUnit())-udg_TempReal))
        endif
        set udg_IsPureDamage=true
        // (udg_TempReal) times ((maximum health of the spell target) divided by (20)).
        call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),(udg_TempReal*(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetSpellTargetUnit())/ 20.)),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
        if(Trig_Transfusion_Cast_NotEmpowered())then
            call UnitAddAbilityBJ('A0I3',GetSpellTargetUnit()) // 'A0I3': ability "Transfusion Powerup"
            // Result 1: BlzGetUnitBaseDamage(the spell target, 0) treated as a decimal-capable number.
            // Result 2: (result 1) times (1.5).
            // Result 3: (result 2) with its decimal part removed.
            call BlzSetUnitBaseDamage(GetSpellTargetUnit(),R2I((I2R(BlzGetUnitBaseDamage(GetSpellTargetUnit(),0))*1.5)),0)
            // Result 1: BlzGetUnitBaseDamage(the spell target, 1) treated as a decimal-capable number.
            // Result 2: (result 1) times (1.5).
            // Result 3: (result 2) with its decimal part removed.
            call BlzSetUnitBaseDamage(GetSpellTargetUnit(),R2I((I2R(BlzGetUnitBaseDamage(GetSpellTargetUnit(),1))*1.5)),1)
            if(Trig_Transfusion_Cast_IsGolem())then
                // (udg_GolemBaseArmor) times (1.5).
                call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_GolemBaseArmor*1.5))
            else
                if(Trig_Transfusion_Cast_IsShiva())then
                    // (udg_ShivaBaseArmor) times (1.5).
                    call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_ShivaBaseArmor*1.5))
                else
                    if(Trig_Transfusion_Cast_IsIfrit())then
                        // (udg_IfritBaseArmor) times (1.5).
                        call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_IfritBaseArmor*1.5))
                    else
                        if(Trig_Transfusion_Cast_IsCyclops())then
                            // (udg_CyclopsBaseArmor) times (1.5).
                            call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_CyclopsBaseArmor*1.5))
                        else
                            if(Trig_Transfusion_Cast_IsBahamut())then
                                // (udg_BahamutBaseArmor) times (1.5).
                                call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_BahamutBaseArmor*1.5))
                            else
                                if(Trig_Transfusion_Cast_IsNeoBahamut())then
                                    // (udg_NeoBahamutBaseArmor) times (1.5).
                                    call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_NeoBahamutBaseArmor*1.5))
                                else
                                    if(Trig_Transfusion_Cast_IsBahamutZero())then
                                        // (udg_BahamutZeroBaseArmor) times (1.5).
                                        call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_BahamutZeroBaseArmor*1.5))
                                    else
                                        // (BlzGetUnitArmor(the spell target)) times (1.5).
                                        call BlzSetUnitArmor(GetSpellTargetUnit(),(BlzGetUnitArmor(GetSpellTargetUnit())*1.5))
                                    endif
                                endif
                            endif
                        endif
                    endif
                endif
            endif
            if(Trig_Transfusion_Cast_HasNoMana())then
                call BlzSetUnitMaxMana(GetSpellTargetUnit(),$3E8) // $3E8 = 1000
                call SetUnitManaPercentBJ(GetSpellTargetUnit(),'d')
            endif
        endif
    else
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000Must target an Eidolon with this skill!|r")
        call DestroyForce(udg_TempForce)
    endif
endfunction

// World Editor calls InitTrig_Transfusion automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Transfusion (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Transfusion takes nothing returns nothing
endfunction

function Register_Transfusion_Cast takes nothing returns nothing
    set gg_trg_Transfusion_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Transfusion_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Transfusion_Cast,Condition(function Trig_Transfusion_Cast_Conditions))
    call TriggerAddAction(gg_trg_Transfusion_Cast,function Trig_Transfusion_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Transfusion takes nothing returns nothing
    call Register_Transfusion_Cast()
endfunction

endlibrary
