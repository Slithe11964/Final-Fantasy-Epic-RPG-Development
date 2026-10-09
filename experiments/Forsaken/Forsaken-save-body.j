library TForsakenSaveBody requires TForsakenSaveReferences
// Same-unit living body recovery; synchronized gameplay hooks must be excluded.
// No resurrection, orders, buffs, activation, original deletion or cooldown checks.
globals
    // 0 idle, 1 captured, 2 restored, 3 blocked.
    integer array FSB_State
    hashtable array FSB_Table
    unit array FSB_FreeCached
    unit array FSB_Unit
    integer array FSB_Raw
    player array FSB_Owner
    integer array FSB_Alias
    real array FSB_X
    real array FSB_Y
    real array FSB_Facing
    real array FSB_Life
    real array FSB_Mana
    real array FSB_MaxLife
    real array FSB_MaxMana
    boolean array FSB_Hidden
    boolean array FSB_Paused
    boolean array FSB_Invulnerable
endglobals

function FSB_Context takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit hero
    if udg_JobCount!=22 or udg_JobHeroHash!=FSB_Table[pid] or LoadUnitHandle(udg_JobHeroHash,'H02L',pid)!=FSB_FreeCached[pid] then
        return false
    endif
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set hero=FHU_Live(pid,slot)
        if hero!=FSB_Unit[index] then
            set hero=null
            return false
        endif
        if slot<22 and udg_JobUnitType[slot]!=FPG_JobRaw(slot) then
            set hero=null
            return false
        endif
        if hero!=null then
            if GetUnitTypeId(hero)!=FSB_Raw[index] or GetOwningPlayer(hero)!=FSB_Owner[index] or not IsUnitType(hero,UNIT_TYPE_HERO) or IsUnitType(hero,UNIT_TYPE_DEAD) or GetWidgetLife(hero)<=0.405 then
                set hero=null
                return false
            endif
            // Maxima must recover through progression/equipment before body setters.
            if GetUnitState(hero,UNIT_STATE_MAX_LIFE)!=FSB_MaxLife[index] or GetUnitState(hero,UNIT_STATE_MAX_MANA)!=FSB_MaxMana[index] then
                set hero=null
                return false
            endif
        endif
        set slot=slot+1
    endloop
    set hero=null
    return true
endfunction

function FSB_Matches takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit hero
    if not FSB_Context(pid) then
        return false
    endif
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set hero=FSB_Unit[index]
        if hero!=null and FSB_Alias[index]==slot then
            if GetUnitX(hero)!=FSB_X[index] or GetUnitY(hero)!=FSB_Y[index] or GetUnitFacing(hero)!=FSB_Facing[index] or GetWidgetLife(hero)!=FSB_Life[index] or GetUnitState(hero,UNIT_STATE_MANA)!=FSB_Mana[index] or IsUnitHidden(hero)!=FSB_Hidden[index] or IsUnitPaused(hero)!=FSB_Paused[index] or BlzIsUnitInvulnerable(hero)!=FSB_Invulnerable[index] then
                set hero=null
                return false
            endif
        endif
        set slot=slot+1
    endloop
    set hero=null
    return true
endfunction

function FSB_Clear takes integer pid returns nothing
    local integer slot=0
    loop
        exitwhen slot>=25
        set FSB_Unit[pid*25+slot]=null
        set FSB_Owner[pid*25+slot]=null
        set slot=slot+1
    endloop
    set FSB_Table[pid]=null
    set FSB_FreeCached[pid]=null
endfunction

