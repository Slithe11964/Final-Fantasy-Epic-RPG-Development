library TForsakenSaveRecovery requires TForsakenSaveEquipment, TForsakenSaveJournal
// Original-item movement only. Not full progression/derived-state rollback.
// Cooldowns are per-game and may refresh on character changes by user decision.
// Caller must hold synchronized exclusion and suppress all inventory/effect hooks.
globals
    // 0 idle, 1 captured, 2 moving/recovery required, 3 quarantined, 4 blocked, 5 items restored.
    integer array FQR_State
    boolean array FQR_Busy
    hashtable array FQR_Table
    integer array FQR_AbilityCount
    integer array FQR_AbilityId
    ability array FQR_Ability
    boolean array FQR_Suspended
    integer array FQR_PassiveCount
    integer array FQR_PassiveId
    integer array FQR_AuxCount
    item array FQR_AuxItem
endglobals

function FQR_Unlock takes integer pid,boolean success returns boolean
    local integer position=0
    local item carried
    if not success then
        set FQR_State[pid]=4
        set FSN_RecoveryBlocked[pid]=true
        // Best-effort concealment, not proof of a gameplay freeze/containment.
        loop
            exitwhen position>=57
            set carried=FSJ_Item[pid*57+position]
            if carried!=null and GetItemTypeId(carried)!=0 then
                call SetItemVisible(carried,false)
            endif
            set position=position+1
        endloop
        set carried=null
    endif
    set FSN_Busy[pid]=false
    set FSJ_Busy[pid]=false
    set FQR_Busy[pid]=false
    return success
endfunction

function FQR_Unit takes integer pid,integer position returns unit
    if position<45 then
        return FSJ_Hero[pid]
    elseif position<51 then
        return FSJ_Gaya[pid]
    endif
    return FSJ_House[pid]
endfunction

function FQR_CheckInstances takes integer pid,integer index returns boolean
    local item carried=FSJ_Item[index]
    local integer abilityIndex=0
    local integer key
    local integer count=0
    local ability current
    if carried==null then
        return true
    endif
    if GetItemTypeId(carried)!=FSJ_Raw[index] then
        set carried=null
        return false
    endif
    loop
        exitwhen abilityIndex>=FQR_AbilityCount[index]
        if BlzGetItemAbility(carried,FQR_AbilityId[index*16+abilityIndex])!=FQR_Ability[index*16+abilityIndex] then
            set carried=null
            return false
        endif
        set abilityIndex=abilityIndex+1
    endloop
    loop
        set current=BlzGetItemAbilityByIndex(carried,count)
        exitwhen current==null
        if count>=16 then
            set current=null
            set carried=null
            return false
        endif
        set count=count+1
    endloop
    set current=null
    if count!=FQR_AbilityCount[index] then
        set carried=null
        return false
    endif
    set key=GetHandleId(carried)
    if LoadBoolean(FQR_Table[pid],key,-1)!=FQR_Suspended[index] or LoadInteger(FQR_Table[pid],key,0)!=FQR_PassiveCount[index] then
        set carried=null
        return false
    endif
    set abilityIndex=0
    loop
        exitwhen abilityIndex>=FQR_PassiveCount[index]
        if LoadInteger(FQR_Table[pid],key,abilityIndex+1)!=FQR_PassiveId[index*16+abilityIndex] then
            set carried=null
            return false
        endif
        set abilityIndex=abilityIndex+1
    endloop
    set carried=null
    return true
endfunction

function FQR_CheckAll takes integer pid returns boolean
    local integer position=0
    if not FSJ_UnitsValid(pid,FSJ_Hero[pid],FSJ_Gaya[pid],FSJ_House[pid]) then
        return false
    endif
    if GetOwningPlayer(FSJ_Hero[pid])!=FSJ_HeroOwner[pid] or GetOwningPlayer(FSJ_Gaya[pid])!=FSJ_GayaOwner[pid] or GetOwningPlayer(FSJ_House[pid])!=FSJ_HouseOwner[pid] then
        return false
    endif
    loop
        exitwhen position>=57
        if not FQR_CheckInstances(pid,pid*57+position) then
            return false
        endif
        set position=position+1
    endloop
    return true
