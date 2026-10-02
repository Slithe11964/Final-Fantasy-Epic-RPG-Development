library TShrine requires TForce, TJob, TPlayerPart01
function Trig_Shrine_Create_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(gg_unit_n04U_0204)
    call CreateNUnitsAtLoc(1,'n07J',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07J': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[0]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07K',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07K': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[1]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07L',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07L': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[2]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07M',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07M': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[3]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07N',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07N': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[4]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07O',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07O': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[5]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07P',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07P': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[6]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07Q',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07Q': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[7]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07R',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07R': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[8]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n0KM',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n0KM': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[18]=GetLastCreatedUnit()
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(gg_unit_n04U_0189)
    call CreateNUnitsAtLoc(1,'n07J',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07J': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[9]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07K',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07K': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[$A]=GetLastCreatedUnit() // $A = 10
    call CreateNUnitsAtLoc(1,'n07L',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07L': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[$B]=GetLastCreatedUnit() // $B = 11
    call CreateNUnitsAtLoc(1,'n07M',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07M': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[$C]=GetLastCreatedUnit() // $C = 12
    call CreateNUnitsAtLoc(1,'n07N',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07N': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[$D]=GetLastCreatedUnit() // $D = 13
    call CreateNUnitsAtLoc(1,'n07O',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07O': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[$E]=GetLastCreatedUnit() // $E = 14
    call CreateNUnitsAtLoc(1,'n07P',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07P': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[$F]=GetLastCreatedUnit() // $F = 15
    call CreateNUnitsAtLoc(1,'n07Q',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07Q': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[16]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n07R',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n07R': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[17]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1,'n0KM',Player(PLAYER_NEUTRAL_PASSIVE),udg_TempPoint,bj_UNIT_FACING) // 'n0KM': unit "Shrine of Individuality"
    set udg_ShrineMenuUnit[19]=GetLastCreatedUnit()
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(gg_unit_n04U_0204)
    set bj_forLoopAIndex=9
    set bj_forLoopAIndexEnd=17
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call GroupAddUnitSimple(udg_ShrineMenuUnit[GetForLoopIndexA()],udg_SecondShrineUnits)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=19
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call ShowUnitHide(udg_ShrineMenuUnit[GetForLoopIndexA()])
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_MasteryBonusAbility[5]='A0T9' // 'A0T9': ability "Last Stand"
    set udg_MasteryBonusAbility[6]='A0P9' // 'A0P9': ability "Focus"
    set udg_MasteryBonusAbility[7]='A0PA' // 'A0PA': ability "Adrenaline"
    set udg_MasteryBonusAbility[8]='A0RF' // 'A0RF': ability "Serenity"
    set udg_MasteryBonusAbility[9]='A0RG' // 'A0RG': ability "Spellbreaker"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Shrine_AbilitySwap_NotShrineSeller takes nothing returns boolean
    return(GetSellingUnit()!=gg_unit_n04U_0204)and(GetSellingUnit()!=gg_unit_n04U_0189)
endfunction

function Trig_Shrine_AbilitySwap_IsMenuPurchase takes nothing returns boolean
    return(Trig_Shrine_AbilitySwap_NotShrineSeller())or(GetUnitTypeId(GetSoldUnit())=='n07I')or(GetUnitTypeId(GetSoldUnit())=='n0KL') // 'n07I': unit "Ability Menu"; 'n0KL': unit "Legendary Bonus Menu"
endfunction

function Trig_Shrine_AbilitySwap_Conditions takes nothing returns boolean
    return(GetUnitName(GetTriggerUnit())=="Shrine of Individuality")and(Trig_Shrine_AbilitySwap_IsMenuPurchase())
endfunction

function Trig_Shrine_AbilitySwap_IsSecondShrine takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SecondShrineUnits))
endfunction

function Trig_Shrine_AbilitySwap_CurrentBonusIsFour takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',udg_CurrentHero)==4) // 'A02F': ability "Mastery"
endfunction

function Trig_Shrine_AbilitySwap_BonusIsFour takes nothing returns boolean
    return(GetUnitPointValue(GetSoldUnit())==4)
endfunction

function Trig_Shrine_AbilitySwap_BonusAlreadyActive takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',udg_CurrentHero)==GetUnitPointValue(GetSoldUnit())) // 'A02F': ability "Mastery"
endfunction

function Trig_Shrine_AbilitySwap_NotLegendaryMaster takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',udg_CurrentHero)<4) // 'A02F': ability "Mastery"
endfunction

function Trig_Shrine_AbilitySwap_MainIsAlchemy takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]==51)
endfunction

function Trig_Shrine_AbilitySwap_MainIsEnchant takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]==26)
endfunction

function Trig_Shrine_AbilitySwap_SubIsAlchemy takes nothing returns boolean
    return(udg_SubSkillSlot[udg_TempInteger]==51)
endfunction

function Trig_Shrine_AbilitySwap_HasBorrowedPair takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]>0)and(udg_SubSkillSlot[udg_TempInteger]>0)
endfunction

