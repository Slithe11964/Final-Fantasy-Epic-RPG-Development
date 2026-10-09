library TForsakenHouseProbe requires TForsakenSavePosition, TForsakenSaveJournal, TForsakenSaveProbe
// Private synthetic storage test. Never swaps live units or exports a save.
globals
    trigger gg_trg_Forsaken_HouseProbe=null
    boolean FHT_WatchdogRecovering=false
    boolean FHT_Busy=false
    integer FHT_Player=-1
    integer FHT_Checkpoint=0
    timer FHT_Watchdog=null
    hashtable FHT_Policy=null
    unit array FHT_Unit
    trigger array FHT_Trigger
    integer FHT_Span=0
    boolean array FHT_Enabled
endglobals

function FHT_Message takes integer pid,string message returns nothing
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,60.,"House test: "+message)
endfunction

// Yield before native operations so the last checkpoint is rendered before a crash.
// Busy remains held across these diagnostic-only sleeps; the watchdog is independent.
function FHT_Trace takes integer pid,string step returns nothing
    set FHT_Checkpoint=FHT_Checkpoint+1
    call ClearTextMessages()
    call FHT_Message(pid,"STEP "+I2S(FHT_Checkpoint)+": NEXT "+step)
    if not FHT_WatchdogRecovering then
        call TriggerSleepAction(0.5)
    endif
endfunction

function FHT_OneGuard takes trigger candidate,integer index,boolean block returns nothing
    if block then
        set FHT_Trigger[index]=candidate
        if candidate!=null then
            set FHT_Enabled[index]=IsTriggerEnabled(candidate)
            call DisableTrigger(candidate)
        endif
    else
        set candidate=FHT_Trigger[index]
        if candidate!=null then
            if FHT_Enabled[index] then
                call EnableTrigger(candidate)
            else
                call DisableTrigger(candidate)
            endif
        endif
        set FHT_Trigger[index]=null
    endif
    set candidate=null
endfunction

function FHT_Capacity takes nothing returns boolean
    // FHT_TRIGGER_GUARD_CAPACITY
    return true
endfunction

function FHT_Guard takes boolean block returns nothing
    local integer slot=0
    // FHT_TRIGGER_GUARD_INITIALIZATION
    // FHT_DYNAMIC_TRIGGER_GUARD_INITIALIZATION
endfunction

function FHT_Empty takes unit candidate returns boolean
    local integer slot=0
    loop
        exitwhen slot>=6
        if UnitItemInSlot(candidate,slot)!=null then
            return false
        endif
        set slot=slot+1
    endloop
    return true
endfunction

function FHT_Referenced takes unit candidate returns boolean
    local integer pid=0
    loop
        exitwhen pid>=8
        if candidate==udg_PlayerHero[pid+1] or candidate==udg_SpiritOfGaya[pid+1] or candidate==udg_PlayerHouse[pid+1] then
            return true
        endif
        set pid=pid+1
    endloop
    return false
endfunction

function FHT_Cleanup takes integer pid returns boolean
    local integer ordinal=0
    local integer position
    local item candidate
    local unit house=FHT_Unit[pid]
    local boolean clean
    // A watchdog may recover an interrupted synchronous diagnostic action.
    // This private probe exclusively owns the fresh native scratch context.
    loop
        exitwhen ordinal>=FSN_Count[pid]
        set candidate=FSN_Item[pid*57+ordinal]
        if candidate!=null then
            set position=0
            loop
                exitwhen position>=57
                if candidate==FSJ_Item[pid*57+position] then
                    set candidate=null
                    set house=null
                    return false
                endif
                set position=position+1
            endloop
        endif
        set ordinal=ordinal+1
    endloop
    set candidate=null
    if house!=null and FHT_Referenced(house) then
        set house=null
        return false
    endif
    set FSN_Operation[pid]=0
    set FSN_Executing[pid]=false
    set FSN_Busy[pid]=false
    set clean=FSN_Abort(pid)
    if clean and house!=null then
        if GetUnitTypeId(house)!=0 then
            if not FHT_Empty(house) then
                set house=null
                return false
            endif
            call RemoveUnit(house)
        endif
        set clean=GetUnitTypeId(house)==0
        if clean then
            set FHT_Unit[pid]=null
        endif
    endif
    set house=null
    return clean
