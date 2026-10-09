library TForsakenSaveCargo requires TForsakenSaveActivation
// Internal contained cargo allocation/placement and cleanup; no load command.
// State0 idle,1 planning,2 sealed,3 cleanup blocked,4 recovered,5 staging.

function FCG_Context takes integer pid returns boolean
    local integer stage=0
    local integer key
    local unit candidate
    local player owner
    if FSU_State[pid]!=1 or FHP_State[pid]!=2 or FSO_State[pid]!=2 or FSR_State[pid]!=2 or FHA_State[pid]!=0 or FSU_Count[pid]!=FHP_Count[pid] or FSU_Count[pid]!=FSO_Count[pid] or FSU_Count[pid]<2 or FSU_Count[pid]>24 or not FSR_Matches(pid,true) then
        return false
    endif
    if FCG_Unit[pid*2]!=FSO_Unit[pid*2] or FCG_Unit[pid*2+1]!=FSO_Unit[pid*2+1] or FCG_Unit[pid*2]==FCG_Unit[pid*2+1] then
        return false
    endif
    loop
        exitwhen stage>=FSU_Count[pid]
        set key=pid*24+stage
        set candidate=FSU_Unit[key]
        set owner=Player(PLAYER_NEUTRAL_PASSIVE)
        if candidate==FCG_Unit[pid*2] or candidate==FCG_Unit[pid*2+1] then
            set owner=Player(pid)
        endif
        if candidate==null or candidate!=FHP_Unit[key] or GetUnitTypeId(candidate)!=FSU_Raw[key] or FHP_Raw[key]!=FSU_Raw[key] or GetOwningPlayer(candidate)!=owner or FHP_Owner[key]!=owner or not IsUnitType(candidate,UNIT_TYPE_HERO) or IsUnitType(candidate,UNIT_TYPE_DEAD) or not (GetWidgetLife(candidate)>0.405) or not IsUnitHidden(candidate) or not IsUnitPaused(candidate) or not BlzIsUnitInvulnerable(candidate) then
            set candidate=null
            set owner=null
            return false
        endif
        set stage=stage+1
    endloop
    set candidate=null
    set owner=null
    return true
endfunction

function FCG_Begin takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FCG_State[pid]!=0 or FSJ_HousePending[pid] or FSJ_CargoPending[pid] or FHA_State[pid]!=0 or FSC_Writing[pid] or FSN_State[pid]!=0 or FSN_Count[pid]!=0 or FSN_AuxCount[pid]!=0 or not FHP_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    set FCG_Unit[pid*2]=FSO_Unit[pid*2]
    set FCG_Unit[pid*2+1]=FSO_Unit[pid*2+1]
    if not FCG_Context(pid) then
        set FCG_Unit[pid*2]=null
        set FCG_Unit[pid*2+1]=null
        return false
    endif
    set FCG_Count[pid]=0
    set FCG_State[pid]=1
    set FSJ_CargoPending[pid]=true
    return true
endfunction

function FCG_Plan takes integer pid,integer raw,integer holder,integer slot returns boolean
    local integer ordinal=0
    local integer key
    local integer limit=6
    local integer position=slot
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FCG_State[pid]!=1 or FSC_Writing[pid] or FSN_Count[pid]!=0 or FSN_State[pid]!=0 or raw==0 or holder<1 or holder>4 or FCG_Count[pid]>=51 or not FCG_Context(pid) then
        return false
    endif
    if holder==2 then
        set limit=30
    elseif holder==3 then
        set limit=9
    endif
    if slot<0 or slot>=limit then
        return false
    endif
    if holder==2 then
        set position=6+slot
    elseif holder==3 then
        set position=36+slot
    elseif holder==4 then
        set position=45+slot
    endif
    loop
        exitwhen ordinal>=FCG_Count[pid]
        set key=pid*51+ordinal
        if FCG_Holder[key]==holder and FCG_Slot[key]==slot then
            return false
        endif
        set ordinal=ordinal+1
    endloop
    set key=pid*51+FCG_Count[pid]
    set FCG_Raw[key]=raw
    set FCG_Holder[key]=holder
    set FCG_Slot[key]=slot
    set FCG_Ordinal[pid*51+position]=FCG_Count[pid]+1
    set FCG_Count[pid]=FCG_Count[pid]+1
    return true
endfunction

