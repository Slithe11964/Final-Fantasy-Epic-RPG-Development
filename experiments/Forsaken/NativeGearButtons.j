globals
    framehandle array GearNative
    hashtable GearFrameData=InitHashtable()
    integer GearCacheContext=0
    integer GearWaiting=-1
    unit GearWaitingHero=null
    item GearWaitingItem=null
    real GearWaitingUntil=0.
    trigger GearFrameClicks=null
    trigger GearWaterCommands=null
    trigger GearIceCommands=null
endglobals

function QuickGear_Layout takes nothing returns nothing
    call BlzFrameClearAllPoints(QuickGearRoot)
    call BlzFrameSetPoint(QuickGearRoot,FRAMEPOINT_TOPLEFT,QuickGearAnchor,FRAMEPOINT_TOPRIGHT,.012,0.)
endfunction

function Gear_Preview takes integer cast returns nothing
    call QuickGear_ClearPreview()
    set QuickGearPending=-1
    set QuickGearPath=LoadInteger(QuickGearData,2,cast)
    set QuickGearNativePreview=QuickGearPath>0
    if QuickGearNativePreview then
        call QuickGear_MovePreview()
    endif
endfunction

function Gear_FrameClick takes nothing returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    local integer slotCode=LoadInteger(GearFrameData,0,GetHandleId(BlzGetTriggerFrame()))
    local item carried=null
    if GetLocalPlayer()==GetTriggerPlayer() and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) then
        if slotCode==1 or slotCode==2 then
            set carried=QuickGear_Item(hero,slotCode-1)
        elseif slotCode>=100 then
            set carried=BlzUnitItemInBagSlot(hero,slotCode-100)
        elseif slotCode>=10 then
            set carried=UnitItemInSlot(hero,slotCode-10)
        endif
        call Gear_Preview(LoadInteger(QuickGearData,0,GetItemTypeId(carried)))
    endif
    set carried=null
    set hero=null
endfunction

function Gear_Hook takes framehandle control,integer slotCode returns nothing
    local integer key=GetHandleId(control)
    if control!=null and not HaveSavedInteger(GearFrameData,0,key) then
        call SaveInteger(GearFrameData,0,key,slotCode)
        call BlzTriggerRegisterFrameEvent(GearFrameClicks,control,FRAMEEVENT_CONTROL_CLICK)
    endif
endfunction

function Gear_CacheBatch takes nothing returns nothing
    local integer last=GearCacheContext+32
    local integer index
    local framehandle control
    local framehandle bag
    loop
        exitwhen GearCacheContext>=last
        set GearNative[GearCacheContext*2]=BlzGetFrameByName("EquipmentButton_6",GearCacheContext)
        set GearNative[GearCacheContext*2+1]=BlzGetFrameByName("EquipmentButton_7",GearCacheContext)
        call Gear_Hook(GearNative[GearCacheContext*2],1)
        call Gear_Hook(GearNative[GearCacheContext*2+1],2)
        set bag=BlzGetFrameByName("SimpleEquipmentInventoryPanel",GearCacheContext)
        set index=0
        loop
            exitwhen index>=36
            set control=BlzGetFrameByName("InventoryButton_"+I2S(index),GearCacheContext)
            if control!=null then
                if bag!=null and BlzFrameGetParent(control)==bag then
                    call Gear_Hook(control,100+index)
                elseif index<6 then
                    call Gear_Hook(control,10+index)
                else
                    call Gear_Hook(control,100+index-6)
                endif
            endif
            set index=index+1
        endloop
        set GearCacheContext=GearCacheContext+1
    endloop
    set control=null
    set bag=null
endfunction

function Gear_WaterCommand takes nothing returns nothing
    call Gear_Preview('A08X')
endfunction

function Gear_IceCommand takes nothing returns nothing
    call Gear_Preview('A0UY')
endfunction

function Gear_CommandHooks takes nothing returns nothing
    // These are UI command-selection events, before the point is chosen.
    // They also cover dynamically created bag buttons and native item hotkeys.
    set GearWaterCommands=CreateTrigger()
    call TriggerRegisterCommandEvent(GearWaterCommands,'A08X',"carrionswarm")
    call TriggerRegisterCommandEvent(GearWaterCommands,'A0Q2',"carrionswarm")
    call TriggerAddAction(GearWaterCommands,function Gear_WaterCommand)
    set GearIceCommands=CreateTrigger()
    call TriggerRegisterCommandEvent(GearIceCommands,'A0UY',"shockwave")
    call TriggerAddAction(GearIceCommands,function Gear_IceCommand)
