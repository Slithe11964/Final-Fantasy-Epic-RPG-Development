library TShadowHiring requires TForce, TMusic, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Shadow_Hire=null
    trigger gg_trg_Shadow_Disband=null
endglobals

function Trig_Shadow_Hire_IsHireOffer takes nothing returns boolean
    // Calculation 1:
    // (udg_ShadowOfferTier) plus (1).
    // Calculation 2:
    // (udg_ShadowOfferTier) plus (2).
    return(GetUnitTypeId(GetSoldUnit())==udg_ShadowHireOffer[udg_ShadowOfferTier])or(GetUnitTypeId(GetSoldUnit())==udg_ShadowHireOffer[(udg_ShadowOfferTier+1)])or(GetUnitTypeId(GetSoldUnit())==udg_ShadowHireOffer[(udg_ShadowOfferTier+2)])or(GetUnitTypeId(GetSoldUnit())=='n085') // 'n085': unit "Hiring Shadow For Free"
endfunction

function Trig_Shadow_Hire_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_ShadowUnit)and(Trig_Shadow_Hire_IsHireOffer())
endfunction

function Trig_Shadow_Hire_IsLoyaltyCapped takes nothing returns boolean
    return(udg_ShadowLoyalty>280)
endfunction

function Trig_Shadow_Hire_IsFreeHireCap takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n085') // 'n085': unit "Hiring Shadow For Free"
endfunction

function Trig_Shadow_Hire_IsLoyaltyAbove160 takes nothing returns boolean
    return(udg_ShadowLoyalty>$A0) // $A0 = 160
endfunction

function Trig_Shadow_Hire_AddPartyHeroLevel takes nothing returns nothing
    // (udg_TempInteger) plus (hero level of udg_SpiritOfGaya at position GetConvertedPlayerId(the player being
    // visited)).
    set udg_TempInteger=(udg_TempInteger+GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())]))
endfunction

function Trig_Shadow_Hire_IsFreeHireGreeting takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n085') // 'n085': unit "Hiring Shadow For Free"
endfunction

function Trig_Shadow_Hire_IsLoyaltyDrained takes nothing returns boolean
    return(udg_ShadowLoyalty<=0)
endfunction

function Trig_Shadow_Hire_ShareShadowVision takes nothing returns nothing
    call UnitShareVisionBJ(true,udg_ShadowUnit,GetEnumPlayer())
endfunction

function Trig_Shadow_Hire_IsThirdOffer takes nothing returns boolean
    // (udg_ShadowOfferTier) plus (2).
    return(GetUnitTypeId(GetSoldUnit())==udg_ShadowHireOffer[(udg_ShadowOfferTier+2)])
endfunction

function Trig_Shadow_Hire_IsSecondOffer takes nothing returns boolean
    // (udg_ShadowOfferTier) plus (1).
    return(GetUnitTypeId(GetSoldUnit())==udg_ShadowHireOffer[(udg_ShadowOfferTier+1)])
endfunction

function Trig_Shadow_Hire_IsFirstOffer takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())==udg_ShadowHireOffer[udg_ShadowOfferTier])
endfunction

function Trig_Shadow_Hire_IsLoyaltyUnder100 takes nothing returns boolean
    return(udg_ShadowLoyalty<'d')
endfunction

function Trig_Shadow_Hire_IsLoyaltyCappedAfterReward takes nothing returns boolean
    return(udg_ShadowLoyalty>280)
endfunction

function Trig_Shadow_Hire_IsLoyaltyAbove160Paid takes nothing returns boolean
    return(udg_ShadowLoyalty>$A0) // $A0 = 160
endfunction

function Trig_Shadow_Hire_IsFreeHireReward takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n085') // 'n085': unit "Hiring Shadow For Free"
endfunction

function Trig_Shadow_Hire_AddPlayerToPool takes nothing returns nothing
    call ForceAddPlayerSimple(GetEnumPlayer(),udg_ShadowLevelPool)
endfunction