endfunction

function FQR_CheckMetadata takes integer pid,integer index returns boolean
    local item carried=FSJ_Item[index]
    if GetItemTypeId(carried)!=FSJ_Raw[index] or GetItemCharges(carried)!=FSJ_Charges[index] or GetItemUserData(carried)!=FSJ_Binding[index] then
        set carried=null
        return false
    endif
    if GetItemPlayer(carried)!=FSJ_Owner[index] or FSJ_ReadFlags(carried)!=FSJ_Flags[index] or not FSL_Pack(pid,GetWidgetLife(carried)) then
        set carried=null
        return false
    endif
    set carried=null
    return FSL_High[pid]==FSJ_High[index] and FSL_Low[pid]==FSJ_Low[index]
endfunction

function FQR_Clear takes integer pid returns nothing
    local integer position=0
    local integer index
    local integer abilityIndex
    loop
        exitwhen position>=57
        set index=pid*57+position
        set abilityIndex=0
        loop
            exitwhen abilityIndex>=16
            set FQR_Ability[index*16+abilityIndex]=null
            set FQR_AbilityId[index*16+abilityIndex]=0
            set FQR_PassiveId[index*16+abilityIndex]=0
            set abilityIndex=abilityIndex+1
        endloop
        set FQR_AbilityCount[index]=0
        set FQR_PassiveCount[index]=0
        set FQR_Suspended[index]=false
        set position=position+1
    endloop
    set FQR_Table[pid]=null
    set FQR_State[pid]=0
    set FSN_RecoveryBlocked[pid]=false
    set FSJ_RecoveryPending[pid]=false
endfunction

function FQR_Begin takes integer pid,hashtable bagAbilities returns boolean
    local integer position=0
    local integer index
    local integer abilityIndex
    local integer previous
    local integer raw
    local integer key
    local item carried
    local ability current
    local boolean valid=true
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FQR_Busy[pid] or FSN_Busy[pid] or FSJ_Busy[pid] or FQR_State[pid]!=0 or FQR_AuxCount[pid]!=0 or bagAbilities==null then
        return false
    endif
    if not FSJ_Verify(pid) then
        return false
    endif
    set FQR_Busy[pid]=true
    set FSN_Busy[pid]=true
    set FSJ_Busy[pid]=true
    set FQR_Table[pid]=bagAbilities
    loop
        exitwhen position>=57 or not valid
        set index=pid*57+position
        set carried=FSJ_Item[index]
        if carried!=null then
            set abilityIndex=0
            loop
                set current=BlzGetItemAbilityByIndex(carried,abilityIndex)
                exitwhen current==null or not valid
                if abilityIndex>=16 then
                    set valid=false
                else
                    set raw=BlzGetAbilityId(current)
                    set previous=0
                    loop
                        exitwhen previous>=abilityIndex
                        if FQR_AbilityId[index*16+previous]==raw then
                            set valid=false
                        endif
                        set previous=previous+1
                    endloop
                    if raw==0 then
                        set valid=false
                    endif
                    set FQR_AbilityId[index*16+abilityIndex]=raw
                    set FQR_Ability[index*16+abilityIndex]=current
                    set abilityIndex=abilityIndex+1
                    set FQR_AbilityCount[index]=abilityIndex
                endif
            endloop
            set key=GetHandleId(carried)
            set FQR_Suspended[index]=LoadBoolean(bagAbilities,key,-1)
            set FQR_PassiveCount[index]=LoadInteger(bagAbilities,key,0)
            if FQR_PassiveCount[index]<0 or FQR_PassiveCount[index]>16 or FQR_Suspended[index]!=(FQR_PassiveCount[index]>0) then
                set valid=false
            else
                set abilityIndex=0
                loop
                    exitwhen abilityIndex>=FQR_PassiveCount[index]
                    set raw=LoadInteger(bagAbilities,key,abilityIndex+1)
                    if raw==0 or BlzGetItemAbility(carried,raw)!=null then
                        set valid=false
                    endif
                    set previous=0
                    loop
                        exitwhen previous>=abilityIndex
                        if FQR_PassiveId[index*16+previous]==raw then
                            set valid=false
                        endif
                        set previous=previous+1
                    endloop
                    set FQR_PassiveId[index*16+abilityIndex]=raw
                    set abilityIndex=abilityIndex+1
                endloop
            endif
        endif
        set position=position+1
    endloop
    set current=null
    set carried=null
    set FSJ_Busy[pid]=false
    if valid then
        set valid=FSJ_Verify(pid) and FQR_CheckAll(pid)
    endif
    if valid then
        set FQR_State[pid]=1
        set FSJ_RecoveryPending[pid]=true
    else
        call FQR_Clear(pid)
    endif
    set FSN_Busy[pid]=false
    set FQR_Busy[pid]=false
    return valid
