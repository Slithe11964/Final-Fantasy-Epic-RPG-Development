library TForsakenSaveUnits requires TForsakenSaveSession
// Owned replacement-unit allocation only. Caller must suppress synchronized gameplay hooks.
// No original mutation, reference promotion, initializer or successful-load commit.
globals
    // 0 idle, 1 open, 2 failed, 3 cleanup unverified.
    integer array FSU_State
    boolean array FSU_Busy
    integer array FSU_Count
    unit array FSU_Unit
    integer array FSU_Raw
    integer array FSU_Role
endglobals

function FSU_Referenced takes unit candidate returns boolean
    local integer pid=0
    local integer slot
    if candidate==null then
        return false
    endif
    loop
        exitwhen pid>=8
        if candidate==FSJ_Hero[pid] or candidate==FSJ_Gaya[pid] or candidate==FSJ_House[pid] or candidate==FHU_FreeCached[pid] or candidate==FSS_FreeCached[pid] or candidate==LoadUnitHandle(udg_JobHeroHash,'H02L',pid) then
            return true
        endif
        set slot=0
        loop
            exitwhen slot>=25
            if candidate==FHU_Live(pid,slot) or candidate==FHU_Unit[pid*25+slot] or candidate==FSS_Unit[pid*25+slot] then
                return true
            endif
            if slot<22 and candidate==FPG_JobHero[pid*22+slot] then
                return true
            endif
            set slot=slot+1
        endloop
        set pid=pid+1
    endloop
    return false
endfunction

function FSU_Tracked takes unit candidate returns boolean
    local integer pid=0
    local integer slot
    loop
        exitwhen pid>=8
        set slot=0
        loop
            exitwhen slot>=FSU_Count[pid]
            if candidate==FSU_Unit[pid*24+slot] then
                return true
            endif
            set slot=slot+1
        endloop
        set pid=pid+1
    endloop
    return false
endfunction

function FSU_Empty takes unit candidate returns boolean
    local integer slot=0
    local integer bag=UnitExtendedInventorySize(candidate)
    if UnitInventorySize(candidate)<0 or UnitInventorySize(candidate)>6 or bag<0 or bag>30 then
        return false
    endif
    loop
        exitwhen slot>=6
        if UnitItemInSlot(candidate,slot)!=null then
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=bag
        if UnitItemInBagSlot(candidate,slot)!=null then
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=9
        if UnitItemInEquipmentSlot(candidate,ConvertLoadoutSlot(slot))!=null then
            return false
        endif
        set slot=slot+1
    endloop
    return true
endfunction

function FSU_Check takes integer index returns boolean
    local unit candidate=FSU_Unit[index]
    if candidate==null or GetUnitTypeId(candidate)!=FSU_Raw[index] or not IsUnitType(candidate,UNIT_TYPE_HERO) then
        set candidate=null
        return false
    endif
    if GetOwningPlayer(candidate)!=Player(PLAYER_NEUTRAL_PASSIVE) or not IsUnitHidden(candidate) or not IsUnitPaused(candidate) or not BlzIsUnitInvulnerable(candidate) or FSU_Referenced(candidate) or not FSU_Empty(candidate) then
        set candidate=null
        return false
    endif
    set candidate=null
    return true
endfunction

function FSU_Lock takes integer pid,boolean flag returns nothing
    set FSU_Busy[pid]=flag
    set FSN_Busy[pid]=flag
    set FSJ_Busy[pid]=flag
    set FQR_Busy[pid]=flag
    set FPG_Busy[pid]=flag
    set FHU_Busy[pid]=flag
    set FSS_Busy[pid]=flag
    set FSC_Busy[pid]=flag
endfunction

function FSU_Idle takes integer pid returns boolean
    return not FSU_Busy[pid] and not FSN_Busy[pid] and not FSJ_Busy[pid] and not FQR_Busy[pid] and not FPG_Busy[pid] and not FHU_Busy[pid] and not FSS_Busy[pid] and not FSC_Busy[pid]
endfunction

function FSU_Block takes integer pid returns nothing
    set FSN_UnitBlocked[pid]=true
    set FSC_UnitBlocked[pid]=true
endfunction

function FSU_Begin takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSU_State[pid]!=0 or FSU_Count[pid]!=0 or FSS_State[pid]!=1 or FSC_Writing[pid] or FSN_UnitBlocked[pid] or FSC_UnitBlocked[pid] or FSN_RecoveryBlocked[pid] or FSN_ProgressionBlocked[pid] or FSN_HeroBlocked[pid] or FSN_SessionBlocked[pid] or not FSS_Verify(pid) or not FHU_Verify(pid,true) or not FPG_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    set FSU_State[pid]=1
    set FSJ_UnitPending[pid]=true
    return true
