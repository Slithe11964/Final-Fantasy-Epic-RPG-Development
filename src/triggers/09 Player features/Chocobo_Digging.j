library TChocoboDigging
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chocobo_DeadPepper_Dig=null
    trigger gg_trg_Chocobo_DigSpot_Nearest=null
    trigger gg_trg_Chocobo_Drop_Nut=null
    // Variables only this module uses.
    location udg_ChocoboNearestDigSpot=null
    integer udg_ChocoboDigSpotIndex=0
    integer udg_ChocoboDigCount=0
endglobals

function Trig_Chocobo_DeadPepper_Dig_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0DJ') // 'A0DJ': ability "Dead Pepper"
endfunction

function Trig_Chocobo_DeadPepper_Dig_TargetNotOwnChocobo takes nothing returns boolean
    return(GetUnitName(GetSpellTargetUnit())!="Chocobo")or(GetOwningPlayer(GetTriggerUnit())!=GetOwningPlayer(GetSpellTargetUnit()))
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsInvalidTarget takes nothing returns boolean
    return(Trig_Chocobo_DeadPepper_Dig_TargetNotOwnChocobo())
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsWithin1024OfSpot takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_ChocoboNearestDigSpot.
    return(DistanceBetweenPoints(udg_TempPoint,udg_ChocoboNearestDigSpot)<1024.)
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsWithin512OfSpot takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_ChocoboNearestDigSpot.
    return(DistanceBetweenPoints(udg_TempPoint,udg_ChocoboNearestDigSpot)<512.)
endfunction

function Trig_Chocobo_DeadPepper_Dig_ItemTakesChargeBonus takes nothing returns boolean
    return(udg_ChocoboDigItemCharges[udg_ChocoboDigSpotIndex]>0)and(GetItemCharges(GetLastCreatedItem())>0)
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsMimettCycle takes nothing returns boolean
    // Calculation 1:
    // (the remainder after dividing (udg_ChocoboDigCount) by (15)) divided by (3); drop the remainder.
    // Calculation 2:
    // (the remainder after dividing (udg_ChocoboDigCount) by (15)) divided by (3); drop the remainder.
    return((ModuloInteger(udg_ChocoboDigCount,$F)/ 3)==2)or((ModuloInteger(udg_ChocoboDigCount,$F)/ 3)==3) // $F = 15
endfunction

function Trig_Chocobo_DeadPepper_Dig_UseMimettGreens takes nothing returns boolean
    return(Trig_Chocobo_DeadPepper_Dig_IsMimettCycle())
endfunction

function Trig_Chocobo_DeadPepper_Dig_UseSilkisGreens takes nothing returns boolean
    // The remainder after dividing (udg_ChocoboDigCount) by (15).
    return(ModuloInteger(udg_ChocoboDigCount,$F)==0)and(udg_ChocoboGreensStage>=2) // $F = 15
endfunction

function Trig_Chocobo_DeadPepper_Dig_UseGysahlGreens takes nothing returns boolean
    return(udg_ChocoboGreensStage<=0)
endfunction

function Trig_Chocobo_DeadPepper_Dig_ItemTakesChargeBonusAgain takes nothing returns boolean
    return(udg_ChocoboDigItemCharges[udg_ChocoboDigSpotIndex]>0)and(GetItemCharges(GetLastCreatedItem())>0)
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsGreensTurn takes nothing returns boolean
    // The remainder after dividing (udg_ChocoboDigCount) by (3).
    return(ModuloInteger(udg_ChocoboDigCount,3)==0)
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsCommonSpot takes nothing returns boolean
    return(udg_ChocoboDigSpotIndex<=20)
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsPowerupItem takes nothing returns boolean
    return(CheckItemStatus(GetLastCreatedItem(),bj_ITEM_STATUS_POWERUP))
endfunction

function Trig_Chocobo_DeadPepper_Dig_ChargesOverMax takes nothing returns boolean
    return(GetItemCharges(GetLastCreatedItem())>99)
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsRareSpot takes nothing returns boolean
    return(udg_ChocoboDigSpotIndex>20)
endfunction

function Trig_Chocobo_DeadPepper_Dig_AbilityBelowLevel10 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())<$A) // $A = 10
endfunction

function Trig_Chocobo_DeadPepper_Dig_TargetIsStage2Chocobo takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n037') // 'n037': unit "Chocobo"
endfunction

function Trig_Chocobo_DeadPepper_Dig_AbilityBelowLevel5 takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())<5)
endfunction

function Trig_Chocobo_DeadPepper_Dig_TargetIsStage1Chocobo takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n036') // 'n036': unit "Chocobo"
endfunction

function Trig_Chocobo_DeadPepper_Dig_HasChocoboAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())>=1)
endfunction

function Trig_Chocobo_DeadPepper_Dig_IsOnDigSpot takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_ChocoboNearestDigSpot.
    return(DistanceBetweenPoints(udg_TempPoint,udg_ChocoboNearestDigSpot)<256.)