endfunction

function FQR_Detach takes integer pid,boolean strictMetadata returns boolean
    local integer position=0
    local integer index
    local integer actual
    local item carried
    local unit holder
    loop
        exitwhen position>=57
        set index=pid*57+position
        set carried=FSJ_Item[index]
        if carried!=null then
            set holder=FQR_Unit(pid,position)
            if IsItemOwned(carried) then
                set actual=0
                loop
                    exitwhen actual>=57 or FSJ_At(FSJ_Hero[pid],FSJ_Gaya[pid],FSJ_House[pid],actual)==carried
                    set actual=actual+1
                endloop
                if actual>=57 then
                    set carried=null
                    set holder=null
                    return false
                endif
                set holder=FQR_Unit(pid,actual)
            endif
            if UnitHasItemEquipped(holder,carried) then
                call UnitUnequipItem(holder,carried)
            endif
            call UnitRemoveItem(holder,carried)
            call SetItemVisible(carried,false)
            if IsItemOwned(carried) or IsItemVisible(carried) or not FQR_CheckInstances(pid,index) or (strictMetadata and not FQR_CheckMetadata(pid,index)) then
                set carried=null
                set holder=null
                return false
            endif
        endif
        set position=position+1
    endloop
    set carried=null
    set holder=null
    return true
endfunction

function FQR_Quarantine takes integer pid returns boolean
    local integer position=0
    local integer index
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FQR_Busy[pid] or FSN_Busy[pid] or FSJ_Busy[pid] or FQR_State[pid]!=1 then
        return false
    endif
    if not FSJ_Verify(pid) or not FQR_CheckAll(pid) then
        return false
    endif
    set FQR_Busy[pid]=true
    set FSN_Busy[pid]=true
    set FSJ_Busy[pid]=true
    set FQR_State[pid]=2
    if not FQR_Detach(pid,true) then
        return FQR_Unlock(pid,false)
    endif
    loop
        exitwhen position>=57
        set index=pid*57+position
        if FSJ_At(FSJ_Hero[pid],FSJ_Gaya[pid],FSJ_House[pid],position)!=null then
            return FQR_Unlock(pid,false)
        endif
        if FSJ_Item[index]!=null then
            if IsItemOwned(FSJ_Item[index]) or IsItemVisible(FSJ_Item[index]) or not FQR_CheckMetadata(pid,index) then
                return FQR_Unlock(pid,false)
            endif
        endif
        set position=position+1
    endloop
    if not FQR_CheckAll(pid) then
        return FQR_Unlock(pid,false)
    endif
    set FQR_State[pid]=3
    return FQR_Unlock(pid,true)
endfunction

