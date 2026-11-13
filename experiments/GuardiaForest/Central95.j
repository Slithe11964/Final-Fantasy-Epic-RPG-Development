// Central Islands: synchronized combat state; uses the existing 1 Hz heartbeat.
globals
 hashtable C95Data=null
 group C95Buffs=null
 real C95AlertUntil=0.
 boolean C95AlertActive=false
endglobals
function C95_Pool takes integer raw returns boolean
 return raw=='ntrd' or raw=='ntrg' or raw=='nahy' or raw=='nehy' or raw=='ntrs' or raw=='njgb' or raw=='njga' or raw=='njg1' or raw=='nlkl' or raw=='nlsn' or raw=='nltc' or raw=='nlds' or raw=='nlrv' or raw=='ndrv' or raw=='nsrv' or raw=='ntrv' or raw=='nsc2' or raw=='nsc3' or raw=='nscb' or raw=='nmsc' or raw=='nmtw' or raw=='nmcf' or raw=='nmbg'
endfunction
function C95_Active takes unit u,integer key returns boolean
 return C95Data!=null and Forest86Now<LoadReal(C95Data,GetHandleId(u),key)
endfunction
function C95_Buff takes unit u,integer key,real duration returns nothing
 call SaveReal(C95Data,GetHandleId(u),key,Forest86Now+duration)
 call GroupAddUnit(C95Buffs,u)
endfunction
function C95_Evasion takes unit u returns real
 local integer raw=GetUnitTypeId(u)
 if raw=='nahy' or raw=='nehy' or raw=='njg1' then
 return 40.
 endif
 if C95_Active(u,42) then
 return 80.
 endif
 return 0.
endfunction
function C95_Block takes unit u,boolean physical,boolean magical returns integer
 local integer value=0
 local integer raw=GetUnitTypeId(u)
 if not physical and not magical then
 return 0
 endif
 if raw=='ntrd' then
 set value=15
 elseif raw=='ntrg' or raw=='ntrs' then
 set value=10
 endif
 if C95_Active(u,15) then
 set value=value+10
 endif
 if physical and C95_Active(u,10) then
 set value=value+40
 endif
 return value
endfunction
function C95_Poison takes unit attacker,unit victim returns nothing
 local integer raw=GetUnitTypeId(attacker)
 local integer chance=25
 local real amount=10.+6.*I2R(GetUnitLevel(attacker))
 local integer id=GetHandleId(victim)
 if C95Data==null or Forest86Data==null then
 return
 endif
 if raw=='cWE5' and Forest86_Enemy(attacker,victim) then
 call M89_Dummy(attacker,victim,'cFS5',"slow")
 endif
 if raw!='nahy' and raw!='nehy' then
 return
 endif
 if raw=='nehy' then
 set chance=33
 set amount=100.+5.*I2R(GetUnitLevel(attacker))
 endif
 if not Forest86_Enemy(attacker,victim) or GetRandomInt(1,100)>chance then
 return
 endif
 if not HaveSavedReal(Forest86Data,id,11) or LoadReal(Forest86Data,id,12)<=Forest86Now or amount>=LoadReal(Forest86Data,id,11) then
 call SaveUnitHandle(Forest86Data,id,10,attacker)
 call SaveReal(Forest86Data,id,11,amount)
 call SaveReal(Forest86Data,id,12,Forest86Now+10.)
 call SaveReal(Forest86Data,id,13,Forest86Now+1.)
 call GroupAddUnit(Forest86Poisoned,victim)
 call M89_Dummy(attacker,victim,'cPO5',"curse")
 endif
endfunction
function C95_Bleed takes unit caster,unit victim returns nothing
 if Forest86_Enemy(caster,victim) then
 call C95_Buff(victim,30,5.)
 call SaveReal(C95Data,GetHandleId(victim),31,100.+7.*I2R(GetHeroLevel(victim)))
 call SaveUnitHandle(C95Data,GetHandleId(victim),32,caster)
 call M89_Dummy(caster,victim,'cBL5',"curse")
 endif
endfunction
function C95_DevourValid takes unit caster,unit victim returns boolean
 return M89_Injured(victim) and victim!=caster and IsUnitAlly(victim,GetOwningPlayer(caster)) and C95_Pool(GetUnitTypeId(victim)) and not IsUnitType(victim,UNIT_TYPE_HERO) and not IsUnitInGroup(victim,udg_SpecialUnits) and LoadInteger(Forest86Data,GetHandleId(caster),90)<2
