globals
 hashtable I2Data=null
 hashtable I2Stacks=null
 group I2Active=null
 integer I2Serial=0
 real I2AlertUntil=0.
 boolean I2AlertActive=false
 boolean I2Proccing=false
 unit I2WaveCaster=null
 real I2WaveX=0.
 real I2WaveY=0.
endglobals
function I2_Pool takes integer raw returns boolean
 return raw=='n02B' or raw=='n025' or raw=='n0MQ' or raw=='n026' or raw=='n02C' or raw=='n029' or raw=='n02D' or raw=='n027' or raw=='n028' or raw=='m02A'
endfunction
function I2_Active takes unit u,integer key returns boolean
 return I2Data!=null and Forest86Now<LoadReal(I2Data,GetHandleId(u),key)
endfunction
function I2_Buff takes unit u,integer key,real duration returns nothing
 call SaveReal(I2Data,GetHandleId(u),key,Forest86Now+duration)
 call GroupAddUnit(I2Active,u)
endfunction
function I2_BeamEnd takes unit u returns nothing
 local integer id=GetHandleId(u)
 if HaveSavedHandle(I2Data,id,23) then
 call DestroyLightning(LoadLightningHandle(I2Data,id,23))
 call RemoveSavedHandle(I2Data,id,23)
 endif
 call RemoveSavedHandle(I2Data,id,20)
 call RemoveSavedReal(I2Data,id,21)
endfunction
function I2_WoundEnd takes unit u returns nothing
 local integer id=GetHandleId(u)
 if LoadBoolean(I2Data,id,43) then
 if GetUnitTypeId(u)!=0 then
 call BlzSetUnitRealField(u,UNIT_RF_HIT_POINTS_REGENERATION_RATE,BlzGetUnitRealField(u,UNIT_RF_HIT_POINTS_REGENERATION_RATE)+LoadReal(I2Data,id,41))
 endif
 call RemoveSavedBoolean(I2Data,id,43)
 endif
 call RemoveSavedReal(I2Data,id,40)
 if GetUnitTypeId(u)!=0 then
 call UnitRemoveAbility(u,'bFB2')
 endif
endfunction
function I2_ClearSlow takes unit u returns nothing
 local integer id=GetHandleId(u)
 local integer record=LoadInteger(I2Data,id,70)
 local integer nextRecord=0
 loop
 exitwhen record==0
 set nextRecord=LoadInteger(I2Stacks,record,0)
 call FlushChildHashtable(I2Stacks,record)
 set record=nextRecord
 endloop
 call RemoveSavedInteger(I2Data,id,70)
 call RemoveSavedInteger(I2Data,id,71)
 call RemoveSavedInteger(I2Data,id,72)
 if GetUnitTypeId(u)!=0 then
 call UnitRemoveAbility(u,'jIS2')
 call UnitRemoveAbility(u,'bIB2')
 endif
endfunction
function I2_Cleanup takes unit u returns nothing
 if I2Data==null then
 return
 endif
 call I2_BeamEnd(u)
 call I2_WoundEnd(u)
 call I2_ClearSlow(u)
 if GetUnitTypeId(u)!=0 then
 call UnitRemoveAbility(u,'jAS2')
 call UnitRemoveAbility(u,'jRA2')
 call UnitRemoveAbility(u,'jSA2')
 endif
 call GroupRemoveUnit(I2Active,u)
 call FlushChildHashtable(I2Data,GetHandleId(u))
endfunction
function I2_Track takes unit u returns nothing
 if I2Data!=null and GetUnitTypeId(u)=='n02D' and not IsUnitIllusion(u) then
 call IssueImmediateOrder(u,"innerfireon")
 endif
endfunction
function I2_FoodValid takes unit caster,unit victim returns boolean
 return victim!=null and victim!=caster and I2_Pool(GetUnitTypeId(victim)) and M89_Injured(victim) and IsUnitAlly(victim,GetOwningPlayer(caster)) and not IsUnitType(victim,UNIT_TYPE_HERO) and not IsUnitInGroup(victim,udg_SpecialUnits) and not IsUnitIllusion(victim) and LoadInteger(Forest86Data,GetHandleId(caster),90)<2
