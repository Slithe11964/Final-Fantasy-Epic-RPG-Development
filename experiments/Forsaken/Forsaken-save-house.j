library TForsakenSaveHouse requires TForsakenSaveInventoryProfile
// Contained empty house staging only. No live house reference or item publication.

function FHS_Valid takes integer pid returns boolean
    return FHS_Contained(pid) and FSU_Empty(FHS_Unit[pid])
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
    return FSU_Idle(pid) and not FSR_Busy[pid] and FHS_State[pid]==1 and FSJ_HousePending[pid] and (FCG_State[pid]==0 or FCG_State[pid]==2 or FCG_State[pid]==4) and FHP_Verify(pid) and FSJ_Verify(pid) and FHS_Contained(pid) and FSU_CargoMatches(pid,FHS_Unit[pid])
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
