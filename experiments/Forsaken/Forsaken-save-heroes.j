library TForsakenSaveHeroes requires TForsakenSaveProgression
// Original unit progression only; caller must suppress gameplay/level/effect hooks.
// Never recreate original units/abilities; cooldown refresh is permitted.
globals
    // 0 idle, 1 captured, 2 core restored, 3 blocked.
    integer array FHU_State
    boolean array FHU_Busy
    hashtable array FHU_Table
    unit array FHU_FreeCached
    unit array FHU_Unit
    integer array FHU_Alias
    integer array FHU_Raw
    player array FHU_Owner
    integer array FHU_XP
    integer array FHU_Level
    integer array FHU_Points
    integer array FHU_Str
    integer array FHU_Agi
    integer array FHU_Int
    integer array FHU_TotalStr
    integer array FHU_TotalAgi
    integer array FHU_TotalInt
    integer array FHU_Count
    integer array FHU_AbilityId
    integer array FHU_Rank
    ability array FHU_Ability
endglobals

function FHU_Live takes integer pid,integer slot returns unit
    if slot<22 then
        return LoadUnitHandle(udg_JobHeroHash,FPG_JobRaw(slot),pid)
    elseif slot==22 then
        return udg_FreelancerHero[pid+1]
    elseif slot==23 then
        return udg_SpiritOfGaya[pid+1]
    endif
    return udg_PlayerHero[pid+1]
endfunction

function FHU_Context takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit hero
    if udg_JobCount!=22 or udg_JobHeroHash!=FHU_Table[pid] or LoadUnitHandle(udg_JobHeroHash,'H02L',pid)!=FHU_FreeCached[pid] or udg_PlayerHero[pid+1]!=FSJ_Hero[pid] or udg_SpiritOfGaya[pid+1]!=FSJ_Gaya[pid] then
        return false
    endif
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set hero=FHU_Live(pid,slot)
        if hero!=FHU_Unit[index] then
            set hero=null
            return false
        endif
        if slot<22 and udg_JobUnitType[slot]!=FPG_JobRaw(slot) then
            set hero=null
            return false
        endif
        if hero!=null then
            if GetUnitTypeId(hero)!=FHU_Raw[index] or GetOwningPlayer(hero)!=FHU_Owner[index] or not IsUnitType(hero,UNIT_TYPE_HERO) then
                set hero=null
                return false
            endif
        endif
        set slot=slot+1
    endloop
    set hero=null
    return true
endfunction

function FHU_Instances takes integer index returns boolean
    local integer ordinal=0
    local integer key
    local unit hero=FHU_Unit[index]
    if hero==null then
        return true
    endif
    loop
        exitwhen ordinal>=FHU_Count[index]
        set key=index*40+ordinal
        if BlzGetUnitAbility(hero,FHU_AbilityId[key])!=FHU_Ability[key] then
            set hero=null
            return false
        endif
        set ordinal=ordinal+1
    endloop
    set hero=null
    return true
endfunction