function Trig_Shrine_AbilitySwap_IsSummonSkill takes nothing returns boolean
    // Calculation 1:
    // The remainder after dividing (udg_MainSkillSlot at position udg_TempInteger) by (5).
    // Calculation 2:
    // The remainder after dividing (udg_SubSkillSlot at position udg_TempInteger) by (5).
    return(ModuloInteger(udg_MainSkillSlot[udg_TempInteger],5)==2)or(ModuloInteger(udg_SubSkillSlot[udg_TempInteger],5)==2)
endfunction

function Trig_Shrine_AbilitySwap_NeedsSummonCleanup takes nothing returns boolean
    return(Trig_Shrine_AbilitySwap_IsSummonSkill())and(udg_SummonUnit[udg_TempInteger]!=null)
endfunction

function Trig_Shrine_AbilitySwap_IsPetSkill takes nothing returns boolean
    // Calculation 1:
    // The remainder after dividing (udg_MainSkillSlot at position udg_TempInteger) by (5).
    // Calculation 2:
    // The remainder after dividing (udg_SubSkillSlot at position udg_TempInteger) by (5).
    return(ModuloInteger(udg_MainSkillSlot[udg_TempInteger],5)==3)or(ModuloInteger(udg_SubSkillSlot[udg_TempInteger],5)==3)
endfunction

function Trig_Shrine_AbilitySwap_NeedsPetCleanup takes nothing returns boolean
    return(Trig_Shrine_AbilitySwap_IsPetSkill())and(udg_PetUnit[udg_TempInteger]!=null)
endfunction

function Trig_Shrine_AbilitySwap_SubWasAlchemy takes nothing returns boolean
    return(udg_SubSkillSlot[udg_TempInteger]==51)
endfunction

function Trig_Shrine_AbilitySwap_SubWasEnchant takes nothing returns boolean
    return(udg_SubSkillSlot[udg_TempInteger]==26)
endfunction

function Trig_Shrine_AbilitySwap_MainWasAlchemy takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]==51)
endfunction

function Trig_Shrine_AbilitySwap_MainWasEnchant takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]==26)
endfunction

function Trig_Shrine_AbilitySwap_MainDiffersFromSub takes nothing returns boolean
    return(udg_MainSkillSlot[udg_TempInteger]!=udg_SubSkillSlot[udg_TempInteger])
endfunction

function Trig_Shrine_AbilitySwap_Slot1Alchemy takes nothing returns boolean
    return(udg_AbilitySlot1[udg_TempInteger]==51)
endfunction

function Trig_Shrine_AbilitySwap_Slot1Enchant takes nothing returns boolean
    return(udg_AbilitySlot1[udg_TempInteger]==26)
endfunction

function Trig_Shrine_AbilitySwap_IsSlot4Menu takes nothing returns boolean
    return(GetSellingUnit()==udg_ShrineMenuUnit[4])or(GetSellingUnit()==udg_ShrineMenuUnit[8])or(GetSellingUnit()==udg_ShrineMenuUnit[$D])or(GetSellingUnit()==udg_ShrineMenuUnit[17]) // $D = 13
endfunction

function Trig_Shrine_AbilitySwap_IsSlot4Pick takes nothing returns boolean
    return(Trig_Shrine_AbilitySwap_IsSlot4Menu())
endfunction

function Trig_Shrine_AbilitySwap_HasPetUnit takes nothing returns boolean
    return(udg_PetUnit[udg_TempInteger]!=null)
endfunction

function Trig_Shrine_AbilitySwap_IsSlot3Menu takes nothing returns boolean
    return(GetSellingUnit()==udg_ShrineMenuUnit[3])or(GetSellingUnit()==udg_ShrineMenuUnit[7])or(GetSellingUnit()==udg_ShrineMenuUnit[$C])or(GetSellingUnit()==udg_ShrineMenuUnit[16]) // $C = 12
endfunction

function Trig_Shrine_AbilitySwap_IsSlot3Pick takes nothing returns boolean
    return(Trig_Shrine_AbilitySwap_IsSlot3Menu())
endfunction

function Trig_Shrine_AbilitySwap_HasSummon takes nothing returns boolean
    return(udg_SummonUnit[udg_TempInteger]!=null)
endfunction

