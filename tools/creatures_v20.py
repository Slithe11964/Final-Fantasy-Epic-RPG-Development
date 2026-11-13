"""Explicit native proxy spell casts and target-bound Shadow Double."""
import copy
from build_forest86 import all_objects
from priest_master import fields,setf
from jtok import functions
from performance_runtime import put

CAST='''function C20_DragonCast takes unit caster,unit target,integer raw,integer cost,real cooldown,real amount,integer element,boolean point returns boolean
 local unit proxy=null
 local integer id=0
 local boolean success=false
 if udg_InCinematicMode or not Forest86_Enemy(caster,target) or not IsUnitType(target,UNIT_TYPE_HERO) or not IsUnitInRange(caster,target,800.) or not Forest86_Ready(caster,raw,cost) then
 return false
 endif
 // Use a native spell on an invisible proxy so the creature's attack AI cannot
 // replace the cast before it fires. All creation and orders are shared.
 set proxy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(caster),GetUnitY(caster),Atan2(GetUnitY(target)-GetUnitY(caster),GetUnitX(target)-GetUnitX(caster))*bj_RADTODEG)
 set id=GetHandleId(proxy)
 call SetUnitVertexColor(proxy,255,255,255,0)
 call SetUnitPathing(proxy,false)
 call SaveUnitHandle(udg_ProxyDamageHash,id,0,caster)
 call SaveReal(udg_ProxyDamageHash,id,1,amount)
 call SaveInteger(udg_ProxyDamageHash,id,2,3)
 call SaveInteger(udg_ProxyDamageHash,id,100,element)
 call SaveBoolean(udg_ProxyDamageHash,id,5,true)
 call UnitAddAbility(proxy,raw)
 call BlzSetUnitAbilityManaCost(proxy,raw,0,0)
 if point then
 set success=IssuePointOrder(proxy,"breathoffire",GetUnitX(target),GetUnitY(target))
 else
 set success=IssueTargetOrder(proxy,"thunderbolt",target)
 endif
 if success then
 call SetUnitState(caster,UNIT_STATE_MANA,GetUnitState(caster,UNIT_STATE_MANA)-I2R(cost))
 call BlzStartUnitAbilityCooldown(caster,raw,cooldown)
 call SetUnitFacing(caster,GetUnitFacing(proxy))
 call SetUnitAnimation(caster,"spell")
 call UnitApplyTimedLife(proxy,'BTLF',12.)
 else
 call RemoveUnit(proxy)
 endif
 set proxy=null
 return success
endfunction
'''

COPY='''function C20_ShadowCopy takes unit caster,unit target returns nothing
 local unit dummy=null
 local item wand=null
 local timer clock=null
 local integer id=0
 if not Forest86_Enemy(caster,target) or not IsUnitType(target,UNIT_TYPE_HERO) or IsUnitIllusion(target) then
 return
 endif
 // Wand of Illusion's native item-target path copies its selected unit. A
 // custom item ability explicitly permits enemy heroes. Keep the proxy and
 // resulting illusion owned by the Satyr throughout.
 set dummy=CreateUnit(GetOwningPlayer(caster),'h01B',GetUnitX(target),GetUnitY(target),GetUnitFacing(target))
 call SetUnitVertexColor(dummy,255,255,255,0)
 call SetUnitPathing(dummy,false)
 call UnitAddAbility(dummy,'AInv')
 call SaveUnitHandle(F99Data,GetHandleId(dummy),41,caster)
 call SaveUnitHandle(F99Data,GetHandleId(dummy),42,target)
 set wand=CreateItem('iC20',GetUnitX(target),GetUnitY(target))
 call UnitAddItem(dummy,wand)
 if UnitUseItemTarget(dummy,wand,target) then
 set clock=CreateTimer()
 set id=GetHandleId(clock)
 call SaveUnitHandle(F99Data,id,0,caster)
 call SaveUnitHandle(F99Data,id,1,target)
 call SaveReal(F99Data,id,2,GetUnitX(target))
 call SaveReal(F99Data,id,3,GetUnitY(target))
 call SaveItemHandle(F99Data,id,4,wand)
 call SaveUnitHandle(F99Data,id,5,dummy)
 call TimerStart(clock,.5,false,function F99_BindCopy)
 else
 call RemoveItem(wand)
 call FlushChildHashtable(F99Data,GetHandleId(dummy))
 call RemoveUnit(dummy)
 endif
 set dummy=null
 set wand=null
 set clock=null
endfunction
'''