function FHU_Core takes integer pid,boolean totals returns boolean
    local integer slot=0
    local integer index
    local integer ordinal
    local integer key
    local unit hero
    if not FHU_Context(pid) then
        return false
    endif
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set hero=FHU_Unit[index]
        if hero!=null and FHU_Alias[index]==slot then
            if not FHU_Instances(index) or GetHeroXP(hero)!=FHU_XP[index] or GetHeroLevel(hero)!=FHU_Level[index] or GetHeroSkillPoints(hero)!=FHU_Points[index] or GetHeroStr(hero,false)!=FHU_Str[index] or GetHeroAgi(hero,false)!=FHU_Agi[index] or GetHeroInt(hero,false)!=FHU_Int[index] then
                set hero=null
                return false
            endif
            if totals and (GetHeroStr(hero,true)!=FHU_TotalStr[index] or GetHeroAgi(hero,true)!=FHU_TotalAgi[index] or GetHeroInt(hero,true)!=FHU_TotalInt[index]) then
                set hero=null
                return false
            endif
            set ordinal=0
            loop
                exitwhen ordinal>=FHU_Count[index]
                set key=index*40+ordinal
                if GetUnitAbilityLevel(hero,FHU_AbilityId[key])!=FHU_Rank[key] then
                    set hero=null
                    return false
                endif
                set ordinal=ordinal+1
            endloop
            // Membership comparison is by ID/instance, independent of native order.
            set ordinal=0
            loop
                exitwhen ordinal>=40 or BlzGetUnitAbilityByIndex(hero,ordinal)==null
                set ordinal=ordinal+1
            endloop
            if ordinal!=FHU_Count[index] or BlzGetUnitAbilityByIndex(hero,ordinal)!=null then
                set hero=null
                return false
            endif
        endif
        set slot=slot+1
    endloop
    set hero=null
    return true
endfunction

function FHU_Clear takes integer pid returns nothing
    local integer slot=0
    local integer index
    local integer ordinal
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set ordinal=0
        loop
            exitwhen ordinal>=40
            set FHU_Ability[index*40+ordinal]=null
            set FHU_AbilityId[index*40+ordinal]=0
            set FHU_Rank[index*40+ordinal]=0
            set ordinal=ordinal+1
        endloop
        set FHU_Unit[index]=null
        set FHU_Owner[index]=null
        set FHU_Count[index]=0
        set slot=slot+1
    endloop
    set FHU_Table[pid]=null
    set FHU_FreeCached[pid]=null
    set FHU_State[pid]=0
    set FSN_HeroBlocked[pid]=false
    set FSJ_HeroPending[pid]=false
endfunction

function FHU_CaptureUnit takes integer pid,integer slot returns boolean
    local integer index=pid*25+slot
    local integer previous=0
    local integer ordinal=0
    local integer check
    local integer key
    local integer raw
    local ability current
    local unit hero=FHU_Live(pid,slot)
    set FHU_Unit[index]=hero
    set FHU_Alias[index]=slot
    if hero==null then
        return true
    endif
    if not IsUnitType(hero,UNIT_TYPE_HERO) or GetUnitTypeId(hero)==0 then
        set hero=null
        return false
    endif
    // Cached heroes may be held by the neutral player after a job change.
    if GetOwningPlayer(hero)!=Player(pid) and GetOwningPlayer(hero)!=Player(PLAYER_NEUTRAL_PASSIVE) then
        set hero=null
        return false
    endif
    set FHU_Raw[index]=GetUnitTypeId(hero)
    set FHU_Owner[index]=GetOwningPlayer(hero)
    if (slot<22 and FHU_Raw[index]!=FPG_JobRaw(slot)) or (slot==22 and FHU_Raw[index]!='H02L') or (slot==23 and FHU_Raw[index]!='H01D') then
        set hero=null
        return false
    endif
    if slot==24 and FHU_Raw[index]!='H02L' then
        set check=0
        loop
            exitwhen check>=22 or FHU_Raw[index]==FPG_JobRaw(check)
            set check=check+1
        endloop
        if check>=22 then
            set hero=null
            return false
        endif
    endif
    loop
        exitwhen previous>=slot
        if FHU_Unit[pid*25+previous]==hero then
            set FHU_Alias[index]=FHU_Alias[pid*25+previous]
            set hero=null
            return true
        endif
        set previous=previous+1
    endloop
    set FHU_XP[index]=GetHeroXP(hero)
    set FHU_Level[index]=GetHeroLevel(hero)
    set FHU_Points[index]=GetHeroSkillPoints(hero)
    set FHU_Str[index]=GetHeroStr(hero,false)
    set FHU_Agi[index]=GetHeroAgi(hero,false)
    set FHU_Int[index]=GetHeroInt(hero,false)
    set FHU_TotalStr[index]=GetHeroStr(hero,true)
    set FHU_TotalAgi[index]=GetHeroAgi(hero,true)
    set FHU_TotalInt[index]=GetHeroInt(hero,true)
    if FHU_XP[index]<0 or FHU_Level[index]<1 or FHU_Points[index]<0 then
        set hero=null
        return false
    endif
    loop
        exitwhen ordinal>=40
        set current=BlzGetUnitAbilityByIndex(hero,ordinal)
        exitwhen current==null
        set raw=BlzGetAbilityId(current)
        if raw==0 or GetUnitAbilityLevel(hero,raw)<=0 or BlzGetUnitAbility(hero,raw)!=current then
            set current=null
            set hero=null
            return false
        endif
        set check=0
        loop
            exitwhen check>=ordinal
            if FHU_AbilityId[index*40+check]==raw then
                set current=null
                set hero=null
                return false
            endif
            set check=check+1
        endloop
        set key=index*40+ordinal
        set FHU_AbilityId[key]=raw
        set FHU_Ability[key]=current
        set FHU_Rank[key]=GetUnitAbilityLevel(hero,raw)
        set ordinal=ordinal+1
    endloop
    set FHU_Count[index]=ordinal
    set current=BlzGetUnitAbilityByIndex(hero,ordinal)
    set hero=null
    if current!=null then
        set current=null
        return false
    endif
    return true
