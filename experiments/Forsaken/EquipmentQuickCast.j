    hashtable QuickGearData=InitHashtable()
    framehandle array QuickGearButton
    framehandle array QuickGearIcon
    framehandle array QuickGearLabel
    framehandle array QuickGearCooldown
    framehandle array QuickGearTooltip
    framehandle array QuickGearTipText
    framehandle QuickGearAnchor=null
    trigger QuickGearClick=null
    trigger QuickGearKeys=null
    trigger QuickGearMouse=null
    trigger QuickGearSync=null
    trigger QuickGearChat=null
    boolean array QuickGearHeld
    boolean QuickGearChatOpen=false
    real QuickGearChatSentAt=-1.
    integer array QuickGearLastRaw
    integer array QuickGearLastSeconds
    integer QuickGearPending=-1
    integer QuickGearPendingItem=0
    integer QuickGearPendingMark=0
    integer QuickGearPendingHero=0
    framehandle QuickGearChatEdit=null
    real array QuickGearLastPress
    framehandle QuickGearRoot=null
    integer QuickGearScreenWidth=0
    integer QuickGearScreenHeight=0
    timer QuickGearUITimer=null
    trigger QuickGearChanges=null
    integer array QuickGearRevision
    integer QuickGearSeenRevision=-1
    unit QuickGearHero=null
    boolean QuickGearReady=false
    real array QuickGearEnds
    integer array QuickGearCast
    boolean array QuickGearActive
    boolean QuickGearShown=false
    integer QuickGearSeenCooldownRevision=-1
    framehandle array QuickGearCooldownPanel
    integer array QuickGearClockPool
    image array QuickGearPreviewImage
    image QuickGearTargetImage=null
    image array QuickGearRune
    integer QuickGearPath=0
    integer QuickGearFrameGeneration=0
    framehandle QuickGearCursor=null
    boolean QuickGearNativePreview=false
    framehandle array QuickGearNativeButton
    trigger QuickGearNativeClicks=null
    real array QuickGearPreviewRadius
    integer QuickGearPreviewCount=0
    integer QuickGearPreview=0
    real QuickGearMouseX=0.
    real QuickGearMouseY=0.
    boolean QuickGearMouseKnown=false
    boolean QuickGearTargetPreview=false
    framehandle array QuickGearWheelPanel
    framehandle array QuickGearWheelImage
    framehandle array QuickGearNativeWheel
    boolean QuickGearCustomKeys=false
    integer array QuickGearShownKey
    timer QuickGearWheelTimer=null
    integer array QuickGearWheelStep
    real array QuickGearDuration
    real QuickGearRetryUntil=0.
    trigger QuickGearBindings=null
    integer array QuickGearWeaponKey
    integer array QuickGearOffhandKey
    framehandle array QuickGearDigitPanel
    framehandle array QuickGearDigitImage
    integer array QuickGearDigitValue
    integer array QuickGearDigitCount
    framehandle array QuickGearNumberImage
    set QuickGearPreviewCount=6
    set QuickGearPreview=0
            set QuickGearPending=-1
            set QuickGearPending=slot
            set QuickGearPendingHero=GetUnitTypeId(hero)
            set QuickGearPendingItem=raw
            set QuickGearPendingMark=GetItemUserData(carried)
                set QuickGearPreview=LoadInteger(QuickGearData,32+IMaxBJ(1,GetUnitAbilityLevel(hero,cast)),cast)
        set QuickGearMouseX=BlzGetTriggerPlayerMouseX()
        set QuickGearMouseY=BlzGetTriggerPlayerMouseY()
        set QuickGearMouseKnown=true
            set QuickGearPending=-1
            set QuickGearPending=-1
            set QuickGearPending=-1
            set QuickGearChatOpen=false
        set QuickGearChatOpen=false
        set QuickGearChatOpen=not QuickGearChatOpen
        set QuickGearPending=-1
        set QuickGearChatOpen=false
        set QuickGearPending=-1
            set QuickGearChatOpen=BlzFrameIsVisible(QuickGearChatEdit)
            set QuickGearShown=false
        set QuickGearReady=false
        set QuickGearHero=null
        set QuickGearPending=-1
            set QuickGearRetryUntil=now+1.
            set QuickGearHero=hero
            set QuickGearSeenRevision=QuickGearRevision[pid]
            set QuickGearReady=true
            set QuickGearSeenCooldownRevision=cooldownRevision
            set QuickGearPending=-1
        set QuickGearShown=show
    if QuickGearClick==null then
    set QuickGearMouseKnown=false
    set QuickGearUITimer=null
    set QuickGearClick=null
    set QuickGearKeys=null
    set QuickGearMouse=null
    set QuickGearSync=null
    set QuickGearChat=null
    set QuickGearBindings=null
    set QuickGearChanges=null
    set QuickGearHero=null
    set QuickGearReady=false
    set QuickGearSeenRevision=-1
    set QuickGearShown=false
    set QuickGearSeenCooldownRevision=-1
    set QuickGearPending=-1
    set QuickGearChatOpen=false
    set QuickGearRoot=null
    set QuickGearScreenWidth=0
    set QuickGearScreenHeight=0
    set QuickGearRoot=BlzCreateSimpleFrame("QuickGearDock",origin,900)
    set QuickGearAnchor=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,7)
    set QuickGearChatEdit=BlzGetFrameByName("ChatEditBar",0)
    set QuickGearClick=CreateTrigger()
    set QuickGearKeys=CreateTrigger()
    set QuickGearMouse=CreateTrigger()
    set QuickGearSync=CreateTrigger()
    set QuickGearChat=CreateTrigger()
    set QuickGearBindings=CreateTrigger()
    set QuickGearChanges=CreateTrigger()
    set QuickGearUITimer=CreateTimer()
