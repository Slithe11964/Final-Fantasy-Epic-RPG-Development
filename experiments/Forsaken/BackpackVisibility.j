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

// Hide every already-reserved native pane, including partial/old contexts.
// Never show an inactive cached pane: only the native command binds a live view.
function Forsaken_HideInventory takes nothing returns nothing
    local integer kind=0
    local integer index
    local framehandle pane
    loop
        exitwhen kind>=3
        set index=0
        loop
            exitwhen index>=ForsakenNativeFrameCount[kind]
            set pane=ForsakenNativeFrame[kind*256+index]
            if pane!=null and BlzFrameIsVisible(pane) then
                call BlzFrameSetVisible(pane,false)
            endif
            set index=index+1
        endloop
        set kind=kind+1
    endloop
    set pane=null
endfunction

function Forsaken_CloseBackpack takes nothing returns nothing
    set ForsakenBackpackCloses=ForsakenBackpackCloses+1
    set ForsakenBackpackWanted=false
    set ForsakenBackpackExplicitlyClosed=true
    set ForsakenInventoryBindPhase=0
    set ForsakenBackpackCloseUntil=TimerGetElapsed(ForsakenPanelClock)+1.2
    set ForsakenBackpackWasVisible=false
    set ForsakenPanelOpen=false
    call Forsaken_HideInventory()
    call BlzFrameSetVisible(ForsakenTalentToggle,false)
    call BlzFrameSetVisible(ForsakenTalentRoot,false)
    call BlzFrameSetVisible(ForsakenBackpackClose,false)
    call BlzFrameSetVisible(ForsakenLinkedBagClose,false)
endfunction

// X uses the same real UI key path as B, so the engine closes its inventory
// controller too. Hiding frames alone leaves that controller reopening them.
function Forsaken_BackpackCloseAction takes nothing returns nothing
    local player viewer=GetTriggerPlayer()
    local unit hero=Player_GetHero(viewer)
    local boolean held=ForsakenBackpackKeyHeld
    if GetLocalPlayer()==viewer then
        if ForsakenBackpackWanted and hero!=null and hero==ForsakenInventoryHero and IsUnitSelected(hero,viewer) and GetUnitAbilityLevel(hero,'ASpc')>0 and not ForsakenBackpackChatOpen and ForsakenBackpackCommand!=null and BlzFrameIsVisible(ForsakenBackpackCommand) and BlzFrameGetEnable(ForsakenBackpackCommand) then
            // This runs once in the player's click callback, never in a poll.
            // Suppress both synthetic key-down and ability notifications so
            // one click cannot toggle twice or leave the B key latched down.
            set ForsakenLastToggleTime=TimerGetElapsed(ForsakenPanelClock)
            set ForsakenLastToggleSource=3
            set ForsakenBackpackKeyHeld=true
            call ForceUIKey("B")
            set ForsakenBackpackKeyHeld=held
        endif
        call Forsaken_CloseBackpack()
    endif
    set hero=null
    set viewer=null
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
    if InventoryCinematicActive then
        return
    endif
    if now-ForsakenLastToggleTime<.25 and source!=ForsakenLastToggleSource then
        return
    endif
    set ForsakenBackpackRequests=ForsakenBackpackRequests+1
    set ForsakenLastToggleTime=now
    set ForsakenLastToggleSource=source
    set ForsakenBackpackWanted=not ForsakenBackpackWanted
    set ForsakenBackpackExplicitlyClosed=not ForsakenBackpackWanted
    set ForsakenInventoryBindPhase=1
    set ForsakenInventoryBindUntil=now+.2
endfunction

function Forsaken_BackpackToggleAction takes nothing returns nothing
    local player viewer=GetTriggerPlayer()
    local unit hero=Player_GetHero(viewer)
    local boolean clicked=false
    local integer source=2
    if GetLocalPlayer()==viewer and not ForsakenBackpackKeyHeld and not InventoryCinematicActive then
        if GetTriggerEventId()==EVENT_GAME_CUSTOM_UI_FRAME then
            set clicked=BlzGetTriggerFrame()==ForsakenBackpackCommand
        else
            set source=4
            set clicked=GetSpellAbilityId()=='ASpc' and GetTriggerUnit()==hero
        endif
        if clicked then
            set ForsakenBackpackMouseEvents=ForsakenBackpackMouseEvents+1
            call Forsaken_RequestBackpackToggle(source)
        endif
    endif
    set viewer=null
    set hero=null