function FSB_Begin takes integer pid returns boolean
    local integer slot=0
    local integer prior
    local integer index
    local unit hero
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSB_State[pid]!=0 or FSU_State[pid]!=0 or FSR_State[pid]!=0 or FSC_Writing[pid] or FHU_State[pid]!=1 or FSS_State[pid]!=1 or not FHU_Verify(pid,true) or not FSS_Verify(pid) or not FPG_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    set FSB_Table[pid]=udg_JobHeroHash
    set FSB_FreeCached[pid]=LoadUnitHandle(udg_JobHeroHash,'H02L',pid)
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set hero=FHU_Live(pid,slot)
        set FSB_Unit[index]=hero
        set FSB_Alias[index]=slot
        if hero!=null then
            set FSB_Raw[index]=GetUnitTypeId(hero)
            set FSB_Owner[index]=GetOwningPlayer(hero)
            set FSB_X[index]=GetUnitX(hero)
            set FSB_Y[index]=GetUnitY(hero)
            set FSB_Facing[index]=GetUnitFacing(hero)
            set FSB_Life[index]=GetWidgetLife(hero)
            set FSB_Mana[index]=GetUnitState(hero,UNIT_STATE_MANA)
            set FSB_MaxLife[index]=GetUnitState(hero,UNIT_STATE_MAX_LIFE)
            set FSB_MaxMana[index]=GetUnitState(hero,UNIT_STATE_MAX_MANA)
            set FSB_Hidden[index]=IsUnitHidden(hero)
            set FSB_Paused[index]=IsUnitPaused(hero)
            set FSB_Invulnerable[index]=BlzIsUnitInvulnerable(hero)
            if IsUnitType(hero,UNIT_TYPE_DEAD) or not (FSB_X[index]>=-32768. and FSB_X[index]<=32768. and FSB_Y[index]>=-32768. and FSB_Y[index]<=32768. and FSB_Facing[index]>=0. and FSB_Facing[index]<360. and FSB_Life[index]>0.405 and FSB_Life[index]<=FSB_MaxLife[index] and FSB_MaxLife[index]<=2147483647. and FSB_Mana[index]>=0. and FSB_Mana[index]<=FSB_MaxMana[index] and FSB_MaxMana[index]<=2147483647.) then
                set hero=null
                call FSB_Clear(pid)
                return false
            endif
            set prior=0
            loop
                exitwhen prior>=slot
                if FSB_Unit[pid*25+prior]==hero then
                    set FSB_Alias[index]=FSB_Alias[pid*25+prior]
                    exitwhen true
                endif
                set prior=prior+1
            endloop
        endif
        set slot=slot+1
    endloop
    set hero=null
    if not FSB_Matches(pid) then
        call FSB_Clear(pid)
        return false
    endif
    set FSB_State[pid]=1
    set FSJ_BodyPending[pid]=true
    return true
endfunction

function FSB_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSB_State[pid]==0 then
        return false
    endif
    return FSB_Matches(pid)
endfunction

function FSB_Recover takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit hero
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSB_State[pid]==0 or FSC_Writing[pid] then
        return false
    endif
    set FSB_State[pid]=3
    set FSN_BodyBlocked[pid]=true
    set FSC_BodyBlocked[pid]=true
    if not FSB_Context(pid) then
        return false
    endif
    call FSR_Lock(pid,true)
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set hero=FSB_Unit[index]
        if hero!=null and FSB_Alias[index]==slot then
            call SetUnitX(hero,FSB_X[index])
            call SetUnitY(hero,FSB_Y[index])
            call BlzSetUnitFacingEx(hero,FSB_Facing[index])
            call SetWidgetLife(hero,FSB_Life[index])
            call SetUnitState(hero,UNIT_STATE_MANA,FSB_Mana[index])
            call SetUnitInvulnerable(hero,FSB_Invulnerable[index])
            call ShowUnit(hero,not FSB_Hidden[index])
            call PauseUnit(hero,FSB_Paused[index])
        endif
        set slot=slot+1
    endloop
    set hero=null
    call FSR_Lock(pid,false)
    if not FSB_Matches(pid) then
        return false
    endif
    set FSB_State[pid]=2
    return true
endfunction

function FSB_Release takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSB_State[pid]!=2 or not FSB_Matches(pid) or not FSJ_Verify(pid) then
        return false
    endif
    call FSB_Clear(pid)
    set FSB_State[pid]=0
    set FSN_BodyBlocked[pid]=false
    set FSC_BodyBlocked[pid]=false
    set FSJ_BodyPending[pid]=false
    return true
endfunction
endlibrary
