// Uses the existing shared forest heartbeat. Charges alone use an active-only 10 Hz timer.
globals
 group B88Buffs=null
 group B88Charges=null
 timer B88ChargeTimer=null
 real B88AlertUntil=0.
 boolean B88AlertActive=false
 boolean B88Reflecting=false
endglobals
function B88_Pool takes integer raw returns boolean
 return raw=='ncea' or raw=='ncer' or raw=='ncim' or raw=='ncen' or raw=='ncks' or raw=='ncnk' or raw=='n0MN' or raw=='nltl' or raw=='nthl' or raw=='nstw' or raw=='nrzt' or raw=='nrzs' or raw=='nqbh' or raw=='nrzb' or raw=='nrzm' or raw=='nrzg' or raw=='nowb' or raw=='nowe' or raw=='nowk' or raw=='nhar' or raw=='nhrr' or raw=='nhrw' or raw=='nhrh' or raw=='n0L0' or raw=='nhrq'
endfunction
function B88_Actor takes integer raw returns boolean
 return B88_Pool(raw)
endfunction
function B88_Damage takes unit source,unit target,real amount,boolean physical returns nothing
 if Forest86_Alive(source) and Forest86_Alive(target) and amount>0. then
 set udg_IsPhysicalAttack=physical
 set udg_DamageElement=0
 set udg_DmgFlagNoCrit=-1.
 call UnitDamageTarget(source,target,amount,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
 endif
endfunction
function B88_Buff takes unit u,integer key,real duration returns nothing
 call SaveReal(Forest86Data,GetHandleId(u),key,Forest86Now+duration)
 call GroupAddUnit(B88Buffs,u)
endfunction
function B88_Quill takes unit caster,unit victim,real offset returns nothing
 local unit dummy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(caster),GetUnitY(caster)+offset,GetUnitFacing(caster))
 local integer id=GetHandleId(dummy)
 call ShowUnit(dummy,false)
 call SaveUnitHandle(udg_ProxyDamageHash,id,0,caster)
 call SaveReal(udg_ProxyDamageHash,id,1,120.)
 call SaveInteger(udg_ProxyDamageHash,id,2,2)
 call SaveBoolean(udg_ProxyDamageHash,id,5,true)
 call UnitAddAbility(dummy,'bY88')
 call IssueTargetOrder(dummy,"thunderbolt",victim)
 call UnitApplyTimedLife(dummy,'BTLF',12.)
 set dummy=null
endfunction
function B88_Active takes unit u,integer key returns boolean
 return Forest86Data!=null and Forest86Now<LoadReal(Forest86Data,GetHandleId(u),key)
endfunction
function B88_Area takes unit caster,integer key,real duration returns nothing
 local group g=CreateGroup()
 local unit u
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),450.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Enemy(caster,u) then
 call B88_Buff(u,key,duration)
 endif
 endloop
 call DestroyGroup(g)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl",caster,"origin"))
 set g=null
 set u=null
endfunction
function B88_Ally takes unit caster,integer missingBuff returns unit
 local group g=CreateGroup()
 local unit u
 local unit chosen=null
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),600.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if u!=caster and Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(caster)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
 if (missingBuff==0 and B88_Pool(GetUnitTypeId(u)) and not IsUnitType(u,UNIT_TYPE_HERO) and not IsUnitInGroup(u,udg_SpecialUnits)) or (missingBuff==1 and not B88_Active(u,44)) or (missingBuff>1 and GetUnitAbilityLevel(u,missingBuff)==0) then
 set chosen=u
 exitwhen true
 endif
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 return chosen
endfunction
function B88_Thorns takes unit source,unit target,real amount returns nothing
 if not B88Reflecting and Forest86_Alive(source) and GetUnitTypeId(target)=='nowe' and B88_Active(target,42) and IsUnitEnemy(source,GetOwningPlayer(target)) and amount>0. then
 set B88Reflecting=true
 set udg_DmgFlagPure=true
 set udg_DmgFlagUnavoidable=-1
 call B88_Damage(target,source,amount*.1,false)
 set B88Reflecting=false
 endif
endfunction
function B88_UpdateSpawnTimer takes nothing returns nothing
 local timer wave=LoadTimerHandle(udg_SpawnTimerHash,3,2)
 local timer zone=LoadTimerHandle(udg_SpawnTimerHash,1,2)
 if wave!=null and zone!=null and TimerGetRemaining(zone)>0. then
 call TimerStart(wave,30./I2R(Forest86_SpawnFactor(2)),true,function Trig_Zone_Spawn_System_ZoneRespawnTick)
 endif
 set wave=null
 set zone=null
