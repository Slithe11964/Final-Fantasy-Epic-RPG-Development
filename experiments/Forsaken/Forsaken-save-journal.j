library TForsakenSaveJournal requires TForsakenSaveLife
// Read-only item/position journal. Not a complete progression/passive journal.
globals
    boolean array FSJ_Ready
    boolean array FSJ_Busy
    boolean array FSJ_ReferencePending
    boolean array FSJ_UnitPending
    boolean array FSJ_SessionPending
    boolean array FSJ_HeroPending
    boolean array FSJ_ProgressionPending
    boolean array FSJ_RecoveryPending
    unit array FSJ_Hero
    unit array FSJ_Gaya
    unit array FSJ_House
    player array FSJ_HeroOwner
    player array FSJ_GayaOwner
    player array FSJ_HouseOwner
    item array FSJ_Item
    integer array FSJ_Raw
    integer array FSJ_Charges
    integer array FSJ_Binding
    player array FSJ_Owner
    boolean array FSJ_Visible
    integer array FSJ_Flags
    integer array FSJ_High
    integer array FSJ_Low
endglobals

function FSJ_At takes unit hero,unit gaya,unit house,integer position returns item
    if position<0 or position>=57 then
        return null
    elseif position<6 then
        return UnitItemInSlot(hero,position)
    elseif position<36 then
        return UnitItemInBagSlot(hero,position-6)
    elseif position<45 then
        return UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(position-36))
    elseif position<51 then
        if gaya!=null then
            return UnitItemInSlot(gaya,position-45)
        endif
    elseif house!=null then
        return UnitItemInSlot(house,position-51)
    endif
    return null
endfunction

function FSJ_UnitsValid takes integer pid,unit hero,unit gaya,unit house returns boolean
    if hero==null or GetUnitTypeId(hero)==0 or GetOwningPlayer(hero)!=Player(pid) then
        return false
    endif
    if UnitExtendedInventorySize(hero)!=30 then
        return false
    endif
    if gaya!=null then
        if gaya==hero or GetUnitTypeId(gaya)==0 or GetOwningPlayer(gaya)!=Player(pid) or UnitExtendedInventorySize(gaya)!=0 then
            return false
        endif
    endif
    if house!=null then
        // House ownership can be shared. Caller must supply the account's actual house.
        if house==hero or house==gaya or GetUnitTypeId(house)==0 or UnitExtendedInventorySize(house)!=0 then
            return false
        endif
    endif
    return true
endfunction

function FSJ_ReadFlags takes item carried returns integer
    local integer flags=0
    if IsItemInvulnerable(carried) then
        set flags=flags+1
    endif
    if BlzGetItemBooleanField(carried,ITEM_BF_CAN_BE_DROPPED) then
        set flags=flags+2
    endif
    if IsItemPawnable(carried) then
        set flags=flags+4
    endif
    return flags
endfunction

function FSJ_Matches takes integer pid,integer index,item carried returns boolean
    if carried!=FSJ_Item[index] then
        return false
    endif
    if carried==null then
        return true
    endif
    if GetItemTypeId(carried)==0 or GetItemTypeId(carried)!=FSJ_Raw[index] or not IsItemOwned(carried) then
        return false
    endif
    if GetItemCharges(carried)!=FSJ_Charges[index] or GetItemUserData(carried)!=FSJ_Binding[index] then
        return false
    endif
    if GetItemPlayer(carried)!=FSJ_Owner[index] or IsItemVisible(carried)!=FSJ_Visible[index] or FSJ_ReadFlags(carried)!=FSJ_Flags[index] then
        return false
    endif
    if not FSL_Pack(pid,GetWidgetLife(carried)) then
        return false
    endif
    return FSL_High[pid]==FSJ_High[index] and FSL_Low[pid]==FSJ_Low[index]
endfunction

function FSJ_Verify takes integer pid returns boolean
    local integer position=0
    local boolean matches=true
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSJ_Ready[pid] or FSJ_Busy[pid] then
        return false
    endif
    set FSJ_Busy[pid]=true
    if not FSJ_UnitsValid(pid,FSJ_Hero[pid],FSJ_Gaya[pid],FSJ_House[pid]) then
        set matches=false
    elseif GetOwningPlayer(FSJ_Hero[pid])!=FSJ_HeroOwner[pid] then
        set matches=false
    elseif FSJ_Gaya[pid]!=null and GetOwningPlayer(FSJ_Gaya[pid])!=FSJ_GayaOwner[pid] then
        set matches=false
    elseif FSJ_House[pid]!=null and GetOwningPlayer(FSJ_House[pid])!=FSJ_HouseOwner[pid] then
        set matches=false
    endif
    loop
        exitwhen position>=57 or not matches
        set matches=FSJ_Matches(pid,pid*57+position,FSJ_At(FSJ_Hero[pid],FSJ_Gaya[pid],FSJ_House[pid],position))
        set position=position+1
    endloop
    set FSJ_Busy[pid]=false
    return matches
endfunction

