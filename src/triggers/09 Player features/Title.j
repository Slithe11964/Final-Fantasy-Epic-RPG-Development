library TTitle requires TForce, TPlayerPart01
function Trig_Title_ApplyStats_AddPrimaryStat takes unit l_hero,integer l_amount returns nothing
    local integer unitTypeId=GetUnitTypeId(l_hero)
    if(unitTypeId=='H000' or unitTypeId=='H003' or unitTypeId=='H00A' or unitTypeId=='H00D' or unitTypeId=='H00C' or unitTypeId=='H00M' or unitTypeId=='H02X' or unitTypeId=='H02L' or unitTypeId=='H02O')then // 'H000': unit "Squire"; 'H003': unit "Knight"; 'H00A': unit "Monk"; 'H00D': unit "Geomancer"; 'H00C': unit "Lancer"; 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"; 'H02L': unit "Freelancer"; 'H02O': unit "Freelancer"
        // (Strength of l_hero) plus (amount).
        call SetHeroStr(l_hero,GetHeroStr(l_hero,false)+l_amount,true)
    elseif(unitTypeId=='H001' or unitTypeId=='H00B' or unitTypeId=='H00E' or unitTypeId=='H00F' or unitTypeId=='H02M' or unitTypeId=='H02P')then // 'H001': unit "Archer"; 'H00B': unit "Thief"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"; 'H02M': unit "Freelancer"; 'H02P': unit "Freelancer"
        // (Agility of l_hero) plus (amount).
        call SetHeroAgi(l_hero,GetHeroAgi(l_hero,false)+l_amount,true)
    elseif(unitTypeId=='H002' or unitTypeId=='H004' or unitTypeId=='H005' or unitTypeId=='H009' or unitTypeId=='H008' or unitTypeId=='H00G' or unitTypeId=='H00I' or unitTypeId=='H00H' or unitTypeId=='H00J' or unitTypeId=='H00L' or unitTypeId=='H02Y' or unitTypeId=='H02N' or unitTypeId=='H02Q')then // 'H002': unit "Chemist"; 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"; 'H00L': unit "Sorcerer"; 'H02Y': unit "Necromancer"; 'H02N': unit "Freelancer"; 'H02Q': unit "Freelancer"
        // (Intelligence of l_hero) plus (amount).
        call SetHeroInt(l_hero,GetHeroInt(l_hero,false)+l_amount,true)
    endif
endfunction

function Trig_Title_Grant_Title_NotOwned takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[udg_TempInteger])==false)
endfunction

function Trig_Title_Grant_Actions takes nothing returns nothing
    if(Trig_Title_Grant_Title_NotOwned())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[udg_TempInteger])
        set udg_TempForce=Force_OfPlayer(udg_TempPlayer)
        call DisplayTimedTextToForce(udg_TempForce,30,("|cffffcc00You have attained the title of|r |cff00ff00"+udg_TitleName[udg_TempInteger]))
        call QuestMessageBJ(udg_TempForce,bj_QUESTMESSAGE_ITEMACQUIRED,udg_BonusText[udg_TempInteger])
        call DestroyForce(udg_TempForce)
    endif
    call SetPlayerAbilityAvailableBJ(true,'A0AR',udg_TempPlayer) // 'A0AR': ability "Hero Chronicles"
    call SetPlayerAbilityAvailableBJ(true,udg_ChronicleAbility[udg_TitleChronicleIndex[udg_TempInteger]],udg_TempPlayer)
    // Result 1: (GetUnitAbilityLevelSwapped(udg_ChronicleAbility at position udg_TitleChronicleIndex at position
    // udg_TempInteger, udg_SpiritOfGaya at position GetConvertedPlayerId(udg_TempPlayer))) plus
    // (udg_TitleChroniclePoints at position udg_TempInteger).
    call SetUnitAbilityLevelSwapped(udg_ChronicleAbility[udg_TitleChronicleIndex[udg_TempInteger]],udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)],(GetUnitAbilityLevelSwapped(udg_ChronicleAbility[udg_TitleChronicleIndex[udg_TempInteger]],udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)])+udg_TitleChroniclePoints[udg_TempInteger]))
    call GroupAddUnitSimple(Player_GetHero(udg_TempPlayer),udg_BonusGroup[udg_TempInteger])
    call ConditionalTriggerExecute(gg_trg_Title_UnlockEffects)
    call ConditionalTriggerExecute(gg_trg_Title_ApplyStats)
