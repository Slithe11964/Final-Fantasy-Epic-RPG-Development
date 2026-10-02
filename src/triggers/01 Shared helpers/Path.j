library TPath
function Path_KillTreeFilter takes nothing returns boolean
    local destructable d=GetFilterDestructable()
    if GetWidgetLife(d)>.405 and not IsDestructableInvulnerable(d)then
        call KillDestructable(d)
    endif
    set d=null
    return false
endfunction

function Path_Init takes nothing returns nothing
    set udg_PathProbeItem=CreateItem('ciri',$6840,-$6D3E) // 'ciri': item "Meta Fragment"; $6840 = 26688; $6D3E = 27966
    call SetItemVisible(udg_PathProbeItem,false)
    set gg_rct_001=Rect(.0,.0,128.,128.)
    set udg_KillTreeFilter=Condition(function Path_KillTreeFilter)
endfunction

function Path_HideItem takes nothing returns nothing
    if IsItemVisible(GetEnumItem())then
        set udg_PathHiddenItem[udg_PathHiddenCount]=GetEnumItem()
        call SetItemVisible(udg_PathHiddenItem[udg_PathHiddenCount],false)
        set udg_PathHiddenCount=udg_PathHiddenCount+1
    endif
endfunction

function Path_IsWalkable takes real x,real y,real l_tolerance returns boolean
    call MoveRectTo(gg_rct_001,x,y)
    call EnumItemsInRect(gg_rct_001,null,function Path_HideItem)
    call SetItemPosition(udg_PathProbeItem,x,y)
    set udg_PathProbeX=GetItemX(udg_PathProbeItem)
    set udg_PathProbeY=GetItemY(udg_PathProbeItem)
    call SetItemVisible(udg_PathProbeItem,false)
    loop
        exitwhen udg_PathHiddenCount<=0
        set udg_PathHiddenCount=udg_PathHiddenCount-1
        call SetItemVisible(udg_PathHiddenItem[udg_PathHiddenCount],true)
        set udg_PathHiddenItem[udg_PathHiddenCount]=null
    endloop
    // Calculation 1:
    // (the square of ((x) minus (udg_PathProbeX))) plus (the square of ((y) minus (udg_PathProbeY))).
    // Calculation 2:
    // The square of (l_tolerance).
    return(x-udg_PathProbeX)*(x-udg_PathProbeX)+(y-udg_PathProbeY)*(y-udg_PathProbeY)<l_tolerance*l_tolerance
endfunction

function InitTrig_Path takes nothing returns nothing
endfunction

endlibrary
