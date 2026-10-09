library TForsakenSaveSession requires TForsakenSaveHeroes
// Same-game session rollback only; talents/partial monographs are never serialized.
// Caller must exclude gameplay, sync callbacks, writer jobs and load publication.
globals
    // 0 idle, 1 captured, 2 recovered, 3 blocked.
    integer array FSS_State
    boolean array FSS_Busy
    hashtable array FSS_Talents
    hashtable array FSS_HeroTable
    unit array FSS_FreeCached
    unit array FSS_Unit
    integer array FSS_Raw
    player array FSS_Owner
    boolean array FSS_ChoicePresent
    boolean array FSS_Choice
    boolean array FSS_SpentPresent
    integer array FSS_Spent
    integer array FSS_Skill
    boolean array FSS_Monograph
    integer array FSS_MonographCount
    string array FSS_Code
    integer array FSS_Account
    integer array FSS_Count
    string array FSS_Text
    integer array FSS_Pos
    integer array FSS_End
    boolean array FSS_Ok
    integer array FSS_Opaque
    integer array FSS_Dormant
    boolean array FSS_HasEvidence
    boolean array FSS_MetadataComplete
    integer array FSS_Id
    integer array FSS_Version
    boolean array FSS_Required
    string array FSS_Payload
    integer array FSS_Spec
    integer array FSS_Gaya
endglobals

function FSS_Context takes integer pid returns boolean
    local integer slot=0
    local integer index
    local unit hero
    if ForsakenTalentState!=FSS_Talents[pid] or udg_JobHeroHash!=FSS_HeroTable[pid] or udg_JobCount!=22 or LoadUnitHandle(udg_JobHeroHash,'H02L',pid)!=FSS_FreeCached[pid] then
        return false
    endif
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set hero=FHU_Live(pid,slot)
        if hero!=FSS_Unit[index] then
            set hero=null
            return false
        endif
        if slot<22 and udg_JobUnitType[slot]!=FPG_JobRaw(slot) then
            set hero=null
            return false
        endif
        if hero!=null and (GetUnitTypeId(hero)!=FSS_Raw[index] or GetOwningPlayer(hero)!=FSS_Owner[index]) then
            set hero=null
            return false
        endif
        set slot=slot+1
    endloop
    set hero=null
    return true
endfunction

function FSS_Matches takes integer pid returns boolean
    local integer job=0
    local integer node
    local integer parent
    local integer index
    local integer slot=0
    local integer active=pid+1
    if not FSS_Context(pid) or FSC_Code[pid]!=FSS_Code[pid] or ChroniclesMonographCount[pid+1]!=FSS_MonographCount[pid] then
        return false
    endif
    if udg_AbilitySlot1[pid+1]!=FSS_Skill[pid*6+0] then
        return false
    endif
    if udg_AbilitySlot2[pid+1]!=FSS_Skill[pid*6+1] then
        return false
    endif
    if udg_AbilitySlot3[pid+1]!=FSS_Skill[pid*6+2] then
        return false
    endif
    if udg_AbilitySlot4[pid+1]!=FSS_Skill[pid*6+3] then
        return false
    endif
    if udg_MainSkillSlot[pid+1]!=FSS_Skill[pid*6+4] then
        return false
    endif
    if udg_SubSkillSlot[pid+1]!=FSS_Skill[pid*6+5] then
        return false
    endif
    if FSC_Account[active]!=FSS_Account[pid] then
        return false
    endif
    if FSC_Count[active]!=FSS_Count[pid] then
        return false
    endif
    if FSC_Text[active]!=FSS_Text[pid] then
        return false
    endif
    if FSC_Pos[active]!=FSS_Pos[pid] then
        return false
    endif
    if FSC_End[active]!=FSS_End[pid] then
        return false
    endif
    if FSC_Ok[active]!=FSS_Ok[pid] then
        return false
    endif
    if FSC_Opaque[active]!=FSS_Opaque[pid] then
        return false
    endif
    if FSC_Dormant[active]!=FSS_Dormant[pid] then
        return false
    endif
    if FSC_HasEvidence[active]!=FSS_HasEvidence[pid] then
        return false
    endif
    if FSC_MetadataComplete[active]!=FSS_MetadataComplete[pid] then
        return false
    endif
    loop
        exitwhen slot>=32
        if FSC_Id[active*32+slot]!=FSS_Id[pid*32+slot] then
            return false
        endif
        if FSC_Version[active*32+slot]!=FSS_Version[pid*32+slot] then
            return false
        endif
        if FSC_Required[active*32+slot]!=FSS_Required[pid*32+slot] then
            return false
        endif
        if FSC_Payload[active*32+slot]!=FSS_Payload[pid*32+slot] then
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=16
        if FSC_Spec[active*16+slot]!=FSS_Spec[pid*16+slot] or FSC_Gaya[active*16+slot]!=FSS_Gaya[pid*16+slot] then
            return false
        endif
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=10
        if ChroniclesMonographSeen[(pid+1)*10+slot]!=FSS_Monograph[pid*10+slot] then
            return false
        endif
        set slot=slot+1
    endloop
    loop
        exitwhen job>=23
        set parent=pid*100+job
        set index=pid*23+job
        if HaveSavedInteger(ForsakenTalentState,parent,20)!=FSS_SpentPresent[index] or LoadInteger(ForsakenTalentState,parent,20)!=FSS_Spent[index] then
            return false
        endif
        set node=0
        loop
            exitwhen node>=12
            set index=(pid*23+job)*12+node
            if HaveSavedBoolean(ForsakenTalentState,parent,node)!=FSS_ChoicePresent[index] or LoadBoolean(ForsakenTalentState,parent,node)!=FSS_Choice[index] then
                return false
            endif
            set node=node+1
        endloop
        set job=job+1
    endloop
    return true
