library TShadowLoyalty
function Trig_Shadow_LoyaltyTick_Conditions takes nothing returns boolean
    return(udg_ShadowUnit!=null)and(GetOwningPlayer(udg_ShadowUnit)==Player($A)) // $A = 10
endfunction

function Trig_Shadow_LoyaltyTick_IsLifeUnder70 takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_ShadowUnit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_ShadowUnit)<=70.)
endfunction

function Trig_Shadow_LoyaltyTick_IsLifeUnder50 takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_ShadowUnit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_ShadowUnit)<=50.)
endfunction

function Trig_Shadow_LoyaltyTick_IsLifeUnder25 takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_ShadowUnit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_ShadowUnit)<=25.)
endfunction

function Trig_Shadow_LoyaltyTick_IsLifeOver85 takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_ShadowUnit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_ShadowUnit)>=85.)
endfunction

function Trig_Shadow_LoyaltyTick_IsLoyaltyBelowQuestFloor takes nothing returns boolean
    return(udg_ShadowLoyalty<'d')and(IsQuestCompleted(udg_SideQuest[44]))
endfunction

function Trig_Shadow_LoyaltyTick_Actions takes nothing returns nothing
    if(Trig_Shadow_LoyaltyTick_IsLifeOver85())then
        set udg_ShadowLoyalty=(udg_ShadowLoyalty+1)
    else
        if(Trig_Shadow_LoyaltyTick_IsLifeUnder25())then
            // Decrease udg_ShadowLoyalty by 5.
            set udg_ShadowLoyalty=(udg_ShadowLoyalty-5)
        else
            if(Trig_Shadow_LoyaltyTick_IsLifeUnder50())then
                // Decrease udg_ShadowLoyalty by 3.
                set udg_ShadowLoyalty=(udg_ShadowLoyalty-3)
            else
                if(Trig_Shadow_LoyaltyTick_IsLifeUnder70())then
                    set udg_ShadowLoyalty=(udg_ShadowLoyalty-1)
                endif
            endif
        endif
    endif
    if(Trig_Shadow_LoyaltyTick_IsLoyaltyBelowQuestFloor())then
        set udg_ShadowLoyalty='d'
    endif
    call ConditionalTriggerExecute(gg_trg_Shadow_Disband)
endfunction

function Trig_Shadow_KillCount_Conditions takes nothing returns boolean
    return(GetKillingUnitBJ()==udg_ShadowUnit)
endfunction

function Trig_Shadow_KillCount_IsHeroKill takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Shadow_KillCount_Actions takes nothing returns nothing
    set udg_ShadowKills=(udg_ShadowKills+1)
    if(Trig_Shadow_KillCount_IsHeroKill())then
        // Increase udg_ShadowLoyalty by 3.
        set udg_ShadowLoyalty=(udg_ShadowLoyalty+3)
    endif
endfunction

function Trig_Shadow_AttackedByParty_IsAboveLoyaltyFloor takes nothing returns boolean
    return(udg_ShadowLoyalty>'d')or(IsQuestCompleted(udg_SideQuest[44])==false)
endfunction

function Trig_Shadow_AttackedByParty_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetAttacker()),udg_PlayingPlayers))and(GetTriggerUnit()==udg_ShadowUnit)and(Trig_Shadow_AttackedByParty_IsAboveLoyaltyFloor())
endfunction

function Trig_Shadow_AttackedByParty_Actions takes nothing returns nothing
    set udg_ShadowLoyalty=(udg_ShadowLoyalty-1)
endfunction

function Trig_Shadow_HealedBonus_IsHealingSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A00M')or(GetSpellAbilityId()=='A04O')or(GetSpellAbilityId()=='A01M')or(GetSpellAbilityId()=='A00L')or(GetSpellAbilityId()=='A171')or(GetSpellAbilityId()=='A14X')or(GetSpellAbilityId()=='A14W')or(GetSpellAbilityId()=='A14V')or(GetSpellAbilityId()=='A14U')or(GetSpellAbilityId()=='A0KZ')or(GetSpellAbilityId()=='A0L0')or(GetSpellAbilityId()=='A0FN') // 'A00M': ability "Cure"; 'A04O': ability "Curaga"; 'A01M': ability "Chakra"; 'A00L': ability "Regen"; 'A171': ability "Spell Shot"; 'A14X': ability "Toss Potion"; 'A14W': ability "Toss Hi-Potion"; 'A14V': ability "Toss Mega Potion"; 'A14U': ability "Toss X-Potion"; 'A0KZ': ability "Toss Nectar"; 'A0L0': ability "Toss Greater Nectar"; 'A0FN': ability "Toss Elixir"
endfunction

function Trig_Shadow_HealedBonus_Conditions takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_ShadowUnit)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(Trig_Shadow_HealedBonus_IsHealingSpell())
endfunction

function Trig_Shadow_HealedBonus_IsHealLifeUnder90 takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_ShadowUnit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_ShadowUnit)<=90.)
endfunction

function Trig_Shadow_HealedBonus_IsHealLifeUnder80 takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_ShadowUnit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_ShadowUnit)<=80.)
endfunction

function Trig_Shadow_HealedBonus_IsHealLifeUnder50 takes nothing returns boolean
    // Result 1: current health divided by maximum health for udg_ShadowUnit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(udg_ShadowUnit)<=50.)
endfunction

function Trig_Shadow_HealedBonus_IsWastedHeal takes nothing returns boolean
    return(UnitHasBuffBJ(GetSpellTargetUnit(),'B05T'))and(GetSpellAbilityId()!='A01M') // 'B05T': buff tooltip "Zombie"; 'A01M': ability "Chakra"
endfunction

function Trig_Shadow_HealedBonus_Actions takes nothing returns nothing
    if(Trig_Shadow_HealedBonus_IsWastedHeal())then
        // Decrease udg_ShadowLoyalty by 5.
        set udg_ShadowLoyalty=(udg_ShadowLoyalty-5)
    else
        if(Trig_Shadow_HealedBonus_IsHealLifeUnder50())then
            // Increase udg_ShadowLoyalty by 5.
            set udg_ShadowLoyalty=(udg_ShadowLoyalty+5)
        else
            if(Trig_Shadow_HealedBonus_IsHealLifeUnder80())then
                // Increase udg_ShadowLoyalty by 3.
                set udg_ShadowLoyalty=(udg_ShadowLoyalty+3)
            else
                if(Trig_Shadow_HealedBonus_IsHealLifeUnder90())then
                    // Increase udg_ShadowLoyalty by 2.
                    set udg_ShadowLoyalty=(udg_ShadowLoyalty+2)
                else
                    set udg_ShadowLoyalty=(udg_ShadowLoyalty+1)
                endif
            endif
        endif
    endif
endfunction

function InitTrig_Shadow_Loyalty takes nothing returns nothing
endfunction

endlibrary
