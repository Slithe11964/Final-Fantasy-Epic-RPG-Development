library TForsakenSaveActivation requires TForsakenSavePreparedHeroes
// Reversible empty-pair exposure only; no load route or successful commit.
// Caller must hold synchronized exclusion, including movement/regeneration/hooks.
globals
    // 0 idle, 1 captured, 2 exposed, 3 blocked, 4 contained.
    integer array FHA_State
    integer array FHA_Count
    unit array FHA_Old
    unit array FHA_New
    real array FHA_X
    real array FHA_Y
    real array FHA_Facing
    real array FHA_OldX
    real array FHA_OldY
    real array FHA_OldFacing
endglobals

function FHA_Context takes integer pid,boolean prepared returns boolean
    local integer slot=0
    local integer index
    local integer body
    local integer skill
    local unit original
    local unit candidate
    if FHP_State[pid]!=2 or FSO_State[pid]!=2 or FSB_State[pid]!=1 or FSU_State[pid]!=1 or FHP_Count[pid]!=FHA_Count[pid] or FSU_Count[pid]!=FHA_Count[pid] or not FSO_Context(pid) then
        return false
    endif
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        set body=pid*25+24-slot
        set original=FHA_Old[index]
        set candidate=FHA_New[index]
        if original==null or original!=FSB_Unit[body] or original==candidate or GetUnitTypeId(original)!=FSB_Raw[body] or GetOwningPlayer(original)!=FSB_Owner[body] or not IsUnitType(original,UNIT_TYPE_HERO) then
            set original=null
            set candidate=null
            return false
        endif
        if prepared and (IsUnitType(original,UNIT_TYPE_DEAD) or not (GetWidgetLife(original)>0.405) or GetUnitX(original)!=FSB_X[body] or GetUnitY(original)!=FSB_Y[body] or GetUnitFacing(original)!=FSB_Facing[body] or GetWidgetLife(original)!=FSB_Life[body] or GetUnitState(original,UNIT_STATE_MANA)!=FSB_Mana[body] or GetUnitState(original,UNIT_STATE_MAX_LIFE)!=FSB_MaxLife[body] or GetUnitState(original,UNIT_STATE_MAX_MANA)!=FSB_MaxMana[body]) then
            set original=null
            set candidate=null
            return false
        endif
        if candidate==null or candidate!=FSO_Unit[index] or candidate==FSB_Unit[pid*25+23] or candidate==FSB_Unit[pid*25+24] or GetOwningPlayer(candidate)!=Player(pid) then
            set original=null
            set candidate=null
            return false
        endif
        set slot=slot+1
    endloop
    set original=null
    set slot=0
    loop
        exitwhen slot>=FHA_Count[pid]
        set index=pid*24+slot
        set candidate=FHP_Unit[index]
        if candidate==null or candidate!=FSU_Unit[index] or GetUnitTypeId(candidate)!=FHP_Raw[index] or GetOwningPlayer(candidate)!=FHP_Owner[index] or not IsUnitType(candidate,UNIT_TYPE_HERO) or IsUnitType(candidate,UNIT_TYPE_DEAD) or not (GetWidgetLife(candidate)>0.405) or not FSU_Empty(candidate) then
            set candidate=null
            return false
        endif
        if prepared and candidate!=FHA_New[pid*2] and candidate!=FHA_New[pid*2+1] and (not IsUnitHidden(candidate) or not IsUnitPaused(candidate) or not BlzIsUnitInvulnerable(candidate)) then
            set candidate=null
            return false
        endif
        if prepared and FSU_Role[index]<22 then
            set skill=0
            loop
                exitwhen skill>=5
                if FHP_Skill[index*5+skill]!=udg_JobSkill[FSU_Role[index]*5+skill+1] then
                    set candidate=null
                    return false
                endif
                set skill=skill+1
            endloop
        endif
        set slot=slot+1
    endloop
    set candidate=null
    return not prepared or FHP_CoreMatches(pid)
endfunction

function FHA_Matches takes integer pid,boolean exposed returns boolean
    local integer slot=0
    local integer index
    local unit candidate
    if not FHA_Context(pid,exposed) then
        return false
    endif
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        set candidate=FHA_New[index]
        if IsUnitHidden(candidate)==exposed or IsUnitPaused(candidate)==exposed or BlzIsUnitInvulnerable(candidate)==exposed then
            set candidate=null
            return false
        endif
        if exposed then
            if GetUnitX(candidate)!=FHA_X[index] or GetUnitY(candidate)!=FHA_Y[index] or GetUnitFacing(candidate)!=FHA_Facing[index] then
                set candidate=null
                return false
            endif
            if not IsUnitHidden(FHA_Old[index]) or not IsUnitPaused(FHA_Old[index]) or not BlzIsUnitInvulnerable(FHA_Old[index]) then
                set candidate=null
                return false
            endif
        elseif GetUnitX(candidate)!=FHA_OldX[index] or GetUnitY(candidate)!=FHA_OldY[index] or GetUnitFacing(candidate)!=FHA_OldFacing[index] then
            set candidate=null
            return false
        endif
        set slot=slot+1
    endloop
    set candidate=null
    return true
endfunction

function FHA_Clear takes integer pid returns nothing
    set FHA_Old[pid*2]=null
    set FHA_Old[pid*2+1]=null
    set FHA_New[pid*2]=null
    set FHA_New[pid*2+1]=null
    set FHA_Count[pid]=0
endfunction

