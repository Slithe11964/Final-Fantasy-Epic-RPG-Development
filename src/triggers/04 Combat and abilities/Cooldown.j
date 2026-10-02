library TCooldown requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Cooldown_Scaling=null
endglobals

function Trig_Cooldown_Scaling_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetTriggerUnit())<=0)and(GetSpellAbilityId()!='A0S8')and(GetSpellAbilityId()!='A0S9')and(GetSpellAbilityId()!='A0SB')and(GetSpellAbilityId()!='A0SC')and(GetSpellAbilityId()!='A0SD')and(GetSpellAbilityId()!='A0SE')and(GetSpellAbilityId()!='A0R3')and(GetSpellAbilityId()!='A00Q')and(GetSpellAbilityId()!='A0Z2')and(GetSpellAbilityId()!='A197')and(GetSpellAbilityId()!='A0C7')and(GetSpellAbilityId()!='A0C6')and(GetSpellAbilityId()!='A12H')and(GetSpellAbilityId()!='A12G')and(GetSpellAbilityId()!='A11A')and(GetSpellAbilityId()!='A0D4')and(GetSpellAbilityId()!='A18N') // 'Avul': standard ability reference "Invulnerable"; 'A0S8': ability "Enfire"; 'A0S9': ability "Enfrost"; 'A0SB': ability "Enthunder"; 'A0SC': ability "Enwater"; 'A0SD': ability "Enstone"; 'A0SE': ability "Enaero"; 'A0R3': ability "Evade & Counter"; 'A00Q': ability "Frog"; 'A0Z2': ability "Raise Dead"; 'A197': ability "Momentum"; 'A0C7': ability "Spirit Potion"; 'A0C6': ability "Blood Ether"; 'A12H': ability "Fill Vial"; 'A12G': ability "Empty Vial"; 'A11A': ability "Essence Crystal"; 'A0D4': ability "Magic Urn"; 'A18N': ability "Firewood"
endfunction

function Trig_Cooldown_Scaling_HasSlashedCooldown takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1C3',GetTriggerUnit())>0) // 'A1C3': ability "Slashed Cooldown"
endfunction

function Trig_Cooldown_Scaling_HasReducedCooldown takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A18K',GetTriggerUnit())>0) // 'A18K': ability "Reduced Cooldown"
endfunction

function Trig_Cooldown_Scaling_HasSlow takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'Bslo')) // 'Bslo': buff tooltip "Slow"
endfunction

function Trig_Cooldown_Scaling_HasSlowra takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B08Y')) // 'B08Y': buff "Slowra"
endfunction

function Trig_Cooldown_Scaling_HasHaste takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B00F'))or(UnitHasBuffBJ(GetTriggerUnit(),'B07F'))or(GetUnitAbilityLevelSwapped('A0GJ',GetTriggerUnit())>0) // 'B00F': buff "Haste"; 'B07F': buff "Haste"; 'A0GJ': ability "Auto-Haste"
endfunction

function Trig_Cooldown_Scaling_IsHasted takes nothing returns boolean
    return(Trig_Cooldown_Scaling_HasHaste())
endfunction

function Trig_Cooldown_Scaling_HasHastera takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B08T')) // 'B08T': buff "Hastera"
endfunction

function Trig_Cooldown_Scaling_IsXPotion takes nothing returns boolean
    return(udg_TempItemId=='I02O') // 'I02O': item "Chemist's X-Potion"
endfunction

function Trig_Cooldown_Scaling_IsMegaPotion takes nothing returns boolean
    return(udg_TempItemId=='I02M') // 'I02M': item "Chemist's Mega Potion"
endfunction

function Trig_Cooldown_Scaling_IsHiPotion takes nothing returns boolean
    return(udg_TempItemId=='I02J') // 'I02J': item "Chemist's Hi-Potion"
endfunction

function Trig_Cooldown_Scaling_IsPotion takes nothing returns boolean
    return(udg_TempItemId=='I02L') // 'I02L': item "Chemist's Potion"
endfunction

function Trig_Cooldown_Scaling_IsTurboEther takes nothing returns boolean
    return(udg_TempItemId=='I02N') // 'I02N': item "Chemist's Turbo Ether"
endfunction

function Trig_Cooldown_Scaling_IsMegaEther takes nothing returns boolean
    return(udg_TempItemId=='I02K') // 'I02K': item "Chemist's Mega Ether"
endfunction

function Trig_Cooldown_Scaling_IsHiEther takes nothing returns boolean
    return(udg_TempItemId=='I02I') // 'I02I': item "Chemist's Hi-Ether"
endfunction

function Trig_Cooldown_Scaling_IsEther takes nothing returns boolean
    return(udg_TempItemId=='I02E') // 'I02E': item "Chemist's Ether"
endfunction

