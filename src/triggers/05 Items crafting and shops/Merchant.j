library TMerchant requires TWait
function Trig_Merchant_Stock_Init_Actions takes nothing returns nothing
    set udg_MerchantPotion[0]='I05I' // 'I05I': item "Spirit Potion"
    set udg_MerchantPotion[1]='pdiv' // 'pdiv': item "Hero Drink"
    set udg_MerchantPotion[2]='I05H' // 'I05H': item "Blood Ether"
    set udg_MerchantPotion[3]='pres' // 'pres': item "Elixir"
    set udg_MerchantPotion[4]='I02X' // 'I02X': item "Greater Nectar"
    set udg_MerchantAccessory[0]='I00J' // 'I00J': item "Chimes of Piercing"
    set udg_MerchantAccessory[1]='I0DL' // 'I0DL': item "Turtleshell Choker"
    set udg_MerchantAccessory[2]='I0CO' // 'I0CO': item "Silver Glasses"
    set udg_MerchantAccessory[3]='I0D0' // 'I0D0': item "Setzer's Coin"
    set udg_MerchantAccessory[4]='I0DR' // 'I0DR': item "Cameo Belt"
    set udg_MerchantRod[0]='I0KZ' // 'I0KZ': item "Gaya's Rod"
    set udg_MerchantRod[1]='I0BM' // 'I0BM': item "Gravity Staff"
    set udg_MerchantRod[2]='I0KY' // 'I0KY': item "Serpent Rod"
    set udg_MerchantRod[3]='I0L0' // 'I0L0': item "Aeon Scepter"
    set udg_MerchantRod[4]='I0KX' // 'I0KX': item "Wand of the Wind"
    set udg_MerchantRareGear[0]='I01L' // 'I01L': item "Grand Helmet"
    set udg_MerchantRareGear[1]='I0EW' // 'I0EW': item "Demon Axe"
    set udg_MerchantRareGear[2]='I0LK' // 'I0LK': item "Artemis Arrows"
    set udg_MerchantRareGear[3]='I0BX' // 'I0BX': item "Grand Armor"
    set udg_MerchantRareGear[4]='I0B8' // 'I0B8': item "Pulsar Shot"
    call EnableTrigger(gg_trg_Merchant_Spawn_Night)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Merchant_Spawn_Night_Conditions takes nothing returns boolean
    // The remainder after dividing (udg_GameDay) by (2).
    return(ModuloInteger(udg_GameDay,2)==1)
endfunction

function Trig_Merchant_Spawn_Night_Cond_PickRect2 takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Merchant_Spawn_Night_Cond_PickRect1 takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Merchant_Spawn_Night_Cond_PickRectPair takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Merchant_Spawn_Night_Cond_KoboldKills_None takes nothing returns boolean
    return(udg_KoboldKillCount<=0)
endfunction

function Trig_Merchant_Spawn_Night_Cond_KoboldKills_Under6 takes nothing returns boolean
    return(udg_KoboldKillCount<=5)
endfunction

function Trig_Merchant_Spawn_Night_Cond_KoboldKills_Under16 takes nothing returns boolean
    return(udg_KoboldKillCount<=$F) // $F = 15
endfunction

function Trig_Merchant_Spawn_Night_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Merchant_Spawn_Night_Cond_PickRectPair())then
        if(Trig_Merchant_Spawn_Night_Cond_PickRect1())then
            set udg_TempPoint=GetRectCenter(gg_rct_699)
        else
            set udg_TempPoint=GetRectCenter(gg_rct_700)
        endif
    else
        if(Trig_Merchant_Spawn_Night_Cond_PickRect2())then
            set udg_TempPoint=GetRectCenter(gg_rct_701)
        else
            set udg_TempPoint=GetRectCenter(gg_rct_702)
        endif
    endif
    call CreateNUnitsAtLoc(1,'n0M3',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'n0M3': unit "Kobold Merchant"
    set udg_KoboldMerchant=GetLastCreatedUnit()
    call RemoveLocation(udg_TempPoint)
    call SetUnitVertexColorBJ(udg_KoboldMerchant,75.,90.,'d',90.)
    // The remainder after dividing (udg_GameDay) by (5).
    set udg_TempInteger=ModuloInteger(udg_GameDay,5)
    call AddItemToStockBJ(udg_MerchantPotion[udg_TempInteger],udg_KoboldMerchant,$A,$A) // $A = 10
    if(Trig_Merchant_Spawn_Night_Cond_KoboldKills_Under16())then
        call AddItemToStockBJ(udg_MerchantAccessory[udg_TempInteger],udg_KoboldMerchant,1,1)
        if(Trig_Merchant_Spawn_Night_Cond_KoboldKills_Under6())then
            call AddItemToStockBJ(udg_MerchantRod[udg_TempInteger],udg_KoboldMerchant,1,1)
            if(Trig_Merchant_Spawn_Night_Cond_KoboldKills_None())then
                call AddItemToStockBJ(udg_MerchantRareGear[udg_TempInteger],udg_KoboldMerchant,1,1)
            endif
        endif
    endif
    call TriggerRegisterUnitInRangeSimple(gg_trg_Merchant_Reveal,256,udg_KoboldMerchant)
    call EnableTrigger(gg_trg_Merchant_Reveal)
    call EnableTrigger(gg_trg_Merchant_Leave_Dawn)
    call EnableTrigger(gg_trg_Merchant_Leave_OnSale)
endfunction

function Trig_Merchant_Reveal_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))
endfunction

