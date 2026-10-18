    hashtable PriestBuffTypes=InitHashtable()
    hashtable PriestBuffSource=InitHashtable()
    hashtable PriestBuffRanks=InitHashtable()
    hashtable PriestBuffClone=InitHashtable()
    hashtable PriestBuffUntil=InitHashtable()
    hashtable PriestBuffExpiry=InitHashtable()
    hashtable PriestReplay=InitHashtable()
    hashtable PriestDeferred=InitHashtable()
    hashtable PriestAbilityText=InitHashtable()
    integer array PriestBuffIds
    integer PriestBuffCount=0
    integer PriestRefreshSerial=0
    real array PriestRainHealing
    real array PriestRainRadius
    real array PriestRainPeriod
    real array PriestRainDuration
    real array PriestRegenDuration
    unit array PriestRainCaster
    real array PriestRainLeft
    real array PriestRainNext
    group array PriestRainEnemies
    timer PriestRainTimer=null
    integer PriestRainCount=0
    integer PriestTooltipOffset=PTTIPOFFSET
// FUNCTIONS
function Priest_CooldownBase takes unit caster,integer raw,integer level returns real
    if raw=='A0W9' and Talent_Active(caster,12,2,2,'A0W9') then
        return 45.
    endif
    return BlzGetAbilityCooldown(raw,level)
endfunction

function Priest_EsunaChannel takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    if GetSpellAbilityId()=='A0W9' then
        if Talent_Active(caster,12,2,2,'A0W9') then
            call SaveReal(CooldownTalentBase,GetHandleId(caster),'A0W9',45.)
        else
            call RemoveSavedReal(CooldownTalentBase,GetHandleId(caster),'A0W9')
        endif
        call BlzSetUnitAbilityCooldown(caster,'A0W9',udg_AbilityLevelIndex,Priest_CooldownBase(caster,'A0W9',udg_AbilityLevelIndex))
    endif
    set caster=null
endfunction

function Priest_SpecialExpire takes nothing returns nothing
    local timer expiry=GetExpiredTimer()
    local unit target=LoadUnitHandle(PriestBuffExpiry,GetHandleId(expiry),0)
    local integer buffId=LoadInteger(PriestBuffExpiry,GetHandleId(expiry),1)
    if LoadTimerHandle(PriestBuffExpiry,GetHandleId(target),buffId)==expiry then
        call UnitRemoveAbility(target,buffId)
        call RemoveSavedHandle(PriestBuffExpiry,GetHandleId(target),buffId)
    endif
    call FlushChildHashtable(PriestBuffExpiry,GetHandleId(expiry))
    call DestroyTimer(expiry)
    set expiry=null
    set target=null
endfunction

function Priest_RecordUnit takes unit target,integer raw,integer rank returns nothing
    local integer i=0
    local integer buffId
    local timer previous
    loop
        exitwhen i>=LoadInteger(PriestBuffTypes,raw,rank*16)
        set buffId=LoadInteger(PriestBuffTypes,raw,rank*16+i+1)
        if buffId=='B006' and raw!='A00L' and raw!='pReg' then
            call SaveBoolean(udg_HealOverTimeHash,GetHandleId(target),10,false)
            call SaveInteger(udg_HealOverTimeHash,GetHandleId(target),11,LoadInteger(udg_HealOverTimeHash,GetHandleId(target),11)+1)
        endif
        set previous=LoadTimerHandle(PriestBuffExpiry,GetHandleId(target),buffId)
        if previous!=null then
            call PauseTimer(previous)
            call FlushChildHashtable(PriestBuffExpiry,GetHandleId(previous))
            call DestroyTimer(previous)
            call RemoveSavedHandle(PriestBuffExpiry,GetHandleId(target),buffId)
        endif
        call SaveInteger(PriestBuffSource,GetHandleId(target),buffId,raw)
        call SaveInteger(PriestBuffRanks,GetHandleId(target),buffId,rank)
        call SaveReal(PriestBuffUntil,GetHandleId(target),buffId,SupportBuff_Now()+LoadReal(PriestBuffTypes,raw,rank*16+10))
        set i=i+1
    endloop
    set previous=null
endfunction

