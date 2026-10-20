    hashtable TalentLegendState=InitHashtable()
    group TalentCleansingUnits=null
    group TalentCleansingScan=null
    timer TalentCleansingTimer=null
    timer TalentLegendClock=null
// FUNCTIONS
function Talent_LegendChoice takes unit hero,integer choice returns boolean
    return hero!=null and Job_GetIndex(hero)==12 and Talent_Has(hero,4,choice)
endfunction

function Talent_CleansingProtected takes unit target returns boolean
    if TalentLegendClock==null then
        return false
    endif
    return LoadReal(TalentLegendState,GetHandleId(target),10)>TimerGetElapsed(TalentLegendClock)
endfunction

function Talent_CleanseStatus takes unit target returns nothing
    call UnitRemoveBuffsEx(target,false,true,true,true,false,true,true)
    // Include the map's scripted ailments, which are not all tagged negative.
CLEANSE
    call Berserk_Remove(target)
endfunction

function Talent_CleansingTick takes nothing returns nothing
    local unit target
    call GroupAddGroup(TalentCleansingUnits,TalentCleansingScan)
    loop
        set target=FirstOfGroup(TalentCleansingScan)
        exitwhen target==null
        call GroupRemoveUnit(TalentCleansingScan,target)
        if Talent_CleansingProtected(target) and GetWidgetLife(target)>.405 then
            call Talent_CleanseStatus(target)
        else
            call GroupRemoveUnit(TalentCleansingUnits,target)
            call RemoveSavedReal(TalentLegendState,GetHandleId(target),10)
        endif
    endloop
    if FirstOfGroup(TalentCleansingUnits)==null then
        call PauseTimer(TalentCleansingTimer)
    endif
    set target=null
endfunction

function Talent_ProlongedCleansing takes unit caster,unit target returns nothing
    if target!=null and Talent_LegendChoice(caster,3) then
        call SaveReal(TalentLegendState,GetHandleId(target),10,TimerGetElapsed(TalentLegendClock)+10.)
        call GroupAddUnit(TalentCleansingUnits,target)
        call Talent_CleanseStatus(target)
        call TimerStart(TalentCleansingTimer,.03125,true,function Talent_CleansingTick)
    endif
endfunction

function Talent_RainCanRevive takes unit target returns boolean
    local integer pid=0
    local unit caster
    local real dx
    local real dy
    loop
        exitwhen pid>=8
        set caster=TalentRainCaster[pid]
        if Talent_LegendChoice(caster,2) and caster!=target and GetWidgetLife(caster)>.405 and GetUnitCurrentOrder(caster)==OrderId("tranquility") and IsUnitAlly(target,GetOwningPlayer(caster)) and not IsUnitType(target,UNIT_TYPE_STRUCTURE) then
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

function Talent_TryRainRevive takes unit target returns boolean
    if Talent_RainCanRevive(target) and IsUnitType(target,UNIT_TYPE_HERO) then
        if ReviveHero(target,GetUnitX(target),GetUnitY(target),true) then
            call SetUnitState(target,UNIT_STATE_LIFE,GetUnitState(target,UNIT_STATE_MAX_LIFE))
            call SetUnitState(target,UNIT_STATE_MANA,GetUnitState(target,UNIT_STATE_MAX_MANA))
            return true
        endif
    endif
    return false
endfunction

function Talent_RestoreOrdinary takes nothing returns nothing
    local timer pending=GetExpiredTimer()
    local unit target=LoadUnitHandle(TalentLegendState,GetHandleId(pending),0)
    if GetWidgetLife(target)>.405 then
        call SetUnitState(target,UNIT_STATE_LIFE,GetUnitState(target,UNIT_STATE_MAX_LIFE))
        call SetUnitState(target,UNIT_STATE_MANA,GetUnitState(target,UNIT_STATE_MAX_MANA))
    endif
    call FlushChildHashtable(TalentLegendState,GetHandleId(pending))
    call DestroyTimer(pending)
    set target=null
    set pending=null
endfunction

