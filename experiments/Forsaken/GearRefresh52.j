function QuickGear_Reseat takes unit hero,item carried returns nothing
    local integer charges=GetItemCharges(carried)
    if carried!=null then
        // Exactly the remove/add/equip lifecycle used by job transfer. The
        // caller reserves quick slot zero, so a completely full bag is safe.
        call BlzUnitUnequipItem(hero,carried)
        call UnitRemoveItem(hero,carried)
        call SetItemCharges(carried,0)
        if UnitAddItem(hero,carried) then
            call SetItemCharges(carried,charges)
            call Forsaken_RestoreStoredItem(carried)
            call BlzUnitEquipItem(hero,carried)
        else
            call SetItemCharges(carried,charges)
            call SetItemPosition(carried,GetUnitX(hero),GetUnitY(hero))
            call DisplayTimedTextToPlayer(GetOwningPlayer(hero),0,0,15,"Your equipment could not refresh. The item is beside your hero.")
        endif
    endif
endfunction

function QuickGear_LoadRefresh takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer key=GetHandleId(clock)
    local unit hero=LoadUnitHandle(QuickGearLoadData,key,0)
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    local item primary
    local item offhand
    local item quick
    local integer charges
    if hero!=null and hero==Player_GetHero(GetOwningPlayer(hero)) and FFL_Phase[pid]==0 and FFN_State[pid]==0 then
        set primary=QuickGear_Item(hero,0)
        set offhand=QuickGear_Item(hero,1)
        set quick=UnitItemInSlot(hero,0)
        set charges=GetItemCharges(quick)
        set ForsakenConvertingGear=true
        if quick!=null then
            call UnitRemoveItem(hero,quick)
        endif
        call QuickGear_Reseat(hero,primary)
        call QuickGear_Reseat(hero,offhand)
        if quick!=null then
            call SetItemCharges(quick,0)
            call UnitAddItem(hero,quick)
            call SetItemCharges(quick,charges)
        endif
        set ForsakenConvertingGear=false
        call Forsaken_SyncStoredEffects(hero)
        call Integrity_RefreshWorn(hero)
        set QuickGearRevision[pid]=QuickGearRevision[pid]+1
    endif
    call FlushChildHashtable(QuickGearLoadData,key)
    call DestroyTimer(clock)
    set primary=null
    set offhand=null
    set quick=null
    set hero=null
    set clock=null
endfunction