endfunction
function I2_Food takes unit caster returns unit
 local group g=CreateGroup()
 local unit u=null
 local unit chosen=null
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),350.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if I2_FoodValid(caster,u) then
 set chosen=u
 exitwhen true
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 return chosen
endfunction
function I2_Duel takes unit caster,unit victim returns nothing
 local integer id=GetHandleId(victim)
 if not Forest86_Enemy(caster,victim) or HaveSavedHandle(I2Data,GetHandleId(caster),30) then
 return
 endif
 call SaveUnitHandle(I2Data,GetHandleId(caster),30,victim)
 call SaveUnitHandle(Forest86Data,id,20,caster)
 call SaveReal(Forest86Data,id,21,Forest86Now+1000000.)
 call GroupAddUnit(Forest86Taunted,victim)
 call GroupAddUnit(I2Active,caster)
 call UnitAddAbility(caster,'jAS2')
 call M89_Dummy(caster,victim,'jDT2',"curse")
 call Forest86_TauntOrder(victim,caster)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl",caster,"origin"))
endfunction
function I2_Dueling takes unit u returns boolean
 local unit victim=null
 local boolean active=false
 if I2Data==null then
 return false
 endif
 set victim=LoadUnitHandle(I2Data,GetHandleId(u),30)
 set active=Forest86_Alive(u) and Forest86_Alive(victim) and LoadUnitHandle(Forest86Data,GetHandleId(victim),20)==u and IsUnitInGroup(victim,Forest86Taunted)
 set victim=null
 return active
endfunction
function I2_DuelTick takes unit u returns nothing
 if not I2_Dueling(u) then
 call RemoveSavedHandle(I2Data,GetHandleId(u),30)
 call UnitRemoveAbility(u,'jAS2')
 endif
endfunction
function I2_AddSlow takes unit caster,unit victim returns nothing
 local integer id=GetHandleId(victim)
 local integer tail=LoadInteger(I2Data,id,71)
 local integer count=LoadInteger(I2Data,id,72)+1
 set I2Serial=I2Serial+1
 if tail==0 then
 call SaveInteger(I2Data,id,70,I2Serial)
 else
 call SaveInteger(I2Stacks,tail,0,I2Serial)
 endif
 call SaveInteger(I2Data,id,71,I2Serial)
 call SaveInteger(I2Data,id,72,count)
 call SaveReal(I2Stacks,I2Serial,1,Forest86Now+30.)
 call UnitAddAbility(victim,'jIS2')
 call SetUnitAbilityLevel(victim,'jIS2',IMinBJ(64,count))
 call M89_Dummy(caster,victim,'jIM2',"curse")
 call GroupAddUnit(I2Active,victim)
endfunction
function I2_ExpireSlow takes unit u returns nothing
 local integer id=GetHandleId(u)
 local integer record=LoadInteger(I2Data,id,70)
 local integer nextRecord=0
 local integer count=LoadInteger(I2Data,id,72)
 loop
 exitwhen record==0 or Forest86Now<LoadReal(I2Stacks,record,1)
 set nextRecord=LoadInteger(I2Stacks,record,0)
 call FlushChildHashtable(I2Stacks,record)
 set record=nextRecord
 set count=count-1
 endloop
 call SaveInteger(I2Data,id,70,record)
 call SaveInteger(I2Data,id,72,count)
 if count<=0 then
 call I2_ClearSlow(u)
 else
 call SetUnitAbilityLevel(u,'jIS2',IMinBJ(64,count))
 endif
endfunction
function I2_BeamTick takes unit u returns nothing
 local integer id=GetHandleId(u)
 local unit victim=LoadUnitHandle(I2Data,id,20)
 if not Forest86_Enemy(u,victim) or not IsUnitInRange(u,victim,1000.) or GetUnitCurrentOrder(u)!=OrderId("drain") or Forest86Now>LoadReal(I2Data,id,21) then
 call I2_BeamEnd(u)
 elseif Forest86Now>=LoadReal(I2Data,id,22) then
 call I2_AddSlow(u,victim)
 call SaveReal(I2Data,id,22,Forest86Now+1.)
 call MoveLightningEx(LoadLightningHandle(I2Data,id,23),true,GetUnitX(u),GetUnitY(u),80.,GetUnitX(victim),GetUnitY(victim),60.)
 if Forest86Now>=LoadReal(I2Data,id,21) then
 call I2_BeamEnd(u)
 endif
 endif
 set victim=null