endfunction

function Trig_Title_UnlockEffects_Has_RumoredAdventurerTitle takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[40]))
endfunction

function Trig_Title_UnlockEffects_IsTitle_GayaApprentice takes nothing returns boolean
    return(udg_TempInteger==7)
endfunction

function Trig_Title_UnlockEffects_IsTitle_GayaHero takes nothing returns boolean
    return(udg_TempInteger==8)
endfunction

function Trig_Title_UnlockEffects_Shrine_NotUnlocked takes nothing returns boolean
    return(udg_ShrineUnlocked==false)
endfunction

function Trig_Title_UnlockEffects_IsTitle_Master takes nothing returns boolean
    return(udg_TempInteger==$A) // $A = 10
endfunction

function Trig_Title_UnlockEffects_NGPlus_NotDoubled takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_LegendaryGuardianForce)==false)
endfunction

function Trig_Title_UnlockEffects_Difficulty_Below5 takes nothing returns boolean
    return(udg_Difficulty<5)
endfunction

function Trig_Title_UnlockEffects_Difficulty_IsSimple takes nothing returns boolean
    return(udg_Difficulty==1)
endfunction

function Trig_Title_UnlockEffects_LoadedDifficulty_Is2 takes nothing returns boolean
    return(udg_CodeDifficulty[GetConvertedPlayerId(udg_TempPlayer)]==2)
endfunction

function Trig_Title_UnlockEffects_LoadedDifficulty_IsSimple takes nothing returns boolean
    return(udg_CodeDifficulty[GetConvertedPlayerId(udg_TempPlayer)]==1)
endfunction

function Trig_Title_UnlockEffects_Difficulty_Is6 takes nothing returns boolean
    return(udg_Difficulty==6)
endfunction

function Trig_Title_UnlockEffects_NGPlus_Allowed takes nothing returns boolean
    return(udg_NewGamePlusLevel[GetConvertedPlayerId(udg_TempPlayer)]<$A)and(IsPlayerInForce(udg_TempPlayer,udg_CheaterForce)==false) // $A = 10
endfunction

function Trig_Title_UnlockEffects_IsTitle_HighGuardian takes nothing returns boolean
    return(udg_TempInteger==$E) // $E = 14
endfunction

function Trig_Title_UnlockEffects_DarkJobs_NotUnlocked takes nothing returns boolean
    return(udg_DarkJobsUnlocked==false)
endfunction

function Trig_Title_UnlockEffects_IsTitle_Lightbringer takes nothing returns boolean
    return(udg_TempInteger==16)
endfunction

function Trig_Title_UnlockEffects_IsTitle_LucifersGeneral takes nothing returns boolean
    return(udg_TempInteger==20)and(IsPlayerInForce(udg_TempPlayer,udg_CheaterForce)==false)
endfunction

function Trig_Title_UnlockEffects_IsTitle_Weaponsmith takes nothing returns boolean
    return(udg_TempInteger==35)
endfunction

function Trig_Title_UnlockEffects_Has_GayaApprenticeTitle takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[7]))
endfunction

function Trig_Title_UnlockEffects_IsTitle_RumoredAdventurer takes nothing returns boolean
    return(udg_TempInteger==40)
endfunction

function Trig_Title_UnlockEffects_WarriorLegend_NoCelestium takes nothing returns boolean
    return(udg_LegendaryUnlocked==false)
endfunction

function Trig_Title_UnlockEffects_IsTitle_WarriorOfLegend takes nothing returns boolean
    return(udg_TempInteger==44)
endfunction

function Trig_Title_UnlockEffects_Has_UltimateMageTitle takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[47]))
endfunction

function Trig_Title_UnlockEffects_IsTitle_UltimateWarrior takes nothing returns boolean
    return(udg_TempInteger==45)
endfunction

function Trig_Title_UnlockEffects_MageLegend_NoCelestium takes nothing returns boolean
    return(udg_LegendaryUnlocked==false)
endfunction

function Trig_Title_UnlockEffects_DropTier_Is5 takes nothing returns boolean
    return(udg_QuestStage[$E]==5) // $E = 14
