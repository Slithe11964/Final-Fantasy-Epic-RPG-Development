// Shared, deterministic monster behavior. One 1-second heartbeat; no local client reads.
globals
 hashtable Forest86Data=null
 group Forest86Actors=null
 group Forest86Poisoned=null
 group Forest86Taunted=null
 real Forest86Now=0.
 real Forest86AlertUntil=0.
 boolean Forest86AlertActive=false
 boolean Forest86OrderGuard=false
endglobals
function Forest86_Alive takes unit u returns boolean
 return u!=null and GetUnitTypeId(u)!=0 and GetWidgetLife(u)>.405
endfunction
function Forest86_Pool takes integer raw returns boolean
 return raw=='nftr' or raw=='nmrl' or raw=='ngnb' or raw=='nspg' or raw=='nwlt' or raw=='nftt' or raw=='nfsp' or raw=='nftb' or raw=='nfsh' or raw=='nspb' or raw=='ndtr' or raw=='ndtp'
endfunction
function Forest86_Actor takes integer raw returns boolean
 return raw=='nfsh' or raw=='nfsp' or raw=='nftb' or raw=='ngnb' or raw=='ndtr' or raw=='ndtp' or raw=='nbld' or raw=='nftt' or raw=='n0BS'
endfunction
function Forest86_SpawnFactor takes integer zone returns integer
 if zone==1 and Forest86AlertUntil>Forest86Now then
 return 2
 endif
 return 1
endfunction
function Forest86_Float takes unit u,string message returns nothing
 local texttag tag=CreateTextTag()
 call SetTextTagText(tag,message,.025)
 call SetTextTagPosUnit(tag,u,100.)
 call SetTextTagColor(tag,255,210,40,255)
 call SetTextTagVelocity(tag,0.,.025)
 call SetTextTagPermanent(tag,false)
 call SetTextTagLifespan(tag,1.7)
 call SetTextTagFadepoint(tag,1.)
 set tag=null
endfunction
function Forest86_Track takes unit u returns nothing
 if Forest86_Actor(GetUnitTypeId(u)) and GetOwningPlayer(u)==Player(11) then
 call GroupAddUnit(Forest86Actors,u)
 if GetUnitTypeId(u)=='nfsp' then
 call IssueImmediateOrder(u,"healon")
 endif
 endif
endfunction
function Forest86_Entered takes nothing returns nothing
 local unit u=GetTriggerUnit()
 if Forest86_Actor(GetUnitTypeId(u)) and GetOwningPlayer(u)==Player(11) then
 call FlushChildHashtable(Forest86Data,GetHandleId(u))
 call Forest86_Track(u)
 endif
 set u=null
endfunction
function Forest86_Death takes nothing returns nothing
 local unit u=GetTriggerUnit()
 if not IsUnitInGroup(u,Forest86Actors) and not IsUnitInGroup(u,Forest86Poisoned) and not IsUnitInGroup(u,Forest86Taunted) then
 set u=null
 return
 endif
 if GetUnitTypeId(u)=='ndtr' and LoadReal(Forest86Data,GetHandleId(u),4)>0. then
 call PauseUnit(u,false)
 endif
 call GroupRemoveUnit(Forest86Actors,u)
 call GroupRemoveUnit(Forest86Poisoned,u)
 call GroupRemoveUnit(Forest86Taunted,u)
 call FlushChildHashtable(Forest86Data,GetHandleId(u))
 set u=null
endfunction
function Forest86_Initial takes nothing returns nothing
 call Forest86_Track(GetEnumUnit())
endfunction
function Forest86_Enemy takes unit caster,unit target returns boolean
 return Forest86_Alive(target) and IsUnitEnemy(target,GetOwningPlayer(caster)) and not IsUnitType(target,UNIT_TYPE_STRUCTURE) and not BlzIsUnitInvulnerable(target)
