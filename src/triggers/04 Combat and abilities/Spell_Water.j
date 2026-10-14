library TSpellWater requires TAbil, TProf, TBackpack
globals
    trigger gg_trg_Spell_Water_Check
    trigger gg_trg_Spell_Water_Observe
    integer array WaterChannels
    integer array WaterEffects
    integer array WaterOrders
    integer array WaterProxyEffects
    boolean array WaterCheckBusy
    hashtable WaterCheckData=InitHashtable()
endglobals
function Trig_Spell_Water_IsWaterSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A08X')or(GetSpellAbilityId()=='A0Q0')or(GetSpellAbilityId()=='A0Q1')or(GetSpellAbilityId()=='A0Q2')or(GetSpellAbilityId()=='A0SM')or(GetSpellAbilityId()=='A0TP')or(GetSpellAbilityId()=='A0SA')or(GetSpellAbilityId()=='A150') // 'A08X': ability "Water"; 'A0Q0': ability "Water"; 'A0Q1': ability "Watera"; 'A0Q2': ability "Wateraga"; 'A0SM': ability "Water"; 'A0TP': ability "Water"; 'A0SA': ability "Water"; 'A150': ability "Water"
endfunction

function Trig_Spell_Water_Conditions takes nothing returns boolean
    return(Trig_Spell_Water_IsWaterSpell())
endfunction

function Trig_Spell_Water_IsPointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_Water_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Water_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    local unit proxy
    local unit source=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(source))
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    set proxy=GetLastCreatedUnit()
    call RemoveLocation(l_tempPoint)
    if Backpack_PageOf(pid,source)>=0 then
        set source=Player_GetHero(Player(pid))
    endif
    if(Trig_Spell_Water_IsPointCast())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(proxy,l_tempPoint,0)
    set l_tempHandleId=GetHandleIdBJ(proxy)
    call SaveUnitHandleBJ(source,0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*5)
    if IsUnitType(source,UNIT_TYPE_HERO) then
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,source,true)*6))
    endif
    set l_tempReal=Prof_RodPower(source)
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    // Keep the proxy active for classic casting; hide its model rather than the unit.
    call SetUnitVertexColor(proxy,255,255,255,0)
    call UnitApplyTimedLifeBJ(6.,'BTLF',proxy) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M4',proxy) // 'A0M4': ability "Water-elemental Damage"
    call UnitAddAbilityBJ('A0PZ',proxy) // 'A0PZ': ability "Water"
    if IssuePointOrderLocBJ(proxy,"carrionswarm",l_tempPoint) then
        set WaterOrders[pid]=WaterOrders[pid]+1
    endif
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
    set proxy=null
    set source=null
endfunction

// Observe the actual engine events, separately from the damage action.
function Water_Observe takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    local integer id=GetSpellAbilityId()
    local integer variant
    if Trig_Spell_Water_IsWaterSpell() then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_CHANNEL then
            set WaterChannels[pid]=WaterChannels[pid]+1
        else
            set WaterEffects[pid]=WaterEffects[pid]+1
        endif
    elseif (id=='A0PZ' or id=='ACcv') and GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_EFFECT then
        set WaterProxyEffects[pid]=WaterProxyEffects[pid]+1
        set variant=LoadInteger(WaterCheckData,GetHandleId(GetTriggerUnit()),0)
        if variant>0 then
            call SaveBoolean(WaterCheckData,pid,variant+10,true)
        endif
    endif
endfunction

function Water_CheckReport takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer pid=LoadInteger(WaterCheckData,GetHandleId(clock),0)
    local integer i=1
    local string line="Water check: "
    local unit proxy
    loop
        exitwhen i>4
        set line=line+I2S(i)+" order="
        if LoadBoolean(WaterCheckData,pid,i) then
            set line=line+"yes"
        else
            set line=line+"no"
        endif
        set line=line+" effect="
        if LoadBoolean(WaterCheckData,pid,i+10) then
            set line=line+"yes; "
        else
            set line=line+"no; "
        endif
        set proxy=LoadUnitHandle(WaterCheckData,pid,i+20)
        call FlushChildHashtable(WaterCheckData,GetHandleId(proxy))
        call RemoveSavedHandle(WaterCheckData,pid,i+20)
        set i=i+1
    endloop
    set WaterCheckBusy[pid]=false
    set proxy=null
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,60.,line)
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,60.,"Item casts: channel="+I2S(WaterChannels[pid])+" effect="+I2S(WaterEffects[pid])+" accepted proxy orders="+I2S(WaterOrders[pid])+". Screenshot these results and note which waves appeared.")
    call FlushChildHashtable(WaterCheckData,GetHandleId(clock))
    call DestroyTimer(clock)
    set clock=null