endfunction

function Trig_Title_UnlockEffects_DropTier_Is6 takes nothing returns boolean
    return(udg_QuestStage[$E]==6) // $E = 14
endfunction

function Trig_Title_UnlockEffects_IsTitle_MageOfLegend takes nothing returns boolean
    return(udg_TempInteger==46)
endfunction

function Trig_Title_UnlockEffects_Has_UltimateWarriorTitle takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[45]))
endfunction

function Trig_Title_UnlockEffects_IsTitle_UltimateMage takes nothing returns boolean
    return(udg_TempInteger==47)
endfunction

function Trig_Title_UnlockEffects_IsTitle_LegendaryGuardian takes nothing returns boolean
    return(udg_TempInteger==48)
endfunction

function Trig_Title_UnlockEffects_IsTitle_GayaMaster takes nothing returns boolean
    return(udg_TempInteger==52)
endfunction

function Trig_Title_UnlockEffects_Cooking_NotMaxed takes nothing returns boolean
    return(udg_CookingStage<3)
endfunction

function Trig_Title_UnlockEffects_IsTitle_MasterChef takes nothing returns boolean
    return(udg_TempInteger==55)
endfunction

function Trig_Title_UnlockEffects_Actions takes nothing returns nothing
    if(Trig_Title_UnlockEffects_IsTitle_GayaApprentice())then
        if(Trig_Title_UnlockEffects_Has_RumoredAdventurerTitle())then
            call SetUnitAbilityLevelSwapped('S009',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)],4) // 'S009': ability "Spirit Blessing"
        else
            call SetUnitAbilityLevelSwapped('S009',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)],2) // 'S009': ability "Spirit Blessing"
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_GayaHero())then
        call SetPlayerAbilityAvailableBJ(true,'A11U',udg_TempPlayer) // 'A11U': ability "Scan"
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_Master())then
        if(Trig_Title_UnlockEffects_Shrine_NotUnlocked())then
            call ConditionalTriggerExecute(gg_trg_Shrine_Unlock)
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_HighGuardian())then
        call StartTimerBJ(udg_JobLevelTimer,false,.01)
        call EnableTrigger(gg_trg_JobLevels_Init)
        if(Trig_Title_UnlockEffects_NGPlus_Allowed())then
            call EnableTrigger(udg_NewGamePlusTrig)
            set udg_TempForce=Force_OfPlayer(udg_TempPlayer)
            if(Trig_Title_UnlockEffects_NGPlus_NotDoubled())then
                call DisplayTimedTextToForce(udg_TempForce,60.,"You are able to enter |cffffcc00New Game Plus|r mode. You can type \"-newgameplus\" to create a save code that when loaded will restart you at Level 1 without any items, abilities or titles. However, all your jobs will have 0.1 increased stat growth per level for each time you do this, up to a maximum of 1.0 increase per level.")
            else
                call DisplayTimedTextToForce(udg_TempForce,60.,"You are able to enter |cffffcc00New Game Plus|r mode. You can type \"-newgameplus\" to create a save code that when loaded will restart you at Level 1 without any items, abilities or titles. However, all your jobs will have 0.2 increased stat growth per level for each time you do this, up to a maximum of 1.0 increase per level.")
            endif
            if(Trig_Title_UnlockEffects_Difficulty_Is6())then
                if(Trig_Title_UnlockEffects_LoadedDifficulty_IsSimple())then
                    call DisplayTimedTextToForce(udg_TempForce,60.," ")
                    call DisplayTimedTextToForce(udg_TempForce,60.,"Saves from Simple mode cannot carry over Armory into New Game Plus.")
                else
                    if(Trig_Title_UnlockEffects_LoadedDifficulty_Is2())then
                        call DisplayTimedTextToForce(udg_TempForce,60.," ")
                        call DisplayTimedTextToForce(udg_TempForce,60.,"You can load your New Game Plus into any difficulty, however, if you load it into Inferno difficulty you cannot carry over your Armory from lower difficulties.")
                    endif
                endif
            else
                if(Trig_Title_UnlockEffects_Difficulty_IsSimple())then
                    call DisplayTimedTextToForce(udg_TempForce,60.," ")
                    call DisplayTimedTextToForce(udg_TempForce,60.,"Saves from Simple mode cannot carry over Armory into New Game Plus.")
                else
                    if(Trig_Title_UnlockEffects_Difficulty_Below5())then
                        call DisplayTimedTextToForce(udg_TempForce,60.," ")
                        call DisplayTimedTextToForce(udg_TempForce,60.,"You can load your New Game Plus into any difficulty, however, if you load it into Inferno difficulty you cannot carry over your Armory from lower difficulties.")
                    endif
                endif
            endif
            call DestroyForce(udg_TempForce)
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_Lightbringer())then
        if(Trig_Title_UnlockEffects_DarkJobs_NotUnlocked())then
            call ConditionalTriggerExecute(gg_trg_DarkJobs_Unlock)
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_LucifersGeneral())then
        call EnableTrigger(udg_NewGameMinusTrig)
        set udg_TempForce=Force_OfPlayer(udg_TempPlayer)
        call DisplayTimedTextToForce(udg_TempForce,60.,"You are able to enter |cffffcc00New Game Minus|r mode. You can type \"-newgameminus\" to create a save code that when loaded will restart you at Level 1 without any items, abilities or titles, but also fix all your base stats at 5. You can still gain EXP and level up and attain titles, but your base stats will never increase.")
        call DestroyForce(udg_TempForce)
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_Weaponsmith())then
        call SetPlayerAbilityAvailableBJ(true,'A0MW',udg_TempPlayer) // 'A0MW': ability "Armory"
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_RumoredAdventurer())then
        if(Trig_Title_UnlockEffects_Has_GayaApprenticeTitle())then
            call SetUnitAbilityLevelSwapped('S009',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)],4) // 'S009': ability "Spirit Blessing"
        else
            call SetUnitAbilityLevelSwapped('S009',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)],3) // 'S009': ability "Spirit Blessing"
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_WarriorOfLegend())then
        if(Trig_Title_UnlockEffects_WarriorLegend_NoCelestium())then
            call ConditionalTriggerExecute(gg_trg_Legendary_Unlock)
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_UltimateWarrior())then
        if(Trig_Title_UnlockEffects_Has_UltimateMageTitle())then
            set udg_QuestStage[23]=1
            call ForceAddPlayerSimple(udg_TempPlayer,udg_JobMasterForce[22])
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_MageOfLegend())then
        if(Trig_Title_UnlockEffects_MageLegend_NoCelestium())then
            call ConditionalTriggerExecute(gg_trg_Legendary_Unlock)
        endif
        if(Trig_Title_UnlockEffects_DropTier_Is6())then
            set udg_QuestStage[$E]=2 // $E = 14
        else
            if(Trig_Title_UnlockEffects_DropTier_Is5())then
                set udg_QuestStage[$E]=6 // $E = 14
            endif
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_UltimateMage())then
        if(Trig_Title_UnlockEffects_Has_UltimateWarriorTitle())then
            set udg_QuestStage[23]=1
            call ForceAddPlayerSimple(udg_TempPlayer,udg_JobMasterForce[22])
        endif
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_LegendaryGuardian())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_LegendaryGuardianForce)
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_GayaMaster())then
        call SetUnitAbilityLevelSwapped('A10U',udg_SpiritOfGaya[GetConvertedPlayerId(udg_TempPlayer)],2) // 'A10U': ability "MP Regeneration"
        return
    endif
    if(Trig_Title_UnlockEffects_IsTitle_MasterChef())then
        if(Trig_Title_UnlockEffects_Cooking_NotMaxed())then
            call ConditionalTriggerExecute(gg_trg_Cooking_Recipes_UnlockAll)
        endif
        return
    endif