endfunction
function I2_Slam takes unit caster,real x,real y,real radius returns nothing
 local group g=CreateGroup()
 local unit u=null
 local effect fx=AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl",x,y)
 call BlzSetSpecialEffectScale(fx,radius/150.)
 call DestroyEffect(fx)
 call GroupEnumUnitsInRange(g,x,y,radius,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Enemy(caster,u) then
 call M89_Damage(caster,u,2000.,2)
 call M89_Dummy(caster,u,'jST2',"thunderbolt")
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 set fx=null
endfunction
function I2_Roar takes unit caster returns nothing
 local group g=CreateGroup()
 local unit u=null
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),800.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(caster)) then
 call UnitAddAbility(u,'jRA2')
 call I2_Buff(u,60,20.)
 call M89_Dummy(caster,u,'jRB2',"curse")
 endif
 endloop
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl",caster,"origin"))
 call DestroyGroup(g)
 set u=null
 set g=null
endfunction
function I2_Wave takes nothing returns nothing
 local unit caster=I2WaveCaster
 local real angle=Atan2(I2WaveY-GetUnitY(caster),I2WaveX-GetUnitX(caster))*bj_RADTODEG
 local integer d=Missile_CreateWithEffects(caster,"Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl","",angle,0.)
 if d!=0 then
 set udg_MissileSpeed[d]=30.
 set udg_MissileRange[d]=1000.
 set udg_MissileAoE[d]=150.
 set udg_MissileTravelDamage[d]=1.
 set udg_MissileHitOnce[d]=true
 set udg_MissileImpactDamage[d]=0.
 set MissileTag[d]=202
 endif
 set caster=null
endfunction
function I2_WaveHit takes nothing returns nothing
 local integer index=udg_ArgIndex
 local unit victim=udg_ArgUnit
 local unit caster=udg_MissileCaster[index]
 if Forest86_Alive(victim) and not IsUnitInGroup(victim,udg_MissileHitGroup[index]) then
 call GroupAddUnit(udg_MissileHitGroup[index],victim)
 if IsUnitAlly(victim,GetOwningPlayer(caster)) then
 call M89_Heal(caster,victim,2500.)
 elseif Forest86_Enemy(caster,victim) then
 call M89_Dummy(caster,victim,'jST2',"thunderbolt")
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl",victim,"chest"))
 endif
 endif
 set caster=null
 set victim=null
endfunction
function I2_Spell takes unit caster,unit victim,integer raw returns nothing
 local integer id=GetHandleId(caster)
 local group wave=null
 if raw=='jDV2' then
 if I2_FoodValid(caster,victim) then
 call M89_Absorb(caster,victim)
 set wave=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(victim))
 if wave!=null then
 call GroupRemoveUnit(wave,victim)
 endif
 call D2_Cleanup(victim)
 call I2_Cleanup(victim)
 call GroupRemoveUnit(Forest86Actors,victim)
 call FlushChildHashtable(Forest86Data,GetHandleId(victim))
 call RemoveUnit(victim)
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+400.))
 call BlzEndUnitAbilityCooldown(caster,'jDV2')
 endif
 elseif raw=='jCL2' then
 set I2WaveCaster=caster
 set I2WaveX=GetSpellTargetX()
 set I2WaveY=GetSpellTargetY()
 call ExecuteFunc("I2_Wave")
 set I2WaveCaster=null
 elseif raw=='jRG2' and Forest86_Alive(victim) and IsUnitAlly(victim,GetOwningPlayer(caster)) then
 call SaveReal(I2Data,GetHandleId(victim),10,Forest86Now+30.)
 call SaveReal(I2Data,GetHandleId(victim),11,I2R(BlzGetUnitMaxHP(caster))/30.)
 call SaveReal(I2Data,GetHandleId(victim),13,Forest86Now+1.)
 call SaveUnitHandle(I2Data,GetHandleId(victim),12,caster)
 call GroupAddUnit(I2Active,victim)
 call M89_Dummy(caster,victim,'jRM2',"curse")
 elseif raw=='jBD2' then
 call I2_Duel(caster,victim)
 elseif raw=='jIB2' and Forest86_Enemy(caster,victim) then
 call I2_BeamEnd(caster)
 call SaveUnitHandle(I2Data,id,20,victim)
 call SaveReal(I2Data,id,21,Forest86Now+10.)
 call SaveReal(I2Data,id,22,Forest86Now+1.)
 call SaveLightningHandle(I2Data,id,23,AddLightningEx("CHIM",true,GetUnitX(caster),GetUnitY(caster),80.,GetUnitX(victim),GetUnitY(victim),60.))
 call SetLightningColor(LoadLightningHandle(I2Data,id,23),.25,.65,1.,1.)
 call GroupAddUnit(I2Active,caster)
 elseif raw=='jFO2' then
 call M89_Dummy(caster,victim,'A10R',"curse")
 elseif raw=='jPA2' then
 call M89_Dummy(caster,victim,'A0ZW',"curse")
 elseif raw=='jGS2' then
 call SaveReal(I2Data,id,50,Forest86Now+2.)
 call SaveReal(I2Data,id,51,GetUnitX(caster))
 call SaveReal(I2Data,id,52,GetUnitY(caster))
 call GroupAddUnit(I2Active,caster)
 call I2_Slam(caster,GetUnitX(caster),GetUnitY(caster),300.)
 elseif raw=='jAR2' then
 call I2_Roar(caster)
 elseif raw=='jFB2' and Forest86_Enemy(caster,victim) then
 call I2_WoundEnd(victim)
 call SaveReal(I2Data,GetHandleId(victim),41,BlzGetUnitRealField(victim,UNIT_RF_HIT_POINTS_REGENERATION_RATE)*.5)
 call SaveBoolean(I2Data,GetHandleId(victim),43,true)
 call BlzSetUnitRealField(victim,UNIT_RF_HIT_POINTS_REGENERATION_RATE,BlzGetUnitRealField(victim,UNIT_RF_HIT_POINTS_REGENERATION_RATE)-LoadReal(I2Data,GetHandleId(victim),41))
 call I2_Buff(victim,40,15.)
 call M89_Dummy(caster,victim,'jFM2',"curse")
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Devour\\DevourEffectArt.mdl",victim,"chest"))
 call B88_Damage(caster,victim,3000.,true)
 elseif raw=='jSU2' then
 call B88_Charge(caster,victim)
 endif
 set wave=null
