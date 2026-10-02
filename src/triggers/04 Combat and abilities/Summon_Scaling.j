library TSummonScaling requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Summon_Powerup=null
endglobals

function Trig_Summon_Powerup_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A122',udg_TempUnit2)<=0) // 'A122': ability "Summoned Powerup"
endfunction

function Trig_Summon_Powerup_Has_HighSummoner takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_TempUnit2),udg_TitleForce[31]))
endfunction

function Trig_Summon_Powerup_Has_BlueExorcist takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_TempUnit2),udg_TitleForce[51]))
endfunction

function Trig_Summon_Powerup_Has_ApprenticeSummoner takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_TempUnit2),udg_TitleForce[30]))
endfunction

function Trig_Summon_Powerup_Has_FullExorcist takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_TempUnit2),udg_TitleForce[32]))
endfunction

function Trig_Summon_Powerup_Has_FinalArbiter takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_TempUnit2),udg_TitleForce[33]))
endfunction

function Trig_Summon_Powerup_Has_ExtremeChallenger takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_TempUnit2),udg_TitleForce[49]))
endfunction

function Trig_Summon_Powerup_Has_MagicGod takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_TempUnit2),udg_TitleForce[34]))
endfunction

function Trig_Summon_Powerup_Has_MonsterHunter takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_TempUnit2),udg_TitleForce[50]))
endfunction

function Trig_Summon_Powerup_Has_NotHornless takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A05H',Player_GetHero(GetOwningPlayer(udg_TempUnit2)))>0) // 'A05H': ability "Not Hornless"
endfunction

function Trig_Summon_Powerup_Aura_Tarugaya takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A058',udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(udg_TempUnit2))])>0) // 'A058': ability "Tarugaya"
endfunction

function Trig_Summon_Powerup_Aura_Sukugaya takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('S004',udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(udg_TempUnit2))])>0) // 'S004': ability "Sukugaya"
endfunction

function Trig_Summon_Powerup_Aura_Rakugaya takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A07E',udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(udg_TempUnit2))])>0) // 'A07E': ability "Rakugaya"
endfunction

function Trig_Summon_Powerup_Powerup_AboveBase takes nothing returns boolean
    return(udg_StatCalcValue>$A) // $A = 10
endfunction

