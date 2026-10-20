// Presentation state only. Never use these values to change units/items or send sync data.
function Forsaken_CloseBackpack takes nothing returns nothing
    set ForsakenBackpackWanted=false
    set ForsakenInventoryBindPhase=0
    set ForsakenBackpackCloseUntil=TimerGetElapsed(ForsakenPanelClock)+.3
    set ForsakenBackpackWasVisible=false
    set ForsakenPanelOpen=false
    if ForsakenCachedEquipment!=null then
        call BlzFrameSetVisible(ForsakenCachedEquipment,false)
    endif
    if ForsakenLinkedBag!=null then
        call BlzFrameSetVisible(ForsakenLinkedBag,false)
    endif
    call BlzFrameSetVisible(ForsakenTalentRoot,false)
    call BlzFrameSetVisible(ForsakenBackpackClose,false)
    call BlzFrameSetVisible(ForsakenLinkedBagClose,false)
endfunction

function Forsaken_BackpackCloseAction takes nothing returns nothing
    if GetLocalPlayer()==GetTriggerPlayer() then
        call Forsaken_CloseBackpack()
    endif
endfunction

function Forsaken_RequestBackpackToggle takes integer source returns nothing
    local real now=TimerGetElapsed(ForsakenPanelClock)
    // One physical hotkey can also dispatch a native command click.
    if now-ForsakenLastToggleTime<.05 or (source!=ForsakenLastToggleSource and now-ForsakenLastToggleTime<.15) then
        return
    endif
    set ForsakenLastToggleTime=now
    set ForsakenLastToggleSource=source
    if ForsakenBackpackWanted then
        call Forsaken_CloseBackpack()
    else
        set ForsakenBackpackWanted=true
        set ForsakenBackpackCloseUntil=0.
        set ForsakenFrameSearchRequested=true
        // Every explicit open must bind through the engine, including the same
        // hero after a scripted close. Cached visible frames are not open state.
        set ForsakenInventoryHero=null
        set ForsakenInventoryBindPhase=0
        set ForsakenNextBagSearch=0.
    endif
endfunction

function Forsaken_BackpackToggleAction takes nothing returns nothing
    local unit hero=Player_GetHero(GetTriggerPlayer())
    local framehandle control=BlzGetTriggerFrame()
    if GetLocalPlayer()==GetTriggerPlayer() and not ForsakenInventoryBinding and hero!=null and IsUnitSelected(hero,GetTriggerPlayer()) then
        if control==ForsakenBackpackInput and GetUnitAbilityLevel(hero,'ASpc')>0 then
            call Forsaken_RequestBackpackToggle(2)
            call BlzFrameSetEnable(control,false)
            call BlzFrameSetEnable(control,true)
        endif
    endif
    set hero=null
    set control=null
endfunction

function Forsaken_BackpackAccess takes player viewer,unit hero returns nothing
    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED or GetTriggerEventId()==EVENT_PLAYER_UNIT_DESELECTED then
        return
    endif
    if BlzGetTriggerPlayerKey()==OSKEY_ESCAPE then
        call Forsaken_CloseBackpack()
    elseif BlzGetTriggerPlayerKey()==OSKEY_B then
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
    local unit hero=GetTriggerUnit()
    if GetLocalPlayer()==GetOwningPlayer(hero) and hero==Player_GetHero(GetOwningPlayer(hero)) and IsUnitSelected(hero,GetLocalPlayer()) then
        if ForsakenBackpackWanted then
            set ForsakenBackpackWanted=true
            set ForsakenFrameSearchRequested=true
        endif
    endif
    set hero=null
endfunction

// These are the two actual engine panels, not the hero's six quick slots.
function Forsaken_ResolveInventory takes nothing returns nothing
    set ForsakenCachedEquipment=Forsaken_FindFrameUncached("SimpleEquipmentPanel")
    set ForsakenCachedBackdrop=Forsaken_FindFrameUncached("EquipmentPanelBackdrop")
    set ForsakenLinkedBag=Forsaken_FindFrameUncached("SimpleEquipmentInventoryPanel")
endfunction

// Let the engine bind its preview/items to the currently selected hero. Simply
// showing a hidden model frame can display the previous job's cached preview.
function Forsaken_NativeInventoryClick takes integer raw returns nothing
    local integer x=BlzGetAbilityPosX(raw)
    local integer y=BlzGetAbilityPosY(raw)
    local framehandle control
    if x>=0 and x<4 and y>=0 and y<3 then
        set control=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,y*4+x)
        if control!=null and BlzFrameIsVisible(control) and BlzFrameGetEnable(control) then
            set ForsakenInventoryBinding=true
            call BlzFrameClick(control)
            set ForsakenInventoryBinding=false
        endif
    endif
    set control=null
