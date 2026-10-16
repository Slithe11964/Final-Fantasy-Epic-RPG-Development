// Local presentation only. Item events never use this state to change inventory.
function Forsaken_BackpackActivity takes nothing returns nothing
    local unit hero=GetTriggerUnit()
    if GetLocalPlayer()==GetOwningPlayer(hero) and hero==Player_GetHero(GetOwningPlayer(hero)) and IsUnitSelected(hero,GetLocalPlayer()) and ForsakenBackpackWasVisible then
        set ForsakenBackpackRestoreUntil=TimerGetElapsed(ForsakenPanelClock)+.5
        set ForsakenFrameSearchRequested=true
    endif
    set hero=null
endfunction

function Forsaken_BackpackVisible takes framehandle panel returns boolean
    local boolean visible=false
    if panel==null then
        return false
    endif
    set visible=BlzFrameIsVisible(panel)
    if not visible and TimerGetElapsed(ForsakenPanelClock)<ForsakenBackpackRestoreUntil then
        call BlzFrameSetVisible(panel,true)
        set visible=true
    endif
    return visible
endfunction

function Forsaken_RegisterBackpackActivity takes nothing returns nothing
    local trigger activity=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(activity,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerRegisterAnyUnitEventBJ(activity,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerRegisterAnyUnitEventBJ(activity,EVENT_PLAYER_UNIT_UNEQUIP_ITEM)
    call TriggerAddAction(activity,function Forsaken_BackpackActivity)
    set activity=null
endfunction