endfunction
function Forest86_Find takes unit caster,integer mode returns unit
 local group g=CreateGroup()
 local unit u
 local unit chosen=null
 local real score=99999999.
 local real candidate
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),600.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if mode==0 and Forest86_Enemy(caster,u) then
 set candidate=(GetUnitX(u)-GetUnitX(caster))*(GetUnitX(u)-GetUnitX(caster))+(GetUnitY(u)-GetUnitY(caster))*(GetUnitY(u)-GetUnitY(caster))
 if candidate<score then
 set chosen=u
 set score=candidate
 endif
 elseif mode==1 and u!=caster and Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(caster)) and GetWidgetLife(u)<I2R(BlzGetUnitMaxHP(u))-.5 and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
 set candidate=GetWidgetLife(u)/I2R(BlzGetUnitMaxHP(u))
 if candidate<score then
 set chosen=u
 set score=candidate
 endif
 elseif mode==2 and u!=caster and Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(caster)) and Forest86_Pool(GetUnitTypeId(u)) and not IsUnitType(u,UNIT_TYPE_HERO) and not IsUnitInGroup(u,udg_SpecialUnits) then
 set candidate=(GetUnitX(u)-GetUnitX(caster))*(GetUnitX(u)-GetUnitX(caster))+(GetUnitY(u)-GetUnitY(caster))*(GetUnitY(u)-GetUnitY(caster))
 if candidate<=350.*350. and candidate<score then
 set chosen=u
 set score=candidate
 endif
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 return chosen
endfunction
function Forest86_Ready takes unit u,integer raw,integer cost returns boolean
 return GetUnitAbilityLevel(u,raw)>0 and GetUnitState(u,UNIT_STATE_MANA)>=I2R(cost) and BlzGetUnitAbilityCooldownRemaining(u,raw)<=0.
endfunction
function Forest86_InForest takes unit u returns boolean
 local integer i=1
 local rect area
 if GetUnitUserData(u)==1 then
 return true
 endif
 loop
 exitwhen i>LoadInteger(udg_SpawnDataHash,2,1)
 set area=LoadRectHandle(udg_SpawnRectHash,1,i)
 if area!=null and RectContainsCoords(area,GetUnitX(u),GetUnitY(u)) then
 set area=null
 return true
 endif
 set i=i+1
 endloop
 set area=null
 return false
endfunction
function Forest86_Alert takes unit u returns nothing
 local integer id=GetHandleId(u)
 if Forest86Data==null or not Forest86_Alive(u) or GetUnitTypeId(u)!='ndtr' or GetOwningPlayer(u)!=Player(11) or not Forest86_InForest(u) or LoadBoolean(Forest86Data,id,3) then
 return
 endif
 call SaveBoolean(Forest86Data,id,3,true)
 call SaveReal(Forest86Data,id,4,Forest86Now+10.)
 call IssueImmediateOrder(u,"stop")
 call SetUnitAnimation(u,"spell")
 call PauseUnit(u,true)
 call Forest86_Float(u,"Calling Reinforcements")
endfunction
function Forest86_Attacked takes nothing returns nothing
 if IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO) then
 call Forest86_Alert(GetAttacker())
 endif
endfunction
function Forest86_PoisonDamage takes integer level,integer coefficient returns real
 return 5.+I2R(coefficient*level)
endfunction
function Forest86_OnAttack takes unit attacker,unit victim returns nothing
 local integer raw=GetUnitTypeId(attacker)
 local integer chance=0
 local integer coefficient=0
 local integer id=GetHandleId(victim)
 if Forest86Data==null or not IsUnitType(victim,UNIT_TYPE_HERO) or not IsUnitEnemy(victim,GetOwningPlayer(attacker)) then
 return
 endif
 if raw=='nspg' then
 set chance=33
 set coefficient=25
 elseif raw=='nbrg' then
 set chance=15
 set coefficient=35
 endif
 if chance>0 and GetRandomInt(1,100)<=chance then
 // Refresh the same monster poison on this hero rather than multiplying stacks.
 if not HaveSavedReal(Forest86Data,id,11) or LoadReal(Forest86Data,id,12)<=Forest86Now or Forest86_PoisonDamage(GetHeroLevel(victim),coefficient)>=LoadReal(Forest86Data,id,11) then
 call SaveUnitHandle(Forest86Data,id,10,attacker)
 call SaveReal(Forest86Data,id,11,Forest86_PoisonDamage(GetHeroLevel(victim),coefficient))
 call SaveReal(Forest86Data,id,12,Forest86Now+5.)
 call SaveReal(Forest86Data,id,13,Forest86Now+1.)
 call GroupAddUnit(Forest86Poisoned,victim)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\AcidBomb\\BottleImpact.mdl",victim,"chest"))
 endif
 endif
