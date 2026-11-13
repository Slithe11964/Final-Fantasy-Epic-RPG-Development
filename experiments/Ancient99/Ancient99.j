globals
 hashtable F99Data=null
 hashtable F99Stacks=null
 group F99Active=null
 group F99Guardians=null
 integer F99Serial=0
 boolean F99Reflecting=false
 boolean F99Sharing=false
 real F99AlertUntil=0.
 boolean F99AlertActive=false
endglobals
function F99_Pool takes integer raw returns boolean
 return raw=='n00P' or raw=='nepl' or raw=='nenp' or raw=='nsty' or raw=='n0ML' or raw=='n01N' or raw=='n010' or raw=='nsat' or raw=='nstl' or raw=='nsts' or raw=='nsth' or raw=='nenc' or raw=='n00N' or raw=='n00O'
endfunction
function F99_SummonType takes integer raw returns boolean
 return raw=='qL99' or raw=='qD99' or raw=='qS99' or raw=='qE99' or raw=='qI99' or raw=='qT99' or raw=='qA99'
endfunction
function F99_Active takes unit u,integer key returns boolean
 return F99Data!=null and Forest86Now<LoadReal(F99Data,GetHandleId(u),key)
endfunction
function F99_NearestHero takes unit source returns unit
 local integer i=0
 local unit hero=null
 local unit chosen=null
 local real distance=9999999999.
 local real candidate=0.
 local group g=null
 loop
 exitwhen i>=bj_MAX_PLAYERS
 set hero=Player_GetHero(Player(i))
 if Forest86_Enemy(source,hero) and IsUnitType(hero,UNIT_TYPE_HERO) and not BlzIsUnitInvulnerable(hero) then
 set candidate=(GetUnitX(hero)-GetUnitX(source))*(GetUnitX(hero)-GetUnitX(source))+(GetUnitY(hero)-GetUnitY(source))*(GetUnitY(hero)-GetUnitY(source))
 if candidate<distance then
 set chosen=hero
 set distance=candidate
 endif
 endif
 set i=i+1
 endloop
 if chosen==null then
 set g=CreateGroup()
 call GroupEnumUnitsInRange(g,GetUnitX(source),GetUnitY(source),2000.,null)
 loop
 set hero=FirstOfGroup(g)
 exitwhen hero==null
 call GroupRemoveUnit(g,hero)
 if Forest86_Enemy(source,hero) and IsUnitType(hero,UNIT_TYPE_HERO) and not BlzIsUnitInvulnerable(hero) then
 set candidate=(GetUnitX(hero)-GetUnitX(source))*(GetUnitX(hero)-GetUnitX(source))+(GetUnitY(hero)-GetUnitY(source))*(GetUnitY(hero)-GetUnitY(source))
 if candidate<distance then
 set chosen=hero
 set distance=candidate
 endif
 endif
 endloop
 call DestroyGroup(g)
 endif
 set g=null
 set hero=null
 return chosen
endfunction
function F99_Summon takes unit caster,integer raw,real x,real y,real duration returns unit
 local unit child=CreateUnit(GetOwningPlayer(caster),raw,x,y,GetUnitFacing(caster))
 call SetUnitUserData(child,GetUnitUserData(caster))
 if duration>0. then
 call UnitApplyTimedLife(child,'BTLF',duration)
 endif
 if raw=='qL99' then
 call SaveUnitHandle(F99Data,GetHandleId(child),21,F99_NearestHero(child))
 call GroupAddUnit(F99Active,child)
 elseif raw=='qE99' then
 call SaveReal(F99Data,GetHandleId(child),22,Forest86Now+10.)
 call GroupAddUnit(F99Active,child)
 call SetUnitAnimation(child,"stand")
 endif
 return child
endfunction
function F99_Brood takes unit shell returns nothing
 local integer i=0
 local real angle=0.
 local unit child=null
 if LoadBoolean(F99Data,GetHandleId(shell),23) then
 return
 endif
 call SaveBoolean(F99Data,GetHandleId(shell),23,true)
 loop
 exitwhen i>=3
 set angle=I2R(i)*120.*bj_DEGTORAD
 set child=F99_Summon(shell,'nsbm',GetUnitX(shell)+70.*Cos(angle),GetUnitY(shell)+70.*Sin(angle),60.)
 set i=i+1
 endloop
 call F99_LingerFx("Objects\\Spawnmodels\\Undead\\CryptFiendEggsack\\CryptFiendEggsack.mdl",GetUnitX(shell),GetUnitY(shell),1.5)
 set child=null
endfunction
function F99_Dummy takes unit caster,unit victim,integer raw,integer level,string order returns nothing
 local unit dummy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(victim),GetUnitY(victim),0.)
 if raw=='zSL9' then
 call UnitRemoveAbility(victim,'bSL9')
 endif
 call SetUnitVertexColor(dummy,255,255,255,0)
 call SetUnitPathing(dummy,false)
 call UnitAddAbility(dummy,raw)
 call SetUnitAbilityLevel(dummy,raw,level)
 call IssueTargetOrder(dummy,order,victim)
 call UnitApplyTimedLife(dummy,'BTLF',2.)
 set dummy=null
