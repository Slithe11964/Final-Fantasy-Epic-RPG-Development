library TChocoboBribing requires TForce, TItemShared
function Trig_Chocobo_Bribe_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A071') // 'A071': ability "Bribe"
endfunction

function Trig_Chocobo_Bribe_IsBribeMaxLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A071',GetTriggerUnit())>=$B) // 'A071': ability "Bribe"; $B = 11
endfunction

function Trig_Chocobo_Bribe_IsNotPowerupItem takes nothing returns boolean
    return(CheckItemStatus(GetLastCreatedItem(),bj_ITEM_STATUS_POWERUP)==false)
endfunction

function Trig_Chocobo_Bribe_HasEnoughGold takes nothing returns boolean
    return(GetPlayerState(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)>=udg_TempInteger2)
endfunction

function Trig_Chocobo_Bribe_HasBribeItem takes nothing returns boolean
    return(udg_TempInteger>0)
endfunction

function Trig_Chocobo_Bribe_Actions takes nothing returns nothing
    set udg_TempInteger=GetUnitTypeId(GetSpellTargetUnit())
    set udg_TempInteger=LoadIntegerBJ(4,udg_TempInteger,udg_MonsterDataHash)
    if(Trig_Chocobo_Bribe_HasBribeItem())then
        if(Trig_Chocobo_Bribe_IsBribeMaxLevel())then
            // This branch prices the bribe at 2,000 gold per target level.
            set udg_TempInteger2=(GetUnitLevel(GetSpellTargetUnit())*$7D0) // $7D0 = 2000
        else
            // Bribe price = target level x (5,200 - 200 x Bribe ability level).
            // Each ability level reduces the price by 200 gold per target level; this line does not set a minimum.
            set udg_TempInteger2=(GetUnitLevel(GetSpellTargetUnit())*(5200-(GetUnitAbilityLevelSwapped('A071',GetTriggerUnit())*$C8))) // 'A071': ability "Bribe"; $C8 = 200
        endif
        if(Trig_Chocobo_Bribe_HasEnoughGold())then
            set udg_LootItemID=Item_IdFromIndex(udg_TempInteger)
            set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call CreateItemLoc(udg_LootItemID,udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            if(Trig_Chocobo_Bribe_IsNotPowerupItem())then
                // Multiply the item's starting charges by a randomly chosen 3, 4, or 5.
                call SetItemCharges(GetLastCreatedItem(),(GetItemCharges(GetLastCreatedItem())*GetRandomInt(3,5)))
            endif
            // (-1) times (udg_TempInteger2).
            call AdjustPlayerStateBJ((-1*udg_TempInteger2),GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
            call UnitAddAbilityBJ('A14Q',GetSpellTargetUnit()) // 'A14Q': ability "Pointless"
            call UnitApplyTimedLifeBJ(.01,'BTLF',GetSpellTargetUnit()) // 'BTLF': object name not found in map data
            call ShowUnitHide(GetSpellTargetUnit())
        else
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
            call DisplayTimedTextToForce(udg_TempForce,10.,("|cffff0000You do not have the required|r |cffff4400"+(I2S(udg_TempInteger2)+"|r |cffff0000gold to bribe this enemy!|r")))
            call DestroyForce(udg_TempForce)
        endif
    else
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000The target unit cannot be bribed!|r")
        call DestroyForce(udg_TempForce)
    endif
endfunction

function InitTrig_Chocobo_Bribing takes nothing returns nothing
endfunction

endlibrary