function FCG_ItemsValid takes integer pid,boolean prepared returns boolean
    local integer ordinal=0
    local integer prior
    local integer index
    local integer key
    local integer stage=0
    local unit expected
    if FSN_Count[pid]<0 or FSN_Count[pid]>FCG_Count[pid] or FSN_AuxCount[pid]!=0 or (FSN_State[pid]!=1 and FSN_State[pid]!=4) then
        return false
    endif
    loop
        exitwhen ordinal>=FSN_Count[pid]
        set index=pid*57+ordinal
        set key=pid*51+ordinal
        if FSN_Item[index]==null or FSN_Raw[index]!=FCG_Raw[key] then
            return false
        endif
        if FSN_PlacedItem[index]!=null then
            set expected=FCG_Unit[pid*2]
            if FCG_Holder[key]==4 then
                set expected=FCG_Unit[pid*2+1]
            endif
            if FSN_PlacedUnit[index]!=expected or FSN_PlacedOwner[index]!=Player(pid) or FSN_PlacedHolder[index]!=FCG_Holder[key] or FSN_PlacedSlot[index]!=FCG_Slot[key] or not FSP_Check(pid,index) then
                set expected=null
                return false
            endif
        elseif not FSN_Check(pid,index) then
            return false
        endif
        if (prepared and not FSN_EffectsReady[index]) or (FSN_EffectsReady[index] and (FSN_EffectsStored[index]!=(FCG_Holder[key]==2) or not FSA_Check(index))) then
            set expected=null
            return false
        endif
        set prior=0
        loop
            exitwhen prior>=ordinal
            if FSN_Item[index]==FSN_Item[pid*57+prior] then
                set expected=null
                return false
            endif
            set prior=prior+1
        endloop
        set ordinal=ordinal+1
    endloop
    set expected=null
    loop
        exitwhen stage>=FSU_Count[pid]
        if not FSU_CargoUnit(pid,FSU_Unit[pid*24+stage]) then
            return false
        endif
        set stage=stage+1
    endloop
    return true
endfunction

function FCG_StartItems takes integer pid returns boolean
    local integer stage=0
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FCG_State[pid]!=1 or not FSJ_CargoPending[pid] or FCG_Count[pid]<1 or FSC_Writing[pid] or FSN_State[pid]!=0 or FSN_Count[pid]!=0 or FSN_AuxCount[pid]!=0 or not FCG_Context(pid) or not FHP_CoreMatches(pid) or not FSJ_Verify(pid) then
        return false
    endif
    loop
        exitwhen stage>=FSU_Count[pid]
        if not FSU_Empty(FSU_Unit[pid*24+stage]) then
            return false
        endif
        set stage=stage+1
    endloop
    set FCG_State[pid]=5
    set FSN_State[pid]=1
    return true
endfunction

function FCG_CallReady takes integer pid returns boolean
    return FSU_Idle(pid) and not FSR_Busy[pid] and FCG_State[pid]==5 and FSJ_CargoPending[pid] and not FSC_Writing[pid] and FSN_Operation[pid]==0 and not FSN_Executing[pid] and FCG_Context(pid) and FHP_CoreMatches(pid) and FSJ_Verify(pid)
endfunction

function FCG_CallDone takes integer pid,boolean result,boolean prepared returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSR_Busy[pid] or not FSU_Busy[pid] or FCG_State[pid]!=5 or FSN_Operation[pid]<1 or FSN_Operation[pid]>4 or FSN_Executing[pid] then
        return false
    endif
    set FSN_Operation[pid]=0
    set FSN_Busy[pid]=true
    // The shared lock remains held until all readbacks finish.
    if not result or not FCG_Context(pid) or not FHP_CoreMatches(pid) or not FSJ_VerifyCore(pid) or not FCG_ItemsValid(pid,prepared) or not FCG_Context(pid) or not FHP_CoreMatches(pid) then
        set FCG_State[pid]=3
        call FSR_Lock(pid,false)
        return false
    endif
    call FSR_Lock(pid,false)
    return true
endfunction

function FCG_Stage takes integer pid,integer charges,boolean bound,integer flags,integer high,integer low,real x,real y returns boolean
    local integer key
    local boolean result
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FCG_CallReady(pid) or FSN_State[pid]!=1 or FSN_Count[pid]>=FCG_Count[pid] or not (x>=-32768. and x<=32768. and y>=-32768. and y<=32768.) or not FCG_ItemsValid(pid,false) then
        return false
    endif
    set key=pid*51+FSN_Count[pid]
    call FSR_Lock(pid,true)
    set FSN_Operation[pid]=1
    set result=FSN_StageCore(pid,FCG_Raw[key],charges,bound,flags,high,low,x,y)
    return FCG_CallDone(pid,result,false)
endfunction

function FCG_PrepareItem takes integer pid,integer ordinal,hashtable policy returns boolean
    local boolean result
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FCG_CallReady(pid) or FSN_State[pid]!=1 or FSN_Count[pid]!=FCG_Count[pid] or ordinal<0 or ordinal>=FCG_Count[pid] or not FCG_ItemsValid(pid,false) then
        return false
    endif
    call FSR_Lock(pid,true)
    set FSN_Operation[pid]=2
    set result=FSA_PrepareCore(pid,ordinal,FCG_Holder[pid*51+ordinal]==2,policy)
    return FCG_CallDone(pid,result,false)
endfunction