// FUNCTIONS
function QuickGear_Item takes unit hero,integer slot returns item
    if hero==null then
        return null
    endif
    if slot==0 then
        return BlzUnitItemInEquipmentSlot(hero,EQUIPMENT_LOADOUT_SLOT_PRIMARY)
    elseif slot==1 then
        return BlzUnitItemInEquipmentSlot(hero,EQUIPMENT_LOADOUT_SLOT_OFFHAND)
    endif
    return null
endfunction



function QuickGear_Field takes string data,integer wanted returns string
    local integer i=0
    local integer start=0
    local integer index=0
    loop
        exitwhen i>=StringLength(data)
        if SubString(data,i,i+1)==":" then
            if index==wanted then
                return SubString(data,start,i)
            endif
            set index=index+1
            set start=i+1
        endif
        set i=i+1
    endloop
    if index==wanted then
        return SubString(data,start,i)
    endif
    return ""
endfunction



function QuickGear_Receive takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local unit hero=Player_GetHero(owner)
    local string data=BlzGetTriggerSyncData()
    local integer slot=S2I(QuickGear_Field(data,0))
    local item carried=QuickGear_Item(hero,slot)
    local integer raw=GetItemTypeId(carried)
    local integer cast=LoadInteger(QuickGearData,0,raw)
    local integer mode=LoadInteger(QuickGearData,1,raw)
    local real x=S2R(QuickGear_Field(data,5))
    local real y=S2R(QuickGear_Field(data,6))
    local integer targetId=S2I(QuickGear_Field(data,4))
    local group candidates
    local unit target=null
    local unit candidate
    local boolean success=false
    if slot<0 or slot>1 or hero==null or GetOwningPlayer(hero)!=owner or GetWidgetLife(hero)<=.405 or GetUnitTypeId(hero)!=S2I(QuickGear_Field(data,1)) or carried==null or raw!=S2I(QuickGear_Field(data,2)) or GetItemUserData(carried)!=S2I(QuickGear_Field(data,3)) or cast==0 then
        set carried=null
        set hero=null
        set owner=null
        return
    endif
    if NativeCD_Left(hero,NativeCD_Pool(cast))<=.01 and BlzGetUnitAbilityCooldownRemaining(hero,cast)<=.01 and GetUnitState(hero,UNIT_STATE_MANA)>=BlzGetAbilityManaCost(cast,0) then
        if targetId!=0 and (mode==1 or mode==3) then
            set candidates=CreateGroup()
            call GroupEnumUnitsInRange(candidates,x,y,256.,null)
            loop
                set candidate=FirstOfGroup(candidates)
                exitwhen candidate==null
                call GroupRemoveUnit(candidates,candidate)
                if GetHandleId(candidate)==targetId then
                    set target=candidate
                endif
            endloop
            call DestroyGroup(candidates)
            set candidates=null
        endif
        if mode==0 then
            set success=UnitUseItem(hero,carried)
        elseif target!=null then
            set success=UnitUseItemTarget(hero,carried,target)
        elseif (mode==2 or mode==3) and x>=GetRectMinX(bj_mapInitialPlayableArea) and x<=GetRectMaxX(bj_mapInitialPlayableArea) and y>=GetRectMinY(bj_mapInitialPlayableArea) and y<=GetRectMaxY(bj_mapInitialPlayableArea) then
            set success=UnitUseItemPoint(hero,carried,x,y)
        endif

    endif
    set target=null
    set candidate=null
    set carried=null
    set hero=null
    set owner=null
endfunction



function QuickGear_Send takes integer slot,integer heroRaw,integer itemRaw,integer mark,integer targetId,real x,real y returns nothing
    call BlzSendSyncData("FFQuickGear",I2S(slot)+":"+I2S(heroRaw)+":"+I2S(itemRaw)+":"+I2S(mark)+":"+I2S(targetId)+":"+R2S(x)+":"+R2S(y))
endfunction


function QuickGear_InitPreviews takes nothing returns nothing
    local integer index=1
    // AREA PREVIEWS
    loop
        exitwhen index>QuickGearPreviewCount
        set QuickGearPreviewImage[index]=CreateImage("ReplaceableTextures\\Selection\\SpellAreaOfEffect.blp",2.*QuickGearPreviewRadius[index],2.*QuickGearPreviewRadius[index],0.,0.,0.,0.,0.,0.,0.,1)
        if GetHandleId(QuickGearPreviewImage[index])!=-1 then
            call SetImageRenderAlways(QuickGearPreviewImage[index],false)
            call ShowImage(QuickGearPreviewImage[index],false)
            call SetImageAboveWater(QuickGearPreviewImage[index],true,true)
        endif
        set index=index+1
    endloop
    set index=1
    loop
        exitwhen index>96
        set QuickGearRune[index]=CreateImage("DragoonRune.tga",24.,24.,0.,0.,0.,0.,0.,0.,0.,2)
        call SetImageRenderAlways(QuickGearRune[index],true)
        call SetImageAboveWater(QuickGearRune[index],true,true)
        call ShowImage(QuickGearRune[index],false)
        set index=index+1
    endloop
    // Unit-target gear needs feedback too. This is a local-only reticle at the
    // cursor; point-target gear continues to use its authored area indicator.
    set QuickGearTargetImage=CreateImage("DragoonRune.tga",64.,64.,0.,0.,0.,0.,0.,0.,0.,2)
    if GetHandleId(QuickGearTargetImage)!=-1 then
        call SetImageRenderAlways(QuickGearTargetImage,false)
        call ShowImage(QuickGearTargetImage,false)
        call SetImageAboveWater(QuickGearTargetImage,true,true)
    endif
endfunction



