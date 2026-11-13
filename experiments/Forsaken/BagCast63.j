globals
    framehandle BagCastRoot63=null
    framehandle array BagCastButton63
    hashtable BagCastSlots63=InitHashtable()
    trigger BagCastClick63=null
    trigger BagCastSync63=null
    integer BagCastClicks63=0
    boolean GearChatRecover63=false
endglobals

function BagCast_Spell63 takes integer raw returns integer
    local integer cast=LoadInteger(GearInputSpells,0,raw)
    if cast==0 then
        set cast=LoadInteger(QuickGearData,0,raw)
    endif
    if GearWave_ModeFor(cast)==0 then
        return 0
    endif
    return cast
endfunction

function GearChat_Poll63 takes nothing returns nothing
    if GearChatRecover63 and not BlzIsKeyPressed(OSKEY_RETURN) and TimerGetElapsed(ForsakenPanelClock)-QuickGearChatSentAt>=.1 then
        // Sending any chat command must release edit focus and the local latch.
        // No frame creation, native clicks, or gameplay orders.
        set GearChatRecover63=false
        set QuickGearChatOpen=false
        set QuickGearHeld[0]=false
        set QuickGearHeld[1]=false
        if QuickGearChatEdit!=null then
            call BlzFrameSetFocus(QuickGearChatEdit,false)
        endif
    endif
endfunction

function BagCast_Click63 takes nothing returns nothing
    local integer slot=LoadInteger(BagCastSlots63,0,GetHandleId(BlzGetTriggerFrame()))-1
    local unit hero=null
    local item carried=null
    local integer cast=0
    if GetTriggerPlayer()==GetLocalPlayer() and slot>=0 and slot<30 and not QuickGearChatOpen and not InventoryCinematicActive and BlzIsLocalClientActive() then
        call BlzFrameSetFocus(BlzGetTriggerFrame(),false)
        set hero=Player_GetHero(GetLocalPlayer())
        set carried=BlzUnitItemInBagSlot(hero,slot)
        set cast=BagCast_Spell63(GetItemTypeId(carried))
        if hero!=null and GetWidgetLife(hero)>.405 and IsUnitSelected(hero,GetLocalPlayer()) and cast!=0 then
            call QuickGear_ClearPreview()
            set QuickGearPending=100+slot
            set QuickGearPendingHero=GetUnitTypeId(hero)
            set QuickGearPendingItem=GetItemTypeId(carried)
            set QuickGearPendingMark=GetItemUserData(carried)
            set GearInputArmedAt=TimerGetElapsed(NativeCDClock)
            set GearInputTarget=true
            set BagCastClicks63=BagCastClicks63+1
            call GearWave_Arm(cast)
            call GearInput_Cursor()
        endif
    endif
    set carried=null
    set hero=null
endfunction

function BagCast_Send63 takes integer slot,integer heroRaw,integer itemRaw,integer mark,real x,real y returns nothing
    call BlzSendSyncData("FFBagWave63",I2S(slot)+":"+I2S(heroRaw)+":"+I2S(itemRaw)+":"+I2S(mark)+":"+R2S(x)+":"+R2S(y))
endfunction

function BagCast_Receive63 takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local unit hero=Player_GetHero(owner)
    local string data=BlzGetTriggerSyncData()
    local integer slot=S2I(QuickGear_Field(data,0))
    local item carried=null
    local integer cast=0
    local real x=S2R(QuickGear_Field(data,4))
    local real y=S2R(QuickGear_Field(data,5))
    if slot>=0 and slot<30 and hero!=null and GetOwningPlayer(hero)==owner and GetWidgetLife(hero)>.405 then
        set carried=BlzUnitItemInBagSlot(hero,slot)
        set cast=BagCast_Spell63(GetItemTypeId(carried))
        if carried!=null and cast!=0 and GetUnitTypeId(hero)==S2I(QuickGear_Field(data,1)) and GetItemTypeId(carried)==S2I(QuickGear_Field(data,2)) and GetItemUserData(carried)==S2I(QuickGear_Field(data,3)) then
            if NativeCD_Left(hero,NativeCD_Pool(cast))<=.01 and BlzGetUnitAbilityCooldownRemaining(hero,cast)<=.01 and GetUnitState(hero,UNIT_STATE_MANA)>=BlzGetAbilityManaCost(cast,0) then
                if x>=GetRectMinX(bj_mapInitialPlayableArea) and x<=GetRectMaxX(bj_mapInitialPlayableArea) and y>=GetRectMinY(bj_mapInitialPlayableArea) and y<=GetRectMaxY(bj_mapInitialPlayableArea) then
                    // Shared sync callback is the only place this UI casts.
                    call UnitUseItemPoint(hero,carried,x,y)
                endif
            endif
        endif
    endif
    set carried=null
    set hero=null
    set owner=null
