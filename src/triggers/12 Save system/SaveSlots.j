library TSaveSlots requires TBackpack, TGearSlots, TPlayerHero
// The new save (FSVB codes and files, folder "12 Save system") was written for Reforged, where a
// hero has six quick slots, a 30-slot bag and nine equipment slots. 1.29.2 has none of those
// natives: there the bag and the worn gear live on the backpack pages instead. The functions here
// answer the save system's questions about bag and equipment positions from those pages, so the
// save code itself, and the codes and files it reads and writes, are exactly what Reforged uses.
//
// Save positions, the same in both versions:
//   0-5    hero's six quick slots
//   6-35   bag; bag position n is backpack page 3+n/6, slot n mod 6 (pages counted from 1)
//   36-44  equipment, in Reforged's order: helm, chest, gloves, boots, ring, ring, weapon,
//          offhand, trinket. Page 1 holds weapon, offhand, helm, chest, gloves and boots;
//          page 2 holds the two rings and the trinket.
//   45-50  Spirit of Gaya, 51-56 house
globals
    // On in both versions since stage ATL: -save writes the new code and -load reads new and old.
    // Set false to go back to the old save (the save modules then stay inactive).
    constant boolean SAVE_ENABLED=true
    // Retired at stage ATL (it switched the new save on for 1.29.2 only); nothing reads it. A
    // module build cannot change an existing variable, so it stays until a World Editor save.
    constant boolean SAVE_NEW_FORMAT=false
    constant integer SAVE_BAG_SIZE=30
    constant integer SAVE_LOADOUT_SLOTS=9
    // 1: equipment position+1 an item was loaded into, 2: page*8+slot it was put in,
    // 3: item type recorded as not droppable (1.29.2 cannot read that flag back).
    hashtable SaveSlotsTable=null
    // What each equipment position holds, pid*9+position, worked out by SaveSlots_Sort.
    item array SaveSlotsWorn
    string array SaveSlotsProblem
endglobals

function SaveSlots_Table takes nothing returns hashtable
    if SaveSlotsTable==null then
        set SaveSlotsTable=InitHashtable()
    endif
    return SaveSlotsTable
endfunction

// The player whose backpack answers for a unit: a hero still owned by a player. Inactive job
// heroes are handed to Neutral Passive, so they never read the backpack.
function SaveSlots_Owner takes unit u returns integer
    local integer pid
    if u==null or not IsUnitType(u,UNIT_TYPE_HERO) then
        return -1
    endif
    set pid=GetPlayerId(GetOwningPlayer(u))
    if pid<0 or pid>=8 then
        return -1
    endif
    return pid
endfunction

// Which page and slot each equipment position is loaded into.
function SaveSlots_LoadoutPage takes integer position returns integer
    if position==4 or position==5 or position==8 then
        return 1
    endif
    return 0
endfunction

function SaveSlots_LoadoutSlot takes integer position returns integer
    if position<4 then
        return position+2
    elseif position==4 or position==6 then
        return 0
    elseif position==5 or position==7 then
        return 1
    endif
    return 2
endfunction

// Whether a piece of gear may be saved at an equipment position, the same rule Reforged's
// load checks (a weapon may also be saved in the offhand, which is how Reforged dual-wields).
function SaveSlots_Legal takes integer kind,integer position returns boolean
    if kind==GEAR_HEAD then
        return position==0
    elseif kind==GEAR_CHEST then
        return position==1
    elseif kind==GEAR_GLOVES then
        return position==2
    elseif kind==GEAR_BOOTS then
        return position==3
    elseif kind==GEAR_RING then
        return position==4 or position==5
    elseif kind==GEAR_PRIMARY then
        return position==6 or position==7
    elseif kind==GEAR_OFFHAND then
        return position==7
    elseif kind==GEAR_TRINKET then
        return position==8
    endif
    return false
endfunction

