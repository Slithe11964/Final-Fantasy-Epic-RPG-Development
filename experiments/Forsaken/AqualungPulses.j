globals
    hashtable AquaData=InitHashtable()
endglobals

function Aqua_Pulse takes timer clock returns nothing
    local integer key=GetHandleId(clock)
    local unit caster=LoadUnitHandle(AquaData,key,0)
    local real x=LoadReal(AquaData,key,1)
    local real y=LoadReal(AquaData,key,2)
    local real damage=LoadReal(AquaData,key,3)
    local integer remaining=LoadInteger(AquaData,key,4)
    local group targets=CreateGroup()
    local unit target
    // X004, the existing Aqualung effect; each authored Blizzard wave is now
    // emitted directly so an engine proxy order cannot silently discard it.
    call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",x,y))
    call GroupEnumUnitsInRange(targets,x,y,250.,null)
    loop
        set target=FirstOfGroup(targets)
        exitwhen target==null
        call GroupRemoveUnit(targets,target)
        if caster!=null and GetUnitTypeId(caster)!=0 and IsUnitEnemy(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitHidden(target) and not BlzIsUnitInvulnerable(target) and not IsUnitType(target,UNIT_TYPE_MAGIC_IMMUNE) then
            set udg_DamageElement=4
            set udg_IsPhysicalAttack=false
            call UnitDamageTarget(caster,target,damage,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
        endif
    endloop
    call DestroyGroup(targets)
    if remaining<=1 or caster==null or GetUnitTypeId(caster)==0 then
        call PauseTimer(clock)
        call FlushChildHashtable(AquaData,key)
        call DestroyTimer(clock)
    else
        call SaveInteger(AquaData,key,4,remaining-1)
    endif
    set targets=null
    set target=null
    set caster=null
endfunction

function Aqua_Tick takes nothing returns nothing
    call Aqua_Pulse(GetExpiredTimer())
endfunction

function Trig_Aqualung_Cast_Actions takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local unit target=GetSpellTargetUnit()
    local real x=GetSpellTargetX()
    local real y=GetSpellTargetY()
    local integer mana=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(caster,GetSpellAbilityId()))
    local real damage=I2R(mana)
    local timer clock=CreateTimer()
    local integer key=GetHandleId(clock)
    if target!=null then
        set x=GetUnitX(target)
        set y=GetUnitY(target)
    endif
    if IsUnitType(caster,UNIT_TYPE_HERO) then
        set damage=damage+I2R(GetHeroInt(caster,true))
    endif
    call SaveUnitHandle(AquaData,key,0,caster)
    call SaveReal(AquaData,key,1,x)
    call SaveReal(AquaData,key,2,y)
    call SaveReal(AquaData,key,3,damage*Prof_RodPower(caster))
    call SaveInteger(AquaData,key,4,8)
    call TimerStart(clock,1.,true,function Aqua_Tick)
    call Aqua_Pulse(clock)
    set clock=null
    set caster=null
    set target=null
endfunction
