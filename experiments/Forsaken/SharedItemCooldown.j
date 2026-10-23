// Shared state only. A cast is admitted at CHANNEL before its effect handlers run.
function NativeCD_Pool takes integer raw returns integer
    return LoadInteger(NativeCDData,0,raw)
endfunction

function NativeCD_Left takes unit caster,integer pool returns real
    return RMaxBJ(0.,LoadReal(NativeCDData,32+GetPlayerId(GetOwningPlayer(caster)),pool)-TimerGetElapsed(NativeCDClock))
endfunction

function NativeCD_PlayerCaster takes unit caster returns boolean
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    return pid>=0 and pid<8 and (caster==Player_GetHero(Player(pid)) or caster==udg_SpiritOfGaya[pid+1])
endfunction

function NativeCD_Stop takes unit caster,integer pool returns nothing
    call PauseUnit(caster,true)
    call IssueImmediateOrder(caster,"stop")
    call PauseUnit(caster,false)
endfunction

// Called only from synchronized item-cast events, never a local UI callback.
function NativeCD_CategoryHolder takes unit holder,integer pool,real duration,boolean start returns nothing
    local integer slot=0
    local integer bagSize
    local integer index
    local integer level
    local integer levels
    local integer raw
    local item carried
    local ability entry
    if holder==null then
        return
    endif
    set bagSize=BlzUnitExtendedInventorySize(holder)
    loop
        exitwhen slot>=6+bagSize+9
        if slot<6 then
            set carried=UnitItemInSlot(holder,slot)
        elseif slot<6+bagSize then
            set carried=BlzUnitItemInBagSlot(holder,slot-6)
        else
            set carried=BlzUnitItemInEquipmentSlot(holder,ConvertLoadoutSlot(slot-6-bagSize))
        endif
        set index=0
        loop
            exitwhen carried==null
            set entry=BlzGetItemAbilityByIndex(carried,index)
            exitwhen entry==null
            set raw=BlzGetAbilityId(entry)
            if NativeCD_Pool(raw)==pool then
                set level=0
                set levels=BlzGetAbilityIntegerField(entry,ABILITY_IF_LEVELS)
                loop
                    exitwhen level>=levels
                    call BlzSetAbilityRealLevelField(entry,ABILITY_RLF_COOLDOWN,level,duration)
                    set level=level+1
                endloop
                if start then
                    call BlzStartUnitAbilityCooldown(holder,raw,duration)
                endif
            endif
            set index=index+1
        endloop
        set slot=slot+1
    endloop
    set entry=null
    set carried=null
endfunction

function NativeCD_Category takes unit caster,integer pool,real duration,boolean start returns nothing
    local player owner=GetOwningPlayer(caster)
    local unit hero=Player_GetHero(owner)
    local unit gaya=udg_SpiritOfGaya[GetPlayerId(owner)+1]
    call NativeCD_CategoryHolder(hero,pool,duration,start)
    if gaya!=hero then
        call NativeCD_CategoryHolder(gaya,pool,duration,start)
    endif
    set hero=null
    set gaya=null
    set owner=null
endfunction

// One shared zero-delay batch runs after the engine commits first-use timers.
function NativeCD_Commit takes nothing returns nothing
    local integer index=0
    local real duration
    loop
        exitwhen index>=NativeCDCommitCount
        if NativeCDCommitCaster[index]!=null and GetUnitTypeId(NativeCDCommitCaster[index])!=0 then
            if NativeCDCommitCategory[index] then
                call NativeCD_Category(NativeCDCommitCaster[index],NativeCDCommitRaw[index],NativeCD_Left(NativeCDCommitCaster[index],NativeCDCommitRaw[index]),true)
            else
                set duration=RMaxBJ(0.,NativeCDCommitDuration[index]-(TimerGetElapsed(NativeCDClock)-NativeCDCommitTime[index]))
                call BlzStartUnitAbilityCooldown(NativeCDCommitCaster[index],NativeCDCommitRaw[index],duration)
            endif
        endif
        set NativeCDCommitCaster[index]=null
        set index=index+1
    endloop
    set NativeCDCommitCount=0
endfunction

function NativeCD_Queue takes unit caster,integer raw,real duration,boolean category returns nothing
    if NativeCDCommitCount<8191 then
        set NativeCDCommitCaster[NativeCDCommitCount]=caster
        set NativeCDCommitRaw[NativeCDCommitCount]=raw
        set NativeCDCommitDuration[NativeCDCommitCount]=duration
        set NativeCDCommitTime[NativeCDCommitCount]=TimerGetElapsed(NativeCDClock)
        set NativeCDCommitCategory[NativeCDCommitCount]=category
        set NativeCDCommitCount=NativeCDCommitCount+1
        call TimerStart(NativeCDCommitTimer,0.,false,function NativeCD_Commit)
    endif