endfunction
function Forest86_PoisonTick takes nothing returns nothing
 local unit victim=GetEnumUnit()
 local integer id=GetHandleId(victim)
 local unit attacker=LoadUnitHandle(Forest86Data,id,10)
 if not Forest86_Alive(victim) or attacker==null or GetUnitTypeId(attacker)==0 or Forest86Now>LoadReal(Forest86Data,id,12) then
 call GroupRemoveUnit(Forest86Poisoned,victim)
 call RemoveSavedHandle(Forest86Data,id,10)
 call RemoveSavedReal(Forest86Data,id,11)
 call RemoveSavedReal(Forest86Data,id,12)
 call RemoveSavedReal(Forest86Data,id,13)
 elseif Forest86Now>=LoadReal(Forest86Data,id,13) then
 call SaveReal(Forest86Data,id,13,Forest86Now+1.)
 set udg_IsPhysicalAttack=false
 set udg_DamageElement=0
 set udg_DmgFlagNoCrit=-1.
 set udg_DmgFlagUnavoidable=-1
 call UnitDamageTarget(attacker,victim,LoadReal(Forest86Data,id,11),false,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
 endif
 set victim=null
 set attacker=null
endfunction
function Forest86_TauntOrder takes unit victim,unit caster returns nothing
 if Forest86OrderGuard then
 return
 endif
 set Forest86OrderGuard=true
 call IssueTargetOrder(victim,"attack",caster)
 set Forest86OrderGuard=false
endfunction
function Forest86_Order takes nothing returns nothing
 local unit victim=GetTriggerUnit()
 local integer id=GetHandleId(victim)
 local unit caster=LoadUnitHandle(Forest86Data,id,20)
 if not Forest86OrderGuard and Forest86_Alive(caster) and Forest86Now<LoadReal(Forest86Data,id,21) then
 if GetIssuedOrderId()!=OrderId("attack") or GetOrderTargetUnit()!=caster then
 call Forest86_TauntOrder(victim,caster)
 endif
 endif
 set victim=null
 set caster=null
endfunction
function Forest86_TauntTick takes nothing returns nothing
 local unit victim=GetEnumUnit()
 local integer id=GetHandleId(victim)
 local unit caster=LoadUnitHandle(Forest86Data,id,20)
 if not Forest86_Alive(victim) or not Forest86_Alive(caster) or Forest86Now>=LoadReal(Forest86Data,id,21) then
 call GroupRemoveUnit(Forest86Taunted,victim)
 call RemoveSavedHandle(Forest86Data,id,20)
 call RemoveSavedReal(Forest86Data,id,21)
 else
 call Forest86_TauntOrder(victim,caster)
 endif
 set victim=null
 set caster=null
endfunction
function Forest86_Taunt takes unit caster returns nothing
 local group g=CreateGroup()
 local unit victim
 local integer id
 call SaveReal(Forest86Data,GetHandleId(caster),22,Forest86Now+5.)
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),450.,null)
 loop
 set victim=FirstOfGroup(g)
 exitwhen victim==null
 call GroupRemoveUnit(g,victim)
 if Forest86_Enemy(caster,victim) then
 set id=GetHandleId(victim)
 call SaveUnitHandle(Forest86Data,id,20,caster)
 call SaveReal(Forest86Data,id,21,Forest86Now+5.)
 call GroupAddUnit(Forest86Taunted,victim)
 call Forest86_TauntOrder(victim,caster)
 endif
 endloop
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl",caster,"origin"))
 call DestroyGroup(g)
 set g=null
 set victim=null
endfunction
function Forest86_Evasion takes unit u returns real
 if Forest86Data!=null and GetUnitTypeId(u)=='nbld' and Forest86Now<LoadReal(Forest86Data,GetHandleId(u),30) then
 return 40.
 endif
 return 0.
