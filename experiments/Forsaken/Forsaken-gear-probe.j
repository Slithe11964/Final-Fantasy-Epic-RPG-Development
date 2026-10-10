library TForsakenGearProbe requires TForsakenHouseProbe, TForsakenSaveEquipment
// Private real-item test on an unpublished contained hero; shared exclusion/recovery.
globals
    trigger gg_trg_Forsaken_GearProbe=null
endglobals

// Bag getters may expose no abilities. Acceptance here is limited to this fixture:
// both IDs were read and the passive removed in the equipment slot before transfer.
// The caller separately requires unchanged speed; shared FSA_Check stays strict.
function FGT_CheckStoredBoots takes integer pid,unit target returns boolean
    local integer index=pid*57+1
    if not FSN_EffectsReady[index] or not FSN_EffectsStored[index] or FSN_EffectCount[index]!=2 or FSN_PlacedUnit[index]!=target or FSN_PlacedHolder[index]!=2 or FSN_PlacedSlot[index]!=29 or not IsItemOwned(FSN_Item[index]) or UnitItemInBagSlot(target,29)!=FSN_Item[index] or not FSA_PreparationContainment(pid,index) then
        if FSN_LastError[pid]=="" then
            set FSN_LastError[pid]="stored boots tracked slot or prepared plan"
        endif
        return false
    endif
    if BlzGetItemAbility(FSN_Item[index],'A0MU')!=null then
        set FSN_LastError[pid]="stored boots readable speed passive"
        return false
    endif
    if BlzGetItemAbilityByIndex(FSN_Item[index],0)!=null then
        return FSA_Check(index)
    endif
    return true
endfunction

