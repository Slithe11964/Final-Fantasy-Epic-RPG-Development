library TProf requires TPlayerPart01
function Prof_GetWeaponUpgrade takes unit u returns integer
    if(GetUnitAbilityLevel(u,'A0X6')>0)then // 'A0X6': ability "Upgrade Damage Bonus Dummy"
        return 'R000' // 'R000': upgrade "Tools"
    elseif(GetUnitAbilityLevel(u,'A0X7')>0)then // 'A0X7': ability "Upgrade Damage Bonus Dummy"
        return 'R001' // 'R001': upgrade "Sword"
    elseif(GetUnitAbilityLevel(u,'A0X8')>0)then // 'A0X8': ability "Upgrade Damage Bonus Dummy"
        return 'R002' // 'R002': upgrade "Bow"
    elseif(GetUnitAbilityLevel(u,'A0X9')>0)then // 'A0X9': ability "Upgrade Damage Bonus Dummy"
        return 'R00B' // 'R00B': upgrade "Dagger"
    elseif(GetUnitAbilityLevel(u,'A0XA')>0)then // 'A0XA': ability "Upgrade Damage Bonus Dummy"
        return 'R009' // 'R009': upgrade "Spear"
    elseif(GetUnitAbilityLevel(u,'A0XB')>0)then // 'A0XB': ability "Upgrade Damage Bonus Dummy"
        return 'R00I' // 'R00I': upgrade "Heavens Forged Axe"
    elseif(GetUnitAbilityLevel(u,'A0XC')>0)then // 'A0XC': ability "Upgrade Damage Bonus Dummy"
        return 'R00A' // 'R00A': upgrade "Katana"
    elseif(GetUnitAbilityLevel(u,'A0XD')>0)then // 'A0XD': ability "Upgrade Damage Bonus Dummy"
        return 'R00N' // 'R00N': upgrade "Greatsword"
    elseif(GetUnitAbilityLevel(u,'A0XE')>0)then // 'A0XE': ability "Upgrade Damage Bonus Dummy"
        return 'R003' // 'R003': upgrade "Rod"
    elseif(GetUnitAbilityLevel(u,'A0XF')>0)then // 'A0XF': ability "Upgrade Damage Bonus Dummy"
        return 'R004' // 'R004': upgrade "Staff"
    elseif(GetUnitAbilityLevel(u,'A0XH')>0)then // 'A0XH': ability "Upgrade Damage Bonus Dummy"
        return 'R00M' // 'R00M': upgrade "Gun"
    elseif(GetUnitAbilityLevel(u,'A0XG')>0)then // 'A0XG': ability "Upgrade Damage Bonus Dummy"
        return 'R00L' // 'R00L': upgrade "Inner Mana"
    else
        return 0
    endif
endfunction

function Prof_GetArmorUpgrade takes unit u returns integer
    if(GetUnitAbilityLevel(u,'A0KL')>0)then // 'A0KL': ability "Upgrade Life Bonus Dummy"
        return 'R006' // 'R006': upgrade "Leather Armor"
    elseif(GetUnitAbilityLevel(u,'A0KM')>0)then // 'A0KM': ability "Upgrade Life Bonus Dummy"
        return 'R005' // 'R005': upgrade "Plate Armor"
    elseif(GetUnitAbilityLevel(u,'A0KN')>0)then // 'A0KN': ability "Upgrade Life Bonus Dummy"
        return 'R007' // 'R007': upgrade "Mystic Armor"
    else
        return 0
    endif
endfunction

function Prof_UpgradeToIndex takes integer upgradeId returns integer
    if(upgradeId==0)then
        return 0
    elseif(upgradeId=='R000')then // 'R000': upgrade "Tools"
        return 1
    elseif(upgradeId=='R001')then // 'R001': upgrade "Sword"
        return 2
    elseif(upgradeId=='R002')then // 'R002': upgrade "Bow"
        return 3
    elseif(upgradeId=='R00B')then // 'R00B': upgrade "Dagger"
        return 4
    elseif(upgradeId=='R009')then // 'R009': upgrade "Spear"
        return 5
    elseif(upgradeId=='R00I')then // 'R00I': upgrade "Heavens Forged Axe"
        return 6
    elseif(upgradeId=='R00A')then // 'R00A': upgrade "Katana"
        return 7
    elseif(upgradeId=='R00N')then // 'R00N': upgrade "Greatsword"
        return 8
    elseif(upgradeId=='R003')then // 'R003': upgrade "Rod"
        return 9
    elseif(upgradeId=='R004')then // 'R004': upgrade "Staff"
        return $A // $A = 10
    elseif(upgradeId=='R00M')then // 'R00M': upgrade "Gun"
        return $B // $B = 11
    elseif(upgradeId=='R00L')then // 'R00L': upgrade "Inner Mana"
        return $C // $C = 12
    elseif(upgradeId==udg_ProfIdUnarmed)then
        return $D // $D = 13
    elseif(upgradeId=='R006')then // 'R006': upgrade "Leather Armor"
        return 1
    elseif(upgradeId=='R005')then // 'R005': upgrade "Plate Armor"
        return 2
    elseif(upgradeId=='R007')then // 'R007': upgrade "Mystic Armor"
        return 3
    else
        return 0
    endif