endfunction
function C95_Food takes unit caster returns unit
 local group g=CreateGroup()
 local unit u
 local unit chosen=null
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),350.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if chosen==null and C95_DevourValid(caster,u) then
 set chosen=u
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 return chosen
endfunction
function C95_PairSecond takes nothing returns nothing
 local timer clock=GetExpiredTimer()
 local integer id=GetHandleId(clock)
 local unit caster=LoadUnitHandle(C95Data,id,1)
 local unit victim=LoadUnitHandle(C95Data,id,2)
 if not udg_InCinematicMode and Forest86_Alive(caster) and Forest86_Enemy(caster,victim) and IsUnitInRange(caster,victim,300.) then
 call SetUnitAnimation(caster,"attack")
 call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",GetUnitX(victim),GetUnitY(victim)))
 call M89_Damage(caster,victim,1000.,5)
 call M89_Dummy(caster,victim,'mST9',"thunderbolt")
 endif
 call FlushChildHashtable(C95Data,id)
 call DestroyTimer(clock)
 set caster=null
 set victim=null
 set clock=null
endfunction
function C95_Cleanup takes unit u returns nothing
 local integer id=GetHandleId(u)
 if HaveSavedHandle(C95Data,id,21) then
 call DestroyEffect(LoadEffectHandle(C95Data,id,21))
 endif
 if HaveSavedHandle(C95Data,id,61) then
 call DestroyEffect(LoadEffectHandle(C95Data,id,61))
 endif
 if LoadBoolean(C95Data,id,12) then
 call UnitRemoveAbility(u,'cD15')
 endif
 if HaveSavedReal(C95Data,id,40) then
 call ShowUnit(u,true)
 call PauseUnit(u,false)
 call SetUnitInvulnerable(u,LoadBoolean(C95Data,id,41))
 endif
 call GroupRemoveUnit(C95Buffs,u)
 call FlushChildHashtable(C95Data,id)
endfunction
function C95_TickUnit takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 local real ending=0.
 local unit source=null
 local group g=null
 local unit ally=null
 if not Forest86_Alive(u) then
 call C95_Cleanup(u)
 set u=null
 return
 endif
 if LoadReal(C95Data,id,30)>0. then
 if Forest86Now<=LoadReal(C95Data,id,30) then
 set source=LoadUnitHandle(C95Data,id,32)
 call B88_Damage(source,u,LoadReal(C95Data,id,31),true)
 else
 call RemoveSavedReal(C95Data,id,30)
 call RemoveSavedHandle(C95Data,id,32)
 endif
 endif
 if LoadBoolean(C95Data,id,12) and not C95_Active(u,11) then
 call UnitRemoveAbility(u,'cD15')
 call RemoveSavedBoolean(C95Data,id,12)
 call RemoveSavedInteger(C95Data,id,13)
 endif
 if HaveSavedReal(C95Data,id,40) and Forest86Now>=LoadReal(C95Data,id,40) then
 call ShowUnit(u,true)
 call PauseUnit(u,false)
 call SetUnitInvulnerable(u,LoadBoolean(C95Data,id,41))
 call SetWidgetLife(u,I2R(BlzGetUnitMaxHP(u)))
 call C95_Buff(u,42,3.)
 call M89_Dummy(u,u,'cEV5',"curse")
 call RemoveSavedReal(C95Data,id,40)
 call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl",GetUnitX(u),GetUnitY(u)))
 endif
 if HaveSavedReal(C95Data,id,20) then
 if Forest86Now<=LoadReal(C95Data,id,20) and GetUnitCurrentOrder(u)==OrderId("tranquility") then
 set g=CreateGroup()
 call GroupEnumUnitsInRange(g,GetUnitX(u),GetUnitY(u),600.,null)
 loop
 set ally=FirstOfGroup(g)
 exitwhen ally==null
 call GroupRemoveUnit(g,ally)
 if Forest86_Alive(ally) and IsUnitAlly(ally,GetOwningPlayer(u)) and not IsUnitType(ally,UNIT_TYPE_STRUCTURE) then
 call M89_Heal(u,ally,200.)
 endif
 endloop
 call DestroyGroup(g)
 else
 call RemoveSavedReal(C95Data,id,20)
 call DestroyEffect(LoadEffectHandle(C95Data,id,21))
 call RemoveSavedHandle(C95Data,id,21)
 endif
 endif
 if HaveSavedReal(C95Data,id,60) then
 if Forest86Now<=LoadReal(C95Data,id,60) then
 call M89_Area(u,GetUnitX(u),GetUnitY(u),250.,800.,5,false)
 else
 call RemoveSavedReal(C95Data,id,60)
 call DestroyEffect(LoadEffectHandle(C95Data,id,61))
 call RemoveSavedHandle(C95Data,id,61)
 call ResetUnitAnimation(u)
 endif
 endif
 // Stop visiting idle units after their last effect ends.
 if not HaveSavedReal(C95Data,id,20) and not HaveSavedReal(C95Data,id,30) and not HaveSavedReal(C95Data,id,40) and not HaveSavedReal(C95Data,id,60) and not C95_Active(u,10) and not C95_Active(u,11) and not C95_Active(u,15) and not C95_Active(u,42) and not C95_Active(u,50) then
 call C95_Cleanup(u)
 endif
 set source=null
 set ally=null
 set g=null
 set u=null
