globals
    hashtable ForsakenWaterWaves=null
endglobals

// Match ACcv: 800 travel, 100 starting radius, 300 final radius, 1100 speed.
// Sweep the entire step rather than just sampling its endpoint; each unit hits once.
function Forsaken_WaterTouches takes real along,real across,real collision,real previous,real distance returns boolean
    local real width=100.+200.*RMaxBJ(0.,RMinBJ(800.,along))/800.
    return along+collision>=previous and along-collision<=distance and along+collision>=0. and along-collision<=800. and RAbsBJ(across)<=width+collision
endfunction

function Forsaken_WaterTick takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer key=GetHandleId(clock)
    local unit caster=LoadUnitHandle(ForsakenWaterWaves,key,0)
    local real originX=LoadReal(ForsakenWaterWaves,key,1)
    local real originY=LoadReal(ForsakenWaterWaves,key,2)
    local real directionX=LoadReal(ForsakenWaterWaves,key,3)
    local real directionY=LoadReal(ForsakenWaterWaves,key,4)
    local real previous=LoadReal(ForsakenWaterWaves,key,5)
    local real distance=RMinBJ(800.,previous+33.)
    local real amount=LoadReal(ForsakenWaterWaves,key,6)
    local real x=originX+directionX*distance
    local real y=originY+directionY*distance
    local real dx
    local real dy
    local unit target
    local effect wave=LoadEffectHandle(ForsakenWaterWaves,key,7)
    local group hits=LoadGroupHandle(ForsakenWaterWaves,key,8)
    local group candidates=LoadGroupHandle(ForsakenWaterWaves,key,9)
    local location ground=Location(x,y)
    call BlzSetSpecialEffectPosition(wave,x,y,GetLocationZ(ground)+40.)
    call RemoveLocation(ground)
    // Full cone radius plus one step and large unit collision bounds.
    call GroupEnumUnitsInRange(candidates,x,y,600.,null)
    loop
        set target=FirstOfGroup(candidates)
        exitwhen target==null
        call GroupRemoveUnit(candidates,target)
        if target!=caster and IsUnitEnemy(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitHidden(target) and not BlzIsUnitInvulnerable(target) and not IsUnitType(target,UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitInGroup(target,hits) then
            set dx=GetUnitX(target)-originX
            set dy=GetUnitY(target)-originY
            if Forsaken_WaterTouches(dx*directionX+dy*directionY,-dx*directionY+dy*directionX,BlzGetUnitCollisionSize(target),previous,distance) then
                call GroupAddUnit(hits,target)
                set udg_DamageElement=4
                set udg_IsPhysicalAttack=false
                call UnitDamageTarget(caster,target,amount,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
            endif
        endif
    endloop
    if distance>=800. or caster==null or GetUnitTypeId(caster)==0 then
        call DestroyEffect(wave)
        call DestroyGroup(hits)
        call DestroyGroup(candidates)
        call FlushChildHashtable(ForsakenWaterWaves,key)
        call DestroyTimer(clock)
    else
        call SaveReal(ForsakenWaterWaves,key,5,distance)
    endif
    set caster=null
    set target=null
    set wave=null
    set hits=null
    set candidates=null
    set ground=null
    set clock=null
endfunction

function Trig_Spell_Water_Actions takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local unit target=GetSpellTargetUnit()
    local location point
    local real x=GetUnitX(caster)
    local real y=GetUnitY(caster)
    local real targetX
    local real targetY
    local real angle
    local integer power=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(caster,GetSpellAbilityId()))*5
    local timer clock=CreateTimer()
    local integer key=GetHandleId(clock)
    local effect wave
    if target==null then
        set point=GetSpellTargetLoc()
        set targetX=GetLocationX(point)
        set targetY=GetLocationY(point)
        call RemoveLocation(point)
    else
        set targetX=GetUnitX(target)
        set targetY=GetUnitY(target)
    endif
    if targetX==x and targetY==y then
        set angle=GetUnitFacing(caster)*bj_DEGTORAD
    else
        set angle=Atan2(targetY-y,targetX-x)
    endif
    if IsUnitType(caster,UNIT_TYPE_HERO) then
        set power=power+GetHeroInt(caster,true)*6
    endif
    set wave=AddSpecialEffect("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveMissile.mdl",x,y)
    call BlzSetSpecialEffectYaw(wave,angle)
    call SaveUnitHandle(ForsakenWaterWaves,key,0,caster)
    call SaveReal(ForsakenWaterWaves,key,1,x)
    call SaveReal(ForsakenWaterWaves,key,2,y)
    call SaveReal(ForsakenWaterWaves,key,3,Cos(angle))
    call SaveReal(ForsakenWaterWaves,key,4,Sin(angle))
    call SaveReal(ForsakenWaterWaves,key,5,0.)
    call SaveReal(ForsakenWaterWaves,key,6,I2R(power)*Prof_RodPower(caster))
    call SaveEffectHandle(ForsakenWaterWaves,key,7,wave)
    call SaveGroupHandle(ForsakenWaterWaves,key,8,CreateGroup())
    call SaveGroupHandle(ForsakenWaterWaves,key,9,CreateGroup())
    call TimerStart(clock,.03,true,function Forsaken_WaterTick)
    set caster=null
    set target=null
    set point=null
    set wave=null
    set clock=null
endfunction
