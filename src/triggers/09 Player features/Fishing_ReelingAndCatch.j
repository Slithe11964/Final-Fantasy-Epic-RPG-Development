library TFishingReelingAndCatch requires TForce, TLoc, TPlayerPart01
globals
    // Variables only this module uses.
    texttag array udg_FishingText
    effect array udg_FishingBubbles
    integer array udg_FishReleaseAbil
endglobals

function Trig_Fishing_Tick_StateLost takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]>=5)
endfunction

function Trig_Fishing_Tick_StateHooked takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]==4)
endfunction

function Trig_Fishing_Tick_StateWaiting takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]==2)
endfunction

function Trig_Fishing_Tick_IsRandomDirSpot takes nothing returns boolean
    return(udg_PlayerFishSpot[udg_TempInteger]==gg_unit_n0AQ_0214)
endfunction

function Trig_Fishing_Tick_FreeCastActive takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Fishing_Tick_FacingSouth takes nothing returns boolean
    return(udg_TempReal==270.)
endfunction

function Trig_Fishing_Tick_FacingWest takes nothing returns boolean
    return(udg_TempReal==180.)
endfunction

function Trig_Fishing_Tick_FacingNorth takes nothing returns boolean
    return(udg_TempReal==90.)
endfunction

function Trig_Fishing_Tick_FacingEast takes nothing returns boolean
    return(udg_TempReal==.0)
endfunction

function Trig_Fishing_Tick_StateCasting takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]==1)
endfunction