endfunction

function FSS_Clear takes integer pid returns nothing
    local integer slot=0
    loop
        exitwhen slot>=25
        set FSS_Unit[pid*25+slot]=null
        set FSS_Owner[pid*25+slot]=null
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=32
        set FSS_Payload[pid*32+slot]=null
        set slot=slot+1
    endloop
    set FSS_Text[pid]=null
    set FSS_Code[pid]=null
    set FSS_Talents[pid]=null
    set FSS_HeroTable[pid]=null
    set FSS_FreeCached[pid]=null
    set FSS_State[pid]=0
    set FSN_SessionBlocked[pid]=false
    set FSC_SessionBlocked[pid]=false
    set FSJ_SessionPending[pid]=false
endfunction

function FSS_Begin takes integer pid returns boolean
    local integer slot=0
    local integer job=0
    local integer node
    local integer parent
    local integer index
    local integer active=pid+1
    local unit hero
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSS_Busy[pid] or FSS_State[pid]!=0 or FHU_State[pid]!=1 or FHU_Busy[pid] or FPG_Busy[pid] or FQR_Busy[pid] or FSN_Busy[pid] or FSC_Busy[pid] or FSC_Writing[pid] or not FHU_Verify(pid,true) or not FPG_Verify(pid) or not FSJ_Verify(pid) then
        return false
    endif
    if ForsakenTalentState==null or FSC_Count[active]<0 or FSC_Count[active]>32 or ChroniclesMonographCount[pid+1]<0 or ChroniclesMonographCount[pid+1]>10 then
        return false
    endif
    set FSS_Busy[pid]=true
    set FSS_Talents[pid]=ForsakenTalentState
    set FSS_HeroTable[pid]=udg_JobHeroHash
    set FSS_FreeCached[pid]=LoadUnitHandle(udg_JobHeroHash,'H02L',pid)
    loop
        exitwhen slot>=25
        set index=pid*25+slot
        set hero=FHU_Live(pid,slot)
        set FSS_Unit[index]=hero
        if hero!=null then
            set FSS_Raw[index]=GetUnitTypeId(hero)
            set FSS_Owner[index]=GetOwningPlayer(hero)
        endif
        set slot=slot+1
    endloop
    set hero=null
    set FSS_MonographCount[pid]=ChroniclesMonographCount[pid+1]
    set FSS_Code[pid]=FSC_Code[pid]
    set FSS_Skill[pid*6+0]=udg_AbilitySlot1[pid+1]
    set FSS_Skill[pid*6+1]=udg_AbilitySlot2[pid+1]
    set FSS_Skill[pid*6+2]=udg_AbilitySlot3[pid+1]
    set FSS_Skill[pid*6+3]=udg_AbilitySlot4[pid+1]
    set FSS_Skill[pid*6+4]=udg_MainSkillSlot[pid+1]
    set FSS_Skill[pid*6+5]=udg_SubSkillSlot[pid+1]
    set FSS_Account[pid]=FSC_Account[active]
    set FSS_Count[pid]=FSC_Count[active]
    set FSS_Text[pid]=FSC_Text[active]
    set FSS_Pos[pid]=FSC_Pos[active]
    set FSS_End[pid]=FSC_End[active]
    set FSS_Ok[pid]=FSC_Ok[active]
    set FSS_Opaque[pid]=FSC_Opaque[active]
    set FSS_Dormant[pid]=FSC_Dormant[active]
    set FSS_HasEvidence[pid]=FSC_HasEvidence[active]
    set FSS_MetadataComplete[pid]=FSC_MetadataComplete[active]
    set slot=0
    loop
        exitwhen slot>=32
        set FSS_Id[pid*32+slot]=FSC_Id[active*32+slot]
        set FSS_Version[pid*32+slot]=FSC_Version[active*32+slot]
        set FSS_Required[pid*32+slot]=FSC_Required[active*32+slot]
        set FSS_Payload[pid*32+slot]=FSC_Payload[active*32+slot]
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=16
        set FSS_Spec[pid*16+slot]=FSC_Spec[active*16+slot]
        set FSS_Gaya[pid*16+slot]=FSC_Gaya[active*16+slot]
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=10
        set FSS_Monograph[pid*10+slot]=ChroniclesMonographSeen[(pid+1)*10+slot]
        set slot=slot+1
    endloop
    loop
        exitwhen job>=23
        set parent=pid*100+job
        set index=pid*23+job
        set FSS_SpentPresent[index]=HaveSavedInteger(ForsakenTalentState,parent,20)
        set FSS_Spent[index]=LoadInteger(ForsakenTalentState,parent,20)
        set node=0
        loop
            exitwhen node>=12
            set index=(pid*23+job)*12+node
            set FSS_ChoicePresent[index]=HaveSavedBoolean(ForsakenTalentState,parent,node)
            set FSS_Choice[index]=LoadBoolean(ForsakenTalentState,parent,node)
            set node=node+1
        endloop
        set job=job+1
    endloop
    if not FSS_Matches(pid) or not FHU_Verify(pid,true) or not FPG_Verify(pid) or not FSJ_Verify(pid) then
        call FSS_Clear(pid)
        set FSS_Busy[pid]=false
        return false
    endif
    set FSS_State[pid]=1
    set FSJ_SessionPending[pid]=true
    set FSS_Busy[pid]=false
    return true
