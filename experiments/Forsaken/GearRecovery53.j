globals
    item array QuickGearObservedItem
    integer array QuickGearObservedRaw
    integer QuickGearKeyEvents=0
    integer QuickGearRequests=0
    integer array QuickGearReceives
    string QuickGearReason="No shortcut pressed"
    trigger QuickGearDiagnostics=null
endglobals

function QuickGear_SlotsChanged takes unit hero returns boolean
    return QuickGear_Item(hero,0)!=QuickGearObservedItem[0] or QuickGear_Item(hero,1)!=QuickGearObservedItem[1] or GetItemTypeId(QuickGear_Item(hero,0))!=QuickGearObservedRaw[0] or GetItemTypeId(QuickGear_Item(hero,1))!=QuickGearObservedRaw[1]
endfunction

function QuickGear_Loaded takes integer pid returns nothing
    // Only invalidate presentation/input state. Never move or edit loaded items.
    set QuickGearRevision[pid]=QuickGearRevision[pid]+1
    if GetLocalPlayer()==Player(pid) then
        set QuickGearChatOpen=false
        set QuickGearReady=false
        set QuickGearPending=-1
        set QuickGearHeld[0]=false
        set QuickGearHeld[1]=false
    endif
endfunction

function QuickGear_Bool takes boolean flag returns string
    if flag then
        return "yes"
    endif
    return "no"
endfunction

function QuickGear_Diagnostic takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local integer pid=GetPlayerId(owner)
    local unit hero=Player_GetHero(owner)
    local item carried
    local integer slot=0
    if GetLocalPlayer()==owner then
        call DisplayTimedTextToPlayer(owner,0,0,60,"UI53 F/G: keys="+I2S(QuickGearKeyEvents)+" requests="+I2S(QuickGearRequests)+" sync="+I2S(QuickGearReceives[pid])+" pending="+I2S(QuickGearPending)+"; "+QuickGearReason)
        call DisplayTimedTextToPlayer(owner,0,0,60,"load="+I2S(FFL_Phase[pid])+" native="+I2S(FFN_State[pid])+" selected="+QuickGear_Bool(IsUnitSelected(hero,owner))+" chat="+QuickGear_Bool(QuickGearChatOpen)+" keys enabled="+QuickGear_Bool(IsTriggerEnabled(QuickGearKeys)))
        loop
            exitwhen slot>=2
            set carried=QuickGear_Item(hero,slot)
            call DisplayTimedTextToPlayer(owner,0,0,60,"slot="+I2S(slot)+" "+GetItemName(carried)+" raw="+I2S(GetItemTypeId(carried))+" spell="+I2S(LoadInteger(QuickGearData,0,GetItemTypeId(carried))))
            set slot=slot+1
        endloop
    endif
    set carried=null
    set hero=null
    set owner=null
endfunction

function QuickGear_InitDiagnostics takes nothing returns nothing
    local integer pid=0
    if QuickGearDiagnostics!=null then
        return
    endif
    set QuickGearDiagnostics=CreateTrigger()
    call TriggerAddAction(QuickGearDiagnostics,function QuickGear_Diagnostic)
    loop
        exitwhen pid>=8
        call TriggerRegisterPlayerChatEvent(QuickGearDiagnostics,Player(pid),"-gearcheck",true)
        set pid=pid+1
    endloop
endfunction