function Trig_Fishing_Tick_Actions takes nothing returns nothing
    if(Trig_Fishing_Tick_StateCasting())then
        set udg_GatherState[udg_TempInteger]=2
        set udg_TempPoint=GetUnitLoc(udg_PlayerFishSpot[udg_TempInteger])
        if(Trig_Fishing_Tick_IsRandomDirSpot())then
            // Choose one of four directions: 0, 90, 180, or 270 degrees.
            set udg_TempReal=I2R((90*GetRandomInt(0,3)))
        else
            set udg_TempReal=GetUnitFacing(udg_PlayerFishSpot[udg_TempInteger])
        endif
        // Pull the bobber back by 0.02 x (Strength + 100) / (item charges + 1).
        // Higher Strength pulls farther; more charges reduce each pull. The direction is opposite the unit's facing.
        set udg_FishingBobberLoc[udg_TempInteger]=Loc_PolarOffset(udg_TempPoint,512.,udg_TempReal)
        set udg_FishingBubbles[udg_TempInteger]=AddSpecialEffectLocBJ(udg_FishingBobberLoc[udg_TempInteger],"Doodads\\Icecrown\\Water\\BubbleGeyserSteam\\BubbleGeyserSteam.mdl")
        call CreateNUnitsAtLoc(1,'n0AR',ConvertedPlayer(udg_TempInteger),udg_FishingBobberLoc[udg_TempInteger],udg_TempReal) // 'n0AR': unit "Fishing Controls"
        set udg_FishingControls[udg_TempInteger]=GetLastCreatedUnit()
        if(Trig_Fishing_Tick_FreeCastActive())then
            call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0VN',0,0) // 'A0VN': ability "<"
            call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0VQ',0,0) // 'A0VQ': ability ">"
            call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0VO',0,0) // 'A0VO': ability "^"
            call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0VP',0,0) // 'A0VP': ability "v"
        else
            call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0VN',1,0) // 'A0VN': ability "<"
            call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0VQ',1,0) // 'A0VQ': ability ">"
            call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0VO',1,0) // 'A0VO': ability "^"
            call BlzSetUnitAbilityManaCost(GetLastCreatedUnit(),'A0VP',1,0) // 'A0VP': ability "v"
        endif
        call SetUnitVertexColorBJ(GetLastCreatedUnit(),.0,.0,'d',90.)
        call SetUnitInvulnerable(Player_GetHero(ConvertedPlayer(udg_TempInteger)),true)
        call IssueTargetOrderBJ(udg_SpiritOfGaya[udg_TempInteger],"smart",Player_GetHero(ConvertedPlayer(udg_TempInteger)))
        call UnitRemoveAbilityBJ('A0P3',udg_SpiritOfGaya[udg_TempInteger]) // 'A0P3': ability "House Portal"
        call SetUnitPositionLocFacingBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),udg_TempPoint,udg_TempReal)
        // (udg_TempInteger) minus (1).
        call SetUnitX(Player_GetHero(Player(udg_TempInteger-1)),GetUnitX(udg_PlayerFishSpot[udg_TempInteger]))
        // (udg_TempInteger) minus (1).
        call SetUnitY(Player_GetHero(Player(udg_TempInteger-1)),GetUnitY(udg_PlayerFishSpot[udg_TempInteger]))
        call SelectUnitForPlayerSingle(udg_FishingControls[udg_TempInteger],ConvertedPlayer(udg_TempInteger))
        if(Trig_Fishing_Tick_FacingEast())then
            set udg_FishPullAbil[udg_TempInteger]='A0VN' // 'A0VN': ability "<"
            set udg_FishLeftAbil[udg_TempInteger]='A0VO' // 'A0VO': ability "^"
            set udg_FishReleaseAbil[udg_TempInteger]='A0VQ' // 'A0VQ': ability ">"
            set udg_FishRightAbil[udg_TempInteger]='A0VP' // 'A0VP': ability "v"
        else
            if(Trig_Fishing_Tick_FacingNorth())then
                set udg_FishPullAbil[udg_TempInteger]='A0VP' // 'A0VP': ability "v"
                set udg_FishLeftAbil[udg_TempInteger]='A0VN' // 'A0VN': ability "<"
                set udg_FishReleaseAbil[udg_TempInteger]='A0VO' // 'A0VO': ability "^"
                set udg_FishRightAbil[udg_TempInteger]='A0VQ' // 'A0VQ': ability ">"
            else
                if(Trig_Fishing_Tick_FacingWest())then
                    set udg_FishPullAbil[udg_TempInteger]='A0VQ' // 'A0VQ': ability ">"
                    set udg_FishLeftAbil[udg_TempInteger]='A0VP' // 'A0VP': ability "v"
                    set udg_FishReleaseAbil[udg_TempInteger]='A0VN' // 'A0VN': ability "<"
                    set udg_FishRightAbil[udg_TempInteger]='A0VO' // 'A0VO': ability "^"
                else
                    if(Trig_Fishing_Tick_FacingSouth())then
                        set udg_FishPullAbil[udg_TempInteger]='A0VO' // 'A0VO': ability "^"
                        set udg_FishLeftAbil[udg_TempInteger]='A0VQ' // 'A0VQ': ability ">"
                        set udg_FishReleaseAbil[udg_TempInteger]='A0VP' // 'A0VP': ability "v"
                        set udg_FishRightAbil[udg_TempInteger]='A0VN' // 'A0VN': ability "<"
                    else
                        call DisplayTextToForce(GetPlayersAll(),"Fishing direction not detected :O")
                    endif
                endif
            endif
        endif
        call RemoveLocation(udg_TempPoint)
        set udg_FishingText[udg_TempInteger]=CreateTextTagLocBJ("...",udg_FishingBobberLoc[udg_TempInteger],0,$A,'d','d','d',0) // $A = 10
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        set udg_TempForce=Force_OfPlayer(ConvertedPlayer(udg_TempInteger))
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_TempForce)
        call DestroyForce(udg_TempForce)
        call SetTextTagPermanentBJ(udg_FishingText[udg_TempInteger],true)
        // Result 1: (maximum health of udg_PlayerFishSpot at position udg_TempInteger) plus (100000).
        // Result 2: the larger of (0) and (Intelligence of Player_GetHero(ConvertedPlayer(udg_TempInteger))).
        // Result 3: result 2 treated as a decimal-capable number.
        // Result 4: (result 3) plus (100).
        // Result 5: (result 1) divided by (result 4).
        // Result 6: (result 5) divided by (100).
        call StartTimerBJ(udg_FishingTimer[udg_TempInteger],false,(((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_PlayerFishSpot[udg_TempInteger])+100000.)/(I2R(IMaxBJ(0,GetHeroStatBJ(bj_HEROSTAT_INT,Player_GetHero(ConvertedPlayer(udg_TempInteger)),true)))+100.))/ 100.))
    else
        if(Trig_Fishing_Tick_StateWaiting())then
            call SetTextTagTextBJ(udg_FishingText[udg_TempInteger],"!",$A) // $A = 10
            set udg_GatherState[udg_TempInteger]=3
        else
            if(Trig_Fishing_Tick_StateHooked())then
                call StartTimerBJ(udg_FishingTimer[0],false,.02)
                // (4) plus (a random whole number from 1 through 2).
                set udg_GatherState[udg_TempInteger]=(4+GetRandomInt(1,2))
                call AddSpecialEffectLocBJ(udg_FishingBobberLoc[udg_TempInteger],"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                // Result 1: Agility of Player_GetHero(ConvertedPlayer(udg_TempInteger)) treated as a decimal-capable number.
                // Result 2: (result 1) plus (100).
                // Result 3: (item charges of udg_GatherItem at position udg_TempInteger) plus (1).
                // Result 4: result 3 treated as a decimal-capable number.
                // Result 5: (result 4) times (100).
                // Result 6: (result 2) divided by (result 5).
                // Result 7: a random decimal number between 1 and 1.5.
                // Result 8: (result 6) times (result 7).
                call StartTimerBJ(udg_FishingTimer[udg_TempInteger],false,(((I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),true))+100.)/(I2R((GetItemCharges(udg_GatherItem[udg_TempInteger])+1))*100.))*GetRandomReal(1.,1.5)))
            else
                if(Trig_Fishing_Tick_StateLost())then
                    call SetTextTagTextBJ(udg_FishingText[udg_TempInteger],"The fish got away...",$A) // $A = 10
                    call RemoveItem(udg_GatherItem[udg_TempInteger])
                    call ConditionalTriggerExecute(gg_trg_Fishing_End)
                endif
            endif
        endif
    endif
