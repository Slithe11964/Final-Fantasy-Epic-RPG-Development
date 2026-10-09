library TForsakenSaveGayaPolicy requires TForsakenSavePreparedHeroes
// Owned fresh Gaya only. Player research/availability are separate controller plans.
// Saved zero support ranks mean unpurchased, retaining native locked rank-one menus.

function FGP_Plan takes integer pid,integer stage,integer savedLevel,boolean mastered,integer breakStun,integer manaTransfer,integer megaHeal,boolean taru,boolean suku,boolean raku,integer xp,integer points,integer strength,integer agility,integer intelligence returns boolean
    local integer key
    local integer level=savedLevel
    local integer power=1
    local unit candidate
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FHP_State[pid]!=1 or stage<0 or stage>=FHP_Count[pid] or savedLevel<0 or savedLevel>100 or breakStun<0 or breakStun>3 or manaTransfer<0 or manaTransfer>3 or megaHeal<0 or megaHeal>3 or xp<0 or points<0 or strength<0 or agility<0 or intelligence<0 or not FHP_Context(pid) then
        return false
    endif
    if mastered and (savedLevel!=99 or breakStun!=3 or manaTransfer!=3 or megaHeal!=3 or not taru or not suku or not raku) then
        return false
    endif
    set key=pid*24+stage
    if FSU_Role[key]!=23 or FHP_Planned[key] or FHP_Abilities[key]!=0 then
        return false
    endif
    set candidate=FHP_Unit[key]
    // Freeze the reviewed fresh-object prerequisites before recording any plan.
    if BlzGetUnitAbility(candidate,'A0B4')==null or GetUnitAbilityLevel(candidate,'A0B4')!=1 or BlzGetUnitAbility(candidate,'A02K')==null or GetUnitAbilityLevel(candidate,'A02K')!=1 or BlzGetUnitAbility(candidate,'A02L')==null or GetUnitAbilityLevel(candidate,'A02L')!=1 or BlzGetUnitAbility(candidate,'A10F')==null or GetUnitAbilityLevel(candidate,'A10F')!=1 or BlzGetUnitAbility(candidate,'A058')!=null or BlzGetUnitAbility(candidate,'S004')!=null or BlzGetUnitAbility(candidate,'A07E')!=null then
        set candidate=null
        return false
    endif
    set candidate=null
    if level==0 then
        set level=1
    endif
    if breakStun==0 then
        set breakStun=1
    endif
    if manaTransfer==0 then
        set manaTransfer=1
    endif
    if megaHeal==0 then
        set megaHeal=1
    endif
    if taru then
        set power=power+1
    endif
    if suku then
        set power=power+2
    endif
    if raku then
        set power=power+4
    endif
    if not FHP_PlanCore(pid,stage,xp,level,points,strength,agility,intelligence) then
        return false
    endif
    if not FHP_PlanAbility(pid,stage,'A0B4',breakStun) or not FHP_PlanAbility(pid,stage,'A02K',manaTransfer) or not FHP_PlanAbility(pid,stage,'A02L',megaHeal) or not FHP_PlanAbility(pid,stage,'A10F',power) then
        return false
    endif
    if taru and not FHP_PlanAbility(pid,stage,'A058',1) then
        return false
    endif
    if suku and not FHP_PlanAbility(pid,stage,'S004',1) then
        return false
    endif
    if raku and not FHP_PlanAbility(pid,stage,'A07E',1) then
        return false
    endif
    return true
endfunction
endlibrary