// Only these separately tracked fillers may be deleted by original-item recovery.
function FQR_CleanupAux takes integer pid returns boolean
    local integer slot=0
    local integer index
    local boolean clean=true
    loop
        exitwhen slot>=FQR_AuxCount[pid]
        set index=pid*36+slot
        if FQR_AuxItem[index]!=null then
            call RemoveItem(FQR_AuxItem[index])
            if GetItemTypeId(FQR_AuxItem[index])==0 then
                set FQR_AuxItem[index]=null
            else
                call SetItemVisible(FQR_AuxItem[index],false)
                set clean=false
            endif
        endif
        set slot=slot+1
    endloop
    if clean then
        set FQR_AuxCount[pid]=0
    endif
    return clean
endfunction

function FQR_Filler takes integer pid,unit holder,integer raw returns item
    local item spacer
    local integer index
    if raw==0 or FQR_AuxCount[pid]>=36 then
        return null
    endif
    set spacer=CreateItem(raw,GetUnitX(holder),GetUnitY(holder))
    if spacer==null then
        return null
    endif
    set index=pid*36+FQR_AuxCount[pid]
    set FQR_AuxItem[index]=spacer
    set FQR_AuxCount[pid]=FQR_AuxCount[pid]+1
    call SetItemVisible(spacer,false)
    if GetItemTypeId(spacer)!=raw or IsItemVisible(spacer) then
        set spacer=null
        return null
    endif
    return spacer
endfunction

function FQR_Place takes integer pid,integer position,integer spacerRaw,integer ringRaw,integer markerRaw returns boolean
    local integer index=pid*57+position
    local item carried=FSJ_Item[index]
    local unit holder=FQR_Unit(pid,position)
    local integer slot=position
    local integer earlier=0
    local item spacer
    local ability marker
    if carried==null then
        set holder=null
        return true
    endif
    if position>=36 and position<45 then
        set slot=position-36
        if slot==5 and UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(4))==null then
            set spacer=FQR_Filler(pid,holder,ringRaw)
            if spacer==null then
                set carried=null
                set holder=null
                return false
            endif
            set marker=BlzGetItemAbilityByIndex(spacer,0)
            if marker==null then
                set spacer=null
                set carried=null
                set holder=null
                return false
            endif
            if BlzGetAbilityId(marker)!=markerRaw or BlzGetItemAbilityByIndex(spacer,1)!=null or GetItemEquipmentType(spacer)!=GetItemEquipmentType(carried) then
                set marker=null
                set spacer=null
                set carried=null
                set holder=null
                return false
            endif
            set marker=null
            call UnitAddItem(holder,spacer)
            call UnitEquipItem(holder,spacer)
            if UnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(4))!=spacer then
                set spacer=null
                set carried=null
                set holder=null
                return false
            endif
            set spacer=null
        endif
    elseif position>=6 and position<36 then
        loop
            exitwhen earlier>=position
            if (earlier<6 and UnitItemInSlot(holder,earlier)==null) or (earlier>=6 and UnitItemInBagSlot(holder,earlier-6)==null) then
                set spacer=FQR_Filler(pid,holder,spacerRaw)
                if spacer==null then
                    set carried=null
                    set holder=null
                    return false
                endif
                call UnitAddItem(holder,spacer)
                if (earlier<6 and UnitItemInSlot(holder,earlier)!=spacer) or (earlier>=6 and UnitItemInBagSlot(holder,earlier-6)!=spacer) then
                    set spacer=null
                    set carried=null
                    set holder=null
                    return false
                endif
                set spacer=null
            endif
            set earlier=earlier+1
        endloop
    elseif position>=51 then
        set slot=position-51
    elseif position>=45 then
        set slot=position-45
    endif
    call UnitAddItem(holder,carried)
    if position>=36 and position<45 then
        call UnitEquipItem(holder,carried)
    elseif position<6 or position>=45 then
        if UnitItemInSlot(holder,slot)!=carried then
            call UnitDropItemSlot(holder,carried,slot)
        endif
    endif
    call SetItemCharges(carried,FSJ_Charges[index])
    call SetItemUserData(carried,FSJ_Binding[index])
    call SetItemPlayer(carried,FSJ_Owner[index],false)
    call SetWidgetLife(carried,FSL_Real(FSJ_High[index],FSJ_Low[index]))
    call SetItemInvulnerable(carried,ModuloInteger(FSJ_Flags[index],2)==1)
    call SetItemDroppable(carried,ModuloInteger(FSJ_Flags[index]/2,2)==1)
    call SetItemPawnable(carried,FSJ_Flags[index]/4==1)
    call SetItemVisible(carried,FSJ_Visible[index])
    set carried=null
    set holder=null
    if not FQR_CleanupAux(pid) then
        return false
    endif
    return FSJ_Matches(pid,index,FSJ_At(FSJ_Hero[pid],FSJ_Gaya[pid],FSJ_House[pid],position)) and FQR_CheckInstances(pid,index)