endfunction

function FHU_Begin takes integer pid returns boolean
    local integer slot=0
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FHU_Busy[pid] or FHU_State[pid]!=0 or FPG_Busy[pid] or FPG_State[pid]!=1 or FQR_Busy[pid] or FQR_State[pid]!=1 or FSN_Busy[pid] or not FPG_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    if LoadUnitHandle(udg_JobHeroHash,'H02L',pid)!=null and LoadUnitHandle(udg_JobHeroHash,'H02L',pid)!=udg_FreelancerHero[pid+1] then
        return false
    endif
    set FHU_Busy[pid]=true
    set FHU_Table[pid]=udg_JobHeroHash
    set FHU_FreeCached[pid]=LoadUnitHandle(udg_JobHeroHash,'H02L',pid)
    loop
        exitwhen slot>=25
        if not FHU_CaptureUnit(pid,slot) then
            call FHU_Clear(pid)
            set FHU_Busy[pid]=false
            return false
        endif
        set slot=slot+1
    endloop
    if not FHU_Core(pid,true) or not FPG_Verify(pid) or not FSJ_Verify(pid) then
        call FHU_Clear(pid)
        set FHU_Busy[pid]=false
        return false
    endif
    set FHU_State[pid]=1
    set FSJ_HeroPending[pid]=true
    set FHU_Busy[pid]=false
    return true
endfunction

