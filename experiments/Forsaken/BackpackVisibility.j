// Presentation state only. Never use these values to change units/items or send sync data.
// Reserve native frame handles on every client during shared startup. Never walk
// a local player's live inventory hierarchy: getters can allocate handle IDs.
function Forsaken_FindFrameUncached takes string name returns framehandle
    local integer context=0
    local framehandle found
    local framehandle first=null
    local integer frameKind=0
    if name=="EquipmentPanelBackdrop" then
        set frameKind=1
    elseif name=="SimpleEquipmentInventoryPanel" then
        set frameKind=2
    endif
    loop
        exitwhen context>255
        set found=BlzGetFrameByName(name,context)
        if found!=null then
            set ForsakenNativeFrame[frameKind*256+ForsakenNativeFrameCount[frameKind]]=found
            set ForsakenNativeFrameCount[frameKind]=ForsakenNativeFrameCount[frameKind]+1
            if first==null then
                set first=found
            endif
        endif
        set context=context+1
    endloop
    set found=null
    return first
endfunction

function Forsaken_SelectCachedFrame takes integer frameKind,framehandle fallback returns framehandle
    local integer i=0
    local framehandle candidate
    loop
        exitwhen i>=ForsakenNativeFrameCount[frameKind]
        set candidate=ForsakenNativeFrame[frameKind*256+i]
        if candidate!=null and BlzFrameIsVisible(candidate) then
            return candidate
        endif
        set i=i+1
    endloop
    // An inactive cached frame is not an alternative inventory view.
    set candidate=null
    return null
endfunction

function Forsaken_FindFrame takes string name returns framehandle
    // Read only handles reserved on all clients at startup. The native engine
    // owns activation, item binding, dragging and cooldown layers.
    if name=="SimpleEquipmentPanel" then
        return ForsakenCachedEquipment
    elseif name=="SimpleEquipmentInventoryPanel" then
        return ForsakenLinkedBag
    elseif name=="EquipmentPanelBackdrop" then
        return ForsakenCachedBackdrop
    endif
    return null
endfunction

function Forsaken_NativeInventoryClick takes integer raw returns nothing
    // Native command activation belongs to the real mouse/hotkey input path.
    // A timer-driven click could activate a different command card on one client.
endfunction

function Forsaken_CloseBackpack takes nothing returns nothing
    set ForsakenBackpackCloses=ForsakenBackpackCloses+1
    set ForsakenBackpackWanted=false
    set ForsakenBackpackExplicitlyClosed=true
    set ForsakenInventoryBindPhase=0
    set ForsakenBackpackCloseUntil=TimerGetElapsed(ForsakenPanelClock)+1.2
    set ForsakenBackpackWasVisible=false
    set ForsakenPanelOpen=false
    if ForsakenCachedBackdrop!=null then
        call BlzFrameSetVisible(ForsakenCachedBackdrop,false)
    endif
    if ForsakenCachedEquipment!=null then
        call BlzFrameSetVisible(ForsakenCachedEquipment,false)
    endif
    if ForsakenLinkedBag!=null then
        call BlzFrameSetVisible(ForsakenLinkedBag,false)
    endif
    call BlzFrameSetVisible(ForsakenTalentToggle,false)
    call BlzFrameSetVisible(ForsakenTalentRoot,false)
    call BlzFrameSetVisible(ForsakenBackpackClose,false)
    call BlzFrameSetVisible(ForsakenLinkedBagClose,false)
endfunction

function Forsaken_BackpackCloseAction takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call Forsaken_CloseBackpack()
    endif
endfunction


function Forsaken_BindInventory takes unit hero returns nothing
    // Real native mouse/B input binds the selected hero. Presentation must not
    // hide its panes, cancel user intent, or retry command activation on a timer.
    set ForsakenInventoryHero=hero
    set ForsakenInventoryBindHero=hero
    set ForsakenInventoryBindPhase=0
