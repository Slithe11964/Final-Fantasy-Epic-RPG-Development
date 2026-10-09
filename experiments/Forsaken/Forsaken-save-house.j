library TForsakenSaveHouse requires TForsakenSaveInventoryProfile
// Contained empty house staging only. No live house reference or item publication.
globals
    // 0 idle,1 prepared,2 cleanup required,3 removed awaiting release.
    integer array FHS_State
    integer array FHS_Raw
endglobals

function FHS_Referenced takes unit candidate returns boolean
    local integer pid=0
    if FSU_Referenced(candidate) then
        return true
    endif
    loop
        exitwhen pid>=8
        if candidate==udg_PlayerHouse[pid+1] then
            return true
        endif
        set pid=pid+1
    endloop
    return false
endfunction

function FHS_Exclusive takes integer pid,unit candidate returns boolean
    local integer other=0
    local integer slot
    loop
        exitwhen other>=8
        if other!=pid and candidate==FHS_Unit[other] then
            return false
        endif
        set slot=0
        loop
            exitwhen slot>=FSU_Count[other]
            if candidate==FSU_Unit[other*24+slot] then
                return false
            endif
            set slot=slot+1
        endloop
        set other=other+1
    endloop
    return true
endfunction

function FHS_Valid takes integer pid returns boolean
    local unit candidate=FHS_Unit[pid]
    local boolean valid=candidate!=null
    if valid then
        set valid=GetUnitTypeId(candidate)==FHS_Raw[pid] and GetOwningPlayer(candidate)==Player(PLAYER_NEUTRAL_PASSIVE) and not IsUnitType(candidate,UNIT_TYPE_HERO) and GetWidgetLife(candidate)>0.405 and IsUnitHidden(candidate) and IsUnitPaused(candidate) and BlzIsUnitInvulnerable(candidate) and UnitInventorySize(candidate)==6 and UnitExtendedInventorySize(candidate)==0 and FSU_Empty(candidate) and not FHS_Referenced(candidate) and FHS_Exclusive(pid,candidate)
    endif
    set candidate=null
    return valid
endfunction

function FHS_Stage takes integer pid,real x,real y returns boolean
    local unit original
    local unit candidate
    local boolean valid
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHS_State[pid]!=0 or FHS_Unit[pid]!=null or FSJ_HousePending[pid] or FCG_State[pid]!=0 or FIP_State[pid]!=0 or FHA_State[pid]!=0 or FSC_Writing[pid] or not (x>=-32768. and x<=32768. and y>=-32768. and y<=32768.) or not FHP_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    set original=FSJ_House[pid]
    if original==null or original!=udg_PlayerHouse[pid+1] or GetUnitTypeId(original)==0 or IsUnitType(original,UNIT_TYPE_HERO) or UnitInventorySize(original)!=6 or UnitExtendedInventorySize(original)!=0 then
        set original=null
        return false
    endif
    set FHS_Raw[pid]=GetUnitTypeId(original)
    set original=null
    set FSJ_HousePending[pid]=true
    set FHS_State[pid]=2
    call FSR_Lock(pid,true)
    set candidate=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE),FHS_Raw[pid],x,y,0.)
    // A native returning an existing handle grants no deletion ownership.
    if candidate==null or FHS_Referenced(candidate) or FSU_Tracked(candidate) then
        call FSR_Lock(pid,false)
        set candidate=null
        return false
    endif
    set FHS_Unit[pid]=candidate
    call ShowUnit(candidate,false)
    call PauseUnit(candidate,true)
    call SetUnitInvulnerable(candidate,true)
    set candidate=null
    set valid=FHS_Valid(pid) and FSJ_VerifyCore(pid) and FHP_Matches(pid) and FHS_Valid(pid) and FHP_Context(pid)
    if valid then
        set FHS_State[pid]=1
    endif
    call FSR_Lock(pid,false)
    return valid
endfunction

function FHS_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    return FSU_Idle(pid) and not FSR_Busy[pid] and FHS_State[pid]==1 and FSJ_HousePending[pid] and FCG_State[pid]==0 and FIP_State[pid]==0 and FHP_Verify(pid) and FSJ_Verify(pid) and FHS_Valid(pid)
endfunction

function FHS_Recover takes integer pid returns boolean
    local unit candidate
    local boolean clean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHS_State[pid]==0 or FHS_State[pid]==3 or not FSJ_HousePending[pid] or FCG_State[pid]!=0 or FIP_State[pid]!=0 or FSC_Writing[pid] then
        return false
    endif
    set candidate=FHS_Unit[pid]
    if candidate!=null then
        if FHS_Referenced(candidate) or (GetUnitTypeId(candidate)!=0 and not FSU_Empty(candidate)) then
            set candidate=null
            return false
        endif
        if not FHS_Exclusive(pid,candidate) then
            set candidate=null
            return false
        endif
    endif
    set FHS_State[pid]=2
    call FSR_Lock(pid,true)
    if candidate!=null and GetUnitTypeId(candidate)!=0 then
        call RemoveUnit(candidate)
    endif
    set clean=candidate==null
    if candidate!=null then
        set clean=GetUnitTypeId(candidate)==0 and not FHS_Referenced(candidate)
    endif
    if clean then
        set FHS_Unit[pid]=null
        set FHS_State[pid]=3
    endif
    set candidate=null
    call FSR_Lock(pid,false)
    return clean
endfunction

function FHS_Release takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHS_State[pid]!=3 or FHS_Unit[pid]!=null or not FSJ_HousePending[pid] or FCG_State[pid]!=0 or FIP_State[pid]!=0 or FSC_Writing[pid] then
        return false
    endif
    set FHS_Raw[pid]=0
    set FHS_State[pid]=0
    set FSJ_HousePending[pid]=false
    return true
endfunction
endlibrary
