library TBackpack requires TAbil, TPlayerHero, TTalents, TGearSlots, TItemCooldown
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
    trigger gg_trg_Backpack_Drop=null
    trigger gg_trg_Backpack_Guard=null
    trigger gg_trg_Backpack_Orders=null
    constant integer BACKPACK_ABILITY='tBag'
    constant integer BACKPACK_RETURN='tBhr'
    constant integer BACKPACK_HOLDER='tBpk'
    constant integer BACKPACK_SLOTS=6
    constant integer BACKPACK_NEXT='tBnx'
    constant integer BACKPACK_PREV='tBpv'
    // Page 1 holds worn equipment, page 2 the rings and trinket, pages 3 to 7 the bag.
    constant integer BACKPACK_PAGES=7
    constant integer BACKPACK_EQUIPMENT_PAGES=2
    // Where a holder waits before its player has a hero to stand beside.
    constant real BACKPACK_PARK_X=27648.
    constant real BACKPACK_PARK_Y=-27648.
    // An item that cannot be moved, dropped or sold, used to block the slots 1.29.2 would
    // otherwise hand out for free: Reforged gives nine equipment slots, so page 2 keeps three.
    constant integer BACKPACK_LOCKED='tBlk'
    constant integer BACKPACK_RING_SLOTS=3
    // How far from the hero -grab looks for an item lying on the ground.
    constant real BACKPACK_GRAB_RANGE=300.
    // Indexed (player id)*8+page, page counted from 0.
    unit array BackpackHolder
    integer array BackpackPage
    // True while the player is looking at a page, so the holder keeps up with the hero.
    boolean array BackpackShown
    // Passive bonuses granted to the hero for the gear it is wearing, indexed pid*64+n,
    // with the hero they were granted to so they can be taken off the right unit.
    integer array BackpackGranted
    integer array BackpackGrantedCount
    unit array BackpackBonusHero
    // Taking an item out of a unit inside the very event that announced it crashes 1.29.2,
    // so the work is queued here and done a moment later, outside the event.
    timer array BackpackDefer
    item array BackpackPendingItem
    integer array BackpackPendingPage
    // The mana the holder was last given, so that what a cast spent can be taken off the
    // hero instead. An item casts from whoever carries it, and worn gear is carried by the
    // holder, so without this the backpack would pay for your wands out of its own pool.
    real array BackpackMirroredMana
    boolean array BackpackSettleMana
    // Gear that casts shares one cooldown across the pages and the hero's own slots, the
    // way the map already shares one between consumables.
    timer array BackpackGearCooldown
    // The last pooled spell cast, kept until the game has started its cooldown and the same
    // wait can be read off the unit that cast it.
    unit array BackpackCdCaster
    integer array BackpackCdAbility
    // How many of each slot kind a page already holds, rebuilt on every check.
    integer array BackpackKindSeen
    // Working values for the item search, which runs through a filter function.
    item BackpackFound=null
    real BackpackFoundX=0.
    real BackpackFoundY=0.
    real BackpackFoundBest=0.
    // Fallback list, used when the game will not select the holder: one button per stored
    // item, indexed (player id)*8+slot, plus a Close button.
    dialog array BackpackDialog
    button array BackpackButton
endglobals

function Backpack_PageHolder takes integer pid,integer page returns unit
    local integer key=pid*8+page
    local unit hero
    local integer slot
    local real x=BACKPACK_PARK_X+page*128.
    local real y=BACKPACK_PARK_Y
    if BackpackHolder[key]==null then
        set hero=Player_GetHero(Player(pid))
        if hero!=null then
            set x=GetUnitX(hero)
            set y=GetUnitY(hero)
        endif
        set BackpackHolder[key]=CreateUnit(Player(pid),BACKPACK_HOLDER,x,y,270.)
        call SetUnitInvulnerable(BackpackHolder[key],true)
        // Fully transparent: the holder stands where the hero stands, so items leave and
        // arrive at the hero's feet, but there is no second unit to look at or click by
        // accident. It stays selectable, which is what shows its six slots.
        call SetUnitVertexColor(BackpackHolder[key],255,255,255,0)
        call SetUnitAcquireRange(BackpackHolder[key],.0)
        // Hidden until its page is opened, so seven holders do not share the hero's spot.
        call ShowUnit(BackpackHolder[key],false)
        // Not paused: the holder has no move speed, and a paused unit is awkward to select.
        if page==1 then
            // Rings and trinket: three slots, and the other three are blocked by an item
            // that cannot be moved, so 1.29.2 offers no more space than Reforged.
            set slot=BACKPACK_RING_SLOTS
            loop
                exitwhen slot>=BACKPACK_SLOTS
                call UnitAddItemToSlotById(BackpackHolder[key],BACKPACK_LOCKED,slot)
                set slot=slot+1
            endloop
        endif
    endif
    set hero=null
    return BackpackHolder[key]