endfunction

function Forsaken_RequestBackpackToggle takes integer source returns nothing
    local real now=TimerGetElapsed(ForsakenPanelClock)
    if now-ForsakenLastToggleTime<.25 then
        return
    endif
    set ForsakenBackpackRequests=ForsakenBackpackRequests+1
    set ForsakenLastToggleTime=now
    set ForsakenLastToggleSource=source
    // Observe real input; do not toggle another presentation state on top of
    // the engine's own toggle. Key and mouse may notify in either order.
    set ForsakenBackpackExplicitlyClosed=false
    set ForsakenInventoryBindPhase=1
    set ForsakenInventoryBindUntil=now+1.
endfunction

function Forsaken_BackpackToggleAction takes nothing returns nothing
    local unit hero=Player_GetHero(GetTriggerPlayer())
    if GetLocalPlayer()==GetTriggerPlayer() and not ForsakenInventoryBinding and hero!=null and IsUnitSelected(hero,GetTriggerPlayer()) then
        if GetUnitAbilityLevel(hero,'ASpc')>0 then
            set ForsakenBackpackMouseEvents=ForsakenBackpackMouseEvents+1
            call Forsaken_RequestBackpackToggle(2)
        endif
    endif
    set hero=null
endfunction

function Forsaken_BackpackAccess takes player viewer,unit hero returns nothing
    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED or GetTriggerEventId()==EVENT_PLAYER_UNIT_DESELECTED then
        return
    endif
    if BlzGetTriggerPlayerKey()==OSKEY_ESCAPE then
        call Forsaken_CloseBackpack()
        set ForsakenBackpackExplicitlyClosed=false
    elseif BlzGetTriggerPlayerKey()==OSKEY_B then
        set ForsakenBackpackKeyEvents=ForsakenBackpackKeyEvents+1
        if not BlzGetTriggerPlayerIsKeyDown() then
            set ForsakenBackpackKeyHeld=false
        elseif not ForsakenBackpackKeyHeld then
            set ForsakenBackpackKeyHeld=true
            if hero!=null and IsUnitSelected(hero,viewer) then
                call Forsaken_RequestBackpackToggle(1)
            endif
        endif
    endif
endfunction

function Forsaken_BackpackActivity takes nothing returns nothing
    // Native inventory already updates changed slots, charges and cooldowns.
    // Item events must never replace the live panel or change its visibility.
endfunction

// These are the two actual engine panels, not the hero's six quick slots.
function Forsaken_ResolveInventory takes nothing returns nothing
    set ForsakenNativeFrameCount[0]=0
    set ForsakenNativeFrameCount[1]=0
    set ForsakenNativeFrameCount[2]=0
    call Forsaken_FindFrameUncached("SimpleEquipmentPanel")
    call Forsaken_FindFrameUncached("EquipmentPanelBackdrop")
    call Forsaken_FindFrameUncached("SimpleEquipmentInventoryPanel")
    set ForsakenCachedEquipment=null
    set ForsakenCachedBackdrop=null
    set ForsakenLinkedBag=null
endfunction

// Let the engine bind its preview/items to the currently selected hero. Simply
// showing a hidden model frame can display the previous job's cached preview.

function Forsaken_BackpackVisible takes framehandle panel returns boolean
    local boolean visible=false
    // Poll visibility of reserved handles, not frame names/hierarchies. Native
    // activation can finish after the input callback; never select hidden fallback
    // frames or manufacture an open view by showing their inner children.
    set ForsakenCachedEquipment=Forsaken_SelectCachedFrame(0,null)
    set ForsakenCachedBackdrop=Forsaken_SelectCachedFrame(1,null)
    set ForsakenLinkedBag=Forsaken_SelectCachedFrame(2,null)
    set visible=ForsakenCachedEquipment!=null and ForsakenCachedBackdrop!=null and ForsakenLinkedBag!=null
    if visible then
        set ForsakenInventoryHero=Player_GetHero(GetLocalPlayer())
        set ForsakenInventoryBindPhase=0
    endif
    set ForsakenBackpackWanted=visible
    return visible