// Private place-then-prepare gate on the journaled, unpublished contained hero only.
function FGT_PlaceBoots takes integer pid,integer ordinal,unit target,boolean stored returns boolean
    local integer index=pid*57+ordinal
    local integer position=0
    local integer auxiliary
    local item spacer
    local integer first=pid*57
    local string failure
    if not FHT_Busy or FHT_Unit[pid]!=target or FHT_Referenced(target) or not IsUnitHidden(target) or not IsUnitPaused(target) or not BlzIsUnitInvulnerable(target) or GetOwningPlayer(target)!=Player(pid) then
        set FSN_LastError[pid]="boots temporary hero containment"
        return false
    endif
    if FSN_State[pid]!=1 or FSN_Busy[pid] or FSN_Executing[pid] or FSN_AuxCount[pid]!=0 or ordinal<0 or ordinal>=FSN_Count[pid] or FSN_Raw[index]!='f003' or FSN_EffectsReady[index] or not FSN_Check(pid,index) then
        if FSN_LastError[pid]=="" then
            set FSN_LastError[pid]="boots staging state="+I2S(FSN_State[pid])
        endif
        return false
    endif
    if UnitExtendedInventorySize(target)!=30 or (stored and UnitItemInBagSlot(target,29)!=null) or (not stored and (UnitItemInSlot(target,0)!=null or UnitItemInEquipmentSlot(target,ConvertLoadoutSlot(3))!=null)) then
        set FSN_LastError[pid]="boots destination capacity or occupancy"
        return false
    endif
    if stored then
        // Only owned test allocations move; the first pair keeps its original plan.
        if not FSP_Check(pid,first) then
            set FSN_LastError[pid]="boots first equipment before swap"
            return false
        endif
        call UnitUnequipItem(target,FSN_Item[first])
        call UnitRemoveItem(target,FSN_Item[first])
        call SetItemVisible(FSN_Item[first],false)
        if UnitItemInEquipmentSlot(target,ConvertLoadoutSlot(3))!=null or not FSN_Check(pid,first) then
            set FSN_LastError[pid]="boots first equipment detach"
            return false
        endif
        call UnitAddItem(target,FSN_Item[index])
        call UnitEquipItem(target,FSN_Item[index])
        set FSN_PlacedItem[index]=FSN_Item[index]
        set FSN_PlacedUnit[index]=target
        set FSN_PlacedOwner[index]=Player(pid)
        set FSN_PlacedHolder[index]=3
        set FSN_PlacedSlot[index]=3
        if not IsItemOwned(FSN_Item[index]) or not FSA_PreparationContainment(pid,index) then
            set FSN_LastError[pid]="boots second equipment pickup"
            return false
        endif
        if not FSA_Prepare(pid,ordinal,false,FHT_Policy) then
            return false
        endif
        if FSN_EffectCount[index]!=2 then
            set FSN_LastError[pid]="boots second equipment plan wanted2 actual="+I2S(FSN_EffectCount[index])
            return false
        endif
        // Diagnostic-only suspension after strict equipped preparation, under FHT guard.
        set FSN_EffectsStored[index]=true
        call BlzItemRemoveAbility(FSN_Item[index],'A0MU')
        if not FSA_Check(index) or not FSA_PreparationContainment(pid,index) then
            return false
        endif
        call UnitUnequipItem(target,FSN_Item[index])
        call UnitRemoveItem(target,FSN_Item[index])
        call SetItemVisible(FSN_Item[index],false)
        if UnitItemInEquipmentSlot(target,ConvertLoadoutSlot(3))!=null or not FSN_Check(pid,index) then
            set FSN_LastError[pid]="boots second equipment detach"
            return false
        endif
        call UnitAddItem(target,FSN_Item[first])
        call UnitEquipItem(target,FSN_Item[first])
        // Re-equipped getters may lag the native move. Yield outside FSN operations.
        call FHT_Trace(pid,"settled first equipment return")
        if not FHT_Busy or FHT_Unit[pid]!=target or FSN_State[pid]!=1 or FSN_Count[pid]!=2 or FSN_Busy[pid] or FSN_Executing[pid] then
            set FSN_LastError[pid]="boots equipment return interrupted"
            return false
        endif
        if not FSN_Check(pid,index) or not FSN_CheckMetadata(pid,first) or FHT_Referenced(target) or not IsUnitHidden(target) or not IsUnitPaused(target) or not BlzIsUnitInvulnerable(target) or GetOwningPlayer(target)!=Player(pid) then
            set FSN_LastError[pid]="boots equipment return containment after wait"
            return false
        endif
        if not FSP_Check(pid,first) then
            set failure=FSN_LastError[pid]
            call FSA_ReadbackFailure(first,"first equipment return",'A0MU')
            set FSN_LastError[pid]="boots first equipment return: "+failure+"; equipment raw="+I2S(GetItemTypeId(UnitItemInEquipmentSlot(target,ConvertLoadoutSlot(3))))+" item raw="+I2S(GetItemTypeId(FSN_Item[first]))+"; "+FSN_LastError[pid]
            return false
        endif
    endif
    // Reserve earlier storage positions with the reviewed inert fixture.
    loop
        exitwhen not stored or position>=35
        if (position<6 and UnitItemInSlot(target,position)==null) or (position>=6 and UnitItemInBagSlot(target,position-6)==null) then
            set spacer=CreateItem('fGap',GetUnitX(target),GetUnitY(target))
            if spacer==null then
                set FSN_LastError[pid]="boots spacer allocation position="+I2S(position)
                return false
            endif
            set auxiliary=pid*36+FSN_AuxCount[pid]
            set FSN_AuxItem[auxiliary]=spacer
            set FSN_AuxCount[pid]=FSN_AuxCount[pid]+1
            call SetItemVisible(spacer,false)
            call UnitAddItem(target,spacer)
            if GetItemTypeId(spacer)!='fGap' or IsItemVisible(spacer) or (position<6 and UnitItemInSlot(target,position)!=spacer) or (position>=6 and UnitItemInBagSlot(target,position-6)!=spacer) then
                set FSN_LastError[pid]="boots spacer readback position="+I2S(position)
                set spacer=null
                return false
            endif
        endif
        set position=position+1
    endloop
    set spacer=null
    call UnitAddItem(target,FSN_Item[index])
    if not stored then
        call UnitEquipItem(target,FSN_Item[index])
    endif
    set FSN_PlacedItem[index]=FSN_Item[index]
    set FSN_PlacedUnit[index]=target
    set FSN_PlacedOwner[index]=Player(pid)
    if stored then
        set FSN_PlacedHolder[index]=2
        set FSN_PlacedSlot[index]=29
    else
        set FSN_PlacedHolder[index]=3
        set FSN_PlacedSlot[index]=3
    endif
    if not IsItemOwned(FSN_Item[index]) or FSP_At(target,FSN_PlacedHolder[index],FSN_PlacedSlot[index])!=FSN_Item[index] or not FSA_PreparationContainment(pid,index) then
        set FSN_LastError[pid]="boots held slot or metadata"
        return false
    endif
    if not stored and not FSA_Prepare(pid,ordinal,false,FHT_Policy) then
        return false
    endif
    if FSN_EffectCount[index]!=2 then
        set FSN_LastError[pid]="boots held plan wanted2 actual="+I2S(FSN_EffectCount[index])
        return false
    endif
    if (stored and not FGT_CheckStoredBoots(pid,target)) or (not stored and not FSP_Check(pid,index)) then
        return false
    endif
    if not FSN_CleanupAux(pid) then
        set FSN_LastError[pid]="boots spacer cleanup"
        return false
    endif
    if stored then
        return FGT_CheckStoredBoots(pid,target)
    endif
    return FSP_Check(pid,index)