endfunction
function C95_Tick takes nothing returns nothing
 if udg_InCinematicMode then
 return
 endif
 call ForGroup(C95Buffs,function C95_TickUnit)
 if C95AlertActive and Forest86Now>=C95AlertUntil then
 set C95AlertActive=false
 call ExecuteFunc("C95_UpdateSpawnTimer")
 endif
endfunction
function C95_Shout takes unit caster,boolean war returns nothing
 local group g=CreateGroup()
 local unit u
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),600.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(caster)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
 if war then
 call C95_Buff(u,11,20.)
 call UnitAddAbility(u,'cD15')
 call SaveBoolean(C95Data,GetHandleId(u),12,true)
 if IsUnitType(u,UNIT_TYPE_RANGED_ATTACKER) then
 call SaveInteger(C95Data,GetHandleId(u),13,4)
 else
 call SaveInteger(C95Data,GetHandleId(u),13,5)
 endif
 call M89_Dummy(caster,u,'cWB5',"curse")
 else
 call C95_Buff(u,15,20.)
 call M89_Dummy(caster,u,'cGB5',"curse")
 endif
 endif
 endloop
 call DestroyGroup(g)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl",caster,"origin"))
 set u=null
 set g=null
endfunction
function C95_Spell takes unit caster,unit victim,integer raw returns nothing
 local integer id=GetHandleId(caster)
 local timer clock=null
 local group spawned=null
 local unit summoned=null
 local effect fx=null
 local integer i=0
 local real angle=0.
 if C95Data==null then
 return
 endif
 if raw=='cPU5' and Forest86_Enemy(caster,victim) then
 call SetUnitAnimation(caster,"attack")
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl",victim,"chest"))
 call M89_Damage(caster,victim,1400.,4)
 call M89_Dummy(caster,victim,'cIM5',"drunkenhaze")
 set clock=CreateTimer()
 call SaveUnitHandle(C95Data,GetHandleId(clock),1,caster)
 call SaveUnitHandle(C95Data,GetHandleId(clock),2,victim)
 call TimerStart(clock,2.,false,function C95_PairSecond)
 elseif raw=='cDV5' then
 if C95_DevourValid(caster,victim) then
 call M89_Absorb(caster,victim)
 set spawned=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(victim))
 if spawned!=null then
 call GroupRemoveUnit(spawned,victim)
 endif
 call GroupRemoveUnit(Forest86Actors,victim)
 call C95_Cleanup(victim)
 call FlushChildHashtable(Forest86Data,GetHandleId(victim))
 call RemoveUnit(victim)
 call UnitAddAbility(caster,'cEL5')
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+200.))
 call BlzEndUnitAbilityCooldown(caster,'cDV5')
 endif
 elseif raw=='cFK5' then
 call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl",GetUnitX(caster),GetUnitY(caster)))
 elseif raw=='cWV5' then
 set angle=Atan2(GetSpellTargetY()-GetUnitY(caster),GetSpellTargetX()-GetUnitX(caster))*bj_RADTODEG
 call Missile_Launch(caster,"Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveMissile.mdl","Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl",null,angle,80.,30.,1000.,0.,0.,200.,1200.,4,ATTACK_TYPE_NORMAL,true)
 elseif raw=='cSH5' then
 call C95_Shout(caster,false)
 elseif raw=='cGD5' then
 call C95_Buff(caster,10,10.)
 call M89_Dummy(caster,caster,'cSB5',"curse")
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl",caster,"origin"))
 elseif raw=='cSU5' then
 if GetUnitAbilityLevel(caster,'bBN5')>0 then
 loop
 exitwhen i>=2
 set summoned=CreateUnit(GetOwningPlayer(caster),'cWE5',GetUnitX(caster)+90.*Cos(I2R(i)*bj_PI),GetUnitY(caster)+90.*Sin(I2R(i)*bj_PI),GetUnitFacing(caster))
 call UnitApplyTimedLife(summoned,'BTLF',60.)
 call SetUnitAcquireRange(summoned,1000.)
 set i=i+1
 endloop
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+150.))
 call BlzEndUnitAbilityCooldown(caster,'cSU5')
 endif
 elseif raw=='cPN5' and Forest86_Enemy(caster,victim) then
 call B88_Damage(caster,victim,1200.,true)
 call C95_Buff(victim,50,10.)
 call M89_Dummy(caster,victim,'cPB5',"curse")
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\snapMissile\\snapMissile.mdl",victim,"chest"))
 elseif raw=='cBU5' then
 call C95_Buff(caster,40,5.)
 call SaveBoolean(C95Data,id,41,BlzIsUnitInvulnerable(caster))
 call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl",GetUnitX(caster),GetUnitY(caster)))
 call SetUnitInvulnerable(caster,true)
 call PauseUnit(caster,true)
 call ShowUnit(caster,false)
 elseif raw=='cWW5' then
 call C95_Buff(caster,60,5.)
 set fx=AddSpecialEffectTarget("Abilities\\Spells\\Other\\Tornado\\TornadoElemental.mdl",caster,"origin")
 call BlzSetSpecialEffectColor(fx,155,110,65)
 call SaveEffectHandle(C95Data,id,61,fx)
 call SetUnitAnimation(caster,"spin")
 elseif raw=='cRA5' then
 call C95_Buff(caster,20,10.)
 set fx=AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl",caster,"origin")
 call SaveEffectHandle(C95Data,id,21,fx)
 elseif raw=='cCH5' then
 call B88_Charge(caster,victim)
 elseif raw=='cWR5' then
 call C95_Shout(caster,true)
 endif
 set fx=null
 set summoned=null
 set spawned=null
 set clock=null
