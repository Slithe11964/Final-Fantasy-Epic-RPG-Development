globals
    framehandle array BagHoverTip64
    integer BagHoverSlot64=-1
    integer BagHoverRaw64=0
    boolean BagLeft64=false
    boolean BagRight64=false
    boolean BagMoving64=false
    boolean array GearRawDown64
    integer GearRawRequests64=0
endglobals

function GearChat_Sent64 takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        set QuickGearChatOpen=false
        set QuickGearChatSentAt=TimerGetElapsed(NativeCDClock)
        set GearChatRecover63=true
        set QuickGearHeld[0]=false
        set QuickGearHeld[1]=false
    endif
endfunction

function GearRaw_Poll64 takes nothing returns nothing
    local integer slot=0
    local integer key=0
    local integer pid=GetPlayerId(GetLocalPlayer())
    local boolean down=false
    local boolean allowed=BlzIsLocalClientActive() and not QuickGearChatOpen and not InventoryCinematicActive
    if pid>=8 then
        return
    endif
    set allowed=allowed and not TravelVisible[pid] and not BlzIsMetaKeyPressed(1) and not BlzIsMetaKeyPressed(2) and not BlzIsMetaKeyPressed(4) and not BlzIsMetaKeyPressed(8)
    loop
        exitwhen slot>=2
        if slot==0 then
            set key=QuickGearWeaponKey[pid]
        else
            set key=QuickGearOffhandKey[pid]
        endif
        set down=BlzIsKeyPressed(ConvertOsKeyType(key))
        if down and not GearRawDown64[slot] and allowed and TimerGetElapsed(NativeCDClock)-QuickGearLastPress[slot]>=.25 then
            set QuickGearLastPress[slot]=TimerGetElapsed(NativeCDClock)
            set GearRawRequests64=GearRawRequests64+1
            call QuickGear_Request(slot)
        endif
        // Observe releases even while typing; closing chat must not cast a
        // letter still held from the chat message.
        set GearRawDown64[slot]=down
        set slot=slot+1
    endloop
endfunction

function BagHover_World64 takes nothing returns nothing
    local integer slot=0
    if not BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT) and not BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT) then
        loop
            exitwhen slot>=30
            call BlzFrameSetVisible(BagCastButton63[slot],false)
            set slot=slot+1
        endloop
        set BagHoverSlot64=-1
    endif
endfunction

function BagHover_Poll64 takes nothing returns nothing
    local framehandle bag=ForsakenLinkedBag
    local unit hero=Player_GetHero(GetLocalPlayer())
    local boolean show=bag!=null and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) and not QuickGearChatOpen and not InventoryCinematicActive and BlzIsLocalClientActive()
    local boolean left=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT)
    local boolean right=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT)
    local integer slot=0
    local integer hover=-1
    local integer cast=0
    local real width=0.
    local real height=0.
    local real cellX=0.
    local real cellY=0.
    if show then
        set show=BlzFrameIsVisible(bag)
    endif
    if show then
        set width=BlzFrameGetWidth(bag)
        set height=BlzFrameGetHeight(bag)
        set cellX=RMaxBJ(.001,(width-.02)/6.)
        set cellY=RMaxBJ(.001,(height-.02)/5.)
        call BlzFrameClearAllPoints(BagCastRoot63)
        call BlzFrameSetPoint(BagCastRoot63,FRAMEPOINT_TOPLEFT,bag,FRAMEPOINT_TOPLEFT,0.,0.)
        call BlzFrameSetSize(BagCastRoot63,width,height)
        loop
            exitwhen slot>=30
            if BlzFrameIsVisible(BagHoverTip64[slot]) then
                set hover=slot
            endif
            set slot=slot+1
        endloop
        if hover>=0 then
            set BagHoverSlot64=hover
            set BagHoverRaw64=GetItemTypeId(BlzUnitItemInBagSlot(hero,hover))
        endif
    endif
    // All owned detector buttons are DISABLED. They have no click action.
    // Tooltip visibility is the only observation; native controls own input.
    call BlzFrameSetVisible(BagCastRoot63,show)
    set slot=0
    loop
        exitwhen slot>=30
        if show then
            call BlzFrameClearAllPoints(BagCastButton63[slot])
            call BlzFrameSetPoint(BagCastButton63[slot],FRAMEPOINT_TOPLEFT,BagCastRoot63,FRAMEPOINT_TOPLEFT,.01+I2R(ModuloInteger(slot,6))*cellX,-.01-I2R(slot/6)*cellY)
            call BlzFrameSetSize(BagCastButton63[slot],cellX,cellY)
            call BlzFrameSetVisible(BagCastButton63[slot],slot!=BagHoverSlot64 and not left and not right and not BagMoving64 and BagCast_Spell63(GetItemTypeId(BlzUnitItemInBagSlot(hero,slot)))!=0)
        else
            call BlzFrameSetVisible(BagCastButton63[slot],false)
        endif
        set slot=slot+1
    endloop
    if right and not BagRight64 and show then
        set BagMoving64=not BagMoving64
        call GearWave_Clear()
    endif
    if left and not BagLeft64 and show then
        if BagMoving64 then
            set BagMoving64=false
        elseif BagHoverSlot64>=0 and GetItemTypeId(BlzUnitItemInBagSlot(hero,BagHoverSlot64))==BagHoverRaw64 then
            set cast=BagCast_Spell63(BagHoverRaw64)
            if cast!=0 then
                set QuickGearPending=-1
                call QuickGear_ClearPreview()
                call GearWave_Arm(cast)
                set GearInputArmedAt=TimerGetElapsed(NativeCDClock)
            endif
        endif
    endif
    if not show then
        set BagHoverSlot64=-1
    endif
    set BagLeft64=left
    set BagRight64=right
    set hero=null
    set bag=null
endfunction