endfunction

function Water_CheckDelayed takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local unit proxy=LoadUnitHandle(WaterCheckData,GetHandleId(clock),1)
    local integer pid=GetPlayerId(GetOwningPlayer(proxy))
    call SaveBoolean(WaterCheckData,pid,2,IssuePointOrder(proxy,"carrionswarm",LoadReal(WaterCheckData,GetHandleId(clock),2),LoadReal(WaterCheckData,GetHandleId(clock),3)))
    call FlushChildHashtable(WaterCheckData,GetHandleId(clock))
    call DestroyTimer(clock)
    set proxy=null
    set clock=null
endfunction

function Water_Check takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    local unit hero=Player_GetHero(Player(pid))
    local unit proxy
    local timer clock
    local real x
    local real y
    local real angle
    local integer i=1
    if hero==null or WaterCheckBusy[pid] then
        return
    endif
    set WaterCheckBusy[pid]=true
    set x=GetUnitX(hero)
    set y=GetUnitY(hero)
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,60.,"Water variants: 1 normal; 2 delayed; 3 without physical detector; 4 stock swarm. Waves fan out in front of your hero; results follow in two seconds.")
    loop
        exitwhen i>4
        call SaveBoolean(WaterCheckData,pid,i,false)
        call SaveBoolean(WaterCheckData,pid,i+10,false)
        set angle=(GetUnitFacing(hero)-60.+40.*I2R(i-1))*bj_DEGTORAD
        set proxy=CreateUnit(Player(pid),'h01B',x,y,angle*bj_RADTODEG)
        call SaveUnitHandle(WaterCheckData,pid,i+20,proxy)
        call SaveInteger(WaterCheckData,GetHandleId(proxy),0,i)
        // Diagnostic waves have no damage; they still use the normal proxy damage path.
        call SaveUnitHandle(udg_ProxyDamageHash,GetHandleId(proxy),0,hero)
        call SaveReal(udg_ProxyDamageHash,GetHandleId(proxy),1,0.)
        call SaveInteger(udg_ProxyDamageHash,GetHandleId(proxy),2,3)
        call UnitApplyTimedLife(proxy,'BTLF',6.)
        if i==3 then
            call UnitRemoveAbility(proxy,'A0PB')
        endif
        if i==4 then
            call UnitAddAbility(proxy,'ACcv')
        else
            call UnitAddAbility(proxy,'A0PZ')
        endif
        if i==2 then
            set clock=CreateTimer()
            call SaveUnitHandle(WaterCheckData,GetHandleId(clock),1,proxy)
            call SaveReal(WaterCheckData,GetHandleId(clock),2,x+600.*Cos(angle))
            call SaveReal(WaterCheckData,GetHandleId(clock),3,y+600.*Sin(angle))
            call TimerStart(clock,.05,false,function Water_CheckDelayed)
        else
            call SaveBoolean(WaterCheckData,pid,i,IssuePointOrder(proxy,"carrionswarm",x+600.*Cos(angle),y+600.*Sin(angle)))
        endif
        set i=i+1
    endloop
    set clock=CreateTimer()
    call SaveInteger(WaterCheckData,GetHandleId(clock),0,pid)
    call TimerStart(clock,2.,false,function Water_CheckReport)
    set clock=null
    set proxy=null
    set hero=null
endfunction

function Register_Spell_Water_Check takes nothing returns nothing
    local integer pid=0
    set gg_trg_Spell_Water_Check=CreateTrigger()
    loop
        exitwhen pid==8
        call TriggerRegisterPlayerChatEvent(gg_trg_Spell_Water_Check,Player(pid),"-watercheck",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Spell_Water_Check,function Water_Check)
    set gg_trg_Spell_Water_Observe=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Water_Observe,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Water_Observe,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(gg_trg_Spell_Water_Observe,function Water_Observe)
endfunction

function InitTrig_Spell_Water takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Water takes nothing returns nothing
    set gg_trg_Spell_Water=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Water,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Water,Condition(function Trig_Spell_Water_Conditions))
    call TriggerAddAction(gg_trg_Spell_Water,function Trig_Spell_Water_Actions)
endfunction

endlibrary
