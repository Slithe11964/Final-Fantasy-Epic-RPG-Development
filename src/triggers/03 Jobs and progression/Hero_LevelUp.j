library THeroLevelUp requires TForce, TJob, TPlayerHero
function Trig_Hero_LevelUp_IsSquire takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H000') // 'H000': unit "Squire"
endfunction

function Trig_Hero_LevelUp_IsChemist takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H002') // 'H002': unit "Chemist"
endfunction

function Trig_Hero_LevelUp_HasThief8 takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00B')>=8) // 'H00B': unit "Thief"
endfunction

function Trig_Hero_LevelUp_IsKnight takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H003') // 'H003': unit "Knight"
endfunction

function Trig_Hero_LevelUp_HasMonk8 takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00A')>=8) // 'H00A': unit "Monk"
endfunction

function Trig_Hero_LevelUp_IsArcher takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H001') // 'H001': unit "Archer"
endfunction

function Trig_Hero_LevelUp_HasTimeMage8 takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H008')>=8) // 'H008': unit "Time Mage"
endfunction

function Trig_Hero_LevelUp_IsWizard takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H004') // 'H004': unit "Wizard"
endfunction

function Trig_Hero_LevelUp_HasSummoner8 takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H009')>=8) // 'H009': unit "Summoner"
endfunction

function Trig_Hero_LevelUp_IsPriest takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H005') // 'H005': unit "Priest"
endfunction

function Trig_Hero_LevelUp_HasSamurai8 takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00E')>=8) // 'H00E': unit "Samurai"
endfunction

function Trig_Hero_LevelUp_IsMonkWithArcher8 takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H00A')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H001')>=8) // 'H00A': unit "Monk"; 'H001': unit "Archer"
endfunction

function Trig_Hero_LevelUp_HasGeomancer8 takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00D')>=8) // 'H00D': unit "Geomancer"
endfunction

function Trig_Hero_LevelUp_IsThiefWithKnight8 takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H00B')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H003')>=8) // 'H00B': unit "Thief"; 'H003': unit "Knight"
endfunction

function Trig_Hero_LevelUp_HasOracle8 takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00I')>=8) // 'H00I': unit "Oracle"
endfunction

function Trig_Hero_LevelUp_IsSummonerWithPriest8 takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H009')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H005')>=8) // 'H009': unit "Summoner"; 'H005': unit "Priest"
endfunction

function Trig_Hero_LevelUp_HasMediator8 takes nothing returns boolean
    return(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00G')>=8) // 'H00G': unit "Mediator"
endfunction

function Trig_Hero_LevelUp_IsTimeMageWithWizard8 takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H008')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H004')>=8) // 'H008': unit "Time Mage"; 'H004': unit "Wizard"
endfunction

function Trig_Hero_LevelUp_IsGeomancerWithThief8 takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H00D')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00B')>=8) // 'H00D': unit "Geomancer"; 'H00B': unit "Thief"
endfunction

function Trig_Hero_LevelUp_IsSamuraiWithMonk8 takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H00E')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H00A')>=8) // 'H00E': unit "Samurai"; 'H00A': unit "Monk"
endfunction

function Trig_Hero_LevelUp_IsMediatorWithTimeMage8 takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H00G')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H008')>=8) // 'H00G': unit "Mediator"; 'H008': unit "Time Mage"
endfunction

function Trig_Hero_LevelUp_IsOracleWithSummoner8 takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H00I')and(Job_GetSavedLevel(GetOwningPlayer(GetTriggerUnit()),'H009')>=8) // 'H00I': unit "Oracle"; 'H009': unit "Summoner"
endfunction

function Trig_Hero_LevelUp_IsLevel8 takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())==8)
endfunction

function Trig_Hero_LevelUp_FilterPlaying takes nothing returns boolean
    return(IsPlayerInForce(GetFilterPlayer(),udg_PlayingPlayers))
endfunction

function Trig_Hero_LevelUp_FilterNotLeveler takes nothing returns boolean
    return(GetFilterPlayer()!=GetOwningPlayer(GetLevelingUnit()))
endfunction

