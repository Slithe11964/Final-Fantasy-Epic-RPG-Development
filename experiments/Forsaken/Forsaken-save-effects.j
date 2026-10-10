library TForsakenSaveEffects requires TForsakenSaveNative
// Only newly allocated, hidden items. Policy is reviewed runtime data, never save data.
// Role 1 is a stored passive; role 2 is a retained active ability or harmless marker.
function FSA_Label takes integer raw returns string
    if raw=='A0MU' then
        return "A0MU(speed)"
    elseif raw=='fGmk' then
        return "fGmk(marker)"
    endif
    return I2S(raw)
endfunction

// Capture before failed placement removes the owned item. Never accepts a mismatch.
function FSA_ReadbackFailure takes integer index,string reason,integer raw returns boolean
    local integer slot=0
    local ability current
    local unit holder=FSN_PlacedUnit[index]
    local string detail=""
    loop
        exitwhen slot>=4
        set current=BlzGetItemAbilityByIndex(FSN_Item[index],slot)
        exitwhen current==null
        set detail=detail+FSA_Label(BlzGetAbilityId(current))+","
        set slot=slot+1
    endloop
    set current=null
    if holder!=null and raw!=0 then
        if BlzGetUnitAbility(holder,raw)!=null then
            set detail=detail+" unit ability=yes"
        else
            set detail=detail+" unit ability=no"
        endif
        set detail=detail+" speed="+R2S(GetUnitMoveSpeed(holder))
    endif
    set holder=null
    set FSN_LastError[index/57]="ability "+reason+" "+FSA_Label(raw)+"; item IDs="+detail
    return false
endfunction

function FSA_Check takes integer index returns boolean
    local integer abilityIndex=0
    local integer count=0
    local integer raw
    local integer expected=0
    local ability current
    if not FSN_EffectsReady[index] or FSN_Item[index]==null then
        return false
    endif
    loop
        exitwhen abilityIndex>=FSN_EffectCount[index]
        if not FSN_EffectsStored[index] or FSN_EffectRole[index*16+abilityIndex]==2 then
            set expected=expected+1
            if BlzGetItemAbility(FSN_Item[index],FSN_EffectId[index*16+abilityIndex])==null then
                return FSA_ReadbackFailure(index,"missing",FSN_EffectId[index*16+abilityIndex])
            endif
        elseif BlzGetItemAbility(FSN_Item[index],FSN_EffectId[index*16+abilityIndex])!=null then
            return FSA_ReadbackFailure(index,"stored passive still present",FSN_EffectId[index*16+abilityIndex])
        endif
        set abilityIndex=abilityIndex+1
    endloop
    // Count as well as membership: extras and duplicate IDs must not pass.
    loop
        set current=BlzGetItemAbilityByIndex(FSN_Item[index],count)
        exitwhen current==null
        if count>=16 then
            set current=null
            return FSA_ReadbackFailure(index,"enumeration exceeds16",0)
        endif
        set raw=BlzGetAbilityId(current)
        set abilityIndex=0
        loop
            exitwhen abilityIndex>=FSN_EffectCount[index] or FSN_EffectId[index*16+abilityIndex]==raw
            set abilityIndex=abilityIndex+1
        endloop
        if abilityIndex>=FSN_EffectCount[index] then
            set current=null
            return FSA_ReadbackFailure(index,"unexpected",raw)
        endif
        set count=count+1
    endloop
    set current=null
    if count!=expected then
        return FSA_ReadbackFailure(index,"count wanted="+I2S(expected)+" actual="+I2S(count),0)
    endif
    return true
endfunction

function FSA_BatchReady takes integer pid returns boolean
    local integer ordinal=0
    local integer index
    loop
        exitwhen ordinal>=FSN_Count[pid]
        set index=pid*57+ordinal
        if not FSN_EffectsReady[index] or not FSA_Check(index) or not FSN_CheckMetadata(pid,index) then
            return false
        endif
        set ordinal=ordinal+1
    endloop
    return true
endfunction

function FSA_PrepareCore takes integer pid,integer ordinal,boolean stored,hashtable policy returns boolean
    local integer index
    local integer abilityIndex=0
    local integer previous
    local integer raw
    local integer role
    local ability current
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_Operation[pid]!=2 or not FSN_Busy[pid] or FSN_Executing[pid] then
        return false
    endif
    set FSN_Executing[pid]=true
    set FSN_Busy[pid]=true
    if ordinal<0 or ordinal>=FSN_Count[pid] or policy==null then
        return FSN_Fail(pid)
    endif
    set index=pid*57+ordinal
    if FSN_EffectsReady[index] or not FSN_Check(pid,index) then
        return FSN_Fail(pid)
    endif
    // Snapshot all IDs before removals shift native enumeration indexes.
    loop
        set current=BlzGetItemAbilityByIndex(FSN_Item[index],abilityIndex)
        exitwhen current==null
        if abilityIndex>=16 then
            set current=null
            return FSN_Fail(pid)
        endif
        set raw=BlzGetAbilityId(current)
        set role=LoadInteger(policy,0,raw)
        if raw==0 or (role!=1 and role!=2) then
            set current=null
            return FSN_Fail(pid)
        endif
        set previous=0
        loop
            exitwhen previous>=abilityIndex
            if FSN_EffectId[index*16+previous]==raw then
                set current=null
                return FSN_Fail(pid)
            endif
            set previous=previous+1
        endloop
        set FSN_EffectId[index*16+abilityIndex]=raw
        set FSN_EffectRole[index*16+abilityIndex]=role
        set abilityIndex=abilityIndex+1
        set FSN_EffectCount[index]=abilityIndex
    endloop
    set current=null
    set FSN_EffectsStored[index]=stored
    set FSN_EffectsReady[index]=true
    set abilityIndex=0
    loop
        exitwhen abilityIndex>=FSN_EffectCount[index]
        if stored and FSN_EffectRole[index*16+abilityIndex]==1 then
            call BlzItemRemoveAbility(FSN_Item[index],FSN_EffectId[index*16+abilityIndex])
        endif
        set abilityIndex=abilityIndex+1
    endloop
    if not FSA_Check(index) or not FSN_Check(pid,index) then
        return FSN_Fail(pid)
    endif
    set FSN_Executing[pid]=false
    set FSN_Busy[pid]=false
    return true
endfunction

// Legacy entry retains every original phase guard.
function FSA_Prepare takes integer pid,integer ordinal,boolean stored,hashtable policy returns boolean
    local boolean result
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSN_RecoveryBlocked[pid] or FSN_ProgressionBlocked[pid] or FSN_HeroBlocked[pid] or FSN_SessionBlocked[pid] or FSN_UnitBlocked[pid] or FSN_ReferenceBlocked[pid] or FSN_BodyBlocked[pid] or FSN_OwnershipBlocked[pid] or FSN_PreparedBlocked[pid] or FSN_ActivationBlocked[pid] or FSN_Busy[pid] or FSN_State[pid]!=1 then
        return false
    endif
    set FSN_Busy[pid]=true
    set FSN_Operation[pid]=2
    set result=FSA_PrepareCore(pid,ordinal,stored,policy)
    set FSN_Operation[pid]=0
    set FSN_Busy[pid]=false
    return result
endfunction
endlibrary
