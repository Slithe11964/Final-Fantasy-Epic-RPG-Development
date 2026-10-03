library TUnit requires TFilter, TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Unit_ApplyUpgradeBonuses=null
endglobals

function Unit_HasNoEquipment takes unit u returns boolean
    local integer i=0
    local item l_slotItem
    loop
        set l_slotItem=UnitItemInSlot(u,i)
        if(l_slotItem!=null and(GetItemType(l_slotItem)==ITEM_TYPE_PERMANENT or GetItemType(l_slotItem)==ITEM_TYPE_POWERUP)and GetItemLevel(l_slotItem)>0)then
            set l_slotItem=null
            return false
        endif
        set i=i+1
        exitwhen i>=bj_MAX_INVENTORY
    endloop
    set l_slotItem=null
    return true
endfunction

function Unit_PlayersNearby takes real l_radius,unit u,boolean l_onlyTriggerUnit,boolean l_abortIfBusy,boolean l_warnPlayer returns boolean
    local location l_loc=GetUnitLoc(u)
    local group l_nearby=Group_UnitsInRangeOfLoc(l_radius,l_loc,Condition(function Filter_OwnedByPlayers))
    set bj_groupCountUnits=0
    call ForGroup(l_nearby,function CountUnitsInGroupEnum)
    call RemoveLocation(l_loc)
    call DestroyGroup(l_nearby)
    set l_loc=null
    set l_nearby=null
    if(l_onlyTriggerUnit and u!=GetTriggerUnit())then
        return false
    endif
    if(l_abortIfBusy and udg_InCinematicMode)then
        return false
    endif
    if(bj_groupCountUnits>0)then
        return true
    endif
    if(l_warnPlayer)then
        if(IsUnitType(u,UNIT_TYPE_HERO))then
            call DisplayTextToPlayer(GetTriggerPlayer(),0,0,GetHeroProperName(u)+": Come closer !")
        else
            call DisplayTextToPlayer(GetTriggerPlayer(),0,0,GetUnitName(u)+": Come closer !")
        endif
    endif
    return false
endfunction

function Unit_AngleToPoint takes unit l_origin,real l_x,real l_y returns real
    // Result 1: (l_y) minus (y position of l_origin).
    // Result 2: (l_x) minus (x position of l_origin).
    // Result 3: the angle in radians from the y gap (result 1) and x gap (result 2).
    // Result 4: (bj_RADTODEG) times (result 3).
    return bj_RADTODEG*Atan2(l_y-GetUnitY(l_origin),l_x-GetUnitX(l_origin))
endfunction

function Unit_ScaleToLevel takes unit u,integer l_targetLevel returns nothing
    local integer l_level=GetUnitLevel(u)
    local integer l_scaledLevel=R2I(l_targetLevel*1.334)
    local real l_factor
    local integer l_newMaxHp
    if l_level>=l_scaledLevel then
        return
    endif
    if(l_level+4>l_scaledLevel)then
        set l_factor=I2R(l_scaledLevel)/ I2R(l_level)
    else
        set l_factor=I2R(l_scaledLevel)/ I2R(l_level+4)
    endif
    // Result 1: (maximum health of u) plus (400).
    // Result 2: (result 1) times (l_factor).
    // Result 3: (result 2) times (0.01).
    // Result 4: (result 3) with its decimal part removed.
    // Result 5: (result 4) times (100).
    // Result 6: (30) times (l_targetLevel).
    // Result 7: (result 5) plus (result 6).
    set l_newMaxHp=(R2I((BlzGetUnitMaxHP(u)+400)*l_factor*.01)*'d')+(30*l_targetLevel)
    call BlzSetUnitMaxHP(u,l_newMaxHp)
    call SetUnitState(u,UNIT_STATE_LIFE,l_newMaxHp)
    // Result 1: (BlzGetUnitBaseDamage(u, 0)) plus (8).
    // Result 2: (result 1) times (l_factor).
    // Result 3: (result 2) with its decimal part removed.
    // Result 4: (1) times (l_targetLevel).
    // Result 5: (result 3) plus (result 4).
    call BlzSetUnitBaseDamage(u,R2I((BlzGetUnitBaseDamage(u,0)+8)*l_factor)+(1*l_targetLevel),0)
    // Result 1: (BlzGetUnitBaseDamage(u, 1)) plus (8).
    // Result 2: (result 1) times (l_factor).
    // Result 3: (result 2) with its decimal part removed.
    // Result 4: (1) times (l_targetLevel).
    // Result 5: (result 3) plus (result 4).
    call BlzSetUnitBaseDamage(u,R2I((BlzGetUnitBaseDamage(u,1)+8)*l_factor)+(1*l_targetLevel),1)
    call BlzSetUnitArmor(u,BlzGetUnitArmor(u)+(.5*l_targetLevel))
    call UnitAddAbility(u,'A1BC') // 'A1BC': ability "Stats Adjusted"
    if(IsUnitType(u,UNIT_TYPE_HERO)and l_level<l_targetLevel)then
        call SetHeroLevel(u,l_targetLevel,false)
    endif
