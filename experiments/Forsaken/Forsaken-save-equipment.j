library TForsakenSaveEquipment requires TForsakenSavePosition
// Experimental placement of prepared transaction-owned gear only.
// Originals must already be safely quarantined by the future controller.
function FSE_CheckEquipment takes integer pid,unit hero returns boolean
    local integer slot=0
    local integer ordinal
    local integer index
    local item carried
    loop
        exitwhen slot>=9
        set carried=UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot))
        if carried!=null then
            set ordinal=0
            loop
                exitwhen ordinal>=FSN_Count[pid] or FSN_Item[pid*57+ordinal]==carried
                set ordinal=ordinal+1
            endloop
            if ordinal>=FSN_Count[pid] then
                set carried=null
                return false
            endif
            set index=pid*57+ordinal
            if FSN_PlacedUnit[index]!=hero or FSN_PlacedHolder[index]!=3 or FSN_PlacedSlot[index]!=slot or not FSN_EffectsReady[index] or FSN_EffectsStored[index] then
                set carried=null
                return false
            endif
            if not FSP_Check(pid,index) then
                set carried=null
                return false
            endif
        endif
        set slot=slot+1
    endloop
    set carried=null
    set ordinal=0
    loop
        exitwhen ordinal>=FSN_Count[pid]
        set index=pid*57+ordinal
        if FSN_PlacedItem[index]==FSN_Item[index] and FSN_PlacedUnit[index]==hero and FSN_PlacedHolder[index]==3 then
            if not FSP_Check(pid,index) then
                return false
            endif
        endif
        set ordinal=ordinal+1
    endloop
    return true
endfunction

function FSE_Place takes integer pid,integer ordinal,unit hero,integer slot,integer ringSpacerRaw,integer harmlessMarker returns boolean
    local integer index
    local integer auxiliary
    local item spacer
    local item carried
    local ability marker
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_RecoveryBlocked[pid] or FSN_ProgressionBlocked[pid] or FSN_HeroBlocked[pid] or FSN_SessionBlocked[pid] or FSN_UnitBlocked[pid] or FSN_ReferenceBlocked[pid] or FSN_BodyBlocked[pid] or FSN_OwnershipBlocked[pid] or FSN_PreparedBlocked[pid] or FSN_Busy[pid] or (FSN_State[pid]!=1 and FSN_State[pid]!=4) then
        return false
    endif
    set FSN_Busy[pid]=true
    if ordinal<0 or ordinal>=FSN_Count[pid] or hero==null or GetUnitTypeId(hero)==0 or slot<0 or slot>=9 then
        return FSN_Fail(pid)
    endif
    if GetOwningPlayer(hero)!=Player(pid) or UnitExtendedInventorySize(hero)!=30 or FSN_AuxCount[pid]!=0 then
        return FSN_Fail(pid)
    endif
    set index=pid*57+ordinal
    if not FSN_EffectsReady[index] or FSN_EffectsStored[index] or not FSN_Check(pid,index) or not FSA_BatchReady(pid) then
        return FSN_Fail(pid)
    endif
    if UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot))!=null or not FSE_CheckEquipment(pid,hero) then
        return FSN_Fail(pid)
    endif
    // A lone alternate ring needs an inert, reviewed Ring object to occupy Ring4.
    if slot==5 and UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(4))==null then
        if ringSpacerRaw==0 or harmlessMarker==0 then
            return FSN_Fail(pid)
        endif
        set spacer=CreateItem(ringSpacerRaw,GetUnitX(hero),GetUnitY(hero))
        if spacer==null then
            return FSN_Fail(pid)
        endif
        set auxiliary=pid*36
        set FSN_AuxItem[auxiliary]=spacer
        set FSN_AuxCount[pid]=1
        call SetItemVisible(spacer,false)
        set marker=BlzGetItemAbilityByIndex(spacer,0)
        if GetItemTypeId(spacer)!=ringSpacerRaw or IsItemVisible(spacer) or marker==null then
            set marker=null
            set spacer=null
            return FSN_Fail(pid)
        endif
        if BlzGetAbilityId(marker)!=harmlessMarker or BlzGetItemAbilityByIndex(spacer,1)!=null or GetItemEquipmentType(spacer)!=GetItemEquipmentType(FSN_Item[index]) then
            set marker=null
            set spacer=null
            return FSN_Fail(pid)
        endif
        set marker=null
        call UnitAddItem(hero,spacer)
        call UnitEquipItem(hero,spacer)
        if UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(4))!=spacer then
            set spacer=null
            return FSN_Fail(pid)
        endif
        set spacer=null
    endif
    set carried=FSN_Item[index]
    call UnitAddItem(hero,carried)
    call UnitEquipItem(hero,carried)
    set FSN_PlacedItem[index]=carried
    set FSN_PlacedUnit[index]=hero
    set FSN_PlacedOwner[index]=Player(pid)
    set FSN_PlacedHolder[index]=3
    set FSN_PlacedSlot[index]=slot
    set carried=null
    if not FSP_Check(pid,index) then
        return FSN_Fail(pid)
    endif
    if not FSN_CleanupAux(pid) then
        return FSN_Fail(pid)
    endif
    if not FSE_CheckEquipment(pid,hero) then
        return FSN_Fail(pid)
    endif
    set FSN_State[pid]=4
    set FSN_Busy[pid]=false
    return true
endfunction
endlibrary
