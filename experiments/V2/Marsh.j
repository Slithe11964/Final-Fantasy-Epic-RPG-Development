function M2_Pool takes integer raw returns boolean
 return raw=='n03H' or raw=='n03G' or raw=='n03J' or raw=='n03I' or raw=='n03E' or raw=='n03F'
endfunction
function M2_FoodValid takes unit caster,unit victim returns boolean
 return victim!=null and victim!=caster and M2_Pool(GetUnitTypeId(victim)) and M89_Injured(victim) and IsUnitAlly(victim,GetOwningPlayer(caster)) and not IsUnitType(victim,UNIT_TYPE_HERO) and not IsUnitInGroup(victim,udg_SpecialUnits) and not IsUnitIllusion(victim) and LoadInteger(Forest86Data,GetHandleId(caster),90)<2
endfunction
function M2_Food takes unit caster returns unit
 local group g=CreateGroup()
 local unit u=null
 local unit chosen=null
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),350.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if M2_FoodValid(caster,u) then
 set chosen=u
 exitwhen true
 endif
 endloop
 call DestroyGroup(g)
 set u=null
 set g=null
 return chosen
endfunction
function M2_Lifesteal takes unit source,unit victim,real damage,boolean physical,boolean magical,boolean heal,boolean mana,boolean pure returns nothing
 local real amount=0.
 if heal or mana or pure or damage<=0. or GetUnitAbilityLevel(source,'bVA2')==0 or not Forest86_Enemy(source,victim) then
 return
 endif
 if physical then
 set amount=RMinBJ(damage,GetWidgetLife(victim))*.01
 elseif magical then
 set amount=RMinBJ(damage,GetWidgetLife(victim))*.05
 endif
 if I2_Active(source,40) then
 set amount=amount*.5
 endif
 if amount>0. and Forest86_Alive(source) then
 call SetWidgetLife(source,RMinBJ(I2R(BlzGetUnitMaxHP(source)),GetWidgetLife(source)+amount))
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl",source,"origin"))
 endif
endfunction
function M2_Sacrifice takes unit caster returns nothing
 local group g=CreateGroup()
 local unit u=null
 local unit credit=null
 local real best=600.*600.+1.
 local real distance=0.
 if not Forest86_Alive(caster) or GetWidgetLife(caster)>=3000. then
 call BlzEndUnitAbilityCooldown(caster,'kSC2')
 call DestroyGroup(g)
 set g=null
 return
 endif
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),600.,null)
 loop
 set u=FirstOfGroup(g)
 exitwhen u==null
 call GroupRemoveUnit(g,u)
 if u!=caster and Forest86_Alive(u) then
 if IsUnitAlly(u,GetOwningPlayer(caster)) then
 call M89_Heal(caster,u,5000.)
 elseif IsUnitType(u,UNIT_TYPE_HERO) and Forest86_Enemy(caster,u) then
 set distance=(GetUnitX(u)-GetUnitX(caster))*(GetUnitX(u)-GetUnitX(caster))+(GetUnitY(u)-GetUnitY(caster))*(GetUnitY(u)-GetUnitY(caster))
 if distance<best then
 set best=distance
 set credit=u
 endif
 endif
 endif
 endloop
 call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl",GetUnitX(caster),GetUnitY(caster)))
 if credit!=null then
 // A tiny guaranteed killing hit credits the existing XP/loot pipeline, including Gaya and XP banking.
 call SetWidgetLife(caster,1.)
 set udg_IsPureDamage=true
 set udg_IgnoresReduction=true
 set udg_DmgFlagUnavoidable=-1
 set udg_DmgFlagNoCrit=-1.
 call UnitDamageTarget(credit,caster,2.,false,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,null)
 else
 call KillUnit(caster)
 endif
 call DestroyGroup(g)
 set g=null
 set u=null
 set credit=null
endfunction
function M2_Spell takes unit caster,unit victim,integer raw returns nothing
 local group wave=null
 if raw=='kDV2' then
 if M2_FoodValid(caster,victim) then
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
 call SetUnitState(caster,UNIT_STATE_MANA,RMinBJ(GetUnitState(caster,UNIT_STATE_MAX_MANA),GetUnitState(caster,UNIT_STATE_MANA)+200.))
 call BlzEndUnitAbilityCooldown(caster,'kDV2')
 endif
 elseif raw=='kES2' and Forest86_Alive(victim) and IsUnitAlly(victim,GetOwningPlayer(caster)) then
 call M89_Dummy(caster,victim,'kEM2',"curse")
 call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\AntiMagicShell\\AntiMagicShell.mdl",victim,"origin"))
 elseif raw=='kSC2' then
 call M2_Sacrifice(caster)
 endif
 set wave=null
endfunction
function M2_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit ally=null
 if IsUnitIllusion(u) then
 return
 endif
 if raw=='n03J' and GetWidgetLife(u)<3000. and Forest86_Ready(u,'kSC2',0) then
 call IssueImmediateOrder(u,"deathpact")
 return
 elseif raw=='n03H' then
 if Forest86_Ready(u,'kDV2',200) then
 set ally=M2_Food(u)
 if ally!=null then
 call IssueTargetOrder(u,"devour",ally)
 set ally=null
 return
 endif
 endif
 if Forest86_Ready(u,'kES2',100) then
 set ally=B88_Ally(u,'bES2')
 if ally==null and GetUnitAbilityLevel(u,'bES2')==0 then
 set ally=u
 endif
 if ally!=null then
 call IssueTargetOrder(u,"antimagicshell",ally)
 set ally=null
 return
 endif
 endif
 endif
 if victim!=null then
 if raw=='n03H' and Forest86_Ready(u,'kOB2',1000) then
 call IssuePointOrder(u,"breathoffrost",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='n03H' and Forest86_Ready(u,'kOF2',200) then
 call IssueTargetOrder(u,"thunderbolt",victim)
 elseif raw=='n03G' and Forest86_Ready(u,'kLB2',200) then
 call IssuePointOrder(u,"breathoffrost",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='n03E' and Forest86_Ready(u,'kWB2',200) then
 call IssuePointOrder(u,"breathoffrost",GetUnitX(victim),GetUnitY(victim))
 elseif raw=='n03F' and Forest86_Ready(u,'kFB2',200) then
 call IssuePointOrder(u,"breathoffrost",GetUnitX(victim),GetUnitY(victim))
 endif
 endif
 set ally=null
endfunction