endfunction

function Unit_ScaleToLevel60 takes unit u returns nothing
    if udg_EternityMode then
        call Unit_ScaleToLevel(u,60)
    endif
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Tarugaya takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Needs_TarugayaBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A058',udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(udg_CurrentHero))])>0)and(GetUnitAbilityLevelSwapped('A1DK',udg_CurrentHero)<=0) // 'A058': ability "Tarugaya"; 'A1DK': ability "Tarugaya Hero Bonus"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Needs_SukugayaBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('S004',udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(udg_CurrentHero))])>0)and(GetUnitAbilityLevelSwapped('A1DJ',udg_CurrentHero)<=0) // 'S004': ability "Sukugaya"; 'A1DJ': ability "Sukugaya Hero Bonus"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Needs_RakugayaBonus takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A07E',udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(udg_CurrentHero))])>0)and(GetUnitAbilityLevelSwapped('A1DL',udg_CurrentHero)<=0) // 'A07E': ability "Rakugaya"; 'A1DL': ability "Rakugaya Bonus"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Tools takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Tools_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_ToolsDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0X6',udg_CurrentHero)>=1) // 'A0X6': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Sword takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Sword_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_SwordDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0X7',udg_CurrentHero)>=1) // 'A0X7': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Bow takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Bow_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_BowDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0X8',udg_CurrentHero)>=1) // 'A0X8': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Dagger takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Dagger_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_DaggerDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0X9',udg_CurrentHero)>=1) // 'A0X9': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Spear takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Spear_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_SpearDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XA',udg_CurrentHero)>=1) // 'A0XA': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Axe takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Axe_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_AxeDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XB',udg_CurrentHero)>=1) // 'A0XB': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Katana takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Katana_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_KatanaDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XC',udg_CurrentHero)>=1) // 'A0XC': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Greatsword takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Greatsword_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_GreatswordDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XD',udg_CurrentHero)>=1) // 'A0XD': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Rod takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Rod_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_RodDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XE',udg_CurrentHero)>=1) // 'A0XE': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Gun takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Gun_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_GunDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XH',udg_CurrentHero)>=1) // 'A0XH': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_InnerMana takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_InnerMana_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_InnerManaDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XG',udg_CurrentHero)>=1) // 'A0XG': ability "Upgrade Damage Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_LeatherArmor_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_LeatherArmorDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0KL',udg_CurrentHero)>=1) // 'A0KL': ability "Upgrade Life Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_PlateArmor_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_PlateArmorDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0KM',udg_CurrentHero)>=1) // 'A0KM': ability "Upgrade Life Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_MysticArmor_LevelsPending takes nothing returns boolean
    return(udg_StatCalcValue>=1)
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Has_MysticArmorDummy takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0KN',udg_CurrentHero)>=1) // 'A0KN': ability "Upgrade Life Bonus Dummy"
endfunction

