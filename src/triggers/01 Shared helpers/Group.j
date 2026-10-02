library TGroup
function Group_UnitsInRect takes rect r,boolexpr l_filter returns group
    set udg_EnumGroup=CreateGroup()
    call GroupEnumUnitsInRect(udg_EnumGroup,r,l_filter)
    call DestroyBoolExpr(l_filter)
    return udg_EnumGroup
endfunction

function Group_UnitsInRectOfPlayer takes rect r,player l_owner returns group
    set udg_EnumGroup=CreateGroup()
    set bj_groupEnumOwningPlayer=l_owner
    call GroupEnumUnitsInRect(udg_EnumGroup,r,filterGetUnitsInRectOfPlayer)
    return udg_EnumGroup
endfunction

function Group_UnitsInRangeOfLoc takes real l_radius,location l_loc,boolexpr l_filter returns group
    set udg_EnumGroup=CreateGroup()
    call GroupEnumUnitsInRangeOfLoc(udg_EnumGroup,l_loc,l_radius,l_filter)
    return udg_EnumGroup
endfunction

function Group_UnitsOfType takes integer l_unitTypeId returns group
    set udg_EnumGroup=CreateGroup()
    call GroupEnumUnitsOfType(udg_EnumGroup,UnitId2String(l_unitTypeId),udg_FilterTrue)
    return udg_EnumGroup
endfunction

function Group_UnitsOfPlayer takes player l_owner,boolexpr l_filter returns group
    set udg_EnumGroup=CreateGroup()
    call GroupEnumUnitsOfPlayer(udg_EnumGroup,l_owner,l_filter)
    call DestroyBoolExpr(l_filter)
    return udg_EnumGroup
endfunction

function Group_AllUnitsOfPlayer takes player l_owner returns group
    set udg_EnumGroup=CreateGroup()
    call GroupEnumUnitsOfPlayer(udg_EnumGroup,l_owner,udg_FilterTrue)
    return udg_EnumGroup
endfunction

function Group_UnitsOfPlayerAndType takes player l_owner,integer l_unitTypeId returns group
    set udg_EnumGroup=CreateGroup()
    set bj_groupEnumTypeId=l_unitTypeId
    call GroupEnumUnitsOfPlayer(udg_EnumGroup,l_owner,filterGetUnitsOfPlayerAndTypeId)
    return udg_EnumGroup
endfunction

function InitTrig_Group takes nothing returns nothing
endfunction

endlibrary