endfunction
function F99_Count takes unit u,integer kind returns integer
 if F99Data==null then
 return 0
 endif
 return LoadInteger(F99Data,GetHandleId(u),102+kind*3)
endfunction
function F99_ClearStack takes unit u,integer kind returns nothing
 local integer key=100+kind*3
 local integer id=GetHandleId(u)
 local integer record=LoadInteger(F99Data,id,key)
 local integer following=0
 loop
 exitwhen record==0
 set following=LoadInteger(F99Stacks,record,0)
 call FlushChildHashtable(F99Stacks,record)
 set record=following
 endloop
 call RemoveSavedInteger(F99Data,id,key)
 call RemoveSavedInteger(F99Data,id,key+1)
 call RemoveSavedInteger(F99Data,id,key+2)
 if GetUnitTypeId(u)!=0 then
 if kind==1 then
 call UnitRemoveAbility(u,'bAC9')
 elseif kind==2 then
 call UnitRemoveAbility(u,'bSL9')
 else
 call UnitRemoveAbility(u,'zAS9')
 endif
 endif
endfunction
function F99_AddStack takes unit source,unit u,integer kind,real duration returns nothing
 local integer id=GetHandleId(u)
 local integer key=100+kind*3
 local integer tail=LoadInteger(F99Data,id,key+1)
 local integer count=LoadInteger(F99Data,id,key+2)+1
 set F99Serial=F99Serial+1
 if tail!=0 then
 call SaveInteger(F99Stacks,tail,0,F99Serial)
 else
 call SaveInteger(F99Data,id,key,F99Serial)
 endif
 call SaveInteger(F99Data,id,key+1,F99Serial)
 call SaveInteger(F99Data,id,key+2,count)
 call SaveReal(F99Stacks,F99Serial,1,Forest86Now+duration)
 call GroupAddUnit(F99Active,u)
 if kind==1 then
 call M89_Dummy(source,u,'zAM9',"curse")
 elseif kind==2 then
 if count>=15 then
 call F99_ClearStack(u,2)
 call M89_Dummy(source,u,'zST9',"thunderbolt")
 else
 call F99_Dummy(source,u,'zSL9',count,"slow")
 endif
 else
 call UnitAddAbility(u,'zAS9')
 call SetUnitAbilityLevel(u,'zAS9',IMinBJ(32,count))
 endif
endfunction
function F99_ExpireStacks takes unit u,integer kind returns nothing
 local integer id=GetHandleId(u)
 local integer key=100+kind*3
 local integer record=LoadInteger(F99Data,id,key)
 local integer following=0
 local integer count=LoadInteger(F99Data,id,key+2)
 local boolean changed=false
 loop
 exitwhen record==0 or Forest86Now<LoadReal(F99Stacks,record,1)
 set following=LoadInteger(F99Stacks,record,0)
 call FlushChildHashtable(F99Stacks,record)
 set record=following
 set count=count-1
 set changed=true
 endloop
 if changed then
 call SaveInteger(F99Data,id,key,record)
 call SaveInteger(F99Data,id,key+2,count)
 if count<=0 then
 call F99_ClearStack(u,kind)
 elseif kind==2 then
 call F99_Dummy(u,u,'zSL9',count,"slow")
 elseif kind==3 then
 call SetUnitAbilityLevel(u,'zAS9',IMinBJ(32,count))
 endif
 endif
endfunction
function F99_RootEnd takes unit u returns nothing
 local integer id=GetHandleId(u)
 local integer raw=GetUnitTypeId(u)
 if not HaveSavedReal(F99Data,id,10) then
 return
 endif
 call RemoveSavedReal(F99Data,id,10)
 if raw!=0 then
 call BlzSetUnitArmor(u,BlzGetUnitArmor(u)-LoadReal(F99Data,id,14))
 if raw=='n00O' then
 call BlzSetUnitBaseDamage(u,BlzGetUnitBaseDamage(u,0)-100,0)
 call BlzSetUnitDiceSides(u,LoadInteger(F99Data,id,16),0)
 call BlzSetUnitWeaponRealField(u,UNIT_WEAPON_RF_ATTACK_RANGE,0,LoadReal(F99Data,id,15))
 endif
 call SetUnitMoveSpeed(u,LoadReal(F99Data,id,13))
 call SetUnitPropWindow(u,GetUnitDefaultPropWindow(u))
 if LoadBoolean(F99Data,id,17) then
 call UnitAddAbility(u,'Amov')
 endif
 call AddUnitAnimationProperties(u,"alternate",false)
 call SetUnitAnimation(u,"morph alternate")
 call QueueUnitAnimation(u,"stand")
 call UnitRemoveAbility(u,'zUP9')
 call IssueImmediateOrder(u,"stop")
 endif
