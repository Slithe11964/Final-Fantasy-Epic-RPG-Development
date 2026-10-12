library TBackpack requires TPlayerHero
// Gear storage for 1.29.2, which has neither a frame UI nor an extended inventory native.
// A holder unit carries six inventory slots and the player's selection switches to it, so the
// hero's own six slots stay free for potions and books. The holder is parked away from play;
// it is invulnerable, has no collision and costs no food, and only its owner ever selects it.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Backpack_Cast=null
    trigger gg_trg_Backpack_Pickup=null
    trigger gg_trg_Backpack_Commands=null
    trigger gg_trg_Backpack_Dialog=null
    constant integer BACKPACK_ABILITY='tBag'
    constant integer BACKPACK_RETURN='tBhr'
    constant integer BACKPACK_HOLDER='tBpk'
    constant integer BACKPACK_SLOTS=6
    // Far enough from play that the holder is never walked into or seen.
    constant real BACKPACK_PARK_X=27648.
    constant real BACKPACK_PARK_Y=-27648.
    unit array BackpackHolder
    // Fallback list, used when the game will not select the holder: one button per stored
    // item, indexed (player id)*8+slot, plus a Close button.
    dialog array BackpackDialog
    button array BackpackButton
endglobals

function Backpack_Holder takes integer pid returns unit
    if BackpackHolder[pid]==null then
        set BackpackHolder[pid]=CreateUnit(Player(pid),BACKPACK_HOLDER,BACKPACK_PARK_X,BACKPACK_PARK_Y,270.)
        call SetUnitInvulnerable(BackpackHolder[pid],true)
        // Not paused: the holder has no move speed, and a paused unit is awkward to select.
    endif
    return BackpackHolder[pid]
endfunction

// A list of what is stored, for when the inventory view cannot be reached.
function Backpack_ShowList takes player p returns nothing
    local integer pid=GetPlayerId(p)
    local unit holder=Backpack_Holder(pid)
    local integer slot=0
    local integer stored=0
    local item carried
    if BackpackDialog[pid]==null then
        set BackpackDialog[pid]=DialogCreate()
        call TriggerRegisterDialogEvent(gg_trg_Backpack_Dialog,BackpackDialog[pid])
    endif
    call DialogClear(BackpackDialog[pid])
    loop
        exitwhen slot>=BACKPACK_SLOTS
        set carried=UnitItemInSlot(holder,slot)
        set BackpackButton[pid*8+slot]=null
        if carried!=null then
            set BackpackButton[pid*8+slot]=DialogAddButton(BackpackDialog[pid],"Take "+GetItemName(carried),0)
            set stored=stored+1
        endif
        set slot=slot+1
    endloop
    if stored==0 then
        call DialogSetMessage(BackpackDialog[pid],"Backpack (empty)")
    else
        call DialogSetMessage(BackpackDialog[pid],"Backpack")
    endif
    call DialogAddButton(BackpackDialog[pid],"Close",0)
    call DialogDisplay(p,BackpackDialog[pid],true)
    set holder=null
    set carried=null
endfunction

function Backpack_Open takes player p returns nothing
    local integer pid=GetPlayerId(p)
    local unit holder=Backpack_Holder(pid)
    if holder==null or GetUnitTypeId(holder)!=BACKPACK_HOLDER then
        call DisplayTimedTextToPlayer(p,0.,0.,12.,"Backpack: the holder could not be created")
        set holder=null
        return
    endif
    if GetLocalPlayer()==p then
        call ClearSelection()
        call SelectUnit(holder,true)
    endif
    // Selection is local, so only this player's own client can judge whether it took.
    if GetLocalPlayer()==p and not IsUnitSelected(holder,p) then
        // The inventory view only ever shows the selected unit, so fall back to a list.
        call Backpack_ShowList(p)
    endif
    set holder=null
endfunction

// Brings the holder to the hero before opening, to tell a placement problem apart from a
// problem with the holder itself.
function Backpack_OpenHere takes player p returns nothing
    local unit holder=Backpack_Holder(GetPlayerId(p))
    local unit hero=Player_GetHero(p)
    if holder!=null and hero!=null then
        call SetUnitPosition(holder,GetUnitX(hero)+128.,GetUnitY(hero))
        call DisplayTimedTextToPlayer(p,0.,0.,12.,"Backpack: holder moved beside your hero")
    endif
    call Backpack_Open(p)
    set holder=null
    set hero=null
endfunction

