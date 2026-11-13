globals
    framehandle array GearBagText61
    integer GearBagTextCount61=0
    framehandle GearBagTip61=null
    framehandle GearBagUber61=null
    hashtable GearBagSeen61=InitHashtable()
    string array GearBagNames61
    integer array GearBagCasts61
    integer GearBagNameCount61=0
    boolean GearBagLeft61=false
    integer GearBagArms61=0
    string GearBagLast61=""
    integer GearBagHoverCast61=0
    real GearBagHoverAt61=-1.
    integer GearBagHoverX61=0
    integer GearBagHoverY61=0
    real GearBagNextRead61=0.
endglobals

function GearBag_Normalize61 takes string value returns string
    local integer i=0
    local integer size=IMinBJ(160,StringLength(value))
    local string result=""
    local string part
    loop
        exitwhen i>=size
        set part=SubString(value,i,i+2)
        if part=="|c" then
            set i=i+10
        elseif part=="|r" then
            set i=i+2
        elseif part=="|n" then
            set result=result+" "
            set i=i+2
        else
            set result=result+SubString(value,i,i+1)
            set i=i+1
        endif
    endloop
    return StringCase(result,false)
endfunction

function GearBag_Find61 takes string value returns integer
    local integer i=1
    local integer offset=0
    local integer size=StringLength(value)
    local integer length=0
    loop
        exitwhen i>GearBagNameCount61
        set length=StringLength(GearBagNames61[i])
        set offset=0
        loop
            exitwhen length==0 or offset+length>size or offset>12
            if SubString(value,offset,offset+length)==GearBagNames61[i] then
                return GearBagCasts61[i]
            endif
            set offset=offset+1
        endloop
        set i=i+1
    endloop
    return 0
endfunction

function GearBag_Add61 takes integer raw,integer cast returns nothing
    local string name=GearBag_Normalize61(GetObjectName(raw))
    local integer i=1
    if name=="" then
        return
    endif
    loop
        exitwhen i>GearBagNameCount61
        if GearBagNames61[i]==name then
            return
        endif
        set i=i+1
    endloop
    set GearBagNameCount61=GearBagNameCount61+1
    set GearBagNames61[GearBagNameCount61]=name
    set GearBagCasts61[GearBagNameCount61]=cast
endfunction

function GearBag_Keep61 takes framehandle text returns nothing
    if text!=null and GetHandleId(text)>0 and not HaveSavedBoolean(GearBagSeen61,0,GetHandleId(text)) and GearBagTextCount61<64 then
        call SaveBoolean(GearBagSeen61,0,GetHandleId(text),true)
        set GearBagText61[GearBagTextCount61]=text
        set GearBagTextCount61=GearBagTextCount61+1
    endif
endfunction

function GearBag_CacheTip61 takes framehandle tip returns nothing
    local integer i=0
    local integer count=0
    local framehandle child=null
    if tip==null or GetHandleId(tip)<=0 then
        return
    endif
    call GearBag_Keep61(tip)
    // Normal tooltip frames only; never traverse native Simple inventory panes.
    set count=IMinBJ(8,BlzFrameGetChildrenCount(tip))
    loop
        exitwhen i>=count
        set child=BlzFrameGetChild(tip,i)
        call GearBag_Keep61(child)
        set i=i+1
    endloop
    set child=null
endfunction

function GearBag_Init61 takes nothing returns nothing
    local integer context=0
    set GearBagTip61=BlzGetOriginFrame(ORIGIN_FRAME_TOOLTIP,0)
    set GearBagUber61=BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP,0)
    set GearBagTextCount61=0
    call FlushParentHashtable(GearBagSeen61)
    call GearBag_CacheTip61(GearBagTip61)
    call GearBag_CacheTip61(GearBagUber61)
    loop
        exitwhen context>=8
        call GearBag_Keep61(BlzGetFrameByName("UbertipTitle",context))
        call GearBag_Keep61(BlzGetFrameByName("UbertipText",context))
        call GearBag_Keep61(BlzGetFrameByName("TooltipText",context))
        call GearBag_Keep61(BlzGetFrameByName("SimpleTooltipText",context))
        set context=context+1
    endloop
    set GearBagLeft61=false
    set GearBagHoverCast61=0
    set GearBagNextRead61=0.
    call ExecuteFunc("GearBag_Names61")
endfunction

function GearBag_Poll61 takes nothing returns nothing
    local boolean down=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT)
    local unit hero=Player_GetHero(GetLocalPlayer())
    local integer i=0
    local integer cast=0
    local string text=""
    local boolean open=false
    local boolean allowed=false
    local real now=TimerGetElapsed(NativeCDClock)
    if ForsakenLinkedBag!=null then
        set open=BlzFrameIsVisible(ForsakenLinkedBag)
    endif
    if ForsakenCachedEquipment!=null then
        set open=open or BlzFrameIsVisible(ForsakenCachedEquipment)
    endif
    set allowed=open and BlzIsLocalClientActive() and not QuickGearChatOpen and not InventoryCinematicActive and hero!=null and IsUnitSelected(hero,GetLocalPlayer())
    if not allowed then
        set GearBagHoverCast61=0
    elseif not down and now>=GearBagNextRead61 then
        set GearBagNextRead61=now+.03
        set GearBagHoverCast61=0
        if (GearBagTip61!=null and BlzFrameIsVisible(GearBagTip61)) or (GearBagUber61!=null and BlzFrameIsVisible(GearBagUber61)) then
            loop
                exitwhen i>=GearBagTextCount61 or cast!=0
                set text=BlzFrameGetText(GearBagText61[i])
                if text!=null and text!="" then
                    set GearBagLast61=GearBag_Normalize61(text)
                    set cast=GearBag_Find61(GearBagLast61)
                endif
                set i=i+1
            endloop
        endif
        if cast!=0 then
            set GearBagHoverCast61=cast
            set GearBagHoverAt61=now
            set GearBagHoverX61=BlzGetMouseScreenPosX()
            set GearBagHoverY61=BlzGetMouseScreenPosY()
        endif
    endif
    // Snapshot before the click: the engine may hide the tooltip as targeting
    // starts. It may arm only while the click stays at that item position.
    if down and not GearBagLeft61 and allowed and GearBagHoverCast61!=0 and now-GearBagHoverAt61<.2 and IAbsBJ(BlzGetMouseScreenPosX()-GearBagHoverX61)<=12 and IAbsBJ(BlzGetMouseScreenPosY()-GearBagHoverY61)<=12 then
            set cast=GearBagHoverCast61
            set QuickGearPending=-1
            call QuickGear_ClearPreview()
            call GearWave_Arm(cast)
            set GearInputArmedAt=TimerGetElapsed(NativeCDClock)
            set GearBagArms61=GearBagArms61+1
            set GearBagHoverCast61=0
    endif
    set GearBagLeft61=down
    set hero=null
endfunction