endfunction
function F99_Root takes unit u returns nothing
 local integer id=GetHandleId(u)
 local integer raw=GetUnitTypeId(u)
 if F99_Active(u,10) then
 return
 endif
 call SaveReal(F99Data,id,10,Forest86Now+30.)
 call SaveReal(F99Data,id,11,Forest86Now+5.)
 call SaveReal(F99Data,id,13,GetUnitMoveSpeed(u))
 call SaveReal(F99Data,id,14,0.)
 call SaveBoolean(F99Data,id,17,GetUnitAbilityLevel(u,'Amov')>0)
 call SaveReal(F99Data,id,18,GetUnitX(u))
 call SaveReal(F99Data,id,19,GetUnitY(u))
 call UnitRemoveAbility(u,'Amov')
 call SetUnitMoveSpeed(u,0.)
 call SetUnitPropWindow(u,bj_PI)
 call SetUnitAnimation(u,"morph")
 call AddUnitAnimationProperties(u,"alternate",true)
 call QueueUnitAnimation(u,"stand alternate")
 call UnitAddAbility(u,'zUP9')
 if raw=='n00P' then
 call BlzSetUnitArmor(u,BlzGetUnitArmor(u)+100.)
 call SaveReal(F99Data,id,14,100.)
 elseif raw=='n00O' then
 call SaveReal(F99Data,id,15,BlzGetUnitWeaponRealField(u,UNIT_WEAPON_RF_ATTACK_RANGE,0))
 call SaveInteger(F99Data,id,16,BlzGetUnitDiceSides(u,0))
 call BlzSetUnitBaseDamage(u,BlzGetUnitBaseDamage(u,0)+100,0)
 call BlzSetUnitDiceSides(u,62,0)
 call BlzSetUnitWeaponRealField(u,UNIT_WEAPON_RF_ATTACK_RANGE,0,1000.)
 endif
 call GroupAddUnit(F99Active,u)
endfunction
function F99_DrainEnd takes unit u returns nothing
 local integer id=GetHandleId(u)
 if HaveSavedHandle(F99Data,id,55) then
 call DestroyLightning(LoadLightningHandle(F99Data,id,55))
 call RemoveSavedHandle(F99Data,id,55)
 endif
 call RemoveSavedHandle(F99Data,id,50)
 call RemoveSavedInteger(F99Data,id,51)
endfunction
function F99_StatsEnd takes unit u returns nothing
 local integer id=GetHandleId(u)
 if LoadBoolean(F99Data,id,31) then
 call RemoveSavedBoolean(F99Data,id,31)
 if GetUnitTypeId(u)!=0 then
 call BlzSetUnitBaseDamage(u,BlzGetUnitBaseDamage(u,0)-200,0)
 call BlzSetUnitArmor(u,BlzGetUnitArmor(u)-50.)
 endif
 endif
 if LoadBoolean(F99Data,id,34) then
 call RemoveSavedBoolean(F99Data,id,34)
 if GetUnitTypeId(u)!=0 then
 call BlzSetUnitArmor(u,BlzGetUnitArmor(u)-60.)
 endif
 endif
endfunction
function F99_Cleanup takes unit u returns nothing
 call F99_RootEnd(u)
 call F99_DrainEnd(u)
 call F99_StatsEnd(u)
 call F99_ClearStack(u,1)
 call F99_ClearStack(u,2)
 call F99_ClearStack(u,3)
 call GroupRemoveUnit(F99Active,u)
 call GroupRemoveUnit(F99Guardians,u)
 call FlushChildHashtable(F99Data,GetHandleId(u))
endfunction
function F99_Thorns takes unit source,unit target,real amount,integer kind returns nothing
 if not F99Reflecting and not B88Reflecting and kind!=4 and GetUnitAbilityLevel(target,'bTH9')>0 and Forest86_Enemy(target,source) and amount>0. then
 set F99Reflecting=true
 set udg_DmgFlagPure=true
 set udg_DmgFlagUnavoidable=-1
 call B88_Damage(target,source,amount*.1,false)
 set F99Reflecting=false
 endif
endfunction
function F99_Cover takes unit victim returns unit
 local unit protector=null
 local unit u=null
 local group g=CreateGroup()
 local real best=800.*800.+1.
 local real r=0.
 if GetUnitTypeId(victim)=='qA99' then
 call GroupAddGroup(F99Guardians,g)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(victim)) and GetUnitAbilityLevel(u,'zCV9')>0 then
 set r=(GetUnitX(u)-GetUnitX(victim))*(GetUnitX(u)-GetUnitX(victim))+(GetUnitY(u)-GetUnitY(victim))*(GetUnitY(u)-GetUnitY(victim))
 if r<best then
 set best=r
 set protector=u
 endif
 endif
 endloop
 endif
 call DestroyGroup(g)
 set g=null
 set u=null
 return protector