endfunction

function Trig_Title_ApplyStats_Conditions takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_CheaterForce)==false)
endfunction

function Trig_Title_ApplyStats_Title_PrimaryOnly takes nothing returns boolean
    return(udg_TitlePrimaryStatOnly[udg_TempInteger])
endfunction

function Trig_Title_ApplyStats_IsArmsTitle_Inner takes nothing returns boolean
    return(udg_TempInteger==36)or(udg_TempInteger==37)or(udg_TempInteger==38)or(udg_TempInteger==57)or(udg_TempInteger==58)
endfunction

function Trig_Title_ApplyStats_IsArmsTitle takes nothing returns boolean
    return(Trig_Title_ApplyStats_IsArmsTitle_Inner())
endfunction

function Trig_Title_ApplyStats_Title_GivesStats takes nothing returns boolean
    return(udg_BonusValue[udg_TempInteger]>0)
endfunction

function Trig_Title_ApplyStats_IsIntTitle_Inner takes nothing returns boolean
    return(udg_TempInteger==4)or(udg_TempInteger==46)
endfunction

function Trig_Title_ApplyStats_IsIntTitle takes nothing returns boolean
    return(Trig_Title_ApplyStats_IsIntTitle_Inner())
endfunction

function Trig_Title_ApplyStats_IsGenericTitle takes nothing returns boolean
    return(udg_TempInteger!=1)and(udg_TempInteger!=4)and(udg_TempInteger!=44)and(udg_TempInteger!=46)
