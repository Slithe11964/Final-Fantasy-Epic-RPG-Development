function Forsaken_SaveUnavailable takes nothing returns nothing
    call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,20,"Forsaken test: saving is disabled while the new backpack save format is being evaluated. Use the normal Stage AS map for progression.")
endfunction

function Forsaken_RejectEquipment takes item gear,unit holder returns nothing
    call UnitUnequipItem(holder,gear)
    call UnitRemoveItem(holder,gear)
endfunction

function Forsaken_HoldsItem takes unit holder,item carried returns boolean
    local integer slot=0
    loop
        exitwhen slot>=6
        if UnitItemInSlot(holder,slot)==carried then
            return true
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=UnitExtendedInventorySize(holder)
        if UnitItemInBagSlot(holder,slot)==carried then
            return true
        endif
        set slot=slot+1
    endloop
    return false
endfunction

function Forsaken_PrepareQuickGear takes unit holder returns nothing
    local integer slot=0
    local integer variant
    local integer charges
    local item original
    local item replacement
    if ForsakenConvertingGear then
        return
    endif
    set ForsakenConvertingGear=true
    loop
        exitwhen slot>=6+UnitExtendedInventorySize(holder)
        if slot<6 then
            set original=UnitItemInSlot(holder,slot)
        else
            set original=UnitItemInBagSlot(holder,slot-6)
        endif
        set variant=LoadInteger(ForsakenGearTypes,0,GetItemTypeId(original))
        if original!=null and variant!=0 and not LoadBoolean(ForsakenGearTypes,50,GetHandleId(original)) and (slot>=6 or not LoadBoolean(ForsakenGearTypes,51,GetHandleId(original))) then
            call SaveBoolean(ForsakenGearTypes,50,GetHandleId(original),true)
            set charges=GetItemCharges(original)
            set replacement=CreateItem(variant,GetUnitX(holder),GetUnitY(holder))
            call SetItemCharges(replacement,0)
            call SetItemUserData(replacement,GetItemUserData(original))
            call SetWidgetLife(replacement,GetWidgetLife(original))
            call SetItemPlayer(replacement,GetItemPlayer(original),false)
            call UnitRemoveItem(holder,original)
            call UnitAddItem(holder,replacement)
            if Forsaken_HoldsItem(holder,replacement) then
                call SetItemCharges(replacement,charges)
                call RemoveSavedBoolean(ForsakenGearTypes,50,GetHandleId(original))
                call RemoveSavedBoolean(ForsakenGearTypes,51,GetHandleId(original))
                call RemoveItem(original)
            else
                call RemoveItem(replacement)
                call SetItemCharges(original,0)
                call UnitAddItem(holder,original)
                call SetItemCharges(original,charges)
                call DisplayTimedTextToPlayer(GetOwningPlayer(holder),0,0,15,"This gear could not enter your backpack. Your original item has been kept.")
            endif
        endif
        set slot=slot+1
    endloop
    set ForsakenConvertingGear=false
    set original=null
    set replacement=null
endfunction

function Forsaken_EnableHero takes unit holder returns nothing
    call UnitAddAbility(holder,'fBag')
    call UnitMakeAbilityPermanent(holder,true,'fBag')
    call UnitAddAbility(holder,'fGer')
    call UnitMakeAbilityPermanent(holder,true,'fGer')
    call UnitAddAbility(holder,'ASpc')
    call UnitMakeAbilityPermanent(holder,true,'ASpc')
    call Forsaken_PrepareQuickGear(holder)
    call Forsaken_PrepareDualWield(holder)
    call Forsaken_UpdatePanels(holder)
endfunction

function Forsaken_OnEquip takes nothing returns nothing
    local unit holder=GetTriggerUnit()
    if holder==null then
        if GetEventPlayerChatString()=="-forsaken" then
            set holder=Player_GetHero(GetTriggerPlayer())
            call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"Forsaken BI: bag capacity="+I2S(UnitExtendedInventorySize(holder))+". Backpack (B) opens FF talents/stats beside native gear. If needed use -forsaken-panels. Rows unlock at Normal, Master, Ultimate and Legendary mastery. Choices are cosmetic; no combat bonuses.")
        endif
        set holder=null
        return
    endif
    if ForsakenConvertingGear then
        set holder=null
        return
    endif
    call Forsaken_CarryEvent(holder)
    if GetTriggerEventId()!=EVENT_PLAYER_UNIT_PICKUP_ITEM and GetTriggerEventId()!=EVENT_PLAYER_UNIT_EQUIP_ITEM then
        set holder=null
        return
    endif
    if holder==Player_GetHero(GetOwningPlayer(holder)) then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_PICKUP_ITEM then
            call Forsaken_PrepareQuickGear(holder)
            set holder=null
            return
        endif
        set ForsakenEquippedItem=GetEquippedItem()
        call Forsaken_ValidateEquipment()
        set ForsakenEquippedItem=null
        call Forsaken_UpdatePanels(holder)
    endif
    set holder=null