function FSJ_Capture takes integer pid,unit hero,unit gaya,unit house,boolean dropGetterVerified returns boolean
    local integer position=0
    local integer previous
    local integer index
    local integer target
    local item carried
    local boolean matches=true
    if not FSC_PlayerValid(pid) then
        return false
    endif
    // This capability must come from external native acceptance, never a save.
    if not dropGetterVerified or FSJ_Ready[pid] or FSJ_Busy[pid] then
        return false
    endif
    if not FSJ_UnitsValid(pid,hero,gaya,house) then
        return false
    endif
    set FSJ_Busy[pid]=true
    set FSJ_HeroOwner[pid+8]=GetOwningPlayer(hero)
    set FSJ_GayaOwner[pid+8]=GetOwningPlayer(gaya)
    set FSJ_HouseOwner[pid+8]=GetOwningPlayer(house)
    loop
        exitwhen position>=57 or not matches
        set index=(pid+8)*57+position
        set carried=FSJ_At(hero,gaya,house,position)
        set FSJ_Item[index]=carried
        set FSJ_Raw[index]=0
        set FSJ_Charges[index]=0
        set FSJ_Binding[index]=0
        set FSJ_Owner[index]=null
        set FSJ_Visible[index]=false
        set FSJ_Flags[index]=0
        set FSJ_High[index]=0
        set FSJ_Low[index]=0
        if carried!=null then
            set previous=0
            loop
                exitwhen previous>=position
                if FSJ_Item[(pid+8)*57+previous]==carried then
                    set matches=false
                endif
                set previous=previous+1
            endloop
            if GetItemTypeId(carried)==0 or not IsItemOwned(carried) or not FSL_Pack(pid,GetWidgetLife(carried)) then
                set matches=false
            endif
            set FSJ_Raw[index]=GetItemTypeId(carried)
            set FSJ_Charges[index]=GetItemCharges(carried)
            set FSJ_Binding[index]=GetItemUserData(carried)
            set FSJ_Owner[index]=GetItemPlayer(carried)
            set FSJ_Visible[index]=IsItemVisible(carried)
            set FSJ_Flags[index]=FSJ_ReadFlags(carried)
            set FSJ_High[index]=FSL_High[pid]
            set FSJ_Low[index]=FSL_Low[pid]
        endif
        set position=position+1
    endloop
    // Re-read the entire view before promoting scratch. Empty positions count.
    set position=0
    loop
        exitwhen position>=57 or not matches
        set matches=FSJ_Matches(pid,(pid+8)*57+position,FSJ_At(hero,gaya,house,position))
        set position=position+1
    endloop
    if not FSJ_UnitsValid(pid,hero,gaya,house) or GetOwningPlayer(hero)!=FSJ_HeroOwner[pid+8] or GetOwningPlayer(gaya)!=FSJ_GayaOwner[pid+8] or GetOwningPlayer(house)!=FSJ_HouseOwner[pid+8] then
        set matches=false
    endif
    if matches then
        set FSJ_Hero[pid]=hero
        set FSJ_Gaya[pid]=gaya
        set FSJ_House[pid]=house
        set FSJ_HeroOwner[pid]=FSJ_HeroOwner[pid+8]
        set FSJ_GayaOwner[pid]=FSJ_GayaOwner[pid+8]
        set FSJ_HouseOwner[pid]=FSJ_HouseOwner[pid+8]
        set position=0
        loop
            exitwhen position>=57
            set index=(pid+8)*57+position
            set target=pid*57+position
            set FSJ_Item[target]=FSJ_Item[index]
            set FSJ_Raw[target]=FSJ_Raw[index]
            set FSJ_Charges[target]=FSJ_Charges[index]
            set FSJ_Binding[target]=FSJ_Binding[index]
            set FSJ_Owner[target]=FSJ_Owner[index]
            set FSJ_Visible[target]=FSJ_Visible[index]
            set FSJ_Flags[target]=FSJ_Flags[index]
            set FSJ_High[target]=FSJ_High[index]
            set FSJ_Low[target]=FSJ_Low[index]
            set position=position+1
        endloop
        set FSJ_Ready[pid]=true
    endif
    // Always release scratch handle references, even after an incomplete scan.
    set position=0
    loop
        exitwhen position>=57
        set FSJ_Item[(pid+8)*57+position]=null
        set FSJ_Owner[(pid+8)*57+position]=null
        set position=position+1
    endloop
    set carried=null
    set FSJ_HeroOwner[pid+8]=null
    set FSJ_GayaOwner[pid+8]=null
    set FSJ_HouseOwner[pid+8]=null
    set FSJ_Busy[pid]=false
    return matches
endfunction

function FSJ_Release takes integer pid returns boolean
    local integer position=0
    local integer index
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSJ_RecoveryPending[pid] or FSJ_ProgressionPending[pid] or FSJ_HeroPending[pid] or FSJ_SessionPending[pid] or FSJ_UnitPending[pid] or FSJ_ReferencePending[pid] then
        return false
    endif
    if not FSJ_Verify(pid) then
        return false
    endif
    set FSJ_Busy[pid]=true
    loop
        exitwhen position>=57
        set index=pid*57+position
        set FSJ_Item[index]=null
        set FSJ_Owner[index]=null
        set position=position+1
    endloop
    set FSJ_Hero[pid]=null
    set FSJ_Gaya[pid]=null
    set FSJ_House[pid]=null
    set FSJ_HeroOwner[pid]=null
    set FSJ_GayaOwner[pid]=null
    set FSJ_HouseOwner[pid]=null
    set FSJ_Ready[pid]=false
    set FSJ_Busy[pid]=false
    return true
endfunction
endlibrary