endfunction

function Trig_Title_ApplyStats_Actions takes nothing returns nothing
    if(Trig_Title_ApplyStats_IsGenericTitle())then
        if(Trig_Title_ApplyStats_Title_GivesStats())then
            if(Trig_Title_ApplyStats_Title_PrimaryOnly())then
                call Trig_Title_ApplyStats_AddPrimaryStat(Player_GetHero(udg_TempPlayer),udg_BonusValue[udg_TempInteger])
            else
                call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,udg_BonusValue[udg_TempInteger])
                call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,udg_BonusValue[udg_TempInteger])
                call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,udg_BonusValue[udg_TempInteger])
            endif
        else
            if(Trig_Title_ApplyStats_IsArmsTitle())then
                // Calculation 1:
                // (BlzGetUnitBaseDamage(Player_GetHero(udg_TempPlayer), 0)) plus (20).
                // Calculation 2:
                // (1) minus (1).
                call BlzSetUnitBaseDamage(Player_GetHero(udg_TempPlayer),(BlzGetUnitBaseDamage(Player_GetHero(udg_TempPlayer),0)+20),(1-1))
                // (BlzGetUnitBaseDamage(Player_GetHero(udg_TempPlayer), 1)) plus (20).
                call BlzSetUnitBaseDamage(Player_GetHero(udg_TempPlayer),(BlzGetUnitBaseDamage(Player_GetHero(udg_TempPlayer),1)+20),1)
                // (BlzGetUnitArmor(Player_GetHero(udg_TempPlayer))) plus (5).
                call BlzSetUnitArmor(Player_GetHero(udg_TempPlayer),(BlzGetUnitArmor(Player_GetHero(udg_TempPlayer))+5.))
            endif
        endif
    else
        if(Trig_Title_ApplyStats_IsIntTitle())then
            call ModifyHeroStat(bj_HEROSTAT_INT,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,udg_BonusValue[udg_TempInteger])
        else
            call ModifyHeroStat(bj_HEROSTAT_STR,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,udg_BonusValue[udg_TempInteger])
            call ModifyHeroStat(bj_HEROSTAT_AGI,Player_GetHero(udg_TempPlayer),bj_MODIFYMETHOD_ADD,udg_BonusValue[udg_TempInteger])
        endif
    endif
endfunction

function Trig_Title_ArmsCollection_Conditions takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[35]))
endfunction

function Trig_Title_ArmsCollection_Item_NewOnHero takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_SaveFlagForce[udg_ItemIndex])==false)and(udg_ItemCounted[udg_ItemIndex]==false)and(GetUnitPointValueByType(udg_SaveFlagUnitID[udg_ItemIndex])>0)
endfunction

function Trig_Title_ArmsCollection_Item_NewOnSpirit takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_SaveFlagForce[udg_ItemIndex])==false)and(udg_ItemCounted[udg_ItemIndex]==false)and(GetUnitPointValueByType(udg_SaveFlagUnitID[udg_ItemIndex])>0)
endfunction

function Trig_Title_ArmsCollection_Item_NewOnExtraUnit takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_SaveFlagForce[udg_ItemIndex])==false)and(udg_ItemCounted[udg_ItemIndex]==false)and(GetUnitPointValueByType(udg_SaveFlagUnitID[udg_ItemIndex])>0)
endfunction

function Trig_Title_ArmsCollection_Arms_ItemMissing takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_SaveFlagForce[udg_TempInteger])==false)and(GetUnitPointValueByType(udg_SaveFlagUnitID[udg_TempInteger])>0)
endfunction

