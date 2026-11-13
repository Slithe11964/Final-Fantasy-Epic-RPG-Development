globals
 hashtable N98Data=null
 group N98Buffs=null
 group N98Pulls=null
 timer N98PullTimer=null
 real N98AlertUntil=0.
 boolean N98AlertActive=false
 boolean N98Proccing=false
 unit N98WaveCaster=null
 real N98WaveX=0.
 real N98WaveY=0.
endglobals
function N98_Pool takes integer raw returns boolean
 return raw=='nnsw' or raw=='nnrg' or raw=='nrel' or raw=='nsel' or raw=='nhyc' or raw=='nmpe' or raw=='nnmg' or raw=='nsnp' or raw=='n01O' or raw=='n01Q' or raw=='nmyr' or raw=='nwgs' or raw=='nsgn' or raw=='nsgh' or raw=='nsgb'
endfunction
function N98_Active takes unit u,integer key returns boolean
 return N98Data!=null and Forest86Now<LoadReal(N98Data,GetHandleId(u),key)
endfunction
function N98_Buff takes unit u,integer key,real duration returns nothing
 call SaveReal(N98Data,GetHandleId(u),key,Forest86Now+duration)
 call GroupAddUnit(N98Buffs,u)
endfunction
function N98_Evasion takes unit u returns real
 local integer raw=GetUnitTypeId(u)
 local real value=0.
 if raw=='nnrg' or raw=='nnmg' then
 set value=60.
 elseif raw=='nmpe' then
 set value=50.
 elseif raw=='nsnp' then
 set value=40.
 endif
 if N98_Active(u,60) then
 set value=value-30.
 endif
 return value
endfunction
function N98_Block takes unit u,boolean physical,boolean magical returns integer
 if GetUnitTypeId(u)=='nhyc' and (physical or magical) then
 if N98_Active(u,10) then
 return 60
 endif
 return 10
 endif
 return 0
endfunction
function N98_Track takes unit u returns nothing
 local effect fx=null
 if N98Data!=null and GetUnitTypeId(u)=='nnsw' and not IsUnitIllusion(u) and not HaveSavedHandle(N98Data,GetHandleId(u),20) then
 set fx=AddSpecialEffectTarget("Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl",u,"origin")
 call BlzSetSpecialEffectColor(fx,85,0,135)
 call SaveEffectHandle(N98Data,GetHandleId(u),20,fx)
 endif
 set fx=null
endfunction
function N98_ImageDeath takes unit u returns nothing
 local integer id=GetHandleId(u)
 local unit parent=LoadUnitHandle(N98Data,id,30)
 local integer count=0
 if parent!=null then
 call RemoveSavedHandle(N98Data,id,30)
 if Forest86_Alive(parent) then
 set count=LoadInteger(N98Data,GetHandleId(parent),40)+1
 call SaveInteger(N98Data,GetHandleId(parent),40,count)
 call UnitAddAbility(parent,'nIH8')
 call SetUnitAbilityLevel(parent,'nIH8',IMinBJ(32,count))
 call BlzSetUnitMaxHP(parent,BlzGetUnitMaxHP(parent)+1500)
 call SetWidgetLife(parent,RMinBJ(I2R(BlzGetUnitMaxHP(parent)),GetWidgetLife(parent)+1500.))
 call BlzSetUnitBaseDamage(parent,BlzGetUnitBaseDamage(parent,0)+120,0)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl",parent,"origin"))
 endif
 endif
 set parent=null
endfunction
function N98_Summoned takes nothing returns nothing
 local unit parent=GetSummoningUnit()
 local unit child=GetSummonedUnit()
 if GetUnitTypeId(parent)=='nwgs' and IsUnitIllusion(child) then
 call SaveUnitHandle(N98Data,GetHandleId(child),30,parent)
 call GroupAddUnit(N98Buffs,child)
 endif
 set parent=null
 set child=null