function FHA_Begin takes integer pid,real heroX,real heroY,real heroFacing,real gayaX,real gayaY,real gayaFacing returns boolean
    local integer slot=0
    local integer index
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHA_State[pid]!=0 or FSJ_CargoPending[pid] or FSC_Writing[pid] or FSN_BodyBlocked[pid] or not FHP_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    if not (heroX>=-32768. and heroX<=32768. and heroY>=-32768. and heroY<=32768. and heroFacing>=0. and heroFacing<360. and gayaX>=-32768. and gayaX<=32768. and gayaY>=-32768. and gayaY<=32768. and gayaFacing>=0. and gayaFacing<360.) then
        return false
    endif
    set FHA_Count[pid]=FHP_Count[pid]
    set FHA_X[pid*2]=heroX
    set FHA_Y[pid*2]=heroY
    set FHA_Facing[pid*2]=heroFacing
    set FHA_X[pid*2+1]=gayaX
    set FHA_Y[pid*2+1]=gayaY
    set FHA_Facing[pid*2+1]=gayaFacing
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        set FHA_Old[index]=FSB_Unit[pid*25+24-slot]
        set FHA_New[index]=FSO_Unit[index]
        set FHA_OldX[index]=GetUnitX(FHA_New[index])
        set FHA_OldY[index]=GetUnitY(FHA_New[index])
        set FHA_OldFacing[index]=GetUnitFacing(FHA_New[index])
        set slot=slot+1
    endloop
    if not FHA_Context(pid,true) or not FHA_Matches(pid,false) then
        call FHA_Clear(pid)
        return false
    endif
    set FHA_State[pid]=1
    set FSN_ActivationBlocked[pid]=true
    set FSC_ActivationBlocked[pid]=true
    set FSJ_ActivationPending[pid]=true
    return true
endfunction

function FHA_Expose takes integer pid returns boolean
    local integer slot=0
    local integer index
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHA_State[pid]!=1 or FSC_Writing[pid] or FSN_BodyBlocked[pid] or not FHA_Context(pid,true) or not FHA_Matches(pid,false) or not FSJ_Verify(pid) then
        return false
    endif
    set FHA_State[pid]=3
    call FSR_Lock(pid,true)
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        call ShowUnit(FHA_Old[index],false)
        call PauseUnit(FHA_Old[index],true)
        call SetUnitInvulnerable(FHA_Old[index],true)
        set slot=slot+1
    endloop
    // Never expose a replacement while either original is still uncontained.
    set slot=0
    loop
        exitwhen slot>=2
        if not IsUnitHidden(FHA_Old[pid*2+slot]) or not IsUnitPaused(FHA_Old[pid*2+slot]) or not BlzIsUnitInvulnerable(FHA_Old[pid*2+slot]) then
            call FSR_Lock(pid,false)
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        call SetUnitX(FHA_New[index],FHA_X[index])
        call SetUnitY(FHA_New[index],FHA_Y[index])
        call BlzSetUnitFacingEx(FHA_New[index],FHA_Facing[index])
        set slot=slot+1
    endloop
    // Verify positions before unpausing/showing either replacement.
    set slot=0
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        if GetUnitX(FHA_New[index])!=FHA_X[index] or GetUnitY(FHA_New[index])!=FHA_Y[index] or GetUnitFacing(FHA_New[index])!=FHA_Facing[index] then
            call FSR_Lock(pid,false)
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        call SetUnitInvulnerable(FHA_New[index],false)
        call ShowUnit(FHA_New[index],true)
        call PauseUnit(FHA_New[index],false)
        set slot=slot+1
    endloop
    call FSR_Lock(pid,false)
    if not FHA_Matches(pid,true) or not FSJ_Verify(pid) then
        return false
    endif
    set FHA_State[pid]=2
    return true
endfunction

function FHA_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHA_State[pid]!=2 then
        return false
    endif
    return FHA_Matches(pid,true) and FSJ_Verify(pid)
endfunction

function FHA_Contain takes integer pid returns boolean
    local integer slot=0
    local integer index
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHA_State[pid]==0 or FSC_Writing[pid] or not FHA_Context(pid,false) then
        return false
    endif
    set FHA_State[pid]=3
    call FSR_Lock(pid,true)
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        call ShowUnit(FHA_New[index],false)
        call PauseUnit(FHA_New[index],true)
        call SetUnitInvulnerable(FHA_New[index],true)
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=2
        if not IsUnitHidden(FHA_New[pid*2+slot]) or not IsUnitPaused(FHA_New[pid*2+slot]) or not BlzIsUnitInvulnerable(FHA_New[pid*2+slot]) then
            call FSR_Lock(pid,false)
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=2
        set index=pid*2+slot
        call SetUnitX(FHA_New[index],FHA_OldX[index])
        call SetUnitY(FHA_New[index],FHA_OldY[index])
        call BlzSetUnitFacingEx(FHA_New[index],FHA_OldFacing[index])
        set slot=slot+1
    endloop
    call FSR_Lock(pid,false)
    if not FHA_Matches(pid,false) then
        return false
    endif
    set FHA_State[pid]=4
    return true
endfunction

function FHA_Release takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHA_State[pid]!=4 or not FHA_Matches(pid,false) or not FSJ_Verify(pid) then
        return false
    endif
    call FHA_Clear(pid)
    set FHA_State[pid]=0
    set FSN_ActivationBlocked[pid]=false
    set FSC_ActivationBlocked[pid]=false
    set FSJ_ActivationPending[pid]=false
    return true
endfunction
endlibrary