endfunction
function F99_Share takes unit source,unit victim,real amount returns real
 local unit protector=null
 if not F99Sharing and GetUnitTypeId(victim)=='qA99' and amount>0. then
 set protector=F99_Cover(victim)
 if protector!=null then
 set F99Sharing=true
 set udg_DmgFlagPure=true
 set udg_DmgFlagUnavoidable=-1
 set udg_IgnoresReduction=true
 call B88_Damage(source,protector,amount*.5,false)
 set F99Sharing=false
 set amount=amount*.5
 endif
 endif
 set protector=null
 return amount
endfunction
function F99_Death takes unit u returns nothing
 local group g=null
 local unit ally=null
 local integer raw=GetUnitTypeId(u)
 if raw=='n010' or raw=='qE99' then
 call F99_Brood(u)
 elseif raw=='qT99' then
 set g=CreateGroup()
 call GroupEnumUnitsInRange(g,GetUnitX(u),GetUnitY(u),600.,null)
 loop
 set ally=FirstOfGroup(g)
 exitwhen ally==null
 call GroupRemoveUnit(g,ally)
 if Forest86_Alive(ally) and IsUnitAlly(ally,GetOwningPlayer(u)) then
 call F99_AddStack(u,ally,3,20.)
 endif
 endloop
 call DestroyGroup(g)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl",u,"origin"))
 endif
 call F99_Cleanup(u)
 set g=null
 set ally=null
endfunction
function F99_OnHit takes unit source,unit target returns nothing
 local integer raw=GetUnitTypeId(source)
 local integer id=GetHandleId(target)
 local real damage=0.
 if F99Data==null or not BlzGetEventIsAttack() or not Forest86_Enemy(source,target) then
 return
 endif
 if raw=='qD99' then
 call F99_AddStack(source,target,1,30.)
 elseif raw=='n010' and IsUnitType(target,UNIT_TYPE_HERO) then
 call F99_AddStack(source,target,2,45.)
 elseif raw=='nenp' and IsUnitType(target,UNIT_TYPE_HERO) and GetRandomInt(1,100)<=30 then
 set damage=300.+7.*I2R(GetHeroLevel(target))
 if not HaveSavedReal(Forest86Data,id,11) or Forest86Now>=LoadReal(Forest86Data,id,12) or damage>=LoadReal(Forest86Data,id,11) then
 call SaveUnitHandle(Forest86Data,id,10,source)
 call SaveReal(Forest86Data,id,11,damage)
 call SaveReal(Forest86Data,id,12,Forest86Now+10.)
 call SaveReal(Forest86Data,id,13,Forest86Now+1.)
 call GroupAddUnit(Forest86Poisoned,target)
 call M89_Dummy(source,target,'xP95',"curse")
 endif
 endif
endfunction
function F99_Track takes unit u returns nothing
 if GetUnitTypeId(u)=='n00N' then
 call GroupAddUnit(F99Guardians,u)
 endif
endfunction
function F99_Summoned takes nothing returns nothing
 local unit parent=GetSummoningUnit()
 local unit child=GetSummonedUnit()
 local unit owner=LoadUnitHandle(F99Data,GetHandleId(parent),41)
 if GetUnitTypeId(parent)=='nsat' and IsUnitIllusion(child) then
 call SaveBoolean(F99Data,GetHandleId(child),40,true)
 call GroupAddUnit(F99Active,child)
 elseif owner!=null and IsUnitIllusion(child) then
 call SaveBoolean(F99Data,GetHandleId(child),40,true)
 call GroupAddUnit(F99Active,child)
 call IssueTargetOrder(child,"attack",LoadUnitHandle(F99Data,GetHandleId(parent),42))
 endif
 set parent=null
 set child=null
 set owner=null
endfunction
function F99_BindMirror takes nothing returns nothing
 local timer t=GetExpiredTimer()
 local unit parent=LoadUnitHandle(F99Data,GetHandleId(t),0)
 local group g=CreateGroup()
 local unit u=null
 call GroupEnumUnitsInRange(g,GetUnitX(parent),GetUnitY(parent),300.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if IsUnitIllusion(u) and GetUnitTypeId(u)=='nsat' and GetOwningPlayer(u)==GetOwningPlayer(parent) then
 call SaveBoolean(F99Data,GetHandleId(u),40,true)
 call GroupAddUnit(F99Active,u)
 endif
 endloop
 call FlushChildHashtable(F99Data,GetHandleId(t))
 call DestroyTimer(t)
 call DestroyGroup(g)
 set u=null
 set parent=null
 set g=null
 set t=null
endfunction
function F99_Food takes unit caster returns unit
 local group g=CreateGroup()
 local unit u=null
 local unit chosen=null
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),350.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if u!=caster and F99_Pool(GetUnitTypeId(u)) and M89_Injured(u) and IsUnitAlly(u,GetOwningPlayer(caster)) and not IsUnitType(u,UNIT_TYPE_HERO) and not IsUnitInGroup(u,udg_SpecialUnits) and not IsUnitIllusion(u) then
 set chosen=u
 exitwhen true
 endif
 endloop
 call DestroyGroup(g)
 set u=null
 set g=null
 return chosen