endfunction

function Forsaken_BackpackInputControl takes unit hero,player viewer returns nothing
    // Keep the real native button unobstructed: its click both binds inventory
    // and dispatches the same presentation toggle as B.
endfunction

function Forsaken_InventoryContext takes unit hero,player viewer returns boolean
    // Selection, combat and item events never change manual visibility intent.
    return hero!=null
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
    // Deliberately no traversal of native children on a local UI path.
    set ForsakenBackpackNativeClose=null
endfunction

function Forsaken_BackpackControls takes framehandle panel,framehandle anchor,boolean visible returns nothing
    if visible and anchor!=null then
        call BlzFrameClearAllPoints(ForsakenBackpackClose)
        call BlzFrameSetSize(ForsakenBackpackClose,.026,.025)
        call BlzFrameSetPoint(ForsakenBackpackClose,FRAMEPOINT_TOPRIGHT,anchor,FRAMEPOINT_TOPRIGHT,-.010,-.008)
        call BlzFrameSetText(ForsakenBackpackClose,"X")
    endif
    call BlzFrameSetVisible(ForsakenBackpackClose,visible and anchor!=null)
    // The gear-header X closes both linked panes. No dynamic native-close lookup.
    call BlzFrameSetVisible(ForsakenLinkedBagClose,false)
endfunction

function Forsaken_ResetBackpackControls takes nothing returns nothing
    set ForsakenBackpackWanted=false
    set ForsakenBackpackExplicitlyClosed=false
    set ForsakenBackpackKeyHeld=false
    set ForsakenInventoryBindPhase=0
    set ForsakenInventoryBindHero=null
    if ForsakenBackpackDebugEvents!=null then
        call DestroyTrigger(ForsakenBackpackDebugEvents)
        set ForsakenBackpackDebugEvents=null
    endif
    set ForsakenLastToggleSource=0
    set ForsakenLastToggleTime=-1.
    if ForsakenBackpackToggleEvents!=null then
        call DestroyTrigger(ForsakenBackpackToggleEvents)
        set ForsakenBackpackToggleEvents=null
    endif
    if ForsakenBackpackInput!=null then
        call BlzDestroyFrame(ForsakenBackpackInput)
        set ForsakenBackpackInput=null
        set ForsakenBackpackInputIcon=null
    endif
    set ForsakenBackpackCommand=null
    set ForsakenAttackCommand=null
    set ForsakenGearCommand=null
    set ForsakenBackpackCloseUntil=0.
    set ForsakenBackpackWasVisible=false
    set ForsakenBackpackHookRoot=null
    set ForsakenBackpackNativeClose=null
    set ForsakenLinkedBag=null
    set ForsakenInventoryHero=null
    set ForsakenBagNativeClose=null
    set ForsakenBagHookRoot=null
    set ForsakenNextBagSearch=0.
    if ForsakenBackpackCloseEvents!=null then
        call DestroyTrigger(ForsakenBackpackCloseEvents)
        set ForsakenBackpackCloseEvents=null
    endif
    if ForsakenBackpackClose!=null then
        call BlzDestroyFrame(ForsakenBackpackClose)
        set ForsakenBackpackClose=null
    endif
    if ForsakenLinkedBagClose!=null then
        call BlzDestroyFrame(ForsakenLinkedBagClose)
        set ForsakenLinkedBagClose=null
    endif
endfunction

function Forsaken_BackpackFlag takes boolean value returns string
    if value then
        return "yes"
    endif
    return "no"
endfunction