function Trig_Shadow_Hire_IsHeroLevelLower takes nothing returns boolean
    return(GetHeroLevel(Player_GetHero(GetEnumPlayer()))<udg_TempInteger)
endfunction

function Trig_Shadow_Hire_TakeLowestHero takes nothing returns nothing
    if(Trig_Shadow_Hire_IsHeroLevelLower())then
        set udg_TempInteger=GetHeroLevel(Player_GetHero(GetEnumPlayer()))
        set udg_TempPlayer=GetEnumPlayer()
    endif
endfunction

function Trig_Shadow_Hire_AddPoolHeroLevel takes nothing returns nothing
    // (udg_TempInteger) plus (hero level of Player_GetHero(the player being visited)).
    set udg_TempInteger=(udg_TempInteger+GetHeroLevel(Player_GetHero(GetEnumPlayer())))
endfunction

function Trig_Shadow_Hire_IsSoloParty takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)==1)
endfunction

function Trig_Shadow_Hire_IsOldPatchFumaLevel takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Shadow_Hire_IsOldPatchFumaMax takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Shadow_Hire_IsFumaMastered takes nothing returns boolean
    return(udg_TempInteger>=90)and(udg_ShadowLoyalty>=$80) // $80 = 128
endfunction

function Trig_Shadow_Hire_IsOldPatchDexLevel takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Shadow_Hire_IsOldPatchDexMax takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Shadow_Hire_IsDexterityMastered takes nothing returns boolean
    // Result 1: (udg_TempInteger) divided by (18); drop the remainder.
    // Result 2: (udg_ShadowLoyalty) divided by (50); drop the remainder.
    // Result 3: (result 1) plus (result 2).
    return(((udg_TempInteger/ 18)+(udg_ShadowLoyalty/ 50))>=$A) // $A = 10
endfunction

function Trig_Shadow_Hire_IsDuoParty takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)==2)
endfunction

function Trig_Shadow_Hire_IsSoloPartySpeed takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)==1)
endfunction

function Trig_Shadow_Hire_HasDancingDaggers takes nothing returns boolean
    // Result 1: (udg_TempInteger) divided by (30); drop the remainder.
    // Result 2: (udg_ShadowLoyalty) divided by (20); drop the remainder.
    // Result 3: (result 1) plus (result 2).
    return(((udg_TempInteger/ 30)+(udg_ShadowLoyalty/ 20))>3)
endfunction

function Trig_Shadow_Hire_HasKatanaForTier takes nothing returns boolean
    // ((udg_TempInteger) plus (1)) divided by (10); drop the remainder.
    return(udg_ShadowKatana[((udg_TempInteger+1)/ $A)]!='tkno') // $A = 10; 'tkno': object name not found in map data
endfunction

function Trig_Shadow_Hire_HasDaggerForTier takes nothing returns boolean
    // ((udg_TempInteger) plus (3)) divided by (10); drop the remainder.
    return(udg_ShadowDagger[((udg_TempInteger+3)/ $A)]!='tkno') // $A = 10; 'tkno': object name not found in map data
endfunction

function Trig_Shadow_Hire_HasHelmetForTier takes nothing returns boolean
    // ((udg_TempInteger) plus (5)) divided by (10); drop the remainder.
    return(udg_ShadowHelmet[((udg_TempInteger+5)/ $A)]!='tkno') // $A = 10; 'tkno': object name not found in map data
endfunction

function Trig_Shadow_Hire_HasArmorForTier takes nothing returns boolean
    // ((udg_TempInteger) minus (1)) divided by (10); drop the remainder.
    return(udg_ShadowArmor[((udg_TempInteger-1)/ $A)]!='tkno') // $A = 10; 'tkno': object name not found in map data
endfunction

function Trig_Shadow_Hire_IsFreeHireGear takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n085') // 'n085': unit "Hiring Shadow For Free"
endfunction

function Trig_Shadow_Hire_HasPotionForTier takes nothing returns boolean
    // ((udg_TempInteger) plus (7)) divided by (10); drop the remainder.
    return(udg_ShadowPotion[((udg_TempInteger+7)/ $A)]!='tkno') // $A = 10; 'tkno': object name not found in map data
