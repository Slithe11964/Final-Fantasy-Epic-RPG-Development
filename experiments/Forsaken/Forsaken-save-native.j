library TForsakenSaveNative requires TForsakenSaveLife
// Isolated modern-client staging only. Caller must hold a synchronized gameplay guard.
// No placement, promotion, initializer, save route or original-item mutation.
globals
    // 0 idle, 1 open, 2 failed, 3 cleanup unverified, 4 placement started.
    integer array FSN_State
    boolean array FSN_Busy
    boolean array FSN_OwnershipBlocked
    boolean array FSN_BodyBlocked
    boolean array FSN_ReferenceBlocked
    boolean array FSN_UnitBlocked
    boolean array FSN_SessionBlocked
    boolean array FSN_HeroBlocked
    boolean array FSN_ProgressionBlocked
    boolean array FSN_RecoveryBlocked
    integer array FSN_Count
    item array FSN_Item
    integer array FSN_Raw
    integer array FSN_Charges
    integer array FSN_Binding
    integer array FSN_Flags
    integer array FSN_High
    integer array FSN_Low
    integer array FSN_AuxCount
    item array FSN_PlacedItem
    unit array FSN_PlacedUnit
    player array FSN_PlacedOwner
    integer array FSN_PlacedHolder
    integer array FSN_PlacedSlot
    item array FSN_AuxItem
    boolean array FSN_EffectsReady
    boolean array FSN_EffectsStored
    integer array FSN_EffectCount
    integer array FSN_EffectId
    integer array FSN_EffectRole
endglobals

function FSN_Begin takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_RecoveryBlocked[pid] or FSN_ProgressionBlocked[pid] or FSN_HeroBlocked[pid] or FSN_SessionBlocked[pid] or FSN_UnitBlocked[pid] or FSN_ReferenceBlocked[pid] or FSN_BodyBlocked[pid] or FSN_OwnershipBlocked[pid] or FSN_State[pid]!=0 or FSN_Busy[pid] or FSN_Count[pid]!=0 or FSN_AuxCount[pid]!=0 then
        return false
    endif
    set FSN_State[pid]=1
    return true
endfunction

function FSN_CheckMetadata takes integer pid,integer index returns boolean
    local item carried=FSN_Item[index]
    if carried==null or GetItemTypeId(carried)!=FSN_Raw[index] then
        set carried=null
        return false
    endif
    if GetItemPlayer(carried)!=Player(pid) then
        set carried=null
        return false
    endif
    if GetItemCharges(carried)!=FSN_Charges[index] or GetItemUserData(carried)!=FSN_Binding[index] then
        set carried=null
        return false
    endif
    if IsItemInvulnerable(carried)!=(ModuloInteger(FSN_Flags[index],2)==1) then
        set carried=null
        return false
    endif
    if IsItemPawnable(carried)!=(FSN_Flags[index]/4==1) then
        set carried=null
        return false
    endif
    if BlzGetItemBooleanField(carried,ITEM_BF_CAN_BE_DROPPED)!=(ModuloInteger(FSN_Flags[index]/2,2)==1) then
        set carried=null
        return false
    endif
    if not FSL_Pack(pid,GetWidgetLife(carried)) then
        set carried=null
        return false
    endif
    set carried=null
    return FSL_High[pid]==FSN_High[index] and FSL_Low[pid]==FSN_Low[index]
endfunction

function FSN_Check takes integer pid,integer index returns boolean
    if not FSN_CheckMetadata(pid,index) then
        return false
    endif
    return not IsItemVisible(FSN_Item[index]) and not IsItemOwned(FSN_Item[index])
endfunction

// Placement fillers are allocations too: Abort must never lose their handles.
function FSN_CleanupAux takes integer pid returns boolean
    local integer slot=0
    local integer index
    local boolean clean=true
    loop
        exitwhen slot>=FSN_AuxCount[pid]
        set index=pid*36+slot
        if FSN_AuxItem[index]!=null then
            call RemoveItem(FSN_AuxItem[index])
            if GetItemTypeId(FSN_AuxItem[index])==0 then
                set FSN_AuxItem[index]=null
            else
                call SetItemVisible(FSN_AuxItem[index],false)
                set clean=false
            endif
        endif
        set slot=slot+1
    endloop
    if clean then
        set FSN_AuxCount[pid]=0
    else
        set FSN_State[pid]=3
    endif
    return clean
endfunction