// The equipment position a piece of gear takes when nothing else decides it.
function SaveSlots_Natural takes integer pid,integer kind,integer slot returns integer
    local integer base=pid*SAVE_LOADOUT_SLOTS
    if kind==GEAR_HEAD then
        return 0
    elseif kind==GEAR_CHEST then
        return 1
    elseif kind==GEAR_GLOVES then
        return 2
    elseif kind==GEAR_BOOTS then
        return 3
    elseif kind==GEAR_RING then
        if slot==1 and SaveSlotsWorn[base+5]==null then
            return 5
        elseif SaveSlotsWorn[base+4]==null then
            return 4
        endif
        return 5
    elseif kind==GEAR_PRIMARY then
        if SaveSlotsWorn[base+6]==null then
            return 6
        endif
        return 7
    elseif kind==GEAR_OFFHAND then
        return 7
    elseif kind==GEAR_TRINKET then
        return 8
    endif
    return -1
endfunction

// Works out what each equipment position holds. An item the save system loaded keeps the
// position it was loaded from while it stays where it was put, so a load reads back exactly;
// everything else takes its natural position. False when two worn items want one position.
function SaveSlots_Sort takes integer pid returns boolean
    local integer base=pid*SAVE_LOADOUT_SLOTS
    local integer pass=0
    local integer page
    local integer slot
    local integer kind
    local integer tag
    local integer position
    local unit holder
    local item worn
    local boolean ok=true
    set position=0
    loop
        exitwhen position>=SAVE_LOADOUT_SLOTS
        set SaveSlotsWorn[base+position]=null
        set position=position+1
    endloop
    set SaveSlotsProblem[pid]=null
    loop
        exitwhen pass>=2
        set page=0
        loop
            exitwhen page>=BACKPACK_EQUIPMENT_PAGES
            set holder=BackpackHolder[pid*8+page]
            set slot=0
            loop
                exitwhen holder==null or slot>=BACKPACK_SLOTS
                set worn=UnitItemInSlot(holder,slot)
                if worn!=null and GetItemTypeId(worn)!=BACKPACK_LOCKED then
                    set kind=Gear_KindOf(GetItemTypeId(worn))
                    set tag=LoadInteger(SaveSlots_Table(),1,GetHandleId(worn))-1
                    if tag>=0 and LoadInteger(SaveSlotsTable,2,GetHandleId(worn))!=page*8+slot then
                        set tag=-1
                    endif
                    if pass==0 then
                        if tag>=0 and SaveSlots_Legal(kind,tag) and SaveSlotsWorn[base+tag]==null then
                            set SaveSlotsWorn[base+tag]=worn
                        endif
                    else
                        // Skip what the first pass already placed by its load position.
                        set position=-1
                        if tag>=0 then
                            if SaveSlotsWorn[base+tag]==worn then
                                set position=-2
                            endif
                        endif
                        if position==-1 then
                            set position=SaveSlots_Natural(pid,kind,slot)
                        endif
                        if position==-2 then
                            // Placed.
                        elseif position<0 then
                            set SaveSlotsProblem[pid]=GetItemName(worn)+" is not equipment"
                            set ok=false
                        elseif SaveSlotsWorn[base+position]!=null then
                            set SaveSlotsProblem[pid]=GetItemName(worn)+" and "+GetItemName(SaveSlotsWorn[base+position])+" are both worn as "+Gear_KindName(kind)
                            set ok=false
                        else
                            set SaveSlotsWorn[base+position]=worn
                        endif
                    endif
                endif
                set slot=slot+1
            endloop
            set page=page+1
        endloop
        set pass=pass+1
    endloop
    set holder=null
    set worn=null
    return ok
endfunction

// Replaces Reforged's UnitItemInBagSlot.
function SaveSlots_Bag takes unit u,integer position returns item
    local integer pid=SaveSlots_Owner(u)
    local unit holder
    local item found
    if pid<0 or position<0 or position>=SAVE_BAG_SIZE then
        return null
    endif
    set holder=BackpackHolder[pid*8+BACKPACK_EQUIPMENT_PAGES+position/BACKPACK_SLOTS]
    if holder==null then
        return null
    endif
    set found=UnitItemInSlot(holder,ModuloInteger(position,BACKPACK_SLOTS))
    set holder=null
    if found!=null and GetItemTypeId(found)==BACKPACK_LOCKED then
        return null
    endif
    return found
endfunction