endfunction

function Forsaken_BindInventory takes unit hero returns nothing
    local real now=TimerGetElapsed(ForsakenPanelClock)
    if ForsakenInventoryBindHero!=hero then
        set ForsakenInventoryBindHero=hero
        set ForsakenInventoryBindPhase=0
    endif
    if now<ForsakenNextBagSearch then
        return
    endif
    if ForsakenInventoryBindPhase==0 then
        // SetVisible(false) does not close the engine's internal inventory.
        // Invalidate the old presentation, dispatch once, then observe the
        // engine result. Never infer success from a frame we showed ourselves.
        call BlzFrameSetVisible(ForsakenCachedEquipment,false)
        call BlzFrameSetVisible(ForsakenLinkedBag,false)
        call Forsaken_NativeInventoryClick('ASpc')
        set ForsakenInventoryBindPhase=1
        set ForsakenInventoryBindUntil=now+1.
        set ForsakenNextBagSearch=now+.1
    elseif ForsakenInventoryBindPhase==1 or ForsakenInventoryBindPhase==2 then
        call Forsaken_ResolveInventory()
        if BlzFrameIsVisible(ForsakenCachedEquipment) or BlzFrameIsVisible(ForsakenLinkedBag) then
            set ForsakenInventoryHero=hero
            set ForsakenInventoryBindPhase=0
        elseif now>=ForsakenInventoryBindUntil then
            if ForsakenInventoryBindPhase==1 then
                // The first click may have closed an internally open panel
                // left hidden by a previous scripted close. One retry opens it.
                call Forsaken_NativeInventoryClick('ASpc')
                set ForsakenInventoryBindPhase=2
                set ForsakenInventoryBindUntil=now+1.
                set ForsakenNextBagSearch=now+.1
            else
                set ForsakenInventoryBindPhase=3
                set ForsakenBackpackWanted=false
                call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,6,"Backpack did not open. Press B or click Backpack to retry.")
            endif
        else
            set ForsakenNextBagSearch=now+.1
        endif
    endif
endfunction

function Forsaken_BackpackVisible takes framehandle panel returns boolean
    local unit hero=Player_GetHero(GetLocalPlayer())
    local boolean visible=false
    local real now=TimerGetElapsed(ForsakenPanelClock)
    if ForsakenLinkedBag==null then
        set ForsakenLinkedBag=BlzGetFrameByName("SimpleEquipmentInventoryPanel",0)
    endif
    if (ForsakenLinkedBag==null or panel==null or ForsakenInventoryHero!=hero) and (ForsakenBackpackWanted or BlzFrameIsVisible(panel) or BlzFrameIsVisible(ForsakenLinkedBag)) then
        call Forsaken_ResolveInventory()
    endif
    set panel=ForsakenCachedEquipment
    if now<ForsakenBackpackCloseUntil then
        call BlzFrameSetVisible(panel,false)
        call BlzFrameSetVisible(ForsakenLinkedBag,false)
        set hero=null
        return false
    endif
    set visible=BlzFrameIsVisible(panel) or BlzFrameIsVisible(ForsakenLinkedBag)
    if ForsakenBackpackWanted and hero!=null then
        if ForsakenInventoryHero!=hero then
            call Forsaken_BindInventory(hero)
            set panel=ForsakenCachedEquipment
            // A failed native bind must never expose a previous hero's model/items.
            if ForsakenInventoryHero!=hero then
                if ForsakenInventoryBindPhase!=1 and ForsakenInventoryBindPhase!=2 then
                    call BlzFrameSetVisible(panel,false)
                    call BlzFrameSetVisible(ForsakenLinkedBag,false)
                endif
                set hero=null
                return false
            endif
        endif
        set visible=panel!=null and ForsakenLinkedBag!=null
        if visible then
            call BlzFrameSetVisible(panel,true)
            call BlzFrameSetVisible(ForsakenLinkedBag,true)
        endif
    else
        set visible=false
    endif
    if not visible then
        call BlzFrameSetVisible(panel,false)
        call BlzFrameSetVisible(ForsakenLinkedBag,false)
    endif
    set hero=null
    return visible
endfunction

