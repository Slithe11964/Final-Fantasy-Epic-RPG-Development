function V37_ForestCaster takes integer raw returns boolean
    return raw=='n00P' or raw=='n00N' or raw=='n00O' or raw=='nenc' or raw=='n010' or raw=='qS99' or raw=='qI99' or raw=='nstl' or raw=='n01N' or raw=='nsat' or raw=='nsts' or raw=='nsth'
endfunction

function V37_Fx takes string model,real x,real y,real angle,real duration returns nothing
    local effect art=AddSpecialEffect(model,x,y)
    local timer clock=CreateTimer()
    call BlzSetSpecialEffectYaw(art,angle)
    call SaveEffectHandle(F99Data,GetHandleId(clock),0,art)
    call TimerStart(clock,duration,false,function F99_FxEnd)
    set art=null
    set clock=null
endfunction

function V37_Sweep takes unit caster,unit aim,boolean bleed returns nothing
    local group targets=CreateGroup()
    local unit target
    local real x=GetUnitX(caster)
    local real y=GetUnitY(caster)
    local real dx
    local real dy
    local real angle=Atan2(GetUnitY(aim)-y,GetUnitX(aim)-x)
    call V37_Fx("Abilities\\Spells\\Human\\SweepingStrike\\SweepingStrike.mdl",x,y,angle,1.2)
    call GroupEnumUnitsInRange(targets,x,y,400.,null)
    loop
        set target=FirstOfGroup(targets)
        exitwhen target==null
        call GroupRemoveUnit(targets,target)
        set dx=GetUnitX(target)-x
        set dy=GetUnitY(target)-y
        if Forest86_Enemy(caster,target) and dx*Cos(angle)+dy*Sin(angle)>=-.01 then
            if bleed then
                call B88_Damage(caster,target,300.,true)
                if Forest86_Alive(target) then
                    call SaveUnitHandle(Forest86Data,GetHandleId(target),48,caster)
                    call B88_Buff(target,47,5.)
                endif
            else
                call B88_Damage(caster,target,75.,true)
            endif
        endif
    endloop
    call DestroyGroup(targets)
    set targets=null
    set target=null
endfunction

function V37_Dot takes unit source,unit victim,real amount,integer ticks,integer kind returns nothing
    local integer victimId=GetHandleId(victim)
    local integer record=LoadInteger(V37Data,victimId,0)
    loop
        exitwhen record==0 or (LoadUnitHandle(V37Dots,record,1)==source and LoadInteger(V37Dots,record,4)==kind)
        set record=LoadInteger(V37Dots,record,0)
    endloop
    if record==0 then
        set V37Serial=V37Serial+1
        set record=V37Serial
        call SaveInteger(V37Dots,record,0,LoadInteger(V37Data,victimId,0))
        call SaveInteger(V37Data,victimId,0,record)
        call SaveUnitHandle(V37Dots,record,1,source)
        call SaveInteger(V37Dots,record,4,kind)
        call SaveReal(V37Dots,record,5,Forest86Now+1.)
    endif
    call SaveReal(V37Dots,record,2,amount)
    call SaveInteger(V37Dots,record,3,ticks)
    call GroupAddUnit(V37Poison,victim)
endfunction