function FCG_PlaceItem takes integer pid,integer ordinal,integer spacerRaw,integer ringSpacerRaw,integer harmlessMarker returns boolean
    local integer key
    local unit holder
    local boolean result
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FCG_CallReady(pid) or FSN_Count[pid]!=FCG_Count[pid] or ordinal<0 or ordinal>=FCG_Count[pid] or not FCG_ItemsValid(pid,true) then
        return false
    endif
    set key=pid*51+ordinal
    set holder=FCG_Unit[pid*2]
    if FCG_Holder[key]==4 then
        set holder=FCG_Unit[pid*2+1]
    endif
    call FSR_Lock(pid,true)
    if FCG_Holder[key]==3 then
        set FSN_Operation[pid]=4
        set result=FSE_PlaceCore(pid,ordinal,holder,FCG_Slot[key],ringSpacerRaw,harmlessMarker)
    else
        set FSN_Operation[pid]=3
        set result=FSP_PlaceCore(pid,ordinal,holder,FCG_Holder[key],FCG_Slot[key],spacerRaw)
    endif
    set holder=null
    return FCG_CallDone(pid,result,true)
endfunction

function FCG_Seal takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or (FCG_State[pid]!=1 and FCG_State[pid]!=5) or FSC_Writing[pid] or not FCG_Context(pid) or not FSU_CargoAudit(pid) or not FHP_CoreMatches(pid) or not FSJ_Verify(pid) then
        return false
    endif
    set FCG_State[pid]=2
    return true
endfunction

function FCG_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    return FSU_Idle(pid) and not FSR_Busy[pid] and FCG_State[pid]==2 and FCG_Context(pid) and FSU_CargoAudit(pid) and FHP_CoreMatches(pid) and FSJ_Verify(pid)
endfunction

function FCG_Recover takes integer pid returns boolean
    local integer ordinal=0
    local integer prior
    local integer stage=0
    local integer index
    local boolean clean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FCG_State[pid]==0 or FCG_State[pid]==4 or FSC_Writing[pid] or not FCG_Context(pid) or FSN_Count[pid]<0 or FSN_Count[pid]>FCG_Count[pid] or FSN_AuxCount[pid]<0 or FSN_AuxCount[pid]>36 then
        return false
    endif
    // Cleanup accepts metadata/core drift, but never original or duplicate handles.
    loop
        exitwhen ordinal>=FSN_Count[pid]
        set index=pid*57+ordinal
        if FSN_Item[index]!=null then
            if FSN_Raw[index]!=FCG_Raw[pid*51+ordinal] then
                return false
            endif
            set prior=0
            loop
                exitwhen prior>=57
                if FSN_Item[index]==FSJ_Item[pid*57+prior] or (prior<ordinal and FSN_Item[index]==FSN_Item[pid*57+prior]) then
                    return false
                endif
                set prior=prior+1
            endloop
        endif
        set ordinal=ordinal+1
    endloop
    set ordinal=0
    loop
        exitwhen ordinal>=FSN_AuxCount[pid]
        if FSN_AuxItem[pid*36+ordinal]!=null then
            set prior=0
            loop
                exitwhen prior>=57
                if FSN_AuxItem[pid*36+ordinal]==FSJ_Item[pid*57+prior] or (prior<FSN_Count[pid] and FSN_AuxItem[pid*36+ordinal]==FSN_Item[pid*57+prior]) or (prior<ordinal and FSN_AuxItem[pid*36+ordinal]==FSN_AuxItem[pid*36+prior]) then
                    return false
                endif
                set prior=prior+1
            endloop
        endif
        set ordinal=ordinal+1
    endloop
    set FCG_State[pid]=3
    call FSR_Lock(pid,true)
    set clean=FSN_Cleanup(pid)
    if clean then
        set FSN_State[pid]=0
    endif
    call FSR_Lock(pid,false)
    if not clean or not FCG_Context(pid) then
        return false
    endif
    loop
        exitwhen stage>=FSU_Count[pid]
        if not FSU_Empty(FSU_Unit[pid*24+stage]) then
            return false
        endif
        set stage=stage+1
    endloop
    set FCG_State[pid]=4
    return true
endfunction

function FCG_Release takes integer pid returns boolean
    local integer stage=0
    local integer key
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FCG_State[pid]!=4 or FSC_Writing[pid] or not FCG_Context(pid) or FSN_State[pid]!=0 or FSN_Count[pid]!=0 or FSN_AuxCount[pid]!=0 then
        return false
    endif
    loop
        exitwhen stage>=FSU_Count[pid]
        if not FSU_Empty(FSU_Unit[pid*24+stage]) then
            return false
        endif
        set stage=stage+1
    endloop
    set stage=0
    loop
        exitwhen stage>=51
        set FCG_Ordinal[pid*51+stage]=0
        set stage=stage+1
    endloop
    set stage=0
    loop
        exitwhen stage>=FCG_Count[pid]
        set key=pid*51+stage
        set FCG_Raw[key]=0
        set FCG_Holder[key]=0
        set FCG_Slot[key]=0
        set stage=stage+1
    endloop
    set FCG_Unit[pid*2]=null
    set FCG_Unit[pid*2+1]=null
    set FCG_Count[pid]=0
    set FCG_State[pid]=0
    set FSJ_CargoPending[pid]=false
    return true
endfunction
endlibrary