function Priest_RecordBuff takes nothing returns nothing
    local integer raw=GetSpellAbilityId()
    local integer rank=IMaxBJ(1,GetUnitAbilityLevel(GetTriggerUnit(),raw))
    local unit target=GetSpellTargetUnit()
    local group nearby
    local unit member
    local real radius
    if not HaveSavedInteger(PriestBuffTypes,raw,1) then
        set target=null
        return
    endif
    if target==null then
        set target=GetTriggerUnit()
    endif
    call Priest_RecordUnit(target,raw,rank)
    set radius=LoadReal(PriestBuffTypes,raw,rank*16+9)
    if radius>1. then
        set nearby=CreateGroup()
        call GroupEnumUnitsInRange(nearby,GetUnitX(target),GetUnitY(target),radius,null)
        loop
            set member=FirstOfGroup(nearby)
            exitwhen member==null
            call GroupRemoveUnit(nearby,member)
            if IsUnitAlly(member,GetOwningPlayer(GetTriggerUnit())) and GetWidgetLife(member)>.405 then
                call Priest_RecordUnit(member,raw,rank)
            endif
        endloop
        call DestroyGroup(nearby)
        set nearby=null
    endif
    set target=null
    set member=null
endfunction

function Priest_Reapply takes unit target,integer raw,integer rank returns nothing
    local unit dummy=CreateUnit(GetOwningPlayer(target),'h02S',GetUnitX(target),GetUnitY(target),0.)
    local integer clone=LoadInteger(PriestBuffTypes,raw,1)
    call UnitAddAbility(dummy,clone)
    call SetUnitAbilityLevel(dummy,clone,rank)
    call SetUnitState(dummy,UNIT_STATE_MANA,GetUnitState(dummy,UNIT_STATE_MAX_MANA))
    if LoadBoolean(PriestBuffTypes,raw,3) then
        call IssueImmediateOrder(dummy,LoadStr(PriestBuffTypes,raw,2))
    else
        call IssueTargetOrder(dummy,LoadStr(PriestBuffTypes,raw,2),target)
    endif
    call UnitApplyTimedLife(dummy,'BTLF',1.)
    set dummy=null
endfunction

function Priest_ReapplyBuff takes unit target,integer raw,integer rank,integer buffId returns nothing
    local integer clone=LoadInteger(PriestBuffClone,raw,buffId)
    local unit dummy
    local timer expiry
    local real remaining
    local boolean accepted
    if clone==0 then
        return
    endif
    set dummy=CreateUnit(GetOwningPlayer(target),'h02S',GetUnitX(target),GetUnitY(target),0.)
    call UnitAddAbility(dummy,clone)
    call SetUnitAbilityLevel(dummy,clone,rank)
    call SetUnitState(dummy,UNIT_STATE_MANA,GetUnitState(dummy,UNIT_STATE_MAX_MANA))
    if LoadBoolean(PriestBuffTypes,raw,3) then
        set accepted=IssueImmediateOrder(dummy,LoadStr(PriestBuffTypes,raw,2))
    else
        set accepted=IssueTargetOrder(dummy,LoadStr(PriestBuffTypes,raw,2),target)
    endif
    if accepted and LoadBoolean(PriestBuffTypes,0,buffId) then
        set remaining=RMaxBJ(0.,LoadReal(PriestBuffUntil,GetHandleId(target),buffId)-SupportBuff_Now())+3.
        call SaveReal(PriestBuffUntil,GetHandleId(target),buffId,SupportBuff_Now()+remaining)
        set expiry=LoadTimerHandle(PriestBuffExpiry,GetHandleId(target),buffId)
        if expiry==null then
            set expiry=CreateTimer()
            call SaveTimerHandle(PriestBuffExpiry,GetHandleId(target),buffId,expiry)
            call SaveUnitHandle(PriestBuffExpiry,GetHandleId(expiry),0,target)
            call SaveInteger(PriestBuffExpiry,GetHandleId(expiry),1,buffId)
        endif
        call TimerStart(expiry,remaining,false,function Priest_SpecialExpire)
    endif
    call UnitApplyTimedLife(dummy,'BTLF',1.)
    set dummy=null
    set expiry=null
endfunction