endfunction
function F99_FxEnd takes nothing returns nothing
 local timer t=GetExpiredTimer()
 call DestroyEffect(LoadEffectHandle(F99Data,GetHandleId(t),0))
 call FlushChildHashtable(F99Data,GetHandleId(t))
 call DestroyTimer(t)
 set t=null
endfunction
function F99_LingerFx takes string model,real x,real y,real duration returns nothing
 local timer clock=CreateTimer()
 call SaveEffectHandle(F99Data,GetHandleId(clock),0,AddSpecialEffect(model,x,y))
 call TimerStart(clock,duration,false,function F99_FxEnd)
 set clock=null
endfunction

function F99_VortexFx takes real x,real y returns nothing
 local effect fx=AddSpecialEffect("Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl",x,y)
 local timer t=CreateTimer()
 call BlzSetSpecialEffectScale(fx,1.4)
 call SaveEffectHandle(F99Data,GetHandleId(t),0,fx)
 call TimerStart(t,2.,false,function F99_FxEnd)
 set t=null
 set fx=null
endfunction
function F99_BindCopy takes nothing returns nothing
 local timer clock=GetExpiredTimer()
 local integer id=GetHandleId(clock)
 local unit parent=LoadUnitHandle(F99Data,id,0)
 local unit target=LoadUnitHandle(F99Data,id,1)
 local group g=CreateGroup()
 local unit child=null
 call GroupEnumUnitsInRange(g,LoadReal(F99Data,id,2),LoadReal(F99Data,id,3),350.,null)
 loop
 set child=FirstOfGroup(g)
 exitwhen child==null
 call GroupRemoveUnit(g,child)
 if IsUnitIllusion(child) and GetUnitTypeId(child)==GetUnitTypeId(target) and GetOwningPlayer(child)==GetOwningPlayer(parent) and not LoadBoolean(F99Data,GetHandleId(child),40) then
 call SaveBoolean(F99Data,GetHandleId(child),40,true)
 call GroupAddUnit(F99Active,child)
 if Forest86_Enemy(child,target) then
 call IssueTargetOrder(child,"attack",target)
 endif
 exitwhen true
 endif
 endloop
 call DestroyGroup(g)
 call FlushChildHashtable(F99Data,id)
 call DestroyTimer(clock)
 set parent=null
 set target=null
 set child=null
 set g=null
 set clock=null
endfunction