endfunction

// Gives the holder the hero's mana, so an item cast from a page costs what it would cost
// the hero and is refused when the hero cannot pay.
function Backpack_MirrorMana takes integer pid returns nothing
    local unit hero=Player_GetHero(Player(pid))
    local unit holder=BackpackHolder[pid*8+BackpackPage[pid]]
    if hero!=null and holder!=null then
        set BackpackMirroredMana[pid]=GetUnitState(hero,UNIT_STATE_MANA)
        call SetUnitState(holder,UNIT_STATE_MANA,BackpackMirroredMana[pid])
    endif
    set hero=null
    set holder=null
endfunction

// Takes what the holder just spent out of the hero, then mirrors again.
function Backpack_SettleMana takes integer pid returns nothing
    local unit hero=Player_GetHero(Player(pid))
    local unit holder=BackpackHolder[pid*8+BackpackPage[pid]]
    local real spent
    if hero!=null and holder!=null then
        set spent=BackpackMirroredMana[pid]-GetUnitState(holder,UNIT_STATE_MANA)
        if spent>.0 then
            call SetUnitState(hero,UNIT_STATE_MANA,GetUnitState(hero,UNIT_STATE_MANA)-spent)
        endif
    endif
    set hero=null
    set holder=null
    call Backpack_MirrorMana(pid)
endfunction

// The holder has to stand where the hero stands to be useful: an item leaves an inventory at
// the unit holding it, so a holder parked in the map's corner can only drop items into the
// corner, and an item can only be dragged between two units that are close together. Standing
// on the hero rather than beside it also means every direction is equally in reach. Only the
// page being looked at is shown; the rest stay hidden where they are.
function Backpack_Anchor takes integer pid returns nothing
    local unit hero=Player_GetHero(Player(pid))
    local unit holder
    local integer page=0
    if hero==null then
        return
    endif
    loop
        exitwhen page>=BACKPACK_PAGES
        set holder=BackpackHolder[pid*8+page]
        if holder!=null and page!=BackpackPage[pid] and not IsUnitHidden(holder) then
            call ShowUnit(holder,false)
        endif
        set page=page+1
    endloop
    set holder=Backpack_PageHolder(pid,BackpackPage[pid])
    call ShowUnit(holder,true)
    // SetUnitPosition, not SetUnitX/SetUnitY: a unit whose movement type is none keeps its
    // model where it was when only its coordinates are set, so the holder worked from the
    // hero's spot while the wisp stayed behind in plain sight.
    call SetUnitPosition(holder,GetUnitX(hero),GetUnitY(hero))
    set hero=null
    set holder=null
    call Backpack_MirrorMana(pid)
endfunction

// The page the player is looking at, or page 0 before they open anything.
function Backpack_Holder takes integer pid returns unit
    return Backpack_PageHolder(pid,BackpackPage[pid])
endfunction

function Backpack_PageName takes integer page returns string
    if page==0 then
        return "Equipment"
    elseif page==1 then
        return "Rings and trinket"
    endif
    return "Bag "+I2S(page-BACKPACK_EQUIPMENT_PAGES+1)+" of "+I2S(BACKPACK_PAGES-BACKPACK_EQUIPMENT_PAGES)
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
    local unit holder
    set BackpackShown[pid]=true
    call Backpack_Anchor(pid)
    set holder=Backpack_Holder(pid)
    call DisplayTimedTextToPlayer(p,0.,0.,6.,"Backpack - "+Backpack_PageName(BackpackPage[pid]))
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
    set BackpackShown[GetPlayerId(p)]=true
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
    local integer pid=GetPlayerId(p)
    local unit hero=Player_GetHero(p)
    local unit holder=BackpackHolder[pid*8+BackpackPage[pid]]
    set BackpackShown[pid]=false
    if hero!=null and GetLocalPlayer()==p then
        call ClearSelection()
        call SelectUnit(hero,true)
    endif
    if holder!=null then
        call ShowUnit(holder,false)
    endif
    set hero=null
    set holder=null
endfunction