endfunction

function Trig_Fishing_Input_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n0AR') // 'n0AR': unit "Fishing Controls"
endfunction

function Trig_Fishing_Input_IsSideInput takes nothing returns boolean
    return(GetSpellAbilityId()==udg_FishLeftAbil[udg_TempInteger])or(GetSpellAbilityId()==udg_FishRightAbil[udg_TempInteger])
endfunction

function Trig_Fishing_Input_IsLeftCorrect takes nothing returns boolean
    return(GetSpellAbilityId()==udg_FishLeftAbil[udg_TempInteger])and(udg_GatherState[udg_TempInteger]==5)
endfunction

function Trig_Fishing_Input_IsRightCorrect takes nothing returns boolean
    return(GetSpellAbilityId()==udg_FishRightAbil[udg_TempInteger])and(udg_GatherState[udg_TempInteger]==6)
endfunction

function Trig_Fishing_Input_IsCorrectSide takes nothing returns boolean
    return(Trig_Fishing_Input_IsLeftCorrect())or(Trig_Fishing_Input_IsRightCorrect())
endfunction

function Trig_Fishing_Input_IsFishInReach takes nothing returns boolean
    // Calculation 1:
    // The straight-line distance between udg_TempPoint and udg_FishingBobberLoc at position udg_TempInteger.
    // Calculation 2:
    // (128) plus (udg_TempReal).
    return(DistanceBetweenPoints(udg_TempPoint,udg_FishingBobberLoc[udg_TempInteger])<=(128.+udg_TempReal))
endfunction

function Trig_Fishing_Input_IsHookedStage takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]>=4)
endfunction

function Trig_Fishing_Input_SideInputCorrect takes nothing returns boolean
    return(Trig_Fishing_Input_IsCorrectSide())
endfunction

function Trig_Fishing_Input_IsSideAbility takes nothing returns boolean
    return(Trig_Fishing_Input_IsSideInput())
endfunction

function Trig_Fishing_Input_IsFightStage takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]>=4)
endfunction

function Trig_Fishing_Input_IsSlackInput takes nothing returns boolean
    return(GetSpellAbilityId()==udg_FishReleaseAbil[udg_TempInteger])
endfunction

function Trig_Fishing_Input_IsFishAtHand takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_FishingBobberLoc at position udg_TempInteger.
    return(DistanceBetweenPoints(udg_TempPoint,udg_FishingBobberLoc[udg_TempInteger])<=128.)
endfunction