endfunction

function FQR_Recover takes integer pid,integer spacerRaw,integer ringRaw,integer markerRaw returns boolean
    local integer position=0
    local integer previous
    local item current
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FQR_Busy[pid] or FSN_Busy[pid] or FSJ_Busy[pid] or FQR_State[pid]==0 or spacerRaw==0 then
        return false
    endif
    set FQR_Busy[pid]=true
    set FSJ_Busy[pid]=true
    // Delete only tracked replacements first; never mix originals into FSN ownership.
    if not FSN_Abort(pid) then
        return FQR_Unlock(pid,false)
    endif
    set FSN_Busy[pid]=true
    if not FQR_CleanupAux(pid) or not FQR_CheckAll(pid) then
        return FQR_Unlock(pid,false)
    endif
    set FSJ_Busy[pid]=false
    if FSJ_Verify(pid) then
        set FQR_State[pid]=5
        set FSN_RecoveryBlocked[pid]=true
        return FQR_Unlock(pid,true)
    endif
    set FSJ_Busy[pid]=true
    // Foreign/untracked occupants are not destroyed or overwritten.
    loop
        exitwhen position>=57
        set current=FSJ_At(FSJ_Hero[pid],FSJ_Gaya[pid],FSJ_House[pid],position)
        if current!=null then
            set previous=0
            loop
                exitwhen previous>=57 or FSJ_Item[pid*57+previous]==current
                set previous=previous+1
            endloop
            if previous>=57 then
                set current=null
                return FQR_Unlock(pid,false)
            endif
        endif
        set position=position+1
    endloop
    set current=null
    set FQR_State[pid]=2
    if not FQR_Detach(pid,false) then
        return FQR_Unlock(pid,false)
    endif
    // Equipment first, then quick/bag/Gaya/house; preserve sparse positions.
    set position=36
    loop
        exitwhen position>=45
        if not FQR_Place(pid,position,spacerRaw,ringRaw,markerRaw) then
            call FQR_CleanupAux(pid)
            return FQR_Unlock(pid,false)
        endif
        set position=position+1
    endloop
    set position=0
    loop
        exitwhen position>=57
        if position<36 or position>=45 then
            if not FQR_Place(pid,position,spacerRaw,ringRaw,markerRaw) then
                call FQR_CleanupAux(pid)
                return FQR_Unlock(pid,false)
            endif
        endif
        set position=position+1
    endloop
    set FSJ_Busy[pid]=false
    if not FSJ_Verify(pid) or not FQR_CheckAll(pid) then
        return FQR_Unlock(pid,false)
    endif
    set FQR_State[pid]=5
    set FSN_RecoveryBlocked[pid]=true
    return FQR_Unlock(pid,true)
endfunction

function FQR_Release takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FQR_Busy[pid] or FSN_Busy[pid] or FSJ_Busy[pid] or FQR_State[pid]!=5 then
        return false
    endif
    if not FSJ_Verify(pid) or not FQR_CheckAll(pid) or FQR_AuxCount[pid]!=0 then
        return false
    endif
    call FQR_Clear(pid)
    return true
endfunction
endlibrary