endfunction

function Forsaken_BackpackAccess takes player viewer,unit hero returns nothing
    if InventoryCinematicActive then
        return
    endif
    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED or GetTriggerEventId()==EVENT_PLAYER_UNIT_DESELECTED then
        return
    endif
    if BlzGetTriggerPlayerKey()==OSKEY_RETURN then
        set ForsakenBackpackChatOpen=not ForsakenBackpackChatOpen
    elseif BlzGetTriggerPlayerKey()==OSKEY_ESCAPE then
        if ForsakenBackpackChatOpen then
            set ForsakenBackpackChatOpen=false
            return
        endif
        call Forsaken_CloseBackpack()
    elseif BlzGetTriggerPlayerKey()==OSKEY_B then
        // ForceUIKey may dispatch key-down after the click callback returns,
        // and does not provide a matching release. Do not latch that echo.
        if ForsakenLastToggleSource==3 and TimerGetElapsed(ForsakenPanelClock)-ForsakenLastToggleTime<.25 then
            return
        endif
        set ForsakenBackpackKeyEvents=ForsakenBackpackKeyEvents+1
        if not BlzGetTriggerPlayerIsKeyDown() then
            set ForsakenBackpackKeyHeld=false
        elseif not ForsakenBackpackKeyHeld then
            set ForsakenBackpackKeyHeld=true
            if not ForsakenBackpackChatOpen and hero!=null and IsUnitSelected(hero,viewer) then
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
    local framehandle gear=Forsaken_SelectCachedFrame(0,null)
    local framehandle backdrop=Forsaken_SelectCachedFrame(1,null)
    local framehandle bag=Forsaken_SelectCachedFrame(2,null)
    local boolean visible=gear!=null and backdrop!=null and bag!=null
    local real now=TimerGetElapsed(ForsakenPanelClock)
    local unit hero=Player_GetHero(GetLocalPlayer())
    if InventoryCinematicActive then
        call Forsaken_HideInventory()
        set visible=false
    elseif ForsakenBackpackExplicitlyClosed then
        call Forsaken_HideInventory()
        set visible=false
    elseif visible then
        // Observe the engine's live trio. Never manufacture an open state by
        // showing cached frames; that produces the static copy without clocks.
        set ForsakenCachedEquipment=gear
        set ForsakenCachedBackdrop=backdrop
        set ForsakenLinkedBag=bag
        set ForsakenInventoryHero=hero
        set ForsakenBackpackWanted=true
    elseif now>=ForsakenInventoryBindUntil then
        // B/mouse have already closed the real native view. Do not restore it.
        set ForsakenBackpackWanted=false
    endif
    if now>=ForsakenInventoryBindUntil then
        set ForsakenInventoryBindPhase=0
    endif
    set gear=null
    set backdrop=null
    set bag=null
    set hero=null
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
    if ForsakenBackpackChatEvents!=null then
        call DestroyTrigger(ForsakenBackpackChatEvents)
        set ForsakenBackpackChatEvents=null
    endif
    set ForsakenBackpackChatOpen=false
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

function Forsaken_BackpackChatSubmitted takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        set ForsakenBackpackChatOpen=false
    endif
endfunction

function Forsaken_RegisterBackpackActivity takes nothing returns nothing
    local integer i=0
    call Forsaken_ResolveInventory()
    if ForsakenBackpackChatEvents==null then
        set ForsakenBackpackChatEvents=CreateTrigger()
        call TriggerAddAction(ForsakenBackpackChatEvents,function Forsaken_BackpackChatSubmitted)
        loop
            exitwhen i>=8
            call TriggerRegisterPlayerChatEvent(ForsakenBackpackChatEvents,Player(i),"",false)
            set i=i+1
        endloop
    endif
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
        call TriggerRegisterAnyUnitEventBJ(ForsakenBackpackToggleEvents,EVENT_PLAYER_UNIT_SPELL_CAST)
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