function F99_Spell takes unit caster,unit target,integer raw returns nothing
 local integer id=GetHandleId(caster)
 local unit child=null
 local unit dummy=null
 local timer t=null
 local integer i=0
 local real x=GetUnitX(caster)
 local real y=GetUnitY(caster)
 if raw=='zRT9' or raw=='zAW9' or raw=='zAP9' then
 call F99_Root(caster)
 elseif raw=='zUP9' then
 call F99_RootEnd(caster)
 elseif raw=='zDY9' or raw=='zEN9' then
 loop
 exitwhen i>=3 or (raw=='zDY9' and i>=2)
 if raw=='zDY9' then
 set child=F99_Summon(caster,'qD99',x+90.*Cos(I2R(i)*3.14),y+90.*Sin(I2R(i)*3.14),60.)
 else
 set child=F99_Summon(caster,'qT99',x+90.*Cos(I2R(i)*2.094),y+90.*Sin(I2R(i)*2.094),60.)
 endif
 set i=i+1
 endloop
 call F99_LingerFx("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl",x,y,1.5)
 elseif raw=='zSY9' then
 set child=F99_Summon(caster,'qS99',x+100.,y,60.)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl",child,"origin"))
 elseif raw=='zEG9' then
 set child=F99_Summon(caster,'qE99',x+100.,y,0.)
 elseif raw=='zIF9' then
 set x=GetSpellTargetX()
 set y=GetSpellTargetY()
 call F99_LingerFx("Units\\Demon\\Infernal\\InfernalBirth.mdl",x,y,2.)
 call M89_Area(caster,x,y,300.,2000.,1,false)
 set child=F99_Summon(caster,'qI99',x,y,60.)
 elseif raw=='zDV9' then
 if target!=caster and F99_Pool(GetUnitTypeId(target)) and M89_Injured(target) and IsUnitAlly(target,GetOwningPlayer(caster)) and not IsUnitType(target,UNIT_TYPE_HERO) and not IsUnitInGroup(target,udg_SpecialUnits) and not IsUnitIllusion(target) and LoadInteger(Forest86Data,id,90)<2 then
 call M89_Absorb(caster,target)
 call F99_Cleanup(target)
 call N98_Cleanup(target)
 call C95_Cleanup(target)
 call GroupRemoveUnit(Forest86Actors,target)
 call FlushChildHashtable(Forest86Data,GetHandleId(target))
 call RemoveUnit(target)
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+300.))
 call BlzEndUnitAbilityCooldown(caster,'zDV9')
 endif
 elseif raw=='zDL9' or raw=='zDM9' then
 call F99_DrainEnd(caster)
 call SaveUnitHandle(F99Data,id,50,target)
 call SaveInteger(F99Data,id,51,5)
 call SaveReal(F99Data,id,52,Forest86Now+1.)
 call SaveInteger(F99Data,id,53,1)
 call SaveInteger(F99Data,id,54,OrderId("drain"))
 if raw=='zDL9' then
 call SaveLightningHandle(F99Data,id,55,AddLightningEx("DRAL",true,x,y,60.,GetUnitX(target),GetUnitY(target),60.))
 else
 call SaveInteger(F99Data,id,53,2)
 call SaveInteger(F99Data,id,54,OrderId("siphonmana"))
 call SaveLightningHandle(F99Data,id,55,AddLightningEx("DRAM",true,x,y,60.,GetUnitX(target),GetUnitY(target),60.))
 endif
 call GroupAddUnit(F99Active,caster)
 elseif raw=='zIC9' then
 call M89_Area(caster,GetUnitX(target),GetUnitY(target),200.,2000.,2,false)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl",target,"origin"))
 elseif raw=='zAB9' then
 call M89_Projectile(caster,target,'zQB9',1500.,4,false)
 elseif raw=='zCU9' then
 call M89_Heal(caster,target,1500.)
 elseif raw=='zCL9' and IsUnitType(target,UNIT_TYPE_HERO) then
 set dummy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(target),GetUnitY(target),0.)
 call SetUnitVertexColor(dummy,255,255,255,0)
 call SaveUnitHandle(F99Data,GetHandleId(dummy),41,caster)
 call SaveUnitHandle(F99Data,GetHandleId(dummy),42,target)
 call UnitAddAbility(dummy,'zCI9')
 call IssueTargetOrderById(dummy,852274,target)
 call UnitApplyTimedLife(dummy,'BTLF',2.)
 set t=CreateTimer()
 call SaveUnitHandle(F99Data,GetHandleId(t),0,caster)
 call SaveUnitHandle(F99Data,GetHandleId(t),1,target)
 call SaveReal(F99Data,GetHandleId(t),2,GetUnitX(target))
 call SaveReal(F99Data,GetHandleId(t),3,GetUnitY(target))
 call TimerStart(t,.1,false,function F99_BindCopy)
 elseif raw=='zMI9' then
 set t=CreateTimer()
 call SaveUnitHandle(F99Data,GetHandleId(t),0,caster)
 call TimerStart(t,0.,false,function F99_BindMirror)
 elseif raw=='zAC9' then
 call F99_StatsEnd(caster)
 call M89_Heal(caster,caster,I2R(BlzGetUnitMaxHP(caster))*.5)
 call BlzSetUnitBaseDamage(caster,BlzGetUnitBaseDamage(caster,0)+200,0)
 call BlzSetUnitArmor(caster,BlzGetUnitArmor(caster)+50.)
 call SaveBoolean(F99Data,id,31,true)
 call SaveReal(F99Data,id,30,Forest86Now+20.)
 call GroupAddUnit(F99Active,caster)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\RegenerationAura\\ObsidianRegenAura.mdl",caster,"origin"))
 elseif raw=='zIT9' then
 call Forest86_Taunt(caster)
 if not LoadBoolean(F99Data,id,34) then
 call BlzSetUnitArmor(caster,BlzGetUnitArmor(caster)+60.)
 endif
 call SaveBoolean(F99Data,id,34,true)
 call SaveReal(F99Data,id,33,Forest86Now+20.)
 call GroupAddUnit(F99Active,caster)
 call M89_Dummy(caster,caster,'zIB9',"curse")
 elseif raw=='zPR9' then
 call M89_Dummy(caster,target,'zPB9',"curse")
 elseif raw=='zSH9' then
 call M89_Dummy(caster,target,'zSB9',"curse")
 endif
 set child=null
 set dummy=null
 set t=null