function Forsaken_BackpackDebug takes nothing returns nothing
    local player viewer=GetTriggerPlayer()
    local unit hero=Player_GetHero(viewer)
    if GetLocalPlayer()==viewer then
        call DisplayTimedTextToPlayer(viewer,0,0,30,"Backpack: wanted="+Forsaken_BackpackFlag(ForsakenBackpackWanted)+" phase="+I2S(ForsakenInventoryBindPhase)+" bound="+Forsaken_BackpackFlag(hero!=null and ForsakenInventoryHero==hero)+" selected="+Forsaken_BackpackFlag(hero!=null and IsUnitSelected(hero,viewer)))
        call DisplayTimedTextToPlayer(viewer,0,0,30,"Panels: gear="+Forsaken_BackpackFlag(BlzFrameIsVisible(ForsakenCachedEquipment))+" bag="+Forsaken_BackpackFlag(BlzFrameIsVisible(ForsakenLinkedBag))+" input="+Forsaken_BackpackFlag(BlzFrameIsVisible(ForsakenBackpackInput))+" native="+Forsaken_BackpackFlag(BlzFrameIsVisible(ForsakenBackpackCommand))+" enabled="+Forsaken_BackpackFlag(BlzFrameGetEnable(ForsakenBackpackCommand)))
        call DisplayTimedTextToPlayer(viewer,0,0,30,"Input: mouse="+I2S(ForsakenBackpackMouseEvents)+" key="+I2S(ForsakenBackpackKeyEvents)+" requests="+I2S(ForsakenBackpackRequests)+" closes="+I2S(ForsakenBackpackCloses)+" native retries="+I2S(ForsakenBackpackNativeClicks))
    endif
    set hero=null
    set viewer=null
endfunction

function Forsaken_RegisterBackpackActivity takes nothing returns nothing
    local integer i=0
    call Forsaken_ResolveInventory()
    set ForsakenAttackCommand=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,3)
    if ForsakenBackpackDebugEvents==null then
        set ForsakenBackpackDebugEvents=CreateTrigger()
        loop
            exitwhen i>=8
            call TriggerRegisterPlayerChatEvent(ForsakenBackpackDebugEvents,Player(i),"-bagdebug",true)
            set i=i+1
        endloop
        call TriggerAddAction(ForsakenBackpackDebugEvents,function Forsaken_BackpackDebug)
    endif
    if ForsakenBackpackToggleEvents==null then
        set ForsakenBackpackToggleEvents=CreateTrigger()
        set ForsakenBackpackCommand=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,BlzGetAbilityPosY('ASpc')*4+BlzGetAbilityPosX('ASpc'))
        set ForsakenGearCommand=null
        // Observe the actual UI button. ASpc opens native UI without issuing
        // an ability order, so TriggerRegisterCommandEvent misses mouse clicks.
        // Registration is shared; the callback changes local presentation only.
        call BlzTriggerRegisterFrameEvent(ForsakenBackpackToggleEvents,ForsakenBackpackCommand,FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(ForsakenBackpackToggleEvents,function Forsaken_BackpackToggleAction)
    endif
    if ForsakenBackpackEvents==null then
        set ForsakenBackpackEvents=CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(ForsakenBackpackEvents,EVENT_PLAYER_UNIT_PICKUP_ITEM)
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
        set ForsakenLinkedBagClose=BlzCreateFrame("ScriptDialogButton",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
        call BlzFrameSetText(ForsakenLinkedBagClose,"X")
        call BlzFrameSetVisible(ForsakenLinkedBagClose,false)
        call BlzTriggerRegisterFrameEvent(ForsakenBackpackCloseEvents,ForsakenLinkedBagClose,FRAMEEVENT_CONTROL_CLICK)
    endif
endfunction

function Forsaken_RequestInventoryRefresh takes unit hero returns nothing
    if hero==Player_GetHero(GetLocalPlayer()) and ForsakenBackpackWanted then
        set ForsakenFrameSearchRequested=true
        set ForsakenNextBagSearch=0.
    endif
endfunction