def refresh(lib,s,dev=False):
 if not dev:return s
 fs=functions(s)
 if 'M2_AI' in fs:
  b=fs['M2_AI']
  # Retain all hero selection/readiness/priority decisions, but execute each
  # native offensive spell through the same reliable proxy mechanism as bolts.
  b=b.replace('IssuePointOrder(u,"breathoffire",GetUnitX(victim),GetUnitY(victim))',"C20_DragonCast(u,victim,'kOB2',1000,30.,5000.,7,true)",1)
  b=b.replace('IssueTargetOrder(u,"thunderbolt",victim)',"C20_DragonCast(u,victim,'kOF2',200,15.,2000.,7,false)",1)
  for raw,element in [('kLB2',3),('kWB2',5),('kFB2',1)]:
   b=b.replace('IssuePointOrder(u,"breathoffire",GetUnitX(victim),GetUnitY(victim))',f"C20_DragonCast(u,victim,'{raw}',200,10.,4000.,{element},true)",1)
  assert 'IssuePointOrder(u,"breathoffire"' not in b
  s=put(s,'M2_AI',b)
  s=s.replace('function M2_AI takes',CAST+'\nfunction M2_AI takes',1)
 if 'F99_Spell' in fs:
  b=fs['F99_Spell'];start=b.index(" elseif raw=='zCL9' and IsUnitType(target,UNIT_TYPE_HERO) then");end=b.index(" elseif raw=='zMI9' then",start)
  b=b[:start]+" elseif raw=='zCL9' and IsUnitType(target,UNIT_TYPE_HERO) then\n call C20_ShadowCopy(caster,target)\n"+b[end:]
  s=put(s,'F99_Spell',b)
  # F99_BindCopy is declared before the spell handler, allowing safe cleanup.
  s=s.replace('function F99_Spell takes',COPY+'\nfunction F99_Spell takes',1)
 if 'F99_Summoned' in fs:
  b=fs['F99_Summoned'];start=b.index(' elseif owner!=null and IsUnitIllusion(child) then');end=b.index('\n endif\n set parent=null',start)
  b=b[:start]+''' elseif owner!=null and IsUnitIllusion(child) then
 if GetUnitTypeId(child)!=GetUnitTypeId(LoadUnitHandle(F99Data,GetHandleId(parent),42)) then
 call RemoveUnit(child)
 else
 call SetUnitOwner(child,GetOwningPlayer(owner),true)
 call SaveBoolean(F99Data,GetHandleId(child),40,true)
 call GroupAddUnit(F99Active,child)
 call IssueTargetOrder(child,"attack",LoadUnitHandle(F99Data,GetHandleId(parent),42))
 endif'''+b[end:]
  s=put(s,'F99_Summoned',b)
 if 'F99_BindCopy' in fs:
  b=fs['F99_BindCopy'];marker=' call FlushChildHashtable(F99Data,id)';assert marker in b
  b=b.replace(marker,''' if LoadItemHandle(F99Data,id,4)!=null then
 call RemoveItem(LoadItemHandle(F99Data,id,4))
 endif
 if LoadUnitHandle(F99Data,id,5)!=null then
 call FlushChildHashtable(F99Data,GetHandleId(LoadUnitHandle(F99Data,id,5)))
 call RemoveUnit(LoadUnitHandle(F99Data,id,5))
 endif
'''+marker,1);s=put(s,'F99_BindCopy',b)
 return s

def objects(v,dev=False):
 if not dev:return {},{},{},{}
 a=all_objects(v,'w3a');items=all_objects(v,'w3t')
 assert 'iC20' not in items
 o=dict(base='will',id='iC20',sets=[dict(flag=0,mods=[])])
 for k,val in {'unam':'Shadow Double proxy wand','iabi':'zCI9','iuse':1,'ipaw':0,'idro':0,'ichg':0,'iper':0,'ipow':0}.items():setf(o,k,val,None)
 copy_spell=copy.deepcopy(a['zCI9']);setf(copy_spell,'aite',1,0)
 return {},{'zCI9':copy_spell},{},{'iC20':o}