endfunction
function F99_TickUnit takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 local integer raw=GetUnitTypeId(u)
 local unit target=null
 local unit child=null
 local unit ally=null
 local group g=null
 local real drained=0.
 local real before=0.
 local integer ticks=LoadInteger(F99Data,id,51)
 if not Forest86_Alive(u) then
 if raw=='qE99' then
 call F99_Brood(u)
 endif
 call F99_Cleanup(u)
 set u=null
 return
 endif
 call F99_ExpireStacks(u,1)
 call F99_ExpireStacks(u,2)
 call F99_ExpireStacks(u,3)
 if HaveSavedReal(F99Data,id,10) then
 call SetUnitX(u,LoadReal(F99Data,id,18))
 call SetUnitY(u,LoadReal(F99Data,id,19))
 if raw!='n00O' and Forest86Now>=LoadReal(F99Data,id,11) then
 if raw=='n00P' then
 set child=F99_Summon(u,'qL99',GetUnitX(u)+100.,GetUnitY(u),60.)
 else
 set child=F99_Summon(u,'qA99',GetUnitX(u)+100.,GetUnitY(u),60.)
 endif
 call SaveReal(F99Data,id,11,LoadReal(F99Data,id,11)+5.)
 endif
 if not F99_Active(u,10) then
 call F99_RootEnd(u)
 endif
 endif
 if raw=='qL99' then
 set target=LoadUnitHandle(F99Data,id,21)
 if not Forest86_Enemy(u,target) then
 set target=F99_NearestHero(u)
 call SaveUnitHandle(F99Data,id,21,target)
 endif
 if target!=null then
 if IsUnitInRange(u,target,250.) then
 call M89_Area(u,GetUnitX(u),GetUnitY(u),500.,3000.,1,false)
 call F99_LingerFx("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl",GetUnitX(u),GetUnitY(u),1.5)
 call KillUnit(u)
 else
 call IssueTargetOrder(u,"move",target)
 endif
 endif
 elseif raw=='qE99' and Forest86Now>=LoadReal(F99Data,id,22) then
 call F99_Brood(u)
 call KillUnit(u)
 endif
 if ticks>0 then
 set target=LoadUnitHandle(F99Data,id,50)
 if not Forest86_Enemy(u,target) or not IsUnitInRange(u,target,800.) or IsUnitPaused(u) or GetUnitCurrentOrder(u)!=LoadInteger(F99Data,id,54) then
 call F99_DrainEnd(u)
 elseif Forest86Now>=LoadReal(F99Data,id,52) then
 call SaveReal(F99Data,id,52,Forest86Now+1.)
 call MoveLightningEx(LoadLightningHandle(F99Data,id,55),true,GetUnitX(u),GetUnitY(u),60.,GetUnitX(target),GetUnitY(target),60.)
 if LoadInteger(F99Data,id,53)==1 then
 set before=GetWidgetLife(target)
 call M89_Damage(u,target,1000.,0)
 set drained=RMaxBJ(0.,before-RMaxBJ(0.,GetWidgetLife(target)))
 call M89_Heal(u,u,drained*.5)
 set g=CreateGroup()
 call GroupEnumUnitsInRange(g,GetUnitX(u),GetUnitY(u),600.,null)
 loop
 set ally=FirstOfGroup(g)
 exitwhen ally==null
 call GroupRemoveUnit(g,ally)
 if ally!=u and Forest86_Alive(ally) and IsUnitAlly(ally,GetOwningPlayer(u)) then
 call M89_Heal(u,ally,drained*.5)
 endif
 endloop
 call DestroyGroup(g)
 else
 set drained=RMinBJ(300.,GetUnitState(target,UNIT_STATE_MANA))
 call SetUnitState(target,UNIT_STATE_MANA,GetUnitState(target,UNIT_STATE_MANA)-drained)
 call SetUnitState(u,UNIT_STATE_MANA,RMinBJ(GetUnitState(u,UNIT_STATE_MAX_MANA),GetUnitState(u,UNIT_STATE_MANA)+drained))
 call M89_Damage(u,target,drained*2.,0)
 endif
 call SaveInteger(F99Data,id,51,ticks-1)
 if ticks<=1 then
 call F99_DrainEnd(u)
 endif
 endif
 endif
 if (LoadBoolean(F99Data,id,31) and not F99_Active(u,30)) or (LoadBoolean(F99Data,id,34) and not F99_Active(u,33)) then
 call F99_StatsEnd(u)
 endif
 if raw!='qL99' and raw!='qE99' and not HaveSavedReal(F99Data,id,10) and LoadInteger(F99Data,id,51)==0 and not LoadBoolean(F99Data,id,31) and not LoadBoolean(F99Data,id,34) and F99_Count(u,1)==0 and F99_Count(u,2)==0 and F99_Count(u,3)==0 and not LoadBoolean(F99Data,id,40) then
 call GroupRemoveUnit(F99Active,u)
 endif
 set target=null
 set child=null
 set ally=null
 set g=null
 set u=null
endfunction
function F99_Tick takes nothing returns nothing
 if not udg_InCinematicMode then
 call ForGroup(F99Active,function F99_TickUnit)
 endif
 if F99AlertActive and Forest86Now>=F99AlertUntil then
 set F99AlertActive=false
 call ExecuteFunc("F99_UpdateSpawnTimer")
 endif