endfunction
function Forest86_Defense takes unit u returns real
 if Forest86Data!=null and GetUnitTypeId(u)=='ngnb' and Forest86Now<LoadReal(Forest86Data,GetHandleId(u),22) then
 return .8
 endif
 return 1.
endfunction
function Forest86_Stun takes unit caster,unit victim returns nothing
 local unit dummy=CreateUnit(GetOwningPlayer(caster),'h02S',GetUnitX(victim),GetUnitY(victim),0.)
 call ShowUnit(dummy,false)
 call UnitAddAbility(dummy,'fS86')
 call IssueTargetOrder(dummy,"thunderbolt",victim)
 call UnitApplyTimedLife(dummy,'BTLF',2.)
 set dummy=null
endfunction
function Forest86_DevourValid takes unit caster,unit victim returns boolean
 return Forest86_Alive(victim) and victim!=caster and Forest86_Pool(GetUnitTypeId(victim)) and not IsUnitType(victim,UNIT_TYPE_HERO) and not IsUnitInGroup(victim,udg_SpecialUnits)
endfunction
function Forest86_Spell takes nothing returns nothing
 local unit caster=GetTriggerUnit()
 local unit victim=GetSpellTargetUnit()
 local integer raw=GetSpellAbilityId()
 local group spawned=null
 local integer id=GetHandleId(caster)
 if raw=='fD86' then
 if Forest86_DevourValid(caster,victim) then
 set spawned=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(victim))
 if spawned!=null then
 call GroupRemoveUnit(spawned,victim)
 endif
 call GroupRemoveUnit(Forest86Actors,victim)
 call FlushChildHashtable(Forest86Data,GetHandleId(victim))
 call RemoveUnit(victim)
 call UnitAddAbility(caster,'fB86')
 call SaveBoolean(Forest86Data,id,1,true)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Devour\\DevourEffectArt.mdl",caster,"chest"))
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+200.))
 call BlzEndUnitAbilityCooldown(caster,'fD86')
 endif
 elseif raw=='fT86' then
 call Forest86_Taunt(caster)
 elseif raw=='fE86' then
 call SaveReal(Forest86Data,id,30,Forest86Now+10.)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl",caster,"origin"))
 elseif raw=='fN86' and Forest86_Alive(victim) then
 call Forest86_Stun(caster,victim)
 endif
 set spawned=null
 set caster=null
 set victim=null
