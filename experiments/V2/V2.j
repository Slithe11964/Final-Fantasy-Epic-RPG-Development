globals
 hashtable D2Data=null
 hashtable D2Poison=null
 group D2Watch=null
 integer D2Serial=0
endglobals
function D2_Active takes unit u,integer key returns boolean
 return D2Data!=null and Forest86Now<LoadReal(D2Data,GetHandleId(u),key)
endfunction
function D2_AuraPath takes unit u returns string
 if GetUnitTypeId(u)=='nfsh' and GetUnitAbilityLevel(u,'hEA0')>0 then
 return "war3mapImported\\EvasiveGreen.mdx"
 elseif GetUnitTypeId(u)=='nnsw' and GetUnitAbilityLevel(u,'nAU8')>0 then
 return "war3mapImported\\AbyssalPurple.mdx"
 elseif GetUnitTypeId(u)=='n00P' and GetUnitAbilityLevel(u,'zTH9')>0 then
 return "Abilities\\Spells\\NightElf\\ThornsAura\\ThornsAura.mdl"
 endif
 return ""
endfunction
function D2_Track takes unit u returns nothing
 local string path=D2_AuraPath(u)
 local integer id=GetHandleId(u)
 if D2Data!=null and path!="" and not IsUnitIllusion(u) then
 if not HaveSavedHandle(D2Data,id,1) then
 call SaveEffectHandle(D2Data,id,1,AddSpecialEffectTarget(path,u,"origin"))
 endif
 call GroupAddUnit(D2Watch,u)
 endif
endfunction
function D2_ClearPoison takes unit u returns nothing
 local integer id=GetHandleId(u)
 local integer record=LoadInteger(D2Data,id,80)
 local integer following=0
 loop
 exitwhen record==0
 set following=LoadInteger(D2Poison,record,4)
 call FlushChildHashtable(D2Poison,record)
 set record=following
 endloop
 call RemoveSavedInteger(D2Data,id,80)
 call RemoveSavedInteger(D2Data,id,81)
 call RemoveSavedInteger(D2Data,id,82)
 if GetUnitTypeId(u)!=0 then
 call UnitRemoveAbility(u,'bPV2')
 endif
endfunction
function D2_Cleanup takes unit u returns nothing
 local integer id=GetHandleId(u)
 if D2Data==null then
 return
 endif
 if HaveSavedHandle(D2Data,id,1) then
 call DestroyEffect(LoadEffectHandle(D2Data,id,1))
 endif
 if HaveSavedHandle(D2Data,id,51) then
 call DestroyEffect(LoadEffectHandle(D2Data,id,51))
 endif
 call D2_ClearPoison(u)
 call GroupRemoveUnit(D2Watch,u)
 call FlushChildHashtable(D2Data,id)
endfunction
function D2_ImageCancel takes unit u returns nothing
 local timer clock=LoadTimerHandle(N98Data,GetHandleId(u),33)
 if clock!=null then
 call RemoveSavedHandle(N98Data,GetHandleId(u),33)
 call FlushChildHashtable(N98Data,GetHandleId(clock))
 call DestroyTimer(clock)
 endif
 set clock=null
endfunction
function D2_ImageExpire takes nothing returns nothing
 local timer clock=GetExpiredTimer()
 local unit u=LoadUnitHandle(N98Data,GetHandleId(clock),0)
 call RemoveSavedHandle(N98Data,GetHandleId(u),33)
 call FlushChildHashtable(N98Data,GetHandleId(clock))
 call DestroyTimer(clock)
 if Forest86_Alive(u) then
 call SaveBoolean(N98Data,GetHandleId(u),32,true)
 call KillUnit(u)
 endif
 set clock=null
 set u=null
endfunction
function D2_ImageLife takes unit u returns nothing
 local timer clock=null
 if not HaveSavedHandle(N98Data,GetHandleId(u),33) then
 set clock=CreateTimer()
 call SaveTimerHandle(N98Data,GetHandleId(u),33,clock)
 call SaveUnitHandle(N98Data,GetHandleId(clock),0,u)
 call TimerStart(clock,30.,false,function D2_ImageExpire)
 endif
 set clock=null
endfunction
function D2_SpawnOffspring takes unit parent,integer childRaw,integer count returns nothing
 local integer i=0
 local unit child=null
 local real angle=0.
 local group wave=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(parent))
 loop
 exitwhen i>=count
 set angle=I2R(i)*360./I2R(count)*bj_DEGTORAD
 set child=F99_Summon(parent,childRaw,GetUnitX(parent)+90.*Cos(angle),GetUnitY(parent)+90.*Sin(angle),0.)
 call UnitRemoveType(child,UNIT_TYPE_SUMMONED)
 if wave!=null then
 call GroupAddUnit(wave,child)
 endif
 set i=i+1
 endloop
 set child=null
 set wave=null