// Moves the item itself rather than making a fresh one, so charges and state survive.
// 1.29.2 has no native that puts an existing item straight into a chosen slot, so the item
// leaves its carrier and a bag page takes it into its first free slot. Equipment pages are
// skipped: a picked-up item is never worn by accident.
// Puts an item on one named page, used when the player chooses the page themselves.
function Backpack_StoreOn takes integer pid,integer page,unit carrier,item carried returns boolean
    local unit holder
    local integer slot
    local integer used
    if carried==null or page<0 or page>=BACKPACK_PAGES then
        return false
    endif
    // A tome or other power-up is used up the moment it is picked up: by now the item is
    // gone, and moving it crashes the game. GetItemTypeId is 0 for an item already removed.
    if IsItemPowerup(carried) or GetItemTypeId(carried)==0 then
        return false
    endif
    set holder=Backpack_PageHolder(pid,page)
    set slot=0
    set used=0
    loop
        exitwhen slot>=BACKPACK_SLOTS
        if UnitItemInSlot(holder,slot)!=null then
            set used=used+1
        endif
        set slot=slot+1
    endloop
    if used>=BACKPACK_SLOTS then
        set holder=null
        return false
    endif
    if carrier!=null then
        call UnitRemoveItem(carrier,carried)
    endif
    call SetItemPosition(carried,GetUnitX(holder),GetUnitY(holder))
    if UnitAddItem(holder,carried) then
        set holder=null
        return true
    endif
    if carrier!=null then
        call UnitAddItem(carrier,carried)
    endif
    set holder=null
    return false
endfunction

// A picked-up item goes to the first bag page with room, never to an equipment page.
function Backpack_Store takes integer pid,unit carrier,item carried returns boolean
    local integer page=BACKPACK_EQUIPMENT_PAGES
    loop
        exitwhen page>=BACKPACK_PAGES
        if Backpack_StoreOn(pid,page,carrier,carried) then
            return true
        endif
        set page=page+1
    endloop
    return false
endfunction

// Picks the nearest loose item to the hero. Run through EnumItemsInRect, which reports one
// item at a time, so the best so far is kept in globals.
function Backpack_WeighItem takes nothing returns nothing
    local item found=GetEnumItem()
    local real dx
    local real dy
    local real distance
    if not IsItemVisible(found) or IsItemOwned(found) or IsItemPowerup(found) then
        set found=null
        return
    endif
    set dx=GetItemX(found)-BackpackFoundX
    set dy=GetItemY(found)-BackpackFoundY
    set distance=dx*dx+dy*dy
    if BackpackFound==null or distance<BackpackFoundBest then
        set BackpackFound=found
        set BackpackFoundBest=distance
    endif
    set found=null
endfunction

// Takes the nearest item on the ground into the page being looked at. With a page open the
// hero can drop an item and pick it back up on another page, which is how an item moves
// between pages until click-to-equip lands.
function Backpack_Grab takes player p returns nothing
    local integer pid=GetPlayerId(p)
    local unit hero=Player_GetHero(p)
    local real range=BACKPACK_GRAB_RANGE
    if hero==null then
        return
    endif
    set BackpackFound=null
    set BackpackFoundBest=0.
    set BackpackFoundX=GetUnitX(hero)
    set BackpackFoundY=GetUnitY(hero)
    call EnumItemsInRect(Rect(BackpackFoundX-range,BackpackFoundY-range,BackpackFoundX+range,BackpackFoundY+range),null,function Backpack_WeighItem)
    if BackpackFound==null then
        call DisplayTimedTextToPlayer(p,0.,0.,8.,"Nothing lying nearby to pick up")
    elseif Backpack_StoreOn(pid,BackpackPage[pid],null,BackpackFound) then
        call DisplayTimedTextToPlayer(p,0.,0.,8.,"Picked up "+GetItemName(BackpackFound)+" into "+Backpack_PageName(BackpackPage[pid]))
    else
        call DisplayTimedTextToPlayer(p,0.,0.,8.,Backpack_PageName(BackpackPage[pid])+" is full")
    endif
    set BackpackFound=null
    set hero=null
endfunction

// How many of a slot kind a page may hold. Equipment page 1 holds one each of the six worn
// pieces, in the kind order, so its slots read weapon, offhand, helm, chest, gloves, boots.
// Page 2 holds two rings and a trinket. A bag page has no rules at all.
function Backpack_PageLimit takes integer page,integer kind returns integer
    if page==0 then
        if kind>=GEAR_PRIMARY and kind<=GEAR_BOOTS then
            return 1
        endif
    elseif page==1 then
        if kind==GEAR_RING then
            return 2
        elseif kind==GEAR_TRINKET then
            return 1
        endif
    endif
    return 0
endfunction

// Takes back every bonus this player's gear was granted. The hero is remembered from when
// they were granted, because a job change or a load replaces the hero unit.
function Backpack_ClearBonuses takes integer pid returns nothing
    local unit hero=BackpackBonusHero[pid]
    local integer i=0
    loop
        exitwhen i>=BackpackGrantedCount[pid]
        if hero!=null then
            call UnitMakeAbilityPermanent(hero,false,BackpackGranted[pid*64+i])
            call UnitRemoveAbility(hero,BackpackGranted[pid*64+i])
        endif
        set i=i+1
    endloop
    set BackpackGrantedCount[pid]=0
    set BackpackBonusHero[pid]=null
    set hero=null
endfunction

