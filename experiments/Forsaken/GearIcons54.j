globals
    hashtable QuickGearIconPaths=InitHashtable()
    string array QuickGearPaintedPath
    item array QuickGearPaintedItem
    framehandle array QuickGearPaintedFrame
endglobals

function QuickGear_PaintIcon takes integer slot,item carried returns nothing
    local string path=""
    if carried!=null and QuickGearIcon[slot]!=null then
        // Use this build's object art, rather than an instance icon cached by
        // the native equipment panel. All canonical and equipped aliases agree.
        set path=LoadStr(QuickGearIconPaths,0,GetItemTypeId(carried))
        if path==null or path=="" then
            set path=BlzGetItemIconPath(carried)
        endif
        if path!=null and path!="" and (QuickGearPaintedItem[slot]!=carried or QuickGearPaintedPath[slot]!=path or QuickGearPaintedFrame[slot]!=QuickGearIcon[slot]) then
            call BlzFrameSetTexture(QuickGearIcon[slot],path,0,true)
            set QuickGearPaintedItem[slot]=carried
            set QuickGearPaintedPath[slot]=path
            set QuickGearPaintedFrame[slot]=QuickGearIcon[slot]
        endif
    else
        set QuickGearPaintedItem[slot]=null
        set QuickGearPaintedPath[slot]=""
        set QuickGearPaintedFrame[slot]=null
    endif
endfunction

function QuickGear_RefreshIcons takes unit hero returns nothing
    call QuickGear_PaintIcon(0,QuickGear_Item(hero,0))
    call QuickGear_PaintIcon(1,QuickGear_Item(hero,1))
endfunction