function QuickGear_ClearPreview takes nothing returns nothing
    local integer index=1
    loop
        exitwhen index>96
        call ShowImage(QuickGearRune[index],false)
        set index=index+1
    endloop
    set QuickGearPath=0
    set QuickGearNativePreview=false
    if QuickGearCursor!=null then
        call BlzFrameSetVisible(QuickGearCursor,false)
    endif
    call BlzEnableCursor(true)
    if QuickGearPreview>0 then
        if GetHandleId(QuickGearPreviewImage[QuickGearPreview])!=-1 then
            call SetImageRenderAlways(QuickGearPreviewImage[QuickGearPreview],false)
            call ShowImage(QuickGearPreviewImage[QuickGearPreview],false)
        endif
    endif
    if QuickGearTargetImage!=null and GetHandleId(QuickGearTargetImage)!=-1 then
        call SetImageRenderAlways(QuickGearTargetImage,false)
        call ShowImage(QuickGearTargetImage,false)
    endif
    set QuickGearTargetPreview=false
    set QuickGearPreview=0
endfunction



function QuickGear_MovePreview takes nothing returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    local integer index=1
    local real angle=0.
    local real direction=0.
    local real distance=0.
    local real width=0.
    local real x=0.
    local real y=0.
    local real side=0.
    if QuickGearTargetPreview and QuickGearCursor!=null then
        call BlzFrameSetAbsPoint(QuickGearCursor,FRAMEPOINT_CENTER,.8*I2R(BlzGetMouseScreenPosX())/I2R(BlzGetLocalClientWidth()),.6*(1.-I2R(BlzGetMouseScreenPosY())/I2R(BlzGetLocalClientHeight())))
        call BlzFrameSetVisible(QuickGearCursor,true)
        call BlzEnableCursor(false)
    endif
    if QuickGearPath>0 and hero!=null and QuickGearMouseKnown and not InventoryCinematicActive then
        set angle=Atan2(QuickGearMouseY-GetUnitY(hero),QuickGearMouseX-GetUnitX(hero))
        loop
            exitwhen index>96
            if QuickGearPath==1 then
                // Water_Touches: 800 travel, half-width 100 growing to 300.
                set distance=800.*I2R(ModuloInteger(index-1,32))/31.
                set width=100.+200.*distance/800.
                set side=0.
                if index>64 then
                    set side=width
                elseif index>32 then
                    set side=-width
                endif
                set direction=angle
            else
                // Blizzaga's authored three launch angles: -11.25, +11.25,
                // +33.75 degrees. Last damaging pulse is at distance 1000.
                set distance=1000.*I2R(ModuloInteger(index-1,32))/31.
                set direction=angle+(-11.25+22.5*I2R((index-1)/32))*bj_DEGTORAD
                set side=0.
            endif
            set x=GetUnitX(hero)+distance*Cos(direction)-side*Sin(direction)
            set y=GetUnitY(hero)+distance*Sin(direction)+side*Cos(direction)
            call SetImagePosition(QuickGearRune[index],x-12.,y-12.,0.)
            call ShowImage(QuickGearRune[index],true)
            set index=index+1
        endloop
    endif
    if QuickGearPreview>0 and QuickGearMouseKnown and not InventoryCinematicActive then
        if GetHandleId(QuickGearPreviewImage[QuickGearPreview])!=-1 then
            call SetImagePosition(QuickGearPreviewImage[QuickGearPreview],QuickGearMouseX-QuickGearPreviewRadius[QuickGearPreview],QuickGearMouseY-QuickGearPreviewRadius[QuickGearPreview],0.)
            call SetImageRenderAlways(QuickGearPreviewImage[QuickGearPreview],true)
            call ShowImage(QuickGearPreviewImage[QuickGearPreview],true)
        endif
    endif
    set hero=null
endfunction



function QuickGear_Request takes integer slot returns nothing
    local player owner=GetLocalPlayer()
    local unit hero=Player_GetHero(owner)
    local item carried=QuickGear_Item(hero,slot)
    local integer raw=GetItemTypeId(carried)
    local integer cast=LoadInteger(QuickGearData,0,raw)
    call QuickGear_ClearPreview()
    if hero!=null and GetWidgetLife(hero)>.405 and IsUnitSelected(hero,owner) and carried!=null and cast!=0 then
        if LoadInteger(QuickGearData,1,raw)==0 then
            set QuickGearPending=-1
            call QuickGear_Send(slot,GetUnitTypeId(hero),raw,GetItemUserData(carried),0,0.,0.)
        else
            set QuickGearPending=slot
            set QuickGearPendingHero=GetUnitTypeId(hero)
            set QuickGearPendingItem=raw
            set QuickGearPendingMark=GetItemUserData(carried)
            set QuickGearTargetPreview=true
            set QuickGearPath=LoadInteger(QuickGearData,2,cast)
            if LoadInteger(QuickGearData,1,raw)>=2 and QuickGearPath==0 then
                set QuickGearPreview=LoadInteger(QuickGearData,32+IMaxBJ(1,GetUnitAbilityLevel(hero,cast)),cast)
                call QuickGear_MovePreview()
            endif
            call QuickGear_MovePreview()

        endif
    endif
    set carried=null
    set hero=null
    set owner=null
endfunction



