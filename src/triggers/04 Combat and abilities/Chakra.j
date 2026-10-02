library TChakra requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chakra_Cast=null
endglobals

function Trig_Chakra_Cast_IsChakra takes nothing returns boolean
    return(GetSpellAbilityId()=='A01M')or(GetSpellAbilityId()=='A0O8') // 'A01M': ability "Chakra"; 'A0O8': ability "Chakra"
endfunction

function Trig_Chakra_Cast_Conditions takes nothing returns boolean
    return(Trig_Chakra_Cast_IsChakra())
endfunction

function Trig_Chakra_Cast_IsMaxLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A01M',GetTriggerUnit())>=$B) // 'A01M': ability "Chakra"; $B = 11
endfunction

function Trig_Chakra_Cast_NoChakraLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A01M',GetTriggerUnit())<=0) // 'A01M': ability "Chakra"
endfunction

function Trig_Chakra_Cast_NegatesHeals takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',udg_TempUnit2)>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Chakra_Cast_Actions takes nothing returns nothing
    local unit targetUnit
    set targetUnit=GetSpellTargetUnit()
    call Wait_Polled(1.)
    set udg_DispelTarget=targetUnit
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    if(Trig_Chakra_Cast_NegatesHeals())then
        call AddSpecialEffectTargetUnitBJ("overhead",targetUnit,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    else
        if(Trig_Chakra_Cast_NoChakraLevel())then
            set udg_TempInteger=8
        else
            if(Trig_Chakra_Cast_IsMaxLevel())then
                set udg_TempInteger=$F // $F = 15
            else
                // (GetUnitAbilityLevelSwapped('A01M', the triggering unit)) plus (2).
                set udg_TempInteger=(GetUnitAbilityLevelSwapped('A01M',GetTriggerUnit())+2) // 'A01M': ability "Chakra"
            endif
        endif
        // Result 1: (unit level of targetUnit) times (3).
        // Result 2: the larger of (result 1) and (Strength of targetUnit).
        // Result 3: (result 2) plus (300).
        // Result 4: (result 3) times (udg_TempInteger).
        set udg_TempInteger=((IMaxBJ((GetUnitLevel(targetUnit)*3),GetHeroStatBJ(bj_HEROSTAT_STR,targetUnit,true))+300)*udg_TempInteger)
        // (udg_TempInteger) divided by (2); drop the remainder.
        set udg_TempInteger=(udg_TempInteger/ 2)
        set udg_IsPureDamage=true
        set udg_DmgFlagManaDamage=true
        // (udg_TempInteger treated as a decimal-capable number) times (0.25).
        call UnitDamageTargetBJ(GetTriggerUnit(),targetUnit,(I2R(udg_TempInteger)*.25),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
        set udg_IsPureDamage=true
        // Udg_TempInteger treated as a decimal-capable number.
        call UnitDamageTargetBJ(GetTriggerUnit(),targetUnit,I2R(udg_TempInteger),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    endif
endfunction

// World Editor calls InitTrig_Chakra automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Chakra (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Chakra takes nothing returns nothing
endfunction

function Register_Chakra_Cast takes nothing returns nothing
    set gg_trg_Chakra_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chakra_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chakra_Cast,Condition(function Trig_Chakra_Cast_Conditions))
    call TriggerAddAction(gg_trg_Chakra_Cast,function Trig_Chakra_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Chakra takes nothing returns nothing
    call Register_Chakra_Cast()
endfunction

endlibrary
