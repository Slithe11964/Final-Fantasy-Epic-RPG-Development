// Snapshot the source rank of transferable buffs; panel reads never mutate this table.
function JobFX_Rank takes unit hero,integer buffId,integer abilityId returns integer
    local integer rank=LoadInteger(JobFXData,GetHandleId(hero),buffId)
    if rank<=0 then
        set rank=GetUnitAbilityLevel(hero,abilityId)
    endif
    return IMaxBJ(1,rank)
endfunction

function JobFX_RageSpeed takes unit hero returns real
    local integer raw=LoadInteger(JobFXData,GetHandleId(hero),'B00K'+1)
    local integer rank=JobFX_Rank(hero,'B00K','A025')
    local real extra=0.
    if GetUnitAbilityLevel(hero,'B07P')>0 then
        set extra=75.
    endif
    if GetUnitAbilityLevel(hero,'B00K')<=0 then
        return extra
    endif
    if raw=='A070' then
        if rank>=11 then
            return extra+120.
        endif
        return extra+55.+5.*I2R(rank)
    endif
    if rank>=11 then
        return extra+100.
    endif
    return extra+35.+5.*I2R(rank)
endfunction

function JobFX_DarkSpeed takes unit hero returns real
    local integer rank=JobFX_Rank(hero,'B082','A1AA')
    return 65.+10.*I2R(IMinBJ(6,rank))
endfunction

function JobFX_Cast takes nothing returns nothing
    local integer raw=GetSpellAbilityId()
    local integer buffId='B00K'
    local unit target=GetSpellTargetUnit()
    local unit caster=GetTriggerUnit()
    if raw!='A025' and raw!='A070' and raw!='A1AA' then
        set target=null
        set caster=null
        return
    endif
    if target==null or raw=='A025' or raw=='A1AA' then
        set target=caster
    endif
    if raw=='A1AA' then
        set buffId='B082'
    endif
    call SaveInteger(JobFXData,GetHandleId(target),buffId,GetUnitAbilityLevel(caster,raw))
    call SaveInteger(JobFXData,GetHandleId(target),buffId+1,raw)
    set target=null
    set caster=null
endfunction

function JobFX_Death takes nothing returns nothing
    call FlushChildHashtable(JobFXData,GetHandleId(GetTriggerUnit()))
endfunction

function JobFX_UndyingReady takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local unit hero=LoadUnitHandle(JobFXData,GetHandleId(clock),0)
    call GroupRemoveUnit(udg_UndyingGroup,hero)
    call FlushChildHashtable(JobFXData,GetHandleId(clock))
    call DestroyTimer(clock)
    set hero=null
    set clock=null
endfunction

function JobFX_UndyingStart takes unit hero returns nothing
    local timer clock=CreateTimer()
    call GroupAddUnit(udg_UndyingGroup,hero)
    call SaveUnitHandle(JobFXData,GetHandleId(clock),0,hero)
    call TimerStart(clock,90.,false,function JobFX_UndyingReady)
    set clock=null
endfunction

function JobFX_Shield takes unit ward,real damage returns real
    local integer key=GetHandleId(ward)
    local unit caster=LoadUnitHandle(udg_DivineShieldHash,key,4)
    local real efficiency=LoadReal(udg_DivineShieldHash,key,5)
    local real available=GetUnitState(caster,UNIT_STATE_MANA)
    local real spent
    if caster==null or GetUnitTypeId(caster)==0 or GetWidgetLife(caster)<=.405 or GetUnitAbilityLevel(caster,'Avul')>0 or efficiency<=0. then
        call UnitRemoveAbility(ward,'B051')
        call SaveBoolean(udg_DivineShieldHash,key,3,false)
        set caster=null
        return damage
    endif
    set spent=RMinBJ(damage*.5/efficiency,available)
    call SetUnitState(caster,UNIT_STATE_MANA,available-spent)
    if spent>0. then
        call Text_FloatingDamage(caster,false,0,spent,true,0)
    endif
    if spent>=available then
        call UnitRemoveAbility(ward,'B051')
        call SaveBoolean(udg_DivineShieldHash,key,3,false)
    endif
    set caster=null
    return damage-spent*efficiency
endfunction

function JobFX_Register takes nothing returns nothing
    local trigger cast=CreateTrigger()
    local trigger death=CreateTrigger()
    set JobFXData=InitHashtable()
    call TriggerRegisterAnyUnitEventBJ(cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(cast,function JobFX_Cast)
    call TriggerRegisterAnyUnitEventBJ(death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(death,function JobFX_Death)
    set cast=null
    set death=null
endfunction