function QuickGear_Mouse takes nothing returns nothing
    local unit target
    local integer targetId=0
    if GetLocalPlayer()==GetTriggerPlayer() and GetTriggerEventId()==EVENT_PLAYER_MOUSE_MOVE then
        set QuickGearMouseX=BlzGetTriggerPlayerMouseX()
        set QuickGearMouseY=BlzGetTriggerPlayerMouseY()
        set QuickGearMouseKnown=true
        call QuickGear_MovePreview()
        return
    endif
    if GetLocalPlayer()==GetTriggerPlayer() and QuickGearNativePreview then
        call QuickGear_ClearPreview()
    elseif GetLocalPlayer()==GetTriggerPlayer() and QuickGearPending>=0 then
        if BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_RIGHT then
            set QuickGearPending=-1
            call QuickGear_ClearPreview()
        elseif BlzGetTriggerPlayerMouseButton()==MOUSE_BUTTON_TYPE_LEFT then
            set target=BlzGetMouseFocusUnit()
            if target!=null then
                set targetId=GetHandleId(target)
            endif
            call QuickGear_Send(QuickGearPending,QuickGearPendingHero,QuickGearPendingItem,QuickGearPendingMark,targetId,BlzGetTriggerPlayerMouseX(),BlzGetTriggerPlayerMouseY())
            set QuickGearPending=-1
            call QuickGear_ClearPreview()
        endif
    endif
    set target=null
endfunction

function QuickGear_NativePath takes integer cast returns nothing
    call QuickGear_ClearPreview()
    set QuickGearPending=-1
    set QuickGearPath=LoadInteger(QuickGearData,2,cast)
    set QuickGearNativePreview=QuickGearPath>0
    if QuickGearNativePreview then
        call QuickGear_MovePreview()
    endif
endfunction

function QuickGear_NativeClick takes nothing returns nothing
    local integer index=0
    local integer cast=0
    local unit hero=Player_GetHero(GetLocalPlayer())
    local item carried=null
    if GetLocalPlayer()==GetTriggerPlayer() and hero!=null then
        loop
            exitwhen index>=18
            if BlzGetTriggerFrame()==QuickGearNativeButton[index] then
                if index<6 then
                    set carried=UnitItemInSlot(hero,index)
                    set cast=LoadInteger(QuickGearData,0,GetItemTypeId(carried))
                else
                    set cast=LoadInteger(QuickGearData,6,index-6)
                    if GetUnitAbilityLevel(hero,cast)<=0 then
                        set cast=0
                    endif
                endif
                call QuickGear_NativePath(cast)
            endif
            set index=index+1
        endloop
    endif
    set carried=null
    set hero=null
endfunction



function QuickGear_KeyName takes integer keycode returns string
    if keycode>=48 and keycode<=57 then
        return SubString("0123456789",keycode-48,keycode-47)
    endif
    return SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZ",keycode-65,keycode-64)
endfunction



function QuickGear_KeyCode takes string letter returns integer
    local integer i=0
    loop
        exitwhen i>=36
        if SubString("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",i,i+1)==letter then
            if i>=26 then
                return 48+i-26
            endif
            return 65+i
        endif
        set i=i+1
    endloop
    return 0
endfunction


function QuickGear_Bindings takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local integer pid=GetPlayerId(owner)
    local string text=StringCase(GetEventPlayerChatString(),true)
    local string args=""
    local string c
    local integer weapon=0
    local integer offhand=0
    local integer i
    if SubString(text,0,12)=="-GEARHOTKEYS" then
        set i=12
    elseif SubString(text,0,11)=="-GEARHOTKEY" then
        set i=11
    else
        set owner=null
        return
    endif
    // Keep only the key letters: spaces and commas separate them. Anything else (a word such as
    // "help") is not a key list, so it changes nothing.
    loop
        exitwhen i>=StringLength(text)
        set c=SubString(text,i,i+1)
        if c!=" " and c!="," then
            set args=args+c
        endif
        set i=i+1
    endloop
    if args=="RESET" then
        set weapon=70
        set offhand=71
    elseif StringLength(args)==2 then
        set weapon=QuickGear_KeyCode(SubString(args,0,1))
        set offhand=QuickGear_KeyCode(SubString(args,1,2))
    endif
    if weapon!=0 and offhand!=0 and weapon!=offhand then
        set QuickGearWeaponKey[pid]=weapon
        set QuickGearOffhandKey[pid]=offhand
        if GetLocalPlayer()==owner then
            set QuickGearPending=-1
            set QuickGearChatOpen=false
            call QuickGear_ClearPreview()
        endif
        call DisplayTimedTextToPlayer(owner,0.,0.,8.,"Gear hotkeys: weapon "+QuickGear_KeyName(weapon)+", offhand "+QuickGear_KeyName(offhand)+".")
    else
        call DisplayTimedTextToPlayer(owner,0.,0.,8.,"Gear hotkeys are weapon "+QuickGear_KeyName(QuickGearWeaponKey[pid])+", offhand "+QuickGear_KeyName(QuickGearOffhandKey[pid])+". Change them with -gearhotkey F G (two different letters A-Z or numbers 0-9), or -gearhotkey reset.")
    endif
    set owner=null
endfunction



