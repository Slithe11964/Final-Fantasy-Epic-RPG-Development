library TForsakenSavePreparedHeroes requires TForsakenSaveOwnership
// Internal detached target plan only; no persistence translation or activation.
// Mutate owned contained replacements only; preserve original heroes.
globals
    // 0 idle, 1 planning, 2 prepared, 3 blocked.
    integer array FHP_State
    integer array FHP_Count
    unit array FHP_Unit
    integer array FHP_Raw
    player array FHP_Owner
    boolean array FHP_Planned
    integer array FHP_XP
    integer array FHP_Level
    integer array FHP_Points
    integer array FHP_Str
    integer array FHP_Agi
    integer array FHP_Int
    integer array FHP_Skill
    integer array FHP_Abilities
    integer array FHP_Id
    integer array FHP_Rank
endglobals

function FHP_Context takes integer pid returns boolean
    local integer stage=0
    local integer key
    local integer skill
    local unit candidate
    local player owner
    if FSU_State[pid]!=1 or FSU_Count[pid]!=FHP_Count[pid] or not FSO_Matches(pid,Player(pid)) then
        return false
    endif
    loop
        exitwhen stage>=FHP_Count[pid]
        set key=pid*24+stage
        set candidate=FHP_Unit[key]
        set owner=Player(PLAYER_NEUTRAL_PASSIVE)
        if candidate==FSO_Unit[pid*2] or candidate==FSO_Unit[pid*2+1] then
            set owner=Player(pid)
        endif
        if candidate==null or candidate!=FSU_Unit[key] or GetUnitTypeId(candidate)!=FHP_Raw[key] or FHP_Raw[key]!=FSU_Raw[key] or GetOwningPlayer(candidate)!=FHP_Owner[key] or GetOwningPlayer(candidate)!=owner or not IsUnitType(candidate,UNIT_TYPE_HERO) or IsUnitType(candidate,UNIT_TYPE_DEAD) or not (GetWidgetLife(candidate)>0.405) or not IsUnitHidden(candidate) or not IsUnitPaused(candidate) or not BlzIsUnitInvulnerable(candidate) or not FSU_Empty(candidate) then
            set candidate=null
            set owner=null
            return false
        endif
        if FSU_Role[key]<22 then
            set skill=0
            loop
                exitwhen skill>=5
                if FHP_Skill[key*5+skill]==0 or FHP_Skill[key*5+skill]!=udg_JobSkill[FSU_Role[key]*5+skill+1] then
                    set candidate=null
                    set owner=null
                    return false
                endif
                set skill=skill+1
            endloop
        endif
        set stage=stage+1
    endloop
    set candidate=null
    set owner=null
    return true
endfunction

function FHP_Begin takes integer pid returns boolean
    local integer stage=0
    local integer key
    local integer skill
    local integer prior
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHP_State[pid]!=0 or FSO_State[pid]!=2 or FSU_Count[pid]<2 or FSU_Count[pid]>24 or FSC_Writing[pid] or FSN_State[pid]!=0 or FSN_Count[pid]!=0 or FSN_AuxCount[pid]!=0 or FSN_BodyBlocked[pid] or FSN_HeroBlocked[pid] or FSN_ProgressionBlocked[pid] or FSN_SessionBlocked[pid] or FSN_RecoveryBlocked[pid] or not FSO_Verify(pid) then
        return false
    endif
    set FHP_Count[pid]=FSU_Count[pid]
    loop
        exitwhen stage>=FHP_Count[pid]
        set key=pid*24+stage
        set FHP_Unit[key]=FSU_Unit[key]
        set FHP_Raw[key]=FSU_Raw[key]
        set FHP_Owner[key]=GetOwningPlayer(FSU_Unit[key])
        set FHP_Planned[key]=false
        set FHP_Abilities[key]=0
        if FSU_Role[key]<22 then
            set skill=0
            loop
                exitwhen skill>=5
                set FHP_Skill[key*5+skill]=udg_JobSkill[FSU_Role[key]*5+skill+1]
                // Duplicate policy skills make ranks/point cost ambiguous.
                set prior=0
                loop
                    exitwhen prior>=skill
                    if FHP_Skill[key*5+prior]==FHP_Skill[key*5+skill] then
                        set FHP_Skill[key*5+skill]=0
                    endif
                    set prior=prior+1
                endloop
                set skill=skill+1
            endloop
        endif
        set stage=stage+1
    endloop
    if not FHP_Context(pid) then
        set stage=0
        loop
            exitwhen stage>=FHP_Count[pid]
            set FHP_Unit[pid*24+stage]=null
            set FHP_Owner[pid*24+stage]=null
            set stage=stage+1
        endloop
        set FHP_Count[pid]=0
        return false
    endif
    set FHP_State[pid]=1
    set FSN_PreparedBlocked[pid]=true
    set FSC_PreparedBlocked[pid]=true
    set FSJ_PreparedPending[pid]=true
    return true