// Replaces Reforged's UnitItemInEquipmentSlot(u,ConvertLoadoutSlot(position)).
function SaveSlots_Equip takes unit u,integer position returns item
    local integer pid=SaveSlots_Owner(u)
    if pid<0 or position<0 or position>=SAVE_LOADOUT_SLOTS then
        return null
    endif
    call SaveSlots_Sort(pid)
    return SaveSlotsWorn[pid*SAVE_LOADOUT_SLOTS+position]
endfunction

// Replaces Reforged's UnitExtendedInventorySize: every player hero has the 30-slot backpack.
function SaveSlots_BagSize takes unit u returns integer
    if SaveSlots_Owner(u)<0 then
        return 0
    endif
    return SAVE_BAG_SIZE
endfunction

// A save starts only when every worn item has a position, so nothing is silently left out.
function SaveSlots_Ready takes integer pid returns boolean
    if udg_PlayerHero[pid+1]==null then
        return false
    elseif not SaveSlots_Sort(pid) then
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,20.,"Save stopped: "+SaveSlotsProblem[pid]+" on the equipment pages. Move it to the bag and save again.")
        return false
    endif
    return true
endfunction

// 1.29.2 can set whether an item can be dropped but cannot read it back, so the save system's
// own changes are remembered. Items keep the game's default, which is droppable for every item
// the save knows; only the save system ever loads one that is not.
function SaveSlots_SetDroppable takes item it,boolean flag returns nothing
    call SetItemDroppable(it,flag)
    if flag then
        call RemoveSavedInteger(SaveSlots_Table(),3,GetHandleId(it))
    else
        call SaveInteger(SaveSlots_Table(),3,GetHandleId(it),GetItemTypeId(it))
    endif
endfunction

// Replaces Reforged's BlzGetItemBooleanField(it,ITEM_BF_CAN_BE_DROPPED).
function SaveSlots_CanDrop takes item it returns boolean
    return LoadInteger(SaveSlots_Table(),3,GetHandleId(it))!=GetItemTypeId(it)
endfunction

// Puts an item into one slot of a unit's six, and reports whether it is there.
function SaveSlots_PlaceOn takes unit u,integer slot,item it returns boolean
    if u==null or it==null or UnitItemInSlot(u,slot)!=null then
        return false
    endif
    call SetItemPosition(it,GetUnitX(u),GetUnitY(u))
    if not UnitAddItem(u,it) then
        return false
    endif
    if UnitItemInSlot(u,slot)!=it then
        call UnitDropItemSlot(u,it,slot)
    endif
    return UnitItemInSlot(u,slot)==it
endfunction

// Loads an item into a bag position (kind 2) or an equipment position (kind 3).
function SaveSlots_Place takes integer pid,integer kind,integer position,item it returns boolean
    local integer page
    local integer slot
    if kind==2 then
        set page=BACKPACK_EQUIPMENT_PAGES+position/BACKPACK_SLOTS
        set slot=ModuloInteger(position,BACKPACK_SLOTS)
    else
        set page=SaveSlots_LoadoutPage(position)
        set slot=SaveSlots_LoadoutSlot(position)
    endif
    if not SaveSlots_PlaceOn(Backpack_PageHolder(pid,page),slot,it) then
        return false
    endif
    if kind==3 then
        call SaveInteger(SaveSlots_Table(),1,GetHandleId(it),position+1)
        call SaveInteger(SaveSlotsTable,2,GetHandleId(it),page*8+slot)
    endif
    return true
endfunction

// After a load is committed: the hero puts on what the pages hold. The page check applies the
// same rules as any other change: a second weapon stays only for a hero with Dual Wield, and
// gear the player may not wear yet moves to the bag.
function SaveSlots_AfterLoad takes integer pid returns nothing
    local integer page=0
    loop
        exitwhen page>=BACKPACK_EQUIPMENT_PAGES
        if BackpackHolder[pid*8+page]!=null then
            call Backpack_CheckPage(pid,page)
        endif
        set page=page+1
    endloop
    call Backpack_ApplyBonuses(pid)
endfunction

function InitTrig_SaveSlots takes nothing returns nothing
endfunction

endlibrary