// An item's abilities only work on the unit carrying it, and worn gear is carried by a
// holder, so the hero is given each worn item's passive bonuses by script. An ability the
// hero already has from elsewhere is left alone, and so is not taken away later either.
function Backpack_ApplyBonuses takes integer pid returns nothing
    local unit hero=Player_GetHero(Player(pid))
    local unit holder
    local item worn
    local integer page=0
    local integer slot
    local integer itype
    local integer count
    local integer index
    local integer spellId
    call Backpack_ClearBonuses(pid)
    if hero==null then
        return
    endif
    set BackpackBonusHero[pid]=hero
    loop
        exitwhen page>=BACKPACK_EQUIPMENT_PAGES
        set holder=BackpackHolder[pid*8+page]
        if holder!=null then
            set slot=0
            loop
                exitwhen slot>=BACKPACK_SLOTS
                set worn=UnitItemInSlot(holder,slot)
                if worn!=null then
                    set itype=GetItemTypeId(worn)
                    set count=Gear_BonusCount(itype)
                    set index=0
                    loop
                        exitwhen index>=count or BackpackGrantedCount[pid]>=64
                        set spellId=Gear_Bonus(itype,index)
                        if spellId!=0 and GetUnitAbilityLevel(hero,spellId)==0 then
                            call UnitAddAbility(hero,spellId)
                            call UnitMakeAbilityPermanent(hero,true,spellId)
                            set BackpackGranted[pid*64+BackpackGrantedCount[pid]]=spellId
                            set BackpackGrantedCount[pid]=BackpackGrantedCount[pid]+1
                        endif
                        set index=index+1
                    endloop
                endif
                set slot=slot+1
            endloop
        endif
        set page=page+1
    endloop
    set hero=null
    set holder=null
    set worn=null
endfunction

// True for a bonus the hero is being given for the gear it wears.
function Backpack_IsGrantedBonus takes integer pid,integer spellId returns boolean
    local integer i=0
    loop
        exitwhen i>=BackpackGrantedCount[pid]
        if BackpackGranted[pid*64+i]==spellId then
            return true
        endif
        set i=i+1
    endloop
    return false
endfunction

// The hero's own six slots are carrying space, not a second set of equipment slots: anything
// can sit there, and nothing worn there pays out. An item in an inventory gives its abilities
// to whoever holds it, so the passives of gear in those slots are taken off again here. What
// the gear casts is left alone, so a wand in a quick slot still works, and a bonus the worn
// gear is already granting stays.
function Backpack_StripQuickSlots takes integer pid returns nothing
    local unit hero=Player_GetHero(Player(pid))
    local item carried
    local integer slot=0
    local integer itype
    local integer count
    local integer index
    local integer spellId
    if hero==null then
        return
    endif
    loop
        exitwhen slot>=BACKPACK_SLOTS
        set carried=UnitItemInSlot(hero,slot)
        if carried!=null then
            set itype=GetItemTypeId(carried)
            set count=Gear_BonusCount(itype)
            set index=0
            loop
                exitwhen index>=count
                set spellId=Gear_Bonus(itype,index)
                if spellId!=0 and not Backpack_IsGrantedBonus(pid,spellId) then
                    call UnitRemoveAbility(hero,spellId)
                endif
                set index=index+1
            endloop
        endif
        set slot=slot+1
    endloop
    set hero=null
    set carried=null
endfunction

// Keeps an equipment page honest: anything that is not equipment, belongs on the other
// equipment page, or doubles up on a piece already worn goes to the bag.
function Backpack_CheckPage takes integer pid,integer page returns nothing
    local player p=Player(pid)
    local unit holder=BackpackHolder[pid*8+page]
    local item worn
    local integer slot=0
    local integer kind=0
    if page>=BACKPACK_EQUIPMENT_PAGES or holder==null then
        return
    endif
    loop
        exitwhen kind>GEAR_KINDS
        set BackpackKindSeen[kind]=0
        set kind=kind+1
    endloop
    loop
        exitwhen slot>=BACKPACK_SLOTS
        set worn=UnitItemInSlot(holder,slot)
        if worn!=null and GetItemTypeId(worn)==BACKPACK_LOCKED then
            // A blocked slot: nothing to judge.
        elseif worn!=null then
            set kind=Gear_KindOf(GetItemTypeId(worn))
            if kind<=0 then
                call DisplayTimedTextToPlayer(p,0.,0.,8.,GetItemName(worn)+" is not equipment, so it goes in the bag")
                call Backpack_Store(pid,holder,worn)
            elseif Backpack_PageLimit(page,kind)==0 then
                call DisplayTimedTextToPlayer(p,0.,0.,8.,GetItemName(worn)+" is a "+Gear_KindName(kind)+", which belongs on the other equipment page")
                call Backpack_Store(pid,holder,worn)
            elseif BackpackKindSeen[kind]>=Backpack_PageLimit(page,kind) then
                call DisplayTimedTextToPlayer(p,0.,0.,8.,"You are already wearing a "+Gear_KindName(kind)+", so "+GetItemName(worn)+" goes in the bag")
                call Backpack_Store(pid,holder,worn)
            else
                set BackpackKindSeen[kind]=BackpackKindSeen[kind]+1
            endif
        endif
        set slot=slot+1
    endloop
    call Backpack_ApplyBonuses(pid)
    set p=null
    set holder=null
    set worn=null
