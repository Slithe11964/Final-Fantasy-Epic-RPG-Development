library TForsakenSaveFreelancerPolicy requires TForsakenSavePreparedHeroes
// Reviewed H02L policy only; XP/points/derived attributes supplied by controller.
// No borrowed choices are copied; player session reset is a separate target.

function FFP_Plan takes integer pid,integer stage,integer savedLevel,integer xp,integer points,integer strength,integer agility,integer intelligence returns boolean
    local integer key
    local integer level=savedLevel
    local integer rank=1
    local integer skill=1
    local unit candidate
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHP_State[pid]!=1 or stage<0 or stage>=FHP_Count[pid] or savedLevel<0 or savedLevel>100 or xp<0 or points<0 or strength<0 or agility<0 or intelligence<0 or not FHP_Context(pid) then
        return false
    endif
    set key=pid*24+stage
    if FSU_Role[key]!=22 or FHP_Planned[key] or FHP_Abilities[key]!=0 then
        return false
    endif
    set candidate=FHP_Unit[key]
    if GetUnitTypeId(candidate)!='H02L' or BlzGetUnitAbility(candidate,'A15I')==null or GetUnitAbilityLevel(candidate,'A15I')!=1 then
        set candidate=null
        return false
    endif
    loop
        exitwhen skill>110
        if udg_JobSkill[skill]==0 or BlzGetUnitAbility(candidate,udg_JobSkill[skill])!=null then
            set candidate=null
            return false
        endif
        set skill=skill+1
    endloop
    set candidate=null
    if savedLevel==100 then
        set level=99
        set rank=4
    elseif savedLevel==99 then
        set rank=3
    elseif savedLevel>=50 then
        set rank=2
    elseif savedLevel==0 then
        set level=1
    endif
    if not FHP_PlanCore(pid,stage,xp,level,points,strength,agility,intelligence) then
        return false
    endif
    return FHP_PlanAbility(pid,stage,'A02F',rank)
endfunction
endlibrary