endfunction

function FHT_Finish takes integer pid,boolean passed,string step returns nothing
    local boolean clean
    local boolean originals
    local boolean released=false
    call FHT_Trace(pid,"temporary cleanup")
    set clean=FHT_Cleanup(pid)
    call FHT_Trace(pid,"original inventory readback")
    set originals=FSJ_Verify(pid)
    if clean and originals then
        set released=FSJ_Release(pid)
    endif
    call FHT_Trace(pid,"trigger restoration")
    call FHT_Guard(false)
    if FHT_Watchdog!=null then
        call PauseTimer(FHT_Watchdog)
        call DestroyTimer(FHT_Watchdog)
        set FHT_Watchdog=null
    endif
    set FHT_Busy=false
    set FHT_Player=-1
    if passed and clean and originals and released then
        call FHT_Message(pid,"PASS: six exact house slots, quantities0/120/127, binding, life and flags; temporary cleanup verified; original inventory unchanged.")
    elseif clean and originals and released and step=="cleanup retry" then
        call FHT_Message(pid,"PASS: temporary cleanup verified; original inventory unchanged.")
    elseif clean and originals and released then
        call FHT_Message(pid,"FAIL at "+step+"; temporary cleanup verified; original inventory unchanged.")
    else
        call FHT_Message(pid,"FAIL at "+step+"; cleanup or original readback needs attention. Use -savehousecleanup; do not save this test session.")
    endif
endfunction

function FHT_Timeout takes nothing returns nothing
    if FHT_Busy and FSC_PlayerValid(FHT_Player) then
        set FHT_WatchdogRecovering=true
        call FHT_Finish(FHT_Player,false,"watchdog / interrupted test")
        set FHT_WatchdogRecovering=false
    endif
endfunction