function Trig_Title_ArmsCollection_ArmsCount_250 takes nothing returns boolean
    // (udg_ArmoryItemCount at position GetConvertedPlayerId(udg_TempPlayer)) plus (udg_CountedItemTotal).
    return((udg_ArmoryItemCount[GetConvertedPlayerId(udg_TempPlayer)]+udg_CountedItemTotal)>=$FA) // $FA = 250
endfunction

function Trig_Title_ArmsCollection_ArmsCount_200 takes nothing returns boolean
    // (udg_ArmoryItemCount at position GetConvertedPlayerId(udg_TempPlayer)) plus (udg_CountedItemTotal).
    return((udg_ArmoryItemCount[GetConvertedPlayerId(udg_TempPlayer)]+udg_CountedItemTotal)>=$C8) // $C8 = 200
endfunction

function Trig_Title_ArmsCollection_ArmsCount_150 takes nothing returns boolean
    // (udg_ArmoryItemCount at position GetConvertedPlayerId(udg_TempPlayer)) plus (udg_CountedItemTotal).
    return((udg_ArmoryItemCount[GetConvertedPlayerId(udg_TempPlayer)]+udg_CountedItemTotal)>=$96) // $96 = 150
endfunction

function Trig_Title_ArmsCollection_ArmsCount_100 takes nothing returns boolean
    // (udg_ArmoryItemCount at position GetConvertedPlayerId(udg_TempPlayer)) plus (udg_CountedItemTotal).
    return((udg_ArmoryItemCount[GetConvertedPlayerId(udg_TempPlayer)]+udg_CountedItemTotal)>='d')
endfunction

function Trig_Title_ArmsCollection_ArmsCount_50 takes nothing returns boolean
    // (udg_ArmoryItemCount at position GetConvertedPlayerId(udg_TempPlayer)) plus (udg_CountedItemTotal).
    return((udg_ArmoryItemCount[GetConvertedPlayerId(udg_TempPlayer)]+udg_CountedItemTotal)>=50)
endfunction

function Trig_Title_ArmsCollection_Arms_HasPendingFlags takes nothing returns boolean
    return(udg_CountedItemTotal>0)
endfunction

function Trig_Title_ArmsCollection_HasArmsTitle_Low takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[udg_TempInteger]))
endfunction

function Trig_Title_ArmsCollection_HasArmsTitle_High takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[udg_TempInteger]))
endfunction

function Trig_Title_ArmsCollection_HasArmsSetPiece takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_SaveFlagForce[udg_TempInteger]))
endfunction