function Trig_Shrine_AbilitySwap_IsSlot2Menu takes nothing returns boolean
    return(GetSellingUnit()==udg_ShrineMenuUnit[2])or(GetSellingUnit()==udg_ShrineMenuUnit[6])or(GetSellingUnit()==udg_ShrineMenuUnit[$B])or(GetSellingUnit()==udg_ShrineMenuUnit[$F]) // $B = 11; $F = 15
endfunction

function Trig_Shrine_AbilitySwap_IsSlot2Pick takes nothing returns boolean
    return(Trig_Shrine_AbilitySwap_IsSlot2Menu())
endfunction

function Trig_Shrine_AbilitySwap_SwapSlot1Alchemy takes nothing returns boolean
    return(udg_AbilitySlot1[udg_TempInteger]==51)
endfunction

function Trig_Shrine_AbilitySwap_NewSlot1Enchant takes nothing returns boolean
    return(udg_AbilitySlot1[udg_TempInteger]==26)
endfunction

function Trig_Shrine_AbilitySwap_IsSlot1Menu takes nothing returns boolean
    return(GetSellingUnit()==udg_ShrineMenuUnit[1])or(GetSellingUnit()==udg_ShrineMenuUnit[5])or(GetSellingUnit()==udg_ShrineMenuUnit[$A])or(GetSellingUnit()==udg_ShrineMenuUnit[$E]) // $A = 10; $E = 14
endfunction

function Trig_Shrine_AbilitySwap_IsSlot1Pick takes nothing returns boolean
    return(Trig_Shrine_AbilitySwap_IsSlot1Menu())
endfunction

function Trig_Shrine_AbilitySwap_IsFreelancer takes nothing returns boolean
    return(GetUnitName(udg_CurrentHero)=="Freelancer")
endfunction

function Trig_Shrine_AbilitySwap_HasJobLevel50 takes nothing returns boolean
    // ((GetUnitPointValue(GetSoldUnit())) minus (1)) divided by (5).
    return(Job_GetSavedLevel(GetOwningPlayer(GetSoldUnit()),udg_JobUnitType[((GetUnitPointValue(GetSoldUnit())-1)/ 5)])>=50)
endfunction

function Trig_Shrine_AbilitySwap_IsShrineBuyerHero takes nothing returns boolean
    return(GetBuyingUnit()==udg_CurrentHero)or(GetBuyingUnit()==udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetSoldUnit()))])
endfunction

function Trig_Shrine_AbilitySwap_IsShrineBuyerValid takes nothing returns boolean
    return(GetBuyingUnit()!=null)and(IsUnitHiddenBJ(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))==false)and(Trig_Shrine_AbilitySwap_IsShrineBuyerHero())
endfunction

function Trig_Shrine_AbilitySwap_IsSecondMainMenu takes nothing returns boolean
    return(GetSellingUnit()==udg_ShrineMenuUnit[9])
endfunction

function Trig_Shrine_AbilitySwap_IsFirstMainMenu takes nothing returns boolean
    return(GetSellingUnit()==udg_ShrineMenuUnit[0])
endfunction

function Trig_Shrine_AbilitySwap_NotMasterEnough takes nothing returns boolean
    return(GetUnitName(udg_CurrentHero)!="Freelancer")and(GetHeroLevel(udg_CurrentHero)<50)
endfunction

function Trig_Shrine_AbilitySwap_IsLegendaryMenu takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n0KM') // 'n0KM': unit "Shrine of Individuality"
endfunction

function Trig_Shrine_AbilitySwap_IsSecondShrineUnit takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SecondShrineUnits))
endfunction

function Trig_Shrine_AbilitySwap_MasteryBelowFour takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',udg_CurrentHero)<4) // 'A02F': ability "Mastery"
endfunction

function Trig_Shrine_AbilitySwap_IsLegendaryButton takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n0KL') // 'n0KL': unit "Legendary Bonus Menu"
endfunction

function Trig_Shrine_AbilitySwap_AtSecondShrineMenu takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SecondShrineUnits))
endfunction

function Trig_Shrine_AbilitySwap_IsAbilityMenuButton takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n07I')or(GetUnitTypeId(GetSoldUnit())=='n076') // 'n07I': unit "Ability Menu"; 'n076': unit "Return to Abilities"
endfunction

function Trig_Shrine_AbilitySwap_IsAbilityMenuPick takes nothing returns boolean
    return(Trig_Shrine_AbilitySwap_IsAbilityMenuButton())
endfunction

function Trig_Shrine_AbilitySwap_IsReturnButton takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n077') // 'n077': unit "Return to Main Menu"
endfunction