endfunction

function Gear_ClickNative takes integer slot returns boolean
    local integer context=0
    local framehandle control
    loop
        exitwhen context>=256
        set control=GearNative[context*2+slot]
        if control!=null and BlzFrameIsVisible(control) and BlzFrameGetEnable(control) then
            // This is the equipment panel's real item control. The engine owns
            // targeting art, range/target filtering, right-click/Escape and use.
            call Gear_Preview(LoadInteger(QuickGearData,0,GetItemTypeId(QuickGear_Item(Player_GetHero(GetLocalPlayer()),slot))))
            call BlzFrameClick(control)
            set control=null
            return true
        endif
        set context=context+1
    endloop
    set control=null
    return false
endfunction

function QuickGear_Request takes integer slot returns nothing
    local player viewer=GetLocalPlayer()
    local unit hero=Player_GetHero(viewer)
    local item carried=QuickGear_Item(hero,slot)
    local integer cast=LoadInteger(QuickGearData,0,GetItemTypeId(carried))
    call QuickGear_ClearPreview()
    set GearWaiting=-1
    if hero!=null and IsUnitSelected(hero,viewer) and GetWidgetLife(hero)>.405 and carried!=null and cast!=0 and not InventoryCinematicActive then
        if not Gear_ClickNative(slot) then
            // B binds the native equipment model to the selected hero. Finish
            // only while that exact hero/item remain selected and equipped.
            set GearWaiting=slot
            set GearWaitingHero=hero
            set GearWaitingItem=carried
            set GearWaitingUntil=TimerGetElapsed(ForsakenPanelClock)+1.
            call ForceUIKey("B")
        endif
    endif
    set carried=null
    set hero=null
    set viewer=null
endfunction

function QuickGear_Mouse takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        if GetTriggerEventId()==EVENT_PLAYER_MOUSE_MOVE then
            if BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0. then
                set QuickGearMouseX=BlzGetTriggerPlayerMouseX()
                set QuickGearMouseY=BlzGetTriggerPlayerMouseY()
                set QuickGearMouseKnown=true
                call QuickGear_MovePreview()
            endif
        elseif BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT or BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0. then
            call QuickGear_ClearPreview()
            set GearWaiting=-1
        endif
    endif
endfunction

function QuickGear_Draw takes unit hero,player viewer returns nothing
    local integer slot=0
    local item carried
    local integer raw
    local string icon
    loop
        exitwhen slot>=2
        set carried=QuickGear_Item(hero,slot)
        set raw=GetItemTypeId(carried)
        set QuickGearCast[slot]=LoadInteger(QuickGearData,0,raw)
        set QuickGearActive[slot]=carried!=null and QuickGearCast[slot]!=0
        if QuickGearLastRaw[slot]!=raw then
            set icon=LoadStr(QuickGearData,3,raw)
            if icon=="" and carried!=null then
                set icon=BlzGetItemIconPath(carried)
            endif
            call BlzFrameSetTexture(QuickGearIcon[slot],icon,0,true)
            set QuickGearLastRaw[slot]=raw
        endif
        call BlzFrameSetVisible(QuickGearButton[slot],QuickGearActive[slot])
        set slot=slot+1
    endloop
    call QuickGear_UpdateCooldowns(hero)
    set carried=null
endfunction