function QuickGear_Input takes nothing returns nothing
    local integer slot=0
    local oskeytype key=null
    if GetLocalPlayer()!=GetTriggerPlayer() then
        return
    endif
    if GetTriggerEventId()==EVENT_PLAYER_CHAT then
        set QuickGearChatOpen=false
        set QuickGearChatSentAt=TimerGetElapsed(ForsakenPanelClock)
        return
    endif
    set key=BlzGetTriggerPlayerKey()
    if key==OSKEY_RETURN and BlzGetTriggerPlayerIsKeyDown() then
        // The Enter that sends a chat message arrives just after the message itself; it closes the
        // chat box rather than opening it, so it must not flip the flag back to "open".
        if TimerGetElapsed(ForsakenPanelClock)-QuickGearChatSentAt<.25 then
            set QuickGearChatOpen=false
        else
            set QuickGearChatOpen=not QuickGearChatOpen
        endif
        set QuickGearPending=-1
        call QuickGear_ClearPreview()
        return
    elseif key==OSKEY_ESCAPE then
        set QuickGearChatOpen=false
        set QuickGearPending=-1
        call QuickGear_ClearPreview()
        return
    endif
    if key==ConvertOsKeyType(QuickGearOffhandKey[GetPlayerId(GetTriggerPlayer())]) then
        set slot=1
    elseif key!=ConvertOsKeyType(QuickGearWeaponKey[GetPlayerId(GetTriggerPlayer())]) then
        if BlzGetTriggerPlayerIsKeyDown() and not QuickGearChatOpen and not TravelVisible[GetPlayerId(GetTriggerPlayer())] then
            set slot=LoadInteger(QuickGearData,5,GetHandleId(key))
            if slot!=0 and GetUnitAbilityLevel(Player_GetHero(GetLocalPlayer()),slot)>0 then
                call QuickGear_NativePath(slot)
            endif
        endif
        return
    endif
    if TravelVisible[GetPlayerId(GetTriggerPlayer())] then
        return
    endif
    if not BlzGetTriggerPlayerIsKeyDown() then
        set QuickGearHeld[slot]=false
    elseif TimerGetElapsed(ForsakenPanelClock)-QuickGearLastPress[slot]>=.25 then
        set QuickGearHeld[slot]=true
        set QuickGearLastPress[slot]=TimerGetElapsed(ForsakenPanelClock)
        if QuickGearChatEdit!=null then
            set QuickGearChatOpen=BlzFrameIsVisible(QuickGearChatEdit)
        endif
        if not QuickGearChatOpen then
            call QuickGear_Request(slot)
        endif
    endif
endfunction



function QuickGear_Click takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        if BlzGetTriggerFrame()==QuickGearButton[0] then
            call QuickGear_Request(0)
        elseif BlzGetTriggerFrame()==QuickGearButton[1] then
            call QuickGear_Request(1)
        endif
    endif
endfunction



function QuickGear_Layout takes nothing returns nothing
    call BlzFrameClearAllPoints(QuickGearRoot)
    call BlzFrameSetPoint(QuickGearRoot,FRAMEPOINT_TOPLEFT,QuickGearAnchor,FRAMEPOINT_TOPRIGHT,.012,0.)
endfunction


function QuickGear_UpdateCooldowns takes unit hero returns nothing
    local integer slot=0
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    local integer pool
    loop
        exitwhen slot>=2
        set pool=NativeCD_Pool(QuickGearCast[slot])
        // The gear cooldown is committed against NativeCDClock. Copy that exact
        // deadline once; never rebase it against the UI clock or keep a stale max.
        set QuickGearEnds[slot]=LoadReal(NativeCDData,32+pid,pool)
        set QuickGearDuration[slot]=LoadReal(NativeCDData,48+pid,pool)
        set QuickGearClockPool[slot]=pool
        set slot=slot+1
    endloop
endfunction


function QuickGear_Draw takes unit hero,player viewer returns nothing
    local integer slot=0
    local item carried
    loop
        exitwhen slot>=2
        set carried=QuickGear_Item(hero,slot)
        set QuickGearCast[slot]=LoadInteger(QuickGearData,0,GetItemTypeId(carried))
        set QuickGearActive[slot]=carried!=null and QuickGearCast[slot]!=0
        set QuickGearLastRaw[slot]=GetItemTypeId(carried)
        call BlzFrameSetVisible(QuickGearButton[slot],QuickGearActive[slot])
        call BlzFrameSetVisible(QuickGearIcon[slot],QuickGearActive[slot])
        if QuickGearActive[slot] and QuickGearIcon[slot]!=null then
            call BlzFrameSetTexture(QuickGearIcon[slot],BlzGetItemIconPath(carried),0,true)
        endif
        set QuickGearLastSeconds[slot]=-1
        set slot=slot+1
    endloop
    call QuickGear_UpdateCooldowns(hero)
    set carried=null
endfunction

function QuickGear_EquipmentChanged takes unit hero returns boolean
    local integer slot=0
    local item carried
    loop
        exitwhen slot>=2
        set carried=QuickGear_Item(hero,slot)
        if GetItemTypeId(carried)!=QuickGearLastRaw[slot] then
            set carried=null
            return true
        endif
        set slot=slot+1
    endloop
    set carried=null
    return false
endfunction



function QuickGear_DrawWheel takes integer slot,boolean show,real now returns nothing
    local real remaining=RMaxBJ(0.,QuickGearEnds[slot]-now)
    local boolean visible=show and QuickGearActive[slot]
    local boolean cooling=visible and remaining>.01
    if QuickGearWheelPanel[slot]==null or QuickGearWheelImage[slot]==null then
        return
    endif
    // The painted wheel stays empty; the game's own cooldown model draws the sweep.
    if QuickGearWheelStep[slot]!=0 then
        set QuickGearWheelStep[slot]=0
        call BlzFrameSetTexture(QuickGearWheelImage[slot],"war3mapImported\\QuickGearWheelCD00.tga",0,true)
    endif
    if QuickGearNativeWheel[slot]!=null then
        if cooling then
            // A status bar plays its model at the bar's value: 0 = cooldown just started, 1 = ready.
            call BlzFrameSetValue(QuickGearNativeWheel[slot],1.-RMinBJ(1.,remaining/RMaxBJ(.01,QuickGearDuration[slot])))
        endif
        if BlzFrameIsVisible(QuickGearNativeWheel[slot])!=cooling then
            call BlzFrameSetVisible(QuickGearNativeWheel[slot],cooling)
        endif
    endif
    if BlzFrameIsVisible(QuickGearWheelPanel[slot])!=visible then
        call BlzFrameSetVisible(QuickGearWheelPanel[slot],visible)
    endif
endfunction