function Priest_Refresh takes unit target returns nothing
    local integer i=0
    local integer buffId
    local integer raw
    local integer rank
    local unit source
    local timer expiry
    if target==null then
        return
    endif
    set PriestRefreshSerial=PriestRefreshSerial+1
    loop
        exitwhen i>=PriestBuffCount
        set buffId=PriestBuffIds[i]
        if GetUnitAbilityLevel(target,buffId)>0 then
            set raw=LoadInteger(PriestBuffSource,GetHandleId(target),buffId)
            set rank=LoadInteger(PriestBuffRanks,GetHandleId(target),buffId)
            if raw!=0 and rank>0 then
                call Priest_ReapplyBuff(target,raw,rank,buffId)
            endif
        endif
        set i=i+1
    endloop
    // These buffs also own script timers. Restart those timers without reapplying
    // the gameplay action, resetting accumulated power, or creating another link.
    if GetUnitAbilityLevel(target,'B051')>0 and LoadBoolean(udg_DivineShieldHash,GetHandleId(target),3) then
        set source=LoadUnitHandle(udg_DivineShieldHash,GetHandleId(target),4)
        set expiry=LoadTimerHandle(udg_DivineShieldHash,GetHandleId(source),2)
        if expiry!=null then
            call TimerStart(expiry,TimerGetRemaining(expiry)+3.,false,function Trig_Prophet_DivineShield_ExpireLink)
        endif
    endif
    if GetUnitAbilityLevel(target,'B07R')>0 and IsUnitInGroup(target,udg_RunicGroup) then
        set expiry=LoadTimerHandle(udg_RunicHash,GetHandleId(target),7)
        if expiry!=null then
            call TimerStart(expiry,TimerGetRemaining(expiry)+3.,false,function Trig_Runic_Shield_Expire)
        endif
    endif
    call SupportBuff_Refresh(target)
    set expiry=null
    set source=null
endfunction

function Priest_SwiftApply takes nothing returns nothing
    local timer pending=GetExpiredTimer()
    local unit target=LoadUnitHandle(PriestDeferred,GetHandleId(pending),0)
    local integer rank=LoadInteger(PriestDeferred,GetHandleId(pending),1)
    if GetWidgetLife(target)>.405 and GetUnitAbilityLevel(target,'B006')>0 and LoadInteger(udg_HealOverTimeHash,GetHandleId(target),11)==LoadInteger(PriestDeferred,GetHandleId(pending),2) then
        call UnitRemoveAbility(target,'B006')
        call Priest_Reapply(target,'pReg',rank)
    endif
    call FlushChildHashtable(PriestDeferred,GetHandleId(pending))
    call DestroyTimer(pending)
    set target=null
    set pending=null
endfunction

function Priest_Swiftmend takes unit caster,unit target,integer raw returns nothing
    local timer pending
    local boolean swift=raw=='A00L' and Talent_Active(caster,12,2,3,'A00L')
    local integer castVersion=LoadInteger(udg_HealOverTimeHash,GetHandleId(target),11)+1
    call SaveInteger(udg_HealOverTimeHash,GetHandleId(target),11,castVersion)
    call SaveBoolean(udg_HealOverTimeHash,GetHandleId(target),10,swift)
    if swift then
        set pending=CreateTimer()
        call SaveUnitHandle(PriestDeferred,GetHandleId(pending),0,target)
        call SaveInteger(PriestDeferred,GetHandleId(pending),1,GetUnitAbilityLevel(caster,raw))
        call SaveInteger(PriestDeferred,GetHandleId(pending),2,castVersion)
        call TimerStart(pending,.01,false,function Priest_SwiftApply)
        set pending=null
    endif
endfunction

