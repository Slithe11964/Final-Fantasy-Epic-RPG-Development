library TToss requires TMedicine
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Toss_Potion=null
    trigger gg_trg_Toss_HeroDrink=null
endglobals

function Trig_Toss_Potion_IsTossAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A14X')or(GetSpellAbilityId()=='A14W')or(GetSpellAbilityId()=='A14V')or(GetSpellAbilityId()=='A14U')or(GetSpellAbilityId()=='A0KZ')or(GetSpellAbilityId()=='A0L0')or(GetSpellAbilityId()=='A0G5')or(GetSpellAbilityId()=='A0G3')or(GetSpellAbilityId()=='A0G1')or(GetSpellAbilityId()=='A0FY')or(GetSpellAbilityId()=='A0FN')or(GetSpellAbilityId()=='A0FZ')or(GetSpellAbilityId()=='A0KA')or(GetSpellAbilityId()=='A0DZ') // 'A14X': ability "Toss Potion"; 'A14W': ability "Toss Hi-Potion"; 'A14V': ability "Toss Mega Potion"; 'A14U': ability "Toss X-Potion"; 'A0KZ': ability "Toss Nectar"; 'A0L0': ability "Toss Greater Nectar"; 'A0G5': ability "Toss Ether"; 'A0G3': ability "Toss Hi-Ether"; 'A0G1': ability "Toss Mega Ether"; 'A0FY': ability "Toss Turbo Ether"; 'A0FN': ability "Toss Elixir"; 'A0FZ': ability "Toss Hero Drink"; 'A0KA': ability "!Elixir"; 'A0DZ': ability "!Toss Elixir"
endfunction

function Trig_Toss_Potion_Conditions takes nothing returns boolean
    return(Trig_Toss_Potion_IsTossAbility())
endfunction

function Trig_Toss_Potion_NoTarget takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Toss_Potion_PharmaCleanseToss takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0HL',GetTriggerUnit())>=1) // 'A0HL': ability "Pharmacology"
endfunction

function Trig_Toss_Potion_IsTossTier4 takes nothing returns boolean
    return(GetSpellAbilityId()=='A14U')or(GetSpellAbilityId()=='A0FY')or(GetSpellAbilityId()=='A0L0') // 'A14U': ability "Toss X-Potion"; 'A0FY': ability "Toss Turbo Ether"; 'A0L0': ability "Toss Greater Nectar"
endfunction

function Trig_Toss_Potion_Cond_TossTier4 takes nothing returns boolean
    return(Trig_Toss_Potion_IsTossTier4())
endfunction

function Trig_Toss_Potion_IsTossTier3 takes nothing returns boolean
    return(GetSpellAbilityId()=='A14V')or(GetSpellAbilityId()=='A0G1')or(GetSpellAbilityId()=='A0KZ') // 'A14V': ability "Toss Mega Potion"; 'A0G1': ability "Toss Mega Ether"; 'A0KZ': ability "Toss Nectar"
endfunction

function Trig_Toss_Potion_Cond_TossTier3 takes nothing returns boolean
    return(Trig_Toss_Potion_IsTossTier3())
endfunction

function Trig_Toss_Potion_IsTossTier2 takes nothing returns boolean
    return(GetSpellAbilityId()=='A14W')or(GetSpellAbilityId()=='A0G3') // 'A14W': ability "Toss Hi-Potion"; 'A0G3': ability "Toss Hi-Ether"
endfunction

function Trig_Toss_Potion_Cond_TossTier2 takes nothing returns boolean
    return(Trig_Toss_Potion_IsTossTier2())
endfunction

function Trig_Toss_Potion_IsTossTier1 takes nothing returns boolean
    return(GetSpellAbilityId()=='A14X')or(GetSpellAbilityId()=='A0G5') // 'A14X': ability "Toss Potion"; 'A0G5': ability "Toss Ether"
endfunction

function Trig_Toss_Potion_Cond_TossTier1 takes nothing returns boolean
    return(Trig_Toss_Potion_IsTossTier1())
endfunction

function Trig_Toss_Potion_HasPharmaBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0HL',GetTriggerUnit())>=1) // 'A0HL': ability "Pharmacology"
endfunction

function Trig_Toss_Potion_IsTossMana takes nothing returns boolean
    return(GetSpellAbilityId()=='A0G5')or(GetSpellAbilityId()=='A0G3')or(GetSpellAbilityId()=='A0G1')or(GetSpellAbilityId()=='A0FY')or(GetSpellAbilityId()=='A0KZ')or(GetSpellAbilityId()=='A0L0') // 'A0G5': ability "Toss Ether"; 'A0G3': ability "Toss Hi-Ether"; 'A0G1': ability "Toss Mega Ether"; 'A0FY': ability "Toss Turbo Ether"; 'A0KZ': ability "Toss Nectar"; 'A0L0': ability "Toss Greater Nectar"
endfunction

function Trig_Toss_Potion_Cond_TossMana takes nothing returns boolean
    return(Trig_Toss_Potion_IsTossMana())
endfunction

function Trig_Toss_Potion_IsTossLife takes nothing returns boolean
    return(GetSpellAbilityId()=='A14X')or(GetSpellAbilityId()=='A14W')or(GetSpellAbilityId()=='A14V')or(GetSpellAbilityId()=='A14U')or(GetSpellAbilityId()=='A0KZ')or(GetSpellAbilityId()=='A0L0') // 'A14X': ability "Toss Potion"; 'A14W': ability "Toss Hi-Potion"; 'A14V': ability "Toss Mega Potion"; 'A14U': ability "Toss X-Potion"; 'A0KZ': ability "Toss Nectar"; 'A0L0': ability "Toss Greater Nectar"
