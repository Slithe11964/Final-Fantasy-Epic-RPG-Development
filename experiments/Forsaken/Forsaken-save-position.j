library TForsakenSavePosition requires TForsakenSaveEffects
// Placement primitive only. Caller must suppress gameplay hooks and journal originals.
// Equipment is refused until passive/cooldown rollback is implemented.

// A generic signed coordinate range is not the actual terrain boundary.
// Leave a full tile of clearance for the house footprint at creation.
function FSP_HousePoint takes real x,real y returns boolean
    return x>=GetRectMinX(bj_mapInitialPlayableArea)+128. and x<=GetRectMaxX(bj_mapInitialPlayableArea)-128. and y>=GetRectMinY(bj_mapInitialPlayableArea)+128. and y<=GetRectMaxY(bj_mapInitialPlayableArea)-128.
endfunction

// Shared readback used by owned house staging and the private engine probe.
function FSP_HouseShape takes unit candidate,integer raw returns boolean
    if candidate==null then
        return false
    endif
    return GetUnitTypeId(candidate)==raw and GetOwningPlayer(candidate)==Player(PLAYER_NEUTRAL_PASSIVE) and not IsUnitType(candidate,UNIT_TYPE_HERO) and GetWidgetLife(candidate)>0.405 and IsUnitHidden(candidate) and IsUnitPaused(candidate) and BlzIsUnitInvulnerable(candidate) and UnitInventorySize(candidate)==6 and UnitExtendedInventorySize(candidate)==0
endfunction

function FSP_At takes unit holder,integer kind,integer slot returns item
    if kind==2 then
        return UnitItemInBagSlot(holder,slot)
    elseif kind==3 then
        return UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot))
    endif
    return UnitItemInSlot(holder,slot)
endfunction

function FSP_Check takes integer pid,integer index returns boolean
    if FSN_PlacedItem[index]!=FSN_Item[index] or FSN_PlacedItem[index]==null or FSN_PlacedUnit[index]==null then
        return false
    endif
    if GetUnitTypeId(FSN_PlacedUnit[index])==0 or GetOwningPlayer(FSN_PlacedUnit[index])!=FSN_PlacedOwner[index] then
        return false
    endif
    if FSN_PlacedHolder[index]==2 and UnitExtendedInventorySize(FSN_PlacedUnit[index])!=30 then
        return false
    endif
    if FSP_At(FSN_PlacedUnit[index],FSN_PlacedHolder[index],FSN_PlacedSlot[index])!=FSN_PlacedItem[index] then
        return false
    endif
    if not FSN_EffectsReady[index] or FSN_EffectsStored[index]!=(FSN_PlacedHolder[index]==2) or not FSA_Check(index) then
        return false
    endif
    return IsItemOwned(FSN_PlacedItem[index]) and not IsItemVisible(FSN_PlacedItem[index]) and FSN_CheckMetadata(pid,index)
endfunction