// Tries the same selection call on Gaya, a unit the player selects every game. If Gaya is
// refused too, selection is being blocked for everything and the holder is not at fault.
function Backpack_SelectTest takes player p returns nothing
    local unit gaya=udg_SpiritOfGaya[GetPlayerId(p)+1]
    local unit holder=Backpack_Holder(GetPlayerId(p))
    if gaya==null then
        call DisplayTimedTextToPlayer(p,0.,0.,20.,"Backpack test: no Gaya to try")
        return
    endif
    if GetLocalPlayer()==p then
        call ClearSelection()
        call SelectUnit(gaya,true)
    endif
    if GetLocalPlayer()==p then
        if IsUnitSelected(gaya,p) then
            call DisplayTimedTextToPlayer(p,0.,0.,20.,"Backpack test: Gaya selected, so the call works and the holder is the problem")
        else
            call DisplayTimedTextToPlayer(p,0.,0.,20.,"Backpack test: Gaya was refused too, so selection is blocked for everything")
        endif
    endif
    // Second attempt on the holder without clearing first, in case the clear is the problem.
    if GetLocalPlayer()==p then
        call SelectUnit(holder,true)
        if IsUnitSelected(holder,p) then
            call DisplayTimedTextToPlayer(p,0.,0.,20.,"Backpack test: the holder selected when added to a selection")
        endif
    endif
    set gaya=null
    set holder=null
endfunction

function Backpack_OnDialog takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local integer pid=GetPlayerId(p)
    local unit hero=Player_GetHero(p)
    local unit holder=Backpack_Holder(pid)
    local integer slot=0
    local item carried
    loop
        exitwhen slot>=BACKPACK_SLOTS
        if BackpackButton[pid*8+slot]==GetClickedButton() then
            set carried=UnitItemInSlot(holder,slot)
            if carried!=null and hero!=null then
                call UnitRemoveItem(holder,carried)
                if UnitAddItem(hero,carried) then
                    call DisplayTimedTextToPlayer(p,0.,0.,8.,"Took "+GetItemName(carried))
                else
                    call UnitAddItem(holder,carried)
                    call DisplayTimedTextToPlayer(p,0.,0.,8.,"Your own slots are full")
                endif
            endif
        endif
        set slot=slot+1
    endloop
    set p=null
    set hero=null
    set holder=null
    set carried=null
endfunction

// Says what the holder actually is, so a backpack that will not open explains itself.
function Backpack_Report takes player p returns nothing
    local unit holder=Backpack_Holder(GetPlayerId(p))
    local string state="missing"
    if holder!=null then
        set state="type "+I2S(GetUnitTypeId(holder))+" at "+I2S(R2I(GetUnitX(holder)))+","+I2S(R2I(GetUnitY(holder)))+" life "+I2S(R2I(GetWidgetLife(holder)))
        if IsUnitHidden(holder) then
            set state=state+" (hidden)"
        endif
        if GetOwningPlayer(holder)!=p then
            set state=state+" (not yours)"
        endif
    endif
    call DisplayTimedTextToPlayer(p,0.,0.,20.,"Backpack holder: "+state)
    set holder=null
endfunction

function Backpack_Close takes player p returns nothing
    local unit hero=Player_GetHero(p)
    if hero!=null and GetLocalPlayer()==p then
        call ClearSelection()
        call SelectUnit(hero,true)
    endif
    set hero=null
endfunction

// Items already in the backpack keep their slot; the first empty one takes a new item.
function Backpack_FreeSlot takes integer pid returns integer
    local unit holder=Backpack_Holder(pid)
    local integer slot=0
    loop
        exitwhen slot>=BACKPACK_SLOTS
        if UnitItemInSlot(holder,slot)==null then
            set holder=null
            return slot
        endif
        set slot=slot+1
    endloop
    set holder=null
    return -1
endfunction

// Moves the item itself rather than making a fresh one, so charges and state survive.
// 1.29.2 has no native that puts an existing item straight into a chosen slot, so the item
// leaves its carrier and the holder takes it into its first free slot.
function Backpack_Store takes integer pid,unit carrier,item carried returns boolean
    local unit holder
    if carried==null or Backpack_FreeSlot(pid)<0 then
        return false
    endif
    set holder=Backpack_Holder(pid)
    if carrier!=null then
        call UnitRemoveItem(carrier,carried)
    endif
    if not UnitAddItem(holder,carried) then
        if carrier!=null then
            call UnitAddItem(carrier,carried)
        endif
        set holder=null
        return false
    endif
    set holder=null
    return true
endfunction

function Backpack_OnCast takes nothing returns nothing
    local integer id=GetSpellAbilityId()
    if id==BACKPACK_ABILITY then
        call Backpack_Open(GetTriggerPlayer())
    elseif id==BACKPACK_RETURN then
        call Backpack_Close(GetTriggerPlayer())
    endif
endfunction