endfunction

function FHP_PlanCore takes integer pid,integer stage,integer xp,integer level,integer points,integer strength,integer agility,integer intelligence returns boolean
    local integer key=pid*24+stage
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHP_State[pid]!=1 or stage<0 or stage>=FHP_Count[pid] or FHP_Planned[key] or xp<0 or level<1 or level>100 or points<0 or strength<0 or agility<0 or intelligence<0 or not FHP_Context(pid) then
        return false
    endif
    set FHP_XP[key]=xp
    set FHP_Level[key]=level
    set FHP_Points[key]=points
    if FSU_Role[key]<22 then
        if level<50 then
            set FHP_Points[key]=level
        else
            set FHP_Points[key]=level-50
        endif
    endif
    set FHP_Str[key]=strength
    set FHP_Agi[key]=agility
    set FHP_Int[key]=intelligence
    set FHP_Planned[key]=true
    return true
endfunction

function FHP_PlanAbility takes integer pid,integer stage,integer raw,integer rank returns boolean
    local integer key=pid*24+stage
    local integer ordinal=0
    local integer skill=0
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHP_State[pid]!=1 or stage<0 or stage>=FHP_Count[pid] or not FHP_Planned[key] or FHP_Abilities[key]>=40 or raw==0 or rank<1 or rank>255 or not FHP_Context(pid) then
        return false
    endif
    if FSU_Role[key]<22 then
        loop
            exitwhen skill>=5
            if raw==FHP_Skill[key*5+skill] then
                return false
            endif
            set skill=skill+1
        endloop
    endif
    loop
        exitwhen ordinal>=FHP_Abilities[key]
        if FHP_Id[key*40+ordinal]==raw then
            return false
        endif
        set ordinal=ordinal+1
    endloop
    set FHP_Id[key*40+ordinal]=raw
    set FHP_Rank[key*40+ordinal]=rank
    set FHP_Abilities[key]=ordinal+1
    return true
endfunction

function FHP_SkillsMatch takes integer key returns boolean
    local integer skill=0
    local integer target
    if FSU_Role[key]>=22 then
        return true
    endif
    loop
        exitwhen skill>=5
        set target=0
        if FHP_Level[key]>=50 then
            set target=11
            if skill==4 then
                set target=6
            endif
        endif
        if GetUnitAbilityLevel(FHP_Unit[key],FHP_Skill[key*5+skill])!=target then
            return false
        endif
        set skill=skill+1
    endloop
    return true
endfunction

function FHP_PrepareSkills takes integer key returns boolean
    local integer skill=0
    local integer target
    local integer current
    local integer needed=0
    local integer points
    local unit candidate=FHP_Unit[key]
    if FSU_Role[key]>=22 or FHP_Level[key]<50 then
        set candidate=null
        return FHP_SkillsMatch(key)
    endif
    loop
        exitwhen skill>=5
        set target=11
        if skill==4 then
            set target=6
        endif
        set current=GetUnitAbilityLevel(candidate,FHP_Skill[key*5+skill])
        if current<0 or current>target then
            set candidate=null
            return false
        endif
        set needed=needed+target-current
        set skill=skill+1
    endloop
    set points=GetHeroSkillPoints(candidate)
    if points<0 then
        set candidate=null
        return false
    endif
    if points<needed then
        call UnitModifySkillPoints(candidate,needed-points)
        if GetHeroSkillPoints(candidate)<needed then
            set candidate=null
            return false
        endif
    endif
    set skill=0
    loop
        exitwhen skill>=5
        set target=11
        if skill==4 then
            set target=6
        endif
        loop
            set current=GetUnitAbilityLevel(candidate,FHP_Skill[key*5+skill])
            exitwhen current>=target
            call SelectHeroSkill(candidate,FHP_Skill[key*5+skill])
            if GetUnitAbilityLevel(candidate,FHP_Skill[key*5+skill])!=current+1 then
                set candidate=null
                return false
            endif
        endloop
        set skill=skill+1
    endloop
    set candidate=null
    return FHP_SkillsMatch(key)
endfunction