function FHU_RestoreUnit takes integer index returns boolean
    local integer ordinal=0
    local integer removed=0
    local integer raw
    local integer previous
    local integer key
    local integer points
    local ability current
    local unit hero=FHU_Unit[index]
    if not FHU_Instances(index) then
        set hero=null
        return false
    endif
    // Remove additions only. Missing/replaced original instances refuse recovery.
    loop
        exitwhen ordinal>=40
        set current=BlzGetUnitAbilityByIndex(hero,ordinal)
        exitwhen current==null
        set raw=BlzGetAbilityId(current)
        if raw==0 then
            set current=null
            set hero=null
            return false
        endif
        set previous=0
        loop
            exitwhen previous>=FHU_Count[index] or FHU_AbilityId[index*40+previous]==raw
            set previous=previous+1
        endloop
        if previous>=FHU_Count[index] then
            if removed>=40 then
                set current=null
                set hero=null
                return false
            endif
            set removed=removed+1
            call UnitRemoveAbility(hero,raw)
            if BlzGetUnitAbility(hero,raw)!=null then
                set current=null
                set hero=null
                return false
            endif
            // Successful deletion compacts enumeration; inspect this ordinal again.
        else
            set ordinal=ordinal+1
        endif
    endloop
    set current=BlzGetUnitAbilityByIndex(hero,ordinal)
    if current!=null then
        set current=null
        set hero=null
        return false
    endif
    // Lower levels explicitly; an XP setter alone need not undo gained levels.
    if GetHeroLevel(hero)>FHU_Level[index] then
        call UnitStripHeroLevel(hero,GetHeroLevel(hero)-FHU_Level[index])
        if GetHeroLevel(hero)!=FHU_Level[index] then
            set hero=null
            return false
        endif
    endif
    call SetHeroXP(hero,FHU_XP[index],false)
    if GetHeroXP(hero)!=FHU_XP[index] or GetHeroLevel(hero)!=FHU_Level[index] then
        set hero=null
        return false
    endif
    set ordinal=0
    loop
        exitwhen ordinal>=FHU_Count[index]
        set key=index*40+ordinal
        if BlzGetUnitAbility(hero,FHU_AbilityId[key])!=FHU_Ability[key] then
            set hero=null
            return false
        endif
        call SetUnitAbilityLevel(hero,FHU_AbilityId[key],FHU_Rank[key])
        set ordinal=ordinal+1
    endloop
    call SetHeroStr(hero,FHU_Str[index],true)
    call SetHeroAgi(hero,FHU_Agi[index],true)
    call SetHeroInt(hero,FHU_Int[index],true)
    set points=GetHeroSkillPoints(hero)
    if points<0 then
        set hero=null
        return false
    endif
    call UnitModifySkillPoints(hero,FHU_Points[index]-points)
    set hero=null
    return true
endfunction

function FHU_Verify takes integer pid,boolean totals returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FHU_Busy[pid] or FHU_State[pid]==0 then
        return false
    endif
    return FHU_Core(pid,totals)
endfunction

function FHU_Recover takes integer pid returns boolean
    local integer slot=0
    local integer index
    local boolean success=true
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FHU_Busy[pid] or FHU_State[pid]==0 or FPG_Busy[pid] or FQR_Busy[pid] or FSN_Busy[pid] or FSJ_Busy[pid] then
        return false
    endif
    set FHU_State[pid]=3
    set FSN_HeroBlocked[pid]=true
    if not FHU_Context(pid) then
        return false
    endif
    // Check every original instance before the first unit setter.
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        if FHU_Unit[index]!=null and FHU_Alias[index]==slot and not FHU_Instances(index) then
            return false
        endif
        set slot=slot+1
    endloop
    set FHU_Busy[pid]=true
    set FPG_Busy[pid]=true
    set FSN_Busy[pid]=true
    set FSJ_Busy[pid]=true
    set slot=0
    loop
        exitwhen slot>=25 or not success
        set index=pid*25+slot
        if FHU_Unit[index]!=null and FHU_Alias[index]==slot then
            set success=FHU_RestoreUnit(index)
        endif
        set slot=slot+1
    endloop
    set FSJ_Busy[pid]=false
    set FSN_Busy[pid]=false
    set FPG_Busy[pid]=false
    set FHU_Busy[pid]=false
    if not success or not FHU_Core(pid,false) then
        return false
    endif
    set FHU_State[pid]=2
    return true
endfunction

function FHU_Release takes integer pid returns boolean
    if not FHU_Verify(pid,true) then
        return false
    endif
    if FHU_State[pid]!=2 or FPG_Busy[pid] or FQR_Busy[pid] or FSN_Busy[pid] or (FPG_State[pid]!=0 and FPG_State[pid]!=2) or (FQR_State[pid]!=0 and FQR_State[pid]!=5) or not FSJ_Verify(pid) then
        return false
    endif
    if FPG_State[pid]==2 and not FPG_Verify(pid) then
        return false
    endif
    call FHU_Clear(pid)
    return true
endfunction
endlibrary