endfunction
function I2_SurgeImpact takes unit caster,unit victim returns nothing
 call M89_Damage(caster,victim,500.,2)
 call I2_Buff(caster,80,3.)
 call UnitAddAbility(caster,'jSA2')
 call IssueTargetOrder(caster,"attack",victim)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl",victim,"chest"))
endfunction
function I2_OnHit takes unit source,unit victim returns nothing
 if I2Proccing or GetUnitTypeId(source)!='n028' or not BlzGetEventIsAttack() or not Forest86_Enemy(source,victim) then
 return
 endif
 set I2Proccing=true
 if I2_Active(source,80) then
 call M89_Damage(source,victim,500.,2)
 endif
 if GetRandomInt(1,100)<=25 then
 call M89_Area(source,GetUnitX(victim),GetUnitY(victim),300.,700.,2,false)
 call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl",GetUnitX(victim),GetUnitY(victim)))
 endif
 set I2Proccing=false
endfunction
function I2_TickUnit takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 local boolean watching=false
 if not Forest86_Alive(u) then
 call I2_Cleanup(u)
 set u=null
 return
 endif
 if HaveSavedReal(I2Data,id,10) then
 if Forest86Now<=LoadReal(I2Data,id,10) and Forest86Now>=LoadReal(I2Data,id,13) then
 call SaveReal(I2Data,id,13,Forest86Now+1.)
 call M89_Heal(LoadUnitHandle(I2Data,id,12),u,LoadReal(I2Data,id,11))
 endif
 if Forest86Now>=LoadReal(I2Data,id,10) then
 call RemoveSavedReal(I2Data,id,10)
 call RemoveSavedHandle(I2Data,id,12)
 else
 set watching=true
 endif
 endif
 if HaveSavedHandle(I2Data,id,20) then
 call I2_BeamTick(u)
 set watching=true
 endif
 if HaveSavedHandle(I2Data,id,30) then
 call I2_DuelTick(u)
 set watching=true
 endif
 if HaveSavedReal(I2Data,id,40) then
 if not I2_Active(u,40) or GetUnitAbilityLevel(u,'bFB2')==0 then
 call I2_WoundEnd(u)
 else
 set watching=true
 endif
 endif
 if HaveSavedReal(I2Data,id,50) then
 if Forest86Now>=LoadReal(I2Data,id,50) then
 call RemoveSavedReal(I2Data,id,50)
 call I2_Slam(u,LoadReal(I2Data,id,51),LoadReal(I2Data,id,52),500.)
 else
 set watching=true
 endif
 endif
 if HaveSavedReal(I2Data,id,60) then
 if I2_Active(u,60) then
 set watching=true
 else
 call UnitRemoveAbility(u,'jRA2')
 call RemoveSavedReal(I2Data,id,60)
 endif
 endif
 if LoadInteger(I2Data,id,72)>0 then
 call I2_ExpireSlow(u)
 set watching=true
 endif
 if HaveSavedReal(I2Data,id,80) then
 if I2_Active(u,80) then
 set watching=true
 else
 call UnitRemoveAbility(u,'jSA2')
 call RemoveSavedReal(I2Data,id,80)
 endif
 endif
 if not watching then
 call GroupRemoveUnit(I2Active,u)
 endif
 set u=null