endfunction

function Prof_GetLevel takes unit u,integer upgradeId returns integer
    local integer i=0
    local integer l_unused
    local integer l_total=0
    local integer l_equipped
    local integer proficiencyIndex=Prof_UpgradeToIndex(upgradeId)
    local integer storedItemLife
    local item l_itm
    local itemtype l_slotType
    local player p
    local boolean l_isArmor
    if(proficiencyIndex==0 or u==null)then
        return 0
    endif
    set p=GetOwningPlayer(u)
    set l_isArmor=(upgradeId=='R006' or upgradeId=='R005' or upgradeId=='R007') // 'R006': upgrade "Leather Armor"; 'R005': upgrade "Plate Armor"; 'R007': upgrade "Mystic Armor"
    if(IsUnitType(u,UNIT_TYPE_HERO))then
        if(l_isArmor)then
            set l_slotType=ITEM_TYPE_PURCHASABLE
        else
            set l_slotType=ITEM_TYPE_PERMANENT
        endif
        loop
            set l_itm=UnitItemInSlot(u,i)
            if(l_itm!=null and(GetItemType(l_itm)==l_slotType and GetItemLevel(l_itm)==proficiencyIndex))then
                // (GetItemLifeBJ(l_itm)) with its decimal part removed.
                set storedItemLife=R2I(GetItemLifeBJ(l_itm))
                if(storedItemLife>=30)then
                    if((upgradeId=='R003' or upgradeId=='R004' or upgradeId=='R00L')or GetUnitAbilityLevel(u,'A15I')>0)then // 'R003': upgrade "Rod"; 'R004': upgrade "Staff"; 'R00L': upgrade "Inner Mana"; 'A15I': ability "Versatility"
                        // The item life field stores a value used for proficiency here, not the hero's health.
                        // Divide it by 10, drop the remainder, add 1, then multiply by 1.5 and drop decimals again.
                        // Example: a stored value of 40 contributes (4 + 1) x 1.5 = 7 whole points.
                        set l_total=l_total+((((storedItemLife/ $A)+1)*3)/ 2) // $A = 10
                    else
                        // For this item, divide its stored life value by 10, drop the remainder, then add 1 proficiency point.
                        set l_total=l_total+(storedItemLife/ $A)+1 // $A = 10
                    endif
                else
                    // Increase l_total by 3.
                    set l_total=l_total+3
                endif
            endif
            set i=i+1
            exitwhen i>=bj_MAX_INVENTORY
        endloop
        set l_itm=null
    endif
    if(u==Player_GetHero(p))then
        if(l_isArmor)then
            set l_equipped=Prof_GetArmorUpgrade(u)
        else
            set l_equipped=Prof_GetWeaponUpgrade(u)
        endif
        if(upgradeId==l_equipped)then
            if(l_isArmor)then
                // (l_total) plus (GetPlayerTechCount(p, upgradeId, true)).
                set l_total=l_total+GetPlayerTechCount(p,upgradeId,true)
            else
                // ((l_total) plus (GetPlayerTechCount(p, upgradeId, true))) plus (1).
                set l_total=l_total+GetPlayerTechCount(p,upgradeId,true)+1
                if(GetUnitAbilityLevel(u,'A1DK')>0)then // 'A1DK': ability "Tarugaya Hero Bonus"
                    // Increase l_total by 2.
                    set l_total=l_total+2
                endif
            endif
        elseif(GetUnitAbilityLevel(u,'A135')>0)then // 'A135': ability "Joker Proficiency"
            // (l_total) plus (GetPlayerTechCount(p, upgradeId, true)).
            set l_total=l_total+GetPlayerTechCount(p,upgradeId,true)
        endif
    endif
    if(upgradeId=='R00M' and GetUnitAbilityLevel(u,'A079')>0)then // 'R00M': upgrade "Gun"; 'A079': ability "Proficiency Bonus"
        // Increase l_total by 10.
        set l_total=l_total+$A // $A = 10
    elseif(upgradeId=='R00I' and GetUnitAbilityLevel(u,'A1A1')>0)then // 'R00I': upgrade "Heavens Forged Axe"; 'A1A1': ability "Spear Hybrid"
        // Increase l_total by 9.
        set l_total=l_total+9
    elseif(upgradeId=='R00B' and GetUnitAbilityLevel(u,'A182')>0)then // 'R00B': upgrade "Dagger"; 'A182': ability "Kazuma Effect"
        // Increase l_total by 8.
        set l_total=l_total+8
    elseif(upgradeId=='R000' and GetUnitAbilityLevel(u,'A1A2')>0)then // 'R000': upgrade "Tools"; 'A1A2': ability "Crossbow Tool"
        // Increase l_total by 7.
        set l_total=l_total+7
    elseif(upgradeId=='R004' and GetUnitAbilityLevel(u,'A07H')>0)then // 'R004': upgrade "Staff"; 'A07H': ability "White Robe"
        // Increase l_total by 6.
        set l_total=l_total+6
    endif
    if(l_total>0 and GetUnitAbilityLevel(u,'A136')>0 and not l_isArmor)then // 'A136': ability "High Proficiency"
        // Increase proficiency by 50%, dropping any fraction: 5 points becomes 7, not 8.
        set l_total=(l_total*3)/ 2
    endif
    if(upgradeId=='R001' or upgradeId=='R004')then // 'R001': upgrade "Sword"; 'R004': upgrade "Staff"
        // Sword and Staff also gain half the Greatsword proficiency, dropping any fraction.
        set l_total=l_total+(Prof_GetLevel(u,'R00N')/ 2) // 'R00N': upgrade "Greatsword"
    endif
    set p=null
    return l_total
