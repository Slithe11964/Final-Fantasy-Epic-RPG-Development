library TMyriad requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Myriad_Arrows=null
    hashtable RainData=InitHashtable()
endglobals

function Rain_Data takes nothing returns nothing
    call SaveInteger(RainData,'A0R0',1,20)
    call SaveInteger(RainData,'A0R0',2,22)
    call SaveInteger(RainData,'A0R0',3,24)
    call SaveInteger(RainData,'A0R0',4,26)
    call SaveInteger(RainData,'A0R0',5,28)
    call SaveInteger(RainData,'A0R0',6,32)
    call SaveInteger(RainData,'A0QM',1,2)
    call SaveInteger(RainData,'A0QM',2,4)
    call SaveInteger(RainData,'A0QM',3,6)
    call SaveInteger(RainData,'A0QM',4,8)
    call SaveInteger(RainData,'A0QM',5,8)
    call SaveInteger(RainData,'A0QM',6,12)
    call SaveInteger(RainData,'A0QM',7,14)
    call SaveInteger(RainData,'A0QM',8,16)
    call SaveInteger(RainData,'A0QM',9,18)
    call SaveInteger(RainData,'A0QM',10,20)
    call SaveInteger(RainData,'A0QM',11,22)
    call SaveInteger(RainData,'A0QM',12,24)
    call SaveInteger(RainData,'A0QM',13,26)
    call SaveInteger(RainData,'A0QM',14,28)
    call SaveInteger(RainData,'A0QM',15,30)
    call SaveInteger(RainData,'A0QM',16,32)
    call SaveInteger(RainData,'A0QM',17,34)
    call SaveInteger(RainData,'A0QM',18,36)
    call SaveInteger(RainData,'A0QM',19,38)
    call SaveInteger(RainData,'A0QM',20,40)
endfunction

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

function Trig_Myriad_Arrows_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0R0') // 'A0R0': ability "!Myriad Arrows"
endfunction

function Trig_Myriad_Arrows_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Myriad_Arrows_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Myriad_Arrows_Actions takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    call Rain_Start(caster,raw,IMaxBJ(1,GetUnitAbilityLevel(caster,raw)),BlzGetAbilityManaCost(raw,Abil_GetLevel(caster,raw)),GetSpellTargetX(),GetSpellTargetY())
    set caster=null
endfunction

// World Editor calls InitTrig_Myriad automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Myriad (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Myriad takes nothing returns nothing
endfunction

function Register_Myriad_Arrows takes nothing returns nothing
    call Rain_Data()
    set gg_trg_Myriad_Arrows=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Myriad_Arrows,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Myriad_Arrows,Condition(function Trig_Myriad_Arrows_Conditions))
    call TriggerAddAction(gg_trg_Myriad_Arrows,function Trig_Myriad_Arrows_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Myriad takes nothing returns nothing
    call Register_Myriad_Arrows()
endfunction

endlibrary