endfunction

function Trig_Toss_Potion_Cond_TossLife takes nothing returns boolean
    return(Trig_Toss_Potion_IsTossLife())
endfunction

function Trig_Toss_Potion_IsTossElixir takes nothing returns boolean
    return(GetSpellAbilityId()=='A0FN')or(GetSpellAbilityId()=='A0KA')or(GetSpellAbilityId()=='A0DZ') // 'A0FN': ability "Toss Elixir"; 'A0KA': ability "!Elixir"; 'A0DZ': ability "!Toss Elixir"
endfunction

function Trig_Toss_Potion_Cond_TossElixir takes nothing returns boolean
    return(Trig_Toss_Potion_IsTossElixir())
endfunction

function Trig_Toss_Potion_TargetNegatesHeal takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',udg_TempUnit2)>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Toss_Potion_Actions takes nothing returns nothing
    if(Trig_Toss_Potion_NoTarget())then
        set udg_TempUnit2=GetTriggerUnit()
    else
        set udg_TempUnit2=GetSpellTargetUnit()
    endif
    if(Trig_Toss_Potion_PharmaCleanseToss())then
        set udg_DispelTarget=udg_TempUnit2
        call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    endif
    if(Trig_Toss_Potion_TargetNegatesHeal())then
        call AddSpecialEffectTargetUnitBJ("overhead",udg_TempUnit2,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    else
        if(Trig_Toss_Potion_Cond_TossElixir())then
            call AddSpecialEffectTargetUnitBJ("origin",udg_TempUnit2,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set udg_DmgFlagPure=true
            set udg_DmgFlagUnavoidable=-1
            set udg_IsPureDamage=true
            set udg_DmgFlagManaDamage=true
            call UnitDamageTargetBJ(GetTriggerUnit(),udg_TempUnit2,6666666.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            set udg_DmgFlagPure=true
            set udg_DmgFlagUnavoidable=-1
            set udg_IsPureDamage=true
            call UnitDamageTargetBJ(GetTriggerUnit(),udg_TempUnit2,6666666.,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
        else
            set udg_TempInteger=0
            if(Trig_Toss_Potion_Cond_TossTier1())then
                set udg_TempInteger=400
            else
                if(Trig_Toss_Potion_Cond_TossTier2())then
                    set udg_TempInteger=$3E8 // $3E8 = 1000
                else
                    if(Trig_Toss_Potion_Cond_TossTier3())then
                        set udg_TempInteger=$9C4 // $9C4 = 2500
                    else
                        if(Trig_Toss_Potion_Cond_TossTier4())then
                            set udg_TempInteger=6000
                        endif
                    endif
                endif
            endif
            if(Trig_Toss_Potion_HasPharmaBonus())then
                // ((udg_TempInteger) times (3)) divided by (2); drop the remainder.
                set udg_TempInteger=((udg_TempInteger*3)/ 2)
            endif
            if(Trig_Toss_Potion_Cond_TossMana())then
                call AddSpecialEffectTargetUnitBJ("origin",udg_TempUnit2,"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                set udg_DmgFlagPure=true
                set udg_DmgFlagUnavoidable=-1
                set udg_IsPureDamage=true
                set udg_DmgFlagManaDamage=true
                // (udg_TempInteger) divided by (2); drop the remainder treated as a decimal-capable number.
                call UnitDamageTargetBJ(GetTriggerUnit(),udg_TempUnit2,I2R((udg_TempInteger/ 2)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            endif
            if(Trig_Toss_Potion_Cond_TossLife())then
                call AddSpecialEffectTargetUnitBJ("origin",udg_TempUnit2,"Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                set udg_DmgFlagPure=true
                set udg_DmgFlagUnavoidable=-1
                set udg_IsPureDamage=true
                // Udg_TempInteger treated as a decimal-capable number.
                call UnitDamageTargetBJ(GetTriggerUnit(),udg_TempUnit2,I2R(udg_TempInteger),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            endif
        endif
    endif
endfunction

function Trig_Toss_HeroDrink_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0FZ') // 'A0FZ': ability "Toss Hero Drink"
endfunction

function Trig_Toss_HeroDrink_Actions takes nothing returns nothing
    call Medicine_ApplyTimed(GetSpellTargetUnit(),(GetUnitAbilityLevel(GetTriggerUnit(),'A0HL')>0)) // 'A0HL': ability "Pharmacology"
endfunction

// World Editor calls InitTrig_Toss automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Toss (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Toss takes nothing returns nothing
endfunction

function Register_Toss_Potion takes nothing returns nothing
    set gg_trg_Toss_Potion=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Toss_Potion,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Toss_Potion,Condition(function Trig_Toss_Potion_Conditions))
    call TriggerAddAction(gg_trg_Toss_Potion,function Trig_Toss_Potion_Actions)
endfunction

function Register_Toss_HeroDrink takes nothing returns nothing
    set gg_trg_Toss_HeroDrink=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Toss_HeroDrink,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Toss_HeroDrink,Condition(function Trig_Toss_HeroDrink_Conditions))
    call TriggerAddAction(gg_trg_Toss_HeroDrink,function Trig_Toss_HeroDrink_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Toss takes nothing returns nothing
    call Register_Toss_Potion()
    call Register_Toss_HeroDrink()
endfunction

endlibrary
