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
    constant integer BACKPACK_ABILITY='tBag'
    constant integer BACKPACK_RETURN='tBhr'
    constant integer BACKPACK_HOLDER='tBpk'
    constant integer BACKPACK_SLOTS=6
    // Far enough from play that the holder is never walked into or seen.
    constant real BACKPACK_PARK_X=27648.
    constant real BACKPACK_PARK_Y=-27648.
    unit array BackpackHolder
endglobals

function Backpack_Holder takes integer pid returns unit
    if BackpackHolder[pid]==null then
        set BackpackHolder[pid]=CreateUnit(Player(pid),BACKPACK_HOLDER,BACKPACK_PARK_X,BACKPACK_PARK_Y,270.)
        call SetUnitInvulnerable(BackpackHolder[pid],true)
        call PauseUnit(BackpackHolder[pid],true)
    endif
    return BackpackHolder[pid]
endfunction

function Backpack_Open takes player p returns nothing
    local integer pid=GetPlayerId(p)
    local unit holder=Backpack_Holder(pid)
    if GetLocalPlayer()==p then
        call ClearSelection()
        call SelectUnit(holder,true)
    endif
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
    if SubString(command,0,4)=="-bag" then
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
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Backpack_Commands,function Backpack_OnCommand)
    call TimerStart(CreateTimer(),1.,true,function Backpack_GiveButton)
endfunction

function RegisterTriggers_Backpack takes nothing returns nothing
    call Register_Backpack_Cast()
    call Register_Backpack_Pickup()
    call Register_Backpack_Commands()
endfunction

function InitTrig_Backpack takes nothing returns nothing
endfunction

endlibrary
