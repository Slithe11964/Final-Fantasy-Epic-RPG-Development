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
        set udg_TempReal=RMinBJ(GetUnitLifePercent(GetTriggerUnit()),((100.-GetUnitLifePercent(GetSpellTargetUnit()))/ 2.))
        if(Trig_Transfusion_Cast_WouldKillCaster())then
            call SetUnitLifeBJ(GetTriggerUnit(),1.)
        else
            call SetUnitLifePercentBJ(GetTriggerUnit(),(GetUnitLifePercent(GetTriggerUnit())-udg_TempReal))
        endif
        set udg_IsPureDamage=true
        call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),(udg_TempReal*(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetSpellTargetUnit())/ 20.)),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
        if(Trig_Transfusion_Cast_NotEmpowered())then
            call UnitAddAbilityBJ('A0I3',GetSpellTargetUnit()) // 'A0I3': ability "Transfusion Powerup"
            call BlzSetUnitBaseDamage(GetSpellTargetUnit(),R2I((I2R(BlzGetUnitBaseDamage(GetSpellTargetUnit(),0))*1.5)),0)
            call BlzSetUnitBaseDamage(GetSpellTargetUnit(),R2I((I2R(BlzGetUnitBaseDamage(GetSpellTargetUnit(),1))*1.5)),1)
            if(Trig_Transfusion_Cast_IsGolem())then
                call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_GolemBaseArmor*1.5))
            else
                if(Trig_Transfusion_Cast_IsShiva())then
                    call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_ShivaBaseArmor*1.5))
                else
                    if(Trig_Transfusion_Cast_IsIfrit())then
                        call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_IfritBaseArmor*1.5))
                    else
                        if(Trig_Transfusion_Cast_IsCyclops())then
                            call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_CyclopsBaseArmor*1.5))
                        else
                            if(Trig_Transfusion_Cast_IsBahamut())then
                                call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_BahamutBaseArmor*1.5))
                            else
                                if(Trig_Transfusion_Cast_IsNeoBahamut())then
                                    call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_NeoBahamutBaseArmor*1.5))
                                else
                                    if(Trig_Transfusion_Cast_IsBahamutZero())then
                                        call BlzSetUnitArmor(GetSpellTargetUnit(),(udg_BahamutZeroBaseArmor*1.5))
                                    else
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
