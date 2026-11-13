globals
    integer Wave_Mode=0
    boolean Wave_FromGear=false
    hashtable Wave_Controls=InitHashtable()
    trigger Wave_Clicks=null
    integer Wave_Context=0
    trigger Wave_Keys=null
    framehandle Wave_Calculator=null
    hashtable Wave_Spells=InitHashtable()
    timer Wave_CacheClock=null
    integer Wave_HookCount=0
    integer Wave_ClickCount=0
    real Wave_ArmedAt=-1.
endglobals

function Wave_AbilityMode takes integer cast returns integer
    if cast=='A17S' or cast=='A0TM' or cast=='A0UY' then
        return 2
    elseif cast=='A08X' or cast=='A0Q0' or cast=='A0Q1' or cast=='A0Q2' or cast=='A0SM' or cast=='A0TP' or cast=='A0SA' or cast=='A150' then
        return 1
    endif
    return 0
endfunction

function Wave_ItemMode takes integer raw returns integer
    local integer cast=LoadInteger(QuickGearData,0,raw)
    local integer mode=LoadInteger(Wave_Spells,0,raw)
    if mode>0 then
        return mode
    endif
    if raw=='I025' then
        return 1
    endif
    if raw=='q104' then
        return 2
    elseif raw=='q220' then
        return 1
    endif
    return Wave_AbilityMode(cast)
endfunction

function Wave_CarriedMode takes item carried returns integer
    // This shared lookup is generated from actual item ability definitions,
    // including loaded/carried aliases. Local UI never allocates ability handles.
    return Wave_ItemMode(GetItemTypeId(carried))
endfunction

function Wave_Poll takes nothing returns nothing
    if QuickGearPending>=0 then
        set Wave_Mode=Wave_ItemMode(QuickGearPendingItem)
        set Wave_FromGear=true
    elseif Wave_FromGear then
        set Wave_Mode=0
        set Wave_FromGear=false
    endif
endfunction

function Wave_Draw takes unit hero returns nothing
    local integer i=1
    local real x=DG_MouseX
    local real y=DG_MouseY
    local real angle
    local real direction
    local real distance
    local boolean show=hero!=null and GetWidgetLife(hero)>.405 and IsUnitSelected(hero,GetLocalPlayer()) and not InventoryCinematicActive
    local unit focus=BlzGetMouseFocusUnit()
    if focus!=null and IsUnitEnemy(focus,GetLocalPlayer()) then
        set x=GetUnitX(focus)
        set y=GetUnitY(focus)
    endif
    set angle=Atan2(y-GetUnitY(hero),x-GetUnitX(hero))
    loop
        exitwhen i>64
        if Wave_Mode==1 then
            // Same rune placement as Sonic Thrust, without its +150 extension.
            // Water_Launch travels exactly 800 units regardless of target range.
            set distance=800.*I2R(i-1)/31.
            set direction=angle
        else
            // Copy Spell_Blizzaga's three directions and last damage pulse.
            set distance=1000.*I2R(ModuloInteger(i-1,21))/20.
            set direction=angle+(-11.25+22.5*I2R((i-1)/21))*bj_DEGTORAD
        endif
        if show then
            call SetImagePosition(DG_Rune[i],GetUnitX(hero)+distance*Cos(direction)-12.,GetUnitY(hero)+distance*Sin(direction)-12.,0.)
        endif
        call ShowImage(DG_Rune[i],show and ((Wave_Mode==1 and i<=32) or (Wave_Mode==2 and i<=63)))
        set i=i+1
    endloop
    if not show then
        set Wave_Mode=0
        set Wave_FromGear=false
    endif
    set focus=null
endfunction