function V37_DotTick takes nothing returns nothing
    local unit victim=GetEnumUnit()
    local integer id=GetHandleId(victim)
    local integer record=LoadInteger(V37Data,id,0)
    local integer previous=0
    local integer next
    local integer remaining
    local real amount
    local unit source
    loop
        exitwhen record==0
        set next=LoadInteger(V37Dots,record,0)
        set remaining=LoadInteger(V37Dots,record,3)
        set source=LoadUnitHandle(V37Dots,record,1)
        if not Forest86_Alive(victim) or source==null or GetUnitTypeId(source)==0 then
            set remaining=0
        elseif Forest86Now>=LoadReal(V37Dots,record,5) then
            set amount=LoadReal(V37Dots,record,2)
            if LoadInteger(V37Dots,record,4)==2 then
                set amount=I2R(BlzGetUnitMaxHP(victim))*.05
            endif
            set udg_IsPhysicalAttack=false
            set udg_DamageElement=0
            set udg_DmgFlagNoCrit=-1.
            set udg_DmgFlagUnavoidable=-1
            call UnitDamageTarget(source,victim,amount,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
            set remaining=remaining-1
            call SaveInteger(V37Dots,record,3,remaining)
            call SaveReal(V37Dots,record,5,Forest86Now+1.)
        endif
        if remaining<=0 then
            if previous==0 then
                call SaveInteger(V37Data,id,0,next)
            else
                call SaveInteger(V37Dots,previous,0,next)
            endif
            call FlushChildHashtable(V37Dots,record)
        else
            set previous=record
        endif
        set record=next
    endloop
    if LoadInteger(V37Data,id,0)==0 then
        call RemoveSavedInteger(V37Data,id,0)
        call GroupRemoveUnit(V37Poison,victim)
    endif
    set source=null
    set victim=null
endfunction

function V37_FiraTick takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer id=GetHandleId(clock)
    local unit caster=LoadUnitHandle(V37Data,id,10)
    local integer remaining=LoadInteger(V37Data,id,13)-1
    if udg_InCinematicMode then
        set caster=null
        set clock=null
        return
    endif
    call M89_Area(caster,LoadReal(V37Data,id,11),LoadReal(V37Data,id,12),300.,100.,1,false)
    if remaining==0 then
        call DestroyEffect(LoadEffectHandle(V37Data,id,14))
        call FlushChildHashtable(V37Data,id)
        call DestroyTimer(clock)
    else
        call SaveInteger(V37Data,id,13,remaining)
    endif
    set caster=null
    set clock=null
endfunction

function V37_Fira takes unit caster,real x,real y returns nothing
    local timer clock=CreateTimer()
    local integer id=GetHandleId(clock)
    call M89_Area(caster,x,y,300.,200.,1,false)
    call SaveUnitHandle(V37Data,id,10,caster)
    call SaveReal(V37Data,id,11,x)
    call SaveReal(V37Data,id,12,y)
    call SaveInteger(V37Data,id,13,5)
    call SaveEffectHandle(V37Data,id,14,AddSpecialEffect("Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl",x,y))
    call TimerStart(clock,1.,true,function V37_FiraTick)
    set clock=null
endfunction

function V37_JumpTick takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer id=GetHandleId(clock)
    local unit caster=LoadUnitHandle(V37Data,id,20)
    local real progress=LoadReal(V37Data,id,25)+.05
    local real startX=LoadReal(V37Data,id,21)
    local real startY=LoadReal(V37Data,id,22)
    local real endX=LoadReal(V37Data,id,23)
    local real endY=LoadReal(V37Data,id,24)
    local real height=LoadReal(V37Data,id,27)
    if udg_InCinematicMode then
        set caster=null
        set clock=null
        return
    endif
    if Forest86_Alive(caster) and progress<1. then
        call SetUnitX(caster,startX+(endX-startX)*progress)
        call SetUnitY(caster,startY+(endY-startY)*progress)
        call SetUnitFlyHeight(caster,height+1100.*progress*(1.-progress),0.)
        call SaveReal(V37Data,id,25,progress)
    else
        if GetUnitTypeId(caster)!=0 then
            call SetUnitFlyHeight(caster,height,0.)
            call PauseUnit(caster,false)
            call ResetUnitAnimation(caster)
        endif
        if Forest86_Alive(caster) then
            call SetUnitPosition(caster,endX,endY)
            call M89_Area(caster,GetUnitX(caster),GetUnitY(caster),300.,LoadReal(V37Data,id,26),5,false)
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",caster,"origin"))
        endif
        call FlushChildHashtable(V37Data,id)
        call DestroyTimer(clock)
    endif
    set caster=null
    set clock=null
endfunction

function V37_Jump takes unit caster,unit victim returns nothing
    local timer clock=CreateTimer()
    local integer id=GetHandleId(clock)
    local real x=GetUnitX(caster)
    local real y=GetUnitY(caster)
    local real dx=GetUnitX(victim)-x
    local real dy=GetUnitY(victim)-y
    call SaveUnitHandle(V37Data,id,20,caster)
    call SaveReal(V37Data,id,21,x)
    call SaveReal(V37Data,id,22,y)
    call SaveReal(V37Data,id,23,x+dx)
    call SaveReal(V37Data,id,24,y+dy)
    call SaveReal(V37Data,id,25,0.)
    call SaveReal(V37Data,id,26,4000.*(RMinBJ(1000.,SquareRoot(dx*dx+dy*dy))+200.)/1200.)
    call SaveReal(V37Data,id,27,GetUnitFlyHeight(caster))
    if UnitAddAbility(caster,'Amrf') then
        call UnitRemoveAbility(caster,'Amrf')
    endif
    call PauseUnit(caster,true)
    call SetUnitFacing(caster,Atan2(dy,dx)*bj_RADTODEG)
    call SetUnitAnimation(caster,"spell")
    call TimerStart(clock,.035,true,function V37_JumpTick)
    set clock=null
endfunction

function V37_Breath takes unit caster,real targetX,real targetY,integer raw returns nothing
    local group targets=CreateGroup()
    local unit target
    local real x=GetUnitX(caster)
    local real y=GetUnitY(caster)
    local real angle=Atan2(targetY-y,targetX-x)
    local real cosine=Cos(angle)
    local real sine=Sin(angle)
    local real dx
    local real dy
    local real forward
    local real across
    local integer element=1
    local real damage=4000.
    local string model="Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireMissile.mdl"
    if raw=='kOB2' then
        set damage=5000.
        set element=7
        set model="war3mapImported\\DarkSwarmBreathV7.mdx"
    elseif raw=='kWB2' then
        set element=6
        set model="Abilities\\Spells\\Other\\Tornado\\TornadoElementalSmall.mdl"
    elseif raw=='kLB2' then
        set element=3
        call V37_LightningBreath(caster,angle)
    endif
    call SetUnitFacing(caster,angle*bj_RADTODEG)
    call SetUnitAnimation(caster,"spell")
    if raw!='kLB2' then
        call V37_Fx(model,x+210.*cosine,y+210.*sine,angle,1.)
        call V37_Fx(model,x+530.*cosine,y+530.*sine,angle,1.)
    endif
    call GroupEnumUnitsInRange(targets,x,y,860.,null)
    loop
        set target=FirstOfGroup(targets)
        exitwhen target==null
        call GroupRemoveUnit(targets,target)
        set dx=GetUnitX(target)-x
        set dy=GetUnitY(target)-y
        set forward=dx*cosine+dy*sine
        set across=dy*cosine-dx*sine
        if Forest86_Enemy(caster,target) and forward>=0. and forward<=800. and RAbsBJ(across)<=150.+150.*forward/800. then
            call M89_Damage(caster,target,damage,element)
        endif
    endloop
    call DestroyGroup(targets)
    set targets=null
    set target=null
endfunction

function V37_Scourge takes unit caster,unit victim returns nothing
    local unit proxy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(caster),GetUnitY(caster),0.)
    local integer id=GetHandleId(proxy)
    call SetUnitVertexColor(proxy,255,255,255,0)
    call SetUnitPathing(proxy,false)
    call SaveUnitHandle(udg_ProxyDamageHash,id,0,caster)
    call SaveReal(udg_ProxyDamageHash,id,1,100.)
    call SaveInteger(udg_ProxyDamageHash,id,2,3)
    call SaveInteger(udg_ProxyDamageHash,id,100,0)
    call SaveBoolean(udg_ProxyDamageHash,id,5,true)
    call UnitAddAbility(proxy,'A0VK')
    call IssueTargetOrder(proxy,"acidbomb",victim)
    call UnitApplyTimedLife(proxy,'BTLF',15.)
    set proxy=null
endfunction

function V37_Deconstruct takes unit caster returns nothing
    local group targets=CreateGroup()
    local unit target
    local real x=GetUnitX(caster)
    local real y=GetUnitY(caster)
    call V37_Fx("Abilities\\Spells\\Other\\Tornado\\TornadoElementalSmall.mdl",x,y,0.,1.2)
    call GroupEnumUnitsInRange(targets,x,y,400.,null)
    loop
        set target=FirstOfGroup(targets)
        exitwhen target==null
        call GroupRemoveUnit(targets,target)
        if Forest86_Alive(target) and IsUnitEnemy(target,GetOwningPlayer(caster)) then
            set udg_IsPhysicalAttack=false
            set udg_DamageElement=6
            set udg_DmgFlagNoCrit=-1.
            call UnitDamageTarget(caster,target,2000.,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
        endif
    endloop
    call DestroyGroup(targets)
    set targets=null
    set target=null
endfunction