endfunction
function I2_Tick takes nothing returns nothing
 if not udg_InCinematicMode then
 call ForGroup(I2Active,function I2_TickUnit)
 endif
 if I2AlertActive and Forest86Now>=I2AlertUntil then
 set I2AlertActive=false
 call ExecuteFunc("I2_UpdateSpawnTimer")
 endif
endfunction
function I2_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit ally=null
 if IsUnitIllusion(u) or HaveSavedHandle(I2Data,GetHandleId(u),20) or I2_Active(u,80) then
 return
 endif
 if raw=='n02B' and Forest86_Ready(u,'jDV2',400) then
 set ally=I2_Food(u)
 if ally!=null then
 call IssueTargetOrder(u,"devour",ally)
 set ally=null
 return
 endif
 endif
 if raw=='n025' then
 if Forest86_Ready(u,'jRG2',300) then
 set ally=Forest86_Find(u,1)
 if ally==null and M89_Injured(u) then
 set ally=u
 endif
 if ally!=null then
 call IssueTargetOrder(u,"rejuvination",ally)
 set ally=null
 return
 endif
 endif
 if Forest86_Ready(u,'jCL2',100) then
 if victim==null then
 set victim=Forest86_Find(u,1)
 endif
 if victim!=null then
 call IssuePointOrder(u,"shockwave",GetUnitX(victim),GetUnitY(victim))
 endif
 endif
 elseif raw=='n02D' then
 if Forest86_Ready(u,'jSH2',200) then
 set ally=B88_Ally(u,'B05O')
 if ally!=null then
 call IssueTargetOrder(u,"innerfire",ally)
 set ally=null
 return
 endif
 endif
 if victim!=null then
 if GetUnitAbilityLevel(victim,'B00P')==0 and Forest86_Ready(u,'jBL2',0) then
 call IssueTargetOrder(u,"curse",victim)
 elseif GetUnitAbilityLevel(victim,'B06I')==0 and Forest86_Ready(u,'jFO2',120) then
 call IssueTargetOrder(u,"drunkenhaze",victim)
 elseif GetUnitAbilityLevel(victim,'B06H')==0 and Forest86_Ready(u,'jPA2',120) then
 call IssueTargetOrder(u,"cripple",victim)
 endif
 endif
 elseif victim!=null then
 if raw=='n0MQ' and not I2_Dueling(u) and Forest86_Ready(u,'jBD2',100) then
 call IssueTargetOrder(u,"roar",victim)
 elseif raw=='n026' and Forest86_Ready(u,'jRO2',75) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif raw=='n02C' then
 if Forest86_Ready(u,'jBF2',280) then
 call IssuePointOrder(u,"breathoffrost",GetUnitX(victim),GetUnitY(victim))
 elseif Forest86_Ready(u,'jIB2',200) then
 call IssueTargetOrder(u,"drain",victim)
 endif
 elseif raw=='n027' then
 if IsUnitInRange(u,victim,150.) and Forest86_Ready(u,'jGS2',200) then
 call IssueImmediateOrder(u,"stomp")
 elseif Forest86_Ready(u,'jAR2',100) then
 call IssueImmediateOrder(u,"battleroar")
 endif
 elseif raw=='n028' then
 if IsUnitInRange(u,victim,200.) and Forest86_Ready(u,'jFB2',150) then
 call IssueTargetOrder(u,"faeriefire",victim)
 elseif Forest86_Ready(u,'jSU2',100) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 endif
 endif
 endif
 set ally=null
endfunction