function FHT_Run takes integer pid returns nothing
    local integer other=0
    local integer ordinal=0
    local integer slot
    local integer charges
    local integer flags
    local real x
    local real y
    local unit candidate
    if not FSC_PlayerValid(pid) or FHT_Busy then
        return
    endif
    loop
        exitwhen other>=8
        if FSX_Phase[other]!=0 then
            call FHT_Message(pid,"wait for the inventory check to finish first.")
            return
        endif
        set other=other+1
    endloop
    if not FHT_Capacity() then
        call FHT_Message(pid,"FAIL: trigger guard capacity exceeded; nothing changed.")
        return
    endif
    if FHT_Unit[pid]!=null or FSN_State[pid]!=0 or FSN_Count[pid]!=0 or FSN_AuxCount[pid]!=0 or FSJ_Ready[pid] then
        call FHT_Message(pid,"previous test needs cleanup; use -savehousecleanup.")
        return
    endif
    set FHT_Busy=true
    set FHT_Checkpoint=0
    call FHT_Trace(pid,"original inventory journal")
    if not FSJ_Capture(pid,udg_PlayerHero[pid+1],udg_SpiritOfGaya[pid+1],udg_PlayerHouse[pid+1],true) then
        set FHT_Busy=false
        call FHT_Message(pid,"FAIL: original inventory could not be journaled; select a Forsaken hero and stand still.")
        return
    endif
    set FHT_Player=pid
    set FHT_Busy=true
    set FHT_Watchdog=CreateTimer()
    call TimerStart(FHT_Watchdog,60.,false,function FHT_Timeout)
    call FHT_Trace(pid,"trigger guard")
    call FHT_Guard(true)
    if FSJ_House[pid]==null then
        call FHT_Finish(pid,false,"missing original house")
        return
    endif
    set x=GetUnitX(FSJ_House[pid])
    set y=GetUnitY(FSJ_House[pid])
    if not FSP_HousePoint(x,y) then
        call FHT_Finish(pid,false,"house point outside safe playable bounds")
        return
    endif
    call FHT_Trace(pid,"temporary house allocation inside map")
    set candidate=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE),'h006',x,y,0.)
    if candidate==null or FHT_Referenced(candidate) then
        set candidate=null
        call FHT_Finish(pid,false,"house allocation")
        return
    endif
    set FHT_Unit[pid]=candidate
    call FHT_Trace(pid,"temporary house containment")
    call ShowUnit(candidate,false)
    call PauseUnit(candidate,true)
    call SetUnitInvulnerable(candidate,true)
    set candidate=null
    call FHT_Trace(pid,"house shape readback")
    if not FSP_HouseShape(FHT_Unit[pid],'h006') or not FHT_Empty(FHT_Unit[pid]) then
        call FHT_Finish(pid,false,"house containment / native begin")
        return
    endif
    call FHT_Trace(pid,"native scratch begin")
    if not FSN_Begin(pid) then
        call FHT_Finish(pid,false,"native begin")
        return
    endif
    if FHT_Policy==null then
        set FHT_Policy=InitHashtable()
    endif
    // fGap is a verified zero-ability temporary spacer in this exact base map.
    loop
        exitwhen ordinal>=6
        set charges=ordinal
        if ordinal==0 then
            set charges=0
        elseif ordinal==1 then
            set charges=120
        elseif ordinal==2 then
            set charges=127
        endif
        set flags=ordinal
        if ordinal==1 then
            set flags=7
        elseif ordinal==2 then
            set flags=6
        endif
        call FHT_Trace(pid,"item metadata "+I2S(ordinal))
        if not FSN_Stage(pid,'fGap',charges,ModuloInteger(ordinal,2)==0,flags,17169,16384,x,y) then
            call FHT_Finish(pid,false,"item allocation / metadata "+I2S(ordinal))
            return
        endif
        set ordinal=ordinal+1
    endloop
    set ordinal=0
    loop
        exitwhen ordinal>=6
        call FHT_Trace(pid,"item ability preparation "+I2S(ordinal))
        if not FSA_Prepare(pid,ordinal,false,FHT_Policy) then
            call FHT_Finish(pid,false,"item ability preparation "+I2S(ordinal))
            return
        endif
        set ordinal=ordinal+1
    endloop
    set ordinal=0
    loop
        exitwhen ordinal>=6
        set slot=ordinal
        if ordinal==0 then
            set slot=5
        elseif ordinal==1 then
            set slot=2
        elseif ordinal==2 then
            set slot=0
        elseif ordinal==3 then
            set slot=1
        elseif ordinal==4 then
            set slot=3
        else
            set slot=4
        endif
        call FHT_Trace(pid,"house placement slot "+I2S(slot))
        if not FSP_Place(pid,ordinal,FHT_Unit[pid],5,slot,'fGap') then
            call FHT_Finish(pid,false,"house placement slot "+I2S(slot))
            return
        endif
        set ordinal=ordinal+1
    endloop
    call FHT_Trace(pid,"final placement readback")
    call FHT_Finish(pid,FSP_Verify(pid) and FSP_HouseShape(FHT_Unit[pid],'h006'),"final placement readback")
endfunction

function FHT_Retry takes integer pid returns nothing
    if not FSC_PlayerValid(pid) or FHT_Busy then
        return
    endif
    if not FHT_Capacity() then
        call FHT_Message(pid,"FAIL: cleanup guard capacity exceeded; restart this private test.")
        return
    endif
    if FHT_Unit[pid]==null and FSN_Count[pid]==0 and not FSJ_Ready[pid] then
        call FHT_Message(pid,"no temporary test resources remain.")
        return
    endif
    set FHT_Busy=true
    set FHT_Checkpoint=0
    set FHT_Player=pid
    set FHT_Watchdog=CreateTimer()
    call TimerStart(FHT_Watchdog,60.,false,function FHT_Timeout)
    call FHT_Trace(pid,"trigger guard")
    call FHT_Guard(true)
    call FHT_Finish(pid,false,"cleanup retry")
endfunction

function FHT_Chat takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    if GetEventPlayerChatString()=="-savehousecleanup" then
        call FHT_Retry(pid)
    else
        call FHT_Run(pid)
    endif
endfunction

function InitTrig_ForsakenHouseProbe takes nothing returns nothing
    local integer pid=0
    set gg_trg_Forsaken_HouseProbe=CreateTrigger()
    loop
        exitwhen pid>=8
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_HouseProbe,Player(pid),"-savehousecheck",true)
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_HouseProbe,Player(pid),"-savehousecleanup",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Forsaken_HouseProbe,function FHT_Chat)
endfunction
endlibrary