endfunction
function N98_BindImages takes nothing returns nothing
 local timer clock=GetExpiredTimer()
 local integer id=GetHandleId(clock)
 local unit parent=LoadUnitHandle(N98Data,id,0)
 local group g=CreateGroup()
 local unit child=null
 if Forest86_Alive(parent) then
 call GroupEnumUnitsInRange(g,GetUnitX(parent),GetUnitY(parent),300.,null)
 loop
 set child=FirstOfGroup(g)
 exitwhen child==null
 call GroupRemoveUnit(g,child)
 if GetUnitTypeId(child)=='nwgs' and IsUnitIllusion(child) and GetOwningPlayer(child)==GetOwningPlayer(parent) and not HaveSavedHandle(N98Data,GetHandleId(child),30) then
 call SaveUnitHandle(N98Data,GetHandleId(child),30,parent)
 call GroupAddUnit(N98Buffs,child)
 endif
 endloop
 endif
 call DestroyGroup(g)
 call FlushChildHashtable(N98Data,id)
 call DestroyTimer(clock)
 set child=null
 set parent=null
 set g=null
 set clock=null
endfunction
function N98_Cleanup takes unit u returns nothing
 local integer id=GetHandleId(u)
 call N98_ImageDeath(u)
 if HaveSavedHandle(N98Data,id,20) then
 call DestroyEffect(LoadEffectHandle(N98Data,id,20))
 endif
 call GroupRemoveUnit(N98Buffs,u)
 call GroupRemoveUnit(N98Pulls,u)
 call FlushChildHashtable(N98Data,id)
endfunction
function N98_TickUnit takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 if not Forest86_Alive(u) then
 call N98_Cleanup(u)
 elseif HaveSavedReal(N98Data,id,1) then
 if Forest86Now<=LoadReal(N98Data,id,1) then
 call M89_Heal(LoadUnitHandle(N98Data,id,3),u,LoadReal(N98Data,id,2))
 else
 call RemoveSavedReal(N98Data,id,1)
 call RemoveSavedHandle(N98Data,id,3)
 endif
 endif
 if not HaveSavedReal(N98Data,id,1) and not N98_Active(u,10) and not N98_Active(u,60) and not HaveSavedHandle(N98Data,id,30) then
 call GroupRemoveUnit(N98Buffs,u)
 endif
 set u=null
endfunction
function N98_Tick takes nothing returns nothing
 if udg_InCinematicMode then
 return
 endif
 call ForGroup(N98Buffs,function N98_TickUnit)
 if N98AlertActive and Forest86Now>=N98AlertUntil then
 set N98AlertActive=false
 call ExecuteFunc("N98_UpdateSpawnTimer")
 endif
endfunction
function N98_PullStep takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 local integer left=LoadInteger(N98Data,id,73)
 if not Forest86_Alive(u) or left<=0 or udg_InCinematicMode then
 call GroupRemoveUnit(N98Pulls,u)
 call RemoveSavedInteger(N98Data,id,73)
 else
 call SetUnitPosition(u,GetUnitX(u)+(LoadReal(N98Data,id,70)-GetUnitX(u))/I2R(left),GetUnitY(u)+(LoadReal(N98Data,id,71)-GetUnitY(u))/I2R(left))
 call SaveInteger(N98Data,id,73,left-1)
 endif
 set u=null
endfunction
function N98_PullTick takes nothing returns nothing
 call ForGroup(N98Pulls,function N98_PullStep)
 if FirstOfGroup(N98Pulls)==null then
 call PauseTimer(N98PullTimer)
 endif
endfunction
function N98_Vortex takes unit caster,real x,real y returns nothing
 local group g=CreateGroup()
 local unit u=null
 local effect fx=AddSpecialEffect("Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl",x,y)
 call BlzSetSpecialEffectColor(fx,40,0,70)
 call DestroyEffect(fx)
 if FirstOfGroup(N98Pulls)==null then
 call TimerStart(N98PullTimer,.1,true,function N98_PullTick)
 endif
 call GroupEnumUnitsInRange(g,x,y,250.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Enemy(caster,u) and not BlzIsUnitInvulnerable(u) and not IsUnitType(u,UNIT_TYPE_STRUCTURE) then
 call SaveReal(N98Data,GetHandleId(u),70,x)
 call SaveReal(N98Data,GetHandleId(u),71,y)
 call SaveInteger(N98Data,GetHandleId(u),73,10)
 call GroupAddUnit(N98Pulls,u)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl",u,"origin"))
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 set fx=null
endfunction
function N98_Food takes unit caster returns unit
 local group g=CreateGroup()
 local unit u=null
 local unit chosen=null
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),350.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if chosen==null and u!=caster and N98_Pool(GetUnitTypeId(u)) and M89_Injured(u) and IsUnitAlly(u,GetOwningPlayer(caster)) and not IsUnitType(u,UNIT_TYPE_HERO) and not IsUnitInGroup(u,udg_SpecialUnits) then
 set chosen=u
 endif
 endloop
 call DestroyGroup(g)
 set u=null
 set g=null
 return chosen