endfunction

// Which page a unit is, or -1 for anything that is not one of this player's holders.
function Backpack_PageOf takes integer pid,unit which returns integer
    local integer page=0
    loop
        exitwhen page>=BACKPACK_PAGES
        if which!=null and BackpackHolder[pid*8+page]==which then
            return page
        endif
        set page=page+1
    endloop
    return -1
endfunction

// What a player is wearing in a given slot kind, for the item checks spread through the map.
function Gear_Worn takes integer pid,integer kind returns item
    local unit holder
    local item worn
    local integer page=0
    local integer slot
    loop
        exitwhen page>=BACKPACK_EQUIPMENT_PAGES
        set holder=BackpackHolder[pid*8+page]
        if holder!=null then
            set slot=0
            loop
                exitwhen slot>=BACKPACK_SLOTS
                set worn=UnitItemInSlot(holder,slot)
                if worn!=null and Gear_KindOf(GetItemTypeId(worn))==kind then
                    set holder=null
                    return worn
                endif
                set slot=slot+1
            endloop
        endif
        set page=page+1
    endloop
    set holder=null
    return null
endfunction

// True when the hero has this item in its own slots or anywhere in the backpack. The item
// checks spread through the map will move onto this, so worn gear still counts.
function Gear_HasItem takes unit hero,integer itemType returns boolean
    local integer pid
    local integer page=0
    local integer slot=0
    local unit holder
    if hero==null then
        return false
    endif
    loop
        exitwhen slot>=BACKPACK_SLOTS
        if GetItemTypeId(UnitItemInSlot(hero,slot))==itemType then
            return true
        endif
        set slot=slot+1
    endloop
    set pid=GetPlayerId(GetOwningPlayer(hero))
    loop
        exitwhen page>=BACKPACK_PAGES
        set holder=BackpackHolder[pid*8+page]
        if holder!=null then
            set slot=0
            loop
                exitwhen slot>=BACKPACK_SLOTS
                if GetItemTypeId(UnitItemInSlot(holder,slot))==itemType then
                    set holder=null
                    return true
                endif
                set slot=slot+1
            endloop
        endif
        set page=page+1
    endloop
    set holder=null
    return false
endfunction

// Lists what is worn and how many bonuses that comes to, so a test can be read off screen.
function Backpack_GearReport takes player p returns nothing
    local integer pid=GetPlayerId(p)
    local integer kind=GEAR_PRIMARY
    local integer held
    local item worn
    local string line=""
    loop
        exitwhen kind>GEAR_KINDS
        set worn=Gear_Worn(pid,kind)
        if worn!=null then
            set line=line+Gear_KindName(kind)+": "+GetItemName(worn)+" "
        endif
        set kind=kind+1
    endloop
    if line=="" then
        set line="nothing equipped"
    endif
    call DisplayTimedTextToPlayer(p,0.,0.,20.,"Gear - "+line)
    set kind=0
    set held=0
    loop
        exitwhen kind>=BackpackGrantedCount[pid]
        if BackpackBonusHero[pid]!=null and GetUnitAbilityLevel(BackpackBonusHero[pid],BackpackGranted[pid*64+kind])>0 then
            set held=held+1
        endif
        set kind=kind+1
    endloop
    call DisplayTimedTextToPlayer(p,0.,0.,20.,"Bonuses granted to your hero: "+I2S(held)+" of "+I2S(BackpackGrantedCount[pid])+" (the gear sits in the backpack; the bonuses are on the hero)")
    set worn=null
endfunction

// Which shared cooldown a spell belongs to: 1 for gear - weapons, elemental books and buff
// tomes - 2 for food and potions, 0 for anything that keeps a cooldown of its own. Both are
// shared by the hero's own six slots and every backpack page, because the game keeps a
// cooldown per unit and each page is a unit of its own.
function Backpack_PoolOf takes integer spellId returns integer
    if spellId==0 then
        return 0
    elseif Item_Cooldown_IsConsumable(spellId) then
        return 2
    elseif Gear_IsGearAbility(spellId) then
        return 1
    endif
    return 0
endfunction

// Gear has a timer of its own; food and potions use the map's existing shared timer, which
// Item_Cooldown already starts when the hero drinks or eats.
function Backpack_PoolTimer takes integer pid,integer pool returns timer
    if pool==1 then
        if BackpackGearCooldown[pid]==null then
            set BackpackGearCooldown[pid]=CreateTimer()
        endif
        return BackpackGearCooldown[pid]
    endif
    return udg_SpellCooldownTimer[pid+1]
