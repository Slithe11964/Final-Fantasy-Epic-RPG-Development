library TAttackSpeed
function Trig_AttackSpeed_Update_AttackSpeedBonusIs22 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A00V',udg_CurrentHero)==22) // 'A00V': ability "Attack Speed Bonus"
endfunction

function Trig_AttackSpeed_Update_AttackSpeedBonusIs11 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A00V',udg_CurrentHero)==$B) // 'A00V': ability "Attack Speed Bonus"; $B = 11
endfunction

function Trig_AttackSpeed_Update_HasAttackSpeedBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A00V',udg_CurrentHero)>0) // 'A00V': ability "Attack Speed Bonus"
endfunction

function Trig_AttackSpeed_Update_HasWyrmheroEffect takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0HS',udg_CurrentHero)>0) // 'A0HS': ability "Wyrmhero Effect"
endfunction

function Trig_AttackSpeed_Update_Actions takes nothing returns nothing
    if(Trig_AttackSpeed_Update_HasWyrmheroEffect())then
        set udg_StatCalcValue=0
    else
        // Start with 4 x square root of Agility, then add 40% of Agility.
        // Drop the decimal part. At 100 Agility: 4 x 10 + 40 = 80 bonus points.
        set udg_StatCalcValue=R2I(((SquareRoot(I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_CurrentHero,true)))*4.)+(I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_CurrentHero,true))*.4)))
        if(Trig_AttackSpeed_Update_HasAttackSpeedBonus())then
            if(Trig_AttackSpeed_Update_AttackSpeedBonusIs11())then
                // The one-letter number 'd' means 100 here: this bonus adds 100 points.
                set udg_StatCalcValue=(udg_StatCalcValue+'d')
            else
                if(Trig_AttackSpeed_Update_AttackSpeedBonusIs22())then
                    // At ability level 22, add 200 points instead of the usual 8 per level.
                    set udg_StatCalcValue=(udg_StatCalcValue+$C8) // $C8 = 200
                else
                    // For other ability levels, add 8 points per level.
                    set udg_StatCalcValue=(udg_StatCalcValue+(GetUnitAbilityLevelSwapped('A00V',udg_CurrentHero)*8)) // 'A00V': ability "Attack Speed Bonus"
                endif
            endif
        endif
    endif
    // Store each complete block of 50 bonus points in the first ability.
    // The +1 selects its zero-bonus level when there are no complete blocks.
    call SetUnitAbilityLevelSwapped('A0KK',udg_CurrentHero,((udg_StatCalcValue/ 50)+1)) // 'A0KK': ability "Agility to Attack Speed - 50% Steps"
    // Modulo means the remainder after division. Store the leftover points in steps of 2.
    // Example: 83 points gives one block of 50, then 16 steps of 2; the last point is dropped.
    call SetUnitAbilityLevelSwapped('A0KJ',udg_CurrentHero,((ModuloInteger(udg_StatCalcValue,50)/ 2)+1)) // 'A0KJ': ability "Agility to Attack Speed - 2% Steps"
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_AttackSpeed takes nothing returns nothing
endfunction

function RegisterR11_AttackSpeed_Update takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_AttackSpeed_Update=CreateTrigger()

call DisableTrigger(gg_trg_AttackSpeed_Update)

call TriggerAddAction(gg_trg_AttackSpeed_Update,function Trig_AttackSpeed_Update_Actions)

endfunction




endlibrary