endfunction
function D2_SpiderRoar takes unit source returns nothing
 local group g=CreateGroup()
 local unit u=null
 local integer count=0
 call GroupEnumUnitsInRange(g,GetUnitX(source),GetUnitY(source),1000.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(source)) and (GetUnitTypeId(u)=='n010' or GetUnitTypeId(u)=='nsbm') then
 set count=LoadInteger(D2Data,GetHandleId(u),90)+1
 call SaveInteger(D2Data,GetHandleId(u),90,count)
 call UnitAddAbility(u,'dFR2')
 call SetUnitAbilityLevel(u,'dFR2',IMinBJ(128,count))
 endif
 endloop
 call DestroyGroup(g)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl",source,"origin"))
 set u=null
 set g=null
endfunction
function D2_Death takes unit u returns nothing
 if GetUnitTypeId(u)=='nsbm' then
 call D2_SpawnOffspring(u,'nspr',2)
 elseif GetUnitTypeId(u)=='nspr' then
 call D2_SpiderRoar(u)
 endif
 call D2_Cleanup(u)
endfunction
function D2_PoisonAdd takes unit source,unit victim returns nothing
 local integer id=GetHandleId(victim)
 local integer tail=LoadInteger(D2Data,id,81)
 set D2Serial=D2Serial+1
 if tail!=0 then
 call SaveInteger(D2Poison,tail,4,D2Serial)
 else
 call SaveInteger(D2Data,id,80,D2Serial)
 endif
 call SaveInteger(D2Data,id,81,D2Serial)
 call SaveInteger(D2Data,id,82,LoadInteger(D2Data,id,82)+1)
 call SaveUnitHandle(D2Poison,D2Serial,0,source)
 call SaveReal(D2Poison,D2Serial,1,100.+5.*I2R(GetHeroLevel(victim)))
 call SaveReal(D2Poison,D2Serial,2,Forest86Now+1.)
 call SaveInteger(D2Poison,D2Serial,3,5)
 call GroupAddUnit(D2Watch,victim)
 call M89_Dummy(source,victim,'dPB2',"curse")
endfunction
function D2_OnHit takes unit source,unit victim returns nothing
 if GetUnitTypeId(source)=='nsbm' and BlzGetEventIsAttack() and Forest86_Enemy(source,victim) and IsUnitType(victim,UNIT_TYPE_HERO) and GetRandomInt(1,100)<=35 then
 call D2_PoisonAdd(source,victim)
 endif