function Trig_Merchant_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitRemoveAbilityBJ('Apiv',udg_KoboldMerchant) // 'Apiv': object name not found in map data
    call SetUnitVertexColorBJ(udg_KoboldMerchant,75.,90.,'d',60.)
    call Wait_Polled(.5)
    call SetUnitVertexColorBJ(udg_KoboldMerchant,75.,90.,'d',.0)
endfunction

function Trig_Merchant_Leave_Dawn_Cond_MerchantVisible takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Apiv',udg_KoboldMerchant)<=0) // 'Apiv': object name not found in map data
endfunction

function Trig_Merchant_Leave_Dawn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Merchant_Leave_OnSale)
    call DisableTrigger(gg_trg_Merchant_Reveal)
    if(Trig_Merchant_Leave_Dawn_Cond_MerchantVisible())then
        set udg_TempPoint=GetUnitLoc(udg_KoboldMerchant)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
    endif
    call RemoveUnit(udg_KoboldMerchant)
    set udg_KoboldMerchant=null
    call EnableTrigger(gg_trg_Merchant_Spawn_Night)
    set udg_KoboldKillCount=0
endfunction

function Trig_Merchant_Leave_OnSale_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_KoboldMerchant)and(GetItemType(GetSoldItem())!=ITEM_TYPE_CHARGED)
endfunction

function Trig_Merchant_Leave_OnSale_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Merchant_Leave_Dawn)
    call DisableTrigger(gg_trg_Merchant_Reveal)
    set udg_TempPoint=GetUnitLoc(udg_KoboldMerchant)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call RemoveUnit(udg_KoboldMerchant)
    set udg_KoboldMerchant=null
    call EnableTrigger(gg_trg_Merchant_Spawn_Night)
    set udg_KoboldKillCount=0
endfunction

function Trig_Merchant_Stock_Shrink_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1C7',GetTriggerUnit())>0) // 'A1C7': ability "Kobold Type"
endfunction

function Trig_Merchant_Stock_Shrink_Cond_KoboldKills_Is16 takes nothing returns boolean
    return(udg_KoboldKillCount==16)
endfunction

function Trig_Merchant_Stock_Shrink_Cond_KoboldKills_Is6 takes nothing returns boolean
    return(udg_KoboldKillCount==6)
endfunction

function Trig_Merchant_Stock_Shrink_Cond_KoboldKills_Is1 takes nothing returns boolean
    return(udg_KoboldKillCount==1)
endfunction

function Trig_Merchant_Stock_Shrink_Cond_MerchantNotFound takes nothing returns boolean
    return(IsTriggerEnabled(gg_trg_Merchant_Reveal))
endfunction

