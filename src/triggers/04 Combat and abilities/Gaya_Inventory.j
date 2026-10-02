library TGayaInventory requires TPlayerPart01
function Trig_Gaya_ShopPurchase_Conditions takes nothing returns boolean
    return GetUnitTypeId(GetSellingUnit())=='n007' or GetUnitTypeId(GetSellingUnit())=='n017' // 'n007': unit "Storm the Pandaren Spiritualist"; 'n017': unit "Storm the Pandaren Spiritualist"
endfunction

function Trig_Gaya_ShopPurchase_Actions takes nothing returns nothing
    local player owningPlayer=GetOwningPlayer(GetBuyingUnit())
    // Starting value for i:
    // (GetPlayerId(owningPlayer)) plus (1).
    local integer i=GetPlayerId(owningPlayer)+1
    local unit g=udg_SpiritOfGaya[i]
    if GetItemTypeId(GetSoldItem())=='I007' then // 'I007': item "Break Stun"
        if GetPlayerTechCount(owningPlayer,'Resi',true)>=1 then // 'Resi': upgrade "Buy from Pandaren Spiritualist (1500 Gold + 1 Shard)"
            if GetUnitAbilityLevel(g,'A0B4')>=3 then // 'A0B4': ability "Break Stun"
                // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_GOLD)) plus (1500).
                call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD)+$5DC) // $5DC = 1500
                // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_LUMBER)) plus (1).
                call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER)+1)
            else
                // (GetUnitAbilityLevel(g, 'A0B4')) plus (1).
                call SetUnitAbilityLevel(g,'A0B4',GetUnitAbilityLevel(g,'A0B4')+1) // 'A0B4': ability "Break Stun"
            endif
        else
            call SetPlayerTechResearched(owningPlayer,'Resi',1) // 'Resi': upgrade "Buy from Pandaren Spiritualist (1500 Gold + 1 Shard)"
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl",g,"origin"))
        endif
    endif
    if GetItemTypeId(GetSoldItem())=='I008' then // 'I008': item "Mana Transfer"
        if GetPlayerTechCount(owningPlayer,'R00F',true)>=1 then // 'R00F': upgrade "Buy from Pandaren Spiritualist (3000 Gold + 1 Shard)"
            if GetUnitAbilityLevel(g,'A02K')>=3 then // 'A02K': ability "Mana Transfer"
                // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_GOLD)) plus (3000).
                call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD)+$BB8) // $BB8 = 3000
                // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_LUMBER)) plus (1).
                call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER)+1)
            else
                // (GetUnitAbilityLevel(g, 'A02K')) plus (1).
                call SetUnitAbilityLevel(g,'A02K',GetUnitAbilityLevel(g,'A02K')+1) // 'A02K': ability "Mana Transfer"
            endif
        else
            call SetPlayerTechResearched(owningPlayer,'R00F',1) // 'R00F': upgrade "Buy from Pandaren Spiritualist (3000 Gold + 1 Shard)"
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl",g,"origin"))
        endif
    endif
    if GetItemTypeId(GetSoldItem())=='I028' then // 'I028': item "Mega Heal"
        if GetPlayerTechCount(owningPlayer,'R00G',true)>=1 then // 'R00G': upgrade "Buy from Pandaren Spiritualist (6000 Gold + 1 Shard)"
            if GetUnitAbilityLevel(g,'A02L')>=3 then // 'A02L': ability "Mega Heal"
                // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_GOLD)) plus (6000).
                call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD)+6000)
                // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_LUMBER)) plus (1).
                call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER)+1)
            else
                // (GetUnitAbilityLevel(g, 'A02L')) plus (1).
                call SetUnitAbilityLevel(g,'A02L',GetUnitAbilityLevel(g,'A02L')+1) // 'A02L': ability "Mega Heal"
            endif
        else
            call SetPlayerTechResearched(owningPlayer,'R00G',1) // 'R00G': upgrade "Buy from Pandaren Spiritualist (6000 Gold + 1 Shard)"
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl",g,"origin"))
        endif
    endif
    if GetItemTypeId(GetSoldItem())=='I02A' then // 'I02A': item "Rakugaya"
        if GetUnitAbilityLevel(g,'A07E')>=1 then // 'A07E': ability "Rakugaya"
            // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_GOLD)) plus (4500).
            call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD)+4500)
            // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_LUMBER)) plus (2).
            call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER)+2)
        else
            call UnitAddAbility(g,'A07E') // 'A07E': ability "Rakugaya"
            call SetPlayerAbilityAvailable(owningPlayer,'A10F',true) // 'A10F': ability "Spiritual Power"
            // (GetUnitAbilityLevel(g, 'A10F')) plus (4).
            call SetUnitAbilityLevel(g,'A10F',GetUnitAbilityLevel(g,'A10F')+4) // 'A10F': ability "Spiritual Power"
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl",g,"origin"))
            set udg_CurrentHero=Player_GetHero(owningPlayer)
            call ConditionalTriggerExecute(gg_trg_Unit_ApplyUpgradeBonuses)
        endif
    endif
    if GetItemTypeId(GetSoldItem())=='I029' then // 'I029': item "Sukugaya"
        if GetUnitAbilityLevel(g,'S004')>=1 then // 'S004': ability "Sukugaya"
            // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_GOLD)) plus (4500).
            call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD)+4500)
            // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_LUMBER)) plus (2).
            call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER)+2)
        else
            call UnitAddAbility(g,'S004') // 'S004': ability "Sukugaya"
            call SetPlayerAbilityAvailable(owningPlayer,'A10F',true) // 'A10F': ability "Spiritual Power"
            // (GetUnitAbilityLevel(g, 'A10F')) plus (2).
            call SetUnitAbilityLevel(g,'A10F',GetUnitAbilityLevel(g,'A10F')+2) // 'A10F': ability "Spiritual Power"
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl",g,"origin"))
            set udg_CurrentHero=Player_GetHero(owningPlayer)
            call ConditionalTriggerExecute(gg_trg_Unit_ApplyUpgradeBonuses)
        endif
    endif
    if GetItemTypeId(GetSoldItem())=='I009' then // 'I009': item "Tarugaya"
        if GetUnitAbilityLevel(g,'A058')>=1 then // 'A058': ability "Tarugaya"
            // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_GOLD)) plus (4500).
            call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_GOLD)+4500)
            // (GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_LUMBER)) plus (2).
            call SetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER,GetPlayerState(owningPlayer,PLAYER_STATE_RESOURCE_LUMBER)+2)
        else
            call UnitAddAbility(g,'A058') // 'A058': ability "Tarugaya"
            call SetPlayerAbilityAvailable(owningPlayer,'A10F',true) // 'A10F': ability "Spiritual Power"
            // (GetUnitAbilityLevel(g, 'A10F')) plus (1).
            call SetUnitAbilityLevel(g,'A10F',GetUnitAbilityLevel(g,'A10F')+1) // 'A10F': ability "Spiritual Power"
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl",g,"origin"))
            set udg_CurrentHero=Player_GetHero(owningPlayer)
            call ConditionalTriggerExecute(gg_trg_Unit_ApplyUpgradeBonuses)
        endif
    endif
    if(GetUnitAbilityLevel(g,'A0B4')>=3 and GetUnitAbilityLevel(g,'A02K')>=3 and GetUnitAbilityLevel(g,'A02L')>=3 and GetUnitAbilityLevel(g,'A07E')>=1 and GetUnitAbilityLevel(g,'S004')>=1 and GetUnitAbilityLevel(g,'A058')>=1 and not IsPlayerInForce(owningPlayer,udg_TitleForce[52]))then // 'A0B4': ability "Break Stun"; 'A02K': ability "Mana Transfer"; 'A02L': ability "Mega Heal"; 'A07E': ability "Rakugaya"; 'S004': ability "Sukugaya"; 'A058': ability "Tarugaya"
        set udg_TempPlayer=owningPlayer
        set udg_TempInteger=52
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    set g=null
endfunction

