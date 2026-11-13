globals
 group M89Buffs=null
 real M89AlertUntil=0.
 boolean M89AlertActive=false
endglobals
function M89_Pool takes integer raw returns boolean
 return raw=='nban' or raw=='nbrg' or raw=='nrog' or raw=='nass' or raw=='nenf' or raw=='nbld' or raw=='nhfp' or raw=='nhdc' or raw=='nhhr' or raw=='nkob' or raw=='nkog' or raw=='nkot' or raw=='nkol' or raw=='nwiz' or raw=='nwzr' or raw=='nwzg' or raw=='nwzd' or raw=='nogr' or raw=='nomg' or raw=='nogm' or raw=='nogl' or raw=='n0MO' or raw=='ngns' or raw=='ngno' or raw=='ngnw' or raw=='ngnv'
endfunction
function M89_Injured takes unit u returns boolean
 return Forest86_Alive(u) and GetWidgetLife(u)<I2R(BlzGetUnitMaxHP(u))-.01
endfunction
function M89_Absorb takes unit caster,unit victim returns nothing
 call BlzSetUnitBaseDamage(caster,BlzGetUnitBaseDamage(caster,0)+BlzGetUnitBaseDamage(victim,0),0)
 call BlzSetUnitBaseDamage(caster,BlzGetUnitBaseDamage(caster,1)+BlzGetUnitBaseDamage(victim,1),1)
 call BlzSetUnitMaxHP(caster,BlzGetUnitMaxHP(caster)+BlzGetUnitMaxHP(victim))
 call BlzSetUnitMaxMana(caster,BlzGetUnitMaxMana(caster)+BlzGetUnitMaxMana(victim))
 call BlzSetUnitArmor(caster,BlzGetUnitArmor(caster)+BlzGetUnitArmor(victim))
 call SetWidgetLife(caster,RMinBJ(I2R(BlzGetUnitMaxHP(caster)),GetWidgetLife(caster)+GetWidgetLife(victim)))
 call SaveInteger(Forest86Data,GetHandleId(caster),90,LoadInteger(Forest86Data,GetHandleId(caster),90)+1)
 if LoadInteger(Forest86Data,GetHandleId(caster),90)>=2 then
 call UnitRemoveAbility(caster,GetSpellAbilityId())
 endif
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Devour\\DevourEffectArt.mdl",caster,"chest"))
endfunction
function M89_Damage takes unit caster,unit victim,real amount,integer element returns nothing
 if Forest86_Alive(caster) and Forest86_Alive(victim) and amount>0. then
 set udg_IsPhysicalAttack=false
 set udg_DamageElement=element
 set udg_DmgFlagNoCrit=-1.
 call UnitDamageTarget(caster,victim,amount,false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
 endif
endfunction
function M89_Heal takes unit caster,unit victim,real amount returns nothing
 if Forest86_Alive(victim) then
 call SetWidgetLife(victim,RMinBJ(I2R(BlzGetUnitMaxHP(victim)),GetWidgetLife(victim)+amount))
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",victim,"origin"))
 endif
endfunction
function M89_Buff takes unit u,integer key,real duration returns nothing
 call SaveReal(Forest86Data,GetHandleId(u),key,Forest86Now+duration)
 call GroupAddUnit(M89Buffs,u)
endfunction
function M89_Dummy takes unit caster,unit victim,integer raw,string order returns nothing
 local unit dummy=CreateUnit(GetOwningPlayer(caster),'h02S',GetUnitX(victim),GetUnitY(victim),0.)
 call ShowUnit(dummy,false)
 call UnitAddAbility(dummy,raw)
 call IssueTargetOrder(dummy,order,victim)
 call UnitApplyTimedLife(dummy,'BTLF',3.)
 set dummy=null
endfunction
function M89_Projectile takes unit caster,unit victim,integer raw,real damage,integer element,boolean slow returns nothing
 local unit dummy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(caster),GetUnitY(caster),GetUnitFacing(caster))
 local integer id=GetHandleId(dummy)
 call ShowUnit(dummy,false)
 call SaveUnitHandle(udg_ProxyDamageHash,id,0,caster)
 call SaveReal(udg_ProxyDamageHash,id,1,damage)
 call SaveInteger(udg_ProxyDamageHash,id,2,3)
 call SaveInteger(udg_ProxyDamageHash,id,100,element)
 call SaveBoolean(udg_ProxyDamageHash,id,101,slow)
 call SaveBoolean(udg_ProxyDamageHash,id,5,true)
 call UnitAddAbility(dummy,raw)
 call IssueTargetOrder(dummy,"thunderbolt",victim)
 call UnitApplyTimedLife(dummy,'BTLF',12.)
 set dummy=null
