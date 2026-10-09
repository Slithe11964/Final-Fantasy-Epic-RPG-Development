library TForsakenSavePlayerTarget requires TForsakenSavePreparedHeroes
// Narrow reversible player target: Gaya purchases and six per-game skill choices.
// Caller excludes gameplay/research hooks. Ability availability has no native getter.
globals
    // 0 idle, 1 captured, 2 applied, 3 blocked, 4 recovered.
    integer array FPT_State
    integer array FPT_OldTech
    integer array FPT_TargetTech
    integer array FPT_OldSkill
endglobals

function FPT_Skill takes integer pid,integer slot returns integer
    if slot==0 then
        return udg_AbilitySlot1[pid+1]
    elseif slot==1 then
        return udg_AbilitySlot2[pid+1]
    elseif slot==2 then
        return udg_AbilitySlot3[pid+1]
    elseif slot==3 then
        return udg_AbilitySlot4[pid+1]
    elseif slot==4 then
        return udg_MainSkillSlot[pid+1]
    endif
    return udg_SubSkillSlot[pid+1]
endfunction

function FPT_SetSkill takes integer pid,integer slot,integer value returns nothing
    if slot==0 then
        set udg_AbilitySlot1[pid+1]=value
    elseif slot==1 then
        set udg_AbilitySlot2[pid+1]=value
    elseif slot==2 then
        set udg_AbilitySlot3[pid+1]=value
    elseif slot==3 then
        set udg_AbilitySlot4[pid+1]=value
    elseif slot==4 then
        set udg_MainSkillSlot[pid+1]=value
    else
        set udg_SubSkillSlot[pid+1]=value
    endif
endfunction

function FPT_Context takes integer pid returns boolean
    return FHP_State[pid]==2 and FPG_State[pid]==1 and FSS_State[pid]==1 and not FSJ_ActivationPending[pid] and FSO_State[pid]==2 and FSO_Matches(pid,Player(pid))
endfunction

function FPT_Matches takes integer pid,boolean target returns boolean
    local integer slot=0
    local integer value
    if not FPT_Context(pid) then
        return false
    endif
    loop
        exitwhen slot>=3
        set value=FPT_OldTech[pid*3+slot]
        if target then
            set value=FPT_TargetTech[pid*3+slot]
        endif
        if GetPlayerTechCount(Player(pid),FPG_TechRaw(15+slot),true)!=value then
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=6
        set value=FPT_OldSkill[pid*6+slot]
        if target then
            set value=0
        endif
        if FPT_Skill(pid,slot)!=value then
            return false
        endif
        set slot=slot+1
    endloop
    return true
endfunction

function FPT_Begin takes integer pid,integer breakStun,integer manaTransfer,integer megaHeal returns boolean
    local integer slot=0
    local integer value
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FPT_State[pid]!=0 or FSC_Writing[pid] or not FPT_Context(pid) or not FHP_Verify(pid) or breakStun<0 or breakStun>3 or manaTransfer<0 or manaTransfer>3 or megaHeal<0 or megaHeal>3 then
        return false
    endif
    if GetUnitAbilityLevel(FSO_Unit[pid*2+1],'A0B4')!=IMaxBJ(1,breakStun) or GetUnitAbilityLevel(FSO_Unit[pid*2+1],'A02K')!=IMaxBJ(1,manaTransfer) or GetUnitAbilityLevel(FSO_Unit[pid*2+1],'A02L')!=IMaxBJ(1,megaHeal) then
        return false
    endif
    loop
        exitwhen slot>=3
        set value=GetPlayerTechCount(Player(pid),FPG_TechRaw(15+slot),true)
        if value<0 or value!=FPG_Tech[pid*18+15+slot] then
            return false
        endif
        set FPT_OldTech[pid*3+slot]=value
        set FPT_TargetTech[pid*3+slot]=0
        set slot=slot+1
    endloop
    if breakStun>0 then
        set FPT_TargetTech[pid*3]=1
    endif
    if manaTransfer>0 then
        set FPT_TargetTech[pid*3+1]=1
    endif
    if megaHeal>0 then
        set FPT_TargetTech[pid*3+2]=1
    endif
    set slot=0
    loop
        exitwhen slot>=6
        set value=FPT_Skill(pid,slot)
        if value!=FSS_Skill[pid*6+slot] then
            return false
        endif
        set FPT_OldSkill[pid*6+slot]=value
        set slot=slot+1
    endloop
    if not FPT_Matches(pid,false) then
        return false
    endif
    set FPT_State[pid]=1
    set FSJ_PlayerPending[pid]=true
    return true
endfunction

function FPT_Write takes integer pid,boolean target returns boolean
    local integer slot=0
    local integer value
    set FPT_State[pid]=3
    call FSR_Lock(pid,true)
    loop
        exitwhen slot>=3
        set value=FPT_OldTech[pid*3+slot]
        if target then
            set value=FPT_TargetTech[pid*3+slot]
        endif
        call SetPlayerTechResearched(Player(pid),FPG_TechRaw(15+slot),value)
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=6
        set value=FPT_OldSkill[pid*6+slot]
        if target then
            set value=0
        endif
        call FPT_SetSkill(pid,slot,value)
        set slot=slot+1
    endloop
    call FSR_Lock(pid,false)
    return FPT_Matches(pid,target)
endfunction

function FPT_Apply takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FPT_State[pid]!=1 or FSC_Writing[pid] or not FPT_Matches(pid,false) or not FHP_Verify(pid) then
        return false
    endif
    if not FPT_Write(pid,true) or not FHP_Verify(pid) then
        return false
    endif
    set FPT_State[pid]=2
    return true
endfunction

function FPT_Recover takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FPT_State[pid]==0 or FSC_Writing[pid] or not FPT_Context(pid) then
        return false
    endif
    if not FPT_Write(pid,false) then
        return false
    endif
    set FPT_State[pid]=4
    return true
endfunction

function FPT_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    return FSU_Idle(pid) and not FSR_Busy[pid] and FPT_State[pid]==2 and FPT_Matches(pid,true) and FHP_Verify(pid)
endfunction

function FPT_Release takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if not FSU_Idle(pid) or FSR_Busy[pid] or FPT_State[pid]!=4 or not FPT_Matches(pid,false) then
        return false
    endif
    set FPT_State[pid]=0
    set FSJ_PlayerPending[pid]=false
    return true
endfunction
endlibrary