function FSP_PlaceCore takes integer pid,integer ordinal,unit holder,integer kind,integer slot,integer spacerRaw returns boolean
    local integer index
    local integer position=0
    local integer limit=0
    local integer auxiliary
    local item spacer
    local item carried
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_Operation[pid]!=3 or not FSN_Busy[pid] or FSN_Executing[pid] then
        return false
    endif
    set FSN_Executing[pid]=true
    set FSN_Busy[pid]=true
    if ordinal<0 or ordinal>=FSN_Count[pid] or holder==null or GetUnitTypeId(holder)==0 then
        return FSN_Fail(pid)
    endif
    if kind!=1 and kind!=2 and kind!=4 and kind!=5 then
        return FSN_Fail(pid)
    endif
    if kind!=5 and GetOwningPlayer(holder)!=Player(pid) then
        return FSN_Fail(pid)
    endif
    if slot<0 or (kind==2 and slot>=30) or (kind!=2 and slot>=6) then
        return FSN_Fail(pid)
    endif
    if kind==2 and (UnitExtendedInventorySize(holder)!=30 or spacerRaw==0) then
        return FSN_Fail(pid)
    endif
    if FSP_At(holder,kind,slot)!=null or FSN_AuxCount[pid]!=0 then
        return FSN_Fail(pid)
    endif
    set index=pid*57+ordinal
    set FSN_PlacedOwner[index]=GetOwningPlayer(holder)
    if not FSN_Check(pid,index) or not FSN_EffectsReady[index] or FSN_EffectsStored[index]!=(kind==2) or not FSA_BatchReady(pid) then
        return FSN_Fail(pid)
    endif
    // Fill earlier empty quick/bag positions so UnitAddItem reaches the exact
    // requested bag slot. Never create a copy using UnitAddItemToSlotById.
    if kind==2 then
        set limit=6+slot
    endif
    loop
        exitwhen position>=limit
        if (position<6 and UnitItemInSlot(holder,position)==null) or (position>=6 and UnitItemInBagSlot(holder,position-6)==null) then
            set spacer=CreateItem(spacerRaw,GetUnitX(holder),GetUnitY(holder))
            if spacer==null then
                return FSN_Fail(pid)
            endif
            set auxiliary=pid*36+FSN_AuxCount[pid]
            set FSN_AuxItem[auxiliary]=spacer
            set FSN_AuxCount[pid]=FSN_AuxCount[pid]+1
            call SetItemVisible(spacer,false)
            if GetItemTypeId(spacer)!=spacerRaw or IsItemVisible(spacer) then
                set spacer=null
                return FSN_Fail(pid)
            endif
            call UnitAddItem(holder,spacer)
            if (position<6 and UnitItemInSlot(holder,position)!=spacer) or (position>=6 and UnitItemInBagSlot(holder,position-6)!=spacer) then
                set spacer=null
                return FSN_Fail(pid)
            endif
        endif
        set position=position+1
    endloop
    set spacer=null
    set carried=FSN_Item[index]
    call UnitAddItem(holder,carried)
    if kind!=2 and UnitItemInSlot(holder,slot)!=carried then
        call UnitDropItemSlot(holder,carried,slot)
    endif
    set FSN_PlacedItem[index]=carried
    set FSN_PlacedUnit[index]=holder
    set FSN_PlacedHolder[index]=kind
    set FSN_PlacedSlot[index]=slot
    set carried=null
    if not FSP_Check(pid,index) then
        return FSN_Fail(pid)
    endif
    if not FSN_CleanupAux(pid) then
        return FSN_Fail(pid)
    endif
    // Removing fillers must not compact/move the requested item.
    if not FSP_Check(pid,index) then
        return FSN_Fail(pid)
    endif
    set FSN_State[pid]=4
    set FSN_Executing[pid]=false
    set FSN_Busy[pid]=false
    return true
endfunction

// Legacy entry retains every original phase guard.
function FSP_Place takes integer pid,integer ordinal,unit holder,integer kind,integer slot,integer spacerRaw returns boolean
    local boolean result
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_RecoveryBlocked[pid] or FSN_ProgressionBlocked[pid] or FSN_HeroBlocked[pid] or FSN_SessionBlocked[pid] or FSN_UnitBlocked[pid] or FSN_ReferenceBlocked[pid] or FSN_BodyBlocked[pid] or FSN_OwnershipBlocked[pid] or FSN_PreparedBlocked[pid] or FSN_ActivationBlocked[pid] or FSN_Busy[pid] or (FSN_State[pid]!=1 and FSN_State[pid]!=4) then
        return false
    endif
    set FSN_Busy[pid]=true
    set FSN_Operation[pid]=3
    set result=FSP_PlaceCore(pid,ordinal,holder,kind,slot,spacerRaw)
    set FSN_Operation[pid]=0
    set FSN_Busy[pid]=false
    return result
endfunction

function FSP_Verify takes integer pid returns boolean
    local integer ordinal=0
    local integer index
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_Busy[pid] or (FSN_State[pid]!=1 and FSN_State[pid]!=4) then
        return false
    endif
    set FSN_Busy[pid]=true
    loop
        exitwhen ordinal>=FSN_Count[pid]
        set index=pid*57+ordinal
        if not FSN_EffectsReady[index] or not FSA_Check(index) then
            return FSN_Fail(pid)
        endif
        if FSN_PlacedItem[index]==FSN_Item[index] then
            if not FSP_Check(pid,index) then
                return FSN_Fail(pid)
            endif
        elseif not FSN_Check(pid,index) then
            return FSN_Fail(pid)
        endif
        set ordinal=ordinal+1
    endloop
    set FSN_Busy[pid]=false
    return true
endfunction
endlibrary