function Wave_FrameClick takes nothing returns nothing
    local integer slotCode=LoadInteger(Wave_Controls,0,GetHandleId(BlzGetTriggerFrame()))
    local unit hero=Player_GetHero(GetLocalPlayer())
    local item carried=null
    if GetLocalPlayer()==GetTriggerPlayer() and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) then
        set Wave_ClickCount=Wave_ClickCount+1
        set Wave_ArmedAt=TimerGetElapsed(NativeCDClock)
        if slotCode==3 then
            if GetUnitAbilityLevel(hero,'A17S')>0 then
                set Wave_Mode=2
                set Wave_FromGear=false
                set DG_UIMode=0
            endif
            set hero=null
            return
        elseif slotCode==1 then
            set carried=BlzUnitItemInEquipmentSlot(hero,EQUIPMENT_LOADOUT_SLOT_PRIMARY)
        elseif slotCode==2 then
            set carried=BlzUnitItemInEquipmentSlot(hero,EQUIPMENT_LOADOUT_SLOT_OFFHAND)
        elseif slotCode>=100 then
            set carried=BlzUnitItemInBagSlot(hero,slotCode-100)
        elseif slotCode>=10 then
            set carried=UnitItemInSlot(hero,slotCode-10)
        endif
        set Wave_Mode=Wave_CarriedMode(carried)
        set Wave_FromGear=false
        set DG_UIMode=0
    endif
    set carried=null
    set hero=null
endfunction

function Wave_CalculatorKey takes nothing returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    if GetLocalPlayer()==GetTriggerPlayer() and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) and not QuickGearChatOpen and not TravelVisible[GetPlayerId(GetLocalPlayer())] then
        if QuickGearChatEdit==null or not BlzFrameIsVisible(QuickGearChatEdit) then
            if GetUnitAbilityLevel(hero,'A17S')>0 then
                set Wave_Mode=2
                set Wave_FromGear=false
                set DG_UIMode=0
            endif
        endif
    endif
    set hero=null
endfunction

function Wave_Hook takes framehandle control,integer slotCode returns nothing
    local integer key=GetHandleId(control)
    if control!=null and not HaveSavedInteger(Wave_Controls,0,key) then
        call SaveInteger(Wave_Controls,0,key,slotCode)
        call BlzTriggerRegisterFrameEvent(Wave_Clicks,control,FRAMEEVENT_CONTROL_CLICK)
        // Native inventory controls may enter targeting on mouse-down rather
        // than dispatching the scripted-button control-click notification.
        if slotCode>=10 then
            call BlzTriggerRegisterFrameEvent(Wave_Clicks,control,FRAMEEVENT_MOUSE_DOWN)
        endif
        set Wave_HookCount=Wave_HookCount+1
    endif
endfunction

function Wave_BagChildren takes framehandle pane,integer first,integer depth returns integer
    local integer index=0
    local integer count=BlzFrameGetChildrenCount(pane)
    local framehandle control
    loop
        exitwhen index>=count or first>=30
        set control=BlzFrameGetChild(pane,index)
        if RAbsBJ(BlzFrameGetWidth(control)-.03125)<.001 and RAbsBJ(BlzFrameGetHeight(control)-.03125)<.001 then
            call Wave_Hook(control,100+first)
            set first=first+1
        elseif depth<3 then
            set first=Wave_BagChildren(control,first,depth+1)
        endif
        set index=index+1
    endloop
    set control=null
    return first
endfunction

