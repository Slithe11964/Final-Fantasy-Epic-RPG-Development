library TFishingCasting requires TAbil, TGroup, TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Fishing_Cast=null
    // Variables only this module uses.
    integer udg_FishCatchCount=0
endglobals

function Trig_Fishing_Cast_IsStartFish takes nothing returns boolean
    return(GetSpellAbilityId()=='A0VB')or(GetSpellAbilityId()=='A0VT')or(GetSpellAbilityId()=='A0VU')or(GetSpellAbilityId()=='A0VV') // 'A0VB': ability "Start Fish"; 'A0VT': ability "Start Fish"; 'A0VU': ability "Start Fish"; 'A0VV': ability "Start Fish"
endfunction

function Trig_Fishing_Cast_Conditions takes nothing returns boolean
    return(Trig_Fishing_Cast_IsStartFish())and(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit())))and(udg_GatherState[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0)
endfunction

function Trig_Fishing_Cast_IsFishingSpot takes nothing returns boolean
    return(IsUnitInGroup(GetFilterUnit(),udg_FishingSpots))
endfunction

function Trig_Fishing_Cast_IsPlayerFishing takes nothing returns boolean
    return(udg_GatherState[udg_TempInteger]>0)
endfunction

function Trig_Fishing_Cast_HasSpotNear takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_Fishing_Cast_NoSpotNear takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_Fishing_Cast_CatchStreakMax takes nothing returns boolean
    return(udg_FishCatchCount>=$F) // $F = 15
endfunction

function Trig_Fishing_Cast_IsTenthCatch takes nothing returns boolean
    return(udg_FishCatchCount==$A) // $A = 10
endfunction

function Trig_Fishing_Cast_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Fishing_Cast_IntLuckRoll takes nothing returns boolean
    // Roll from 1 to 1000. Intelligence must reach the roll: 100 Intelligence gives a 10% success chance.
    return(GetRandomInt(1,$3E8)<=GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)) // $3E8 = 1000
endfunction

