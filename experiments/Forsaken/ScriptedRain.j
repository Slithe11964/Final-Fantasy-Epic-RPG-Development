// One owned timer and one group per cast; visual effects are destroyed each wave.
function Rain_End takes timer clock returns nothing
    local integer key=GetHandleId(clock)
    local integer i=0
    loop
        exitwhen i>=LoadInteger(RainData,key,8)
        call DestroyEffect(LoadEffectHandle(RainData,key,100+i))
        set i=i+1
    endloop
    call DestroyGroup(LoadGroupHandle(RainData,key,9))
    call FlushChildHashtable(RainData,key)
    call PauseTimer(clock)
    call DestroyTimer(clock)
endfunction

function Rain_Tick takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer key=GetHandleId(clock)
    local unit caster=LoadUnitHandle(RainData,key,0)
    local integer step=LoadInteger(RainData,key,7)+1
    local integer i=0
    local integer waves=LoadInteger(RainData,key,6)
    local boolean arrows=LoadBoolean(RainData,key,10)
    local real x=LoadReal(RainData,key,1)
    local real y=LoadReal(RainData,key,2)
    local real radius=LoadReal(RainData,key,3)
    local real px
    local real py
    local location ground
    local effect visual
    local unit target
    local group targets=LoadGroupHandle(RainData,key,9)
    if GetUnitTypeId(caster)==0 then
        call Rain_End(clock)
    else
        loop
            exitwhen i>=LoadInteger(RainData,key,8)
            call BlzSetSpecialEffectZ(LoadEffectHandle(RainData,key,100+i),LoadReal(RainData,key,200+i)+RMaxBJ(0.,360.-I2R(step)*72.))
            set i=i+1
        endloop
        if step>=5 then
            call GroupEnumUnitsInRange(targets,x,y,radius,null)
            loop
                set target=FirstOfGroup(targets)
                exitwhen target==null
                call GroupRemoveUnit(targets,target)
                if IsUnitEnemy(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitType(target,UNIT_TYPE_FLYING) and GetUnitAbilityLevel(target,'Avul')==0 then
                    set udg_DamageElement=0
                    set udg_IsPhysicalAttack=arrows
                    if arrows then
                        call UnitDamageTarget(caster,target,LoadReal(RainData,key,4),true,true,ATTACK_TYPE_PIERCE,DAMAGE_TYPE_NORMAL,null)
                    else
                        call UnitDamageTarget(caster,target,LoadReal(RainData,key,4),true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
                    endif
                endif
            endloop
            set i=0
            loop
                exitwhen i>=LoadInteger(RainData,key,8)
                call DestroyEffect(LoadEffectHandle(RainData,key,100+i))
                set i=i+1
            endloop
            call SaveInteger(RainData,key,8,0)
            set waves=waves-1
            call SaveInteger(RainData,key,6,waves)
            set step=0
        endif
        if waves<=0 then
            call Rain_End(clock)
        else
            if step==0 then
                set i=0
                loop
                    exitwhen i>=6
                    set px=x+GetRandomReal(-radius*.7,radius*.7)
                    set py=y+GetRandomReal(-radius*.7,radius*.7)
                    set ground=Location(px,py)
                    if arrows then
                        set visual=AddSpecialEffect("Abilities\\Weapons\\Arrow\\ArrowMissile.mdl",px,py)
                        call BlzSetSpecialEffectPitch(visual,1.5708)
                    else
                        set visual=AddSpecialEffect("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl",px,py)
                    endif
                    call SaveEffectHandle(RainData,key,100+i,visual)
                    call SaveReal(RainData,key,200+i,GetLocationZ(ground))
                    call BlzSetSpecialEffectZ(visual,GetLocationZ(ground)+360.)
                    call RemoveLocation(ground)
                    set i=i+1
                endloop
                call SaveInteger(RainData,key,8,6)
            endif
            call SaveInteger(RainData,key,7,step)
        endif
    endif
    set caster=null
    set target=null
    set targets=null
    set clock=null
    set ground=null
    set visual=null
endfunction

function Rain_Start takes unit caster,integer raw,integer rank,integer mana,real x,real y returns nothing
    local timer clock=CreateTimer()
    local integer key=GetHandleId(clock)
    local boolean arrows=raw=='A0R0'
    local integer waves
    local real damage
    local real radius
    if arrows then
        set waves=LoadInteger(RainData,'A0R0',rank)
        set damage=(mana/2+GetHeroAgi(caster,true))*(1.+.1*Prof_GetLevel(caster,'R002'))
        set radius=250.
    elseif raw=='A028' then
        set waves=20
        set damage=(100.+2.*GetHeroInt(caster,true))*Prof_InnerManaPower(caster)
        set radius=800.
    else
        set waves=LoadInteger(RainData,'A0QM',IMaxBJ(1,IMinBJ(20,mana/50)))
        set damage=(250.+GetHeroInt(caster,true)/2)*Prof_InnerManaPower(caster)
        set radius=500.
    endif
    call SaveUnitHandle(RainData,key,0,caster)
    call SaveReal(RainData,key,1,x)
    call SaveReal(RainData,key,2,y)
    call SaveReal(RainData,key,3,radius)
    call SaveReal(RainData,key,4,damage)
    call SaveInteger(RainData,key,6,waves)
    call SaveInteger(RainData,key,7,-1)
    call SaveGroupHandle(RainData,key,9,CreateGroup())
    call SaveBoolean(RainData,key,10,arrows)
    call TimerStart(clock,.05,true,function Rain_Tick)
    set clock=null
endfunction