function Trig_Gaya_ItemChanged_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H01D') // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Gaya_ItemChanged_Actions takes nothing returns nothing
    call StartTimerBJ(udg_LoadRefreshTimer,false,.0)
endfunction

function Trig_Gaya_GatherItems_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A049' // 'A049': ability "Gather Items"
endfunction

function Trig_Gaya_GatherItems_CollectItemToHouse takes nothing returns nothing
    // Starting value for i:
    // (GetPlayerId(the triggering player)) plus (1).
    local integer i=GetPlayerId(GetTriggerPlayer())+1
    local real ux
    local real uy
    if not IsItemVisible(GetEnumItem())then
        return
    endif
    if IsItemOwned(GetEnumItem())then
        return
    endif
    if IsItemPowerup(GetEnumItem())then
        return
    endif
    if(GetItemUserData(GetEnumItem())>0 and GetItemUserData(GetEnumItem())!=i)then
        return
    endif
    // Result 1: a random decimal number between GetRectMinX(udg_PlayerStartRect at position i) and
    // GetRectMaxX(udg_PlayerStartRect at position i).
    set ux=GetRandomReal(GetRectMinX(udg_PlayerStartRect[i]),GetRectMaxX(udg_PlayerStartRect[i]))
    // Result 1: a random decimal number between GetRectMinY(udg_PlayerStartRect at position i) and
    // GetRectMaxY(udg_PlayerStartRect at position i).
    set uy=GetRandomReal(GetRectMinY(udg_PlayerStartRect[i]),GetRectMaxY(udg_PlayerStartRect[i]))
    call SetItemPosition(GetEnumItem(),ux,uy)
    call UnitAddItem(udg_PlayerHouse[i],GetEnumItem())
endfunction

function Trig_Gaya_GatherItems_GatherItemsAround takes unit u,real l_radius returns nothing
    local real ux=GetUnitX(u)
    local real uy=GetUnitY(u)
    // Calculation 1:
    // (ux) minus (l_radius).
    // Calculation 2:
    // (uy) minus (l_radius).
    // Calculation 3:
    // (ux) plus (l_radius).
    // Calculation 4:
    // (uy) plus (l_radius).
    call EnumItemsInRect(Rect(ux-l_radius,uy-l_radius,ux+l_radius,uy+l_radius),null,function Trig_Gaya_GatherItems_CollectItemToHouse)
endfunction

function Trig_Gaya_GatherItems_Actions takes nothing returns nothing
    call Trig_Gaya_GatherItems_GatherItemsAround(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),500.)
    call Trig_Gaya_GatherItems_GatherItemsAround(GetTriggerUnit(),300.)
endfunction

function InitTrig_Gaya_Inventory takes nothing returns nothing
endfunction

endlibrary