endfunction

function Trig_Chocobo_DeadPepper_Dig_Actions takes nothing returns nothing
    if(Trig_Chocobo_DeadPepper_Dig_IsInvalidTarget())then
        return
    endif
    set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call ConditionalTriggerExecute(gg_trg_Chocobo_DigSpot_Nearest)
    if(Trig_Chocobo_DeadPepper_Dig_IsOnDigSpot())then
        call CreateTextTagLocBJ("WARK-KKK!!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Chocobo_DeadPepper_Dig_IsCommonSpot())then
            set udg_ChocoboDigCount=(udg_ChocoboDigCount+1)
            if(Trig_Chocobo_DeadPepper_Dig_IsGreensTurn())then
                if(Trig_Chocobo_DeadPepper_Dig_UseGysahlGreens())then
                    call CreateItemLoc('I027',udg_TempPoint) // 'I027': item "Gysahl Greens"
                else
                    if(Trig_Chocobo_DeadPepper_Dig_UseSilkisGreens())then
                        call CreateItemLoc('I0KE',udg_TempPoint) // 'I0KE': item "Silkis Greens"
                    else
                        if(Trig_Chocobo_DeadPepper_Dig_UseMimettGreens())then
                            call CreateItemLoc('I07Q',udg_TempPoint) // 'I07Q': item "Mimett Greens"
                        else
                            call CreateItemLoc('I027',udg_TempPoint) // 'I027': item "Gysahl Greens"
                        endif
                    endif
                endif
            else
                call CreateItemLoc(udg_ChocoboDigItem[udg_ChocoboDigSpotIndex],udg_TempPoint)
                if(Trig_Chocobo_DeadPepper_Dig_ItemTakesChargeBonusAgain())then
                    // Multiply the item's starting charges by the dig spot's charge value plus Chocobo level divided by a random 15-25.
                    // That division uses whole numbers, so the remainder is discarded.
                    call SetItemCharges(GetLastCreatedItem(),(GetItemCharges(GetLastCreatedItem())*(udg_ChocoboDigItemCharges[udg_ChocoboDigSpotIndex]+(GetUnitLevel(GetSpellTargetUnit())/ GetRandomInt($F,25))))) // $F = 15
                endif
            endif
        else
            call CreateItemLoc(udg_ChocoboDigItem[udg_ChocoboDigSpotIndex],udg_TempPoint)
            if(Trig_Chocobo_DeadPepper_Dig_ItemTakesChargeBonus())then
                // Multiply the item's starting charges by the dig spot's charge value plus Chocobo level divided by a random 15-25.
                // That division uses whole numbers, so the remainder is discarded.
                call SetItemCharges(GetLastCreatedItem(),(GetItemCharges(GetLastCreatedItem())*(udg_ChocoboDigItemCharges[udg_ChocoboDigSpotIndex]+(GetUnitLevel(GetSpellTargetUnit())/ GetRandomInt($F,25))))) // $F = 15
            endif
        endif
        if(Trig_Chocobo_DeadPepper_Dig_ChargesOverMax())then
            call SetItemCharges(GetLastCreatedItem(),99)
        else
            if(Trig_Chocobo_DeadPepper_Dig_IsPowerupItem())then
                call SetItemCharges(GetLastCreatedItem(),1)
            endif
        endif
        if(Trig_Chocobo_DeadPepper_Dig_IsRareSpot())then
            // A random whole number from 14 through 20.
            set udg_TempInteger=GetRandomInt($E,20) // $E = 14
            set udg_ChocoboDigItem[udg_ChocoboDigSpotIndex]=udg_ChocoboDigItem[udg_TempInteger]
            // The destination dig spot receives twice the charge value of the selected source spot.
            set udg_ChocoboDigItemCharges[udg_ChocoboDigSpotIndex]=(udg_ChocoboDigItemCharges[udg_TempInteger]*2)
        endif
        // A random whole number from 1 through 8.
        set udg_ChocoboRegionIndex=GetRandomInt(1,8)
        // A random whole number from 1 through LoadIntegerBJ(udg_ChocoboRegionIndex, 2, udg_SpawnDataHashRef).
        set udg_ChocoboDigSpot[udg_ChocoboDigSpotIndex]=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(udg_ChocoboRegionIndex,2,udg_SpawnDataHashRef)),udg_ChocoboRegionIndex,udg_SpawnRectHashRef))
        set bj_forLoopBIndex=3
        set bj_forLoopBIndexEnd=$F // $F = 15
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            if(Trig_Chocobo_DeadPepper_Dig_HasChocoboAbility())then
                set udg_ChocoboAbilityIndex=GetForLoopIndexB()
                if(Trig_Chocobo_DeadPepper_Dig_TargetIsStage1Chocobo())then
                    if(Trig_Chocobo_DeadPepper_Dig_AbilityBelowLevel5())then
                        call IncUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())
                    endif
                else
                    if(Trig_Chocobo_DeadPepper_Dig_TargetIsStage2Chocobo())then
                        if(Trig_Chocobo_DeadPepper_Dig_AbilityBelowLevel10())then
                            call IncUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())
                        endif
                    endif
                endif
            endif
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
    else
        if(Trig_Chocobo_DeadPepper_Dig_IsWithin512OfSpot())then
            call CreateTextTagLocBJ("Warkk!!!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        else
            if(Trig_Chocobo_DeadPepper_Dig_IsWithin1024OfSpot())then
                call CreateTextTagLocBJ("Wark!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
            else
                call CreateTextTagLocBJ("Warrrrrrk...",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
            endif
        endif
    endif
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Chocobo_DigSpot_Nearest_IsNearMapCenter takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_ChocoboNearestDigSpot.
    return(DistanceBetweenPoints(udg_TempPoint,udg_ChocoboNearestDigSpot)<2048.)
endfunction

function Trig_Chocobo_DigSpot_Nearest_IsSpotCloser takes nothing returns boolean
    // Calculation 1:
    // The straight-line distance between udg_TempPoint and udg_ChocoboDigSpot at position loop counter A.
    // Calculation 2:
    // The straight-line distance between udg_TempPoint and udg_ChocoboNearestDigSpot.
    return(DistanceBetweenPoints(udg_TempPoint,udg_ChocoboDigSpot[GetForLoopIndexA()])<DistanceBetweenPoints(udg_TempPoint,udg_ChocoboNearestDigSpot))
endfunction

function Trig_Chocobo_DigSpot_Nearest_IsSecretSpotCloser takes nothing returns boolean
    // Calculation 1:
    // The straight-line distance between udg_TempPoint and udg_ChocoboDigSpot at position 99.
    // Calculation 2:
    // The straight-line distance between udg_TempPoint and udg_ChocoboNearestDigSpot.
    return(DistanceBetweenPoints(udg_TempPoint,udg_ChocoboDigSpot[99])<DistanceBetweenPoints(udg_TempPoint,udg_ChocoboNearestDigSpot))
endfunction

function Trig_Chocobo_DigSpot_Nearest_SecretSpotRevealed takes nothing returns boolean
    return(udg_SecretDigSpotRevealed)
endfunction

function Trig_Chocobo_DigSpot_Nearest_Actions takes nothing returns nothing
    set udg_ChocoboNearestDigSpot=GetRectCenter(GetPlayableMapRect())
    if(Trig_Chocobo_DigSpot_Nearest_IsNearMapCenter())then
        call RemoveLocation(udg_ChocoboNearestDigSpot)
        set udg_ChocoboNearestDigSpot=GetRectCenter(gg_rct_472)
    endif
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_ChocoboDigSpotCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Chocobo_DigSpot_Nearest_IsSpotCloser())then
            set udg_ChocoboNearestDigSpot=udg_ChocoboDigSpot[GetForLoopIndexA()]
            set udg_ChocoboDigSpotIndex=GetForLoopIndexA()
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Chocobo_DigSpot_Nearest_SecretSpotRevealed())then
        if(Trig_Chocobo_DigSpot_Nearest_IsSecretSpotCloser())then
            set udg_ChocoboNearestDigSpot=udg_ChocoboDigSpot[99]
            set udg_ChocoboDigSpotIndex=99
        endif
    endif
endfunction

function Trig_Chocobo_Drop_Nut_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I07H',udg_TempPoint) // 'I07H': item "Zeio Nut"
    call CreateItemLoc('I0KE',udg_TempPoint) // 'I0KE': item "Silkis Greens"
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Chocobo_Digging takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Chocobo_Part1, RegisterTriggers_Chocobo_Part2 (module Chocobo),
// which keeps the original registration order.

function Register_Chocobo_DeadPepper_Dig takes nothing returns nothing
    set gg_trg_Chocobo_DeadPepper_Dig=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_DeadPepper_Dig,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chocobo_DeadPepper_Dig,Condition(function Trig_Chocobo_DeadPepper_Dig_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_DeadPepper_Dig,function Trig_Chocobo_DeadPepper_Dig_Actions)
endfunction

function Register_Chocobo_DigSpot_Nearest takes nothing returns nothing
    set gg_trg_Chocobo_DigSpot_Nearest=CreateTrigger()
    call TriggerAddAction(gg_trg_Chocobo_DigSpot_Nearest,function Trig_Chocobo_DigSpot_Nearest_Actions)
endfunction

function Register_Chocobo_Drop_Nut takes nothing returns nothing
    set gg_trg_Chocobo_Drop_Nut=CreateTrigger()
    call DisableTrigger(gg_trg_Chocobo_Drop_Nut)
    call TriggerAddAction(gg_trg_Chocobo_Drop_Nut,function Trig_Chocobo_Drop_Nut_Actions)
endfunction

endlibrary