function Trig_Hero_LevelUp_FilterOtherPlayers takes nothing returns boolean
    return GetBooleanAnd(Trig_Hero_LevelUp_FilterPlaying(),Trig_Hero_LevelUp_FilterNotLeveler())
endfunction

function Trig_Hero_LevelUp_NotStatCapped takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_CheaterForce)==false)
endfunction

function Trig_Hero_LevelUp_CanBecomeMaster takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())>=50)and(GetUnitAbilityLevelSwapped('A02F',GetLevelingUnit())<2) // 'A02F': ability "Mastery"
endfunction

function Trig_Hero_LevelUp_FilterPlayingUltimate takes nothing returns boolean
    return(IsPlayerInForce(GetFilterPlayer(),udg_PlayingPlayers))
endfunction

function Trig_Hero_LevelUp_FilterNotLevelerUltimate takes nothing returns boolean
    return(GetFilterPlayer()!=GetOwningPlayer(GetLevelingUnit()))
endfunction

function Trig_Hero_LevelUp_FilterOtherPlayersUltimate takes nothing returns boolean
    return GetBooleanAnd(Trig_Hero_LevelUp_FilterPlayingUltimate(),Trig_Hero_LevelUp_FilterNotLevelerUltimate())
endfunction

function Trig_Hero_LevelUp_NotYetMaster takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',GetLevelingUnit())<2) // 'A02F': ability "Mastery"
endfunction

function Trig_Hero_LevelUp_NotYetMasterStats takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',GetLevelingUnit())<2) // 'A02F': ability "Mastery"
endfunction

function Trig_Hero_LevelUp_NotStatCappedUltimate takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_CheaterForce)==false)
endfunction

function Trig_Hero_LevelUp_CanBecomeUltimate takes nothing returns boolean
    return(GetHeroLevel(GetTriggerUnit())>=99)and(GetUnitAbilityLevelSwapped('A02F',GetLevelingUnit())<3) // 'A02F': ability "Mastery"
endfunction

function Trig_Hero_LevelUp_NeedsEndlessUpdate takes nothing returns boolean
    return(udg_NewGamePlusLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>0)and(udg_SpeedrunMode==false)and(GetHeroLevel(GetTriggerUnit())>GetUnitAbilityLevelSwapped('A10E',GetTriggerUnit())) // 'A10E': ability "Endless"
endfunction

function Trig_Hero_LevelUp_IsStatCapped takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_CheaterForce))
endfunction

function Trig_Hero_LevelUp_IsPlayerHero takes nothing returns boolean
    return(GetLevelingUnit()==Player_GetHero(GetOwningPlayer(GetLevelingUnit())))
endfunction