function Priest_RainTick takes nothing returns nothing
    local integer pid=0
    local integer rank
    local unit caster
    local unit target
    loop
        exitwhen pid>=8
        set caster=PriestRainCaster[pid]
        if caster!=null then
            if GetWidgetLife(caster)<=.405 or GetUnitCurrentOrder(caster)!=OrderId("tranquility") or PriestRainLeft[pid]<=.0001 then
                set PriestRainCaster[pid]=null
                set PriestRainCount=PriestRainCount-1
            else
                set rank=GetUnitAbilityLevel(caster,'A0OM')
                set PriestRainNext[pid]=PriestRainNext[pid]-.1
                set PriestRainLeft[pid]=PriestRainLeft[pid]-.1
                if PriestRainNext[pid]<=.0001 then
                    set PriestRainNext[pid]=PriestRainNext[pid]+PriestRainPeriod[rank]
                    call GroupEnumUnitsInRange(PriestRainEnemies[pid],GetUnitX(caster),GetUnitY(caster),PriestRainRadius[rank],null)
                    loop
                        set target=FirstOfGroup(PriestRainEnemies[pid])
                        exitwhen target==null
                        call GroupRemoveUnit(PriestRainEnemies[pid],target)
                        set udg_IsPureDamage=false
                        if IsUnitAlly(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitType(target,UNIT_TYPE_STRUCTURE) then
                            set udg_IsPureDamage=true
                            if Talent_Active(caster,12,2,1,'A0OM') then
                                call UnitDamageTarget(caster,target,PriestRainHealing[rank]*.5,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                            else
                                call UnitDamageTarget(caster,target,PriestRainHealing[rank],false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_WHOKNOWS)
                            endif
                        elseif Talent_Active(caster,12,2,1,'A0OM') and IsUnitEnemy(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitType(target,UNIT_TYPE_MAGIC_IMMUNE) then
                            call UnitDamageTarget(caster,target,PriestRainHealing[rank]*.5,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_MAGIC,WEAPON_TYPE_WHOKNOWS)
                        endif
                        // Damage events normally reset this. Also clear after
                        // invulnerable/ignored targets that may emit no event.
                        set udg_IsPureDamage=false
                    endloop
                endif
            endif
        endif
        set pid=pid+1
    endloop
    if PriestRainCount==0 then
        call PauseTimer(PriestRainTimer)
    endif
    set caster=null
    set target=null
endfunction

function Priest_RainEvent takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local integer rank=GetUnitAbilityLevel(caster,'A0OM')
    if pid>=0 and pid<8 and GetSpellAbilityId()=='A0OM' then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_EFFECT then
            if PriestRainCaster[pid]==null then
                set PriestRainCount=PriestRainCount+1
            endif
            set PriestRainCaster[pid]=caster
            set PriestRainLeft[pid]=PriestRainDuration[rank]
            set PriestRainNext[pid]=PriestRainPeriod[rank]
            if PriestRainCount==1 then
                call TimerStart(PriestRainTimer,.1,true,function Priest_RainTick)
            endif
        elseif PriestRainCaster[pid]==caster then
            set PriestRainCaster[pid]=null
            set PriestRainCount=PriestRainCount-1
            if PriestRainCount==0 then
                call PauseTimer(PriestRainTimer)
            endif
        endif
    endif
    set caster=null
endfunction

function Priest_AbilityTalentTip takes unit hero,integer raw,integer row,integer choice returns nothing
    local integer rank=GetUnitAbilityLevel(hero,raw)
    local string tip
    local real amount
    local integer mana
    if rank>0 then
        set tip=LoadStr(PriestAbilityText,raw,rank)
        set mana=BlzGetAbilityManaCost(raw,rank-1)
        if raw=='A00M' then
            set amount=(I2R(mana)*5.+I2R(GetHeroInt(hero,true))*5.)*Prof_StaffPower(hero)
            set tip=tip+"|n|nCurrent caster: "+R2SW(amount,1,0)+" HP on impact; "+R2SW(amount*.25,1,0)+" HP along its path, before target modifiers."
        elseif raw=='A0OM' then
            set amount=I2R(R2I(PriestRainHealing[rank]/PriestRainPeriod[rank]+.5))
            if Talent_Active(hero,12,2,1,raw) then
                set tip=tip+"|n|nCurrent rank: "+R2SW(amount*.5,1,0)+" base HP/sec and "+R2SW(amount*.5,1,0)+" magic damage/sec."
            else
                set tip=tip+"|n|nCurrent rank: "+R2SW(amount,1,0)+" base HP/sec."
            endif
        elseif raw=='A0PC' then
            set amount=I2R(R2I(I2R(50+GetHeroInt(hero,true)/4)*Prof_StaffPower(hero)))
            set tip=tip+"|n|nCurrent caster contributes "+R2SW(amount,1,0)+" queued HP per second; up to "+R2SW(amount*.25,1,0)+" MP per second before recovery rolls and modifiers."
        elseif raw=='A089' then
            set amount=I2R(R2I((I2R(mana)*3.+I2R(GetHeroInt(hero,true))*3.)*Prof_StaffPower(hero)))
            set tip=tip+"|n|nCurrent caster: "+R2SW(amount,1,0)+" HP and "+R2SW(amount*.25,1,0)+" MP before target modifiers. Caster receives HP only."
        endif
        if row>0 and Talent_Active(hero,12,row,choice,raw) then
            set tip=tip+"|n|n|cffffcc00Talent: "+TalentName[Talent_Index(12,row,choice)]+"|r|n"+TalentText[Talent_Index(12,row,choice)]
        endif
        call BlzSetAbilityExtendedTooltip(raw,tip,rank-1+PriestTooltipOffset)
    endif
endfunction

function Priest_RegenTooltip takes nothing returns nothing
    local player viewer=GetLocalPlayer()
    local unit hero=Player_GetHero(viewer)
    local integer rank=GetUnitAbilityLevel(hero,'A00L')
    local real rate
    local real duration
    local string strength="25%"
    local string talent=""
    if hero!=null then
        call Priest_AbilityTalentTip(hero,'A00G',1,1)
        call Priest_AbilityTalentTip(hero,'A0TZ',1,2)
        call Priest_AbilityTalentTip(hero,'A00M',1,3)
        call Priest_AbilityTalentTip(hero,'A0OM',2,1)
        call Priest_AbilityTalentTip(hero,'A0W9',2,2)
        call Priest_AbilityTalentTip(hero,'A0PC',0,0)
        call Priest_AbilityTalentTip(hero,'A089',0,0)
    endif
    if hero!=null and rank>0 then
        set rate=I2R(25+GetHeroInt(hero,true)/3)*Prof_StaffPower(hero)
        set duration=PriestRegenDuration[rank]
        if Talent_Active(hero,12,2,3,'A00L') then
            set rate=rate*2.
            set duration=duration*.5
            set strength="50%"
            set talent="|n|n|cffffcc00Talent: Swiftmend|r|nSame total healing in half the time."
        endif
        call BlzSetAbilityExtendedTooltip('A00L',"|cffffcc00Life Spell|r|nHeals "+R2SW(rate,1,1)+" + "+strength+" of target Strength HP per second for "+R2SW(duration,1,0)+" seconds at this rank. Each tick rolls 93.75% to 100%; healing modifiers still apply."+talent,rank-1+PriestTooltipOffset)
    endif
    set hero=null
    set viewer=null
endfunction

function Priest_MasterEsuna takes nothing returns nothing
    if GetSpellAbilityId()=='A0W9' and Talent_Active(GetTriggerUnit(),12,2,2,'A0W9') then
        call Priest_Refresh(GetSpellTargetUnit())
    endif
endfunction

function Priest_MasterInit takes nothing returns nothing
    local trigger capture=CreateTrigger()
    local trigger rain=CreateTrigger()
    local trigger channel=CreateTrigger()
    local trigger esuna=CreateTrigger()
    local integer pid=0
    call Priest_MasterData()
    set PriestRainTimer=CreateTimer()
    loop
        exitwhen pid>=8
        set PriestRainEnemies[pid]=CreateGroup()
        set pid=pid+1
    endloop
    call TriggerRegisterAnyUnitEventBJ(capture,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(capture,function Priest_RecordBuff)
    call TriggerRegisterAnyUnitEventBJ(rain,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterAnyUnitEventBJ(rain,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    call TriggerRegisterAnyUnitEventBJ(rain,EVENT_PLAYER_UNIT_SPELL_FINISH)
    call TriggerAddAction(rain,function Priest_RainEvent)
    call TriggerRegisterAnyUnitEventBJ(channel,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddAction(channel,function Priest_EsunaChannel)
    call TriggerRegisterAnyUnitEventBJ(esuna,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(esuna,function Priest_MasterEsuna)
    call TimerStart(CreateTimer(),1.,true,function Priest_RegenTooltip)
    set capture=null
    set rain=null
    set channel=null
    set esuna=null
endfunction
