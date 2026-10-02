library TMagicDefense
function Trig_MagicDefense_Calc_Has_MysticArmorUpgrade takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0KN',udg_CurrentHero)>0) // 'A0KN': ability "Upgrade Life Bonus Dummy"
endfunction

function Trig_MagicDefense_Calc_Has_StaffUpgrade takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XF',udg_CurrentHero)>0) // 'A0XF': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_MagicDefense_Calc_Has_Nirvana takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I08N')) // 'I08N': item "Nirvana"
endfunction

function Trig_MagicDefense_Calc_Has_GravityStaff takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0BM')) // 'I0BM': item "Gravity Staff"
endfunction

function Trig_MagicDefense_Calc_Has_LifeStaff takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0CS')) // 'I0CS': item "Life Staff"
endfunction

function Trig_MagicDefense_Calc_Has_SiphoningStaff takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0KW')) // 'I0KW': item "Siphoning Staff"
endfunction

function Trig_MagicDefense_Calc_Has_DarkStaff takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0JW')) // 'I0JW': item "Dark Staff"
endfunction

function Trig_MagicDefense_Calc_Has_StaffOfLight takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0HW')) // 'I0HW': item "Staff of Light"
endfunction

function Trig_MagicDefense_Calc_Has_MagusRod takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0E6')) // 'I0E6': item "Magus Rod A"
endfunction

function Trig_MagicDefense_Calc_Has_InvertShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0FK')) // 'I0FK': item "Invert Shield"
endfunction

function Trig_MagicDefense_Calc_Has_PaladinShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0H0')) // 'I0H0': item "Paladin Shield"
endfunction

function Trig_MagicDefense_Calc_Has_Absorber takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I018')) // 'I018': item "Absorber"
endfunction

function Trig_MagicDefense_Calc_Has_FrostShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I03A')) // 'I03A': item "Frost Shield"
endfunction

function Trig_MagicDefense_Calc_Has_EnchantedShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I017')) // 'I017': item "Enchanted Shield"
endfunction

function Trig_MagicDefense_Calc_Has_ShimmeringShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0LN')) // 'I0LN': item "Shimmering Shield"
endfunction

function Trig_MagicDefense_Calc_Has_ReflectShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I04J')) // 'I04J': item "Reflect Shield"
endfunction

function Trig_MagicDefense_Calc_Has_UnholyShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I02T')) // 'I02T': item "Unholy Shield"
endfunction

function Trig_MagicDefense_Calc_Has_AegisShield takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I015')) // 'I015': item "Aegis Shield"
endfunction

function Trig_MagicDefense_Calc_Has_HelmOfDivineJudgement takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0D4')) // 'I0D4': item "Helm of Divine Judgement"
endfunction

function Trig_MagicDefense_Calc_Has_ZodiacHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I06A')) // 'I06A': item "Zodiac Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_GenjiMask takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0AA')) // 'I0AA': item "Genji Mask"
endfunction

function Trig_MagicDefense_Calc_Has_SerpentHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0FB')) // 'I0FB': item "Serpent Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_GrandHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I01L')) // 'I01L': item "Grand Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_BarbarianHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I02Z')) // 'I02Z': item "Barbarian's Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_ShimmeringHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0LO')) // 'I0LO': item "Shimmering Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_PlatinumHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I01K')) // 'I01K': item "Platinum Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_MithrilHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I01I')) // 'I01I': item "Mithril Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_IronHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I01H')) // 'I01H': item "Iron Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_Circlet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I069')) // 'I069': item "Circlet"
endfunction

function Trig_MagicDefense_Calc_Has_DiamondHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I01J')) // 'I01J': item "Diamond Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_HelmOfTheNecromancer takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I02U')) // 'I02U': item "Helm of the Necromancer"
endfunction

function Trig_MagicDefense_Calc_Has_IceHat takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0L1')) // 'I0L1': item "Ice Hat"
endfunction

