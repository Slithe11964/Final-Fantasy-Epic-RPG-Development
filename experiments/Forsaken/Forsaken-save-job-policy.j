library TForsakenSaveJobPolicy requires TForsakenSavePreparedHeroes
// Internal normal-job bridge; caller supplies reviewed native XP/grown base stats.
// No guessed growth, profile mutation, original writes or gameplay load route.

function FJP_PlanNormal takes integer pid,integer stage,integer identity,integer savedLevel,integer xp,integer strength,integer agility,integer intelligence returns boolean
    local integer key
    local integer level=savedLevel
    local integer rank=1
    local integer bonus=0
    local integer ordinal=0
    local integer skill=0
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHP_State[pid]!=1 or stage<0 or stage>=FHP_Count[pid] or identity<1 or identity>22 or savedLevel<0 or savedLevel>100 or xp<0 or strength<0 or agility<0 or intelligence<0 or not FHP_Context(pid) then
        return false
    endif
    set key=pid*24+stage
    if FSU_Role[key]!=identity-1 or FHP_Planned[key] or FHP_Abilities[key]>=40 then
        return false
    endif
    // Preflight every later plan call before recording either core or marker.
    loop
        exitwhen ordinal>=FHP_Abilities[key]
        if FHP_Id[key*40+ordinal]=='A02F' then // Mastery
            return false
        endif
        set ordinal=ordinal+1
    endloop
    loop
        exitwhen skill>=5
        if FHP_Skill[key*5+skill]=='A02F' then
            return false
        endif
        set skill=skill+1
    endloop
    if savedLevel==100 then
        set level=99
        set rank=4
        set bonus=100
    elseif savedLevel==99 then
        set rank=3
        set bonus=50
    elseif savedLevel>=50 then
        set rank=2
        set bonus=20
    elseif savedLevel==0 then
        set level=1
    endif
    if strength>2147483647-bonus or agility>2147483647-bonus or intelligence>2147483647-bonus then
        return false
    endif
    if not FHP_PlanCore(pid,stage,xp,level,0,strength+bonus,agility+bonus,intelligence+bonus) then
        return false
    endif
    // Both calls only record plans; native learning/readback remains in FHP_Apply.
    return FHP_PlanAbility(pid,stage,'A02F',rank)
endfunction
endlibrary