endfunction

function Backpack_PoolLeft takes integer pid,integer pool returns real
    if pool<=0 then
        return .0
    endif
    return TimerGetRemaining(Backpack_PoolTimer(pid,pool))
endfunction

// Starts a pool, or leaves it alone when it already has longer to run.
function Backpack_StartPool takes integer pid,integer pool,real seconds returns nothing
    if pool>0 and seconds>Backpack_PoolLeft(pid,pool) then
        call TimerStart(Backpack_PoolTimer(pid,pool),seconds,false,null)
    endif
endfunction

// The cooldown a cast left behind, read off the unit that cast it once the game has started
// it: the real figure, whatever the spell's level and whichever game is running. The table
// value is only a fallback, and is asked for at the level number this game uses - 1.29.2 and
// Reforged count levels differently, which Abil_GetLevel accounts for.
function Backpack_CooldownAfterCast takes unit caster,integer spellId returns real
    local real left=BlzGetUnitAbilityCooldownRemaining(caster,spellId)
    if left>.0 then
        return left
    endif
    if GetUnitAbilityLevel(caster,spellId)<1 then
        // A consumed last charge may have removed the item ability before this readback.
        return BlzGetAbilityCooldown(spellId,udg_AbilityLevelIndex)
    endif
    return BlzGetAbilityCooldown(spellId,Abil_GetLevel(caster,spellId))
endfunction

// Refuses a use while its shared cooldown runs, and says why. True when it refused.
function Backpack_RefusePool takes unit caster,integer pool returns boolean
    local player p=GetOwningPlayer(caster)
    local integer pid=GetPlayerId(p)
    local real left
    if pool<=0 or not (caster==Player_GetHero(p) or Backpack_PageOf(pid,caster)>=0) then
        set p=null
        return false
    endif
    set left=Backpack_PoolLeft(pid,pool)
    if left<=.01 then
        set p=null
        return false
    endif
    // Paused for an instant so the stop takes the place of the order before it does anything:
    // no mana spent, no cooldown started, no charge used.
    call PauseUnit(caster,true)
    call IssueImmediateOrder(caster,"stop")
    call PauseUnit(caster,false)
    if pool==1 then
        call DisplayTimedTextToPlayer(p,0.,0.,4.,"|cffff0000Your gear is recovering ("+I2S(R2I(left+.99))+"s).|r")
    else
        call DisplayTimedTextToPlayer(p,0.,0.,4.,"|cffff0000Your food and potions are recovering ("+I2S(R2I(left+.99))+"s).|r")
    endif
    set p=null
    return true
endfunction

function Backpack_CooldownReport takes player p returns nothing
    local integer pid=GetPlayerId(p)
    call DisplayTimedTextToPlayer(p,0.,0.,20.,"Gear recovering: "+I2S(R2I(Backpack_PoolLeft(pid,1)+.99))+"s - food and potions recovering: "+I2S(R2I(Backpack_PoolLeft(pid,2)+.99))+"s")
endfunction

// Runs a moment after the event that asked for it: puts away whatever the hero picked up,
// then checks the equipment pages and grants what is worn. Everything that moves an item
// lives here, where no item event is in progress.
function Backpack_RunDeferred takes nothing returns nothing
    local timer which=GetExpiredTimer()
    local integer pid=0
    local item pending
    local unit hero
    local integer kind
    local boolean stored
    loop
        exitwhen pid>=bj_MAX_PLAYERS
        if BackpackDefer[pid]==which then
            set pending=BackpackPendingItem[pid]
            set BackpackPendingItem[pid]=null
            set hero=Player_GetHero(Player(pid))
            if pending!=null and GetItemTypeId(pending)!=0 and hero!=null and UnitHasItem(hero,pending) then
                // A page the player chose takes the item; a full hero falls back to any bag
                // page with room.
                if BackpackPendingPage[pid]>=BACKPACK_EQUIPMENT_PAGES then
                    set stored=Backpack_Store(pid,hero,pending)
                else
                    set stored=Backpack_StoreOn(pid,BackpackPendingPage[pid],hero,pending)
                endif
                if stored then
                    set kind=Gear_KindOf(GetItemTypeId(pending))
                    if BackpackPendingPage[pid]<BACKPACK_EQUIPMENT_PAGES and kind>0 then
                        call DisplayTimedTextToPlayer(Player(pid),0.,0.,8.,"Equipped "+GetItemName(pending)+" ("+Gear_KindName(kind)+")")
                    else
                        call DisplayTimedTextToPlayer(Player(pid),0.,0.,8.,GetItemName(pending)+" went into the bag")
                    endif
                endif
            endif
            call Backpack_CheckPage(pid,0)
            call Backpack_CheckPage(pid,1)
            call Backpack_StripQuickSlots(pid)
            if BackpackCdAbility[pid]!=0 then
                call Backpack_StartPool(pid,Backpack_PoolOf(BackpackCdAbility[pid]),Backpack_CooldownAfterCast(BackpackCdCaster[pid],BackpackCdAbility[pid]))
                set BackpackCdAbility[pid]=0
                set BackpackCdCaster[pid]=null
            endif
            if BackpackSettleMana[pid] then
                set BackpackSettleMana[pid]=false
                call Backpack_SettleMana(pid)
            endif
            set pending=null
            set hero=null
            set which=null
            return
        endif
        set pid=pid+1
    endloop
    set which=null
