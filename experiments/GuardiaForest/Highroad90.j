globals
 group H90Buffs=null
 real H90AlertUntil=0.
 boolean H90AlertActive=false
endglobals
function H90_Pool takes integer raw returns boolean
 return raw=='nwlg' or raw=='nwld' or raw=='nspb' or raw=='ngrk' or raw=='ngst' or raw=='nggr' or raw=='narg' or raw=='nwrg' or raw=='nsgg' or raw=='ngno' or raw=='ngns' or raw=='ngnw' or raw=='ngnv' or raw=='ngna' or raw=='n01P'
endfunction
function H90_Buff takes unit u,integer key,real duration returns nothing
 call SaveReal(Forest86Data,GetHandleId(u),key,Forest86Now+duration)
 call GroupAddUnit(H90Buffs,u)
endfunction
function H90_BreakTaunt takes unit hero returns nothing
 local integer id=GetHandleId(hero)
 if hero==null or Forest86Data==null then
 return
 endif
 if IsUnitInGroup(hero,Forest86Taunted) or HaveSavedHandle(Forest86Data,id,20) then
 call GroupRemoveUnit(Forest86Taunted,hero)
 call RemoveSavedHandle(Forest86Data,id,20)
 call RemoveSavedReal(Forest86Data,id,21)
 call IssueImmediateOrder(hero,"stop")
 endif
endfunction
function H90_Evasion takes unit u,real value returns real
 if GetUnitTypeId(u)!='nggr' and GetUnitAbilityLevel(u,'bE90')>0 then
 set value=value*1.2
 endif
 if B88_Active(u,112) then
 set value=value-30.
 endif
 return value
endfunction
function H90_Ground takes unit u,real x,real y,real radius returns nothing
 local effect fx=AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",x,y)
 call BlzSetSpecialEffectScale(fx,radius/300.)
 call DestroyEffect(fx)
 call M89_Area(u,x,y,radius,800.,5,false)
 set fx=null
endfunction
function H90_Cleanup takes unit u returns nothing
 local integer id=GetHandleId(u)
 if HaveSavedHandle(Forest86Data,id,120) then
 call DestroyEffect(LoadEffectHandle(Forest86Data,id,120))
 call RemoveSavedHandle(Forest86Data,id,120)
 endif
 if LoadBoolean(Forest86Data,id,109) then
 call PauseUnit(u,false)
 call RemoveSavedBoolean(Forest86Data,id,109)
 endif
 if LoadBoolean(Forest86Data,id,111) then
 call SetUnitScale(u,1.,1.,1.)
 call RemoveSavedBoolean(Forest86Data,id,111)
 endif
 call UnitRemoveAbility(u,'hD20')
 call UnitRemoveAbility(u,'hAS0')
 call UnitRemoveAbility(u,'hA25')
 call GroupRemoveUnit(H90Buffs,u)