endfunction

function FGT_Run takes integer pid returns nothing
    local integer other=0
    local unit target
    local real x
    local real y
    local real baseline
    local real actual
    local real equipped
    if not FSC_PlayerValid(pid) or FHT_Busy then
        return
    endif
    loop
        exitwhen other>=8
        if FSX_Phase[other]!=0 then
            return
        endif
        set other=other+1
    endloop
    if not FHT_Capacity() or FHT_Unit[pid]!=null or FSN_State[pid]!=0 or FSN_Count[pid]!=0 or FSN_AuxCount[pid]!=0 or FSJ_Ready[pid] then
        call FHT_Message(pid,"previous test needs cleanup; use -savehousecleanup.")
        return
    endif
    set FHT_GearMode=true
    set FHT_Busy=true
    set FHT_Checkpoint=0
    call FHT_Trace(pid,"original inventory journal")
    if not FSJ_Capture(pid,udg_PlayerHero[pid+1],udg_SpiritOfGaya[pid+1],udg_PlayerHouse[pid+1],true) then
        set FHT_Busy=false
        call FHT_Message(pid,"FAIL: original journal; select a hero and stand still.")
        return
    endif
    set FHT_Player=pid
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
        call FHT_Finish(pid,false,"temporary hero point")
        return
    endif
    call FHT_Trace(pid,"temporary hero allocation")
    set target=CreateUnit(Player(pid),GetUnitTypeId(udg_PlayerHero[pid+1]),x,y,0.)
    if target==null or FHT_Referenced(target) then
        set target=null
        call FHT_Finish(pid,false,"temporary hero allocation")
        return
    endif
    set FHT_Unit[pid]=target
    call FHT_Trace(pid,"temporary hero containment and inventory abilities")
    call ShowUnit(target,false)
    call PauseUnit(target,true)
    call SetUnitInvulnerable(target,true)
    call UnitAddAbility(target,'fBag')
    call UnitAddAbility(target,'fGer')
    call UnitAddAbility(target,'ASpc')
    if not IsUnitType(target,UNIT_TYPE_HERO) or not IsUnitHidden(target) or not IsUnitPaused(target) or not BlzIsUnitInvulnerable(target) or GetOwningPlayer(target)!=Player(pid) or UnitInventorySize(target)!=6 or UnitExtendedInventorySize(target)!=30 or not FHT_Empty(target) then
        set target=null
        call FHT_Finish(pid,false,"temporary hero inventory shape")
        return
    endif
    set baseline=GetUnitMoveSpeed(target)
    // Measure native speed rather than assuming a setter's requested value.
    // Keep room below this map's522 maximum for the reviewed80 bonus.
    if baseline<45. or baseline>442. then
        set FSN_LastError[pid]="speed baseline outside45..442 actual="+R2S(baseline)
        set target=null
        call FHT_Finish(pid,false,"speed baseline")
        return
    endif
    call FHT_Trace(pid,"real boots native staging")
    if not FSN_Begin(pid) then
        set target=null
        call FHT_Finish(pid,false,"native begin")
        return
    endif
    // f003 has max health1, A0MU speed80 and the zero-stat fGmk marker.
    if not FSN_Stage(pid,'f003',0,true,5,16256,0,x,y) or not FSN_Stage(pid,'f003',120,false,7,16256,0,x,y) then
        set target=null
        call FHT_Finish(pid,false,"real boots metadata")
        return
    endif
    if FHT_Policy==null then
        set FHT_Policy=InitHashtable()
    endif
    call SaveInteger(FHT_Policy,0,'A0MU',1)
    call SaveInteger(FHT_Policy,0,'fGmk',2)
    call FHT_Trace(pid,"real boots equipment slot3")
    if not FGT_PlaceBoots(pid,0,target,false) then
        set target=null
        call FHT_Finish(pid,false,"real boots equipment slot3")
        return
    endif
    // Validate the exact bonus against the same hero after owned item deletion.
    // This does not assume the fresh allocation speed is already recalculated.
    call FHT_Trace(pid,"equipped movement speed readback")
    set equipped=GetUnitMoveSpeed(target)
    if equipped<45. or equipped>522. then
        set FSN_LastError[pid]="equipped speed outside45..522 actual="+R2S(equipped)
        set target=null
        call FHT_Finish(pid,false,"equipped speed")
        return
    endif
    call FHT_Trace(pid,"stored boots bag slot29")
    if not FGT_PlaceBoots(pid,1,target,true) then
        set target=null
        call FHT_Finish(pid,false,"stored boots bag slot29")
        return
    endif
    set FSN_State[pid]=4
    call FHT_Trace(pid,"stored passive and whole inventory readback")
    set actual=GetUnitMoveSpeed(target)
    if not FGT_CheckStoredBoots(pid,target) or not FSE_CheckEquipment(pid,target) or actual!=equipped then
        set FSN_LastError[pid]="stored speed wanted="+R2S(equipped)+" actual="+R2S(actual)
        set target=null
        call FHT_Finish(pid,false,"stored passive or inventory readback")
        return
    endif
    call FHT_Trace(pid,"owned item cleanup")
    if not FSN_Abort(pid) then
        set target=null
        call FHT_Finish(pid,false,"owned item cleanup")
        return
    endif
    call FHT_Trace(pid,"empty inventory and restored baseline speed")
    set actual=GetUnitMoveSpeed(target)
    if not FHT_Empty(target) or actual<45. or actual>442. or equipped!=actual+80. then
        set FSN_LastError[pid]="cleanup speed wanted="+R2S(equipped-80.)+" actual="+R2S(actual)+" equipped="+R2S(equipped)
        set target=null
        call FHT_Finish(pid,false,"cleanup baseline speed")
        return
    endif
    set target=null
    call FHT_Finish(pid,true,"gear final readback")
endfunction

function FGT_Chat takes nothing returns nothing
    call FGT_Run(GetPlayerId(GetTriggerPlayer()))
endfunction

function InitTrig_ForsakenGearProbe takes nothing returns nothing
    local integer pid=0
    set gg_trg_Forsaken_GearProbe=CreateTrigger()
    loop
        exitwhen pid>=8
        call TriggerRegisterPlayerChatEvent(gg_trg_Forsaken_GearProbe,Player(pid),"-savegearcheck",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Forsaken_GearProbe,function FGT_Chat)
endfunction
endlibrary