endfunction

function NativeCD_Channel takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    local integer pool=NativeCD_Pool(raw)
    local integer key=GetHandleId(caster)
    if pool>0 and NativeCD_PlayerCaster(caster) then
        call SaveInteger(NativeCDData,key,10,raw)
        call SaveReal(NativeCDData,key,11,TimerGetElapsed(NativeCDClock))
        call SaveBoolean(NativeCDData,key,12,NativeCD_Left(caster,pool)>.01)
        if LoadBoolean(NativeCDData,key,12) then
            call NativeCD_Stop(caster,pool)
        else
            call SaveReal(NativeCDData,key,13,SharedItemCD_Duration(caster,raw))
            call NativeCD_Category(caster,pool,LoadReal(NativeCDData,key,13),false)
        endif
    endif
    set caster=null
endfunction

function NativeCD_DurationForCast takes unit caster,integer raw returns real
    local integer key=GetHandleId(caster)
    if NativeCD_PlayerCaster(caster) and LoadInteger(NativeCDData,key,10)==raw and not LoadBoolean(NativeCDData,key,12) then
        return LoadReal(NativeCDData,key,13)
    endif
    return SharedItemCD_Duration(caster,raw)
endfunction

// Added as a condition to item spell effect triggers, so a vetoed cast cannot
// execute scripted damage/healing even if an engine item ignores the stop order.
function NativeCD_Allowed takes nothing returns boolean
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    local integer pool=NativeCD_Pool(raw)
    local integer key=GetHandleId(caster)
    local real duration=NativeCD_DurationForCast(caster,raw)
    local boolean allowed=true
    if pool>0 and NativeCD_PlayerCaster(caster) then
        if LoadInteger(NativeCDData,key,10)==raw and TimerGetElapsed(NativeCDClock)-LoadReal(NativeCDData,key,11)<.01 then
            set allowed=not LoadBoolean(NativeCDData,key,12)
        else
            set allowed=NativeCD_Left(caster,pool)<=.01
            call SaveInteger(NativeCDData,key,10,raw)
            call SaveReal(NativeCDData,key,11,TimerGetElapsed(NativeCDClock))
            call SaveBoolean(NativeCDData,key,12,not allowed)
            if allowed then
                call SaveReal(NativeCDData,key,13,duration)
            endif
        endif
    endif
    set caster=null
    return allowed
endfunction

// One admitted cast uses one duration, including items that apply Haste or Agility.


function NativeCD_Effect takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    local integer pool=NativeCD_Pool(raw)
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local real duration
    if pool>0 and NativeCD_PlayerCaster(caster) and NativeCD_Allowed() then
        set duration=NativeCD_DurationForCast(caster,raw)
        call SaveReal(NativeCDData,32+pid,pool,RMaxBJ(LoadReal(NativeCDData,32+pid,pool),TimerGetElapsed(NativeCDClock)+duration))
        call NativeCD_Queue(caster,pool,duration,true)
        call SaveReal(NativeCDData,48+pid,pool,duration)
        // Presentation observers only refresh after the category deadline is committed.
        call SaveInteger(NativeCDData,32+pid,0,LoadInteger(NativeCDData,32+pid,0)+1)
    endif
    set caster=null
endfunction

function NativeCD_Order takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer order=GetIssuedOrderId()
    local item used
    local integer pool
    if order>=852008 and order<=852013 and NativeCD_PlayerCaster(caster) then
        set used=UnitItemInSlot(caster,order-852008)
        set pool=LoadInteger(NativeCDData,1,GetItemTypeId(used))
        if pool==0 and GetItemType(used)==ITEM_TYPE_CHARGED then
            set pool=2
        endif
        if pool>0 and NativeCD_Left(caster,pool)>.01 then
            call NativeCD_Stop(caster,pool)
        endif
    endif
    set used=null
    set caster=null
endfunction

function NativeCD_Init takes nothing returns nothing
    local trigger channel=CreateTrigger()
    local trigger effectEvent=CreateTrigger()
    local trigger orders=CreateTrigger()
    call TimerStart(NativeCDClock,1000000.,false,null)
    call NativeCD_Data()
    call TriggerRegisterAnyUnitEventBJ(channel,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddAction(channel,function NativeCD_Channel)
    call TriggerRegisterAnyUnitEventBJ(effectEvent,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(effectEvent,function NativeCD_Effect)
    call TriggerRegisterAnyUnitEventBJ(orders,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerRegisterAnyUnitEventBJ(orders,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterAnyUnitEventBJ(orders,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerAddAction(orders,function NativeCD_Order)
    set channel=null
    set effectEvent=null
    set orders=null
endfunction