endfunction

function Prof_GetHybridLevel takes unit u returns integer
    // Add Greatsword, Sword, and Staff proficiency, then halve the sum and drop any fraction.
    return(Prof_GetLevel(u,'R00N')+Prof_GetLevel(u,'R001')+Prof_GetLevel(u,'R004'))/ 2 // 'R00N': upgrade "Greatsword"; 'R001': upgrade "Sword"; 'R004': upgrade "Staff"
endfunction

function Prof_GetSpellPower takes unit u,integer upgradeId,real manaWeight returns real
    local real l_mult=1
    local real currentMana=GetUnitState(u,UNIT_STATE_MANA)
    local real maximumMana=GetUnitState(u,UNIT_STATE_MAX_MANA)
    if IsPlayerInForce(GetOwningPlayer(u),udg_PlayingPlayers)then
        // Start the proficiency factor at 1, then add 0.1 per level: level 3 gives 1.3.
        set l_mult=l_mult+Prof_GetLevel(u,upgradeId)*.1
    endif
    if(maximumMana>0)then
        // Current mana divided by maximum mana is how full the mana bar is.
        // Half full means 0.5; multiply the proficiency factor by that fraction and the mana weight.
        set l_mult=l_mult*(currentMana/ maximumMana)*manaWeight
    endif
    // Add the base multiplier of 1 after the mana-based bonus.
    // Example: factor 1.3, half mana, and weight 0.5 give 1 + 1.3 x 0.5 x 0.5 = 1.325.
    set l_mult=l_mult+1
    if(GetUnitAbilityLevel(u,'B06N')>0)then // 'B06N': buff tooltip "Mind Charge"
        // (l_mult) times (2).
        set l_mult=l_mult*2.
    endif
    if(GetUnitAbilityLevel(u,'A16K')>0 and currentMana>=maximumMana)then // 'A16K': ability "Concentration"
        // (l_mult) times (1.5).
        set l_mult=l_mult*1.5
    endif
    return l_mult
endfunction

function Prof_RodPower takes unit u returns real
    return Prof_GetSpellPower(u,'R003',.5) // 'R003': upgrade "Rod"
endfunction

function Prof_StaffPower takes unit u returns real
    return Prof_GetSpellPower(u,'R004',.5) // 'R004': upgrade "Staff"
endfunction

function Prof_StaffPowerAlt takes unit u returns real
    return Prof_GetSpellPower(u,'R004',.5) // 'R004': upgrade "Staff"
endfunction

function Prof_InnerManaPower takes unit u returns real
    return Prof_GetSpellPower(u,'R00L',1.) // 'R00L': upgrade "Inner Mana"
endfunction

function InitTrig_Prof takes nothing returns nothing
endfunction

endlibrary