endfunction
function N98_OnHit takes unit source,unit victim returns nothing
 local integer raw=GetUnitTypeId(source)
 local integer id=GetHandleId(victim)
 local real damage=0.
 local integer element=0
 local integer chance=0
 if N98Data==null or N98Proccing or not BlzGetEventIsAttack() or not Forest86_Enemy(source,victim) then
 return
 endif
 if raw=='nsnp' and IsUnitType(victim,UNIT_TYPE_HERO) and GetRandomInt(1,100)<=40 then
 set damage=250.+8.*I2R(GetHeroLevel(victim))
 if not HaveSavedReal(Forest86Data,id,11) or Forest86Now>=LoadReal(Forest86Data,id,12) or damage>=LoadReal(Forest86Data,id,11) then
 call SaveUnitHandle(Forest86Data,id,10,source)
 call SaveReal(Forest86Data,id,11,damage)
 call SaveReal(Forest86Data,id,12,Forest86Now+10.)
 call SaveReal(Forest86Data,id,13,Forest86Now+1.)
 call GroupAddUnit(Forest86Poisoned,victim)
 call M89_Dummy(source,victim,'xP95',"curse")
 endif
 elseif raw=='nrel' then
 call N98_Buff(victim,60,5.)
 call M89_Dummy(source,victim,'nSL8',"slow")
 endif
 if raw=='nsgn' then
 set chance=33
 set damage=500.
 set element=4
 elseif raw=='nsgh' then
 set chance=40
 set damage=750.
 set element=3
 elseif raw=='nsgb' then
 set chance=50
 set damage=100.
 set element=7
 endif
 if chance>0 and GetRandomInt(1,100)<=chance then
 set N98Proccing=true
 call M89_Area(source,GetUnitX(victim),GetUnitY(victim),300.,damage,element,false)
 call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl",GetUnitX(victim),GetUnitY(victim)))
 set N98Proccing=false
 endif
endfunction
function N98_Spell takes unit caster,unit victim,integer raw returns nothing
 local integer id=GetHandleId(caster)
 local unit dummy=null
 local group wave=null
 local timer clock=null
 if raw=='nDV8' then
 if victim!=caster and M89_Injured(victim) and N98_Pool(GetUnitTypeId(victim)) and IsUnitAlly(victim,GetOwningPlayer(caster)) and not IsUnitType(victim,UNIT_TYPE_HERO) and not IsUnitInGroup(victim,udg_SpecialUnits) and LoadInteger(Forest86Data,id,90)<2 then
 call M89_Absorb(caster,victim)
 set wave=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(victim))
 if wave!=null then
 call GroupRemoveUnit(wave,victim)
 endif
 call GroupRemoveUnit(Forest86Actors,victim)
 call N98_Cleanup(victim)
 call FlushChildHashtable(Forest86Data,GetHandleId(victim))
 call RemoveUnit(victim)
 call UnitAddAbility(caster,'nMA8')
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+250.))
 call BlzEndUnitAbilityCooldown(caster,'nDV8')
 endif
 elseif raw=='nMA8' then
 set dummy=CreateUnit(GetOwningPlayer(caster),'h01B',GetSpellTargetX(),GetSpellTargetY(),0.)
 call SetUnitVertexColor(dummy,255,255,255,0)
 call SaveUnitHandle(udg_ProxyDamageHash,GetHandleId(dummy),0,caster)
 call SaveInteger(udg_ProxyDamageHash,GetHandleId(dummy),2,3)
 call UnitAddAbility(dummy,'nMD8')
 call IssuePointOrder(dummy,"deathanddecay",GetSpellTargetX(),GetSpellTargetY())
 call UnitApplyTimedLife(dummy,'BTLF',20.)
 elseif raw=='nWV8' then
 set N98WaveCaster=caster
 set N98WaveX=GetSpellTargetX()
 set N98WaveY=GetSpellTargetY()
 call ExecuteFunc("N98_Wave")
 set N98WaveCaster=null
 elseif raw=='nVO8' then
 call N98_Vortex(caster,GetSpellTargetX(),GetSpellTargetY())
 elseif raw=='nRG8' and Forest86_Alive(victim) then
 call N98_Buff(victim,1,60.)
 call SaveReal(N98Data,GetHandleId(victim),2,I2R(BlzGetUnitMaxHP(caster))/60.)
 call SaveUnitHandle(N98Data,GetHandleId(victim),3,caster)
 call M89_Dummy(caster,victim,'nRB8',"curse")
 elseif raw=='nTA8' then
 call Forest86_Taunt(caster)
 call N98_Buff(caster,10,10.)
 call M89_Dummy(caster,caster,'nTB8',"curse")
 elseif raw=='nMI8' then
 set clock=CreateTimer()
 call SaveUnitHandle(N98Data,GetHandleId(clock),0,caster)
 call TimerStart(clock,0.,false,function N98_BindImages)
 endif
 set dummy=null
 set wave=null
 set clock=null