function Talent_RainDeath takes nothing returns nothing
    local unit target=GetTriggerUnit()
    local unit dummy
    local timer pending
    if not IsUnitType(target,UNIT_TYPE_HERO) and Talent_RainCanRevive(target) then
        set dummy=CreateUnit(GetOwningPlayer(target),'h02S',GetUnitX(target),GetUnitY(target),0.)
        call UnitAddAbility(dummy,'pRiv')
        call IssueImmediateOrder(dummy,"resurrection")
        call UnitApplyTimedLife(dummy,'BTLF',1.)
        set pending=CreateTimer()
        call SaveUnitHandle(TalentLegendState,GetHandleId(pending),0,target)
        call TimerStart(pending,.1,false,function Talent_RestoreOrdinary)
    endif
    set target=null
    set dummy=null
    set pending=null
endfunction

function Talent_HealingBoltResolve takes nothing returns nothing
    local timer pending=GetExpiredTimer()
    local integer key=GetHandleId(pending)
    local unit caster=LoadUnitHandle(TalentLegendState,key,0)
    local real ax=LoadReal(TalentLegendState,key,1)
    local real ay=LoadReal(TalentLegendState,key,2)
    local real bx=LoadReal(TalentLegendState,key,3)
    local real by=LoadReal(TalentLegendState,key,4)
    local real amount=LoadReal(TalentLegendState,key,5)
    local real dx=bx-ax
    local real dy=by-ay
    local real length=dx*dx+dy*dy
    local real along
    local real x
    local real y
    local unit target
    local group nearby=CreateGroup()
    if length>0. then
        call GroupEnumUnitsInRange(nearby,(ax+bx)*.5,(ay+by)*.5,SquareRoot(length)*.5+128.,null)
        loop
            set target=FirstOfGroup(nearby)
            exitwhen target==null
            call GroupRemoveUnit(nearby,target)
            if target!=caster and IsUnitAlly(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitType(target,UNIT_TYPE_STRUCTURE) then
                set along=((GetUnitX(target)-ax)*dx+(GetUnitY(target)-ay)*dy)/length
                if along>=0. and along<=1. then
                    set x=GetUnitX(target)-(ax+along*dx)
                    set y=GetUnitY(target)-(ay+along*dy)
                    if x*x+y*y<=16384. then
                        set udg_IsPureDamage=true
                        set udg_DmgFlagPure=true
                        call UnitDamageTarget(caster,target,amount,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,null)
                        set udg_IsPureDamage=false
                        set udg_DmgFlagPure=false
                        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",target,"origin"))
                    endif
                endif
            endif
        endloop
    endif
    call DestroyGroup(nearby)
    call FlushChildHashtable(TalentLegendState,key)
    call DestroyTimer(pending)
    set nearby=null
    set target=null
    set caster=null
    set pending=null
endfunction

function Talent_HealingBolt takes unit caster,unit victim,real damage returns nothing
    local timer pending
    local integer key
    if damage>0. and Talent_LegendChoice(caster,1) then
        set pending=CreateTimer()
        set key=GetHandleId(pending)
        call SaveUnitHandle(TalentLegendState,key,0,caster)
        call SaveReal(TalentLegendState,key,1,GetUnitX(caster))
        call SaveReal(TalentLegendState,key,2,GetUnitY(caster))
        call SaveReal(TalentLegendState,key,3,GetUnitX(victim))
        call SaveReal(TalentLegendState,key,4,GetUnitY(victim))
        call SaveReal(TalentLegendState,key,5,damage*.25)
        call TimerStart(pending,0.,false,function Talent_HealingBoltResolve)
        set pending=null
    endif
endfunction

function Talent_LegendInit takes nothing returns nothing
    local trigger deaths=CreateTrigger()
    set TalentCleansingUnits=CreateGroup()
    set TalentCleansingScan=CreateGroup()
    set TalentCleansingTimer=CreateTimer()
    set TalentLegendClock=CreateTimer()
    call TimerStart(TalentLegendClock,1000000.,false,null)
    call TriggerRegisterAnyUnitEventBJ(deaths,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddAction(deaths,function Talent_RainDeath)
    set deaths=null
endfunction