function Trig_MagicDefense_Calc_Has_GreenHat takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0L2')) // 'I0L2': item "Green Hat"
endfunction

function Trig_MagicDefense_Calc_Has_GlimmeringHat takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0L4')) // 'I0L4': item "Glimmering Hat"
endfunction

function Trig_MagicDefense_Calc_Has_EarthHat takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0L3')) // 'I0L3': item "Earth Hat"
endfunction

function Trig_MagicDefense_Calc_Has_EnchantedHelmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I0FC')) // 'I0FC': item "Enchanted Helmet"
endfunction

function Trig_MagicDefense_Calc_Has_HelmOfTheMagi takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I026')) // 'I026': item "Helm of the Magi"
endfunction

function Trig_MagicDefense_Calc_Has_HeadgearOfTheDamned takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I02R')) // 'I02R': item "Headgear of the Damned"
endfunction

function Trig_MagicDefense_Calc_Has_IronDuke takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I08F')) // 'I08F': item "Iron Duke"
endfunction

function Trig_MagicDefense_Calc_Has_Griever takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I00H')) // 'I00H': item "Griever"
endfunction

function Trig_MagicDefense_Calc_Has_TouphRing takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(udg_CurrentHero,'I00B')) // 'I00B': item "Touph Ring"
endfunction

function Trig_MagicDefense_Calc_Has_RakugayaAura takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A07E',udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(udg_CurrentHero))])>=1) // 'A07E': ability "Rakugaya"
endfunction

function Trig_MagicDefense_Calc_Has_ArmsBeginnerTitle takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_CurrentHero),udg_TitleForce[36]))
endfunction

function Trig_MagicDefense_Calc_Has_ArmsCollectorTitle takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_CurrentHero),udg_TitleForce[37]))
endfunction

function Trig_MagicDefense_Calc_Has_ArmsHoarderTitle takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_CurrentHero),udg_TitleForce[38]))
endfunction

function Trig_MagicDefense_Calc_Has_ArmsConnoisseurTitle takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_CurrentHero),udg_TitleForce[57]))
endfunction

function Trig_MagicDefense_Calc_Has_ArmsExpertTitle takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_CurrentHero),udg_TitleForce[58]))
endfunction

function Trig_MagicDefense_Calc_Has_GeomancyLevel11 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0EM',udg_CurrentHero)==$B) // 'A0EM': ability "Defense Bonus"; $B = 11
endfunction

function Trig_MagicDefense_Calc_Has_GeomancyLevel22 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0EM',udg_CurrentHero)>=22) // 'A0EM': ability "Defense Bonus"
endfunction

function Trig_MagicDefense_Calc_Has_GeomancyBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0EM',udg_CurrentHero)>0) // 'A0EM': ability "Defense Bonus"
endfunction

function Trig_MagicDefense_Calc_Total_IsNegative takes nothing returns boolean
    return(udg_StatCalcValue<0)
endfunction

function Trig_MagicDefense_Calc_Owner_IsPlaying takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(udg_CurrentHero),udg_PlayingPlayers))
endfunction