function Trig_Shrine_AbilitySwap_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Shrine_SelectMenu)
    call EnableTrigger(gg_trg_Shrine_SelectEnable)
    call StartTimerBJ(udg_ShrineReselectTimer,false,5.)
    call ShowUnitHide(GetSoldUnit())
    call UnitApplyTimedLifeBJ(.21,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    if(Trig_Shrine_AbilitySwap_IsReturnButton())then
        if(Trig_Shrine_AbilitySwap_IsSecondShrine())then
            call SelectUnitForPlayerSingle(gg_unit_n04U_0189,GetOwningPlayer(GetSoldUnit()))
        else
            call SelectUnitForPlayerSingle(gg_unit_n04U_0204,GetOwningPlayer(GetSoldUnit()))
        endif
    else
        if(Trig_Shrine_AbilitySwap_IsAbilityMenuPick())then
            if(Trig_Shrine_AbilitySwap_AtSecondShrineMenu())then
                call SelectUnitForPlayerSingle(udg_ShrineMenuUnit[9],GetOwningPlayer(GetSoldUnit()))
            else
                call SelectUnitForPlayerSingle(udg_ShrineMenuUnit[0],GetOwningPlayer(GetSoldUnit()))
            endif
        else
            set udg_CurrentHero=Player_GetHero(GetOwningPlayer(GetSoldUnit()))
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
            if(Trig_Shrine_AbilitySwap_IsLegendaryButton())then
                if(Trig_Shrine_AbilitySwap_MasteryBelowFour())then
                    call DisplayTextToForce(udg_TempForce,"Your hero has not yet reached Legendary Mastery in this job!")
                else
                    if(Trig_Shrine_AbilitySwap_IsSecondShrineUnit())then
                        call SelectUnitForPlayerSingle(udg_ShrineMenuUnit[19],GetOwningPlayer(GetSoldUnit()))
                    else
                        call SelectUnitForPlayerSingle(udg_ShrineMenuUnit[18],GetOwningPlayer(GetSoldUnit()))
                    endif
                endif
            else
                if(Trig_Shrine_AbilitySwap_IsLegendaryMenu())then
                    if(Trig_Shrine_AbilitySwap_NotLegendaryMaster())then
                        call DisplayTextToForce(udg_TempForce,"Your hero has not yet reached Legendary Mastery in this job!")
                    else
                        if(Trig_Shrine_AbilitySwap_BonusAlreadyActive())then
                            call DisplayTextToForce(udg_TempForce,"You are already using this Legendary Mastery bonus.")
                        else
                            if(Trig_Shrine_AbilitySwap_CurrentBonusIsFour())then
                                call ModifyHeroStat(bj_HEROSTAT_STR,udg_CurrentHero,bj_MODIFYMETHOD_SUB,$A) // $A = 10
                                call ModifyHeroStat(bj_HEROSTAT_AGI,udg_CurrentHero,bj_MODIFYMETHOD_SUB,$A) // $A = 10
                                call ModifyHeroStat(bj_HEROSTAT_INT,udg_CurrentHero,bj_MODIFYMETHOD_SUB,$A) // $A = 10
                            else
                                call UnitRemoveAbilityBJ(udg_MasteryBonusAbility[GetUnitAbilityLevelSwapped('A02F',udg_CurrentHero)],udg_CurrentHero) // 'A02F': ability "Mastery"
                            endif
                            if(Trig_Shrine_AbilitySwap_BonusIsFour())then
                                call ModifyHeroStat(bj_HEROSTAT_STR,udg_CurrentHero,bj_MODIFYMETHOD_ADD,$A) // $A = 10
                                call ModifyHeroStat(bj_HEROSTAT_AGI,udg_CurrentHero,bj_MODIFYMETHOD_ADD,$A) // $A = 10
                                call ModifyHeroStat(bj_HEROSTAT_INT,udg_CurrentHero,bj_MODIFYMETHOD_ADD,$A) // $A = 10
                            else
                                call UnitAddAbilityBJ(udg_MasteryBonusAbility[GetUnitPointValue(GetSoldUnit())],udg_CurrentHero)
                            endif
                            call DisplayTimedTextToForce(udg_TempForce,10.,((("|cff00ff00"+GetUnitName(udg_CurrentHero))+" now uses Legendary Bonus |cffffcc00")+(GetUnitName(GetSoldUnit())+"|cff00ff00!|r")))
                            call SetUnitAbilityLevelSwapped('A02F',udg_CurrentHero,GetUnitPointValue(GetSoldUnit())) // 'A02F': ability "Mastery"
                        endif
                    endif
                else
                    if(Trig_Shrine_AbilitySwap_NotMasterEnough())then
                        call DisplayTextToForce(udg_TempForce,"Jobs besides the Freelancer must be Master to swap out an ability!")
                    else
                        if(Trig_Shrine_AbilitySwap_IsFirstMainMenu())then
                            call SelectUnitForPlayerSingle(udg_ShrineMenuUnit[GetUnitPointValue(GetSoldUnit())],GetOwningPlayer(GetSoldUnit()))
                        else
                            if(Trig_Shrine_AbilitySwap_IsSecondMainMenu())then
                                // (GetUnitPointValue(GetSoldUnit())) plus (9).
                                call SelectUnitForPlayerSingle(udg_ShrineMenuUnit[(GetUnitPointValue(GetSoldUnit())+9)],GetOwningPlayer(GetSoldUnit()))
                            else
                                if(Trig_Shrine_AbilitySwap_IsShrineBuyerValid())then
                                    if(Trig_Shrine_AbilitySwap_HasJobLevel50())then
                                        set udg_TempInteger=GetConvertedPlayerId(GetOwningPlayer(GetSoldUnit()))
                                        if(Trig_Shrine_AbilitySwap_IsFreelancer())then
                                            if(Trig_Shrine_AbilitySwap_IsSlot1Pick())then
                                                if(Trig_Shrine_AbilitySwap_Slot1Enchant())then
                                                    call UnitRemoveAbilityBJ('A0SI',udg_CurrentHero) // 'A0SI': ability "Enchantment Variant"
                                                else
                                                    if(Trig_Shrine_AbilitySwap_Slot1Alchemy())then
                                                        call UnitRemoveAbilityBJ('A1AJ',udg_CurrentHero) // 'A1AJ': ability "Alchemy"
                                                    endif
                                                endif
                                                call UnitRemoveAbilityBJ(udg_JobSkill[udg_AbilitySlot1[udg_TempInteger]],udg_CurrentHero)
                                                set udg_AbilitySlot1[udg_TempInteger]=GetUnitPointValue(GetSoldUnit())
                                                call UnitAddAbilityBJ(udg_JobSkill[udg_AbilitySlot1[udg_TempInteger]],udg_CurrentHero)
                                                call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_AbilitySlot1[udg_TempInteger]],udg_CurrentHero,$A) // $A = 10
                                                if(Trig_Shrine_AbilitySwap_NewSlot1Enchant())then
                                                    call BlzSetAbilityIcon('A0S8',BlzGetAbilityIcon(udg_EnchantAbility[1])) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],9),9) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],9),9) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],$A),$A) // 'A0S8': ability "Enfire"; $A = 10
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],$A),$A) // 'A0S8': ability "Enfire"; $A = 10
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],$B),$B) // 'A0S8': ability "Enfire"; $B = 11
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],$B),$B) // 'A0S8': ability "Enfire"; $B = 11
                                                else
                                                    if(Trig_Shrine_AbilitySwap_SwapSlot1Alchemy())then
                                                        call UnitAddAbilityBJ('A1AJ',udg_CurrentHero) // 'A1AJ': ability "Alchemy"
                                                    endif
                                                endif
                                            else
                                                if(Trig_Shrine_AbilitySwap_IsSlot2Pick())then
                                                    call UnitRemoveAbilityBJ(udg_JobSkill[udg_AbilitySlot2[udg_TempInteger]],udg_CurrentHero)
                                                    set udg_AbilitySlot2[udg_TempInteger]=GetUnitPointValue(GetSoldUnit())
                                                    call UnitAddAbilityBJ(udg_JobSkill[udg_AbilitySlot2[udg_TempInteger]],udg_CurrentHero)
                                                    call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_AbilitySlot2[udg_TempInteger]],udg_CurrentHero,$A) // $A = 10
                                                    if(Trig_Shrine_AbilitySwap_HasSummon())then
                                                        call UnitApplyTimedLifeBJ(.01,'BTLF',udg_SummonUnit[udg_TempInteger]) // 'BTLF': object name not found in map data
                                                    endif
                                                else
                                                    if(Trig_Shrine_AbilitySwap_IsSlot3Pick())then
                                                        call UnitRemoveAbilityBJ(udg_JobSkill[udg_AbilitySlot3[udg_TempInteger]],udg_CurrentHero)
                                                        set udg_AbilitySlot3[udg_TempInteger]=GetUnitPointValue(GetSoldUnit())
                                                        call UnitAddAbilityBJ(udg_JobSkill[udg_AbilitySlot3[udg_TempInteger]],udg_CurrentHero)
                                                        call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_AbilitySlot3[udg_TempInteger]],udg_CurrentHero,$A) // $A = 10
                                                        if(Trig_Shrine_AbilitySwap_HasPetUnit())then
                                                            call UnitApplyTimedLifeBJ(.01,'BTLF',udg_PetUnit[udg_TempInteger]) // 'BTLF': object name not found in map data
                                                        endif
                                                    else
                                                        if(Trig_Shrine_AbilitySwap_IsSlot4Pick())then
                                                            call UnitRemoveAbilityBJ(udg_JobSkill[udg_AbilitySlot4[udg_TempInteger]],udg_CurrentHero)
                                                            set udg_AbilitySlot4[udg_TempInteger]=GetUnitPointValue(GetSoldUnit())
                                                            call UnitAddAbilityBJ(udg_JobSkill[udg_AbilitySlot4[udg_TempInteger]],udg_CurrentHero)
                                                            call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_AbilitySlot4[udg_TempInteger]],udg_CurrentHero,$A) // $A = 10
                                                        endif
                                                    endif
                                                endif
                                            endif
                                        else
                                            if(Trig_Shrine_AbilitySwap_HasBorrowedPair())then
                                                if(Trig_Shrine_AbilitySwap_MainIsEnchant())then
                                                    call UnitRemoveAbilityBJ('A0SI',udg_CurrentHero) // 'A0SI': ability "Enchantment Variant"
                                                else
                                                    if(Trig_Shrine_AbilitySwap_MainIsAlchemy())then
                                                        call UnitRemoveAbilityBJ('A1AJ',udg_CurrentHero) // 'A1AJ': ability "Alchemy"
                                                    endif
                                                endif
                                                call UnitRemoveAbilityBJ(udg_JobSkill[udg_MainSkillSlot[udg_TempInteger]],udg_CurrentHero)
                                                call BlzUnitDisableAbility(udg_CurrentHero,udg_JobSkill[udg_SubSkillSlot[udg_TempInteger]],false,false)
                                                if(Trig_Shrine_AbilitySwap_SubIsAlchemy())then
                                                    call UnitAddAbilityBJ('A1AI',udg_CurrentHero) // 'A1AI': ability "Alchemy"
                                                endif
                                            endif
                                            set udg_MainSkillSlot[udg_TempInteger]=GetUnitPointValue(GetSoldUnit())
                                            if(Trig_Shrine_AbilitySwap_NeedsSummonCleanup())then
                                                call UnitApplyTimedLifeBJ(.01,'BTLF',udg_SummonUnit[udg_TempInteger]) // 'BTLF': object name not found in map data
                                            endif
                                            if(Trig_Shrine_AbilitySwap_NeedsPetCleanup())then
                                                call UnitApplyTimedLifeBJ(.01,'BTLF',udg_PetUnit[udg_TempInteger]) // 'BTLF': object name not found in map data
                                            endif
                                            set udg_SubSkillSlot[udg_TempInteger]=Job_GetIndex(udg_CurrentHero)
                                            // Result 1: (udg_SubSkillSlot at position udg_TempInteger) times (5).
                                            // Result 2: the remainder after dividing (udg_MainSkillSlot at position udg_TempInteger) by (5).
                                            // Result 3: (result 1) plus (result 2).
                                            set udg_SubSkillSlot[udg_TempInteger]=((udg_SubSkillSlot[udg_TempInteger]*5)+ModuloInteger(udg_MainSkillSlot[udg_TempInteger],5))
                                            if(Trig_Shrine_AbilitySwap_MainDiffersFromSub())then
                                                if(Trig_Shrine_AbilitySwap_SubWasEnchant())then
                                                    call UnitRemoveAbilityBJ('A0SI',udg_CurrentHero) // 'A0SI': ability "Enchantment Variant"
                                                    call BlzSetAbilityIcon('A0S8',BlzGetAbilityIcon(udg_EnchantAbility[1])) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],9),9) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],9),9) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],$A),$A) // 'A0S8': ability "Enfire"; $A = 10
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],$A),$A) // 'A0S8': ability "Enfire"; $A = 10
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],$B),$B) // 'A0S8': ability "Enfire"; $B = 11
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],$B),$B) // 'A0S8': ability "Enfire"; $B = 11
                                                else
                                                    if(Trig_Shrine_AbilitySwap_SubWasAlchemy())then
                                                        call UnitRemoveAbilityBJ('A1AI',udg_CurrentHero) // 'A1AI': ability "Alchemy"
                                                    endif
                                                endif
                                                call BlzUnitDisableAbility(udg_CurrentHero,udg_JobSkill[udg_SubSkillSlot[udg_TempInteger]],true,true)
                                                call UnitAddAbilityBJ(udg_JobSkill[udg_MainSkillSlot[udg_TempInteger]],udg_CurrentHero)
                                                call SetUnitAbilityLevelSwapped(udg_JobSkill[udg_MainSkillSlot[udg_TempInteger]],udg_CurrentHero,$A) // $A = 10
                                                if(Trig_Shrine_AbilitySwap_MainWasEnchant())then
                                                    call BlzSetAbilityIcon('A0S8',BlzGetAbilityIcon(udg_EnchantAbility[1])) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],9),9) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],9),9) // 'A0S8': ability "Enfire"
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],$A),$A) // 'A0S8': ability "Enfire"; $A = 10
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],$A),$A) // 'A0S8': ability "Enfire"; $A = 10
                                                    call BlzSetAbilityTooltip('A0S8',BlzGetAbilityTooltip(udg_EnchantAbility[1],$B),$B) // 'A0S8': ability "Enfire"; $B = 11
                                                    call BlzSetAbilityExtendedTooltip('A0S8',BlzGetAbilityExtendedTooltip(udg_EnchantAbility[1],$B),$B) // 'A0S8': ability "Enfire"; $B = 11
                                                else
                                                    if(Trig_Shrine_AbilitySwap_MainWasAlchemy())then
                                                        call UnitAddAbilityBJ('A1AJ',udg_CurrentHero) // 'A1AJ': ability "Alchemy"
                                                    endif
                                                endif
                                            else
                                                set udg_MainSkillSlot[udg_TempInteger]=0
                                                set udg_SubSkillSlot[udg_TempInteger]=0
                                            endif
                                        endif
                                        call DisplayTimedTextToForce(udg_TempForce,10.,((("|cff00ff00"+GetUnitName(udg_CurrentHero))+" now uses ability |cffffcc00")+(GetUnitName(GetSoldUnit())+"|cff00ff00!|r")))
                                        set udg_DispelTarget=udg_CurrentHero
                                        call ConditionalTriggerExecute(gg_trg_Remove_Buffs)
                                    else
                                        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000ERROR:|r You need to be Master in the class that uses this skill to use it on another job!")
                                    endif
                                else
                                    call DisplayTextToForce(udg_TempForce,"The unit interacting with the shrine is not your hero.")
                                endif
                            endif
                        endif
                    endif
                endif
            endif
            call DestroyForce(udg_TempForce)
        endif
    endif