endfunction

// Asks for that pass. Starting the timer again simply moves the moment it runs.
function Backpack_QueueWork takes integer pid returns nothing
    if BackpackDefer[pid]==null then
        set BackpackDefer[pid]=CreateTimer()
    endif
    call TimerStart(BackpackDefer[pid],0.,false,function Backpack_RunDeferred)
endfunction

// Pages wrap around, so one button reaches every page.
function Backpack_Turn takes player p,integer step returns nothing
    local integer pid=GetPlayerId(p)
    set BackpackPage[pid]=BackpackPage[pid]+step
    if BackpackPage[pid]<0 then
        set BackpackPage[pid]=BACKPACK_PAGES-1
    elseif BackpackPage[pid]>=BACKPACK_PAGES then
        set BackpackPage[pid]=0
    endif
    call Backpack_Open(p)
endfunction

// A cast from a holder: whatever mana it spent comes off the hero, and if it was a piece of
// gear the shared gear cooldown starts.
function Backpack_OnItemCast takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local integer id=GetSpellAbilityId()
    if caster==Player_GetHero(Player(pid)) or Backpack_PageOf(pid,caster)>=0 then
        if Backpack_PageOf(pid,caster)>=0 then
            set BackpackSettleMana[pid]=true
            call Backpack_QueueWork(pid)
        endif
        if Backpack_PoolOf(id)>0 then
            // Reserve the pool now so another page cannot cast before the deferred readback.
            call Backpack_StartPool(pid,Backpack_PoolOf(id),Backpack_CooldownAfterCast(caster,id))
            // The game starts the cooldown on the unit that cast; the deferred pass reads it
            // and holds every other copy, on the hero and on every page, for as long.
            set BackpackCdCaster[pid]=caster
            set BackpackCdAbility[pid]=id
            call Backpack_QueueWork(pid)
        endif
    endif
    set caster=null
endfunction

// Refuses a cast that the shared cooldowns say is not ready yet. The map already stops a
// cast this way when a talent is missing, so the same approach serves here.
// A second line behind the order check, for a spell that reaches its channel some other way.
// The channel comes before mana or cooldown are taken; the cast event, used before, comes
// too late for an instant item spell to be stopped.
function Backpack_GuardCast takes nothing returns nothing
    call Backpack_RefusePool(GetTriggerUnit(),Backpack_PoolOf(GetSpellAbilityId()))
endfunction

// Clicking an item orders "use the item in slot N", one order id per slot. It is judged here,
// before the item does anything, by the item itself rather than by a spell already under way.
function Backpack_OnOrder takes nothing returns nothing
    local integer order=GetIssuedOrderId()
    local unit u
    local item used
    local integer pool
    if order<852008 or order>852013 then
        return
    endif
    set u=GetTriggerUnit()
    set used=UnitItemInSlot(u,order-852008)
    if used!=null then
        set pool=Backpack_PoolOf(Gear_CastOf(GetItemTypeId(used)))
        if pool==0 and Gear_CastOf(GetItemTypeId(used))==0 and GetItemType(used)==ITEM_TYPE_CHARGED then
            // A stock potion the map writes no abilities for: charged items are consumables.
            set pool=2
        endif
        call Backpack_RefusePool(u,pool)
    endif
    set u=null
    set used=null
endfunction

function Backpack_OnCast takes nothing returns nothing
    local integer id=GetSpellAbilityId()
    call Backpack_OnItemCast()
    if id==BACKPACK_ABILITY then
        call Backpack_Open(GetTriggerPlayer())
    elseif id==BACKPACK_RETURN then
        call Backpack_Close(GetTriggerPlayer())
    elseif id==BACKPACK_NEXT then
        call Backpack_Turn(GetTriggerPlayer(),1)
    elseif id==BACKPACK_PREV then
        call Backpack_Turn(GetTriggerPlayer(),-1)
    endif
endfunction

