library TSpellWater requires TAbil, TProf, TBackpack
globals
    trigger gg_trg_Spell_Water_Check
    trigger gg_trg_Spell_Water_Observe
    integer array WaterChannels
    integer array WaterEffects
    hashtable WaterWaves=InitHashtable()
    integer array WaterStarted
    integer array WaterHitCount
    integer array WaterActive
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

// Match ACcv: 800 travel, 100 starting radius, 300 final radius, 1100 speed.
// Sweep the entire step rather than just sampling its endpoint; each unit hits once.
function Water_Touches takes real along,real across,real collision,real previous,real distance returns boolean
    local real width=100.+200.*RMaxBJ(0.,RMinBJ(800.,along))/800.
    return along+collision>=previous and along-collision<=distance and along+collision>=0. and along-collision<=800. and RAbsBJ(across)<=width+collision
endfunction

function Water_Tick takes nothing returns nothing
    local timer clock=GetExpiredTimer()
    local integer key=GetHandleId(clock)
    local unit caster=LoadUnitHandle(WaterWaves,key,0)
    local real originX=LoadReal(WaterWaves,key,1)
    local real originY=LoadReal(WaterWaves,key,2)
    local real directionX=LoadReal(WaterWaves,key,3)
    local real directionY=LoadReal(WaterWaves,key,4)
    local real previous=LoadReal(WaterWaves,key,5)
    local real distance=RMinBJ(800.,previous+33.)
    local real amount=LoadReal(WaterWaves,key,6)
    local real x=originX+directionX*distance
    local real y=originY+directionY*distance
    local real dx
    local real dy
    local unit target
    local effect wave=LoadEffectHandle(WaterWaves,key,7)
    local group hits=LoadGroupHandle(WaterWaves,key,8)
    local group candidates=LoadGroupHandle(WaterWaves,key,9)
    local unit carrier=LoadUnitHandle(WaterWaves,key,10)
    local integer pid=LoadInteger(WaterWaves,key,11)
    call SetUnitX(carrier,x)
    call SetUnitY(carrier,y)
    // Full cone radius plus one step and large unit collision bounds.
    call GroupEnumUnitsInRange(candidates,x,y,600.,null)
    loop
        set target=FirstOfGroup(candidates)
        exitwhen target==null
        call GroupRemoveUnit(candidates,target)
        if target!=caster and IsUnitEnemy(target,GetOwningPlayer(caster)) and GetWidgetLife(target)>.405 and not IsUnitHidden(target) and not BlzIsUnitInvulnerable(target) and not IsUnitType(target,UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitInGroup(target,hits) then
            set dx=GetUnitX(target)-originX
            set dy=GetUnitY(target)-originY
            if Water_Touches(dx*directionX+dy*directionY,-dx*directionY+dy*directionX,BlzGetUnitCollisionSize(target),previous,distance) then
                call GroupAddUnit(hits,target)
                if amount>0. and GetUnitTypeId(caster)!=0 then
                    set udg_DamageElement=4
                    set udg_IsPhysicalAttack=false
                    set WaterHitCount[pid]=WaterHitCount[pid]+1
                    call UnitDamageTarget(caster,target,amount,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
                endif
            endif
        endif
    endloop
    if distance>=800. or caster==null or GetUnitTypeId(caster)==0 then
        call DestroyEffect(wave)
        call RemoveUnit(carrier)
        set WaterActive[pid]=WaterActive[pid]-1
        call DestroyGroup(hits)
        call DestroyGroup(candidates)
        call FlushChildHashtable(WaterWaves,key)
        call DestroyTimer(clock)
    else
        call SaveReal(WaterWaves,key,5,distance)
    endif
    set caster=null
    set target=null
    set wave=null
    set hits=null
    set candidates=null
    set carrier=null
    set clock=null
endfunction

function Water_Launch takes unit caster,real x,real y,real angle,real amount returns nothing
    local timer clock=CreateTimer()
    local integer key=GetHandleId(clock)
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local unit carrier=CreateUnit(GetOwningPlayer(caster),'h020',x,y,angle*bj_RADTODEG) // Dummy Missile
    local effect wave=AddSpecialEffectTarget("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveMissile.mdl",carrier,"chest")
    call SetUnitFlyHeight(carrier,40.,0.)
    call SaveUnitHandle(WaterWaves,key,0,caster)
    call SaveReal(WaterWaves,key,1,x)
    call SaveReal(WaterWaves,key,2,y)
    call SaveReal(WaterWaves,key,3,Cos(angle))
    call SaveReal(WaterWaves,key,4,Sin(angle))
    call SaveReal(WaterWaves,key,5,0.)
    call SaveReal(WaterWaves,key,6,amount)
    call SaveEffectHandle(WaterWaves,key,7,wave)
    call SaveGroupHandle(WaterWaves,key,8,CreateGroup())
    call SaveGroupHandle(WaterWaves,key,9,CreateGroup())
    call SaveUnitHandle(WaterWaves,key,10,carrier)
    call SaveInteger(WaterWaves,key,11,pid)
    set WaterActive[pid]=WaterActive[pid]+1
    call TimerStart(clock,.03,true,function Water_Tick)
    set carrier=null
    set wave=null
    set clock=null
endfunction

function Trig_Spell_Water_Actions takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local unit source=caster
    local unit target=GetSpellTargetUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(caster))
    local location point
    local real x=GetUnitX(caster)
    local real y=GetUnitY(caster)
    local real targetX
    local real targetY
    local real angle
    local integer power=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(caster,GetSpellAbilityId()))*5
    if Backpack_PageOf(pid,caster)>=0 then
        set source=Player_GetHero(Player(pid))
    endif
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
    if IsUnitType(source,UNIT_TYPE_HERO) then
        set power=power+GetHeroInt(source,true)*6
    endif
    set WaterStarted[pid]=WaterStarted[pid]+1
    call Water_Launch(source,x,y,angle,I2R(power)*Prof_RodPower(source))
    set caster=null
    set source=null
    set target=null
    set point=null
endfunction

// Observe the actual engine events, separately from the damage action.
function Water_Observe takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    if Trig_Spell_Water_IsWaterSpell() then
        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_CHANNEL then
            set WaterChannels[pid]=WaterChannels[pid]+1
        else
            set WaterEffects[pid]=WaterEffects[pid]+1
        endif
    endif
endfunction

function Water_Check takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    local unit hero=Player_GetHero(Player(pid))
    call DisplayTimedTextToPlayer(Player(pid),0.,0.,60.,"Water: item channel="+I2S(WaterChannels[pid])+" effect="+I2S(WaterEffects[pid])+" waves="+I2S(WaterStarted[pid])+" hits="+I2S(WaterHitCount[pid])+" active="+I2S(WaterActive[pid])+". Launching one visual-only wave in front of your hero.")
    if hero!=null then
        call Water_Launch(hero,GetUnitX(hero),GetUnitY(hero),GetUnitFacing(hero)*bj_DEGTORAD,0.)
    endif
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