endfunction
function B88_ChargeEnd takes unit u returns nothing
 local unit victim=LoadUnitHandle(Forest86Data,GetHandleId(u),60)
 call GroupRemoveUnit(B88Charges,u)
 call RemoveSavedHandle(Forest86Data,GetHandleId(u),60)
 call PauseUnit(u,false)
 call ResetUnitAnimation(u)
 if Forest86_Enemy(u,victim) and Forest86_Alive(u) then
 if GetUnitTypeId(u)=='nrzg' then
 call B88_Buff(victim,43,5.)
 else
 call B88_Damage(u,victim,400.,true)
 call B88_Buff(victim,46,5.)
 call UnitAddAbility(victim,'bX88')
 endif
 endif
 set victim=null
endfunction
function B88_ChargeStep takes nothing returns nothing
 local unit u=GetEnumUnit()
 local unit victim=LoadUnitHandle(Forest86Data,GetHandleId(u),60)
 local real dx=GetUnitX(victim)-GetUnitX(u)
 local real dy=GetUnitY(victim)-GetUnitY(u)
 local real distance=SquareRoot(dx*dx+dy*dy)
 local real step=RMinBJ(100.,RMaxBJ(0.,distance-90.))
 if not Forest86_Alive(u) or not Forest86_Enemy(u,victim) or Forest86Now>=LoadReal(Forest86Data,GetHandleId(u),61) or distance<=110. then
 call B88_ChargeEnd(u)
 else
 call SetUnitFacing(u,Atan2(dy,dx)*bj_RADTODEG)
 call SetUnitX(u,GetUnitX(u)+step*dx/distance)
 call SetUnitY(u,GetUnitY(u)+step*dy/distance)
 endif
 set u=null
 set victim=null
endfunction
function B88_ChargeTick takes nothing returns nothing
 call ForGroup(B88Charges,function B88_ChargeStep)
 if FirstOfGroup(B88Charges)==null then
 call PauseTimer(B88ChargeTimer)
 endif
endfunction
function B88_Charge takes unit caster,unit victim returns nothing
 if not Forest86_Enemy(caster,victim) then
 return
 endif
 if FirstOfGroup(B88Charges)==null then
 call TimerStart(B88ChargeTimer,.1,true,function B88_ChargeTick)
 endif
 call SaveUnitHandle(Forest86Data,GetHandleId(caster),60,victim)
 call SaveReal(Forest86Data,GetHandleId(caster),61,Forest86Now+3.)
 call GroupAddUnit(B88Charges,caster)
 call PauseUnit(caster,true)
 call SetUnitAnimation(caster,"walk")
endfunction
function B88_BuffTick takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 local integer key=40
 local boolean active=false
 local unit source=LoadUnitHandle(Forest86Data,id,48)
 if Forest86_Alive(u) then
 if LoadReal(Forest86Data,id,47)>0. and Forest86Now<=LoadReal(Forest86Data,id,47) and Forest86_Alive(source) then
 call B88_Damage(source,u,I2R(BlzGetUnitMaxHP(u))*.01,true)
 endif
 loop
 exitwhen key>47
 if B88_Active(u,key) then
 set active=true
 endif
 set key=key+1
 endloop
 endif
 if not B88_Active(u,45) or not Forest86_Alive(u) then
 call UnitRemoveAbility(u,'bA88')
 endif
 if not B88_Active(u,46) or not Forest86_Alive(u) then
 call UnitRemoveAbility(u,'bX88')
 endif
 if not active or not Forest86_Alive(u) then
 call GroupRemoveUnit(B88Buffs,u)
 endif
 set source=null
 set u=null
endfunction
function B88_Spell takes unit caster,unit victim,integer raw returns nothing
 local integer id=GetHandleId(caster)
 local group spawned=null
 local unit dummy=null
 if raw=='bD88' then
 if Forest86_Alive(victim) and victim!=caster and B88_Pool(GetUnitTypeId(victim)) and not IsUnitType(victim,UNIT_TYPE_HERO) and not IsUnitInGroup(victim,udg_SpecialUnits) then
 set spawned=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(victim))
 if spawned!=null then
 call GroupRemoveUnit(spawned,victim)
 endif
 call GroupRemoveUnit(Forest86Actors,victim)
 call RemoveUnit(victim)
 call UnitAddAbility(caster,'bR88')
 call SaveBoolean(Forest86Data,id,1,true)
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+250.))
 call BlzEndUnitAbilityCooldown(caster,'bD88')
 endif
 elseif raw=='bT88' or raw=='bK88' then
 call Forest86_Taunt(caster)
 if raw=='bT88' then
 call B88_Buff(caster,42,5.)
 else
 call UnitAddAbility(caster,'bA88')
 call B88_Buff(caster,45,15.)
 endif
 elseif raw=='bW88' then
 call B88_Area(caster,40,5.)
 elseif raw=='bV88' then
 call B88_Area(caster,41,10.)
 elseif raw=='bB88' and Forest86_Enemy(caster,victim) then
 call B88_Damage(caster,victim,300.,true)
 call SaveUnitHandle(Forest86Data,GetHandleId(victim),48,caster)
 call B88_Buff(victim,47,3.)
 elseif raw=='bG88' or raw=='bC88' then
 call B88_Charge(caster,victim)
 elseif raw=='bQ88' and Forest86_Enemy(caster,victim) then
 call B88_Quill(caster,victim,-25.)
 call B88_Quill(caster,victim,0.)
 call B88_Quill(caster,victim,25.)
 elseif raw=='bU88' and victim!=null and IsUnitAlly(victim,GetOwningPlayer(caster)) then
 call B88_Buff(victim,44,20.)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\InnerFire\\InnerFireTarget.mdl",victim,"overhead"))
 elseif raw=='bO88' and Forest86_Enemy(caster,victim) then
 set dummy=CreateUnit(GetOwningPlayer(caster),'h02S',GetUnitX(caster),GetUnitY(caster),0.)
 call ShowUnit(dummy,false)
 call UnitAddAbility(dummy,'bOF8')
 call IssueTargetOrder(dummy,"curse",victim)
 call UnitApplyTimedLife(dummy,'BTLF',2.)
 endif
 set spawned=null
 set dummy=null