endfunction
function M89_Area takes unit caster,real x,real y,real radius,real amount,integer element,boolean stun returns nothing
 local group g=CreateGroup()
 local unit u
 call GroupEnumUnitsInRange(g,x,y,radius,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Enemy(caster,u) then
 call M89_Damage(caster,u,amount,element)
 if stun then
 call M89_Dummy(caster,u,'mST9',"thunderbolt")
 endif
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
endfunction
function M89_Ally takes unit caster,integer mode returns unit
 local group g=CreateGroup()
 local unit u
 local unit chosen=null
 local real score=2.
 local real ratio
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),800.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(caster)) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
 set ratio=GetWidgetLife(u)/I2R(BlzGetUnitMaxHP(u))
 if mode==0 and ratio<.99999 and ratio<score then
 set chosen=u
 set score=ratio
 elseif mode==1 and u!=caster and M89_Pool(GetUnitTypeId(u)) and M89_Injured(u) and not IsUnitType(u,UNIT_TYPE_HERO) and not IsUnitInGroup(u,udg_SpecialUnits) then
 set chosen=u
 exitwhen true
 elseif mode==2 and GetUnitAbilityLevel(u,'B01W')==0 then
 set chosen=u
 exitwhen true
 elseif mode==3 and GetUnitAbilityLevel(u,'B00F')==0 then
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
function M89_TickUnit takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 local integer key=80
 local boolean active=false
 if Forest86_Alive(u) then
 if B88_Active(u,85) and Forest86Now>=LoadReal(Forest86Data,id,86) then
 call M89_Area(u,LoadReal(Forest86Data,id,87),LoadReal(Forest86Data,id,88),300.,LoadReal(Forest86Data,id,89),6,false)
 call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Tornado\\TornadoElementalSmall.mdl",LoadReal(Forest86Data,id,87),LoadReal(Forest86Data,id,88)))
 call SaveReal(Forest86Data,id,86,Forest86Now+3.)
 endif
 loop
 exitwhen key>85
 if B88_Active(u,key) then
 set active=true
 endif
 set key=key+1
 endloop
 endif
 if not B88_Active(u,84) or not Forest86_Alive(u) then
 call UnitRemoveAbility(u,'mA29')
 endif
 if not B88_Active(u,83) or not Forest86_Alive(u) then
 call UnitRemoveAbility(u,'mD39')
 if GetUnitTypeId(u)=='nogl' then
 call UnitRemoveAbility(u,'mA49')
 endif
 endif
 if not active then
 call GroupRemoveUnit(M89Buffs,u)
 endif
 set u=null
endfunction
function M89_Spell takes unit caster,unit victim,integer raw returns nothing
 local integer id=GetHandleId(caster)
 local group g=null
 local unit u=null
 local unit hound=null
 local real damage
 if raw=='mDA9' then
 set g=CreateGroup()
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),600.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Enemy(caster,u) then
 call M89_Damage(caster,u,GetWidgetLife(u)*.1,0)
 endif
 endloop
 call DestroyGroup(g)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathAndDecay\\DeathAndDecayTarget.mdl",caster,"origin"))
 elseif raw=='mSU9' then
 call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl",GetUnitX(caster)+100.,GetUnitY(caster)))
 set hound=CreateUnit(GetOwningPlayer(caster),'mH89',GetUnitX(caster)+100.,GetUnitY(caster),GetUnitFacing(caster))
 call UnitApplyTimedLife(hound,'BTLF',45.)
 call IssuePointOrder(hound,"attack",GetUnitX(caster)+200.,GetUnitY(caster))
 elseif raw=='mRO9' or raw=='mAC9' then
 call UnitAddAbility(caster,'mD39')
 call M89_Buff(caster,83,20.)
 if raw=='mAC9' then
 call UnitAddAbility(caster,'mA49')
 call M89_Heal(caster,caster,I2R(BlzGetUnitMaxHP(caster))*.5)
 endif
 elseif raw=='mDS9' then
 call M89_Buff(caster,80,10.)
 elseif raw=='mTE9' or raw=='mTV9' then
 call Forest86_Taunt(caster)
 if raw=='mTE9' then
 call M89_Buff(caster,81,10.)
 else
 call M89_Buff(caster,82,15.)
 endif
 elseif raw=='mBI9' and Forest86_Enemy(caster,victim) then
 call M89_Damage(caster,victim,600.,0)
 call M89_Heal(caster,caster,250.)
 elseif raw=='mSH9' then
 set g=CreateGroup()
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),800.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(caster)) then
 call UnitAddAbility(u,'mA29')
 call M89_Buff(u,84,15.)
 endif
 endloop
 call DestroyGroup(g)
 elseif raw=='mSL9' then
 call M89_Area(caster,GetUnitX(caster),GetUnitY(caster),300.,600.,5,true)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",caster,"origin"))
 elseif raw=='mRK9' and Forest86_Enemy(caster,victim) then
 call M89_Projectile(caster,victim,'mPE9',400.,5,true)
 elseif raw=='mFB9' and Forest86_Enemy(caster,victim) then
 call M89_Projectile(caster,victim,'mPF9',800.,1,false)
 elseif raw=='mDV9' then
 if victim!=caster and M89_Injured(victim) and M89_Pool(GetUnitTypeId(victim)) and not IsUnitType(victim,UNIT_TYPE_HERO) and not IsUnitInGroup(victim,udg_SpecialUnits) and IsUnitAlly(victim,GetOwningPlayer(caster)) and LoadInteger(Forest86Data,id,90)<2 then
 call M89_Absorb(caster,victim)
 set g=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(victim))
 if g!=null then
 call GroupRemoveUnit(g,victim)
 endif
 call GroupRemoveUnit(Forest86Actors,victim)
 call RemoveUnit(victim)
 call UnitAddAbility(caster,'mAW9')
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+300.))
 call BlzEndUnitAbilityCooldown(caster,'mDV9')
 endif
 elseif raw=='mAW9' then
 set damage=500.
 if GetUnitTypeId(caster)=='nwzd' then
 set damage=1000.+I2R(BlzGetUnitBaseDamage(caster,0))+.001*I2R(BlzGetUnitMaxHP(caster))
 endif
 call SaveReal(Forest86Data,id,87,GetSpellTargetX())
 call SaveReal(Forest86Data,id,88,GetSpellTargetY())
 call SaveReal(Forest86Data,id,89,damage)
 call SaveReal(Forest86Data,id,86,Forest86Now+3.)
 call M89_Buff(caster,85,9.01)
 endif
 set caster=null
 set victim=null
 set g=null
 set u=null
 set hound=null