function Trig_Cooldown_Scaling_IsElixir takes nothing returns boolean
    return(udg_TempItemId=='I02D') // 'I02D': item "Chemist's Elixir"
endfunction

function Trig_Cooldown_Scaling_IsGreaterNectar takes nothing returns boolean
    return(udg_TempItemId=='I0EU') // 'I0EU': item "Chemist's Greater Nectar"
endfunction

function Trig_Cooldown_Scaling_IsNectar takes nothing returns boolean
    return(udg_TempItemId=='I0ET') // 'I0ET': item "Chemist's Nectar"
endfunction

function Trig_Cooldown_Scaling_IsHeroDrink takes nothing returns boolean
    return(udg_TempItemId=='I02H') // 'I02H': item "Chemist's Hero Drink"
endfunction

function Trig_Cooldown_Scaling_IsPharmacology takes nothing returns boolean
    return(GetSpellAbilityId()=='A19C') // 'A19C': ability "Pharmacology"
endfunction

function Trig_Cooldown_Scaling_UseLowerLevel takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Cooldown_Scaling_UseLowerLevelHero takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Cooldown_Scaling_IsPlayerHero takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Cooldown_Scaling_Actions takes nothing returns nothing
    set udg_TempReal=1000.
    if(Trig_Cooldown_Scaling_HasSlashedCooldown())then
        // Keep 70% of the cooldown scale: a 30% reduction.
        set udg_TempReal=(udg_TempReal*.7)
    endif
    if(Trig_Cooldown_Scaling_HasReducedCooldown())then
        // Keep 80% of the already-adjusted scale. Combined with 0.7, this is 0.56: a 44% total reduction.
        set udg_TempReal=(udg_TempReal*.8)
    endif
    if(Trig_Cooldown_Scaling_HasHastera())then
        // Hastera keeps 67% of the scale, making this cooldown portion 33% shorter.
        set udg_TempReal=(udg_TempReal*.67)
    else
        if(Trig_Cooldown_Scaling_IsHasted())then
            // Haste keeps 75% of the scale, making this cooldown portion 25% shorter.
            set udg_TempReal=(udg_TempReal*.75)
        else
            if(Trig_Cooldown_Scaling_HasSlowra())then
                // Slowra multiplies the scale by 1.5: this cooldown portion is 50% longer.
                set udg_TempReal=(udg_TempReal*1.5)
            else
                if(Trig_Cooldown_Scaling_HasSlow())then
                    // Slow multiplies the scale by 1.3: this cooldown portion is 30% longer.
                    set udg_TempReal=(udg_TempReal*1.3)
                endif
            endif
        endif
    endif
    if(Trig_Cooldown_Scaling_IsPharmacology())then
        if(Trig_Cooldown_Scaling_IsPotion())then
            // (udg_TempReal) times (BlzGetAbilityCooldown('A14X', udg_AbilityLevelIndex)).
            set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A14X',udg_AbilityLevelIndex)) // 'A14X': ability "Toss Potion"
        else
            if(Trig_Cooldown_Scaling_IsHiPotion())then
                // (udg_TempReal) times (BlzGetAbilityCooldown('A14W', udg_AbilityLevelIndex)).
                set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A14W',udg_AbilityLevelIndex)) // 'A14W': ability "Toss Hi-Potion"
            else
                if(Trig_Cooldown_Scaling_IsMegaPotion())then
                    // (udg_TempReal) times (BlzGetAbilityCooldown('A14V', udg_AbilityLevelIndex)).
                    set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A14V',udg_AbilityLevelIndex)) // 'A14V': ability "Toss Mega Potion"
                else
                    if(Trig_Cooldown_Scaling_IsXPotion())then
                        // (udg_TempReal) times (BlzGetAbilityCooldown('A14U', udg_AbilityLevelIndex)).
                        set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A14U',udg_AbilityLevelIndex)) // 'A14U': ability "Toss X-Potion"
                    endif
                endif
            endif
        endif
        if(Trig_Cooldown_Scaling_IsEther())then
            // (udg_TempReal) times (BlzGetAbilityCooldown('A0G5', udg_AbilityLevelIndex)).
            set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A0G5',udg_AbilityLevelIndex)) // 'A0G5': ability "Toss Ether"
        else
            if(Trig_Cooldown_Scaling_IsHiEther())then
                // (udg_TempReal) times (BlzGetAbilityCooldown('A0G3', udg_AbilityLevelIndex)).
                set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A0G3',udg_AbilityLevelIndex)) // 'A0G3': ability "Toss Hi-Ether"
            else
                if(Trig_Cooldown_Scaling_IsMegaEther())then
                    // (udg_TempReal) times (BlzGetAbilityCooldown('A0G1', udg_AbilityLevelIndex)).
                    set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A0G1',udg_AbilityLevelIndex)) // 'A0G1': ability "Toss Mega Ether"
                else
                    if(Trig_Cooldown_Scaling_IsTurboEther())then
                        // (udg_TempReal) times (BlzGetAbilityCooldown('A0FY', udg_AbilityLevelIndex)).
                        set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A0FY',udg_AbilityLevelIndex)) // 'A0FY': ability "Toss Turbo Ether"
                    endif
                endif
            endif
        endif
        if(Trig_Cooldown_Scaling_IsHeroDrink())then
            // (udg_TempReal) times (BlzGetAbilityCooldown('A0FZ', udg_AbilityLevelIndex)).
            set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A0FZ',udg_AbilityLevelIndex)) // 'A0FZ': ability "Toss Hero Drink"
        else
            if(Trig_Cooldown_Scaling_IsNectar())then
                // (udg_TempReal) times (BlzGetAbilityCooldown('A0KZ', udg_AbilityLevelIndex)).
                set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A0KZ',udg_AbilityLevelIndex)) // 'A0KZ': ability "Toss Nectar"
            else
                if(Trig_Cooldown_Scaling_IsGreaterNectar())then
                    // (udg_TempReal) times (BlzGetAbilityCooldown('A0L0', udg_AbilityLevelIndex)).
                    set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A0L0',udg_AbilityLevelIndex)) // 'A0L0': ability "Toss Greater Nectar"
                else
                    if(Trig_Cooldown_Scaling_IsElixir())then
                        // (udg_TempReal) times (BlzGetAbilityCooldown('A0FN', udg_AbilityLevelIndex)).
                        set udg_TempReal=(udg_TempReal*BlzGetAbilityCooldown('A0FN',udg_AbilityLevelIndex)) // 'A0FN': ability "Toss Elixir"
                    endif
                endif
            endif
        endif
    endif
    if(Trig_Cooldown_Scaling_IsPlayerHero())then
        if(Trig_Cooldown_Scaling_UseLowerLevelHero())then
            // Calculation 1:
            // (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) minus (1).
            // Calculation 2:
            // Result 1: (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) minus (1).
            // Result 2: Agility of the triggering unit treated as a decimal-capable number.
            // Result 3: (result 2) plus (1000).
            // Result 4: (udg_TempReal) divided by (result 3).
            // Result 5: (BlzGetAbilityCooldown(GetSpellAbilityId(), result 1)) times (result 4).
            call BlzSetUnitAbilityCooldown(GetTriggerUnit(),GetSpellAbilityId(),(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())-1),(BlzGetAbilityCooldown(GetSpellAbilityId(),(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())-1))*(udg_TempReal/(I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true))+1000.))))
        else
            // Result 1: Agility of the triggering unit treated as a decimal-capable number.
            // Result 2: (result 1) plus (1000).
            // Result 3: (udg_TempReal) divided by (result 2).
            // Result 4: (BlzGetAbilityCooldown(GetSpellAbilityId(), GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the
            // triggering unit))) times (result 3).
            call BlzSetUnitAbilityCooldown(GetTriggerUnit(),GetSpellAbilityId(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit()),(BlzGetAbilityCooldown(GetSpellAbilityId(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit()))*(udg_TempReal/(I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true))+1000.))))
        endif
    else
        if(Trig_Cooldown_Scaling_UseLowerLevel())then
            // Calculation 1:
            // (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) minus (1).
            // Calculation 2:
            // Result 1: (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) minus (1).
            // Result 2: (udg_TempReal) divided by (1000).
            // Result 3: (BlzGetAbilityCooldown(GetSpellAbilityId(), result 1)) times (result 2).
            call BlzSetUnitAbilityCooldown(GetTriggerUnit(),GetSpellAbilityId(),(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())-1),(BlzGetAbilityCooldown(GetSpellAbilityId(),(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())-1))*(udg_TempReal/ 1000.)))
        else
            // Result 1: (udg_TempReal) divided by (1000).
            // Result 2: (BlzGetAbilityCooldown(GetSpellAbilityId(), GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the
            // triggering unit))) times (result 1).
            call BlzSetUnitAbilityCooldown(GetTriggerUnit(),GetSpellAbilityId(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit()),(BlzGetAbilityCooldown(GetSpellAbilityId(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit()))*(udg_TempReal/ 1000.)))
        endif
    endif
endfunction

// World Editor calls InitTrig_Cooldown automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cooldown (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cooldown takes nothing returns nothing
endfunction

function Register_Cooldown_Scaling takes nothing returns nothing
    set gg_trg_Cooldown_Scaling=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cooldown_Scaling,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Cooldown_Scaling,Condition(function Trig_Cooldown_Scaling_Conditions))
    call TriggerAddAction(gg_trg_Cooldown_Scaling,function Trig_Cooldown_Scaling_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cooldown takes nothing returns nothing
    call Register_Cooldown_Scaling()
endfunction

endlibrary