endfunction
function H90_TickUnit takes nothing returns nothing
 local unit u=GetEnumUnit()
 local integer id=GetHandleId(u)
 local integer key=100
 local boolean active=false
 if not Forest86_Alive(u) then
 call H90_Cleanup(u)
 set u=null
 return
 endif
 if LoadReal(Forest86Data,id,101)>0. and Forest86Now<=LoadReal(Forest86Data,id,101) then
 call M89_Heal(LoadUnitHandle(Forest86Data,id,121),u,100.)
 endif
 if not B88_Active(u,101) then
 call RemoveSavedHandle(Forest86Data,id,121)
 endif
 if LoadReal(Forest86Data,id,103)>0. and Forest86Now<=LoadReal(Forest86Data,id,103) then
 call H90_Whirl(u)
 endif
 if LoadReal(Forest86Data,id,107)>0. and Forest86Now>=LoadReal(Forest86Data,id,107) then
 call RemoveSavedReal(Forest86Data,id,107)
 call H90_Ground(u,LoadReal(Forest86Data,id,114),LoadReal(Forest86Data,id,115),500.)
 endif
 if not B88_Active(u,100) and LoadBoolean(Forest86Data,id,109) then
 call PauseUnit(u,false)
 call RemoveSavedBoolean(Forest86Data,id,109)
 endif
 if not B88_Active(u,102) then
 call UnitRemoveAbility(u,'hD20')
 call UnitRemoveAbility(u,'hAS0')
 endif
 if not B88_Active(u,103) and HaveSavedHandle(Forest86Data,id,120) then
 call DestroyEffect(LoadEffectHandle(Forest86Data,id,120))
 call RemoveSavedHandle(Forest86Data,id,120)
 endif
 if not B88_Active(u,105) and LoadBoolean(Forest86Data,id,111) then
 call SetUnitScale(u,1.,1.,1.)
 call UnitRemoveAbility(u,'hA25')
 call RemoveSavedBoolean(Forest86Data,id,111)
 endif
 loop
 exitwhen key>112
 if key!=109 and key!=111 and B88_Active(u,key) then
 set active=true
 endif
 set key=key+1
 endloop
 if not active then
 call GroupRemoveUnit(H90Buffs,u)
 endif
 set u=null
endfunction
function H90_Whirl takes unit caster returns nothing
 local group g=CreateGroup()
 local unit u
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),250.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Enemy(caster,u) then
 call B88_Damage(caster,u,500.,true)
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
endfunction
function H90_Spell takes unit caster,unit victim,integer raw returns nothing
 local integer id=GetHandleId(caster)
 local group g=null
 local unit u=null
 if raw=='hTT0' then
 call Forest86_Taunt(caster)
 call H90_Buff(caster,100,5.)
 call IssueImmediateOrder(caster,"stop")
 call SaveBoolean(Forest86Data,id,109,true)
 call PauseUnit(caster,true)
 elseif raw=='hBI0' and Forest86_Enemy(caster,victim) then
 call B88_Damage(caster,victim,1000.,true)
 call H90_Buff(victim,112,5.)
 call M89_Dummy(caster,victim,'hSL0',"slow")
 elseif raw=='hHW0' then
 set g=CreateGroup()
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),800.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if Forest86_Alive(u) and IsUnitAlly(u,GetOwningPlayer(caster)) then
 call UnitAddAbility(u,'hD20')
 call UnitAddAbility(u,'hAS0')
 call H90_Buff(u,102,20.)
 endif
 endloop
 call DestroyGroup(g)
 elseif raw=='hFK0' and Forest86_Alive(victim) and IsUnitAlly(victim,GetOwningPlayer(caster)) then
 call M89_Heal(caster,victim,1000.)
 call SaveUnitHandle(Forest86Data,GetHandleId(victim),121,caster)
 call H90_Buff(victim,101,5.)
 elseif raw=='hWW0' then
 call H90_Buff(caster,103,5.)
 call SaveEffectHandle(Forest86Data,id,120,AddSpecialEffectTarget("Abilities\\Spells\\Orc\\Bladestorm\\Bladestorm.mdl",caster,"origin"))
 elseif raw=='hAV0' then
 call UnitAddAbility(caster,'hA25')
 call H90_Buff(caster,105,30.)
 call SaveBoolean(Forest86Data,id,111,true)
 call SetUnitScale(caster,1.5,1.5,1.5)
 elseif raw=='hGS0' then
 call H90_Ground(caster,GetUnitX(caster),GetUnitY(caster),300.)
 call SaveReal(Forest86Data,id,114,GetUnitX(caster))
 call SaveReal(Forest86Data,id,115,GetUnitY(caster))
 call H90_Buff(caster,107,2.)
 elseif raw=='hDV0' then
 if victim!=caster and M89_Injured(victim) and H90_Pool(GetUnitTypeId(victim)) and not IsUnitType(victim,UNIT_TYPE_HERO) and not IsUnitInGroup(victim,udg_SpecialUnits) and IsUnitAlly(victim,GetOwningPlayer(caster)) and LoadInteger(Forest86Data,id,90)<2 then
 call M89_Absorb(caster,victim)
 set g=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(victim))
 if g!=null then
 call GroupRemoveUnit(g,victim)
 endif
 call GroupRemoveUnit(Forest86Actors,victim)
 call RemoveUnit(victim)
 call UnitAddAbility(caster,'hRD0')
 else
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+350.))
 call BlzEndUnitAbilityCooldown(caster,'hDV0')
 endif
 elseif raw=='hRD0' then
 call H90_Buff(caster,106,10.)
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl",caster,"origin"))
 elseif raw=='hMF0' and Forest86_Enemy(caster,victim) then
 call B88_Damage(caster,victim,1200.,true)
 call M89_Dummy(caster,victim,'hPB0',"cripple")
 endif
 set g=null
 set u=null
 set caster=null
 set victim=null
