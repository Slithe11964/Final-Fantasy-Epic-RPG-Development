library TAbil requires TText
globals
    hashtable JobFXData=null
endglobals

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

function Abil_CopyOne takes unit u,unit t,integer a returns boolean
    if(GetUnitAbilityLevel(u,a)>0)then
        return UnitAddAbility(t,a)
    endif
    return false
endfunction

function Abil_CopyPassives takes unit u,unit t returns nothing
    call Abil_CopyOne(u,t,'A0P9') // 'A0P9': ability "Focus"
    call Abil_CopyOne(u,t,'A0RF') // 'A0RF': ability "Serenity"
    call Abil_CopyOne(u,t,'A0PA') // 'A0PA': ability "Adrenaline"
    call Abil_CopyOne(u,t,'A0RG') // 'A0RG': ability "Spellbreaker"
    call Abil_CopyOne(u,t,'A0T9') // 'A0T9': ability "Last Stand"
    call Abil_CopyOne(u,t,'A0ME') // 'A0ME': ability "Omni Ward"
    call Abil_CopyOne(u,t,'A0LV') // 'A0LV': ability "Fire Resistance"
    call Abil_CopyOne(u,t,'A0LW') // 'A0LW': ability "Ice Resistance"
    call Abil_CopyOne(u,t,'A0LX') // 'A0LX': ability "Thunder Resistance"
    call Abil_CopyOne(u,t,'A0LY') // 'A0LY': ability "Water Resistance"
    call Abil_CopyOne(u,t,'A0LZ') // 'A0LZ': ability "Earth Resistance"
    call Abil_CopyOne(u,t,'A0M0') // 'A0M0': ability "Wind Resistance"
    call Abil_CopyOne(u,t,'A1A4') // 'A1A4': ability "Non-elemental Damage"
    call Abil_CopyOne(u,t,'A15B') // 'A15B': ability "Omni Boost"
    call Abil_CopyOne(u,t,'A15C') // 'A15C': ability "Fire Boost"
    call Abil_CopyOne(u,t,'A15E') // 'A15E': ability "Ice Boost"
    call Abil_CopyOne(u,t,'A15D') // 'A15D': ability "Thunder Boost"
    call Abil_CopyOne(u,t,'A15F') // 'A15F': ability "Water Boost"
    call Abil_CopyOne(u,t,'A15G') // 'A15G': ability "Earth Boost"
    call Abil_CopyOne(u,t,'A15H') // 'A15H': ability "Wind Boost"
    call Abil_CopyOne(u,t,'A19Y') // 'A19Y': ability "Omni Knowledge"
    call Abil_CopyOne(u,t,'A19S') // 'A19S': ability "Fire Knowledge"
    call Abil_CopyOne(u,t,'A19T') // 'A19T': ability "Ice Knowledge"
    call Abil_CopyOne(u,t,'A19U') // 'A19U': ability "Thunder Knowledge"
    call Abil_CopyOne(u,t,'A19V') // 'A19V': ability "Water Knowledge"
    call Abil_CopyOne(u,t,'A19W') // 'A19W': ability "Earth Knowledge"
    call Abil_CopyOne(u,t,'A19X') // 'A19X': ability "Wind Knowledge"
    call Abil_CopyOne(u,t,'A0MG') // 'A0MG': ability "Omni Spell Amplification"
    call Abil_CopyOne(u,t,'A0LJ') // 'A0LJ': ability "Fire Spell Amplification"
    call Abil_CopyOne(u,t,'A0LK') // 'A0LK': ability "Ice Spell Amplification"
    call Abil_CopyOne(u,t,'A0LL') // 'A0LL': ability "Thunder Spell Amplification"
    call Abil_CopyOne(u,t,'A0LM') // 'A0LM': ability "Water Spell Amplification"
    call Abil_CopyOne(u,t,'A0LN') // 'A0LN': ability "Earth Spell Amplification"
    call Abil_CopyOne(u,t,'A0LO') // 'A0LO': ability "Wind Spell Amplification"
    call Abil_CopyOne(u,t,'A0MI') // 'A0MI': ability "Omni Orb Amplification"
    call Abil_CopyOne(u,t,'A0M7') // 'A0M7': ability "Fire Orb Amplification"
    call Abil_CopyOne(u,t,'A0M8') // 'A0M8': ability "Ice Orb Amplification"
    call Abil_CopyOne(u,t,'A0M9') // 'A0M9': ability "Thunder Orb Amplification"
    call Abil_CopyOne(u,t,'A0MA') // 'A0MA': ability "Water Orb Amplification"
    call Abil_CopyOne(u,t,'A0MB') // 'A0MB': ability "Earth Orb Amplification"
    call Abil_CopyOne(u,t,'A0MC') // 'A0MC': ability "Wind Orb Amplification"
endfunction

function Abil_GetLevel takes unit u,integer l_abilId returns integer
    local integer l_level=GetUnitAbilityLevel(u,l_abilId)
    // An item spell cast from a unit that does not list the ability (a backpack page, or the
    // hero casting an item it holds) still has rank 1 while its spell is being cast.
    if l_level<=0 and l_abilId!=0 and GetSpellAbilityId()==l_abilId then
        set l_level=1
    endif
    if udg_AbilityLevelShift then
        return l_level-1
    else
        return l_level
    endif
endfunction

function InitTrig_Abil takes nothing returns nothing
endfunction

endlibrary