function Trig_Hero_LevelUp_Actions takes nothing returns nothing
    if(Trig_Hero_LevelUp_IsPlayerHero())then
        if(Trig_Hero_LevelUp_CanBecomeUltimate())then
            call PlaySoundBJ(gg_snd_003)
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetLevelingUnit()))
            call DisplayTimedTextToForce(udg_TempForce,30,("Congratulations, you are now |cffaa88ffUltimate Master|r "+("|cff00ff00"+(GetUnitName(GetTriggerUnit())+"|r"))))
            call DestroyForce(udg_TempForce)
            set udg_TempForce=Force_Matching(Condition(function Trig_Hero_LevelUp_FilterOtherPlayersUltimate))
            call DisplayTimedTextToForce(udg_TempForce,30,(("|cff0000a0"+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+("|r is now |cffccaaffUltimate Master|r "+GetUnitName(GetTriggerUnit()))))
            call DestroyForce(udg_TempForce)
            if(Trig_Hero_LevelUp_NotYetMaster())then
                call Job_MaxSkills(GetTriggerUnit())
            endif
            if(Trig_Hero_LevelUp_NotStatCappedUltimate())then
                if(Trig_Hero_LevelUp_NotYetMasterStats())then
                    call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,50)
                    call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,50)
                    call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,50)
                else
                    call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,30)
                    call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,30)
                    call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,30)
                endif
            endif
            call SetUnitAbilityLevelSwapped('A02F',GetTriggerUnit(),3) // 'A02F': ability "Mastery"
            call AdjustPlayerStateBJ(1,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_FOOD_USED)
        else
            if(Trig_Hero_LevelUp_CanBecomeMaster())then
                call PlaySoundBJ(gg_snd_002)
                set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetLevelingUnit()))
                call DisplayTimedTextToForce(udg_TempForce,30,("Congratulations, you are now |cffb28a42Master|r "+("|cff00ff00"+(GetUnitName(GetTriggerUnit())+"|r"))))
                call DestroyForce(udg_TempForce)
                set udg_TempForce=Force_Matching(Condition(function Trig_Hero_LevelUp_FilterOtherPlayers))
                call DisplayTimedTextToForce(udg_TempForce,30,(("|cff0000a0"+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+("|r is now |cff824a02Master|r "+GetUnitName(GetTriggerUnit()))))
                call DestroyForce(udg_TempForce)
                call SetUnitAbilityLevelSwapped('A02F',GetTriggerUnit(),2) // 'A02F': ability "Mastery"
                call Job_MaxSkills(GetTriggerUnit())
                if(Trig_Hero_LevelUp_NotStatCapped())then
                    call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,20)
                    call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,20)
                    call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,20)
                endif
            else
                if(Trig_Hero_LevelUp_IsLevel8())then
                    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
                    if(Trig_Hero_LevelUp_IsSquire())then
                        call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Knight|r and |cffffcc00Archer|r jobs.")
                    endif
                    if(Trig_Hero_LevelUp_IsChemist())then
                        call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Wizard|r and |cffffcc00Priest|r jobs.")
                    endif
                    if(Trig_Hero_LevelUp_IsKnight())then
                        if(Trig_Hero_LevelUp_HasThief8())then
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Monk|r and |cffffcc00Samurai|r jobs.")
                        else
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Monk|r job.")
                        endif
                    endif
                    if(Trig_Hero_LevelUp_IsArcher())then
                        if(Trig_Hero_LevelUp_HasMonk8())then
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Thief|r and |cffffcc00Geomancer|r jobs.")
                        else
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Thief|r job.")
                        endif
                    endif
                    if(Trig_Hero_LevelUp_IsWizard())then
                        if(Trig_Hero_LevelUp_HasTimeMage8())then
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Summoner|r and |cffffcc00Oracle|r jobs.")
                        else
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Summoner|r job.")
                        endif
                    endif
                    if(Trig_Hero_LevelUp_IsPriest())then
                        if(Trig_Hero_LevelUp_HasSummoner8())then
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Time Mage|r and |cffffcc00Mediator|r jobs.")
                        else
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Time Mage|r job.")
                        endif
                    endif
                    if(Trig_Hero_LevelUp_IsMonkWithArcher8())then
                        if(Trig_Hero_LevelUp_HasSamurai8())then
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Geomancer|r and |cffffcc00Ninja|r jobs.")
                        else
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Geomancer|r job.")
                        endif
                    endif
                    if(Trig_Hero_LevelUp_IsThiefWithKnight8())then
                        if(Trig_Hero_LevelUp_HasGeomancer8())then
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Samurai|r and |cffffcc00Lancer|r jobs.")
                        else
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Samurai|r job.")
                        endif
                    endif
                    if(Trig_Hero_LevelUp_IsSummonerWithPriest8())then
                        if(Trig_Hero_LevelUp_HasOracle8())then
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Mediator|r and |cffffcc00Prophet|r jobs.")
                        else
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Mediator|r job.")
                        endif
                    endif
                    if(Trig_Hero_LevelUp_IsTimeMageWithWizard8())then
                        if(Trig_Hero_LevelUp_HasMediator8())then
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Oracle|r and |cffffcc00Calculator|r jobs.")
                        else
                            call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Oracle|r job.")
                        endif
                    endif
                    if(Trig_Hero_LevelUp_IsGeomancerWithThief8())then
                        call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Lancer|r job.")
                    endif
                    if(Trig_Hero_LevelUp_IsSamuraiWithMonk8())then
                        call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Ninja|r job.")
                    endif
                    if(Trig_Hero_LevelUp_IsMediatorWithTimeMage8())then
                        call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Calculator|r job.")
                    endif
                    if(Trig_Hero_LevelUp_IsOracleWithSummoner8())then
                        call DisplayTimedTextToForce(udg_TempForce,20.,"You are now able to use the |cffffcc00Prophet|r job.")
                    endif
                    call DestroyForce(udg_TempForce)
                endif
            endif
        endif
        if(Trig_Hero_LevelUp_IsStatCapped())then
            call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_SET,5)
            call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_SET,5)
            call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_SET,5)
        else
            if(Trig_Hero_LevelUp_NeedsEndlessUpdate())then
                // Result 1: (udg_NewGamePlusLevel at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit)))
                // times (GetUnitAbilityLevelSwapped('A10E', the triggering unit)).
                // Result 2: result 1 treated as a decimal-capable number.
                // Result 3: (result 2) times (0.1).
                // Result 4: (result 3) with its decimal part removed.
                call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_SUB,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*GetUnitAbilityLevelSwapped('A10E',GetTriggerUnit())))*.1))) // 'A10E': ability "Endless"
                // Result 1: (udg_NewGamePlusLevel at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit)))
                // times (GetUnitAbilityLevelSwapped('A10E', the triggering unit)).
                // Result 2: result 1 treated as a decimal-capable number.
                // Result 3: (result 2) times (0.1).
                // Result 4: (result 3) with its decimal part removed.
                call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_SUB,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*GetUnitAbilityLevelSwapped('A10E',GetTriggerUnit())))*.1))) // 'A10E': ability "Endless"
                // Result 1: (udg_NewGamePlusLevel at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit)))
                // times (GetUnitAbilityLevelSwapped('A10E', the triggering unit)).
                // Result 2: result 1 treated as a decimal-capable number.
                // Result 3: (result 2) times (0.1).
                // Result 4: (result 3) with its decimal part removed.
                call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_SUB,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*GetUnitAbilityLevelSwapped('A10E',GetTriggerUnit())))*.1))) // 'A10E': ability "Endless"
                call SetUnitAbilityLevelSwapped('A10E',GetTriggerUnit(),GetHeroLevel(GetTriggerUnit())) // 'A10E': ability "Endless"
                // Result 1: (udg_NewGamePlusLevel at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit)))
                // times (GetUnitAbilityLevelSwapped('A10E', the triggering unit)).
                // Result 2: result 1 treated as a decimal-capable number.
                // Result 3: (result 2) times (0.1).
                // Result 4: (result 3) with its decimal part removed.
                call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*GetUnitAbilityLevelSwapped('A10E',GetTriggerUnit())))*.1))) // 'A10E': ability "Endless"
                // Result 1: (udg_NewGamePlusLevel at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit)))
                // times (GetUnitAbilityLevelSwapped('A10E', the triggering unit)).
                // Result 2: result 1 treated as a decimal-capable number.
                // Result 3: (result 2) times (0.1).
                // Result 4: (result 3) with its decimal part removed.
                call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*GetUnitAbilityLevelSwapped('A10E',GetTriggerUnit())))*.1))) // 'A10E': ability "Endless"
                // Result 1: (udg_NewGamePlusLevel at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit)))
                // times (GetUnitAbilityLevelSwapped('A10E', the triggering unit)).
                // Result 2: result 1 treated as a decimal-capable number.
                // Result 3: (result 2) times (0.1).
                // Result 4: (result 3) with its decimal part removed.
                call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,R2I((I2R((udg_NewGamePlusLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*GetUnitAbilityLevelSwapped('A10E',GetTriggerUnit())))*.1))) // 'A10E': ability "Endless"
            endif
        endif
    endif
    call StartTimerBJ(udg_JobLevelTimer,false,.01)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Hero_LevelUp takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Hero_Part1 (module Hero),
// which keeps the original registration order.

function Register_Hero_LevelUp takes nothing returns nothing
    set gg_trg_Hero_LevelUp=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Hero_LevelUp,EVENT_PLAYER_HERO_LEVEL)
    call TriggerAddAction(gg_trg_Hero_LevelUp,function Trig_Hero_LevelUp_Actions)
endfunction

endlibrary
