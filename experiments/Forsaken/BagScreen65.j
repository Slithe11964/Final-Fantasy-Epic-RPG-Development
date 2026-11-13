globals
    framehandle BagConsole65=null
    real BagLeftEdge65=0.
    real BagTopEdge65=0.
    real BagCellX65=0.
    real BagCellY65=0.
    integer BagScreenArms65=0
endglobals

function BagScreen_Slot65 takes real x,real y returns integer
    local real dx=x-BagLeftEdge65
    local real dy=BagTopEdge65-y
    local integer column=0
    local integer row=0
    if BagCellX65<=0. or BagCellY65<=0. or dx<0. or dy<0. or dx>=6.*BagCellX65 or dy>=5.*BagCellY65 then
        return -1
    endif
    set column=R2I(dx/BagCellX65)
    set row=R2I(dy/BagCellY65)
    return row*6+column
endfunction

function BagScreen_Poll65 takes nothing returns nothing
    local framehandle bag=ForsakenLinkedBag
    local unit hero=Player_GetHero(GetLocalPlayer())
    local boolean show=bag!=null and BagConsole65!=null and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) and not QuickGearChatOpen and not InventoryCinematicActive and BlzIsLocalClientActive()
    local boolean left=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT)
    local boolean right=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT)
    local integer slot=-1
    local integer cast=0
    local real edge=0.
    local real bottom=0.
    if show then
        set show=BlzFrameIsVisible(bag)
    endif
    if show then
        // Installed inventorybar.fdf anchors bag BOTTOMRIGHT to console
        // TOPRIGHT +(0,.03). No input frame is placed over the inventory.
        set edge=(BlzPixelToFrameX(0)+BlzPixelToFrameX(BlzGetLocalClientWidth())+BlzFrameGetWidth(BagConsole65))/2.
        set bottom=BlzPixelToFrameY(BlzGetLocalClientHeight())+BlzFrameGetHeight(BagConsole65)+.03
        set BagLeftEdge65=edge-BlzFrameGetWidth(bag)+.01
        set BagTopEdge65=bottom+BlzFrameGetHeight(bag)-.01
        set BagCellX65=(BlzFrameGetWidth(bag)-.02)/6.
        set BagCellY65=(BlzFrameGetHeight(bag)-.02)/5.
        set slot=BagScreen_Slot65(BlzPixelToFrameX(BlzGetMouseScreenPosX()),BlzPixelToFrameY(BlzGetMouseScreenPosY()))
    endif
    set BagHoverSlot64=slot
    if right and not BagRight64 then
        if show and slot>=0 then
            set BagMoving64=not BagMoving64
        else
            set BagMoving64=false
        endif
        call GearWave_Clear()
    endif
    if left and not BagLeft64 then
        if BagMoving64 then
            set BagMoving64=false
        elseif show and slot>=0 then
            set cast=BagCast_Spell63(GetItemTypeId(BlzUnitItemInBagSlot(hero,slot)))
            if cast!=0 then
                set QuickGearPending=-1
                call QuickGear_ClearPreview()
                call GearWave_Arm(cast)
                set GearInputArmedAt=TimerGetElapsed(NativeCDClock)
                set BagScreenArms65=BagScreenArms65+1
            endif
        endif
    endif
    set BagLeft64=left
    set BagRight64=right
    set hero=null
    set bag=null
endfunction