endfunction

function FSS_Verify takes integer pid returns boolean
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSS_Busy[pid] or FSS_State[pid]==0 then
        return false
    endif
    return FSS_Matches(pid)
endfunction

function FSS_Recover takes integer pid returns boolean
    local integer slot=0
    local integer job=0
    local integer node
    local integer parent
    local integer index
    local integer active=pid+1
    if not FSC_PlayerValid(pid) then
        return false
    endif
    if FSS_Busy[pid] or FSS_State[pid]==0 or FHU_Busy[pid] or FPG_Busy[pid] or FQR_Busy[pid] or FSN_Busy[pid] or FSJ_Busy[pid] or FSC_Busy[pid] then
        return false
    endif
    set FSS_State[pid]=3
    set FSN_SessionBlocked[pid]=true
    set FSC_SessionBlocked[pid]=true
    if FSC_Writing[pid] or not FSS_Context(pid) then
        return false
    endif
    set FSS_Busy[pid]=true
    set FHU_Busy[pid]=true
    set FPG_Busy[pid]=true
    set FSN_Busy[pid]=true
    set FSJ_Busy[pid]=true
    set FSC_Busy[pid]=true
    set udg_AbilitySlot1[pid+1]=FSS_Skill[pid*6+0]
    set udg_AbilitySlot2[pid+1]=FSS_Skill[pid*6+1]
    set udg_AbilitySlot3[pid+1]=FSS_Skill[pid*6+2]
    set udg_AbilitySlot4[pid+1]=FSS_Skill[pid*6+3]
    set udg_MainSkillSlot[pid+1]=FSS_Skill[pid*6+4]
    set udg_SubSkillSlot[pid+1]=FSS_Skill[pid*6+5]
    set ChroniclesMonographCount[pid+1]=FSS_MonographCount[pid]
    set FSC_Code[pid]=FSS_Code[pid]
    set FSC_Account[active]=FSS_Account[pid]
    set FSC_Count[active]=FSS_Count[pid]
    set FSC_Text[active]=FSS_Text[pid]
    set FSC_Pos[active]=FSS_Pos[pid]
    set FSC_End[active]=FSS_End[pid]
    set FSC_Ok[active]=FSS_Ok[pid]
    set FSC_Opaque[active]=FSS_Opaque[pid]
    set FSC_Dormant[active]=FSS_Dormant[pid]
    set FSC_HasEvidence[active]=FSS_HasEvidence[pid]
    set FSC_MetadataComplete[active]=FSS_MetadataComplete[pid]
    loop
        exitwhen slot>=32
        set FSC_Id[active*32+slot]=FSS_Id[pid*32+slot]
        set FSC_Version[active*32+slot]=FSS_Version[pid*32+slot]
        set FSC_Required[active*32+slot]=FSS_Required[pid*32+slot]
        set FSC_Payload[active*32+slot]=FSS_Payload[pid*32+slot]
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=16
        set FSC_Spec[active*16+slot]=FSS_Spec[pid*16+slot]
        set FSC_Gaya[active*16+slot]=FSS_Gaya[pid*16+slot]
        set slot=slot+1
    endloop
    set slot=0
    loop
        exitwhen slot>=10
        set ChroniclesMonographSeen[(pid+1)*10+slot]=FSS_Monograph[pid*10+slot]
        set slot=slot+1
    endloop
    loop
        exitwhen job>=23
        set parent=pid*100+job
        set index=pid*23+job
        if FSS_SpentPresent[index] then
            call SaveInteger(ForsakenTalentState,parent,20,FSS_Spent[index])
        else
            call RemoveSavedInteger(ForsakenTalentState,parent,20)
        endif
        set node=0
        loop
            exitwhen node>=12
            set index=(pid*23+job)*12+node
            if FSS_ChoicePresent[index] then
                call SaveBoolean(ForsakenTalentState,parent,node,FSS_Choice[index])
            else
                call RemoveSavedBoolean(ForsakenTalentState,parent,node)
            endif
            set node=node+1
        endloop
        set job=job+1
    endloop
    set FSC_Busy[pid]=false
    set FSJ_Busy[pid]=false
    set FSN_Busy[pid]=false
    set FPG_Busy[pid]=false
    set FHU_Busy[pid]=false
    set FSS_Busy[pid]=false
    if not FSS_Matches(pid) then
        return false
    endif
    set FSS_State[pid]=2
    return true
endfunction

function FSS_Release takes integer pid returns boolean
    if not FSS_Verify(pid) then
        return false
    endif
    if FSS_State[pid]!=2 or FHU_Busy[pid] or FPG_Busy[pid] or FQR_Busy[pid] or FSN_Busy[pid] or FSC_Busy[pid] or FSC_Writing[pid] or (FHU_State[pid]!=0 and FHU_State[pid]!=2) or (FPG_State[pid]!=0 and FPG_State[pid]!=2) or (FQR_State[pid]!=0 and FQR_State[pid]!=5) or not FSJ_Verify(pid) then
        return false
    endif
    if FHU_State[pid]==2 and not FHU_Verify(pid,true) then
        return false
    endif
    if FPG_State[pid]==2 and not FPG_Verify(pid) then
        return false
    endif
    call FSS_Clear(pid)
    return true
endfunction
endlibrary