function Trig_Fishing_Input_IsStageFour takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]==4)
endfunction

function Trig_Fishing_Input_IsStageThree takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]==3)
endfunction

function Trig_Fishing_Input_IsPullInput takes nothing returns boolean
    return(GetSpellAbilityId()==udg_FishPullAbil[udg_TempInteger])
endfunction

function Trig_Fishing_Input_IsTooEarly takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]<=2)
endfunction

function Trig_Fishing_Input_Actions takes nothing returns nothing
    call PauseUnitBJ(true,GetTriggerUnit())
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
    call PauseUnitBJ(false,GetTriggerUnit())
    set udg_TempInteger=GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Fishing_Input_IsTooEarly())then
        call RemoveItem(udg_GatherItem[udg_TempInteger])
        call ConditionalTriggerExecute(gg_trg_Fishing_End)
    else
        if(Trig_Fishing_Input_IsPullInput())then
            if(Trig_Fishing_Input_IsStageThree())then
                call EnableTrigger(gg_trg_AbilityTags_Show)
                call StartTimerBJ(udg_FishingTimer[0],false,.02)
                call AddSpecialEffectLocBJ(udg_FishingBobberLoc[udg_TempInteger],"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                set udg_GatherState[udg_TempInteger]=4
                // Result 1: Agility of Player_GetHero(ConvertedPlayer(udg_TempInteger)) treated as a decimal-capable number.
                // Result 2: (result 1) plus (100).
                // Result 3: (result 2) divided by (10).
                // Result 4: (item charges of udg_GatherItem at position udg_TempInteger) plus (3).
                // Result 5: result 4 treated as a decimal-capable number.
                // Result 6: (result 3) divided by (result 5).
                // Result 7: a random decimal number between 0.75 and 1.25.
                // Result 8: (result 6) times (result 7).
                call StartTimerBJ(udg_FishingTimer[udg_TempInteger],false,((((I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),true))+100.)/ 10.)/ I2R((GetItemCharges(udg_GatherItem[udg_TempInteger])+3)))*GetRandomReal(.75,1.25)))
            else
                if(Trig_Fishing_Input_IsStageFour())then
                    set udg_TempPoint=udg_FishingBobberLoc[udg_TempInteger]
                    // Pull the bobber back by 0.02 x (Strength + 100) / (item charges + 1).
                    // Higher Strength pulls farther; more charges reduce each pull. The direction is opposite the unit's facing.
                    set udg_FishingBobberLoc[udg_TempInteger]=Loc_PolarOffset(udg_TempPoint,(20./((I2R((GetItemCharges(udg_GatherItem[udg_TempInteger])+1))*1000.)/(I2R(GetHeroStatBJ(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),true))+100.))),ModuloReal((GetUnitFacing(GetTriggerUnit())+180.),360.))
                    call RemoveLocation(udg_TempPoint)
                    set udg_TempPoint=GetUnitLoc(udg_PlayerFishSpot[udg_TempInteger])
                    if(Trig_Fishing_Input_IsFishAtHand())then
                        call RemoveLocation(udg_TempPoint)
                        call ConditionalTriggerExecute(gg_trg_Fishing_Catch)
                    else
                        call RemoveLocation(udg_TempPoint)
                        call SetUnitPositionLoc(GetTriggerUnit(),udg_FishingBobberLoc[udg_TempInteger])
                        call BlzSetSpecialEffectPositionLoc(udg_FishingBubbles[udg_TempInteger],udg_FishingBobberLoc[udg_TempInteger])
                        call SetTextTagPosBJ(udg_FishingText[udg_TempInteger],udg_FishingBobberLoc[udg_TempInteger],0)
                    endif
                endif
            endif
        else
            if(Trig_Fishing_Input_IsSlackInput())then
                if(Trig_Fishing_Input_IsFightStage())then
                    call SetTextTagTextBJ(udg_FishingText[udg_TempInteger],"The fish got away...",$A) // $A = 10
                endif
                call RemoveItem(udg_GatherItem[udg_TempInteger])
                call ConditionalTriggerExecute(gg_trg_Fishing_End)
            else
                if(Trig_Fishing_Input_IsSideAbility())then
                    if(Trig_Fishing_Input_SideInputCorrect())then
                        call StartTimerBJ(udg_FishingTimer[0],false,.02)
                        set udg_GatherState[udg_TempInteger]=4
                        call AddSpecialEffectLocBJ(udg_FishingBobberLoc[udg_TempInteger],"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
                        call DestroyEffectBJ(GetLastCreatedEffectBJ())
                        // Compute 0.2 x (seconds remaining + 1) x (Strength + 100) / (item charges + 1).
                        // More remaining time or Strength raises the result; more charges lower it.
                        set udg_TempReal=((200.*(TimerGetRemaining(udg_FishingTimer[udg_TempInteger])+1.))/((I2R((GetItemCharges(udg_GatherItem[udg_TempInteger])+1))*1000.)/(I2R(GetHeroStatBJ(bj_HEROSTAT_STR,Player_GetHero(ConvertedPlayer(udg_TempInteger)),true))+100.)))
                        set udg_TempPoint=GetUnitLoc(udg_PlayerFishSpot[udg_TempInteger])
                        if(Trig_Fishing_Input_IsFishInReach())then
                            call RemoveLocation(udg_TempPoint)
                            call ConditionalTriggerExecute(gg_trg_Fishing_Catch)
                        else
                            call RemoveLocation(udg_TempPoint)
                            set udg_TempPoint=udg_FishingBobberLoc[udg_TempInteger]
                            // Pull the bobber back by 0.02 x (Strength + 100) / (item charges + 1).
                            // Higher Strength pulls farther; more charges reduce each pull. The direction is opposite the unit's facing.
                            set udg_FishingBobberLoc[udg_TempInteger]=Loc_PolarOffset(udg_TempPoint,udg_TempReal,ModuloReal((GetUnitFacing(GetTriggerUnit())+180.),360.))
                            call RemoveLocation(udg_TempPoint)
                            // Result 1: Agility of Player_GetHero(ConvertedPlayer(udg_TempInteger)) treated as a decimal-capable number.
                            // Result 2: (result 1) plus (100).
                            // Result 3: (result 2) divided by (10).
                            // Result 4: (item charges of udg_GatherItem at position udg_TempInteger) plus (3).
                            // Result 5: result 4 treated as a decimal-capable number.
                            // Result 6: (result 3) divided by (result 5).
                            // Result 7: a random decimal number between 0.75 and 1.25.
                            // Result 8: (result 6) times (result 7).
                            call StartTimerBJ(udg_FishingTimer[udg_TempInteger],false,((((I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,Player_GetHero(ConvertedPlayer(udg_TempInteger)),true))+100.)/ 10.)/ I2R((GetItemCharges(udg_GatherItem[udg_TempInteger])+3)))*GetRandomReal(.75,1.25)))
                            call SetUnitPositionLoc(GetTriggerUnit(),udg_FishingBobberLoc[udg_TempInteger])
                            call BlzSetSpecialEffectPositionLoc(udg_FishingBubbles[udg_TempInteger],udg_FishingBobberLoc[udg_TempInteger])
                            call SetTextTagPosBJ(udg_FishingText[udg_TempInteger],udg_FishingBobberLoc[udg_TempInteger],0)
                        endif
                    else
                        if(Trig_Fishing_Input_IsHookedStage())then
                            call SetTextTagTextBJ(udg_FishingText[udg_TempInteger],"The fish got away...",$A) // $A = 10
                        endif
                        call RemoveItem(udg_GatherItem[udg_TempInteger])
                        call ConditionalTriggerExecute(gg_trg_Fishing_End)
                    endif
                endif
            endif
        endif
    endif