// Internal helper: only transaction-owned allocations, never caller-owned items.
function FSN_Cleanup takes integer pid returns boolean
    local integer slot=0
    local integer index
    local integer abilityIndex
    local boolean clean=true
    if not FSN_CleanupAux(pid) then
        set clean=false
    endif
    loop
        exitwhen slot>=FSN_Count[pid]
        set index=pid*57+slot
        if FSN_Item[index]!=null then
            call RemoveItem(FSN_Item[index])
            if GetItemTypeId(FSN_Item[index])==0 then
                set FSN_Item[index]=null
                set FSN_Raw[index]=0
                set FSN_Charges[index]=0
                set FSN_Binding[index]=0
                set FSN_Flags[index]=0
                set FSN_High[index]=0
                set FSN_Low[index]=0
            else
                // Retain the handle and block reuse. Visibility is containment,
                // not proof that a native deletion or gameplay freeze succeeded.
                call SetItemVisible(FSN_Item[index],false)
                set clean=false
            endif
        endif
        if FSN_Item[index]==null then
            set abilityIndex=0
            loop
                exitwhen abilityIndex>=FSN_EffectCount[index]
                set FSN_EffectId[index*16+abilityIndex]=0
                set FSN_EffectRole[index*16+abilityIndex]=0
                set abilityIndex=abilityIndex+1
            endloop
            set FSN_EffectCount[index]=0
            set FSN_EffectsReady[index]=false
            set FSN_EffectsStored[index]=false
            set FSN_PlacedItem[index]=null
            set FSN_PlacedUnit[index]=null
            set FSN_PlacedOwner[index]=null
            set FSN_PlacedHolder[index]=0
            set FSN_PlacedSlot[index]=0
        endif
        set slot=slot+1
    endloop
    if clean then
        set FSN_Count[pid]=0
    else
        set FSN_State[pid]=3
    endif
    return clean
endfunction

function FSN_Abort takes integer pid returns boolean
    local boolean clean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_Busy[pid] then
        return false
    endif
    set FSN_Busy[pid]=true
    set clean=FSN_Cleanup(pid)
    if clean then
        set FSN_State[pid]=0
    endif
    set FSN_Busy[pid]=false
    return clean
endfunction

function FSN_Fail takes integer pid returns boolean
    set FSN_State[pid]=2
    call FSN_Cleanup(pid)
    set FSN_Busy[pid]=false
    return false
endfunction

function FSN_Stage takes integer pid,integer raw,integer charges,boolean bound,integer flags,integer high,integer low,real x,real y returns boolean
    local integer index
    local item carried
    local real life
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_RecoveryBlocked[pid] or FSN_ProgressionBlocked[pid] or FSN_HeroBlocked[pid] or FSN_SessionBlocked[pid] or FSN_UnitBlocked[pid] or FSN_ReferenceBlocked[pid] or FSN_BodyBlocked[pid] or FSN_OwnershipBlocked[pid] or FSN_State[pid]!=1 or FSN_Busy[pid] then
        return false
    endif
    set FSN_Busy[pid]=true
    set life=FSL_Real(high,low)
    if raw==0 or charges<0 or charges>127 or flags<0 or flags>7 or life<=0.0 or FSN_Count[pid]>=57 then
        return FSN_Fail(pid)
    endif
    // Verify client arithmetic before allocating. Resolution/eligibility of raw
    // and staging coordinates belongs to the future reviewed policy adapter.
    if not FSL_Pack(pid,life) then
        return FSN_Fail(pid)
    endif
    if FSL_High[pid]!=high or FSL_Low[pid]!=low then
        return FSN_Fail(pid)
    endif
    set index=pid*57+FSN_Count[pid]
    set carried=CreateItem(raw,x,y)
    if carried==null then
        return FSN_Fail(pid)
    endif
    // Own the handle before the first fallible setter or callback.
    set FSN_Item[index]=carried
    set FSN_Count[pid]=FSN_Count[pid]+1
    set FSN_Raw[index]=raw
    set FSN_Charges[index]=charges
    set FSN_Binding[index]=0
    if bound then
        set FSN_Binding[index]=pid+1
    endif
    set FSN_Flags[index]=flags
    set FSN_High[index]=high
    set FSN_Low[index]=low
    call SetItemVisible(carried,false)
    // Refuse a getter that merely returns unchanged object-data defaults.
    // This checks this newly allocated handle; it does not authorize capture
    // of original items or replace real-client acceptance tests.
    call SetItemDroppable(carried,false)
    if BlzGetItemBooleanField(carried,ITEM_BF_CAN_BE_DROPPED) then
        set carried=null
        return FSN_Fail(pid)
    endif
    call SetItemDroppable(carried,true)
    if not BlzGetItemBooleanField(carried,ITEM_BF_CAN_BE_DROPPED) then
        set carried=null
        return FSN_Fail(pid)
    endif
    call SetItemDroppable(carried,ModuloInteger(flags/2,2)==1)
    call SetItemPlayer(carried,Player(pid),false)
    call SetItemCharges(carried,charges)
    call SetItemUserData(carried,FSN_Binding[index])
    call SetWidgetLife(carried,life)
    call SetItemInvulnerable(carried,ModuloInteger(flags,2)==1)
    call SetItemPawnable(carried,flags/4==1)
    set carried=null
    if not FSN_Check(pid,index) then
        return FSN_Fail(pid)
    endif
    set FSN_Busy[pid]=false
    return true
endfunction

function FSN_Verify takes integer pid returns boolean
    local integer slot=0
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_State[pid]!=1 or FSN_Busy[pid] then
        return false
    endif
    set FSN_Busy[pid]=true
    loop
        exitwhen slot>=FSN_Count[pid]
        if not FSN_Check(pid,pid*57+slot) then
            return FSN_Fail(pid)
        endif
        set slot=slot+1
    endloop
    set FSN_Busy[pid]=false
    return true
endfunction
endlibrary
