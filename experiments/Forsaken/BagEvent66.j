globals
    real BagLastEvent66=-100.
    boolean BagHandled66=false
    item BagCarried66=null
    integer BagSourceSlot66=-1
    real BagMovedAt66=-100.
endglobals

function BagScreen_Update66 takes nothing returns nothing
    local framehandle bag=ForsakenLinkedBag
    local unit hero=Player_GetHero(GetLocalPlayer())
    local boolean show=bag!=null and BagConsole65!=null and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) and not QuickGearChatOpen and not InventoryCinematicActive and BlzIsLocalClientActive()
    local real edge=0.
    local real bottom=0.
    set BagHoverSlot64=-1
    if show then
        set show=BlzFrameIsVisible(bag)
    endif
    if show then
        set edge=(BlzPixelToFrameX(0)+BlzPixelToFrameX(BlzGetLocalClientWidth())+BlzFrameGetWidth(BagConsole65))/2.
        set bottom=BlzPixelToFrameY(BlzGetLocalClientHeight())+BlzFrameGetHeight(BagConsole65)+.03
        set BagLeftEdge65=edge-BlzFrameGetWidth(bag)+.01
        set BagTopEdge65=bottom+BlzFrameGetHeight(bag)-.01
        set BagCellX65=(BlzFrameGetWidth(bag)-.02)/6.
        set BagCellY65=(BlzFrameGetHeight(bag)-.02)/5.
        set BagHoverSlot64=BagScreen_Slot65(BlzPixelToFrameX(BlzGetMouseScreenPosX()),BlzPixelToFrameY(BlzGetMouseScreenPosY()))
    endif
    if BagMoving64 and BagSourceSlot66>=0 and hero!=null then
        if BlzUnitItemInBagSlot(hero,BagSourceSlot66)!=BagCarried66 then
            // An already-completed native move must not block the next cast.
            set BagMoving64=false
            set BagCarried66=null
            set BagSourceSlot66=-1
            set BagMovedAt66=TimerGetElapsed(NativeCDClock)
        endif
    endif
    set hero=null
    set bag=null
endfunction

function BagScreen_Click66 takes boolean right returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    local integer cast=0
    if right then
        set QuickGearPending=-1
        call QuickGear_ClearPreview()
        if BagHoverSlot64>=0 and not BagMoving64 then
            set BagCarried66=BlzUnitItemInBagSlot(hero,BagHoverSlot64)
            set BagSourceSlot66=BagHoverSlot64
            set BagMoving64=BagCarried66!=null
        else
            set BagMoving64=false
            set BagCarried66=null
            set BagSourceSlot66=-1
        endif
    elseif TimerGetElapsed(NativeCDClock)-BagMovedAt66<.12 then
        set cast=0
    elseif BagMoving64 then
        // Native left-click placement is not a request to cast the item.
        set BagMoving64=false
        set BagCarried66=null
        set BagSourceSlot66=-1
    elseif BagHoverSlot64>=0 and hero!=null then
        set cast=BagCast_Spell63(GetItemTypeId(BlzUnitItemInBagSlot(hero,BagHoverSlot64)))
        if cast!=0 then
            set QuickGearPending=-1
            call QuickGear_ClearPreview()
            call GearWave_Arm(cast)
            set GearInputArmedAt=TimerGetElapsed(NativeCDClock)
            set BagScreenArms65=BagScreenArms65+1
        endif
    endif
    set hero=null
endfunction

function BagScreen_Event66 takes nothing returns nothing
    call BagScreen_Update66()
    set BagHandled66=BagHoverSlot64>=0
    set BagLastEvent66=TimerGetElapsed(NativeCDClock)
    if BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT then
        call BagScreen_Click66(true)
    elseif BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_LEFT then
        call BagScreen_Click66(false)
    endif
endfunction

function BagScreen_Poll66 takes nothing returns nothing
    local boolean left=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT)
    local boolean right=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT)
    call BagScreen_Update66()
    // Fallback for native UI clicks that do not emit a mouse event. The shared
    // timestamp prevents the polled edge replaying the same native event.
    if TimerGetElapsed(NativeCDClock)-BagLastEvent66>.12 then
        if right and not BagRight64 then
            call BagScreen_Click66(true)
        elseif left and not BagLeft64 then
            call BagScreen_Click66(false)
        endif
    endif
    set BagLeft64=left
    set BagRight64=right
endfunction
