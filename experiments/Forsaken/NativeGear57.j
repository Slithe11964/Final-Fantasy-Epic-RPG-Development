globals
    framehandle array NativeGearRoot
    framehandle array NativeGearControl
    integer NativeGearContext=0
    hashtable NativeGearFrames=InitHashtable()
    trigger NativeGearClicks=null
    integer NativeGearWaiting=-1
    unit NativeGearHero=null
    item NativeGearItem=null
    real NativeGearUntil=0.
    boolean NativeGearArmed=false
    real NativeGearStarted=-1.
    integer NativeGearClickCount=0
endglobals

function NativeGear_Arm takes integer slot returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    local item carried=QuickGear_Item(hero,slot)
    local integer raw=GetItemTypeId(carried)
    local integer cast=LoadInteger(QuickGearData,0,raw)
    call QuickGear_ClearPreview()
    set QuickGearPending=-1
    set QuickGearExpectedSpell[GetPlayerId(GetLocalPlayer())]=cast
    set NativeGearArmed=LoadInteger(QuickGearData,1,raw)!=0
    set NativeGearStarted=TimerGetElapsed(NativeCDClock)
    call GearWave_Arm(cast)
    if NativeGearArmed and GearWaveMode==0 and LoadInteger(QuickGearData,1,raw)>=2 then
        set QuickGearPreview=LoadInteger(QuickGearData,32+IMaxBJ(1,GetUnitAbilityLevel(hero,cast)),cast)
        call QuickGear_MovePreview()
    endif
    set carried=null
    set hero=null
endfunction

function NativeGear_ObserveClick takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call NativeGear_Arm(LoadInteger(NativeGearFrames,0,GetHandleId(BlzGetTriggerFrame()))-1)
    endif
endfunction

function NativeGear_CacheBatch takes nothing returns nothing
    local integer last=NativeGearContext+32
    local integer slot=0
    local framehandle control
    loop
        exitwhen NativeGearContext>=last
        set NativeGearRoot[NativeGearContext]=BlzGetFrameByName("SimpleEquipmentPanel",NativeGearContext)
        set slot=0
        loop
            exitwhen slot>=2
            set control=BlzGetFrameByName("EquipmentButton_"+I2S(slot+6),NativeGearContext)
            set NativeGearControl[NativeGearContext*2+slot]=control
            if control!=null and not HaveSavedInteger(NativeGearFrames,0,GetHandleId(control)) then
                call SaveInteger(NativeGearFrames,0,GetHandleId(control),slot+1)
                call BlzTriggerRegisterFrameEvent(NativeGearClicks,control,FRAMEEVENT_CONTROL_CLICK)
            endif
            set slot=slot+1
        endloop
        set NativeGearContext=NativeGearContext+1
    endloop
    set control=null
endfunction

function NativeGear_Click takes integer slot returns boolean
    local integer context=0
    local framehandle control=null
    loop
        exitwhen context>=256
        if NativeGearRoot[context]!=null and NativeGearRoot[context]==ForsakenCachedEquipment then
            set control=NativeGearControl[context*2+slot]
            exitwhen control!=null
        endif
        set context=context+1
    endloop
    if control==null then
        return false
    endif
    if BlzFrameGetEnable(control) then
        call NativeGear_Arm(slot)
        set NativeGearClickCount=NativeGearClickCount+1
        // The exact native equipped-item control the player can click manually.
        // It owns the target cursor, valid targets, right-click/Escape and cast.
        call BlzFrameClick(control)
    endif
    set control=null
    return true
endfunction

function NativeGear_Cancel takes nothing returns nothing
    set NativeGearWaiting=-1
    set NativeGearHero=null
    set NativeGearItem=null
    set NativeGearArmed=false
    call QuickGear_ClearPreview()
    call GearWave_Clear()
endfunction

function NativeGear_Request takes integer slot returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    local item carried=QuickGear_Item(hero,slot)
    local boolean held=ForsakenBackpackKeyHeld
    set QuickGearRequests=QuickGearRequests+1
    if hero==null or carried==null or not IsUnitSelected(hero,GetLocalPlayer()) or GetWidgetLife(hero)<=.405 or QuickGearChatOpen or InventoryCinematicActive then
        set hero=null
        set carried=null
        return
    endif
    call NativeGear_Cancel()
    if ForsakenInventoryHero==hero and NativeGear_Click(slot) then
        set hero=null
        set carried=null
        return
    endif
    // Bind through real native inventory input once for this selected hero.
    // A guarded pending UI click may complete only for this exact hero/item.
    set NativeGearWaiting=slot
    set NativeGearHero=hero
    set NativeGearItem=carried
    set NativeGearUntil=TimerGetElapsed(NativeCDClock)+1.5
    set ForsakenBackpackWanted=true
    set ForsakenBackpackExplicitlyClosed=false
    set ForsakenInventoryBindPhase=1
    set ForsakenInventoryBindUntil=TimerGetElapsed(ForsakenPanelClock)+.2
    set ForsakenLastToggleTime=TimerGetElapsed(ForsakenPanelClock)
    set ForsakenLastToggleSource=3
    set ForsakenBackpackKeyHeld=true
    call ForceUIKey("B")
    set ForsakenBackpackKeyHeld=held
    set hero=null
    set carried=null
endfunction

function NativeGear_Tick takes nothing returns nothing
    local unit hero=Player_GetHero(GetLocalPlayer())
    if not BlzIsLocalClientActive() or QuickGearChatOpen or InventoryCinematicActive then
        call NativeGear_Cancel()
    elseif NativeGearWaiting>=0 then
        if hero!=NativeGearHero or not IsUnitSelected(hero,GetLocalPlayer()) or QuickGear_Item(hero,NativeGearWaiting)!=NativeGearItem then
            call NativeGear_Cancel()
        elseif TimerGetElapsed(NativeCDClock)>NativeGearUntil then
            call NativeGear_Cancel()
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,8,"Open Backpack once to bind this hero's native equipment controls, then use F/G.")
        elseif ForsakenInventoryHero==hero and NativeGear_Click(NativeGearWaiting) then
            set NativeGearWaiting=-1
            set NativeGearHero=null
            set NativeGearItem=null
        endif
    endif
    call GearWave_Draw()
    set hero=null
endfunction

function NativeGear_Reset takes nothing returns nothing
    call NativeGear_Cancel()
    call GearWave_Reset()
    if NativeGearClicks!=null then
        call DestroyTrigger(NativeGearClicks)
    endif
    set NativeGearClicks=null
    call FlushParentHashtable(NativeGearFrames)
endfunction

function NativeGear_Init takes nothing returns nothing
    local integer batch=0
    set NativeGearClicks=CreateTrigger()
    call TriggerAddAction(NativeGearClicks,function NativeGear_ObserveClick)
    set NativeGearContext=0
    loop
        exitwhen batch>=8
        call ExecuteFunc("NativeGear_CacheBatch")
        set batch=batch+1
    endloop
    call GearWave_Init()
endfunction