endfunction
function N98_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit ally=null
 if raw=='nnsw' then
 if LoadInteger(Forest86Data,GetHandleId(u),90)<2 and Forest86_Ready(u,'nDV8',250) then
 set ally=N98_Food(u)
 if ally!=null then
 call IssueTargetOrder(u,"devour",ally)
 set ally=null
 return
 endif
 endif
 if Forest86_Ready(u,'nRG8',300) then
 set ally=Forest86_Find(u,1)
 if ally==null and GetWidgetLife(u)<I2R(BlzGetUnitMaxHP(u))*.8 then
 set ally=u
 endif
 if ally!=null and not N98_Active(ally,1) then
 call IssueTargetOrder(u,"rejuvination",ally)
 set ally=null
 return
 endif
 endif
 if Forest86_Ready(u,'nFA8',80) then
 set ally=B88_Ally(u,'bFA8')
 if ally==null and GetUnitAbilityLevel(u,'bFA8')==0 then
 set ally=u
 endif
 if ally!=null then
 call IssueTargetOrder(u,"frostarmor",ally)
 set ally=null
 return
 endif
 endif
 endif
 if victim==null then
 return
 endif
 if raw=='nnsw' and Forest86_Ready(u,'nMA8',1800) then
 call IssuePointOrder(u,"deathanddecay",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='nnsw' and Forest86_Ready(u,'nVO8',400) then
 call IssuePointOrder(u,"flamestrike",GetUnitX(victim),GetUnitY(victim))
 elseif (raw=='nnrg' or raw=='n01Q') and Forest86_Ready(u,'nWV8',100) then
 call IssuePointOrder(u,"shockwave",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='nnrg' and Forest86_Ready(u,'nBO8',150) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif raw=='nsel' and Forest86_Ready(u,'nAQ8',250) then
 call IssuePointOrder(u,"blizzard",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='nhyc' and Forest86_Ready(u,'nTA8',0) and IsUnitInRange(u,victim,450.) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='nsnp' and Forest86_Ready(u,'nBE8',0) then
 call IssueImmediateOrder(u,"berserk")
 elseif raw=='n01Q' and Forest86_Ready(u,'nFQ8',200) then
 call IssueTargetOrder(u,"forkedlightning",victim)
 elseif raw=='n01O' and Forest86_Ready(u,'nFL8',200) then
 call IssueTargetOrder(u,"forkedlightning",victim)
 elseif raw=='nwgs' and Forest86_Ready(u,'nMI8',150) then
 call IssueImmediateOrder(u,"mirrorimage")
 elseif raw=='nsgh' and Forest86_Ready(u,'nER8',150) then
 call IssueTargetOrder(u,"entanglingroots",victim)
 elseif raw=='nsgb' and Forest86_Ready(u,'nST8',100) and IsUnitInRange(u,victim,500.) then
 call IssueImmediateOrder(u,"stomp")
 elseif raw=='nsgb' and Forest86_Ready(u,'nBU8',100) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 endif
 set ally=null
endfunction