endfunction
function C95_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit food=null
 local unit ally=null
 if C95_Active(u,20) or C95_Active(u,60) then
 return
 endif
 if raw=='njgb' and Forest86_Ready(u,'cDV5',200) and LoadInteger(Forest86Data,GetHandleId(u),90)<2 then
 set food=C95_Food(u)
 if food!=null then
 call IssueTargetOrder(u,"devour",food)
 set food=null
 return
 endif
 endif
 if raw=='nmsc' and Forest86_Ready(u,'cRA5',200) then
 set ally=Forest86_Find(u,1)
 if ally!=null or GetWidgetLife(u)<I2R(BlzGetUnitMaxHP(u))*.8 then
 call IssueImmediateOrder(u,"tranquility")
 set ally=null
 return
 endif
 endif
 if victim==null then
 return
 endif
 if raw=='njgb' and Forest86_Ready(u,'cEL5',1100) then
 call IssueTargetOrder(u,"firebolt",victim)
 elseif raw=='njgb' and Forest86_Ready(u,'cPU5',150) and IsUnitInRange(u,victim,200.) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif raw=='nlkl' and Forest86_Ready(u,'cFK5',200) and IsUnitInRange(u,victim,600.) then
 call IssueImmediateOrder(u,"fanofknives")
 elseif raw=='nlsn' and Forest86_Ready(u,'cSK5',200) then
 call IssueImmediateOrder(u,"battleroar")
 elseif raw=='nltc' and Forest86_Ready(u,'cWV5',100) then
 call IssuePointOrder(u,"shockwave",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='nlds' and Forest86_Ready(u,'cRG5',0) then
 call IssueImmediateOrder(u,"berserk")
 elseif raw=='nlrv' and Forest86_Ready(u,'cSH5',0) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='nlrv' and Forest86_Ready(u,'cGD5',0) then
 call IssueImmediateOrder(u,"defend")
 elseif raw=='ndrv' and GetUnitAbilityLevel(u,'bBN5')>0 and Forest86_Ready(u,'cSU5',150) then
 call IssueImmediateOrder(u,"waterelemental")
 elseif raw=='ndrv' and GetUnitAbilityLevel(u,'bBN5')==0 and Forest86_Ready(u,'cBN5',100) then
 call IssueTargetOrder(u,"banish",u)
 elseif raw=='nsrv' and Forest86_Ready(u,'cNT5',300) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif raw=='ntrv' and Forest86_Ready(u,'cBI5',200) then
 call IssueTargetOrder(u,"curse",victim)
 elseif raw=='nsc2' and Forest86_Ready(u,'cPN5',200) then
 call IssueTargetOrder(u,"cripple",victim)
 elseif raw=='nsc3' and GetWidgetLife(u)<=I2R(BlzGetUnitMaxHP(u))*.5 and Forest86_Ready(u,'cBU5',200) then
 call IssueImmediateOrder(u,"burrow")
 elseif raw=='nscb' and Forest86_Ready(u,'cWW5',200) and IsUnitInRange(u,victim,300.) then
 call IssueImmediateOrder(u,"whirlwind")
 elseif raw=='nmtw' and Forest86_Ready(u,'cCH5',250) then
 call IssueTargetOrder(u,"charge",victim)
 elseif raw=='nmcf' and Forest86_Ready(u,'cWR5',0) then
 call IssueImmediateOrder(u,"howlofterror")
 endif
 set food=null
 set ally=null
endfunction