endfunction

function Trig_Shadow_Hire_IsBoughtBySpirit takes nothing returns boolean
    return(GetUnitTypeId(GetBuyingUnit())=='H01D') // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Shadow_Hire_IsOfferRefused takes nothing returns boolean
    // (udg_TempInteger) divided by (CountPlayersInForceBJ(udg_PlayingPlayers)); drop the remainder.
    return(GetUnitTypeId(GetSoldUnit())==udg_ShadowHireOffer[udg_ShadowOfferTier])and(udg_ShadowLoyalty<(udg_TempInteger/ CountPlayersInForceBJ(udg_PlayingPlayers)))
endfunction

function Trig_Shadow_Hire_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Shadow_NearbyDelay)
    call DisableTrigger(gg_trg_Shadow_Leave)
    if(Trig_Shadow_Hire_IsLoyaltyAbove160())then
        if(Trig_Shadow_Hire_IsFreeHireCap())then
            if(Trig_Shadow_Hire_IsLoyaltyCapped())then
                set udg_ShadowLoyalty=280
            endif
        else
            set udg_ShadowLoyalty=$A0 // $A0 = 160
        endif
    endif
    set udg_TempInteger=0
    call ForForce(udg_PlayingPlayers,function Trig_Shadow_Hire_AddPartyHeroLevel)
    if(Trig_Shadow_Hire_IsOfferRefused())then
        call AdjustPlayerStateBJ(GetUnitPointValue(GetSoldUnit()),GetOwningPlayer(GetBuyingUnit()),PLAYER_STATE_RESOURCE_GOLD)
        call RemoveUnit(GetSoldUnit())
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetBuyingUnit()))
        call TransmissionFromUnitWithNameBJ(udg_TempForce,udg_ShadowUnit,"Shadow",null,"I refuse your offer. Who do you take me for?",bj_TIMETYPE_SET,7.5,false)
        call DestroyForce(udg_TempForce)
        set udg_TempPoint=GetUnitLoc(udg_ShadowUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call RemoveUnit(udg_ShadowUnit)
        // Decrease udg_ShadowLoyalty by 6.
        set udg_ShadowLoyalty=(udg_ShadowLoyalty-6)
        if(Trig_Shadow_Hire_IsLoyaltyDrained())then
            call ConditionalTriggerExecute(gg_trg_Shadow_Disband)
        else
            call StartTimerBJ(udg_ShadowTimer,false,60.)
            call EnableTrigger(gg_trg_Shadow_Respawn)
        endif
    else
        set udg_ShadowUnit=ReplaceUnitBJ(udg_ShadowUnit,'E00S',bj_UNIT_STATE_METHOD_MAXIMUM) // 'E00S': unit "Assassin"
        call SetUnitOwner(udg_ShadowUnit,Player($A),false) // $A = 10
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetBuyingUnit()))
        if(Trig_Shadow_Hire_IsFreeHireGreeting())then
            call TransmissionFromUnitWithNameBJ(udg_TempForce,udg_ShadowUnit,"Shadow",null,"Of course. Let us fight alongside each other once more.",bj_TIMETYPE_SET,5.,false)
        else
            call TransmissionFromUnitWithNameBJ(udg_TempForce,udg_ShadowUnit,"Shadow",null,"Adequate. I will lend you my blade for a while.",bj_TIMETYPE_SET,5.,false)
        endif
        call DestroyForce(udg_TempForce)
        call PauseTimerBJ(true,udg_ShadowTimer)
        call ForForce(udg_PlayingPlayers,function Trig_Shadow_Hire_ShareShadowVision)
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"Shadow joins your party.")
        set udg_ShadowKills=0
        if(Trig_Shadow_Hire_IsFirstOffer())then
            // Udg_ShadowLoyalty treated as a decimal-capable number.
            call UnitApplyTimedLifeBJ(I2R(udg_ShadowLoyalty),'BEfn',udg_ShadowUnit) // 'BEfn': buff tooltip "Time Limit"
            // Decrease udg_ShadowLoyalty by 12.
            set udg_ShadowLoyalty=(udg_ShadowLoyalty-$C) // $C = 12
        else
            if(Trig_Shadow_Hire_IsSecondOffer())then
                // (udg_ShadowLoyalty) plus (40) treated as a decimal-capable number.
                call UnitApplyTimedLifeBJ(I2R((udg_ShadowLoyalty+40)),'BEfn',udg_ShadowUnit) // 'BEfn': buff tooltip "Time Limit"
                // Increase udg_ShadowLoyalty by 2.
                set udg_ShadowLoyalty=(udg_ShadowLoyalty+2)
            else
                if(Trig_Shadow_Hire_IsThirdOffer())then
                    // (udg_ShadowLoyalty) plus (100) treated as a decimal-capable number.
                    call UnitApplyTimedLifeBJ(I2R((udg_ShadowLoyalty+'d')),'BEfn',udg_ShadowUnit) // 'BEfn': buff tooltip "Time Limit"
                    // Increase udg_ShadowLoyalty by 12.
                    set udg_ShadowLoyalty=(udg_ShadowLoyalty+$C) // $C = 12
                else
                    // (udg_ShadowLoyalty) plus (270) treated as a decimal-capable number.
                    call UnitApplyTimedLifeBJ(I2R((udg_ShadowLoyalty+270)),'BEfn',udg_ShadowUnit) // 'BEfn': buff tooltip "Time Limit"
                    // Increase udg_ShadowLoyalty by 8.
                    set udg_ShadowLoyalty=(udg_ShadowLoyalty+8)
                endif
            endif
        endif
        if(Trig_Shadow_Hire_IsFreeHireReward())then
            call Music_ClearTrack(32)
            if(Trig_Shadow_Hire_IsLoyaltyCappedAfterReward())then
                set udg_ShadowLoyalty=280
            else
                if(Trig_Shadow_Hire_IsLoyaltyUnder100())then
                    set udg_ShadowLoyalty='d'
                endif
            endif
        else
            if(Trig_Shadow_Hire_IsLoyaltyAbove160Paid())then
                set udg_ShadowLoyalty=$A0 // $A0 = 160
            endif
        endif
        call EnableTrigger(gg_trg_Shadow_KillCount)
        call EnableTrigger(gg_trg_Shadow_LoyaltyTick)
        call EnableTrigger(gg_trg_Shadow_HealedBonus)
        call EnableTrigger(gg_trg_Shadow_AttackedByParty)
        call EnableTrigger(gg_trg_Shadow_Death)
        if(Trig_Shadow_Hire_IsSoloParty())then
            // Result 1: the larger of (hero level of Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))) and (1).
            // Result 2: the smaller of (result 1) and (99).
            set udg_TempInteger=IMinBJ(IMaxBJ(GetHeroLevel(Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))),1),99)
        else
            call ForceClear(udg_ShadowLevelPool)
            call ForForce(udg_PlayingPlayers,function Trig_Shadow_Hire_AddPlayerToPool)
            set bj_forLoopBIndex=1
            // (CountPlayersInForceBJ(udg_PlayingPlayers)) divided by (2); drop the remainder.
            set bj_forLoopBIndexEnd=(CountPlayersInForceBJ(udg_PlayingPlayers)/ 2)
            loop
                exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
                set udg_TempInteger='d'
                call ForForce(udg_ShadowLevelPool,function Trig_Shadow_Hire_TakeLowestHero)
                call ForceRemovePlayerSimple(udg_TempPlayer,udg_ShadowLevelPool)
                set bj_forLoopBIndex=bj_forLoopBIndex+1
            endloop
            set udg_TempInteger=0
            call ForForce(udg_ShadowLevelPool,function Trig_Shadow_Hire_AddPoolHeroLevel)
            // Result 1: (udg_TempInteger) divided by (CountPlayersInForceBJ(udg_ShadowLevelPool)); drop the remainder.
            // Result 2: the larger of (result 1) and (1).
            // Result 3: the smaller of (result 2) and (99).
            set udg_TempInteger=IMinBJ(IMaxBJ((udg_TempInteger/ CountPlayersInForceBJ(udg_ShadowLevelPool)),1),99)
        endif
        // Result 1: (udg_TempInteger) plus (25).
        // Result 2: (udg_ShadowLoyalty) divided by (result 1); drop the remainder.
        // Result 3: (result 2) minus (2).
        // Result 4: (udg_TempInteger) plus (result 3).
        // Result 5: the larger of (result 4) and (1).
        // Result 6: the smaller of (result 5) and (99).
        set udg_TempInteger=IMinBJ(IMaxBJ((udg_TempInteger+((udg_ShadowLoyalty/(udg_TempInteger+25))-2)),1),99)
        call SetHeroLevelBJ(udg_ShadowUnit,udg_TempInteger,false)
        call SuspendHeroXPBJ(false,udg_ShadowUnit)
        if(Trig_Shadow_Hire_IsFumaMastered())then
            if(Trig_Shadow_Hire_IsOldPatchFumaMax())then
                // (1) minus (1).
                call BlzSetAbilityTooltip('A0WS',"Fuma Shuriken (|cffffcc00Q|r) - [|cffffcc00MASTER|r]",(1-1)) // 'A0WS': ability "Fuma Shuriken"
            else
                call BlzSetAbilityTooltip('A0WS',"Fuma Shuriken (|cffffcc00Q|r) - [|cffffcc00MASTER|r]",1) // 'A0WS': ability "Fuma Shuriken"
            endif
        else
            if(Trig_Shadow_Hire_IsOldPatchFumaLevel())then
                // Calculation 1:
                // Result 1: (udg_TempInteger) divided by (10); drop the remainder.
                // Result 2: (udg_ShadowLoyalty) divided by (128); drop the remainder.
                // Result 3: (result 1) plus (result 2).
                // Result 4: (result 3) plus (1).
                // Result 5: the smaller of (10) and (result 4).
                // Result 6: the larger of (1) and (result 5).
                // Calculation 2:
                // (1) minus (1).
                call BlzSetAbilityTooltip('A0WS',("Fuma Shuriken (|cffffcc00Q|r) - [|cffffcc00Level "+(I2S(IMaxBJ(1,IMinBJ($A,(((udg_TempInteger/ $A)+(udg_ShadowLoyalty/ $80))+1))))+"|r]")),(1-1)) // 'A0WS': ability "Fuma Shuriken"; $A = 10; $80 = 128
            else
                // Result 1: (udg_TempInteger) divided by (10); drop the remainder.
                // Result 2: (udg_ShadowLoyalty) divided by (128); drop the remainder.
                // Result 3: (result 1) plus (result 2).
                // Result 4: (result 3) plus (1).
                // Result 5: the smaller of (10) and (result 4).
                // Result 6: the larger of (1) and (result 5).
                call BlzSetAbilityTooltip('A0WS',("Fuma Shuriken (|cffffcc00Q|r) - [|cffffcc00Level "+(I2S(IMaxBJ(1,IMinBJ($A,(((udg_TempInteger/ $A)+(udg_ShadowLoyalty/ $80))+1))))+"|r]")),1) // 'A0WS': ability "Fuma Shuriken"; $A = 10; $80 = 128
            endif
        endif
        if(Trig_Shadow_Hire_IsDexterityMastered())then
            if(Trig_Shadow_Hire_IsOldPatchDexMax())then
                // (1) minus (1).
                call BlzSetAbilityTooltip('A0R6',"Dexterity - [|cffffcc00MASTER|r]",(1-1)) // 'A0R6': ability "Dexterity"
            else
                call BlzSetAbilityTooltip('A0R6',"Dexterity - [|cffffcc00MASTER|r]",1) // 'A0R6': ability "Dexterity"
            endif
        else
            if(Trig_Shadow_Hire_IsOldPatchDexLevel())then
                // Calculation 1:
                // Result 1: (udg_TempInteger) divided by (18); drop the remainder.
                // Result 2: (udg_ShadowLoyalty) divided by (50); drop the remainder.
                // Result 3: (result 1) plus (result 2).
                // Result 4: (result 3) plus (1).
                // Result 5: the smaller of (10) and (result 4).
                // Result 6: the larger of (1) and (result 5).
                // Calculation 2:
                // (1) minus (1).
                call BlzSetAbilityTooltip('A0R6',("Dexterity - [|cffffcc00Level "+(I2S(IMaxBJ(1,IMinBJ($A,(((udg_TempInteger/ 18)+(udg_ShadowLoyalty/ 50))+1))))+"|r]")),(1-1)) // 'A0R6': ability "Dexterity"; $A = 10
            else
                // Result 1: (udg_TempInteger) divided by (18); drop the remainder.
                // Result 2: (udg_ShadowLoyalty) divided by (50); drop the remainder.
                // Result 3: (result 1) plus (result 2).
                // Result 4: (result 3) plus (1).
                // Result 5: the smaller of (10) and (result 4).
                // Result 6: the larger of (1) and (result 5).
                call BlzSetAbilityTooltip('A0R6',("Dexterity - [|cffffcc00Level "+(I2S(IMaxBJ(1,IMinBJ($A,(((udg_TempInteger/ 18)+(udg_ShadowLoyalty/ 50))+1))))+"|r]")),1) // 'A0R6': ability "Dexterity"; $A = 10
            endif
        endif
        // Result 1: (udg_TempInteger) divided by (18); drop the remainder.
        // Result 2: (udg_ShadowLoyalty) divided by (50); drop the remainder.
        // Result 3: (result 1) plus (result 2).
        // Result 4: (result 3) plus (1).
        // Result 5: the smaller of (11) and (result 4).
        // Result 6: result 5 treated as a decimal-capable number.
        // Result 7: (result 6) times (2).
        // Result 8: (5) plus (result 7).
        set udg_DexterityBonus=(5.+(I2R(IMinBJ($B,(((udg_TempInteger/ 18)+(udg_ShadowLoyalty/ 50))+1)))*2.)) // $B = 11
        if(Trig_Shadow_Hire_IsSoloPartySpeed())then
            set udg_DexterityCritMult=2.4
        else
            if(Trig_Shadow_Hire_IsDuoParty())then
                set udg_DexterityCritMult=2.2
            else
                // (2.3) minus ((0.1) times (CountPlayersInForceBJ(udg_PlayingPlayers) treated as a decimal-capable number)).
                set udg_DexterityCritMult=(2.3-(.1*I2R(CountPlayersInForceBJ(udg_PlayingPlayers))))
            endif
        endif
        if(Trig_Shadow_Hire_HasDancingDaggers())then
            call UnitAddAbilityBJ(udg_DancingDaggersAbility[CountPlayersInForceBJ(udg_PlayingPlayers)],udg_ShadowUnit)
            // Result 1: (udg_TempInteger) divided by (30); drop the remainder.
            // Result 2: (udg_ShadowLoyalty) divided by (20); drop the remainder.
            // Result 3: (result 1) plus (result 2).
            // Result 4: (result 3) minus (3).
            // Result 5: the smaller of (11) and (result 4).
            // Result 6: the larger of (1) and (result 5).
            call SetUnitAbilityLevelSwapped(udg_DancingDaggersAbility[CountPlayersInForceBJ(udg_PlayingPlayers)],udg_ShadowUnit,IMaxBJ(1,IMinBJ($B,(((udg_TempInteger/ 30)+(udg_ShadowLoyalty/ 20))-3)))) // $B = 11
        endif
        // Result 1: udg_ShadowLoyalty treated as a decimal-capable number.
        // Result 2: CountPlayersInForceBJ(udg_PlayingPlayers) treated as a decimal-capable number.
        // Result 3: (result 2) times (0.1).
        // Result 4: (1) minus (result 3).
        // Result 5: (result 4) times (0.3).
        // Result 6: (result 1) times (result 5).
        // Result 7: (result 6) with its decimal part removed.
        call ModifyHeroStat(bj_HEROSTAT_STR,udg_ShadowUnit,bj_MODIFYMETHOD_ADD,R2I((I2R(udg_ShadowLoyalty)*((1-(I2R(CountPlayersInForceBJ(udg_PlayingPlayers))*.1))*.3))))
        // Result 1: udg_ShadowLoyalty treated as a decimal-capable number.
        // Result 2: CountPlayersInForceBJ(udg_PlayingPlayers) treated as a decimal-capable number.
        // Result 3: (result 2) times (0.1).
        // Result 4: (1) minus (result 3).
        // Result 5: (result 4) times (0.2).
        // Result 6: (result 1) times (result 5).
        // Result 7: (result 6) with its decimal part removed.
        call ModifyHeroStat(bj_HEROSTAT_AGI,udg_ShadowUnit,bj_MODIFYMETHOD_ADD,R2I((I2R(udg_ShadowLoyalty)*((1-(I2R(CountPlayersInForceBJ(udg_PlayingPlayers))*.1))*.2))))
        // Result 1: udg_ShadowLoyalty treated as a decimal-capable number.
        // Result 2: CountPlayersInForceBJ(udg_PlayingPlayers) treated as a decimal-capable number.
        // Result 3: (result 2) times (0.1).
        // Result 4: (1) minus (result 3).
        // Result 5: (result 4) times (0.3).
        // Result 6: (result 1) times (result 5).
        // Result 7: (result 6) with its decimal part removed.
        call ModifyHeroStat(bj_HEROSTAT_INT,udg_ShadowUnit,bj_MODIFYMETHOD_ADD,R2I((I2R(udg_ShadowLoyalty)*((1-(I2R(CountPlayersInForceBJ(udg_PlayingPlayers))*.1))*.3))))
        call DisableTrigger(gg_trg_Equip_Restrictions)
        if(Trig_Shadow_Hire_HasKatanaForTier())then
            // ((udg_TempInteger) plus (1)) divided by (10); drop the remainder.
            call UnitAddItemByIdSwapped(udg_ShadowKatana[((udg_TempInteger+1)/ $A)],udg_ShadowUnit) // $A = 10
            call SetItemDroppableBJ(GetLastCreatedItem(),false)
            call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
        endif
        if(Trig_Shadow_Hire_IsFreeHireGear())then
            call UnitAddItemByIdSwapped('I0DN',udg_ShadowUnit) // 'I0DN': item "Genji Shield L"
            call SetItemDroppableBJ(GetLastCreatedItem(),false)
            call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
            call UnitAddItemByIdSwapped('I0DO',udg_ShadowUnit) // 'I0DO': item "Genji Mask Y"
            call SetItemDroppableBJ(GetLastCreatedItem(),false)
            call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
            call UnitAddItemByIdSwapped('I0DP',udg_ShadowUnit) // 'I0DP': item "Genji Armor D"
            call SetItemDroppableBJ(GetLastCreatedItem(),false)
            call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
            call UnitAddItemByIdSwapped('I0D3',udg_ShadowUnit) // 'I0D3': item "Memento Ring E"
            call SetItemDroppableBJ(GetLastCreatedItem(),false)
            call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
            call GroupAddUnitSimple(udg_ShadowUnit,udg_BossGroup)
            call UnitAddAbilityBJ('A04F',udg_ShadowUnit) // 'A04F': ability "Join Fast"
            call UnitAddAbilityBJ('A0WN',udg_ShadowUnit) // 'A0WN': ability "Physical Hardness"
            call UnitAddAbilityBJ('A0WP',udg_ShadowUnit) // 'A0WP': ability "Magical Hardness"
        else
            call UnitRemoveAbilityBJ('A0P9',udg_ShadowUnit) // 'A0P9': ability "Focus"
            call UnitRemoveAbilityBJ('A0PA',udg_ShadowUnit) // 'A0PA': ability "Adrenaline"
            call UnitRemoveAbilityBJ('A0T9',udg_ShadowUnit) // 'A0T9': ability "Last Stand"
            if(Trig_Shadow_Hire_HasDaggerForTier())then
                // ((udg_TempInteger) plus (3)) divided by (10); drop the remainder.
                call UnitAddItemByIdSwapped(udg_ShadowDagger[((udg_TempInteger+3)/ $A)],udg_ShadowUnit) // $A = 10
                call SetItemDroppableBJ(GetLastCreatedItem(),false)
                call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
            endif
            if(Trig_Shadow_Hire_HasHelmetForTier())then
                // ((udg_TempInteger) plus (5)) divided by (10); drop the remainder.
                call UnitAddItemByIdSwapped(udg_ShadowHelmet[((udg_TempInteger+5)/ $A)],udg_ShadowUnit) // $A = 10
                call SetItemDroppableBJ(GetLastCreatedItem(),false)
                call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
            endif
            if(Trig_Shadow_Hire_HasArmorForTier())then
                // ((udg_TempInteger) minus (1)) divided by (10); drop the remainder.
                call UnitAddItemByIdSwapped(udg_ShadowArmor[((udg_TempInteger-1)/ $A)],udg_ShadowUnit) // $A = 10
                call SetItemDroppableBJ(GetLastCreatedItem(),false)
                call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
            endif
        endif
        if(Trig_Shadow_Hire_HasPotionForTier())then
            // ((udg_TempInteger) plus (7)) divided by (10); drop the remainder.
            call UnitAddItemByIdSwapped(udg_ShadowPotion[((udg_TempInteger+7)/ $A)],udg_ShadowUnit) // $A = 10
            call SetItemDroppableBJ(GetLastCreatedItem(),false)
            call SetItemUserData(GetLastCreatedItem(),$B) // $B = 11
        endif
        call EnableTrigger(gg_trg_Equip_Restrictions)
        call RemoveUnit(GetSoldUnit())
        if(Trig_Shadow_Hire_IsBoughtBySpirit())then
            call IssueTargetOrderBJ(udg_ShadowUnit,"smart",Player_GetHero(GetOwningPlayer(GetBuyingUnit())))
        else
            call IssueTargetOrderBJ(udg_ShadowUnit,"smart",GetBuyingUnit())
        endif
        call ConditionalTriggerExecute(gg_trg_Shadow_Disband)
    endif