endfunction
function Forest86_AI takes nothing returns nothing
 local unit u=GetEnumUnit()
 local unit victim=null
 local integer raw=GetUnitTypeId(u)
 local integer id=GetHandleId(u)
 local real ending=LoadReal(Forest86Data,id,4)
 local integer remaining
 if not Forest86_Alive(u) then
 call GroupRemoveUnit(Forest86Actors,u)
 call FlushChildHashtable(Forest86Data,id)
 set u=null
 return
 endif
 if ending>0. then
 set remaining=R2I(ending-Forest86Now)
 if remaining<=0 then
 call RemoveSavedReal(Forest86Data,id,4)
 call PauseUnit(u,false)
 call ResetUnitAnimation(u)
 set Forest86AlertUntil=Forest86Now+60.
 set Forest86AlertActive=true
 call Forest86_Float(u,"Reinforcements alerted!")
 call ExecuteFunc("Forest86_UpdateSpawnTimer")
 elseif remaining<=5 then
 call Forest86_Float(u,I2S(remaining))
 endif
 endif
 if GetOwningPlayer(u)!=Player(11) or IsUnitPaused(u) or IsUnitHidden(u) or udg_InCinematicMode then
 set u=null
 return
 endif
 if raw=='nfsp' and Forest86_Ready(u,'fH86',10) then
 set victim=Forest86_Find(u,1)
 if victim!=null then
 call IssueTargetOrder(u,"heal",victim)
 endif
 elseif raw=='nfsh' and not LoadBoolean(Forest86Data,id,1) and Forest86_Ready(u,'fD86',200) then
 set victim=Forest86_Find(u,2)
 if victim!=null then
 call IssueTargetOrder(u,"devour",victim)
 endif
 else
 set victim=Forest86_Find(u,0)
 if victim!=null then
 if raw=='nfsh' and Forest86_Ready(u,'fB86',100) then
 call IssuePointOrder(u,"shockwave",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='nftb' and Forest86_Ready(u,'fR86',0) then
 call IssueImmediateOrder(u,"berserk")
 elseif raw=='ngnb' and Forest86_Ready(u,'fT86',25) and (GetUnitX(victim)-GetUnitX(u))*(GetUnitX(victim)-GetUnitX(u))+(GetUnitY(victim)-GetUnitY(u))*(GetUnitY(victim)-GetUnitY(u))<=450.*450. then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='nbld' and Forest86_Ready(u,'fE86',0) then
 call IssueImmediateOrder(u,"howlofterror")
 elseif raw=='nftt' and Forest86_Ready(u,'fN86',0) then
 call IssueTargetOrder(u,"ensnare",victim)
 elseif raw=='ndtp' and GetUnitAbilityLevel(u,'ACcs')>0 and BlzGetUnitAbilityCooldownRemaining(u,'ACcs')<=0. then
 call IssueTargetOrder(u,"curse",victim)
 elseif raw=='n0BS' and Forest86_Ready(u,'fI86',200) then
 call IssueTargetOrder(u,"firebolt",victim)
 endif
 endif
 endif
 set victim=null
 set u=null
endfunction
function Forest86_Tick takes nothing returns nothing
 set Forest86Now=Forest86Now+1.
 call ForGroup(Forest86Actors,function Forest86_AI)
 call ForGroup(Forest86Poisoned,function Forest86_PoisonTick)
 call ForGroup(Forest86Taunted,function Forest86_TauntTick)
 if Forest86AlertActive and Forest86Now>=Forest86AlertUntil then
 set Forest86AlertActive=false
 call ExecuteFunc("Forest86_UpdateSpawnTimer")
 endif
endfunction
function Forest86_Init takes nothing returns nothing
 local trigger t=CreateTrigger()
 local trigger spell=CreateTrigger()
 local trigger orders=CreateTrigger()
 local trigger attacks=CreateTrigger()
 local trigger deaths=CreateTrigger()
 local region world=CreateRegion()
 local rect bounds=GetWorldBounds()
 local group g=CreateGroup()
 local integer i=0
 set Forest86Data=InitHashtable()
 set Forest86Actors=CreateGroup()
 set Forest86Poisoned=CreateGroup()
 set Forest86Taunted=CreateGroup()
 call RegionAddRect(world,bounds)
 call TriggerRegisterEnterRegion(t,world,null)
 call TriggerAddAction(t,function Forest86_Entered)
 loop
 exitwhen i>=bj_MAX_PLAYER_SLOTS
 call TriggerRegisterPlayerUnitEvent(spell,Player(i),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)
 call TriggerRegisterPlayerUnitEvent(attacks,Player(i),EVENT_PLAYER_UNIT_ATTACKED,null)
 call TriggerRegisterPlayerUnitEvent(deaths,Player(i),EVENT_PLAYER_UNIT_DEATH,null)
 call TriggerRegisterPlayerUnitEvent(orders,Player(i),EVENT_PLAYER_UNIT_ISSUED_ORDER,null)
 call TriggerRegisterPlayerUnitEvent(orders,Player(i),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER,null)
 call TriggerRegisterPlayerUnitEvent(orders,Player(i),EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER,null)
 set i=i+1
 endloop
 call TriggerAddAction(spell,function Forest86_Spell)
 call TriggerAddAction(attacks,function Forest86_Attacked)
 call TriggerAddAction(deaths,function Forest86_Death)
 call TriggerAddAction(orders,function Forest86_Order)
 call GroupEnumUnitsInRect(g,bounds,null)
 call ForGroup(g,function Forest86_Initial)
 call DestroyGroup(g)
 call RemoveRect(bounds)
 call TimerStart(CreateTimer(),1.,true,function Forest86_Tick)
 set t=null
 set spell=null
 set orders=null
 set attacks=null
 set deaths=null
 set world=null
 set bounds=null
 set g=null
endfunction
