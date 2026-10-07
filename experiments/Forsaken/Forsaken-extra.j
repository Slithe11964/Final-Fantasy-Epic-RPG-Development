function Forsaken_SaveUnavailable takes nothing returns nothing
    call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,20,"Forsaken test: saving is disabled while the new backpack save format is being evaluated. Use the normal Stage AS map for progression.")
endfunction

function Forsaken_RejectEquipment takes item gear,unit holder returns nothing
    call UnitUnequipItem(holder,gear)
    call UnitRemoveItem(holder,gear)
endfunction

function Forsaken_OnEquip takes nothing returns nothing
    local unit holder=GetTriggerUnit()
    if holder==null then
        if GetEventPlayerChatString()=="-forsaken" then
            set holder=Player_GetHero(GetTriggerPlayer())
            call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,30,"Forsaken test: backpack="+I2S(GetInventoryIndexOfItemTypeBJ(holder,'fBpk'))+", bag capacity="+I2S(UnitExtendedInventorySize(holder))+". Click the Backpack item in your six-slot inventory to open the native UI.")
        endif
        set holder=null
        return
    endif
    if holder==Player_GetHero(GetOwningPlayer(holder)) then
        set ForsakenEquippedItem=GetEquippedItem()
        call Forsaken_ValidateEquipment()
        set ForsakenEquippedItem=null
    endif
    set holder=null
endfunction

function Forsaken_ConvertCarriedGear takes unit holder returns nothing
    local integer slot=0
    local item original
    local item replacement
    local integer variant
    loop
        exitwhen slot>=6
        set original=UnitItemInSlot(holder,slot)
        set variant=LoadInteger(ForsakenGearTypes,0,GetItemTypeId(original))
        if original!=null and variant!=0 then
            set replacement=CreateItem(variant,GetUnitX(holder),GetUnitY(holder))
            call SetItemCharges(replacement,GetItemCharges(original))
            call SetItemUserData(replacement,GetItemUserData(original))
            if UnitAddItem(holder,replacement) then
                call RemoveItem(original)
            else
                call RemoveItem(replacement)
            endif
        endif
        set slot=slot+1
    endloop
    set original=null
    set replacement=null
endfunction

function Forsaken_PrepareInventories takes nothing returns nothing
    local integer i=0
    local unit hero
    local unit gaya
    local item backpack
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
        set gaya=udg_SpiritOfGaya[i+1]
        if hero!=null then
            if not UnitHasItemOfTypeBJ(hero,'fBpk') then
                set backpack=CreateItem('fBpk',GetUnitX(hero),GetUnitY(hero))
                if not UnitAddItem(hero,backpack) then
                    call RemoveItem(backpack)
                endif
            endif
            if UnitExtendedInventorySize(hero)>0 then
                call Forsaken_ConvertCarriedGear(hero)
            endif
        endif
        if gaya!=null then
            call UnitAddAbility(gaya,'AInx')
            call UnitMakeAbilityPermanent(gaya,true,'AInx')
        endif
        set i=i+1
    endloop
    set hero=null
    set gaya=null
    set backpack=null
endfunction

function Register_Forsaken_Equipment takes nothing returns nothing
    local integer i=0
    set gg_trg_Forsaken_Equipment=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Forsaken_Equipment,EVENT_PLAYER_UNIT_EQUIP_ITEM)
    loop
        exitwhen i>7
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_Equipment,Player(i),"-forsaken",true)
        set i=i+1
    endloop
    call TriggerAddAction(gg_trg_Forsaken_Equipment,function Forsaken_OnEquip)
    set ForsakenInventoryTimer=CreateTimer()
    call TimerStart(ForsakenInventoryTimer,1.,true,function Forsaken_PrepareInventories)
endfunction
