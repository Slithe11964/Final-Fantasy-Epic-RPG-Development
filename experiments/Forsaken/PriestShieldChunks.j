// Shared FIFO shield contributions. Each timer owns only its unconsumed amount.
// Unit keys: 0 total, 1 oldest timer, 2 display tag, 3 newest timer.
// Timer keys: 0 target, 1 amount, 2 next timer, 3 previous timer.
function Talent_ShieldRemove takes timer pending returns nothing
    local integer node=GetHandleId(pending)
    local unit target=LoadUnitHandle(TalentShieldState,node,0)
    local integer key=GetHandleId(target)
    local timer older=LoadTimerHandle(TalentShieldState,node,3)
    local timer newer=LoadTimerHandle(TalentShieldState,node,2)
    if older==null then
        call SaveTimerHandle(TalentShieldState,key,1,newer)
    else
        call SaveTimerHandle(TalentShieldState,GetHandleId(older),2,newer)
    endif
    if newer==null then
        call SaveTimerHandle(TalentShieldState,key,3,older)
    else
        call SaveTimerHandle(TalentShieldState,GetHandleId(newer),3,older)
    endif
    call SaveReal(TalentShieldState,key,0,RMaxBJ(0.,LoadReal(TalentShieldState,key,0)-LoadReal(TalentShieldState,node,1)))
    call PauseTimer(pending)
    call FlushChildHashtable(TalentShieldState,node)
    call DestroyTimer(pending)
    call Talent_ShieldDisplayUpdate(target)
    if newer==null and older==null then
        call FlushChildHashtable(TalentShieldState,key)
    endif
    set target=null
    set older=null
    set newer=null
endfunction

function Talent_ShieldExpire takes nothing returns nothing
    call Talent_ShieldRemove(GetExpiredTimer())
endfunction

function Talent_AddShield takes unit target,real amount returns nothing
    local integer key=GetHandleId(target)
    local timer pending
    local timer older
    local integer node
    if target==null or amount<=0. or GetWidgetLife(target)<=.405 then
        return
    endif
    set pending=CreateTimer()
    set node=GetHandleId(pending)
    set older=LoadTimerHandle(TalentShieldState,key,3)
    call SaveUnitHandle(TalentShieldState,node,0,target)
    call SaveReal(TalentShieldState,node,1,amount)
    call SaveTimerHandle(TalentShieldState,node,3,older)
    if older==null then
        call SaveTimerHandle(TalentShieldState,key,1,pending)
    else
        call SaveTimerHandle(TalentShieldState,GetHandleId(older),2,pending)
    endif
    call SaveTimerHandle(TalentShieldState,key,3,pending)
    call SaveReal(TalentShieldState,key,0,LoadReal(TalentShieldState,key,0)+amount)
    call TimerStart(pending,30.,false,function Talent_ShieldExpire)
    call Talent_ShieldDisplayUpdate(target)
    set pending=null
    set older=null
endfunction

function Talent_AbsorbShield takes unit target,real amount returns real
    local integer key=GetHandleId(target)
    local timer pending=LoadTimerHandle(TalentShieldState,key,1)
    local integer node
    local real shield
    local real absorbed
    loop
        exitwhen pending==null or amount<=0.
        set node=GetHandleId(pending)
        set shield=LoadReal(TalentShieldState,node,1)
        set absorbed=RMinBJ(amount,shield)
        set amount=amount-absorbed
        if absorbed>=shield then
            call Talent_ShieldRemove(pending)
        else
            call SaveReal(TalentShieldState,node,1,shield-absorbed)
            call SaveReal(TalentShieldState,key,0,RMaxBJ(0.,LoadReal(TalentShieldState,key,0)-absorbed))
            call Talent_ShieldDisplayUpdate(target)
        endif
        set pending=LoadTimerHandle(TalentShieldState,key,1)
    endloop
    set pending=null
    return amount
endfunction

function Talent_ShieldDeath takes nothing returns nothing
    local unit target=GetTriggerUnit()
    local timer pending=LoadTimerHandle(TalentShieldState,GetHandleId(target),1)
    loop
        exitwhen pending==null
        call Talent_ShieldRemove(pending)
        set pending=LoadTimerHandle(TalentShieldState,GetHandleId(target),1)
    endloop
    set pending=null
    set target=null
endfunction