endfunction

function Forsaken_ConvertCarriedGear takes unit holder returns nothing
    local integer slot=5+UnitExtendedInventorySize(holder)
    local integer equipmentSlot
    local item original
    local item replacement
    local integer variant
    loop
        exitwhen slot<0
        if slot<6 then
            set original=UnitItemInSlot(holder,slot)
        else
            set original=UnitItemInBagSlot(holder,slot-6)
        endif
        set variant=LoadInteger(ForsakenGearTypes,0,GetItemTypeId(original))
        set equipmentSlot=LoadInteger(ForsakenGearTypes,1,GetItemTypeId(original))
        if original!=null and variant!=0 and (UnitHasLoadoutSlotEmpty(holder,ConvertLoadoutSlot(equipmentSlot)) or (equipmentSlot==4 and UnitHasLoadoutSlotEmpty(holder,EQUIPMENT_LOADOUT_SLOT_RINGALT))) then
            set replacement=CreateItem(variant,GetUnitX(holder),GetUnitY(holder))
            call SetItemCharges(replacement,GetItemCharges(original))
            call SetItemUserData(replacement,GetItemUserData(original))
            if UnitAddItem(holder,replacement) then
                if UnitEquipItem(holder,replacement) and IsItemEquipped(replacement) then
                    call RemoveItem(original)
                else
                    call RemoveItem(replacement)
                endif
            else
                call RemoveItem(replacement)
            endif
        endif
        set slot=slot-1
    endloop
    set original=null
    set replacement=null
endfunction

function Forsaken_TestEquip takes nothing returns nothing
    local unit hero=Player_GetHero(GetTriggerPlayer())
    if hero!=null and UnitExtendedInventorySize(hero)>0 then
        call Forsaken_ConvertCarriedGear(hero)
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,15,"Forsaken test: carried gear was equipped where accepted. Rejected replacements keep their original items.")
    endif
    set hero=null
endfunction

function Forsaken_PrepareInventories takes nothing returns nothing
    local integer i=0
    local unit hero
    if not ForsakenSaveBlocked and udg_SaveCommandTrig!=null and udg_SaveToFileTrig!=null and udg_NewGamePlusTrig!=null and udg_NewGameMinusTrig!=null and udg_AutosaveTimerTrig!=null then
        call TriggerClearActions(udg_SaveCommandTrig)
        call TriggerAddAction(udg_SaveCommandTrig,function Forsaken_SaveUnavailable)
        call TriggerClearActions(udg_SaveToFileTrig)
        call TriggerAddAction(udg_SaveToFileTrig,function Forsaken_SaveUnavailable)
        call TriggerClearActions(udg_NewGamePlusTrig)
        call TriggerAddAction(udg_NewGamePlusTrig,function Forsaken_SaveUnavailable)
        call TriggerClearActions(udg_NewGameMinusTrig)
        call TriggerAddAction(udg_NewGameMinusTrig,function Forsaken_SaveUnavailable)
        call TriggerClearActions(udg_AutosaveTimerTrig)
        set ForsakenSaveBlocked=true
    endif
    loop
        exitwhen i>7
        set hero=Player_GetHero(Player(i))
        if hero!=null then
            call Forsaken_EnableHero(hero)
        endif
        set i=i+1
    endloop
    set hero=null
endfunction

function Register_Forsaken_Equipment takes nothing returns nothing
    local integer i=0
    set gg_trg_Forsaken_Equipment=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Forsaken_Equipment,EVENT_PLAYER_UNIT_EQUIP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Forsaken_Equipment,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Forsaken_Equipment,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Forsaken_Equipment,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Forsaken_Equipment,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Forsaken_Equipment,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    loop
        exitwhen i>7
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_Equipment,Player(i),"-forsaken",true)
        set i=i+1
    endloop
    call TriggerAddAction(gg_trg_Forsaken_Equipment,function Forsaken_OnEquip)
    set ForsakenInventoryTimer=CreateTimer()
    call TimerStart(ForsakenInventoryTimer,1.,true,function Forsaken_PrepareInventories)
endfunction

function Register_Forsaken_TestEquip takes nothing returns nothing
    local integer i=0
    set gg_trg_Forsaken_TestEquip=CreateTrigger()
    loop
        exitwhen i>7
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_TestEquip,Player(i),"-forsaken-equip",true)
        set i=i+1
    endloop
    call TriggerAddAction(gg_trg_Forsaken_TestEquip,function Forsaken_TestEquip)
endfunction
