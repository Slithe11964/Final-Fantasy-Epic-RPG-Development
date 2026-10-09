library TForsakenSaveOwnership requires TForsakenSaveBody
// Reversible ownership preparation for active/Gaya replacements only.
// Targets remain hidden/paused/invulnerable/empty; no activation or commit.
globals
    // 0 idle, 1 captured, 2 assigned, 3 blocked, 4 neutralized.
    integer array FSO_State
    integer array FSO_Count
    integer array FSO_Stage
    unit array FSO_Unit
    integer array FSO_Raw
endglobals

function FSO_Context takes integer pid returns boolean
    local integer slot=0
    local integer key
    local integer stage
    local unit candidate
    if FSU_State[pid]!=1 or FSU_Count[pid]!=FSO_Count[pid] or FSR_State[pid]!=2 or not FSR_Matches(pid,true) then
        return false
    endif
    loop
        exitwhen slot>=2
        set key=pid*2+slot
        set stage=FSO_Stage[key]
        set candidate=FSO_Unit[key]
        if stage<0 or stage>=FSU_Count[pid] or candidate==null or candidate!=FSU_Unit[pid*24+stage] or GetUnitTypeId(candidate)!=FSO_Raw[key] or not IsUnitType(candidate,UNIT_TYPE_HERO) or IsUnitType(candidate,UNIT_TYPE_DEAD) or not (GetWidgetLife(candidate)>0.405) or not FSU_Empty(candidate) then
            set candidate=null
            return false
        endif
        if (slot==0 and (FSU_Role[pid*24+stage]>=23 or candidate!=udg_PlayerHero[pid+1])) or (slot==1 and (FSU_Role[pid*24+stage]!=23 or candidate!=udg_SpiritOfGaya[pid+1])) then
            set candidate=null
            return false
        endif
        set slot=slot+1
    endloop
    set candidate=null
    return FSO_Unit[pid*2]!=FSO_Unit[pid*2+1]
endfunction

function FSO_Matches takes integer pid,player owner returns boolean
    local integer slot=0
    local unit candidate
    if not FSO_Context(pid) then
        return false
    endif
    loop
        exitwhen slot>=2
        set candidate=FSO_Unit[pid*2+slot]
        if GetOwningPlayer(candidate)!=owner or not IsUnitHidden(candidate) or not IsUnitPaused(candidate) or not BlzIsUnitInvulnerable(candidate) then
            set candidate=null
            return false
        endif
        set slot=slot+1
    endloop
    set candidate=null
    return true
endfunction

function FSO_Clear takes integer pid returns nothing
    set FSO_Unit[pid*2]=null
    set FSO_Unit[pid*2+1]=null
    set FSO_Count[pid]=0
endfunction

function FSO_Begin takes integer pid returns boolean
    local integer slot=0
    local integer role
    local integer found=0
    local unit candidate
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSO_State[pid]!=0 or FSR_State[pid]!=2 or FSU_State[pid]!=1 or FSB_State[pid]!=1 or FSC_Writing[pid] or FSN_BodyBlocked[pid] or not FSR_Matches(pid,true) then
        return false
    endif
    call FSO_Clear(pid)
    set FSO_Count[pid]=FSU_Count[pid]
    loop
        exitwhen slot>=FSU_Count[pid]
        set candidate=FSU_Unit[pid*24+slot]
        // Audit the complete owned batch, including dormant job replacements.
        if candidate==null or GetUnitTypeId(candidate)!=FSU_Raw[pid*24+slot] or not IsUnitType(candidate,UNIT_TYPE_HERO) or IsUnitType(candidate,UNIT_TYPE_DEAD) or not (GetWidgetLife(candidate)>0.405) or GetOwningPlayer(candidate)!=Player(PLAYER_NEUTRAL_PASSIVE) or not IsUnitHidden(candidate) or not IsUnitPaused(candidate) or not BlzIsUnitInvulnerable(candidate) or not FSU_Empty(candidate) then
            set candidate=null
            call FSO_Clear(pid)
            return false
        endif
        set role=-1
        if candidate==udg_PlayerHero[pid+1] and FSU_Role[pid*24+slot]<23 then
            set role=0
        elseif candidate==udg_SpiritOfGaya[pid+1] and FSU_Role[pid*24+slot]==23 then
            set role=1
        endif
        if role>=0 then
            set FSO_Stage[pid*2+role]=slot
            set FSO_Unit[pid*2+role]=candidate
            set FSO_Raw[pid*2+role]=GetUnitTypeId(candidate)
            set found=found+1
        endif
        set slot=slot+1
    endloop
    set candidate=null
    if found!=2 or not FSO_Matches(pid,Player(PLAYER_NEUTRAL_PASSIVE)) then
        call FSO_Clear(pid)
        return false
    endif
    set FSO_State[pid]=1
    set FSN_OwnershipBlocked[pid]=true
    set FSC_OwnershipBlocked[pid]=true
    set FSJ_OwnershipPending[pid]=true
    return true
endfunction

function FSO_Assign takes integer pid returns boolean
    local integer slot=0
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSO_State[pid]!=1 or FSC_Writing[pid] or FSN_BodyBlocked[pid] or not FSO_Matches(pid,Player(PLAYER_NEUTRAL_PASSIVE)) then
        return false
    endif
    set FSO_State[pid]=3
    call FSR_Lock(pid,true)
    loop
        exitwhen slot>=2
        call SetUnitOwner(FSO_Unit[pid*2+slot],Player(pid),false)
        set slot=slot+1
    endloop
    call FSR_Lock(pid,false)
    if not FSO_Matches(pid,Player(pid)) then
        return false
    endif
    set FSO_State[pid]=2
    return true
endfunction

function FSO_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSO_State[pid]!=2 then
        return false
    endif
    return FSO_Matches(pid,Player(pid))
endfunction

function FSO_Neutralize takes integer pid returns boolean
    local integer slot=0
    local player owner
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSJ_PreparedPending[pid] or FSJ_ActivationPending[pid] or FSO_State[pid]==0 or FSC_Writing[pid] then
        return false
    endif
    set FSO_State[pid]=3
    if not FSO_Context(pid) then
        return false
    endif
    loop
        exitwhen slot>=2
        set owner=GetOwningPlayer(FSO_Unit[pid*2+slot])
        if owner!=Player(pid) and owner!=Player(PLAYER_NEUTRAL_PASSIVE) then
            set owner=null
            return false
        endif
        set slot=slot+1
    endloop
    set owner=null
    call FSR_Lock(pid,true)
    set slot=0
    loop
        exitwhen slot>=2
        call ShowUnit(FSO_Unit[pid*2+slot],false)
        call PauseUnit(FSO_Unit[pid*2+slot],true)
        call SetUnitInvulnerable(FSO_Unit[pid*2+slot],true)
        call SetUnitOwner(FSO_Unit[pid*2+slot],Player(PLAYER_NEUTRAL_PASSIVE),false)
        set slot=slot+1
    endloop
    call FSR_Lock(pid,false)
    if not FSO_Matches(pid,Player(PLAYER_NEUTRAL_PASSIVE)) then
        return false
    endif
    set FSO_State[pid]=4
    return true
endfunction

function FSO_Release takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSO_State[pid]!=4 or not FSO_Matches(pid,Player(PLAYER_NEUTRAL_PASSIVE)) then
        return false
    endif
    call FSO_Clear(pid)
    set FSO_State[pid]=0
    set FSN_OwnershipBlocked[pid]=false
    set FSC_OwnershipBlocked[pid]=false
    set FSJ_OwnershipPending[pid]=false
    return true
endfunction
endlibrary