function Trig_Summon_Powerup_Actions takes nothing returns nothing
    call UnitAddAbilityBJ('A122',udg_TempUnit2) // 'A122': ability "Summoned Powerup"
    set udg_StatCalcValue=$A // $A = 10
    if(Trig_Summon_Powerup_Has_ExtremeChallenger())then
        // Increase udg_StatCalcValue by 15.
        set udg_StatCalcValue=(udg_StatCalcValue+$F) // $F = 15
    else
        if(Trig_Summon_Powerup_Has_FinalArbiter())then
            // Increase udg_StatCalcValue by 12.
            set udg_StatCalcValue=(udg_StatCalcValue+$C) // $C = 12
        else
            if(Trig_Summon_Powerup_Has_FullExorcist())then
                // Increase udg_StatCalcValue by 10.
                set udg_StatCalcValue=(udg_StatCalcValue+$A) // $A = 10
            else
                if(Trig_Summon_Powerup_Has_ApprenticeSummoner())then
                    // Increase udg_StatCalcValue by 3.
                    set udg_StatCalcValue=(udg_StatCalcValue+3)
                    if(Trig_Summon_Powerup_Has_HighSummoner())then
                        // Increase udg_StatCalcValue by 2.
                        set udg_StatCalcValue=(udg_StatCalcValue+2)
                    endif
                    if(Trig_Summon_Powerup_Has_BlueExorcist())then
                        // Increase udg_StatCalcValue by 3.
                        set udg_StatCalcValue=(udg_StatCalcValue+3)
                    endif
                endif
            endif
        endif
    endif
    if(Trig_Summon_Powerup_Has_MagicGod())then
        // Increase udg_StatCalcValue by 5.
        set udg_StatCalcValue=(udg_StatCalcValue+5)
    endif
    if(Trig_Summon_Powerup_Has_MonsterHunter())then
        // Increase udg_StatCalcValue by 2.
        set udg_StatCalcValue=(udg_StatCalcValue+2)
    endif
    if(Trig_Summon_Powerup_Has_NotHornless())then
        // Increase udg_StatCalcValue by 8.
        set udg_StatCalcValue=(udg_StatCalcValue+8)
    endif
    if(Trig_Summon_Powerup_Powerup_AboveBase())then
        call UnitRemoveBuffBJ('B08A',udg_TempUnit2) // 'B08A': buff "Evil Armor"
        call UnitRemoveBuffBJ('B04P',udg_TempUnit2) // 'B04P': buff "Spirit Armor"
        call UnitRemoveBuffBJ('BUfa',udg_TempUnit2) // 'BUfa': object name not found in map data
        if(Trig_Summon_Powerup_Aura_Tarugaya())then
            // ((BlzGetUnitBaseDamage(udg_TempUnit2, 0)) times ((udg_StatCalcValue) plus (3))) divided by (10).
            call BlzSetUnitBaseDamage(udg_TempUnit2,((BlzGetUnitBaseDamage(udg_TempUnit2,0)*(udg_StatCalcValue+3))/ $A),0) // $A = 10
            // ((BlzGetUnitBaseDamage(udg_TempUnit2, 1)) times ((udg_StatCalcValue) plus (3))) divided by (10).
            call BlzSetUnitBaseDamage(udg_TempUnit2,((BlzGetUnitBaseDamage(udg_TempUnit2,1)*(udg_StatCalcValue+3))/ $A),1) // $A = 10
        else
            // ((BlzGetUnitBaseDamage(udg_TempUnit2, 0)) times (udg_StatCalcValue)) divided by (10).
            call BlzSetUnitBaseDamage(udg_TempUnit2,((BlzGetUnitBaseDamage(udg_TempUnit2,0)*udg_StatCalcValue)/ $A),0) // $A = 10
            // ((BlzGetUnitBaseDamage(udg_TempUnit2, 1)) times (udg_StatCalcValue)) divided by (10).
            call BlzSetUnitBaseDamage(udg_TempUnit2,((BlzGetUnitBaseDamage(udg_TempUnit2,1)*udg_StatCalcValue)/ $A),1) // $A = 10
        endif
        if(Trig_Summon_Powerup_Aura_Sukugaya())then
            call UnitAddAbilityBJ('A1DI',udg_TempUnit2) // 'A1DI': ability "Sukugaya Unit Attack Speed +20%"
        endif
        if(Trig_Summon_Powerup_Aura_Rakugaya())then
            // Result 1: (BlzGetUnitArmor(udg_TempUnit2)) plus (20).
            // Result 2: udg_StatCalcValue treated as a decimal-capable number.
            // Result 3: (result 2) times (0.1).
            // Result 4: (result 1) times (result 3).
            call BlzSetUnitArmor(udg_TempUnit2,((BlzGetUnitArmor(udg_TempUnit2)+20.)*(I2R(udg_StatCalcValue)*.1)))
            call UnitAddAbilityBJ('A1DL',udg_TempUnit2) // 'A1DL': ability "Rakugaya Bonus"
        else
            // (BlzGetUnitArmor(udg_TempUnit2)) times ((udg_StatCalcValue treated as a decimal-capable number) times
            // (0.1)).
            call BlzSetUnitArmor(udg_TempUnit2,(BlzGetUnitArmor(udg_TempUnit2)*(I2R(udg_StatCalcValue)*.1)))
        endif
        // ((maximum health of udg_TempUnit2) times (udg_StatCalcValue)) divided by (10).
        call BlzSetUnitMaxHP(udg_TempUnit2,((BlzGetUnitMaxHP(udg_TempUnit2)*udg_StatCalcValue)/ $A)) // $A = 10
        call SetUnitLifePercentBJ(udg_TempUnit2,'d')
    endif
endfunction

function InitTrig_Summon_Scaling takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Summon_Part1 (module Summon),
// which keeps the original registration order.

function Register_Summon_Powerup takes nothing returns nothing
    set gg_trg_Summon_Powerup=CreateTrigger()
    call DisableTrigger(gg_trg_Summon_Powerup)
    call TriggerAddCondition(gg_trg_Summon_Powerup,Condition(function Trig_Summon_Powerup_Conditions))
    call TriggerAddAction(gg_trg_Summon_Powerup,function Trig_Summon_Powerup_Actions)
endfunction

endlibrary
