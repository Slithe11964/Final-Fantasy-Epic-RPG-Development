// Shared state only. A cast is admitted at CHANNEL before its effect handlers run.
function NativeCD_Pool takes integer raw returns integer
    return LoadInteger(NativeCDData,0,raw)
endfunction

function NativeCD_Left takes unit caster,integer pool returns real
    return RMaxBJ(0.,LoadReal(NativeCDData,GetPlayerId(GetOwningPlayer(caster)),pool)-TimerGetElapsed(NativeCDClock))
endfunction

function NativeCD_PlayerCaster takes unit caster returns boolean
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    return pid>=0 and pid<8 and (caster==Player_GetHero(Player(pid)) or caster==udg_SpiritOfGaya[pid+1])
endfunction

function NativeCD_Stop takes unit caster,integer pool returns nothing
    call PauseUnit(caster,true)
    call IssueImmediateOrder(caster,"stop")
    call PauseUnit(caster,false)
    call DisplayTimedTextToPlayer(GetOwningPlayer(caster),0,0,3,"|cffff0000Shared item cooldown: "+R2SW(NativeCD_Left(caster,pool),1,1)+" seconds remaining.|r")
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
        endif
    endif
    set caster=null
endfunction

// Added as a condition to item spell effect triggers, so a vetoed cast cannot
// execute scripted damage/healing even if an engine item ignores the stop order.
function NativeCD_Allowed takes nothing returns boolean
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    local integer pool=NativeCD_Pool(raw)
    local integer key=GetHandleId(caster)
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
                call SaveReal(NativeCDData,key,13,SharedItemCD_Duration(caster,raw))
            endif
        endif
    endif
    set caster=null
    return allowed
endfunction

// One admitted cast uses one duration, including items that apply Haste or Agility.
function NativeCD_DurationForCast takes unit caster,integer raw returns real
    local integer key=GetHandleId(caster)
    if NativeCD_PlayerCaster(caster) and LoadInteger(NativeCDData,key,10)==raw and not LoadBoolean(NativeCDData,key,12) and TimerGetElapsed(NativeCDClock)-LoadReal(NativeCDData,key,11)<.01 then
        return LoadReal(NativeCDData,key,13)
    endif
    return SharedItemCD_Duration(caster,raw)
endfunction

function NativeCD_Effect takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    local integer pool=NativeCD_Pool(raw)
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local real duration
    if pool>0 and NativeCD_PlayerCaster(caster) and NativeCD_Allowed() then
        set duration=NativeCD_DurationForCast(caster,raw)
        call SaveReal(NativeCDData,pid,pool,RMaxBJ(LoadReal(NativeCDData,pid,pool),TimerGetElapsed(NativeCDClock)+duration))
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
