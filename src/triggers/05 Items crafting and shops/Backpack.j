library TBackpack requires TPlayerHero, TTalents, TGearSlots
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
    // The holder stands this far from the hero: close enough that items dropped from it land
    // within reach, far enough that both units can still be clicked apart.
    constant real BACKPACK_OFFSET=96.
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
    local real x=BACKPACK_PARK_X+page*128.
    local real y=BACKPACK_PARK_Y
    if BackpackHolder[key]==null then
        set hero=Player_GetHero(Player(pid))
        if hero!=null then
            set x=GetUnitX(hero)+BACKPACK_OFFSET
            set y=GetUnitY(hero)
        endif
        set BackpackHolder[key]=CreateUnit(Player(pid),BACKPACK_HOLDER,x,y,270.)
        call SetUnitInvulnerable(BackpackHolder[key],true)
        // Hidden until its page is opened, so six wisps do not stand around the hero.
        call ShowUnit(BackpackHolder[key],false)
        // Not paused: the holder has no move speed, and a paused unit is awkward to select.
    endif
    set hero=null
    return BackpackHolder[key]
endfunction

// The holder has to stand beside the hero to be useful: an item leaves an inventory at the
// unit holding it, so a holder parked in the map's corner can only drop items into the
// corner, and an item can only be dragged between two units that are close together. Only
// the page being looked at is shown; the rest stay hidden where they are.
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
    call SetUnitPosition(holder,GetUnitX(hero)+BACKPACK_OFFSET,GetUnitY(hero))
    set hero=null
    set holder=null
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
// leaves its carrier and a bag page takes it into its first free slot. Equipment pages are
// skipped: a picked-up item is never worn by accident.
// Puts an item on one named page, used when the player chooses the page themselves.
function Backpack_StoreOn takes integer pid,integer page,unit carrier,item carried returns boolean
    local unit holder
    if carried==null or page<0 or page>=BACKPACK_PAGES then
        return false
    endif
    set holder=Backpack_PageHolder(pid,page)
    if UnitItemInSlot(holder,BACKPACK_SLOTS-1)!=null then
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
    if not IsItemVisible(found) or IsItemOwned(found) then
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
    local integer ability
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
                        set ability=Gear_Bonus(itype,index)
                        if ability!=0 and GetUnitAbilityLevel(hero,ability)==0 then
                            call UnitAddAbility(hero,ability)
                            call UnitMakeAbilityPermanent(hero,true,ability)
                            set BackpackGranted[pid*64+BackpackGrantedCount[pid]]=ability
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
        if worn!=null then
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
    call DisplayTimedTextToPlayer(p,0.,0.,20.,"Bonuses granted: "+I2S(BackpackGrantedCount[pid]))
    set worn=null
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

function Backpack_OnCast takes nothing returns nothing
    local integer id=GetSpellAbilityId()
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
    local integer page
    local item moved
    if GetUnitTypeId(which)!=BACKPACK_HOLDER then
        set which=null
        return
    endif
    set page=Backpack_PageOf(pid,which)
    if page>=0 then
        call Backpack_CheckPage(pid,page)
        set moved=GetManipulatedItem()
        if page<BACKPACK_EQUIPMENT_PAGES and moved!=null and UnitHasItem(which,moved) then
            call DisplayTimedTextToPlayer(GetOwningPlayer(which),0.,0.,6.,"Equipped "+GetItemName(moved)+" ("+Gear_KindName(Gear_KindOf(GetItemTypeId(moved)))+")")
        endif
    endif
    set which=null
    set moved=null
endfunction

function Backpack_OnPickup takes nothing returns nothing
    local unit hero=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    local item carried=GetManipulatedItem()
    local integer used=0
    local integer slot=0
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
    if command=="-blindcheck" then
        call Talents_BlindCheck(p)
    elseif command=="-grab" then
        call Backpack_Grab(p)
    elseif command=="-gear" then
        call Backpack_GearReport(p)
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
    call Register_Backpack_Commands()
endfunction

function InitTrig_Backpack takes nothing returns nothing
endfunction

endlibrary