endfunction
function B88_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit ally=null
 if raw=='nqbh' and not LoadBoolean(Forest86Data,GetHandleId(u),1) and Forest86_Ready(u,'bD88',250) then
 set ally=B88_Ally(u,0)
 if ally!=null then
 call IssueTargetOrder(u,"devour",ally)
 endif
 elseif raw=='nrzm' and Forest86_Ready(u,'bH88',50) then
 set ally=Forest86_Find(u,1)
 if ally!=null then
 call IssueTargetOrder(u,"heal",ally)
 endif
 elseif raw=='nstw' and Forest86_Ready(u,'bF88',150) then
 set ally=B88_Ally(u,'B05A')
 if ally!=null then
 call IssueTargetOrder(u,"unholyfrenzy",ally)
 endif
 elseif raw=='ncks' and LoadBoolean(Forest86Data,GetHandleId(u),49) and Forest86_Ready(u,'bU88',100) then
 set ally=B88_Ally(u,1)
 if ally!=null then
 call IssueTargetOrder(u,"innerfire",ally)
 endif
 elseif raw=='nhrq' and Forest86_Ready(u,'bJ88',75) then
 set ally=Forest86_Find(u,1)
 if ally!=null then
 call IssueTargetOrder(u,"rejuvination",ally)
 endif
 endif
 if victim!=null then
 if raw=='nqbh' and Forest86_Ready(u,'bR88',100) and not LoadBoolean(Forest86Data,GetHandleId(u),65) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif raw=='nowe' and Forest86_Ready(u,'bT88',0) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='ncnk' and Forest86_Ready(u,'bK88',150) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='nowb' and Forest86_Ready(u,'bW88',0) then
 call IssueImmediateOrder(u,"howlofterror")
 elseif raw=='ncer' and Forest86_Ready(u,'bV88',0) then
 call IssueImmediateOrder(u,"howlofterror")
 elseif raw=='nrzb' and Forest86_Ready(u,'bB88',0) then
 call IssueTargetOrder(u,"cripple",victim)
 elseif raw=='nrzg' and Forest86_Ready(u,'bG88',50) then
 call IssueTargetOrder(u,"acidbomb",victim)
 elseif raw=='ncen' and Forest86_Ready(u,'bC88',0) then
 call IssueTargetOrder(u,"acidbomb",victim)
 elseif raw=='nrzt' and Forest86_Ready(u,'bQ88',50) then
 call IssueTargetOrder(u,"shadowstrike",victim)
 elseif raw=='ncea' and Forest86_Ready(u,'bS88',0) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif raw=='ncim' and Forest86_Ready(u,'bZ88',0) then
 call IssueImmediateOrder(u,"berserk")
 elseif (raw=='nltl' or raw=='nthl') and Forest86_Ready(u,'bL88',120) then
 call IssueTargetOrder(u,"chainlightning",victim)
 elseif raw=='nthl' and Forest86_Ready(u,'bI88',75) and GetUnitAbilityLevel(u,'Blsh')==0 then
 call IssueTargetOrder(u,"lightningshield",u)
 elseif raw=='nthl' and Forest86_Ready(u,'bM88',0) and IsUnitInRange(u,victim,250.) then
 call IssueImmediateOrder(u,"creepthunderclap")
 elseif (raw=='nhrw' or raw=='nhrq') and Forest86_Ready(u,'bE88',35) and GetUnitAbilityLevel(victim,'Bfae')==0 then
 call IssueTargetOrder(u,"faeriefire",victim)
 elseif raw=='nhrq' and Forest86_Ready(u,'bN88',50) and GetUnitState(victim,UNIT_STATE_MANA)>0. then
 call IssueTargetOrder(u,"manaburn",victim)
 elseif raw=='n0L0' and Forest86_Ready(u,'bO88',50) then
 call IssueTargetOrder(u,"drunkenhaze",victim)
 elseif raw=='nhrh' and Forest86_Ready(u,'ACcs',40) then
 call IssueTargetOrder(u,"curse",victim)
 endif
 endif
 set ally=null
endfunction