function Trig_MagicDefense_Calc_Actions takes nothing returns nothing
    // Start with 1 magic-defense point per 5 Intelligence. Whole-number division drops leftovers.
    // Example: 27 Intelligence gives 5 points. Equipment and upgrade bonuses are added below.
    set udg_StatCalcValue=(GetHeroStatBJ(bj_HEROSTAT_INT,udg_CurrentHero,true)/ 5)
    if(Trig_MagicDefense_Calc_Has_MysticArmorUpgrade())then
        // Add 6 points per Mystic Armor research level when its bonus is active.
        set udg_StatCalcValue=(udg_StatCalcValue+(GetPlayerTechCountSimple('R007',GetOwningPlayer(udg_CurrentHero))*6)) // 'R007': upgrade "Mystic Armor"
    endif
    if(Trig_MagicDefense_Calc_Has_StaffUpgrade())then
        // Add 3 points per Staff research level when its bonus is active.
        set udg_StatCalcValue=(udg_StatCalcValue+(GetPlayerTechCountSimple('R004',GetOwningPlayer(udg_CurrentHero))*3)) // 'R004': upgrade "Staff"
    endif
    if(Trig_MagicDefense_Calc_Has_Nirvana())then
        // Increase udg_StatCalcValue by 68.
        set udg_StatCalcValue=(udg_StatCalcValue+68)
    endif
    if(Trig_MagicDefense_Calc_Has_GravityStaff())then
        // Increase udg_StatCalcValue by 70.
        set udg_StatCalcValue=(udg_StatCalcValue+70)
    endif
    if(Trig_MagicDefense_Calc_Has_LifeStaff())then
        // Increase udg_StatCalcValue by 50.
        set udg_StatCalcValue=(udg_StatCalcValue+50)
    endif
    if(Trig_MagicDefense_Calc_Has_SiphoningStaff())then
        // Increase udg_StatCalcValue by 45.
        set udg_StatCalcValue=(udg_StatCalcValue+45)
    endif
    if(Trig_MagicDefense_Calc_Has_DarkStaff())then
        // Increase udg_StatCalcValue by 40.
        set udg_StatCalcValue=(udg_StatCalcValue+40)
    endif
    if(Trig_MagicDefense_Calc_Has_StaffOfLight())then
        // Increase udg_StatCalcValue by 30.
        set udg_StatCalcValue=(udg_StatCalcValue+30)
    endif
    if(Trig_MagicDefense_Calc_Has_MagusRod())then
        // Decrease udg_StatCalcValue by 45.
        set udg_StatCalcValue=(udg_StatCalcValue-45)
    endif
    if(Trig_MagicDefense_Calc_Has_AegisShield())then
        // Increase udg_StatCalcValue by 20.
        set udg_StatCalcValue=(udg_StatCalcValue+20)
    else
        if(Trig_MagicDefense_Calc_Has_UnholyShield())then
            // Increase udg_StatCalcValue by 40.
            set udg_StatCalcValue=(udg_StatCalcValue+40)
        else
            if(Trig_MagicDefense_Calc_Has_ReflectShield())then
                // Increase udg_StatCalcValue by 80.
                set udg_StatCalcValue=(udg_StatCalcValue+80)
            else
                if(Trig_MagicDefense_Calc_Has_ShimmeringShield())then
                    // Increase udg_StatCalcValue by 50.
                    set udg_StatCalcValue=(udg_StatCalcValue+50)
                else
                    if(Trig_MagicDefense_Calc_Has_EnchantedShield())then
                        // Increase udg_StatCalcValue by 70.
                        set udg_StatCalcValue=(udg_StatCalcValue+70)
                    else
                        if(Trig_MagicDefense_Calc_Has_FrostShield())then
                            // Increase udg_StatCalcValue by 60.
                            set udg_StatCalcValue=(udg_StatCalcValue+60)
                        else
                            if(Trig_MagicDefense_Calc_Has_Absorber())then
                                // Increase udg_StatCalcValue by 100.
                                set udg_StatCalcValue=(udg_StatCalcValue+'d')
                            else
                                if(Trig_MagicDefense_Calc_Has_PaladinShield())then
                                    // Increase udg_StatCalcValue by 65.
                                    set udg_StatCalcValue=(udg_StatCalcValue+65)
                                else
                                    if(Trig_MagicDefense_Calc_Has_InvertShield())then
                                        // Increase udg_StatCalcValue by 75.
                                        set udg_StatCalcValue=(udg_StatCalcValue+75)
                                    endif
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
    if(Trig_MagicDefense_Calc_Has_IronHelmet())then
        // Increase udg_StatCalcValue by 5.
        set udg_StatCalcValue=(udg_StatCalcValue+5)
    else
        if(Trig_MagicDefense_Calc_Has_MithrilHelmet())then
            // Increase udg_StatCalcValue by 12.
            set udg_StatCalcValue=(udg_StatCalcValue+$C) // $C = 12
        else
            if(Trig_MagicDefense_Calc_Has_PlatinumHelmet())then
                // Increase udg_StatCalcValue by 20.
                set udg_StatCalcValue=(udg_StatCalcValue+20)
            else
                if(Trig_MagicDefense_Calc_Has_ShimmeringHelmet())then
                    // Increase udg_StatCalcValue by 30.
                    set udg_StatCalcValue=(udg_StatCalcValue+30)
                else
                    if(Trig_MagicDefense_Calc_Has_BarbarianHelmet())then
                        // Increase udg_StatCalcValue by 40.
                        set udg_StatCalcValue=(udg_StatCalcValue+40)
                    else
                        if(Trig_MagicDefense_Calc_Has_GrandHelmet())then
                            // Increase udg_StatCalcValue by 45.
                            set udg_StatCalcValue=(udg_StatCalcValue+45)
                        else
                            if(Trig_MagicDefense_Calc_Has_SerpentHelmet())then
                                // Increase udg_StatCalcValue by 45.
                                set udg_StatCalcValue=(udg_StatCalcValue+45)
                            else
                                if(Trig_MagicDefense_Calc_Has_GenjiMask())then
                                    // Increase udg_StatCalcValue by 50.
                                    set udg_StatCalcValue=(udg_StatCalcValue+50)
                                else
                                    if(Trig_MagicDefense_Calc_Has_ZodiacHelmet())then
                                        // Increase udg_StatCalcValue by 25.
                                        set udg_StatCalcValue=(udg_StatCalcValue+25)
                                    else
                                        if(Trig_MagicDefense_Calc_Has_HelmOfDivineJudgement())then
                                            // Increase udg_StatCalcValue by 30.
                                            set udg_StatCalcValue=(udg_StatCalcValue+30)
                                        endif
                                    endif
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
    if(Trig_MagicDefense_Calc_Has_HeadgearOfTheDamned())then
        // Increase udg_StatCalcValue by 20.
        set udg_StatCalcValue=(udg_StatCalcValue+20)
    else
        if(Trig_MagicDefense_Calc_Has_HelmOfTheMagi())then
            // Increase udg_StatCalcValue by 25.
            set udg_StatCalcValue=(udg_StatCalcValue+25)
        else
            if(Trig_MagicDefense_Calc_Has_EnchantedHelmet())then
                // Increase udg_StatCalcValue by 30.
                set udg_StatCalcValue=(udg_StatCalcValue+30)
            else
                if(Trig_MagicDefense_Calc_Has_EarthHat())then
                    // Increase udg_StatCalcValue by 50.
                    set udg_StatCalcValue=(udg_StatCalcValue+50)
                else
                    if(Trig_MagicDefense_Calc_Has_GlimmeringHat())then
                        // Increase udg_StatCalcValue by 45.
                        set udg_StatCalcValue=(udg_StatCalcValue+45)
                    else
                        if(Trig_MagicDefense_Calc_Has_GreenHat())then
                            // Increase udg_StatCalcValue by 55.
                            set udg_StatCalcValue=(udg_StatCalcValue+55)
                        else
                            if(Trig_MagicDefense_Calc_Has_IceHat())then
                                // Increase udg_StatCalcValue by 60.
                                set udg_StatCalcValue=(udg_StatCalcValue+60)
                            else
                                if(Trig_MagicDefense_Calc_Has_HelmOfTheNecromancer())then
                                    // Increase udg_StatCalcValue by 70.
                                    set udg_StatCalcValue=(udg_StatCalcValue+70)
                                else
                                    if(Trig_MagicDefense_Calc_Has_DiamondHelmet())then
                                        // Increase udg_StatCalcValue by 70.
                                        set udg_StatCalcValue=(udg_StatCalcValue+70)
                                    else
                                        if(Trig_MagicDefense_Calc_Has_Circlet())then
                                            // Increase udg_StatCalcValue by 65.
                                            set udg_StatCalcValue=(udg_StatCalcValue+65)
                                        endif
                                    endif
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
    if(Trig_MagicDefense_Calc_Has_TouphRing())then
        // Increase udg_StatCalcValue by 50.
        set udg_StatCalcValue=(udg_StatCalcValue+50)
    else
        if(Trig_MagicDefense_Calc_Has_Griever())then
            // Increase udg_StatCalcValue by 20.
            set udg_StatCalcValue=(udg_StatCalcValue+20)
        else
            if(Trig_MagicDefense_Calc_Has_IronDuke())then
                // Increase udg_StatCalcValue by 32.
                set udg_StatCalcValue=(udg_StatCalcValue+32)
            endif
        endif
    endif
    if(Trig_MagicDefense_Calc_Has_RakugayaAura())then
        // Increase udg_StatCalcValue by 20.
        set udg_StatCalcValue=(udg_StatCalcValue+20)
    endif
    if(Trig_MagicDefense_Calc_Has_ArmsExpertTitle())then
        // Increase udg_StatCalcValue by 25.
        set udg_StatCalcValue=(udg_StatCalcValue+25)
    else
        if(Trig_MagicDefense_Calc_Has_ArmsConnoisseurTitle())then
            // Increase udg_StatCalcValue by 20.
            set udg_StatCalcValue=(udg_StatCalcValue+20)
        else
            if(Trig_MagicDefense_Calc_Has_ArmsHoarderTitle())then
                // Increase udg_StatCalcValue by 15.
                set udg_StatCalcValue=(udg_StatCalcValue+$F) // $F = 15
            else
                if(Trig_MagicDefense_Calc_Has_ArmsCollectorTitle())then
                    // Increase udg_StatCalcValue by 10.
                    set udg_StatCalcValue=(udg_StatCalcValue+$A) // $A = 10
                else
                    if(Trig_MagicDefense_Calc_Has_ArmsBeginnerTitle())then
                        // Increase udg_StatCalcValue by 5.
                        set udg_StatCalcValue=(udg_StatCalcValue+5)
                    endif
                endif
            endif
        endif
    endif
    if(Trig_MagicDefense_Calc_Has_GeomancyBonus())then
        // (udg_StatCalcValue) plus ((GetUnitAbilityLevelSwapped('A0EM', udg_CurrentHero)) times (5)).
        set udg_StatCalcValue=(udg_StatCalcValue+(GetUnitAbilityLevelSwapped('A0EM',udg_CurrentHero)*5)) // 'A0EM': ability "Defense Bonus"
        if(Trig_MagicDefense_Calc_Has_GeomancyLevel22())then
            // Increase udg_StatCalcValue by 10.
            set udg_StatCalcValue=(udg_StatCalcValue+$A) // $A = 10
        else
            if(Trig_MagicDefense_Calc_Has_GeomancyLevel11())then
                // Increase udg_StatCalcValue by 5.
                set udg_StatCalcValue=(udg_StatCalcValue+5)
            endif
        endif
    endif
    // Do not let penalties leave the final magic-defense total below zero.
    if(Trig_MagicDefense_Calc_Total_IsNegative())then
        set udg_StatCalcValue=0
    endif
    if(Trig_MagicDefense_Calc_Owner_IsPlaying())then
        set udg_MagicDefense[GetConvertedPlayerId(GetOwningPlayer(udg_CurrentHero))]=udg_StatCalcValue
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_MagicDefense takes nothing returns nothing
endfunction

function RegisterR11_MagicDefense_Calc takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_MagicDefense_Calc=CreateTrigger()

call DisableTrigger(gg_trg_MagicDefense_Calc)

call TriggerAddAction(gg_trg_MagicDefense_Calc,function Trig_MagicDefense_Calc_Actions)

endfunction




endlibrary