// Redraws the cooldown sweeps between the 0.1 s panel polls so they turn smoothly. Runs on each
// client for its own player only and touches nothing but local frames, so it cannot desync.
function QuickGear_WheelTick takes nothing returns nothing
    local real now=TimerGetElapsed(NativeCDClock)
    local integer pid=GetPlayerId(GetLocalPlayer())
    // Once -gearhotkey changes this player's keys, blank the buttons' F/G letters so they do not show
    // the old keys. Two comparisons per tick while nothing changes.
    if pid<8 and (QuickGearShownKey[0]!=QuickGearWeaponKey[pid] or QuickGearShownKey[1]!=QuickGearOffhandKey[pid]) then
        if QuickGearShownKey[0]>0 or QuickGearCustomKeys then
            set QuickGearCustomKeys=true
            if QuickGearLabel[0]!=null then
                call BlzFrameSetText(QuickGearLabel[0],"")
            endif
            if QuickGearLabel[1]!=null then
                call BlzFrameSetText(QuickGearLabel[1],"")
            endif
        endif
        set QuickGearShownKey[0]=QuickGearWeaponKey[pid]
        set QuickGearShownKey[1]=QuickGearOffhandKey[pid]
    endif
    // Nothing to animate unless the buttons are shown and one is cooling down; the 0.1 s panel
    // poll still hides the wheel when a cooldown ends.
    if not QuickGearShown or (QuickGearEnds[0]<=now and QuickGearEnds[1]<=now) then
        return
    endif
    call QuickGear_DrawWheel(0,true,now)
    call QuickGear_DrawWheel(1,true,now)
endfunction


// The buttons show no countdown seconds, only the cooldown wheel; the panel poll still calls this.
function QuickGear_SetCountdown takes integer slot,integer seconds returns nothing
endfunction


function QuickGear_Poll takes nothing returns nothing
    local player viewer=GetLocalPlayer()
    local integer pid=GetPlayerId(viewer)
    local unit hero=Player_GetHero(viewer)
    local integer slot=0
    local integer seconds
    local boolean show=false
    local integer cooldownRevision
    local boolean faceWasHidden
    local real now=TimerGetElapsed(NativeCDClock)
    if pid>=8 then
        call BlzFrameSetVisible(QuickGearRoot,false)
        call BlzFrameSetVisible(QuickGearIcon[0],false)
        call BlzFrameSetVisible(QuickGearIcon[1],false)
    elseif FFL_Phase[pid]!=0 or FFN_State[pid]!=0 or hero==null then
        call BlzFrameSetVisible(QuickGearIcon[0],false)
        call BlzFrameSetVisible(QuickGearIcon[1],false)
        if QuickGearShown then
            call BlzFrameSetVisible(QuickGearRoot,false)
            set QuickGearShown=false
        endif
        set QuickGearReady=false
        set QuickGearHero=null
        set QuickGearPending=-1
        call QuickGear_ClearPreview()
    else
        if not QuickGearReady or QuickGearHero!=hero then
            set QuickGearRetryUntil=now+1.
        endif
        // Read the two live slots every poll. Saved UI caches and equip events
        // are insufficient after a checkpoint recreates the equipment frames.
        if true then
            call QuickGear_Draw(hero,viewer)
            set QuickGearHero=hero
            set QuickGearSeenRevision=QuickGearRevision[pid]
            set QuickGearReady=true
        endif
        set cooldownRevision=LoadInteger(NativeCDData,32+pid,0)
        if cooldownRevision!=QuickGearSeenCooldownRevision then
            call QuickGear_UpdateCooldowns(hero)
            set QuickGearSeenCooldownRevision=cooldownRevision
        endif
        set show=not InventoryCinematicActive and IsUnitSelected(hero,viewer) and (QuickGearActive[0] or QuickGearActive[1])
        if InventoryCinematicActive or not IsUnitSelected(hero,viewer) then
            set QuickGearPending=-1
            call QuickGear_ClearPreview()
        endif
        if show!=BlzFrameIsVisible(QuickGearRoot) then
            call BlzFrameSetVisible(QuickGearRoot,show)
        endif
        set QuickGearShown=show
        if QuickGearPending>=0 or QuickGearNativePreview then
            call QuickGear_MovePreview()
        endif
        loop
            exitwhen slot>=2
            call BlzFrameSetVisible(QuickGearIcon[slot],show and QuickGearActive[slot])
            if BlzFrameIsVisible(QuickGearButton[slot])!=QuickGearActive[slot] then
                call BlzFrameSetVisible(QuickGearButton[slot],QuickGearActive[slot])
            endif
            set faceWasHidden=QuickGearWheelPanel[slot]!=null and not BlzFrameIsVisible(QuickGearWheelPanel[slot])
            call QuickGear_DrawWheel(slot,show,now)
            set seconds=R2I(RMaxBJ(0.,QuickGearEnds[slot]-now)+.999)
            if show and QuickGearActive[slot] and (seconds!=QuickGearLastSeconds[slot] or faceWasHidden) then
                call QuickGear_SetCountdown(slot,seconds)
                set QuickGearLastSeconds[slot]=seconds
            endif
            set slot=slot+1
        endloop
    endif
    set hero=null
    set viewer=null
endfunction


function QuickGear_Changed takes nothing returns nothing
    local integer pid=GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
    if pid>=0 and pid<8 then
        set QuickGearRevision[pid]=QuickGearRevision[pid]+1
    endif
endfunction