endfunction
function M89_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit ally=null
 if raw=='nkog' and Forest86_Ready(u,'mCU9',300) then
 set ally=M89_Ally(u,0)
 if ally!=null then
 call IssueTargetOrder(u,"holybolt",ally)
 return
 endif
 elseif raw=='nwzd' and LoadInteger(Forest86Data,GetHandleId(u),90)<2 and Forest86_Ready(u,'mDV9',300) then
 set ally=M89_Ally(u,1)
 if ally!=null then
 call IssueTargetOrder(u,"devour",ally)
 return
 endif
 elseif raw=='nomg' then
 if Forest86_Ready(u,'mBR9',100) and LoadBoolean(Forest86Data,GetHandleId(u),91) then
 set ally=M89_Ally(u,2)
 if ally!=null then
 call IssueTargetOrder(u,"innerfire",ally)
 return
 endif
 endif
 if Forest86_Ready(u,'A059',100) then
 set ally=M89_Ally(u,3)
 if ally!=null then
 call IssueTargetOrder(u,"bloodlust",ally)
 return
 endif
 endif
 endif
 set ally=null
 if victim==null then
 return
 endif
 if raw=='nwiz' and Forest86_Ready(u,'mDA9',100) then
 call IssueImmediateOrder(u,"howlofterror")
 elseif raw=='nhfp' and Forest86_Ready(u,'mSU9',200) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='n0MO' and Forest86_Ready(u,'mRO9',125) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='nban' and Forest86_Ready(u,'mDS9',0) then
 call IssueImmediateOrder(u,"defend")
 elseif raw=='nbld' and Forest86_Ready(u,'fE86',200) then
 call IssueImmediateOrder(u,"howlofterror")
 elseif raw=='nenf' and Forest86_Ready(u,'mTE9',0) and IsUnitInRange(u,victim,450.) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='ngnv' and Forest86_Ready(u,'mTV9',125) and IsUnitInRange(u,victim,450.) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='ngno' and Forest86_Ready(u,'mBI9',0) and IsUnitInRange(u,victim,180.) then
 call IssueTargetOrder(u,"cripple",victim)
 elseif raw=='nhdc' and Forest86_Ready(u,'mMI9',100) then
 call IssueImmediateOrder(u,"mirrorimage")
 elseif raw=='nhhr' and Forest86_Ready(u,'mCS9',100) then
 call IssuePointOrder(u,"carrionswarm",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='nkot' and Forest86_Ready(u,'mSH9',250) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='nogl' and Forest86_Ready(u,'mAC9',150) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='nogm' and Forest86_Ready(u,'mSL9',125) and IsUnitInRange(u,victim,300.) then
 call IssueImmediateOrder(u,"stomp")
 elseif raw=='nogr' and Forest86_Ready(u,'mRK9',75) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif (raw=='nwzd' or raw=='nwzg') and Forest86_Ready(u,'mAW9',200) then
 call IssuePointOrder(u,"flamestrike",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='nwzd' and Forest86_Ready(u,'mL79',120) then
 call IssueTargetOrder(u,"chainlightning",victim)
 elseif raw=='nwzd' and Forest86_Ready(u,'mFL9',100) then
 call IssueTargetOrder(u,"forkedlightning",victim)
 elseif raw=='nwzg' and Forest86_Ready(u,'mL69',120) then
 call IssueTargetOrder(u,"chainlightning",victim)
 elseif raw=='nwzg' and Forest86_Ready(u,'mLS9',100) and GetUnitAbilityLevel(u,'Blsh')==0 then
 call IssueTargetOrder(u,"lightningshield",u)
 elseif raw=='nwzr' and Forest86_Ready(u,'mFB9',200) then
 call IssueTargetOrder(u,"firebolt",victim)
 endif
endfunction
