library TForsakenSaveInventoryProfile requires TForsakenSaveCargo
// Explicit target-code bridge. No publication, initializer or load command.
// Reviewed policy: parent0 canonicalID->raw; parent4 runtimeRaw->default charges.
globals
    integer array FIP_State
    integer array FIP_Count
    integer array FIP_Prepared
    integer array FIP_Placed
    integer array FIP_Dormant
    string array FIP_Code
    integer array FIP_Charges
    boolean array FIP_Bound
    integer array FIP_High
    integer array FIP_Low
    integer array FIP_Flags
    integer array FIP_Raw
    integer array FIP_Holder
    integer array FIP_Slot
    integer array FIP_Order
endglobals

function FIP_Clear takes integer pid returns nothing
    local integer i=0
    local integer key
    loop
        exitwhen i>=57
        set key=pid*57+i
        set FIP_Charges[key]=0
        set FIP_Bound[key]=false
        set FIP_High[key]=0
        set FIP_Low[key]=0
        set FIP_Flags[key]=0
        set FIP_Raw[key]=0
        set FIP_Holder[key]=0
        set FIP_Slot[key]=0
        set FIP_Order[key]=0
        set i=i+1
    endloop
    set FIP_State[pid]=0
    set FIP_Count[pid]=0
    set FIP_Prepared[pid]=0
    set FIP_Placed[pid]=0
    set FIP_Dormant[pid]=0
    set FIP_Code[pid]=null
endfunction

function FIP_Read takes integer pid,integer ctx,hashtable policy returns boolean
    local integer identity=1
    local integer ordinal=0
    local integer key
    local integer target
    local integer raw
    local integer variant
    local integer slot
    local integer wanted
    local integer charges
    local integer order=0
    if policy==null or ForsakenDefenseTypes==null or ForsakenGearTypes==null or FSC_HasEvidence[ctx] or FSC_Cheater[ctx] then
        return false
    endif
    // Freeze against the complete permanent registry, not experimental aliases.
    loop
        exitwhen identity>358
        if udg_ItemIdTable[identity]==0 or LoadInteger(policy,0,identity)!=udg_ItemIdTable[identity] then
            return false
        endif
        set identity=identity+1
    endloop
    loop
        exitwhen ordinal>=FSC_ItemCount[ctx]
        set key=ctx*57+ordinal
        set identity=FSC_ItemId[key]
        if FSC_ItemHolder[key]==5 and (FHS_State[pid]!=1 or not FSJ_HousePending[pid] or not FHS_Contained(pid) or not FSU_Empty(FHS_Unit[pid])) then
            return false
        endif
        if identity>358 or FSC_ItemDormant[key] then
            set FIP_Dormant[pid]=FIP_Dormant[pid]+1
        else
            // Known records require exact captured metadata.
            if not FSC_ItemComplete[key] then
                return false
            endif
            set raw=udg_ItemIdTable[identity]
            set variant=LoadInteger(ForsakenDefenseTypes,0,raw)
            if variant!=LoadInteger(ForsakenGearTypes,0,raw) then
                return false
            endif
            if FSC_ItemHolder[key]==2 and variant!=0 then
                set raw=variant
            elseif FSC_ItemHolder[key]==3 then
                set slot=FSC_ItemSlot[key]
                set wanted=slot
                if slot==5 then
                    set wanted=4
                endif
                if variant==0 then
                    return false
                endif
                if slot==7 and LoadInteger(ForsakenGearTypes,1,raw)==6 then
                    set raw=LoadInteger(ForsakenDefenseTypes,1,raw)
                    if raw==0 or LoadInteger(ForsakenGearTypes,6,raw)!=variant then
                        return false
                    endif
                else
                    if LoadInteger(ForsakenGearTypes,1,raw)!=wanted then
                        return false
                    endif
                    set raw=variant
                endif
            endif
            set charges=FSC_ItemQuantity[key]
            if charges<0 then
                if not HaveSavedInteger(policy,4,raw) then
                    return false
                endif
                set charges=LoadInteger(policy,4,raw)
            endif
            if charges<0 or charges>127 or FIP_Count[pid]>=57 then
                return false
            endif
            set target=pid*57+FIP_Count[pid]
            set FIP_Raw[target]=raw
            set FIP_Holder[target]=FSC_ItemHolder[key]
            set FIP_Slot[target]=FSC_ItemSlot[key]
            set FIP_Charges[target]=charges
            set FIP_Bound[target]=FSC_ItemBound[key]
            set FIP_High[target]=FSC_ItemHigh[key]
            set FIP_Low[target]=FSC_ItemLow[key]
            set FIP_Flags[target]=FSC_ItemFlags[key]
            set FIP_Count[pid]=FIP_Count[pid]+1
        endif
        set ordinal=ordinal+1
    endloop
    // Equipment first, in exact slot order, before a potentially full bag.
    set slot=0
    loop
        exitwhen slot>=9
        set ordinal=0
        loop
            exitwhen ordinal>=FIP_Count[pid]
            set target=pid*57+ordinal
            if FIP_Holder[target]==3 and FIP_Slot[target]==slot then
                set FIP_Order[pid*57+order]=ordinal
                set order=order+1
            endif
            set ordinal=ordinal+1
        endloop
        set slot=slot+1
    endloop
    set ordinal=0
    loop
        exitwhen ordinal>=FIP_Count[pid]
        if FIP_Holder[pid*57+ordinal]!=3 then
            set FIP_Order[pid*57+order]=ordinal
            set order=order+1
        endif
        set ordinal=ordinal+1
    endloop
    return order==FIP_Count[pid]