function Trig_Merchant_Stock_Shrink_Actions takes nothing returns nothing
    set udg_KoboldKillCount=(udg_KoboldKillCount+1)
    if(Trig_Merchant_Stock_Shrink_Cond_MerchantNotFound())then
        if(Trig_Merchant_Stock_Shrink_Cond_KoboldKills_Is1())then
            call RemoveItemFromStockBJ(udg_MerchantRareGear[0],udg_KoboldMerchant)
            call RemoveItemFromStockBJ(udg_MerchantRareGear[1],udg_KoboldMerchant)
            call RemoveItemFromStockBJ(udg_MerchantRareGear[2],udg_KoboldMerchant)
            call RemoveItemFromStockBJ(udg_MerchantRareGear[3],udg_KoboldMerchant)
            call RemoveItemFromStockBJ(udg_MerchantRareGear[4],udg_KoboldMerchant)
        else
            if(Trig_Merchant_Stock_Shrink_Cond_KoboldKills_Is6())then
                call RemoveItemFromStockBJ(udg_MerchantRod[0],udg_KoboldMerchant)
                call RemoveItemFromStockBJ(udg_MerchantRod[1],udg_KoboldMerchant)
                call RemoveItemFromStockBJ(udg_MerchantRod[2],udg_KoboldMerchant)
                call RemoveItemFromStockBJ(udg_MerchantRod[3],udg_KoboldMerchant)
                call RemoveItemFromStockBJ(udg_MerchantRod[4],udg_KoboldMerchant)
            else
                if(Trig_Merchant_Stock_Shrink_Cond_KoboldKills_Is16())then
                    call RemoveItemFromStockBJ(udg_MerchantAccessory[0],udg_KoboldMerchant)
                    call RemoveItemFromStockBJ(udg_MerchantAccessory[1],udg_KoboldMerchant)
                    call RemoveItemFromStockBJ(udg_MerchantAccessory[2],udg_KoboldMerchant)
                    call RemoveItemFromStockBJ(udg_MerchantAccessory[3],udg_KoboldMerchant)
                    call RemoveItemFromStockBJ(udg_MerchantAccessory[4],udg_KoboldMerchant)
                endif
            endif
        endif
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Merchant takes nothing returns nothing
endfunction
function RegisterR11_Merchant_Stock_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Merchant_Stock_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Merchant_Stock_Init,120.)
    call TriggerAddAction(gg_trg_Merchant_Stock_Init,function Trig_Merchant_Stock_Init_Actions)
endfunction
function RegisterR11_Merchant_Spawn_Night takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Merchant_Spawn_Night=CreateTrigger()
    call DisableTrigger(gg_trg_Merchant_Spawn_Night)
    call TriggerRegisterGameStateEventTimeOfDay(gg_trg_Merchant_Spawn_Night,EQUAL,18.)
    call TriggerAddCondition(gg_trg_Merchant_Spawn_Night,Condition(function Trig_Merchant_Spawn_Night_Conditions))
    call TriggerAddAction(gg_trg_Merchant_Spawn_Night,function Trig_Merchant_Spawn_Night_Actions)
endfunction
function RegisterR11_Merchant_Reveal takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Merchant_Reveal=CreateTrigger()
    call DisableTrigger(gg_trg_Merchant_Reveal)
    call TriggerAddCondition(gg_trg_Merchant_Reveal,Condition(function Trig_Merchant_Reveal_Conditions))
    call TriggerAddAction(gg_trg_Merchant_Reveal,function Trig_Merchant_Reveal_Actions)
endfunction
function RegisterR11_Merchant_Leave_Dawn takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Merchant_Leave_Dawn=CreateTrigger()
    call DisableTrigger(gg_trg_Merchant_Leave_Dawn)
    call TriggerRegisterGameStateEventTimeOfDay(gg_trg_Merchant_Leave_Dawn,EQUAL,6.)
    call TriggerAddAction(gg_trg_Merchant_Leave_Dawn,function Trig_Merchant_Leave_Dawn_Actions)
endfunction
function RegisterR11_Merchant_Leave_OnSale takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Merchant_Leave_OnSale=CreateTrigger()
    call DisableTrigger(gg_trg_Merchant_Leave_OnSale)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Merchant_Leave_OnSale,Player(8),EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Merchant_Leave_OnSale,Condition(function Trig_Merchant_Leave_OnSale_Conditions))
    call TriggerAddAction(gg_trg_Merchant_Leave_OnSale,function Trig_Merchant_Leave_OnSale_Actions)
endfunction
function RegisterR11_Merchant_Stock_Shrink takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Merchant_Stock_Shrink=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Merchant_Stock_Shrink,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Merchant_Stock_Shrink,Condition(function Trig_Merchant_Stock_Shrink_Conditions))
    call TriggerAddAction(gg_trg_Merchant_Stock_Shrink,function Trig_Merchant_Stock_Shrink_Actions)
endfunction




endlibrary