endfunction

function Trig_Shrine_SelectEnable_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call EnableTrigger(gg_trg_Shrine_SelectMenu)
endfunction

function Trig_Shrine_SelectMenu_IsMenuUnit takes nothing returns boolean
    return(GetTriggerUnit()==udg_ShrineMenuUnit[0])or(GetTriggerUnit()==udg_ShrineMenuUnit[1])or(GetTriggerUnit()==udg_ShrineMenuUnit[2])or(GetTriggerUnit()==udg_ShrineMenuUnit[3])or(GetTriggerUnit()==udg_ShrineMenuUnit[4])or(GetTriggerUnit()==udg_ShrineMenuUnit[5])or(GetTriggerUnit()==udg_ShrineMenuUnit[6])or(GetTriggerUnit()==udg_ShrineMenuUnit[7])or(GetTriggerUnit()==udg_ShrineMenuUnit[8])or(GetTriggerUnit()==udg_ShrineMenuUnit[9])or(GetTriggerUnit()==udg_ShrineMenuUnit[$A])or(GetTriggerUnit()==udg_ShrineMenuUnit[$B])or(GetTriggerUnit()==udg_ShrineMenuUnit[$C])or(GetTriggerUnit()==udg_ShrineMenuUnit[$D])or(GetTriggerUnit()==udg_ShrineMenuUnit[$E])or(GetTriggerUnit()==udg_ShrineMenuUnit[$F])or(GetTriggerUnit()==udg_ShrineMenuUnit[16])or(GetTriggerUnit()==udg_ShrineMenuUnit[17])or(GetTriggerUnit()==udg_ShrineMenuUnit[18])or(GetTriggerUnit()==udg_ShrineMenuUnit[19]) // $A = 10; $B = 11; $C = 12; $D = 13; $E = 14; $F = 15