endfunction

function Trig_Fishing_Catch_NebraKingDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[48]))or(IsUnitHiddenBJ(gg_unit_H02W_0246)==false)
endfunction

function Trig_Fishing_Catch_NebraKingAlreadyCaught takes nothing returns boolean
    return(GetItemTypeId(udg_GatherItem[udg_TempInteger])=='I0FH')and(Trig_Fishing_Catch_NebraKingDone()) // 'I0FH': item "The Nebra King"
endfunction

function Trig_Fishing_Catch_GilgameshBusy takes nothing returns boolean
    return(udg_GilgameshDefeated==false)or(udg_FishedGilgamesh!=null)
endfunction

function Trig_Fishing_Catch_GilgameshUnavailable takes nothing returns boolean
    return(GetItemTypeId(udg_GatherItem[udg_TempInteger])=='I0FG')and(Trig_Fishing_Catch_GilgameshBusy()) // 'I0FG': item "Gilgamesh"
endfunction

function Trig_Fishing_Catch_Actions takes nothing returns nothing
    call AddSpecialEffectLocBJ(udg_FishingBobberLoc[udg_TempInteger],"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if(Trig_Fishing_Catch_NebraKingAlreadyCaught())then
        call RemoveItem(udg_GatherItem[udg_TempInteger])
        set udg_GatherItem[udg_TempInteger]=CreateItemLoc('I0GW',udg_FishingBobberLoc[udg_TempInteger]) // 'I0GW': item "Gold Fish"
    endif
    if(Trig_Fishing_Catch_GilgameshUnavailable())then
        call RemoveItem(udg_GatherItem[udg_TempInteger])
        set udg_GatherItem[udg_TempInteger]=CreateItemLoc('I01Z',udg_FishingBobberLoc[udg_TempInteger]) // 'I01Z': item "Crystal Shard"
    endif
    call SetTextTagTextBJ(udg_FishingText[udg_TempInteger],("You fished up |cffffcc00"+(GetItemName(udg_GatherItem[udg_TempInteger])+"|r!")),$A) // $A = 10
    call PauseUnitBJ(false,Player_GetHero(ConvertedPlayer(udg_TempInteger)))
    call UnitAddItemByIdSwapped(GetItemTypeId(udg_GatherItem[udg_TempInteger]),Player_GetHero(ConvertedPlayer(udg_TempInteger)))
    call RemoveItem(udg_GatherItem[udg_TempInteger])
    call ConditionalTriggerExecute(gg_trg_Fishing_End)
endfunction

function Trig_Fishing_End_SeaKingQuestReady takes nothing returns boolean
    return(udg_SeaKingQuestStarted==false)and(udg_LothlorienOpen)and(udg_PlayerFishSpot[udg_TempInteger]==gg_unit_n0AQ_0212)
endfunction

function Trig_Fishing_End_AnyPlayerFishing takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]>0)
endfunction