// A picked-up item goes to the backpack when the hero's own slots are full, so a full
// inventory never stops a drop being collected.
function Backpack_OnPickup takes nothing returns nothing
    local unit hero=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    local item carried=GetManipulatedItem()
    local integer used=0
    local integer slot=0
    loop
        exitwhen slot>=BACKPACK_SLOTS
        if UnitItemInSlot(hero,slot)!=null then
            set used=used+1
        endif
        set slot=slot+1
    endloop
    if hero==Player_GetHero(GetOwningPlayer(hero)) and used>=BACKPACK_SLOTS then
        if Backpack_Store(pid,hero,carried) then
            call DisplayTimedTextToPlayer(Player(pid),0.,0.,8.,"Bagged: "+GetItemName(carried)+" (B to open the backpack)")
        endif
    endif
    set hero=null
    set carried=null
endfunction

// Testing commands while the equipment pages are being built: move one slot either way.
function Backpack_OnCommand takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local integer pid=GetPlayerId(p)
    local string command=GetEventPlayerChatString()
    local integer slot=S2I(SubString(command,6,StringLength(command)))-1
    local unit hero=Player_GetHero(p)
    local unit holder=Backpack_Holder(pid)
    local item moving
    if command=="-bagwhere" then
        call Backpack_Report(p)
    elseif command=="-bagtest" then
        call Backpack_SelectTest(p)
    elseif command=="-bagnear" then
        call Backpack_OpenHere(p)
    elseif SubString(command,0,4)=="-bag" then
        call Backpack_Open(p)
    elseif hero==null or slot<0 or slot>=BACKPACK_SLOTS then
        call DisplayTimedTextToPlayer(p,0.,0.,8.,"Use -take 1 to 6 or -put 1 to 6")
    elseif SubString(command,0,5)=="-take" then
        set moving=UnitItemInSlot(holder,slot)
        if moving==null then
            call DisplayTimedTextToPlayer(p,0.,0.,8.,"That backpack slot is empty")
        elseif UnitAddItem(hero,moving) then
            call DisplayTimedTextToPlayer(p,0.,0.,8.,"Took "+GetItemName(moving))
        else
            call DisplayTimedTextToPlayer(p,0.,0.,8.,"Your own slots are full")
        endif
    else
        set moving=UnitItemInSlot(hero,slot)
        if moving==null then
            call DisplayTimedTextToPlayer(p,0.,0.,8.,"That hero slot is empty")
        elseif Backpack_Store(pid,hero,moving) then
            call DisplayTimedTextToPlayer(p,0.,0.,8.,"Bagged that item")
        else
            call DisplayTimedTextToPlayer(p,0.,0.,8.,"The backpack is full")
        endif
    endif
    set p=null
    set hero=null
    set holder=null
    set moving=null
endfunction

// Every job hero gets the Backpack button; job changes and loads create new hero units.
function Backpack_GiveButton takes nothing returns nothing
    local integer i=0
    local unit hero
    loop
        exitwhen i>=bj_MAX_PLAYERS
        set hero=Player_GetHero(Player(i))
        if hero!=null and GetUnitAbilityLevel(hero,BACKPACK_ABILITY)==0 then
            call UnitAddAbility(hero,BACKPACK_ABILITY)
            call UnitMakeAbilityPermanent(hero,true,BACKPACK_ABILITY)
        endif
        set i=i+1
    endloop
    set hero=null
endfunction

function Register_Backpack_Dialog takes nothing returns nothing
    set gg_trg_Backpack_Dialog=CreateTrigger()
    call TriggerAddAction(gg_trg_Backpack_Dialog,function Backpack_OnDialog)
endfunction

function Register_Backpack_Cast takes nothing returns nothing
    set gg_trg_Backpack_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Backpack_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(gg_trg_Backpack_Cast,function Backpack_OnCast)
endfunction

function Register_Backpack_Pickup takes nothing returns nothing
    set gg_trg_Backpack_Pickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Backpack_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(gg_trg_Backpack_Pickup,function Backpack_OnPickup)
endfunction

function Register_Backpack_Commands takes nothing returns nothing
    local integer pid=0
    set gg_trg_Backpack_Commands=CreateTrigger()
    loop
        exitwhen pid>=bj_MAX_PLAYERS
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-take ",false)
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-put ",false)
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-bag",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-bagwhere",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-bagnear",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-bagtest",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Backpack_Commands,function Backpack_OnCommand)
    call TimerStart(CreateTimer(),1.,true,function Backpack_GiveButton)
endfunction

function RegisterTriggers_Backpack takes nothing returns nothing
    call Register_Backpack_Dialog()
    call Register_Backpack_Cast()
    call Register_Backpack_Pickup()
    call Register_Backpack_Commands()
endfunction

function InitTrig_Backpack takes nothing returns nothing
endfunction

endlibrary