function Trig_Title_ArmsCollection_Actions takes nothing returns nothing
    set udg_CountedItemTotal=0
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>6
        set udg_ItemIndex=LoadInteger(udg_ItemSaveID,0,GetItemTypeId(UnitItemInSlotBJ(Player_GetHero(udg_TempPlayer),udg_TempInteger)))
        if(Trig_Title_ArmsCollection_Item_NewOnHero())then
            set udg_ItemCounted[udg_ItemIndex]=true
            set udg_CountedItemTotal=(udg_CountedItemTotal+1)
            set udg_CountedItemIndex[udg_CountedItemTotal]=udg_ItemIndex
        endif
        // (GetPlayerId(udg_TempPlayer)) plus (1).
        set udg_ItemIndex=LoadInteger(udg_ItemSaveID,0,GetItemTypeId(UnitItemInSlotBJ(udg_SpiritOfGaya[GetPlayerId(udg_TempPlayer)+1],udg_TempInteger)))
        if(Trig_Title_ArmsCollection_Item_NewOnSpirit())then
            set udg_ItemCounted[udg_ItemIndex]=true
            set udg_CountedItemTotal=(udg_CountedItemTotal+1)
            set udg_CountedItemIndex[udg_CountedItemTotal]=udg_ItemIndex
        endif
        // (GetPlayerId(udg_TempPlayer)) plus (1).
        set udg_ItemIndex=LoadInteger(udg_ItemSaveID,0,GetItemTypeId(UnitItemInSlotBJ(udg_PlayerHouse[GetPlayerId(udg_TempPlayer)+1],udg_TempInteger)))
        if(Trig_Title_ArmsCollection_Item_NewOnExtraUnit())then
            set udg_ItemCounted[udg_ItemIndex]=true
            set udg_CountedItemTotal=(udg_CountedItemTotal+1)
            set udg_CountedItemIndex[udg_CountedItemTotal]=udg_ItemIndex
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    if(Trig_Title_ArmsCollection_ArmsCount_50())then
        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[36])
        if(Trig_Title_ArmsCollection_ArmsCount_100())then
            call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[37])
            if(Trig_Title_ArmsCollection_ArmsCount_150())then
                call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[38])
                if(Trig_Title_ArmsCollection_ArmsCount_200())then
                    call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[57])
                    if(Trig_Title_ArmsCollection_ArmsCount_250())then
                        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[58])
                        call ForceAddPlayerSimple(udg_TempPlayer,udg_TitleForce[56])
                        set udg_TempInteger=1
                        loop
                            exitwhen udg_TempInteger>udg_SaveFlagCount
                            if(Trig_Title_ArmsCollection_Arms_ItemMissing())then
                                call ForceRemovePlayerSimple(udg_TempPlayer,udg_TitleForce[56])
                            endif
                            set udg_TempInteger=udg_TempInteger+1
                        endloop
                    endif
                endif
            endif
        endif
    endif
    if(Trig_Title_ArmsCollection_Arms_HasPendingFlags())then
        set udg_TempInteger=1
        loop
            exitwhen udg_TempInteger>udg_CountedItemTotal
            set udg_ItemCounted[udg_CountedItemIndex[udg_TempInteger]]=false
            set udg_TempInteger=udg_TempInteger+1
        endloop
        set udg_CountedItemTotal=0
    endif
    set udg_TempInteger=36
    loop
        exitwhen udg_TempInteger>38
        if(Trig_Title_ArmsCollection_HasArmsTitle_Low())then
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    set udg_TempInteger=56
    loop
        exitwhen udg_TempInteger>58
        if(Trig_Title_ArmsCollection_HasArmsTitle_High())then
            call ConditionalTriggerExecute(gg_trg_Title_Grant)
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    set udg_TempInteger=303
    loop
        exitwhen udg_TempInteger>312
        if(Trig_Title_ArmsCollection_HasArmsSetPiece())then
            call ForceAddPlayerSimple(udg_TempPlayer,udg_SaveFlagForce[507])
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
endfunction

function Trig_Title_JuniorAdventurer_Conditions takes nothing returns boolean
    return(udg_QuestsCompleted>=$A) // $A = 10
endfunction

function Trig_Title_JuniorAdventurer_Missing_JuniorAdventurer takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[39])==false)
endfunction

function Trig_Title_JuniorAdventurer_GrantJuniorAdventurer takes nothing returns nothing
    if(Trig_Title_JuniorAdventurer_Missing_JuniorAdventurer())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=39
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Title_JuniorAdventurer_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ForForce(udg_PlayingPlayers,function Trig_Title_JuniorAdventurer_GrantJuniorAdventurer)
    call EnableTrigger(gg_trg_Title_RumoredAdventurer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Title_RumoredAdventurer_Conditions takes nothing returns boolean
    return(udg_QuestsCompleted>=25)
endfunction

function Trig_Title_RumoredAdventurer_Missing_RumoredAdventurer takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[40])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[39]))
endfunction

function Trig_Title_RumoredAdventurer_GrantRumoredAdventurer takes nothing returns nothing
    if(Trig_Title_RumoredAdventurer_Missing_RumoredAdventurer())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=40
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Title_RumoredAdventurer_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ForForce(udg_PlayingPlayers,function Trig_Title_RumoredAdventurer_GrantRumoredAdventurer)
    call EnableTrigger(gg_trg_Title_SeniorAdventurer)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Title_SeniorAdventurer_Conditions takes nothing returns boolean
    return(udg_QuestsCompleted>=50)
endfunction

function Trig_Title_SeniorAdventurer_Missing_SeniorAdventurer takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[41])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[40]))
endfunction