endfunction
function H90_Food takes unit caster returns unit
 local group g=CreateGroup()
 local unit u
 local unit chosen=null
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),350.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if u!=caster and M89_Injured(u) and H90_Pool(GetUnitTypeId(u)) and IsUnitAlly(u,GetOwningPlayer(caster)) and not IsUnitType(u,UNIT_TYPE_HERO) and not IsUnitInGroup(u,udg_SpecialUnits) then
 set chosen=u
 exitwhen true
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set u=null
 return chosen
endfunction
function H90_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit ally=null
 if raw=='ngno' and Forest86_Ready(u,'hFK0',50) then
 set ally=M89_Ally(u,0)
 if ally!=null then
 call IssueTargetOrder(u,"healingwave",ally)
 set ally=null
 return
 endif
 elseif raw=='nggr' and LoadInteger(Forest86Data,GetHandleId(u),90)<2 and Forest86_Ready(u,'hDV0',350) then
 set ally=H90_Food(u)
 if ally!=null then
 call IssueTargetOrder(u,"devour",ally)
 set ally=null
 return
 endif
 endif
 set ally=null
 if victim!=null then
 if raw=='nsgg' and Forest86_Ready(u,'hTT0',0) and IsUnitInRange(u,victim,450.) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='narg' and Forest86_Ready(u,'hHB0',100) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif raw=='n01P' and Forest86_Ready(u,'hER0',200) then
 call IssueTargetOrder(u,"entanglingroots",victim)
 elseif raw=='nwld' and Forest86_Ready(u,'hBI0',150) and IsUnitInRange(u,victim,180.) then
 call IssueTargetOrder(u,"cripple",victim)
 elseif raw=='nwlg' and Forest86_Ready(u,'hHW0',0) then
 call IssueImmediateOrder(u,"roar")
 elseif raw=='nspb' and Forest86_Ready(u,'hBO0',100) then
 call IssueTargetOrder(u,"firebolt",victim)
 elseif raw=='ngnv' and Forest86_Ready(u,'hWW0',150) and IsUnitInRange(u,victim,250.) then
 call IssueImmediateOrder(u,"whirlwind")
 elseif raw=='ngnw' and Forest86_Ready(u,'hAA0',100) then
 call IssueTargetOrder(u,"chainlightning",victim)
 elseif raw=='ngrk' and Forest86_Ready(u,'hAV0',150) then
 call IssueImmediateOrder(u,"avatar")
 elseif raw=='ngst' and Forest86_Ready(u,'hGS0',200) and IsUnitInRange(u,victim,500.) then
 call IssueImmediateOrder(u,"stomp")
 elseif raw=='nggr' and Forest86_Ready(u,'hRD0',400) then
 call IssueImmediateOrder(u,"howlofterror")
 elseif raw=='nwrg' and Forest86_Ready(u,'hMF0',100) and IsUnitInRange(u,victim,180.) then
 call IssueTargetOrder(u,"cripple",victim)
 else
 call M89_AI(u,victim)
 endif
 endif
endfunction