function Trig_Fishing_End_Actions takes nothing returns nothing
    set udg_GatherState[udg_TempInteger]=0
    call DestroyEffectBJ(udg_FishingBubbles[udg_TempInteger])
    call PauseTimerBJ(true,udg_FishingTimer[udg_TempInteger])
    call SetTextTagPermanentBJ(udg_FishingText[udg_TempInteger],false)
    call SetTextTagAgeBJ(udg_FishingText[udg_TempInteger],0)
    call SetTextTagLifespanBJ(udg_FishingText[udg_TempInteger],5)
    call KillUnit(udg_FishingControls[udg_TempInteger])
    call RemoveUnit(udg_FishingControls[udg_TempInteger])
    call UnitRemoveAbilityBJ('A0VJ',Player_GetHero(ConvertedPlayer(udg_TempInteger))) // 'A0VJ': ability "Unaffected by Cinematics"
    call UnitAddAbilityBJ('A0P3',udg_SpiritOfGaya[udg_TempInteger]) // 'A0P3': ability "House Portal"
    call SetUnitInvulnerable(Player_GetHero(ConvertedPlayer(udg_TempInteger)),false)
    call PauseUnitBJ(false,Player_GetHero(ConvertedPlayer(udg_TempInteger)))
    call IssueImmediateOrderBJ(Player_GetHero(ConvertedPlayer(udg_TempInteger)),"holdposition")
    call SelectUnitForPlayerSingle(Player_GetHero(ConvertedPlayer(udg_TempInteger)),ConvertedPlayer(udg_TempInteger))
    if(Trig_Fishing_End_SeaKingQuestReady())then
        call ConditionalTriggerExecute(gg_trg_Anabel_Appear)
    endif
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>8
        if(Trig_Fishing_End_AnyPlayerFishing())then
            return
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    call DisableTrigger(gg_trg_AbilityTags_Show)
endfunction

function InitTrig_Fishing_ReelingAndCatch takes nothing returns nothing
endfunction

endlibrary