function Trig_Unit_ApplyUpgradeBonuses_Actions takes nothing returns nothing
    if(Trig_Unit_ApplyUpgradeBonuses_Needs_TarugayaBonus())then
        call UnitAddAbilityBJ('A1DK',udg_CurrentHero) // 'A1DK': ability "Tarugaya Hero Bonus"
        if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Tarugaya())then
            call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+$C8),0) // $C8 = 200
        else
            call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+$C8),1) // $C8 = 200
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Needs_SukugayaBonus())then
        call UnitAddAbilityBJ('A1DJ',udg_CurrentHero) // 'A1DJ': ability "Sukugaya Hero Bonus"
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Needs_RakugayaBonus())then
        call BlzSetUnitArmor(udg_CurrentHero,(BlzGetUnitArmor(udg_CurrentHero)+20.))
        call UnitAddAbilityBJ('A1DL',udg_CurrentHero) // 'A1DL': ability "Rakugaya Bonus"
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_ToolsDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R000',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0X6',udg_CurrentHero)) // 'R000': upgrade "Tools"; 'A0X6': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Tools_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Tools())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*8)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*2)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*8)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*2)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0X6',udg_CurrentHero,(GetPlayerTechCountSimple('R000',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0X6': ability "Upgrade Damage Bonus Dummy"; 'R000': upgrade "Tools"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_SwordDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R001',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0X7',udg_CurrentHero)) // 'R001': upgrade "Sword"; 'A0X7': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Sword_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Sword())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*19)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*4)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*19)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*4)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0X7',udg_CurrentHero,(GetPlayerTechCountSimple('R001',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0X7': ability "Upgrade Damage Bonus Dummy"; 'R001': upgrade "Sword"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_BowDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R002',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0X8',udg_CurrentHero)) // 'R002': upgrade "Bow"; 'A0X8': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Bow_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Bow())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*$E)),0) // $E = 14
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*2)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*$E)),1) // $E = 14
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*2)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0X8',udg_CurrentHero,(GetPlayerTechCountSimple('R002',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0X8': ability "Upgrade Damage Bonus Dummy"; 'R002': upgrade "Bow"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_DaggerDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R00B',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0X9',udg_CurrentHero)) // 'R00B': upgrade "Dagger"; 'A0X9': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Dagger_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Dagger())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*$C)),0) // $C = 12
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*2)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*$C)),1) // $C = 12
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*2)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0X9',udg_CurrentHero,(GetPlayerTechCountSimple('R00B',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0X9': ability "Upgrade Damage Bonus Dummy"; 'R00B': upgrade "Dagger"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_SpearDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R009',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0XA',udg_CurrentHero)) // 'R009': upgrade "Spear"; 'A0XA': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Spear_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Spear())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*8)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*7)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*8)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*7)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0XA',udg_CurrentHero,(GetPlayerTechCountSimple('R009',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0XA': ability "Upgrade Damage Bonus Dummy"; 'R009': upgrade "Spear"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_AxeDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R008',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0XB',udg_CurrentHero)) // 'R008': upgrade "Axe"; 'A0XB': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Axe_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Axe())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*8)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*1)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*8)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0XB',udg_CurrentHero,(GetPlayerTechCountSimple('R008',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0XB': ability "Upgrade Damage Bonus Dummy"; 'R008': upgrade "Axe"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_KatanaDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R00A',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0XC',udg_CurrentHero)) // 'R00A': upgrade "Katana"; 'A0XC': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Katana_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Katana())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*17)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*4)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*17)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*4)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0XC',udg_CurrentHero,(GetPlayerTechCountSimple('R00A',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0XC': ability "Upgrade Damage Bonus Dummy"; 'R00A': upgrade "Katana"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_GreatswordDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R00N',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0XD',udg_CurrentHero)) // 'R00N': upgrade "Greatsword"; 'A0XD': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Greatsword_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Greatsword())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*5)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*5)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*5)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*5)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0XD',udg_CurrentHero,(GetPlayerTechCountSimple('R00N',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0XD': ability "Upgrade Damage Bonus Dummy"; 'R00N': upgrade "Greatsword"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_RodDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R003',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0XE',udg_CurrentHero)) // 'R003': upgrade "Rod"; 'A0XE': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Rod_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Rod())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*4)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*4)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*1)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0XE',udg_CurrentHero,(GetPlayerTechCountSimple('R003',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0XE': ability "Upgrade Damage Bonus Dummy"; 'R003': upgrade "Rod"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_GunDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R00M',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0XH',udg_CurrentHero)) // 'R00M': upgrade "Gun"; 'A0XH': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_Gun_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_Gun())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*7)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue*5)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*7)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*5)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0XH',udg_CurrentHero,(GetPlayerTechCountSimple('R00M',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0XH': ability "Upgrade Damage Bonus Dummy"; 'R00M': upgrade "Gun"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_InnerManaDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R00L',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0XG',udg_CurrentHero)) // 'R00L': upgrade "Inner Mana"; 'A0XG': ability "Upgrade Damage Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_InnerMana_LevelsPending())then
            if(Trig_Unit_ApplyUpgradeBonuses_UsesAttack1_InnerMana())then
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,0)+(udg_StatCalcValue*2)),0)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,0)+(udg_StatCalcValue)),0)
            else
                call BlzSetUnitBaseDamage(udg_CurrentHero,(BlzGetUnitBaseDamage(udg_CurrentHero,1)+(udg_StatCalcValue*2)),1)
                call BlzSetUnitDiceNumber(udg_CurrentHero,(BlzGetUnitDiceNumber(udg_CurrentHero,1)+(udg_StatCalcValue*1)),1)
            endif
            call SetUnitAbilityLevelSwapped('A0XG',udg_CurrentHero,(GetPlayerTechCountSimple('R00L',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0XG': ability "Upgrade Damage Bonus Dummy"; 'R00L': upgrade "Inner Mana"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_LeatherArmorDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R006',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0KL',udg_CurrentHero)) // 'R006': upgrade "Leather Armor"; 'A0KL': ability "Upgrade Life Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_LeatherArmor_LevelsPending())then
            set udg_TempReal=GetUnitLifePercent(udg_CurrentHero)
            call BlzSetUnitMaxHP(udg_CurrentHero,(BlzGetUnitMaxHP(udg_CurrentHero)+(udg_StatCalcValue*300)))
            call SetUnitLifePercentBJ(udg_CurrentHero,udg_TempReal)
            call SetUnitAbilityLevelSwapped('A0KL',udg_CurrentHero,(GetPlayerTechCountSimple('R006',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0KL': ability "Upgrade Life Bonus Dummy"; 'R006': upgrade "Leather Armor"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_PlateArmorDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R005',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0KM',udg_CurrentHero)) // 'R005': upgrade "Plate Armor"; 'A0KM': ability "Upgrade Life Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_PlateArmor_LevelsPending())then
            set udg_TempReal=GetUnitLifePercent(udg_CurrentHero)
            call BlzSetUnitMaxHP(udg_CurrentHero,(BlzGetUnitMaxHP(udg_CurrentHero)+(udg_StatCalcValue*$96))) // $96 = 150
            call SetUnitLifePercentBJ(udg_CurrentHero,udg_TempReal)
            call SetUnitAbilityLevelSwapped('A0KM',udg_CurrentHero,(GetPlayerTechCountSimple('R005',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0KM': ability "Upgrade Life Bonus Dummy"; 'R005': upgrade "Plate Armor"
        endif
    endif
    if(Trig_Unit_ApplyUpgradeBonuses_Has_MysticArmorDummy())then
        set udg_StatCalcValue=((GetPlayerTechCountSimple('R007',GetOwningPlayer(udg_CurrentHero))+1)-GetUnitAbilityLevelSwapped('A0KN',udg_CurrentHero)) // 'R007': upgrade "Mystic Armor"; 'A0KN': ability "Upgrade Life Bonus Dummy"
        if(Trig_Unit_ApplyUpgradeBonuses_MysticArmor_LevelsPending())then
            set udg_TempReal=GetUnitLifePercent(udg_CurrentHero)
            call BlzSetUnitMaxHP(udg_CurrentHero,(BlzGetUnitMaxHP(udg_CurrentHero)+(udg_StatCalcValue*'d')))
            call SetUnitLifePercentBJ(udg_CurrentHero,udg_TempReal)
            call SetUnitAbilityLevelSwapped('A0KN',udg_CurrentHero,(GetPlayerTechCountSimple('R007',GetOwningPlayer(udg_CurrentHero))+1)) // 'A0KN': ability "Upgrade Life Bonus Dummy"; 'R007': upgrade "Mystic Armor"
        endif
    endif
endfunction

// World Editor calls InitTrig_Unit automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Unit (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Unit takes nothing returns nothing
endfunction

function Register_Unit_ApplyUpgradeBonuses takes nothing returns nothing
    set gg_trg_Unit_ApplyUpgradeBonuses=CreateTrigger()
    call DisableTrigger(gg_trg_Unit_ApplyUpgradeBonuses)
    call TriggerAddAction(gg_trg_Unit_ApplyUpgradeBonuses,function Trig_Unit_ApplyUpgradeBonuses_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Unit takes nothing returns nothing
    call Register_Unit_ApplyUpgradeBonuses() // starts off; run by Cmd, Gaya_Inventory, Job +1 more
endfunction

endlibrary