function QuickGear_Reset takes nothing returns nothing
    local integer slot=0
    if QuickGearClick==null then
        return
    endif
    call QuickGear_ClearPreview()
    set slot=1
    loop
        exitwhen slot>96
        call DestroyImage(QuickGearRune[slot])
        set QuickGearRune[slot]=null
        set slot=slot+1
    endloop
    if QuickGearCursor!=null then
        call BlzDestroyFrame(QuickGearCursor)
        set QuickGearCursor=null
    endif
    set slot=1
    loop
        exitwhen slot>QuickGearPreviewCount
        if GetHandleId(QuickGearPreviewImage[slot])!=-1 then
            call DestroyImage(QuickGearPreviewImage[slot])
        endif
        set QuickGearPreviewImage[slot]=null
        set slot=slot+1
    endloop
    if QuickGearTargetImage!=null then
        call DestroyImage(QuickGearTargetImage)
        set QuickGearTargetImage=null
    endif
    set slot=0
    set QuickGearMouseKnown=false
    call PauseTimer(QuickGearUITimer)
    call DestroyTimer(QuickGearUITimer)
    set QuickGearUITimer=null
    call DestroyTrigger(QuickGearClick)
    call DestroyTrigger(QuickGearKeys)
    call DestroyTrigger(QuickGearMouse)
    call DestroyTrigger(QuickGearSync)
    call DestroyTrigger(QuickGearChat)
    call DestroyTrigger(QuickGearBindings)
    call DestroyTrigger(QuickGearChanges)
    call DestroyTrigger(QuickGearNativeClicks)
    set QuickGearNativeClicks=null
    set QuickGearClick=null
    set QuickGearKeys=null
    set QuickGearMouse=null
    set QuickGearSync=null
    set QuickGearChat=null
    set QuickGearBindings=null
    set QuickGearChanges=null
    set QuickGearHero=null
    set QuickGearReady=false
    set QuickGearSeenRevision=-1
    set QuickGearShown=false
    set QuickGearSeenCooldownRevision=-1
    set QuickGearPending=-1
    set QuickGearChatOpen=false
    loop
        exitwhen slot>=2
        if QuickGearWheelPanel[slot]!=null then
            call BlzDestroyFrame(QuickGearWheelPanel[slot])
        endif
        if QuickGearNativeWheel[slot]!=null then
            call BlzDestroyFrame(QuickGearNativeWheel[slot])
            set QuickGearNativeWheel[slot]=null
        endif
        call BlzDestroyFrame(QuickGearButton[slot])
        call BlzDestroyFrame(QuickGearIcon[slot])

        set QuickGearButton[slot]=null
        set QuickGearNumberImage[slot]=null
        set QuickGearWheelPanel[slot]=null
        set QuickGearWheelImage[slot]=null
        set QuickGearTooltip[slot]=null
        set QuickGearHeld[slot]=false
        set QuickGearLastPress[slot]=-1.
        set QuickGearLastRaw[slot]=0
        set QuickGearLastSeconds[slot]=0
        set slot=slot+1
    endloop
    call BlzDestroyFrame(QuickGearRoot)
    set QuickGearRoot=null
    set QuickGearScreenWidth=0
    set QuickGearScreenHeight=0
endfunction