function QuickGear_Poll takes nothing returns nothing
    local player viewer=GetLocalPlayer()
    local unit hero=Player_GetHero(viewer)
    local integer pid=GetPlayerId(viewer)
    local integer slot=0
    local boolean show=pid<8 and hero!=null and FFL_Phase[pid]==0 and FFN_State[pid]==0 and not InventoryCinematicActive and IsUnitSelected(hero,viewer)
    local real now=TimerGetElapsed(NativeCDClock)
    if show then
        call QuickGear_Draw(hero,viewer)
        if GearWaiting>=0 then
            if hero!=GearWaitingHero or QuickGear_Item(hero,GearWaiting)!=GearWaitingItem or TimerGetElapsed(ForsakenPanelClock)>GearWaitingUntil then
                set GearWaiting=-1
            elseif Gear_ClickNative(GearWaiting) then
                set GearWaiting=-1
            endif
        endif
        call QuickGear_MovePreview()
    else
        call QuickGear_ClearPreview()
        set GearWaiting=-1
    endif
    call BlzFrameSetVisible(QuickGearRoot,show and (QuickGearActive[0] or QuickGearActive[1]))
    loop
        exitwhen slot>=2
        if QuickGearNativeWheel[slot]!=null then
            call BlzFrameSetVisible(QuickGearNativeWheel[slot],show and QuickGearActive[slot] and QuickGearEnds[slot]>now)
            call BlzFrameSetValue(QuickGearNativeWheel[slot],1.-RMinBJ(1.,RMaxBJ(0.,QuickGearEnds[slot]-now)/RMaxBJ(.01,QuickGearDuration[slot])))
        endif
        set slot=slot+1
    endloop
    set hero=null
    set viewer=null
endfunction

function QuickGear_Init takes nothing returns nothing
    local framehandle origin=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
    local integer slot=0
    local integer pid=0
    local integer keycode
    if QuickGearClick!=null then
        return
    endif
    // ITEM CATALOGUE
    // The entire dock uses ordinary frame controls. Mixing a simple button's
    // painted default texture with an ordinary backdrop left the backpack art
    // above the changing icon in UI48.
    set QuickGearRoot=BlzCreateFrameByType("FRAME","QuickGearDock",origin,"",0)
    set QuickGearAnchor=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,7)
    call BlzFrameSetSize(QuickGearRoot,.040,.086)
    call BlzFrameSetLevel(QuickGearRoot,120)
    call QuickGear_Layout()
    call BlzFrameSetVisible(QuickGearRoot,false)
    set QuickGearChatEdit=BlzGetFrameByName("ChatEditBar",0)
    set QuickGearClick=CreateTrigger()
    set QuickGearKeys=CreateTrigger()
    set QuickGearMouse=CreateTrigger()
    set QuickGearChat=CreateTrigger()
    set QuickGearBindings=CreateTrigger()
    set GearFrameClicks=CreateTrigger()
    call TriggerAddAction(QuickGearClick,function QuickGear_Click)
    call TriggerAddAction(QuickGearKeys,function QuickGear_Input)
    call TriggerAddAction(QuickGearMouse,function QuickGear_Mouse)
    call TriggerAddAction(QuickGearChat,function QuickGear_Input)
    call TriggerAddAction(QuickGearBindings,function QuickGear_Bindings)
    call TriggerAddAction(GearFrameClicks,function Gear_FrameClick)
    loop
        exitwhen pid>=8
        if QuickGearWeaponKey[pid]==0 then
            set QuickGearWeaponKey[pid]=70
        endif
        if QuickGearOffhandKey[pid]==0 then
            set QuickGearOffhandKey[pid]=71
        endif
        call TriggerRegisterPlayerEvent(QuickGearMouse,Player(pid),EVENT_PLAYER_MOUSE_MOVE)
        call TriggerRegisterPlayerEvent(QuickGearMouse,Player(pid),EVENT_PLAYER_MOUSE_DOWN)
        call TriggerRegisterPlayerChatEvent(QuickGearChat,Player(pid),"",false)
        call TriggerRegisterPlayerChatEvent(QuickGearBindings,Player(pid),"-gearhotkey",false)
        set keycode=48
        loop
            exitwhen keycode>90
            if keycode<=57 or keycode>=65 then
                call BlzTriggerRegisterPlayerKeyEvent(QuickGearKeys,Player(pid),ConvertOsKeyType(keycode),0,true)
                call BlzTriggerRegisterPlayerKeyEvent(QuickGearKeys,Player(pid),ConvertOsKeyType(keycode),0,false)
            endif
            set keycode=keycode+1
        endloop
        call BlzTriggerRegisterPlayerKeyEvent(QuickGearKeys,Player(pid),OSKEY_ESCAPE,0,true)
        call BlzTriggerRegisterPlayerKeyEvent(QuickGearKeys,Player(pid),OSKEY_RETURN,0,true)
        set pid=pid+1
    endloop
    loop
        exitwhen slot>=2
        set QuickGearButton[slot]=BlzCreateFrameByType("BUTTON","QuickGearButton",QuickGearRoot,"",slot)
        call BlzFrameSetSize(QuickGearButton[slot],.040,.040)
        call BlzFrameSetPoint(QuickGearButton[slot],FRAMEPOINT_TOPLEFT,QuickGearRoot,FRAMEPOINT_TOPLEFT,0.,-I2R(slot)*.046)
        set QuickGearIcon[slot]=BlzCreateFrameByType("BACKDROP","QuickGearIcon",QuickGearButton[slot],"",slot)
        call BlzFrameSetAllPoints(QuickGearIcon[slot],QuickGearButton[slot])
        call BlzFrameSetEnable(QuickGearIcon[slot],false)
        set QuickGearLabel[slot]=BlzCreateFrameByType("TEXT","QuickGearLabel",QuickGearButton[slot],"",slot)
        call BlzFrameSetPoint(QuickGearLabel[slot],FRAMEPOINT_TOPLEFT,QuickGearButton[slot],FRAMEPOINT_TOPLEFT,.002,-.001)
        call BlzFrameSetFont(QuickGearLabel[slot],"Fonts\\FRIZQT__.TTF",.010,0)
        call BlzFrameSetEnable(QuickGearLabel[slot],false)
        set QuickGearLastRaw[slot]=-1
        if slot==0 then
            call BlzFrameSetText(QuickGearLabel[slot],QuickGear_KeyName(QuickGearWeaponKey[GetPlayerId(GetLocalPlayer())]))
        else
            call BlzFrameSetText(QuickGearLabel[slot],QuickGear_KeyName(QuickGearOffhandKey[GetPlayerId(GetLocalPlayer())]))
        endif
        call BlzTriggerRegisterFrameEvent(QuickGearClick,QuickGearButton[slot],FRAMEEVENT_CONTROL_CLICK)
        set QuickGearNativeWheel[slot]=BlzCreateFrameByType("STATUSBAR","QuickGearCooldown",QuickGearButton[slot],"",slot)
        call BlzFrameSetModel(QuickGearNativeWheel[slot],"UI\\Feedback\\Cooldown\\UI-Cooldown-Indicator.mdl",0)
        call BlzFrameSetMinMaxValue(QuickGearNativeWheel[slot],0.,1.)
        call BlzFrameSetAllPoints(QuickGearNativeWheel[slot],QuickGearButton[slot])
        call BlzFrameSetEnable(QuickGearNativeWheel[slot],false)
        call BlzFrameSetVisible(QuickGearNativeWheel[slot],false)
        set slot=slot+1
    endloop
    call QuickGear_InitPreviews()
    set GearCacheContext=0
    loop
        exitwhen GearCacheContext>=256
        call ExecuteFunc("Gear_CacheBatch")
    endloop
    call ExecuteFunc("Gear_CommandHooks")
    set QuickGearUITimer=CreateTimer()
    call TimerStart(QuickGearUITimer,.05,true,function QuickGear_Poll)
    set origin=null