endfunction

function Trig_Shadow_Disband_Conditions takes nothing returns boolean
    return(udg_ShadowLoyalty<=0)
endfunction

function Trig_Shadow_Disband_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Shadow_LoyaltyTick)
    call DisableTrigger(gg_trg_Shadow_KillCount)
    call DisableTrigger(gg_trg_Shadow_Hire)
    call DisableTrigger(gg_trg_Shadow_HealedBonus)
    call DisableTrigger(gg_trg_Shadow_AttackedByParty)
    call DestroyTrigger(gg_trg_Shadow_LoyaltyTick)
    call DestroyTrigger(gg_trg_Shadow_KillCount)
    call DestroyTrigger(gg_trg_Shadow_Hire)
    call DestroyTrigger(gg_trg_Shadow_HealedBonus)
    call DestroyTrigger(gg_trg_Shadow_AttackedByParty)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Shadow_Hiring takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Shadow (module Shadow),
// which keeps the original registration order.

function Register_Shadow_Hire takes nothing returns nothing
    set gg_trg_Shadow_Hire=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Hire)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shadow_Hire,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Shadow_Hire,Condition(function Trig_Shadow_Hire_Conditions))
    call TriggerAddAction(gg_trg_Shadow_Hire,function Trig_Shadow_Hire_Actions)
endfunction

function Register_Shadow_Disband takes nothing returns nothing
    set gg_trg_Shadow_Disband=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Disband)
    call TriggerAddCondition(gg_trg_Shadow_Disband,Condition(function Trig_Shadow_Disband_Conditions))
    call TriggerAddAction(gg_trg_Shadow_Disband,function Trig_Shadow_Disband_Actions)
endfunction

endlibrary
