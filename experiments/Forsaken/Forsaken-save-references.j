library TForsakenSaveReferences requires TForsakenSaveUnits
// Reversible reference switch only; replacement heroes remain hidden and empty.
// No successful-load commit, original deletion or gameplay activation.
globals
    // 0 idle, 1 planning, 2 switched, 3 blocked, 4 reversed.
    integer array FSR_State
    boolean array FSR_Busy
    hashtable array FSR_Table
    unit array FSR_Old
    unit array FSR_Target
    integer array FSR_Raw
    player array FSR_Owner
    boolean array FSR_Present
endglobals

function FSR_Live takes integer pid,integer slot returns unit
    if slot<22 then
        return LoadUnitHandle(udg_JobHeroHash,FPG_JobRaw(slot),pid)
    elseif slot==22 then
        return LoadUnitHandle(udg_JobHeroHash,'H02L',pid)
    elseif slot==23 then
        return udg_FreelancerHero[pid+1]
    elseif slot==24 then
        return udg_SpiritOfGaya[pid+1]
    endif
    return udg_PlayerHero[pid+1]
endfunction

function FSR_Key takes integer slot returns integer
    if slot<22 then
        return FPG_JobRaw(slot)
    endif
    return 'H02L'
endfunction

function FSR_Context takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit original
    if udg_JobHeroHash!=FSR_Table[pid] or udg_JobCount!=22 then
        return false
    endif
    loop
        exitwhen slot>=26
        set index=pid*26+slot
        if slot<22 and udg_JobUnitType[slot]!=FPG_JobRaw(slot) then
            return false
        endif
        set original=FSR_Old[index]
        if original!=null and (GetUnitTypeId(original)!=FSR_Raw[index] or GetOwningPlayer(original)!=FSR_Owner[index]) then
            set original=null
            return false
        endif
        set slot=slot+1
    endloop
    set original=null
    return true
endfunction

function FSR_Matches takes integer pid,boolean targets returns boolean
    local integer slot=0
    local integer index
    local unit expected
    local boolean present
    if not FSR_Context(pid) then
        return false
    endif
    loop
        exitwhen slot>=26
        set index=pid*26+slot
        if targets then
            set expected=FSR_Target[index]
            set present=expected!=null
        else
            set expected=FSR_Old[index]
            set present=FSR_Present[index]
        endif
        if FSR_Live(pid,slot)!=expected then
            set expected=null
            return false
        endif
        if slot<23 and HaveSavedHandle(udg_JobHeroHash,FSR_Key(slot),pid)!=present then
            set expected=null
            return false
        endif
        set slot=slot+1
    endloop
    set expected=null
    return true
endfunction

function FSR_Begin takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit original
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSR_Busy[pid] or not FSU_Idle(pid) or FSN_BodyBlocked[pid] or FSN_OwnershipBlocked[pid] or FSN_PreparedBlocked[pid] or FSR_State[pid]!=0 or FSU_State[pid]!=1 or FSS_State[pid]!=1 or FSC_Writing[pid] or not FSU_Verify(pid) or not FSS_Verify(pid) or not FHU_Verify(pid,true) or not FPG_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    // Present non-unit handles at known unit keys cannot be removed safely.
    loop
        exitwhen slot>=23
        if HaveSavedHandle(udg_JobHeroHash,FSR_Key(slot),pid) and FSR_Live(pid,slot)==null then
            return false
        endif
        set slot=slot+1
    endloop
    set FSR_Table[pid]=udg_JobHeroHash
    set slot=0
    loop
        exitwhen slot>=26
        set index=pid*26+slot
        set original=FSR_Live(pid,slot)
        set FSR_Old[index]=original
        set FSR_Target[index]=original
        if original!=null then
            set FSR_Raw[index]=GetUnitTypeId(original)
            set FSR_Owner[index]=GetOwningPlayer(original)
        endif
        if slot<23 then
            set FSR_Present[index]=HaveSavedHandle(udg_JobHeroHash,FSR_Key(slot),pid)
        endif
        set slot=slot+1
    endloop
    set original=null
    set FSR_State[pid]=1
    set FSJ_ReferencePending[pid]=true
    return true
endfunction