function Forsaken_BackpackInputControl takes unit hero,player viewer returns nothing
    local boolean show=hero!=null and IsUnitSelected(hero,viewer) and GetUnitAbilityLevel(hero,'ASpc')>0 and ForsakenInspectTarget==null
    if ForsakenBackpackInput!=null then
        call BlzFrameSetVisible(ForsakenBackpackInput,show and BlzFrameIsVisible(ForsakenBackpackCommand))
    endif
endfunction

function Forsaken_InventoryContext takes unit hero,player viewer returns boolean
    if hero!=null and IsUnitSelected(hero,viewer) then
        return true
    endif
    // Keep intent, but never show a hero pane while another unit owns the card.
    call BlzFrameSetVisible(ForsakenCachedEquipment,false)
    call BlzFrameSetVisible(ForsakenLinkedBag,false)
    return false
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
    local framehandle gearClose=null
    if visible and panel!=ForsakenBackpackHookRoot then
        set ForsakenBackpackHookRoot=panel
        set ForsakenBackpackNativeClose=null
        set ForsakenBackpackScanBudget=128
        call Forsaken_HookBackpackClose(panel,0)
    endif
    if visible and anchor!=null then
        call BlzFrameClearAllPoints(ForsakenBackpackClose)
        call BlzFrameSetSize(ForsakenBackpackClose,.026,.025)
        call BlzFrameSetPoint(ForsakenBackpackClose,FRAMEPOINT_TOPRIGHT,anchor,FRAMEPOINT_TOPRIGHT,-.010,-.008)
        call BlzFrameSetText(ForsakenBackpackClose,"X")
    endif
    call BlzFrameSetVisible(ForsakenBackpackClose,visible and anchor!=null)
    if visible and ForsakenLinkedBag!=null and ForsakenLinkedBag!=ForsakenBagHookRoot then
        set ForsakenBagHookRoot=ForsakenLinkedBag
        set gearClose=ForsakenBackpackNativeClose
        set ForsakenBackpackNativeClose=null
        set ForsakenBackpackScanBudget=128
        call Forsaken_HookBackpackClose(ForsakenLinkedBag,0)
        set ForsakenBagNativeClose=ForsakenBackpackNativeClose
        set ForsakenBackpackNativeClose=gearClose
    endif
    if visible and ForsakenBagNativeClose!=null then
        call BlzFrameClearAllPoints(ForsakenLinkedBagClose)
        call BlzFrameSetAllPoints(ForsakenLinkedBagClose,ForsakenBagNativeClose)
    endif
    call BlzFrameSetVisible(ForsakenLinkedBagClose,visible and ForsakenBagNativeClose!=null)
    set gearClose=null
endfunction

function Forsaken_ResetBackpackControls takes nothing returns nothing
    set ForsakenBackpackWanted=false
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
    endif
    set ForsakenBackpackCommand=null
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
    endif
    set hero=null
    set viewer=null
endfunction

function Forsaken_RegisterBackpackActivity takes nothing returns nothing
    local integer i=0
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
        // A transparent owned button intercepts the physical click. The native
        // command remains underneath for explicit, observed engine binding only.
        set ForsakenBackpackInput=BlzCreateFrameByType("BUTTON","ForsakenBackpackInput",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
        call BlzFrameSetAllPoints(ForsakenBackpackInput,ForsakenBackpackCommand)
        call BlzFrameSetLevel(ForsakenBackpackInput,60)
        call BlzFrameSetVisible(ForsakenBackpackInput,false)
        call BlzTriggerRegisterFrameEvent(ForsakenBackpackToggleEvents,ForsakenBackpackInput,FRAMEEVENT_CONTROL_CLICK)
        call TriggerAddAction(ForsakenBackpackToggleEvents,function Forsaken_BackpackToggleAction)
    endif
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
        set ForsakenLinkedBagClose=BlzCreateFrame("ScriptDialogButton",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
        call BlzFrameSetText(ForsakenLinkedBagClose,"X")
        call BlzFrameSetVisible(ForsakenLinkedBagClose,false)
        call BlzTriggerRegisterFrameEvent(ForsakenBackpackCloseEvents,ForsakenLinkedBagClose,FRAMEEVENT_CONTROL_CLICK)
    endif
endfunction

function Forsaken_RequestInventoryRefresh takes unit hero returns nothing
    if hero==Player_GetHero(GetLocalPlayer()) and ForsakenBackpackWanted then
        set ForsakenInventoryHero=null
        set ForsakenInventoryBindPhase=0
        set ForsakenFrameSearchRequested=true
        set ForsakenNextBagSearch=0.
    endif
endfunction
