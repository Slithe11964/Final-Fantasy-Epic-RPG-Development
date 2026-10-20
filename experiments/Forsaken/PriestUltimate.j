    hashtable TalentShieldState=InitHashtable()
    unit array TalentRainCaster
    real array TalentRainRadius
// FUNCTIONS
function Talent_PriestChoice takes unit hero,integer choice returns boolean
    return hero!=null and Job_GetIndex(hero)==12 and Talent_Has(hero,3,choice)
endfunction

function Talent_ShieldExpire takes nothing returns nothing
    local timer pending=GetExpiredTimer()
    local unit target=LoadUnitHandle(TalentShieldState,GetHandleId(pending),0)
    call FlushChildHashtable(TalentShieldState,GetHandleId(target))
    call FlushChildHashtable(TalentShieldState,GetHandleId(pending))
    call DestroyTimer(pending)
    set target=null
    set pending=null
endfunction

function Talent_AddShield takes unit target,real amount returns nothing
    local integer key=GetHandleId(target)
    local timer pending
    if amount<=0. or GetWidgetLife(target)<=.405 then
        return
    endif
    set pending=LoadTimerHandle(TalentShieldState,key,1)
    if pending==null then
        set pending=CreateTimer()
        call SaveTimerHandle(TalentShieldState,key,1,pending)
        call SaveUnitHandle(TalentShieldState,GetHandleId(pending),0,target)
    endif
    call SaveReal(TalentShieldState,key,0,LoadReal(TalentShieldState,key,0)+amount)
    call TimerStart(pending,30.,false,function Talent_ShieldExpire)
    set pending=null
endfunction

function Talent_AbsorbShield takes unit target,real amount returns real
    local integer key=GetHandleId(target)
    local real shield=LoadReal(TalentShieldState,key,0)
    local real absorbed=RMinBJ(amount,shield)
    if absorbed>0. then
        call SaveReal(TalentShieldState,key,0,shield-absorbed)
        return amount-absorbed
    endif
    return amount
endfunction

function Talent_ShieldDeath takes nothing returns nothing
    local unit target=GetTriggerUnit()
    local timer pending=LoadTimerHandle(TalentShieldState,GetHandleId(target),1)
    if pending!=null then
        call PauseTimer(pending)
        call FlushChildHashtable(TalentShieldState,GetHandleId(pending))
        call DestroyTimer(pending)
        call FlushChildHashtable(TalentShieldState,GetHandleId(target))
    endif
    set target=null
    set pending=null
endfunction

function Talent_BlessedRain takes unit target returns boolean
    local integer pid=0
    local unit caster
    local real dx
    local real dy
    loop
        exitwhen pid>=8
        set caster=TalentRainCaster[pid]
        if Talent_PriestChoice(caster,2) and GetWidgetLife(caster)>.405 and GetUnitCurrentOrder(caster)==OrderId("tranquility") and IsUnitAlly(target,GetOwningPlayer(caster)) and not IsUnitType(target,UNIT_TYPE_STRUCTURE) then
            set dx=GetUnitX(target)-GetUnitX(caster)
            set dy=GetUnitY(target)-GetUnitY(caster)
            if dx*dx+dy*dy<=TalentRainRadius[pid]*TalentRainRadius[pid] then
                set caster=null
                return true
            endif
        endif
        set pid=pid+1
    endloop
    set caster=null
    return false
endfunction

function Talent_HealingPower takes unit hero returns real
    local real mult=1.
    if GetUnitAbilityLevel(hero,'B076')>0 then
        set mult=mult*2.
    endif
    if GetUnitAbilityLevel(hero,'B07D')>0 then
        set mult=mult*2.
    endif
    // Holy Bolts also converts Rejuvenation's healing-received increase.
    if GetUnitAbilityLevel(hero,'A13R')>0 then
        set mult=mult*1.5
    endif
    return mult-1.
endfunction

function Talent_HolyBolts takes unit hero returns real
    if Talent_PriestChoice(hero,3) then
        return Talent_HealingPower(hero)
    endif
    return 0.
endfunction

function Talent_UltimateInit takes nothing returns nothing
    local trigger deaths=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(deaths,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(deaths,function Talent_ShieldDeath)
    set deaths=null
endfunction