function QuickGear_Init takes nothing returns nothing
    local framehandle origin=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
    local integer slot=0
    local integer pid=0
    local integer modifier
    local integer keycode
    if QuickGearClick!=null then
        return
    endif
    // ITEM CATALOGUE
    set QuickGearFrameGeneration=QuickGearFrameGeneration+1
    call QuickGear_InitPreviews()
    set QuickGearCursor=BlzCreateFrameByType("BACKDROP","QuickGearTargetCursor",origin,"",0)
    call BlzFrameSetTexture(QuickGearCursor,"QuickGearTarget.tga",0,true)
    call BlzFrameSetSize(QuickGearCursor,.028,.028)
    call BlzFrameSetLevel(QuickGearCursor,200)
    call BlzFrameSetEnable(QuickGearCursor,false)
    call BlzFrameSetVisible(QuickGearCursor,false)
    call BlzLoadTOCFile("war3mapImported\\QuickGear.toc")
    set QuickGearRoot=BlzCreateSimpleFrame("QuickGearDock",origin,900)
    set QuickGearAnchor=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,7)
    call BlzFrameSetSize(QuickGearRoot,.040,.086)
    call BlzFrameSetLevel(QuickGearRoot,120)
    call QuickGear_Layout()
    call BlzFrameSetVisible(QuickGearRoot,false)
    set QuickGearChatEdit=BlzGetFrameByName("ChatEditBar",0)

    set QuickGearClick=CreateTrigger()
    set QuickGearKeys=CreateTrigger()
    set QuickGearMouse=CreateTrigger()
    set QuickGearSync=CreateTrigger()
    set QuickGearChat=CreateTrigger()
    set QuickGearBindings=CreateTrigger()
    set QuickGearChanges=CreateTrigger()
    set QuickGearNativeClicks=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(QuickGearChanges,EVENT_PLAYER_UNIT_EQUIP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(QuickGearChanges,EVENT_PLAYER_UNIT_UNEQUIP_ITEM)
    call TriggerAddAction(QuickGearChanges,function QuickGear_Changed)
    call TriggerAddAction(QuickGearClick,function QuickGear_Click)
    call TriggerAddAction(QuickGearKeys,function QuickGear_Input)
    call TriggerAddAction(QuickGearChat,function QuickGear_Input)
    call TriggerAddAction(QuickGearBindings,function QuickGear_Bindings)
    call TriggerAddAction(QuickGearMouse,function QuickGear_Mouse)
    call TriggerAddAction(QuickGearSync,function QuickGear_Receive)
    set slot=0
    loop
        exitwhen slot>=18
        if slot<6 then
            set QuickGearNativeButton[slot]=BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON,slot)
        else
            set QuickGearNativeButton[slot]=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,slot-6)
        endif
        call BlzTriggerRegisterFrameEvent(QuickGearNativeClicks,QuickGearNativeButton[slot],FRAMEEVENT_CONTROL_CLICK)
        set slot=slot+1
    endloop
    set slot=0
    call TriggerAddAction(QuickGearNativeClicks,function QuickGear_NativeClick)
    loop
        exitwhen pid>=8
        call BlzTriggerRegisterPlayerSyncEvent(QuickGearSync,Player(pid),"FFQuickGear",false)
        call TriggerRegisterPlayerEvent(QuickGearMouse,Player(pid),EVENT_PLAYER_MOUSE_DOWN)
        call TriggerRegisterPlayerEvent(QuickGearMouse,Player(pid),EVENT_PLAYER_MOUSE_MOVE)
        call TriggerRegisterPlayerChatEvent(QuickGearChat,Player(pid),"",false)
        call TriggerRegisterPlayerChatEvent(QuickGearBindings,Player(pid),"-gearhotkey",false)
        if QuickGearWeaponKey[pid]==0 then
            set QuickGearWeaponKey[pid]=70
        endif
        if QuickGearOffhandKey[pid]==0 then
            set QuickGearOffhandKey[pid]=71
        endif
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
        set modifier=0
        loop
            exitwhen modifier>=16
            call BlzTriggerRegisterPlayerKeyEvent(QuickGearKeys,Player(pid),OSKEY_RETURN,modifier,true)
            set modifier=modifier+1
        endloop
        set pid=pid+1
    endloop
    loop
        exitwhen slot>=2
        set QuickGearButton[slot]=BlzCreateSimpleFrame("QuickGearItemButton",QuickGearRoot,slot+900+10*QuickGearFrameGeneration)
        call BlzFrameSetSize(QuickGearButton[slot],.040,.040)
        call BlzFrameSetPoint(QuickGearButton[slot],FRAMEPOINT_TOPLEFT,QuickGearRoot,FRAMEPOINT_TOPLEFT,0.,-I2R(slot)*.046)
        call BlzFrameSetLevel(QuickGearButton[slot],121)
        // Resolve special children on every client during shared startup.
        // Ordinary backdrop handles survive texture changes correctly; named
        // simple-texture lookups can retain the previous checkpoint's children.
        set QuickGearIcon[slot]=BlzCreateFrameByType("BACKDROP","QuickGearLiveIcon",origin,"",slot+10*QuickGearFrameGeneration)
        call BlzFrameSetAllPoints(QuickGearIcon[slot],QuickGearButton[slot])
        call BlzFrameSetLevel(QuickGearIcon[slot],121)
        call BlzFrameSetEnable(QuickGearIcon[slot],false)
        set QuickGearLabel[slot]=BlzGetFrameByName("QuickGearItemKey",slot+900+10*QuickGearFrameGeneration)
        set QuickGearShownKey[slot]=-1
        set QuickGearWheelPanel[slot]=BlzCreateSimpleFrame("QuickGearClockFace",QuickGearRoot,940+slot)
        set QuickGearWheelImage[slot]=BlzGetFrameByName("QuickGearWheelTexture",940+slot)
        set QuickGearNumberImage[slot]=null
        if QuickGearWheelPanel[slot]!=null then
            call BlzFrameSetSize(QuickGearWheelPanel[slot],.040,.040)
            call BlzFrameSetPoint(QuickGearWheelPanel[slot],FRAMEPOINT_TOPLEFT,QuickGearRoot,FRAMEPOINT_TOPLEFT,0.,-I2R(slot)*.046)
            call BlzFrameSetLevel(QuickGearWheelPanel[slot],122)
            call BlzFrameSetVisible(QuickGearWheelPanel[slot],false)
        endif
        set QuickGearWheelStep[slot]=-1
        // The game's cooldown wheel model on an ordinary status bar laid over the button.
        set QuickGearNativeWheel[slot]=BlzCreateFrameByType("STATUSBAR","QuickGearNativeWheel",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",950+slot)
        if QuickGearNativeWheel[slot]!=null then
            call BlzFrameSetModel(QuickGearNativeWheel[slot],"UI\\Feedback\\Cooldown\\UI-Cooldown-Indicator.mdl",0)
            call BlzFrameSetMinMaxValue(QuickGearNativeWheel[slot],0.,1.)
            call BlzFrameSetValue(QuickGearNativeWheel[slot],1.)
            call BlzFrameSetAllPoints(QuickGearNativeWheel[slot],QuickGearButton[slot])
            call BlzFrameSetVisible(QuickGearNativeWheel[slot],false)
        endif
        if QuickGearIcon[slot]==null or QuickGearLabel[slot]==null then
            call BlzFrameSetVisible(QuickGearRoot,false)
            set origin=null
            return
        endif
        if slot==0 then
            call BlzFrameSetText(QuickGearLabel[slot],QuickGear_KeyName(QuickGearWeaponKey[GetPlayerId(GetLocalPlayer())]))
        else
            call BlzFrameSetText(QuickGearLabel[slot],QuickGear_KeyName(QuickGearOffhandKey[GetPlayerId(GetLocalPlayer())]))
        endif
        // Simple buttons must not be linked to ordinary tooltip frame trees.
        // Special texture/string children receive only their supported text/texture setters.
        call BlzFrameSetTexture(QuickGearIcon[slot],"ReplaceableTextures\\CommandButtons\\BTNBackpack.blp",0,true)
        set QuickGearLastRaw[slot]=-1
        call BlzFrameSetVisible(QuickGearButton[slot],true)
        call BlzTriggerRegisterFrameEvent(QuickGearClick,QuickGearButton[slot],FRAMEEVENT_CONTROL_CLICK)
        set slot=slot+1
    endloop
    set QuickGearUITimer=CreateTimer()
    call TimerStart(QuickGearUITimer,.1,true,function QuickGear_Poll)
    if QuickGearWheelTimer==null then
        set QuickGearWheelTimer=CreateTimer()
        call TimerStart(QuickGearWheelTimer,.05,true,function QuickGear_WheelTick)
    endif
    set origin=null
endfunction