endfunction

function FSU_Stage takes integer pid,integer role,real x,real y returns boolean
    local integer slot=0
    local integer raw
    local integer index
    local unit candidate
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSU_State[pid]!=1 or FSN_UnitBlocked[pid] or FSN_RecoveryBlocked[pid] or FSN_ProgressionBlocked[pid] or FSN_HeroBlocked[pid] or FSN_SessionBlocked[pid] or FSC_Writing[pid] then
        return false
    endif
    if role<0 or role>=24 or FSU_Count[pid]>=24 or not (x>=-32768. and x<=32768. and y>=-32768. and y<=32768.) then
        return false
    endif
    if not FSS_Context(pid) then
        set FSU_State[pid]=2
        call FSU_Block(pid)
        return false
    endif
    loop
        exitwhen slot>=FSU_Count[pid]
        if FSU_Role[pid*24+slot]==role then
            return false
        endif
        if not FSU_Check(pid*24+slot) then
            set FSU_State[pid]=2
            call FSU_Block(pid)
            return false
        endif
        set slot=slot+1
    endloop
    if role<22 then
        set raw=FPG_JobRaw(role)
    elseif role==22 then
        set raw='H02L'
    else
        set raw='H01D'
    endif
    call FSU_Lock(pid,true)
    set candidate=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE),raw,x,y,0.)
    if candidate==null or FSU_Referenced(candidate) or FSU_Tracked(candidate) then
        set FSU_State[pid]=2
        call FSU_Block(pid)
        call FSU_Lock(pid,false)
        set candidate=null
        return false
    endif
    set index=pid*24+FSU_Count[pid]
    set FSU_Unit[index]=candidate
    set FSU_Raw[index]=raw
    set FSU_Role[index]=role
    set FSU_Count[pid]=FSU_Count[pid]+1
    call ShowUnit(candidate,false)
    call PauseUnit(candidate,true)
    call SetUnitInvulnerable(candidate,true)
    call FSU_Lock(pid,false)
    set candidate=null
    if not FSU_Check(index) or not FSS_Context(pid) then
        set FSU_State[pid]=2
        call FSU_Block(pid)
        return false
    endif
    return true
endfunction

function FSU_Verify takes integer pid returns boolean
    local integer slot=0
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSU_State[pid]!=1 or not FSS_Context(pid) then
        return false
    endif
    loop
        exitwhen slot>=FSU_Count[pid]
        if not FSU_Check(pid*24+slot) then
            return false
        endif
        set slot=slot+1
    endloop
    return true
endfunction

function FSU_Abort takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit candidate
    local boolean clean=true
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSN_State[pid]!=0 or FSN_Count[pid]!=0 or FSN_AuxCount[pid]!=0 or FSC_Writing[pid] then
        return false
    endif
    if FSU_State[pid]==0 then
        return FSU_Count[pid]==0
    endif
    set FSU_State[pid]=3
    call FSU_Block(pid)
    // Refuse the whole batch before deletion if any unit is published or carries items.
    loop
        exitwhen slot>=FSU_Count[pid]
        set candidate=FSU_Unit[pid*24+slot]
        if candidate!=null and (FSU_Referenced(candidate) or (GetUnitTypeId(candidate)!=0 and not FSU_Empty(candidate))) then
            set candidate=null
            return false
        endif
        set slot=slot+1
    endloop
    call FSU_Lock(pid,true)
    set slot=0
    loop
        exitwhen slot>=FSU_Count[pid]
        set index=pid*24+slot
        set candidate=FSU_Unit[index]
        if candidate!=null then
            // Recheck after every native callback; earlier cleanup must not authorize this handle.
            if FSU_Referenced(candidate) or (GetUnitTypeId(candidate)!=0 and not FSU_Empty(candidate)) then
                set clean=false
            else
                if GetUnitTypeId(candidate)!=0 then
                    call ShowUnit(candidate,false)
                    call PauseUnit(candidate,true)
                    call SetUnitInvulnerable(candidate,true)
                    if not FSU_Referenced(candidate) and FSU_Empty(candidate) then
                        call RemoveUnit(candidate)
                    endif
                endif
                if GetUnitTypeId(candidate)==0 and not FSU_Referenced(candidate) then
                    set FSU_Unit[index]=null
                else
                    set clean=false
                endif
            endif
        endif
        set slot=slot+1
    endloop
    set candidate=null
    call FSU_Lock(pid,false)
    if not clean then
        return false
    endif
    set FSU_Count[pid]=0
    set FSU_State[pid]=0
    set FSN_UnitBlocked[pid]=false
    set FSC_UnitBlocked[pid]=false
    set FSJ_UnitPending[pid]=false
    return true
endfunction
endlibrary