endfunction

function Trig_Shrine_SelectMenu_Conditions takes nothing returns boolean
    return(Trig_Shrine_SelectMenu_IsMenuUnit())
endfunction

function Trig_Shrine_SelectMenu_AtSecondShrine takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SecondShrineUnits))
endfunction

function Trig_Shrine_SelectMenu_Actions takes nothing returns nothing
    if(Trig_Shrine_SelectMenu_AtSecondShrine())then
        call SelectUnitForPlayerSingle(gg_unit_n04U_0189,GetTriggerPlayer())
    else
        call SelectUnitForPlayerSingle(gg_unit_n04U_0204,GetTriggerPlayer())
    endif
endfunction

function Trig_Shrine_Unlock_Actions takes nothing returns nothing
    set udg_ShrineUnlocked=true
    call EnableTrigger(gg_trg_Shrine_Reveal)
    call ShowUnitShow(gg_unit_n04U_0204)
    call ShowUnitShow(udg_ShrineMenuUnit[0])
    call ShowUnitShow(udg_ShrineMenuUnit[1])
    call ShowUnitShow(udg_ShrineMenuUnit[2])
    call ShowUnitShow(udg_ShrineMenuUnit[3])
    call ShowUnitShow(udg_ShrineMenuUnit[4])
    call ShowUnitShow(udg_ShrineMenuUnit[5])
    call ShowUnitShow(udg_ShrineMenuUnit[6])
    call ShowUnitShow(udg_ShrineMenuUnit[7])
    call ShowUnitShow(udg_ShrineMenuUnit[8])
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Shrine_Reveal_Conditions takes nothing returns boolean
    return(udg_ShrineUnlocked)