function Trig_Fishing_Cast_IsNebraKingSpot takes nothing returns boolean
    return(udg_TempInteger==$A)and(udg_PlayerFishSpot[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==udg_NebraKingSpot) // $A = 10
endfunction

function Trig_Fishing_Cast_IsDeepestSpot takes nothing returns boolean
    return(udg_PlayerFishSpot[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==gg_unit_n0AQ_0214)and(udg_TempInteger==$A) // $A = 10
endfunction

function Trig_Fishing_Cast_IsDeepSpot takes nothing returns boolean
    return(udg_PlayerFishSpot[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==gg_unit_n0AQ_0214)or(udg_PlayerFishSpot[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==gg_unit_n0AQ_0212)
endfunction

function Trig_Fishing_Cast_IsRareTier takes nothing returns boolean
    return(udg_TempInteger==5)or(udg_TempInteger==8)or(udg_TempInteger==$A) // $A = 10
endfunction

function Trig_Fishing_Cast_IsDeepRareCatch takes nothing returns boolean
    return(Trig_Fishing_Cast_IsDeepSpot())and(Trig_Fishing_Cast_IsRareTier())
endfunction

function Trig_Fishing_Cast_IsCommonTier takes nothing returns boolean
    return(udg_TempInteger<=5)or(udg_TempInteger==7)or(udg_TempInteger==9)
endfunction

function Trig_Fishing_Cast_IsCommonCatch takes nothing returns boolean
    return(Trig_Fishing_Cast_IsCommonTier())
endfunction

function Trig_Fishing_Cast_GilgameshBlocked takes nothing returns boolean
    return(udg_TempInteger==70)and(udg_GilgameshDefeated==false)
endfunction

function Trig_Fishing_Cast_IsFifthCatch takes nothing returns boolean
    // The remainder after dividing (udg_FishCatchCount) by (5).
    return(ModuloInteger(udg_FishCatchCount,5)==0)
endfunction

function Trig_Fishing_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(256.,udg_TempPoint,Condition(function Trig_Fishing_Cast_IsFishingSpot))
    call RemoveLocation(udg_TempPoint)
    if(Trig_Fishing_Cast_HasSpotNear())then
        set udg_TempInteger=1
        loop
            exitwhen udg_TempInteger>8
            if(Trig_Fishing_Cast_IsPlayerFishing())then
                call GroupRemoveUnitSimple(udg_PlayerFishSpot[udg_TempInteger],udg_TempGroup)
            endif
            set udg_TempInteger=udg_TempInteger+1
        endloop
    endif
    if(Trig_Fishing_Cast_NoSpotNear())then
        call DestroyGroup(udg_TempGroup)
        return
    endif
    set udg_PlayerFishSpot[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GroupPickRandomUnit(udg_TempGroup)
    call DestroyGroup(udg_TempGroup)
    set udg_GatherState[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
    set udg_TempPoint=GetUnitLoc(udg_PlayerFishSpot[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
    set udg_FishCatchCount=(udg_FishCatchCount+1)
    if(Trig_Fishing_Cast_IsFifthCatch())then
        if(Trig_Fishing_Cast_IsTenthCatch())then
            set udg_TempInteger=25
        else
            set udg_TempInteger=5
            if(Trig_Fishing_Cast_CatchStreakMax())then
                set udg_FishCatchCount=0
            endif
        endif
        set udg_TempReal=5.
    else
        // The starting catch score is mana cost divided by 10, with any fraction dropped.
        set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ $A) // $A = 10
        if(Trig_Fishing_Cast_IntLuckRoll())then
            // Pick a random value up to the catch score squared, take its square root, drop decimals, and add 1.
            // The square root favors larger results compared with a roll that gives every whole number the same chance.
            set udg_TempInteger=(R2I(SquareRoot(GetRandomReal(0,I2R((udg_TempInteger*udg_TempInteger)))))+1)
        else
            if(Trig_Fishing_Cast_CoinFlip())then
                set udg_TempInteger=1
            else
                // A random whole number from 1 through udg_TempInteger.
                set udg_TempInteger=GetRandomInt(1,udg_TempInteger)
            endif
        endif
        if(Trig_Fishing_Cast_IsNebraKingSpot())then
            set udg_TempInteger=9
        endif
        if(Trig_Fishing_Cast_IsDeepRareCatch())then
            if(Trig_Fishing_Cast_IsDeepestSpot())then
                set udg_TempInteger=(udg_TempInteger+1)
            else
                set udg_TempInteger=(udg_TempInteger-1)
            endif
        endif
        if(Trig_Fishing_Cast_IsCommonCatch())then
            // Use the fishing spot's maximum-life value / 100,000, plus a random adjustment from -1 to 2.
            // Keep the result between 0 and 9; the next line drops its decimal part.
            set udg_TempReal=RMaxBJ(.0,RMinBJ(9.,((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_PlayerFishSpot[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])/ 100000.)+GetRandomReal(-1.,2.))))
            // Each catch-score group has 10 loot entries. Jump to that group, then add the chosen entry from 0 to 9.
            set udg_TempInteger=(((udg_TempInteger-1)*$A)+R2I(udg_TempReal)) // $A = 10
        else
            // Udg_TempInteger treated as a decimal-capable number.
            set udg_TempReal=I2R(udg_TempInteger)
            // Choose the first loot entry in this catch-score group; each group occupies 10 entries.
            set udg_TempInteger=((udg_TempInteger-1)*$A) // $A = 10
        endif
        if(Trig_Fishing_Cast_GilgameshBlocked())then
            set udg_TempInteger=50
        endif
    endif
    set udg_GatherItem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=CreateItemLoc(udg_FishLoot[udg_TempInteger],udg_TempPoint)
    // Result 1: (udg_TempInteger) divided by (20); drop the remainder.
    // Result 2: (udg_TempReal) with its decimal part removed.
    // Result 3: (result 2) divided by (2).
    // Result 4: (result 1) plus (result 3).
    call SetItemCharges(GetLastCreatedItem(),((udg_TempInteger/ 20)+(R2I(udg_TempReal)/ 2)))
    call SetItemVisibleBJ(false,GetLastCreatedItem())
    call RemoveLocation(udg_TempPoint)
    call UnitAddAbilityBJ('A0VJ',GetTriggerUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(true,GetTriggerUnit())
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
    call StartTimerBJ(udg_FishingTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false,5.)
endfunction

function InitTrig_Fishing_Casting takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Fishing_Part1 (module Fishing),
// which keeps the original registration order.

function Register_Fishing_Cast takes nothing returns nothing
    set gg_trg_Fishing_Cast=CreateTrigger()
    call DisableTrigger(gg_trg_Fishing_Cast)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fishing_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Fishing_Cast,Condition(function Trig_Fishing_Cast_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Cast,function Trig_Fishing_Cast_Actions)
endfunction

endlibrary