endfunction

function QuickGear_Reset takes nothing returns nothing
    local integer index=1
    if QuickGearClick==null then
        return
    endif
    call QuickGear_ClearPreview()
    call PauseTimer(QuickGearUITimer)
    call DestroyTimer(QuickGearUITimer)
    call DestroyTrigger(QuickGearClick)
    call DestroyTrigger(QuickGearKeys)
    call DestroyTrigger(QuickGearMouse)
    call DestroyTrigger(QuickGearChat)
    call DestroyTrigger(QuickGearBindings)
    call DestroyTrigger(GearFrameClicks)
    call DestroyTrigger(GearWaterCommands)
    call DestroyTrigger(GearIceCommands)
    call FlushParentHashtable(GearFrameData)
    call BlzDestroyFrame(QuickGearRoot)
    loop
        exitwhen index>QuickGearPreviewCount
        call DestroyImage(QuickGearPreviewImage[index])
        set index=index+1
    endloop
    set index=1
    loop
        exitwhen index>96
        call DestroyImage(QuickGearRune[index])
        set index=index+1
    endloop
    call DestroyImage(QuickGearTargetImage)
    set QuickGearClick=null
    set QuickGearRoot=null
    set GearWaiting=-1
    set GearWaitingHero=null
    set GearWaitingItem=null
endfunction