endfunction

function BagCast_Poll63 takes nothing returns nothing
    local framehandle bag=ForsakenLinkedBag
    local unit hero=Player_GetHero(GetLocalPlayer())
    local boolean show=bag!=null and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) and not QuickGearChatOpen and not InventoryCinematicActive and BlzIsLocalClientActive()
    local integer slot=0
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
    endif
    call BlzFrameSetVisible(BagCastRoot63,show)
    loop
        exitwhen slot>=30
        if show then
            call BlzFrameClearAllPoints(BagCastButton63[slot])
            call BlzFrameSetPoint(BagCastButton63[slot],FRAMEPOINT_TOPLEFT,BagCastRoot63,FRAMEPOINT_TOPLEFT,.01+I2R(ModuloInteger(slot,6))*cellX,-.01-I2R(slot/6)*cellY)
            call BlzFrameSetSize(BagCastButton63[slot],cellX,cellY)
            // Only the wave items use this entry point. Other items retain
            // their native controls, cursor and click behavior.
            call BlzFrameSetVisible(BagCastButton63[slot],BagCast_Spell63(GetItemTypeId(BlzUnitItemInBagSlot(hero,slot)))!=0)
        else
            call BlzFrameSetVisible(BagCastButton63[slot],false)
        endif
        set slot=slot+1
    endloop
    set hero=null
    set bag=null
endfunction

function BagCast_Reset63 takes nothing returns nothing
    local integer slot=0
    if BagCastClick63!=null then
        call DestroyTrigger(BagCastClick63)
        set BagCastClick63=null
    endif
    if BagCastSync63!=null then
        call DestroyTrigger(BagCastSync63)
        set BagCastSync63=null
    endif
    loop
        exitwhen slot>=30
        if BagCastButton63[slot]!=null then
            call BlzDestroyFrame(BagCastButton63[slot])
        endif
        set BagCastButton63[slot]=null
        set slot=slot+1
    endloop
    if BagCastRoot63!=null then
        call BlzDestroyFrame(BagCastRoot63)
        set BagCastRoot63=null
    endif
    call FlushParentHashtable(BagCastSlots63)
endfunction

function BagCast_Init63 takes nothing returns nothing
    local integer slot=0
    local integer pid=0
    local framehandle origin=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
    call BlzLoadTOCFile("BagCast63.toc")
    set BagCastRoot63=BlzCreateSimpleFrame("BagCast63Root",origin,630)
    call BlzFrameSetLevel(BagCastRoot63,200)
    call BlzFrameSetVisible(BagCastRoot63,false)
    set BagCastClick63=CreateTrigger()
    set BagCastSync63=CreateTrigger()
    call TriggerAddAction(BagCastClick63,function BagCast_Click63)
    call TriggerAddAction(BagCastSync63,function BagCast_Receive63)
    loop
        exitwhen slot>=30
        set BagCastButton63[slot]=BlzCreateSimpleFrame("BagCast63Button",BagCastRoot63,631+slot)
        call BlzFrameSetLevel(BagCastButton63[slot],201)
        call BlzFrameSetVisible(BagCastButton63[slot],false)
        call SaveInteger(BagCastSlots63,0,GetHandleId(BagCastButton63[slot]),slot+1)
        call BlzTriggerRegisterFrameEvent(BagCastClick63,BagCastButton63[slot],FRAMEEVENT_CONTROL_CLICK)
        set slot=slot+1
    endloop
    loop
        exitwhen pid>=8
        call BlzTriggerRegisterPlayerSyncEvent(BagCastSync63,Player(pid),"FFBagWave63",false)
        set pid=pid+1
    endloop
    set origin=null
endfunction
