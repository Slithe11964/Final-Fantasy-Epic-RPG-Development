// Preserve original payloads. The historical Speedrun tag is informational;
// optional trial progress permits defaults for older/Legendary profiles.
function FFL_CoreReadback takes integer original,integer captured,string expected,string actual returns boolean
    local integer count
    local integer i=0
    local integer identity
    local integer wanted
    local integer found
    set FSC_Text[original]=FSS_SetRoot(expected,295637012,original,false)
    set FSC_Text[captured]=FSS_SetRoot(actual,295637012,captured,false)
    set FSC_Pos[original]=0
    set FSC_Pos[captured]=0
    set FSC_End[original]=FSS_Length(FSC_Text[original])
    set FSC_End[captured]=FSS_Length(FSC_Text[captured])
    set FSC_Ok[original]=true
    set FSC_Ok[captured]=true
    set count=FSC_Read(original)
    if count!=FSC_Read(captured) then
        return false
    endif
    loop
        exitwhen i>=count
        set identity=FSC_Read(original)
        if identity!=FSC_Read(captured) then
            return false
        endif
        set wanted=FSC_Read(original)
        set found=FSC_Read(captured)
        if identity==15 then
            if wanted>1 or found>1 then
                return false
            endif
        elseif wanted!=found then
            return false
        endif
        set i=i+1
    endloop
    return FSC_Ok[original] and FSC_Ok[captured] and FSC_Pos[original]==FSC_End[original] and FSC_Pos[captured]==FSC_End[captured]
endfunction

function FFL_ExpectedTrial takes integer pid,integer identity returns boolean
    if FFL_Val(pid,11,identity)==1 then
        return true
    elseif identity<=22 then
        return FFL_Val(pid,10,identity)==3
    elseif identity==23 then
        return FFL_Val(pid,4,12)==3
    endif
    return false
endfunction

function FFL_ReadbackBody takes integer pid,string actual,string expected returns boolean
    local integer original=pid+9
    local integer captured=pid+25
    local integer i=0
    local integer j
    local integer left
    local integer right
    local integer trial=-1
    local integer identity
    local integer count
    local integer wanted=0
    if not FSC_Parse(original,expected,FRC_Account(pid),true) or not FSC_Parse(captured,actual,FRC_Account(pid),true) then
        set FRC_Error[pid]=FSS_SetRoot("readback profile could not be decoded",243739446,pid,false)
        return false
    endif
    if (FSC_Count[original]!=7 and FSC_Count[original]!=8) or FSC_Count[captured]!=8 then
        set FRC_Error[pid]=FSS_SetRoot("readback section count differs",243739446,pid,false)
        return false
    endif
    loop
        exitwhen i>=FSC_Count[original]
        set left=original*32+i
        if FSC_Id[left]!=11 then
            set j=0
            loop
                exitwhen j>=FSC_Count[captured] or FSC_Id[captured*32+j]==FSC_Id[left]
                set j=j+1
            endloop
            if j>=FSC_Count[captured] then
                set FRC_Error[pid]=FSS_SetRoot("readback section missing",243739446,pid,false)
                return false
            endif
            set right=captured*32+j
            if FSC_Version[left]!=FSC_Version[right] or FSC_Required[left]!=FSC_Required[right] then
                set FRC_Error[pid]=FSS_SetRoot("readback section metadata differs",243739446,pid,false)
                return false
            endif
            if not FSS_Equals(FSC_Payload[left],FSC_Payload[right]) and not (FSC_Id[left]==4 and FFL_CoreReadback(original,captured,FSC_Payload[left],FSC_Payload[right])) then
                set FRC_Error[pid]=FSS_SetRoot(FSS_Concat("readback section differs: ",I2S(FSC_Id[left])),243739446,pid,false)
                return false
            endif
        endif
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=FSC_Count[captured]
        set right=captured*32+i
        if FSC_Id[right]==11 and FSC_Version[right]==1 and not FSC_Required[right] then
            set trial=right
        endif
        set i=i+1
    endloop
    if trial<0 then
        set FRC_Error[pid]=FSS_SetRoot("readback trial section missing",243739446,pid,false)
        return false
    endif
    set identity=1
    loop
        exitwhen identity>61
        if FFL_ExpectedTrial(pid,identity) then
            set wanted=wanted+1
        endif
        set identity=identity+1
    endloop
    set FSC_Text[captured]=FSS_SetRoot(FSC_Payload[trial],295637012,captured,false)
    set FSC_Pos[captured]=0
    set FSC_End[captured]=FSS_Length(FSC_Text[captured])
    set FSC_Ok[captured]=true
    set count=FSC_Read(captured)
    if count!=wanted then
        set FRC_Error[pid]=FSS_SetRoot("readback trial count differs",243739446,pid,false)
        return false
    endif
    set i=0
    loop
        exitwhen i>=count
        set identity=FSC_Read(captured)
        if not FFL_ExpectedTrial(pid,identity) or FSC_Read(captured)!=1 then
            set FRC_Error[pid]=FSS_SetRoot("readback trial progress differs",243739446,pid,false)
            return false
        endif
        set i=i+1
    endloop
    return FSC_Ok[captured] and FSC_Pos[captured]==FSC_End[captured]
endfunction

function FFL_ReadbackMatches takes integer pid,string actual,string expected returns boolean
    local boolean valid
    if FSS_Equals(actual,expected) then
        return true
    endif
    call FSC_Clear(pid+9)
    call FSC_ClearSeen(pid+9)
    call FSC_Clear(pid+25)
    call FSC_ClearSeen(pid+25)
    set valid=FFL_ReadbackBody(pid,actual,expected)
    call FSC_ClearSeen(pid+9)
    call FSC_Clear(pid+9)
    call FSC_ClearSeen(pid+25)
    call FSC_Clear(pid+25)
    return valid
endfunction