function Wave_CacheBatch takes nothing returns nothing
    local integer last=Wave_Context+32
    local integer index
    local integer count
    local integer itemIndex
    local framehandle pane
    local framehandle control
    loop
        exitwhen Wave_Context>=last
        call Wave_Hook(BlzGetFrameByName("EquipmentButton_6",Wave_Context),1)
        call Wave_Hook(BlzGetFrameByName("EquipmentButton_7",Wave_Context),2)
        set pane=BlzGetFrameByName("SimpleEquipmentInventoryPanel",Wave_Context)
        set index=0
        if pane!=null then
          loop
            exitwhen index>=36
            set control=BlzGetFrameByName("InventoryButton_"+I2S(index),Wave_Context)
            if pane!=null and control!=null and BlzFrameGetParent(control)==pane then
                call Wave_Hook(control,100+index)
            elseif index<6 then
                call Wave_Hook(control,10+index)
            else
                call Wave_Hook(control,100+index-6)
            endif
            set index=index+1
          endloop
        endif
        // The extended bag's engine-generated children need not be exposed
        // through GetFrameByName. A complete 30-slot pane has the native order.
        if pane!=null then
            set count=BlzFrameGetChildrenCount(pane)
            if count==30 then
                set index=0
                loop
                    exitwhen index>=30
                    set control=BlzFrameGetChild(pane,index)
                    call Wave_Hook(control,100+index)
                    set index=index+1
                endloop
            else
                // Ignore the pane's background/scroll controls and recognize
                // engine item buttons by the installed native template size.
                set index=0
                set itemIndex=0
                loop
                    exitwhen index>=count or itemIndex>=30
                    set control=BlzFrameGetChild(pane,index)
                    if RAbsBJ(BlzFrameGetWidth(control)-.03125)<.001 and RAbsBJ(BlzFrameGetHeight(control)-.03125)<.001 then
                        call Wave_Hook(control,100+itemIndex)
                        set itemIndex=itemIndex+1
                    endif
                    set index=index+1
                endloop
            endif
            // Extended inventory cells may live in row containers. Those
            // buttons are generated by the engine, outside the FDF name table.
            set itemIndex=Wave_BagChildren(pane,0,0)
        endif
        set Wave_Context=Wave_Context+1
    endloop
    set pane=null
    set control=null
endfunction

function Wave_RefreshControls takes nothing returns nothing
    // Shared timer: never discover or allocate frames from a local bag-open
    // event. New native panels can appear after selecting a loaded job hero.
    if Wave_Context>=256 then
        set Wave_Context=0
    endif
    call Wave_CacheBatch()
endfunction

function Wave_Init takes nothing returns nothing
    local integer index=0
    // WAVE ITEM DEFINITIONS
    if Wave_Clicks!=null then
        call DestroyTrigger(Wave_Clicks)
        call DestroyTrigger(Wave_Keys)
        call FlushParentHashtable(Wave_Controls)
    endif
    set Wave_Clicks=CreateTrigger()
    set Wave_HookCount=0
    set Wave_Keys=CreateTrigger()
    call TriggerAddAction(Wave_Clicks,function Wave_FrameClick)
    call TriggerAddAction(Wave_Keys,function Wave_CalculatorKey)
    set Wave_Calculator=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,BlzGetAbilityPosY('A17S')*4+BlzGetAbilityPosX('A17S'))
    call Wave_Hook(Wave_Calculator,3)
    loop
        exitwhen index>=8
        call BlzTriggerRegisterPlayerKeyEvent(Wave_Keys,Player(index),OSKEY_E,0,true)
        set index=index+1
    endloop
    set index=0
    loop
        exitwhen index>=6
        call Wave_Hook(BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON,index),10+index)
        set index=index+1
    endloop
    set Wave_Context=0
    set index=0
    loop
        exitwhen index>=8
        call ExecuteFunc("Wave_CacheBatch")
        set index=index+1
    endloop
    if Wave_CacheClock==null then
        set Wave_CacheClock=CreateTimer()
    endif
    call TimerStart(Wave_CacheClock,.1,true,function Wave_RefreshControls)
endfunction

function Wave_MouseCommit takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() and GetTriggerEventId()!=EVENT_PLAYER_MOUSE_MOVE then
        // The native item click also emits a mouse event. Its coordinates can
        // still contain the previous world position; do not cancel the preview
        // on the very click that entered native item targeting.
        if BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT or (TimerGetElapsed(NativeCDClock)-Wave_ArmedAt>.08 and (BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0.)) then
            set Wave_Mode=0
            set Wave_FromGear=false
        endif
    endif
endfunction