function FSR_Plan takes integer pid,integer staged,boolean activate returns boolean
    local integer role
    local integer slot
    local unit replacement
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSR_Busy[pid] or not FSU_Idle(pid) or FSN_BodyBlocked[pid] or FSN_OwnershipBlocked[pid] or FSN_PreparedBlocked[pid] or FSR_State[pid]!=1 or staged<0 or staged>=FSU_Count[pid] or not FSR_Matches(pid,false) or not FSU_Verify(pid) then
        return false
    endif
    set role=FSU_Role[pid*24+staged]
    if role==23 and activate then
        return false
    endif
    set replacement=FSU_Unit[pid*24+staged]
    set slot=role
    if role==23 then
        set slot=24
    endif
    if activate or FSR_Target[pid*26+25]==FSR_Target[pid*26+slot] then
        set FSR_Target[pid*26+25]=replacement
    endif
    set FSR_Target[pid*26+slot]=replacement
    if role==22 then
        set FSR_Target[pid*26+23]=replacement
    endif
    set replacement=null
    return true
endfunction

function FSR_Write takes integer pid,boolean targets returns nothing
    local integer slot=0
    local integer index
    local unit replacement
    local boolean present
    loop
        exitwhen slot>=26
        set index=pid*26+slot
        if targets then
            set replacement=FSR_Target[index]
            set present=replacement!=null
        else
            set replacement=FSR_Old[index]
            set present=FSR_Present[index]
        endif
        if slot<23 then
            if present then
                call SaveUnitHandle(udg_JobHeroHash,FSR_Key(slot),pid,replacement)
            else
                call RemoveSavedHandle(udg_JobHeroHash,FSR_Key(slot),pid)
            endif
        elseif slot==23 then
            set udg_FreelancerHero[pid+1]=replacement
        elseif slot==24 then
            set udg_SpiritOfGaya[pid+1]=replacement
        else
            set udg_PlayerHero[pid+1]=replacement
        endif
        set slot=slot+1
    endloop
    set replacement=null
endfunction

function FSR_Lock takes integer pid,boolean flag returns nothing
    set FSR_Busy[pid]=flag
    call FSU_Lock(pid,flag)
endfunction

function FSR_Block takes integer pid returns nothing
    set FSR_State[pid]=3
    set FSN_ReferenceBlocked[pid]=true
    set FSC_ReferenceBlocked[pid]=true
endfunction

function FSR_Apply takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSR_Busy[pid] or not FSU_Idle(pid) or FSN_BodyBlocked[pid] or FSN_OwnershipBlocked[pid] or FSN_PreparedBlocked[pid] or FSR_State[pid]!=1 or FSC_Writing[pid] or not FSR_Matches(pid,false) or not FSU_Verify(pid) or not FSS_Verify(pid) or not FHU_Verify(pid,true) or not FPG_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    call FSR_Block(pid)
    call FSR_Lock(pid,true)
    call FSR_Write(pid,true)
    call FSR_Lock(pid,false)
    if not FSR_Matches(pid,true) then
        return false
    endif
    set FSR_State[pid]=2
    return true
endfunction

function FSR_Reverse takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit current
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSR_Busy[pid] or not FSU_Idle(pid) or FSJ_OwnershipPending[pid] or FSJ_PreparedPending[pid] or FSR_State[pid]==0 or FSC_Writing[pid] then
        return false
    endif
    call FSR_Block(pid)
    if not FSR_Context(pid) then
        return false
    endif
    // Do not overwrite third-party units or non-unit handles at these keys.
    loop
        exitwhen slot>=26
        set index=pid*26+slot
        set current=FSR_Live(pid,slot)
        if current!=null and current!=FSR_Old[index] and current!=FSR_Target[index] then
            set current=null
            return false
        endif
        if slot<23 and current==null and HaveSavedHandle(udg_JobHeroHash,FSR_Key(slot),pid) then
            return false
        endif
        set slot=slot+1
    endloop
    set current=null
    call FSR_Lock(pid,true)
    call FSR_Write(pid,false)
    call FSR_Lock(pid,false)
    if not FSR_Matches(pid,false) then
        return false
    endif
    set FSR_State[pid]=4
    return true
endfunction

function FSR_Release takes integer pid returns boolean
    local integer slot=0
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSR_Busy[pid] or not FSU_Idle(pid) or FSR_State[pid]!=4 or FSU_State[pid]!=0 or FSU_Count[pid]!=0 or not FSR_Matches(pid,false) or not FSJ_Verify(pid) then
        return false
    endif
    loop
        exitwhen slot>=26
        set FSR_Old[pid*26+slot]=null
        set FSR_Target[pid*26+slot]=null
        set FSR_Owner[pid*26+slot]=null
        set slot=slot+1
    endloop
    set FSR_Table[pid]=null
    set FSR_State[pid]=0
    set FSN_ReferenceBlocked[pid]=false
    set FSC_ReferenceBlocked[pid]=false
    set FSJ_ReferencePending[pid]=false
    return true
endfunction
endlibrary