endfunction

function FIP_Begin takes integer pid,string encoded,integer account,hashtable policy returns boolean
    local integer ctx=pid+25
    local integer ordinal=0
    local integer key
    local boolean valid
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FIP_State[pid]!=0 or FCG_State[pid]!=0 or FSC_Writing[pid] or account<0 or account>=1048576 or not FHP_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    set ordinal=51
    loop
        exitwhen ordinal>=57
        if FSJ_Item[pid*57+ordinal]!=null and (FHS_State[pid]!=1 or not FSJ_HousePending[pid] or not FHS_Contained(pid) or not FSU_Empty(FHS_Unit[pid])) then
            return false
        endif
        set ordinal=ordinal+1
    endloop
    set ordinal=0
    call FSR_Lock(pid,true)
    call FIP_Clear(pid)
    if FSC_Seen==null then
        set FSC_Seen=InitHashtable()
    endif
    call FSC_Clear(ctx)
    call FSC_ClearSeen(ctx)
    set valid=FSC_Parse(ctx,encoded,account,true)
    if valid then
        set valid=FIP_Read(pid,ctx,policy)
    endif
    call FSC_ClearSeen(ctx)
    call FSC_Clear(ctx)
    call FSR_Lock(pid,false)
    if not valid then
        call FIP_Clear(pid)
        return false
    endif
    if not FCG_Begin(pid) then
        call FIP_Clear(pid)
        return false
    endif
    set FIP_Code[pid]=encoded
    set FIP_State[pid]=1
    loop
        exitwhen ordinal>=FIP_Count[pid]
        set key=pid*57+ordinal
        if not FCG_Plan(pid,FIP_Raw[key],FIP_Holder[key],FIP_Slot[key]) then
            set FIP_State[pid]=3
            return false
        endif
        set ordinal=ordinal+1
    endloop
    if FIP_Count[pid]>0 and not FCG_StartItems(pid) then
        set FIP_State[pid]=3
        return false
    endif
    return true
endfunction

function FIP_StageNext takes integer pid returns boolean
    local integer key
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FIP_State[pid]!=1 or FSN_Count[pid]>=FIP_Count[pid] then
        return false
    endif
    set key=pid*57+FSN_Count[pid]
    if not FCG_Stage(pid,FIP_Charges[key],FIP_Bound[key],FIP_Flags[key],FIP_High[key],FIP_Low[key],GetUnitX(FCG_Unit[pid*2]),GetUnitY(FCG_Unit[pid*2])) then
        set FIP_State[pid]=3
        return false
    endif
    return true
endfunction

function FIP_PrepareNext takes integer pid,hashtable abilities returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FIP_State[pid]!=1 or FSN_Count[pid]!=FIP_Count[pid] or FIP_Prepared[pid]>=FIP_Count[pid] then
        return false
    endif
    if not FCG_PrepareItem(pid,FIP_Prepared[pid],abilities) then
        set FIP_State[pid]=3
        return false
    endif
    set FIP_Prepared[pid]=FIP_Prepared[pid]+1
    return true
endfunction

function FIP_PlaceNext takes integer pid,integer spacer,integer ringSpacer,integer marker returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FIP_State[pid]!=1 or FIP_Prepared[pid]!=FIP_Count[pid] or FIP_Placed[pid]>=FIP_Count[pid] then
        return false
    endif
    if not FCG_PlaceItem(pid,FIP_Order[pid*57+FIP_Placed[pid]],spacer,ringSpacer,marker) then
        set FIP_State[pid]=3
        return false
    endif
    set FIP_Placed[pid]=FIP_Placed[pid]+1
    return true
endfunction

function FIP_Seal takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FIP_State[pid]!=1 or FIP_Prepared[pid]!=FIP_Count[pid] or FIP_Placed[pid]!=FIP_Count[pid] or not FCG_Seal(pid) then
        return false
    endif
    set FIP_State[pid]=2
    return true
endfunction

function FIP_Recover takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FIP_State[pid]==0 or not FCG_Recover(pid) then
        return false
    endif
    set FIP_State[pid]=3
    return true
endfunction

function FIP_Release takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FIP_State[pid]!=3 or not FCG_Release(pid) then
        return false
    endif
    call FIP_Clear(pid)
    return true
endfunction
endlibrary