function Trig_Title_SeniorAdventurer_GrantSeniorAdventurer takes nothing returns nothing
    if(Trig_Title_SeniorAdventurer_Missing_SeniorAdventurer())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=41
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Title_SeniorAdventurer_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ForForce(udg_PlayingPlayers,function Trig_Title_SeniorAdventurer_GrantSeniorAdventurer)
    call EnableTrigger(gg_trg_Title_HeroicSpirit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Title_HeroicSpirit_Conditions takes nothing returns boolean
    return(udg_QuestsCompleted>=udg_QuestsTotal)
endfunction

function Trig_Title_HeroicSpirit_Missing_HeroicSpirit takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[42])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[41]))
endfunction

function Trig_Title_HeroicSpirit_GrantHeroicSpirit takes nothing returns nothing
    if(Trig_Title_HeroicSpirit_Missing_HeroicSpirit())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=42
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Title_HeroicSpirit_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ForForce(udg_PlayingPlayers,function Trig_Title_HeroicSpirit_GrantHeroicSpirit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Title takes nothing returns nothing
endfunction
function RegisterR11_Title_Grant takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Title_Grant=CreateTrigger()
    call DisableTrigger(gg_trg_Title_Grant)
    call TriggerAddAction(gg_trg_Title_Grant,function Trig_Title_Grant_Actions)
endfunction
function RegisterR11_Title_UnlockEffects takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Title_UnlockEffects=CreateTrigger()
    call DisableTrigger(gg_trg_Title_UnlockEffects)
    call TriggerAddAction(gg_trg_Title_UnlockEffects,function Trig_Title_UnlockEffects_Actions)
endfunction
function RegisterR11_Title_ApplyStats takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Title_ApplyStats=CreateTrigger()
    call DisableTrigger(gg_trg_Title_ApplyStats)
    call TriggerAddCondition(gg_trg_Title_ApplyStats,Condition(function Trig_Title_ApplyStats_Conditions))
    call TriggerAddAction(gg_trg_Title_ApplyStats,function Trig_Title_ApplyStats_Actions)
endfunction
function RegisterR11_Title_ArmsCollection takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Title_ArmsCollection=CreateTrigger()
    call DisableTrigger(gg_trg_Title_ArmsCollection)
    call TriggerAddCondition(gg_trg_Title_ArmsCollection,Condition(function Trig_Title_ArmsCollection_Conditions))
    call TriggerAddAction(gg_trg_Title_ArmsCollection,function Trig_Title_ArmsCollection_Actions)
endfunction
function RegisterR11_Title_JuniorAdventurer takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Title_JuniorAdventurer=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Title_JuniorAdventurer,5.)
    call TriggerAddCondition(gg_trg_Title_JuniorAdventurer,Condition(function Trig_Title_JuniorAdventurer_Conditions))
    call TriggerAddAction(gg_trg_Title_JuniorAdventurer,function Trig_Title_JuniorAdventurer_Actions)
endfunction
function RegisterR11_Title_RumoredAdventurer takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Title_RumoredAdventurer=CreateTrigger()
    call DisableTrigger(gg_trg_Title_RumoredAdventurer)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Title_RumoredAdventurer,5.)
    call TriggerAddCondition(gg_trg_Title_RumoredAdventurer,Condition(function Trig_Title_RumoredAdventurer_Conditions))
    call TriggerAddAction(gg_trg_Title_RumoredAdventurer,function Trig_Title_RumoredAdventurer_Actions)
endfunction
function RegisterR11_Title_SeniorAdventurer takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Title_SeniorAdventurer=CreateTrigger()
    call DisableTrigger(gg_trg_Title_SeniorAdventurer)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Title_SeniorAdventurer,5.)
    call TriggerAddCondition(gg_trg_Title_SeniorAdventurer,Condition(function Trig_Title_SeniorAdventurer_Conditions))
    call TriggerAddAction(gg_trg_Title_SeniorAdventurer,function Trig_Title_SeniorAdventurer_Actions)
endfunction
function RegisterR11_Title_HeroicSpirit takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Title_HeroicSpirit=CreateTrigger()
    call DisableTrigger(gg_trg_Title_HeroicSpirit)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Title_HeroicSpirit,5.)
    call TriggerAddCondition(gg_trg_Title_HeroicSpirit,Condition(function Trig_Title_HeroicSpirit_Conditions))
    call TriggerAddAction(gg_trg_Title_HeroicSpirit,function Trig_Title_HeroicSpirit_Actions)
endfunction




endlibrary