endfunction

function Trig_Shrine_Reveal_SetFoodCap21 takes nothing returns nothing
    call SetPlayerStateBJ(GetEnumPlayer(),PLAYER_STATE_RESOURCE_FOOD_CAP,21)
endfunction

function Trig_Shrine_Reveal_SetFoodCap23 takes nothing returns nothing
    call SetPlayerStateBJ(GetEnumPlayer(),PLAYER_STATE_RESOURCE_FOOD_CAP,23)
endfunction

function Trig_Shrine_Reveal_IsDarkJobsUnlocked takes nothing returns boolean
    return(udg_DarkJobsUnlocked)
endfunction

function Trig_Shrine_Reveal_RevealShrine takes nothing returns nothing
    call CreateFogModifierRadiusLocBJ(true,GetEnumPlayer(),FOG_OF_WAR_VISIBLE,udg_TempPoint,256.)
endfunction

function Trig_Shrine_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Shrine_Reveal_IsDarkJobsUnlocked())then
        call ForForce(udg_PlayingPlayers,function Trig_Shrine_Reveal_SetFoodCap23)
    else
        call ForForce(udg_PlayingPlayers,function Trig_Shrine_Reveal_SetFoodCap21)
    endif
    set udg_TempPoint=GetUnitLoc(gg_unit_n04U_0204)
    call ForForce(udg_PlayingPlayers,function Trig_Shrine_Reveal_RevealShrine)
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Shrine takes nothing returns nothing
endfunction