// A picked-up item goes to the backpack when the hero's own slots are full, so a full
// inventory never stops a drop being collected.
// An item landing on or leaving a holder is the moment gear is equipped or taken off.
function Backpack_OnHolderChange takes nothing returns nothing
    local unit which=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(which))
    if GetUnitTypeId(which)!=BACKPACK_HOLDER then
        set which=null
        return
    endif
    if Backpack_PageOf(pid,which)>=0 then
        call Backpack_QueueWork(pid)
    endif
    set which=null
endfunction

function Backpack_OnPickup takes nothing returns nothing
    local unit hero=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    local item carried=GetManipulatedItem()
    local integer used=0
    local integer slot=0
    if carried!=null and (IsItemPowerup(carried) or GetItemTypeId(carried)==0) then
        // Tomes and other power-ups are used up as they are picked up; there is nothing
        // left to put anywhere, and reaching for it crashes 1.29.2.
        set hero=null
        set carried=null
        return
    endif
    if GetUnitTypeId(hero)==BACKPACK_HOLDER then
        call Backpack_OnHolderChange()
        set hero=null
        set carried=null
        return
    endif
    loop
        exitwhen slot>=BACKPACK_SLOTS
        if UnitItemInSlot(hero,slot)!=null then
            set used=used+1
        endif
        set slot=slot+1
    endloop
    if hero!=Player_GetHero(GetOwningPlayer(hero)) then
        // Someone else's unit picked it up; the backpack has no business with it.
    elseif BackpackShown[pid] then
        // While a page is open, what the hero picks up lands on that page, where the player
        // can see it, rather than in the first bag page with room. The move itself waits
        // for the deferred pass.
        set BackpackPendingItem[pid]=carried
        set BackpackPendingPage[pid]=BackpackPage[pid]
        call Backpack_QueueWork(pid)
    elseif used>=BACKPACK_SLOTS then
        set BackpackPendingItem[pid]=carried
        set BackpackPendingPage[pid]=BACKPACK_EQUIPMENT_PAGES
        call Backpack_QueueWork(pid)
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
    if command=="-blindcheck" then
        call Talents_BlindCheck(p)
    elseif command=="-grab" then
        call Backpack_Grab(p)
    elseif command=="-gear" then
        call Backpack_GearReport(p)
    elseif command=="-cdcheck" then
        call Backpack_CooldownReport(p)
    elseif command=="-bagwhere" then
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
        elseif Backpack_StoreOn(pid,BackpackPage[pid],hero,moving) then
            call DisplayTimedTextToPlayer(p,0.,0.,8.,"Put that into "+Backpack_PageName(BackpackPage[pid]))
        else
            call DisplayTimedTextToPlayer(p,0.,0.,8.,Backpack_PageName(BackpackPage[pid])+" is full")
        endif
    endif
    set p=null
    set hero=null
    set holder=null
    set moving=null
endfunction

// Every job hero gets the Backpack button; job changes and loads create new hero units.
// Also keeps an open page beside its hero, so walking away does not leave the backpack
// behind and items still drop within reach.
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
        if BackpackShown[i] then
            call Backpack_Anchor(i)
        endif
        // A job change or a load replaces the hero unit, which takes the worn bonuses with
        // it, so they are granted again to whoever the hero is now.
        if hero!=null and BackpackBonusHero[i]!=hero and BackpackGrantedCount[i]>0 then
            call Backpack_ApplyBonuses(i)
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

function Register_Backpack_Guard takes nothing returns nothing
    set gg_trg_Backpack_Guard=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Backpack_Guard,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddAction(gg_trg_Backpack_Guard,function Backpack_GuardCast)
endfunction

function Register_Backpack_Orders takes nothing returns nothing
    set gg_trg_Backpack_Orders=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Backpack_Orders,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Backpack_Orders,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Backpack_Orders,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerAddAction(gg_trg_Backpack_Orders,function Backpack_OnOrder)
endfunction

function Register_Backpack_Drop takes nothing returns nothing
    set gg_trg_Backpack_Drop=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Backpack_Drop,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddAction(gg_trg_Backpack_Drop,function Backpack_OnHolderChange)
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
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-blindcheck",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-grab",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-gear",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Backpack_Commands,Player(pid),"-cdcheck",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Backpack_Commands,function Backpack_OnCommand)
    call TimerStart(CreateTimer(),1.,true,function Backpack_GiveButton)
endfunction

function RegisterTriggers_Backpack takes nothing returns nothing
    // The slot table is only read here, so it is filled here rather than from startup.
    call GearSlots_Init()
    call Register_Backpack_Dialog()
    call Register_Backpack_Cast()
    call Register_Backpack_Pickup()
    call Register_Backpack_Drop()
    call Register_Backpack_Guard()
    call Register_Backpack_Orders()
    call Register_Backpack_Commands()
endfunction

function InitTrig_Backpack takes nothing returns nothing
endfunction

endlibrary
