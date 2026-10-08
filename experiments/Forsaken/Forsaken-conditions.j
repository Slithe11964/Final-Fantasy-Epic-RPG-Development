function Forsaken_ConditionValue takes unit hero,integer index returns string
    local integer raw=0
    if index==0 then
        set raw='A0RA'
    elseif index==1 then
        set raw='A0FX'
    elseif index==2 then
        set raw='A0U6'
    elseif index==3 then
        set raw='A0GJ'
    elseif index==4 then
        set raw='A0WE'
    elseif index==5 then
        set raw='A0WG'
    elseif index==6 then
        set raw='A15P'
    elseif index==7 then
        set raw='A15R'
    elseif index==8 then
        if IsUnitInGroup(hero,udg_BossGroup) then
            return "Immune"
        endif
    elseif index==9 then
        if Forsaken_StatAbilityLevel(hero,'A0KV')>0 then
            return "-80%"
        endif
    endif
    if raw!=0 and Forsaken_StatAbilityLevel(hero,raw)>0 then
        return "Immune"
    endif
    return ""
endfunction

function Forsaken_ConditionName takes integer index returns string
    if index==0 then
        return "Blind"
    elseif index==1 then
        return "Disease"
    elseif index==2 then
        return "Sleep"
    elseif index==3 then
        return "Slow"
    elseif index==4 then
        return "Pain"
    elseif index==5 then
        return "Fog"
    elseif index==6 then
        return "Deprotect"
    elseif index==7 then
        return "Deshell"
    elseif index==8 then
        return "Stun / Freeze"
    endif
    return "Knockback"
endfunction

function Forsaken_ConditionCount takes unit hero returns integer
    local integer index=0
    local integer count=0
    loop
        exitwhen index>=10
        if Forsaken_ConditionValue(hero,index)!="" then
            set count=count+1
        endif
        set index=index+1
    endloop
    return count
endfunction

function Forsaken_RenderConditions takes unit hero,integer row returns nothing
    local integer index=0
    local string value
    loop
        exitwhen index>=10 or row>=12
        set value=Forsaken_ConditionValue(hero,index)
        if value!="" then
            call Forsaken_StatRow(row,Forsaken_ConditionName(index),"|cff00ff00"+value+"|r")
            set row=row+1
        endif
        set index=index+1
    endloop
endfunction