function RegisterR11_Shrine_Create takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Shrine_Create=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Shrine_Create,2.)

call TriggerAddAction(gg_trg_Shrine_Create,function Trig_Shrine_Create_Actions)

endfunction




function RegisterR11_Shrine_AbilitySwap takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Shrine_AbilitySwap=CreateTrigger()

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Shrine_AbilitySwap,Player(PLAYER_NEUTRAL_PASSIVE),EVENT_PLAYER_UNIT_SELL)

call TriggerAddCondition(gg_trg_Shrine_AbilitySwap,Condition(function Trig_Shrine_AbilitySwap_Conditions))

call TriggerAddAction(gg_trg_Shrine_AbilitySwap,function Trig_Shrine_AbilitySwap_Actions)

endfunction




function RegisterR11_Shrine_SelectEnable takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Shrine_SelectEnable=CreateTrigger()

call DisableTrigger(gg_trg_Shrine_SelectEnable)

call TriggerRegisterTimerExpireEventBJ(gg_trg_Shrine_SelectEnable,udg_ShrineReselectTimer)

call TriggerAddAction(gg_trg_Shrine_SelectEnable,function Trig_Shrine_SelectEnable_Actions)

endfunction




function RegisterR11_Shrine_SelectMenu takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Shrine_SelectMenu=CreateTrigger()

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shrine_SelectMenu,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shrine_SelectMenu,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shrine_SelectMenu,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shrine_SelectMenu,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shrine_SelectMenu,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shrine_SelectMenu,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shrine_SelectMenu,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shrine_SelectMenu,Player(7),true)

call TriggerAddCondition(gg_trg_Shrine_SelectMenu,Condition(function Trig_Shrine_SelectMenu_Conditions))

call TriggerAddAction(gg_trg_Shrine_SelectMenu,function Trig_Shrine_SelectMenu_Actions)

endfunction




function RegisterR11_Shrine_Unlock takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Shrine_Unlock=CreateTrigger()

call DisableTrigger(gg_trg_Shrine_Unlock)

call TriggerAddAction(gg_trg_Shrine_Unlock,function Trig_Shrine_Unlock_Actions)

endfunction




function RegisterR11_Shrine_Reveal takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Shrine_Reveal=CreateTrigger()

call DisableTrigger(gg_trg_Shrine_Reveal)

call TriggerRegisterTimerEventPeriodic(gg_trg_Shrine_Reveal,12.)

call TriggerAddCondition(gg_trg_Shrine_Reveal,Condition(function Trig_Shrine_Reveal_Conditions))

call TriggerAddAction(gg_trg_Shrine_Reveal,function Trig_Shrine_Reveal_Actions)

endfunction




endlibrary
