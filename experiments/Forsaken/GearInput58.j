globals
    framehandle GearInputCursor=null
    trigger GearInputHover=null
    hashtable GearInputControls=InitHashtable()
    hashtable GearInputSpells=InitHashtable()
    integer GearInputContext=0
    integer GearInputHoverSlot=0
    boolean GearInputLeft=false
    boolean GearInputTarget=false
    real GearInputArmedAt=-1.
    integer GearInputBagClicks=0
endglobals

function GearInput_Cursor takes nothing returns nothing
    if GearInputCursor!=null then
        if GearInputTarget and QuickGearPending>=0 and BlzIsLocalClientActive() and not QuickGearChatOpen and not InventoryCinematicActive then
            call BlzFrameSetAbsPoint(GearInputCursor,FRAMEPOINT_CENTER,BlzPixelToFrameX(BlzGetMouseScreenPosX()),BlzPixelToFrameY(BlzGetMouseScreenPosY()))
            call BlzFrameSetVisible(GearInputCursor,true)
            call BlzEnableCursor(false)
        else
            call BlzFrameSetVisible(GearInputCursor,false)
            call BlzEnableCursor(true)
        endif
    endif
endfunction

function GearInput_Hover takes nothing returns nothing
    if GetTriggerPlayer()==GetLocalPlayer() then
        if BlzGetTriggerFrameEvent()==FRAMEEVENT_MOUSE_ENTER then
            set GearInputHoverSlot=LoadInteger(GearInputControls,0,GetHandleId(BlzGetTriggerFrame()))
        else
            set GearInputHoverSlot=0
        endif
    endif
endfunction

function GearInput_Hook takes framehandle control,integer slot returns nothing
    if control!=null and not HaveSavedInteger(GearInputControls,0,GetHandleId(control)) then
        call SaveInteger(GearInputControls,0,GetHandleId(control),slot)
        // Never replace the native CONTROL_CLICK action. It starts targeting.
        call BlzTriggerRegisterFrameEvent(GearInputHover,control,FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(GearInputHover,control,FRAMEEVENT_MOUSE_LEAVE)
    endif
endfunction

function GearInput_CacheBatch takes nothing returns nothing
    local integer last=GearInputContext+8
    local integer index=0
    local framehandle pane=null
    local framehandle control=null
    loop
        exitwhen GearInputContext>=last
        set pane=BlzGetFrameByName("SimpleEquipmentInventoryPanel",GearInputContext)
        call GearInput_Hook(BlzGetFrameByName("EquipmentButton_6",GearInputContext),1)
        call GearInput_Hook(BlzGetFrameByName("EquipmentButton_7",GearInputContext),2)
        set index=0
        loop
            exitwhen index>=36
            set control=BlzGetFrameByName("InventoryButton_"+I2S(index),GearInputContext)
            if control!=null then
                if pane!=null and BlzFrameGetParent(control)==pane then
                    call GearInput_Hook(control,100+index)
                elseif index<6 then
                    call GearInput_Hook(control,10+index)
                endif
            endif
            set index=index+1
        endloop
        set GearInputContext=GearInputContext+1
    endloop
    set pane=null
    set control=null
endfunction

function GearInput_Poll takes nothing returns nothing
    local boolean down=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT)
    local unit hero=Player_GetHero(GetLocalPlayer())
    local item carried=null
    local integer cast=0
    if not BlzIsLocalClientActive() or QuickGearChatOpen or InventoryCinematicActive then
        set GearInputHoverSlot=0
        set QuickGearPending=-1
        call QuickGear_ClearPreview()
    elseif down and not GearInputLeft and GearInputHoverSlot>0 and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) then
        if GearInputHoverSlot<=2 then
            if ForsakenCachedEquipment!=null and BlzFrameIsVisible(ForsakenCachedEquipment) then
                set carried=QuickGear_Item(hero,GearInputHoverSlot-1)
            endif
        elseif GearInputHoverSlot>=100 then
            if ForsakenLinkedBag!=null and BlzFrameIsVisible(ForsakenLinkedBag) then
                set carried=BlzUnitItemInBagSlot(hero,GearInputHoverSlot-100)
            endif
        else
            set carried=UnitItemInSlot(hero,GearInputHoverSlot-10)
        endif
        set cast=LoadInteger(QuickGearData,0,GetItemTypeId(carried))
        if cast==0 then
            set cast=LoadInteger(GearInputSpells,0,GetItemTypeId(carried))
        endif
        if carried!=null then
            set QuickGearPending=-1
            call QuickGear_ClearPreview()
        endif
        if GearWave_ModeFor(cast)>0 then
            call GearWave_Arm(cast)
            set GearInputArmedAt=TimerGetElapsed(NativeCDClock)
            set GearInputBagClicks=GearInputBagClicks+1
        endif
    endif
    set GearInputLeft=down
    call GearInput_Cursor()
    call GearWave_Draw()
    set carried=null
    set hero=null
endfunction

function GearInput_Reset takes nothing returns nothing
    set GearInputTarget=false
    call GearInput_Cursor()
    if GearInputCursor!=null then
        call BlzDestroyFrame(GearInputCursor)
    endif
    if GearInputHover!=null then
        call DestroyTrigger(GearInputHover)
    endif
    set GearInputCursor=null
    set GearInputHover=null
    set GearInputHoverSlot=0
    set GearInputLeft=false
    call FlushParentHashtable(GearInputControls)
    call GearWave_Reset()
endfunction

function GearInput_Init takes nothing returns nothing
    local integer batch=0
    set GearInputCursor=BlzCreateFrameByType("BACKDROP","GearInputTarget58",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetTexture(GearInputCursor,"QuickGearTarget.tga",0,true)
    call BlzFrameSetSize(GearInputCursor,.028,.028)
    call BlzFrameSetLevel(GearInputCursor,200)
    call BlzFrameSetEnable(GearInputCursor,false)
    call BlzFrameSetVisible(GearInputCursor,false)
    set GearInputHover=CreateTrigger()
    call TriggerAddAction(GearInputHover,function GearInput_Hover)
    set GearInputContext=0
    loop
        exitwhen batch>=32
        call ExecuteFunc("GearInput_CacheBatch")
        set batch=batch+1
    endloop
    call GearWave_Init()
endfunction