endfunction
function D2_PoisonTick takes unit victim returns nothing
 local integer id=GetHandleId(victim)
 local integer record=LoadInteger(D2Data,id,80)
 local integer previous=0
 local integer following=0
 local integer count=LoadInteger(D2Data,id,82)
 local integer ticks=0
 local real total=0.
 local unit attacker=null
 local unit source=null
 loop
 exitwhen record==0
 set following=LoadInteger(D2Poison,record,4)
 set ticks=LoadInteger(D2Poison,record,3)
 if Forest86Now>=LoadReal(D2Poison,record,2) then
 set source=LoadUnitHandle(D2Poison,record,0)
 if source!=null and GetUnitTypeId(source)!=0 then
 set attacker=source
 set total=total+LoadReal(D2Poison,record,1)
 endif
 set ticks=ticks-1
 call SaveInteger(D2Poison,record,3,ticks)
 call SaveReal(D2Poison,record,2,Forest86Now+1.)
 endif
 if ticks<=0 then
 if previous==0 then
 call SaveInteger(D2Data,id,80,following)
 else
 call SaveInteger(D2Poison,previous,4,following)
 endif
 if LoadInteger(D2Data,id,81)==record then
 call SaveInteger(D2Data,id,81,previous)
 endif
 call FlushChildHashtable(D2Poison,record)
 set count=count-1
 else
 set previous=record
 endif
 set record=following
 endloop
 call SaveInteger(D2Data,id,82,count)
 if count<=0 then
 call D2_ClearPoison(victim)
 endif
 if total>0. and attacker!=null then
 set udg_IsPhysicalAttack=false
 set udg_DamageElement=0
 set udg_DmgFlagNoCrit=-1.
 set udg_DmgFlagUnavoidable=-1
 call UnitDamageTarget(attacker,victim,total,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
 endif
 set attacker=null
 set source=null
endfunction
function D2_FindEnemy takes unit source,real radius returns unit
 local group g=CreateGroup()
 local unit u=null
 local unit chosen=null
 local real best=radius*radius+1.
 local real r=0.
 call GroupEnumUnitsInRange(g,GetUnitX(source),GetUnitY(source),radius,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Enemy(source,u) then
 set r=(GetUnitX(u)-GetUnitX(source))*(GetUnitX(u)-GetUnitX(source))+(GetUnitY(u)-GetUnitY(source))*(GetUnitY(u)-GetUnitY(source))
 if r<best then
 set best=r
 set chosen=u
 endif
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 return chosen
endfunction
function D2_ArcherNear takes unit source returns boolean
 local group g=CreateGroup()
 local unit u=null
 local boolean found=false
 call GroupEnumUnitsInRange(g,GetUnitX(source),GetUnitY(source),800.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if GetUnitTypeId(u)=='qA99' and Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(source)) then
 set found=true
 exitwhen true
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 return found
endfunction
function D2_RootWeapons takes unit u,boolean rooted returns nothing
 if GetUnitTypeId(u)=='n00O' then
 call BlzSetUnitWeaponBooleanField(u,UNIT_WEAPON_BF_ATTACKS_ENABLED,0,rooted)
 call BlzSetUnitWeaponBooleanField(u,UNIT_WEAPON_BF_ATTACKS_ENABLED,1,not rooted)
 if rooted then
 call SetUnitAcquireRange(u,1000.)
 call SaveUnitHandle(D2Data,GetHandleId(u),22,D2_FindEnemy(u,1000.))
 call GroupAddUnit(D2Watch,u)
 else
 call RemoveSavedHandle(D2Data,GetHandleId(u),22)
 call SetUnitAcquireRange(u,1000.)
 call BlzEndUnitAbilityCooldown(u,'zAP9')
 endif
 endif
endfunction
function D2_TowerTick takes unit u returns nothing
 local unit target=LoadUnitHandle(D2Data,GetHandleId(u),22)
 local unit nextTarget=null
 if Forest86_Enemy(u,target) and IsUnitInRange(u,target,1000.) then
 if GetUnitCurrentOrder(u)!=OrderId("attack") then
 call IssueTargetOrder(u,"attack",target)
 endif
 else
 set nextTarget=D2_FindEnemy(u,1000.)
 if nextTarget!=null then
 call SaveUnitHandle(D2Data,GetHandleId(u),22,nextTarget)
 call IssueTargetOrder(u,"attack",nextTarget)
 elseif target!=null and Forest86_Alive(target) then
 call F99_RootEnd(u)
 call IssueTargetOrder(u,"attack",target)
 endif
 endif
 set target=null
 set nextTarget=null
endfunction
function D2_Spell takes unit caster,integer raw returns nothing
 local integer id=GetHandleId(caster)
 local effect fx=null
 if raw=='zEG9' and not HaveSavedReal(D2Data,id,50) then
 call SaveReal(D2Data,id,50,Forest86Now+10.)
 set fx=AddSpecialEffectTarget("Doodads\\Dungeon\\Terrain\\EggSack\\EggSack0.mdl",caster,"chest")
 call BlzSetSpecialEffectScale(fx,.45)
 call SaveEffectHandle(D2Data,id,51,fx)
 call GroupAddUnit(D2Watch,caster)
 elseif raw=='zCV9' then
 call SaveReal(D2Data,id,60,Forest86Now+30.)
 call GroupAddUnit(D2Watch,caster)
 call M89_Dummy(caster,caster,'dCB2',"curse")
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl",caster,"origin"))
 endif
 set fx=null
endfunction
function D2_TickUnit takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 local boolean watch=false
 if not Forest86_Alive(u) then
 call D2_Cleanup(u)
 set u=null
 return
 endif
 if D2_AuraPath(u)!="" then
 call D2_Track(u)
 set watch=true
 endif
 if HaveSavedReal(D2Data,id,50) then
 if Forest86Now>=LoadReal(D2Data,id,50) then
 call RemoveSavedReal(D2Data,id,50)
 call DestroyEffect(LoadEffectHandle(D2Data,id,51))
 call RemoveSavedHandle(D2Data,id,51)
 call D2_SpawnOffspring(u,'nsbm',3)
 else
 set watch=true
 endif
 endif
 if GetUnitTypeId(u)=='n00O' and HaveSavedReal(F99Data,id,10) then
 call D2_TowerTick(u)
 set watch=true
 endif
 if LoadInteger(D2Data,id,82)>0 then
 call D2_PoisonTick(u)
 set watch=true
 endif
 if D2_Active(u,60) then
 set watch=true
 endif
 if not watch then
 call GroupRemoveUnit(D2Watch,u)
 endif
 set u=null
endfunction
function D2_Tick takes nothing returns nothing
 call ForGroup(D2Watch,function D2_TickUnit)
endfunction
