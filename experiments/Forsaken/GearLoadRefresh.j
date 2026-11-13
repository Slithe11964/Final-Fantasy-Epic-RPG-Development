globals
    item array QuickGearSeenItem
    integer array QuickGearSeenRaw
    hashtable QuickGearLoadData=InitHashtable()
endglobals

function QuickGear_EquipmentChanged takes unit hero returns boolean
    local integer slot=0
    local item carried
    loop
        exitwhen slot>=2
        set carried=QuickGear_Item(hero,slot)
        if carried!=QuickGearSeenItem[slot] or GetItemTypeId(carried)!=QuickGearSeenRaw[slot] then
            set carried=null
            return true
        endif
        set slot=slot+1
    endloop
    set carried=null
    return false
endfunction

function QuickGear_LoadRefresh takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer key=GetHandleId(clock)
    local unit hero=LoadUnitHandle(QuickGearLoadData,key,0)
    local integer slot=0
    local integer cast
    local integer rank
    local item carried
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    if hero!=null and hero==Player_GetHero(GetOwningPlayer(hero)) and FFL_Phase[pid]==0 and FFN_State[pid]==0 then
        call Forsaken_SyncStoredEffects(hero)
        call Integrity_RefreshWorn(hero)
        loop
            exitwhen slot>=2
            set carried=QuickGear_Item(hero,slot)
            set cast=LoadInteger(QuickGearData,0,GetItemTypeId(carried))
            if carried!=null and cast!=0 then
                // Loading places items while equip handlers are guarded. Rebind
                // only their active spell after commit, keeping the same item,
                // slot, charges, ownership, passive effects and saved metadata.
                set rank=GetUnitAbilityLevel(hero,cast)
                if BlzGetItemAbility(carried,cast)!=null then
                    call BlzItemRemoveAbility(carried,cast)
                endif
                call BlzItemAddAbility(carried,cast)
                if rank>1 then
                    call SetUnitAbilityLevel(hero,cast,rank)
                endif
            endif
            set slot=slot+1
        endloop
        set QuickGearRevision[pid]=QuickGearRevision[pid]+1
    endif
    call FlushChildHashtable(QuickGearLoadData,key)
    call DestroyTimer(clock)
    set carried=null
    set hero=null
    set clock=null
endfunction

function QuickGear_QueueLoaded takes unit hero returns nothing
    local timer clock=CreateTimer()
    call SaveUnitHandle(QuickGearLoadData,GetHandleId(clock),0,hero)
    call TimerStart(clock,0.,false,function QuickGear_LoadRefresh)
    set clock=null
endfunction
