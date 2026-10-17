// Presentation state only. Never use these values to change units/items or send sync data.
function Forsaken_CloseBackpack takes nothing returns nothing
    set ForsakenBackpackWanted=false
    set ForsakenBackpackCloseUntil=TimerGetElapsed(ForsakenPanelClock)+.3
    set ForsakenBackpackWasVisible=false
    set ForsakenPanelOpen=false
    if ForsakenCachedEquipment!=null then
        call BlzFrameSetVisible(ForsakenCachedEquipment,false)
    endif
    call BlzFrameSetVisible(ForsakenTalentRoot,false)
    call BlzFrameSetVisible(ForsakenBackpackClose,false)
endfunction

function Forsaken_BackpackCloseAction takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call Forsaken_CloseBackpack()
    endif
endfunction

function Forsaken_BackpackAccess takes player viewer,unit hero returns nothing
    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED or GetTriggerEventId()==EVENT_PLAYER_UNIT_DESELECTED then
        return
    endif
    if BlzGetTriggerPlayerKey()==OSKEY_ESCAPE then
        call Forsaken_CloseBackpack()
    elseif BlzGetTriggerPlayerKey()==OSKEY_B and hero!=null and IsUnitSelected(hero,viewer) then
        if ForsakenBackpackWanted then
            call Forsaken_CloseBackpack()
        else
            set ForsakenBackpackWanted=true
            set ForsakenBackpackCloseUntil=0.
            set ForsakenFrameSearchRequested=true
        endif
    endif
endfunction

function Forsaken_BackpackActivity takes nothing returns nothing
    local unit hero=GetTriggerUnit()
    if GetLocalPlayer()==GetOwningPlayer(hero) and hero==Player_GetHero(GetOwningPlayer(hero)) and IsUnitSelected(hero,GetLocalPlayer()) then
        if ForsakenBackpackWanted then
            set ForsakenBackpackWanted=true
            set ForsakenFrameSearchRequested=true
        endif
    endif
    set hero=null
endfunction

function Forsaken_BackpackVisible takes framehandle panel returns boolean
    local boolean visible=false
    if panel==null then
        return false
    endif
    if TimerGetElapsed(ForsakenPanelClock)<ForsakenBackpackCloseUntil then
        call BlzFrameSetVisible(panel,false)
        return false
    endif
    set visible=BlzFrameIsVisible(panel)
    if visible then
        set ForsakenBackpackWanted=true
    elseif ForsakenBackpackWanted then
        call BlzFrameSetVisible(panel,true)
        set visible=true
    endif
    return visible
endfunction

function Forsaken_BackpackCloseName takes string name returns boolean
    local integer i=0
    local integer length=StringLength(name)
    set name=StringCase(name,false)
    loop
        exitwhen i>=length
        if SubString(name,i,i+5)=="close" or SubString(name,i,i+6)=="cancel" then
            return true
        endif
        set i=i+1
    endloop
    return false
endfunction

// Search a changed native panel once, rather than scanning its children every poll.
function Forsaken_HookBackpackClose takes framehandle root,integer depth returns nothing
    local integer child=0
    local integer count
    if root==null or depth>6 or ForsakenBackpackScanBudget<=0 then
        return
    endif
    set ForsakenBackpackScanBudget=ForsakenBackpackScanBudget-1
    if Forsaken_BackpackCloseName(BlzFrameGetName(root)) then
        set ForsakenBackpackNativeClose=root
        return
    endif
    set count=BlzFrameGetChildrenCount(root)
    loop
        exitwhen child>=count or ForsakenBackpackScanBudget<=0 or ForsakenBackpackNativeClose!=null
        call Forsaken_HookBackpackClose(BlzFrameGetChild(root,child),depth+1)
        set child=child+1
    endloop
endfunction

function Forsaken_BackpackControls takes framehandle panel,framehandle anchor,boolean visible returns nothing
    if visible and panel!=ForsakenBackpackHookRoot then
        set ForsakenBackpackHookRoot=panel
        set ForsakenBackpackNativeClose=null
        set ForsakenBackpackScanBudget=128
        call Forsaken_HookBackpackClose(panel,0)
    endif
    if visible then
        if ForsakenBackpackNativeClose!=null then
            // The button/event was created at shared startup. Only its presentation
            // is moved locally over the native X; no local handle allocations.
            call BlzFrameClearAllPoints(ForsakenBackpackClose)
            call BlzFrameSetAllPoints(ForsakenBackpackClose,ForsakenBackpackNativeClose)
            call BlzFrameSetText(ForsakenBackpackClose,"X")
        elseif anchor!=null then
            call BlzFrameClearAllPoints(ForsakenBackpackClose)
            call BlzFrameSetPoint(ForsakenBackpackClose,FRAMEPOINT_TOPRIGHT,anchor,FRAMEPOINT_TOPRIGHT,-.075,-.010)
            call BlzFrameSetText(ForsakenBackpackClose,"Close bag")
        endif
    endif
    call BlzFrameSetVisible(ForsakenBackpackClose,visible)
endfunction

function Forsaken_ResetBackpackControls takes nothing returns nothing
    set ForsakenBackpackWanted=false
    set ForsakenBackpackCloseUntil=0.
    set ForsakenBackpackWasVisible=false
    set ForsakenBackpackHookRoot=null
    set ForsakenBackpackNativeClose=null
    if ForsakenBackpackCloseEvents!=null then
        call DestroyTrigger(ForsakenBackpackCloseEvents)
        set ForsakenBackpackCloseEvents=null
    endif
    if ForsakenBackpackClose!=null then
        call BlzDestroyFrame(ForsakenBackpackClose)
        set ForsakenBackpackClose=null
    endif
endfunction

function Forsaken_RegisterBackpackActivity takes nothing returns nothing
    if ForsakenBackpackEvents==null then
        set ForsakenBackpackEvents=CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(ForsakenBackpackEvents,EVENT_PLAYER_UNIT_DROP_ITEM)
        call TriggerRegisterAnyUnitEventBJ(ForsakenBackpackEvents,EVENT_PLAYER_UNIT_USE_ITEM)
        call TriggerRegisterAnyUnitEventBJ(ForsakenBackpackEvents,EVENT_PLAYER_UNIT_UNEQUIP_ITEM)
        call TriggerAddAction(ForsakenBackpackEvents,function Forsaken_BackpackActivity)
    endif
    if ForsakenBackpackCloseEvents==null then
        set ForsakenBackpackCloseEvents=CreateTrigger()
        call TriggerAddAction(ForsakenBackpackCloseEvents,function Forsaken_BackpackCloseAction)
        set ForsakenBackpackClose=BlzCreateFrame("ScriptDialogButton",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
        call BlzFrameSetSize(ForsakenBackpackClose,.06,.025)
        call BlzFrameSetLevel(ForsakenBackpackClose,60)
        call BlzFrameSetText(ForsakenBackpackClose,"Close bag")
        call BlzFrameSetVisible(ForsakenBackpackClose,false)
        call BlzTriggerRegisterFrameEvent(ForsakenBackpackCloseEvents,ForsakenBackpackClose,FRAMEEVENT_CONTROL_CLICK)
    endif
endfunction
