function Forsaken_SaveUnavailable takes nothing returns nothing
    call DisplayTimedTextToPlayer(GetTriggerPlayer(),0,0,20,"Forsaken test: saving is disabled while the new backpack save format is being evaluated. Use the normal Stage AS map for progression.")
endfunction

function Forsaken_RejectEquipment takes item gear,unit holder returns nothing
    call UnitUnequipItem(holder,gear)
    call UnitRemoveItem(holder,gear)
endfunction

function Forsaken_OnEquip takes nothing returns nothing
    local unit holder=GetTriggerUnit()
    if holder==Player_GetHero(GetOwningPlayer(holder)) then
        set ForsakenEquippedItem=GetEquippedItem()
        call Forsaken_ValidateEquipment()
        set ForsakenEquippedItem=null
    endif
    set holder=null
endfunction

function Forsaken_PrepareInventories takes nothing returns nothing
    local integer i=0
    local unit hero
    local unit gaya
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
            call UnitAddAbility(hero,'fBag')
            call UnitAddAbility(hero,'fGer')
            call UnitMakeAbilityPermanent(hero,true,'fBag')
            call UnitMakeAbilityPermanent(hero,true,'fGer')
        endif
        if gaya!=null then
            call UnitAddAbility(gaya,'fBag')
            call UnitMakeAbilityPermanent(gaya,true,'fBag')
        endif
        set i=i+1
    endloop
    set hero=null
    set gaya=null
endfunction

function Register_Forsaken_Equipment takes nothing returns nothing
    set gg_trg_Forsaken_Equipment=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Forsaken_Equipment,EVENT_PLAYER_UNIT_EQUIP_ITEM)
    call TriggerAddAction(gg_trg_Forsaken_Equipment,function Forsaken_OnEquip)
    set ForsakenInventoryTimer=CreateTimer()
    call TimerStart(ForsakenInventoryTimer,1.,true,function Forsaken_PrepareInventories)
endfunction