endfunction
function F99_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit ally=null
 if F99_Active(u,10) or LoadInteger(F99Data,GetHandleId(u),51)>0 or IsUnitIllusion(u) then
 return
 endif
 if raw=='n00P' then
 if Forest86_Ready(u,'zDV9',300) and LoadInteger(Forest86Data,GetHandleId(u),90)<2 then
 set ally=F99_Food(u)
 if ally!=null then
 call IssueTargetOrder(u,"devour",ally)
 set ally=null
 return
 endif
 endif
 if Forest86_Ready(u,'zDY9',250) then
 call IssueImmediateOrder(u,"forceofnature")
 elseif Forest86_Ready(u,'zSY9',800) then
 call IssueImmediateOrder(u,"waterelemental")
 elseif BlzGetUnitAbilityCooldownRemaining(u,'zDY9')>0. and BlzGetUnitAbilityCooldownRemaining(u,'zSY9')>0. and Forest86_Ready(u,'zRT9',0) and victim!=null then
 call IssueImmediateOrder(u,"root")
 endif
 elseif raw=='nenc' and Forest86_Ready(u,'zEN9',200) then
 call IssueImmediateOrder(u,"forceofnature")
 elseif raw=='n010' and Forest86_Ready(u,'zEG9',150) then
 call IssueImmediateOrder(u,"carrionscarabs")
 elseif raw=='n00N' and victim!=null and Forest86_Ready(u,'zAW9',0) then
 call IssueImmediateOrder(u,"root")
 elseif raw=='n00O' and victim!=null and Forest86_Ready(u,'zAP9',0) then
 call IssueImmediateOrder(u,"root")
 elseif raw=='qS99' then
 if Forest86_Ready(u,'zHA9',100) then
 set ally=B88_Ally(u,'B00F')
 if ally!=null then
 call IssueTargetOrder(u,"bloodlust",ally)
 set ally=null
 return
 endif
 endif
 if Forest86_Ready(u,'zPR9',100) then
 set ally=B88_Ally(u,'B007')
 if ally!=null then
 call IssueTargetOrder(u,"innerfire",ally)
 set ally=null
 return
 endif
 endif
 if Forest86_Ready(u,'zSH9',100) then
 set ally=B88_Ally(u,'B05O')
 if ally!=null then
 call IssueTargetOrder(u,"antimagicshell",ally)
 set ally=null
 return
 endif
 endif
 if victim!=null and Forest86_Ready(u,'zSI9',100) then
 call IssuePointOrder(u,"silence",GetUnitX(victim),GetUnitY(victim))
 elseif victim!=null and Forest86_Ready(u,'zIM9',100) then
 call IssueTargetOrder(u,"drunkenhaze",victim)
 endif
 elseif raw=='nstl' then
 if Forest86_Ready(u,'zCU9',150) then
 set ally=Forest86_Find(u,1)
 if ally==null and M89_Injured(u) then
 set ally=u
 endif
 if ally!=null then
 call IssueTargetOrder(u,"holybolt",ally)
 set ally=null
 return
 endif
 endif
 if victim!=null and Forest86_Ready(u,'zDL9',200) then
 call IssueTargetOrder(u,"drain",victim)
 elseif victim!=null and GetUnitState(victim,UNIT_STATE_MANA)>0. and Forest86_Ready(u,'zDM9',200) then
 call IssueTargetOrder(u,"siphonmana",victim)
 endif
 elseif victim!=null then
 if raw=='n01N' then
 if Forest86_Ready(u,'zFL9',200) then
 call IssueTargetOrder(u,"forkedlightning",victim)
 elseif Forest86_Ready(u,'zIC9',200) then
 call IssueTargetOrder(u,"frostnova",victim)
 elseif Forest86_Ready(u,'zAB9',200) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 endif
 elseif raw=='nsat' then
 if Forest86_Ready(u,'zBL9',100) then
 call IssueTargetOrder(u,"curse",victim)
 elseif Forest86_Ready(u,'zMI9',150) then
 call IssueImmediateOrder(u,"mirrorimage")
 endif
 elseif raw=='nsts' and IsUnitType(victim,UNIT_TYPE_HERO) and Forest86_Ready(u,'zCL9',200) then
 call IssueTargetOrder(u,"shadowstrike",victim)
 elseif raw=='nsth' then
 if Forest86_Ready(u,'zAC9',125) then
 call IssueImmediateOrder(u,"battleroar")
 elseif Forest86_Ready(u,'zIF9',300) then
 call IssuePointOrder(u,"inferno",GetUnitX(victim),GetUnitY(victim))
 endif
 elseif raw=='qI99' and IsUnitInRange(u,victim,450.) and Forest86_Ready(u,'zIT9',0) then
 call IssueImmediateOrder(u,"roar")
 endif
 endif
 set ally=null
endfunction