function FHP_CoreMatches takes integer pid returns boolean
    local integer stage=0
    local integer key
    local integer ordinal
    local unit candidate
    loop
        exitwhen stage>=FHP_Count[pid]
        set key=pid*24+stage
        set candidate=FHP_Unit[key]
        if not FHP_Planned[key] or not FHP_SkillsMatch(key) or GetHeroXP(candidate)!=FHP_XP[key] or GetHeroLevel(candidate)!=FHP_Level[key] or GetHeroSkillPoints(candidate)!=FHP_Points[key] or GetHeroStr(candidate,false)!=FHP_Str[key] or GetHeroAgi(candidate,false)!=FHP_Agi[key] or GetHeroInt(candidate,false)!=FHP_Int[key] then
            set candidate=null
            return false
        endif
        set ordinal=0
        loop
            exitwhen ordinal>=FHP_Abilities[key]
            if BlzGetUnitAbility(candidate,FHP_Id[key*40+ordinal])==null or GetUnitAbilityLevel(candidate,FHP_Id[key*40+ordinal])!=FHP_Rank[key*40+ordinal] then
                set candidate=null
                return false
            endif
            set ordinal=ordinal+1
        endloop
        set stage=stage+1
    endloop
    set candidate=null
    return true
endfunction

function FHP_Matches takes integer pid returns boolean
    return FHP_Context(pid) and FHP_CoreMatches(pid)
endfunction

function FHP_Apply takes integer pid returns boolean
    local integer stage=0
    local integer key
    local integer ordinal
    local integer raw
    local integer points
    local unit candidate
    local boolean ok=true
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or (FHP_State[pid]!=1 and FHP_State[pid]!=3) or FSC_Writing[pid] or FSN_BodyBlocked[pid] or not FHP_Context(pid) then
        return false
    endif
    loop
        exitwhen stage>=FHP_Count[pid]
        if not FHP_Planned[pid*24+stage] then
            return false
        endif
        // Fresh below-master jobs must retain their native unlearned skill menu.
        if FHP_Level[pid*24+stage]<50 and not FHP_SkillsMatch(pid*24+stage) then
            return false
        endif
        set stage=stage+1
    endloop
    set FHP_State[pid]=3
    call FSR_Lock(pid,true)
    set stage=0
    loop
        exitwhen stage>=FHP_Count[pid] or not ok
        set key=pid*24+stage
        set candidate=FHP_Unit[key]
        if GetHeroLevel(candidate)>FHP_Level[key] then
            call UnitStripHeroLevel(candidate,GetHeroLevel(candidate)-FHP_Level[key])
            if GetHeroLevel(candidate)!=FHP_Level[key] then
                set ok=false
            endif
        endif
        if ok then
            call SetHeroXP(candidate,FHP_XP[key],false)
            if GetHeroXP(candidate)!=FHP_XP[key] or GetHeroLevel(candidate)!=FHP_Level[key] then
                set ok=false
            endif
        endif
        if ok then
            set ok=FHP_PrepareSkills(key)
        endif
        if ok then
            set ordinal=0
            loop
                exitwhen ordinal>=FHP_Abilities[key] or not ok
                set raw=FHP_Id[key*40+ordinal]
                if BlzGetUnitAbility(candidate,raw)==null then
                    call UnitAddAbility(candidate,raw)
                endif
                if BlzGetUnitAbility(candidate,raw)==null then
                    set ok=false
                else
                    call SetUnitAbilityLevel(candidate,raw,FHP_Rank[key*40+ordinal])
                    if GetUnitAbilityLevel(candidate,raw)!=FHP_Rank[key*40+ordinal] then
                        set ok=false
                    endif
                endif
                set ordinal=ordinal+1
            endloop
            call SetHeroStr(candidate,FHP_Str[key],true)
            call SetHeroAgi(candidate,FHP_Agi[key],true)
            call SetHeroInt(candidate,FHP_Int[key],true)
            set points=GetHeroSkillPoints(candidate)
            if points<0 then
                set ok=false
            else
                call UnitModifySkillPoints(candidate,FHP_Points[key]-points)
            endif
        endif
        set stage=stage+1
    endloop
    set candidate=null
    call FSR_Lock(pid,false)
    if not ok or not FHP_Matches(pid) then
        return false
    endif
    set FHP_State[pid]=2
    return true
endfunction

function FHP_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHP_State[pid]!=2 then
        return false
    endif
    return FHP_Matches(pid)
endfunction

function FHP_Discard takes integer pid returns boolean
    local integer stage=0
    local integer key
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FSJ_ActivationPending[pid] or FHP_State[pid]==0 or FSC_Writing[pid] then
        return false
    endif
    // Owned replacements are disposed by the existing ownership/reference/unit path.
    // Clearing a target plan never approves or publishes its partially prepared units.
    loop
        exitwhen stage>=FHP_Count[pid]
        set key=pid*24+stage
        set FHP_Unit[key]=null
        set FHP_Owner[key]=null
        set FHP_Planned[key]=false
        set FHP_Abilities[key]=0
        set stage=stage+1
    endloop
    set FHP_Count[pid]=0
    set FHP_State[pid]=0
    set FSN_PreparedBlocked[pid]=false
    set FSC_PreparedBlocked[pid]=false
    set FSJ_PreparedPending[pid]=false
    return true
endfunction
endlibrary
