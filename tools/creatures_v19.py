"""Hero-targeted dragon/Shadowdancer AI and visible Legendary Mastery."""
import copy
from jtok import functions
from performance_runtime import put
from priest_master import fields,setf
from build_forest86 import all_objects

HERO='''function A19_FindHero takes unit caster,real radius returns unit
 local group g=CreateGroup()
 local unit candidate=null
 local unit chosen=null
 local real best=radius*radius+1.
 local real distance=0.
 call GroupEnumUnitsInRange(g,GetUnitX(caster),GetUnitY(caster),radius,null)
 loop
 set candidate=FirstOfGroup(g)
 exitwhen candidate==null
 call GroupRemoveUnit(g,candidate)
 if Forest86_Enemy(caster,candidate) and IsUnitType(candidate,UNIT_TYPE_HERO) and not IsUnitIllusion(candidate) and not IsUnitHidden(candidate) then
 set distance=(GetUnitX(candidate)-GetUnitX(caster))*(GetUnitX(candidate)-GetUnitX(caster))+(GetUnitY(candidate)-GetUnitY(caster))*(GetUnitY(candidate)-GetUnitY(caster))
 if distance<best then
 set chosen=candidate
 set best=distance
 endif
 endif
 endloop
 call DestroyGroup(g)
 set g=null
 set candidate=null
 return chosen
endfunction
'''

DRAGONS='''function M2_AI takes unit u,unit victim returns nothing
 local integer raw=GetUnitTypeId(u)
 local unit ally=null
 if IsUnitIllusion(u) then
 return
 endif
 // Dragon attacks can hold them beyond the old shared 600-unit search.
 // Offensive abilities choose an actual hero within their native 800 range.
 if raw=='n03H' or raw=='n03G' or raw=='n03E' or raw=='n03F' then
 set victim=A19_FindHero(u,800.)
 endif
 if victim!=null then
 if raw=='n03H' and Forest86_Ready(u,'kOB2',1000) then
 if IssuePointOrder(u,"breathoffire",GetUnitX(victim),GetUnitY(victim)) then
 return
 endif
 endif
 if raw=='n03H' and Forest86_Ready(u,'kOF2',200) then
 if IssueTargetOrder(u,"thunderbolt",victim) then
 return
 endif
 elseif raw=='n03G' and Forest86_Ready(u,'kLB2',200) then
 if IssuePointOrder(u,"breathoffire",GetUnitX(victim),GetUnitY(victim)) then
 return
 endif
 elseif raw=='n03E' and Forest86_Ready(u,'kWB2',200) then
 if IssuePointOrder(u,"breathoffire",GetUnitX(victim),GetUnitY(victim)) then
 return
 endif
 elseif raw=='n03F' and Forest86_Ready(u,'kFB2',200) then
 if IssuePointOrder(u,"breathoffire",GetUnitX(victim),GetUnitY(victim)) then
 return
 endif
 endif
 endif
 if raw=='n03J' and GetWidgetLife(u)<3000. and Forest86_Ready(u,'kSC2',0) then
 call IssueImmediateOrder(u,"deathpact")
 elseif raw=='n03H' then
 if Forest86_Ready(u,'kDV2',200) then
 set ally=M2_Food(u)
 if ally!=null then
 if IssueTargetOrder(u,"devour",ally) then
 set ally=null
 return
 endif
 endif
 endif
 if Forest86_Ready(u,'kES2',100) then
 set ally=B88_Ally(u,'bES2')
 if ally==null and GetUnitAbilityLevel(u,'bES2')==0 then
 set ally=u
 endif
 if ally!=null then
 call IssueTargetOrder(u,"antimagicshell",ally)
 endif
 endif
 endif
 set ally=null
endfunction'''

def refresh(lib,s,dev=False):
 if not dev:return s
 fs=functions(s)
 if 'F99_AI' in fs:
  b=fs['F99_AI'];marker=' if raw==\'n00N\' and not IsUnitIllusion(u)'
  assert marker in b
  b=b.replace(marker,''' // All automatic Ancient Forest abilities require nearby combat.
 if D2_FindEnemy(u,2000.)==null then
 return
 endif
 if raw=='nsts' then
 set victim=A19_FindHero(u,600.)
 endif
'''+marker,1)
  s=put(s,'F99_AI',b)
  s=s.replace('function F99_AI takes',HERO+'\nfunction F99_AI takes',1)
 if 'M2_AI' in fs:s=put(s,'M2_AI',DRAGONS)
 if 'F99_TickUnit' in fs:
  b=fs['F99_TickUnit'];old=" if raw=='n00P' then\n set child=F99_Summon(u,'qL99'"
  assert old in b
  b=b.replace(old," if D2_FindEnemy(u,2000.)!=null then\n"+old,1)
  marker=' call SaveReal(F99Data,id,11,LoadReal(F99Data,id,11)+5.)';assert marker in b
  b=b.replace(marker,' endif\n call SaveReal(F99Data,id,11,Forest86Now+5.)',1)
  s=put(s,'F99_TickUnit',b)
 return s

def objects(v,dev=False):
 a=all_objects(v,'w3a');abilities={};units={}
 o=copy.deepcopy(a['A02F'])
 for rank in range(5,10):
  assert fields(o)['Ihid',rank]==1
  # Preserve the native attribute ability's Data D pointer (4), not Data A.
  for st in o['sets']:
   for m in st['mods']:
    if m['field']=='Ihid' and m['level']==rank:
     assert m['data']==4
     m['value']=0
 abilities['A02F']=o
 if dev:
  # Explain the new cast condition in summon ability tooltips as well as copies.
  text_changes=[]
  for raw in ['zDY9','zSY9','zEN9','zEG9','zIF9','zRT9','zAW9']:
   q=copy.deepcopy(a[raw]);text=fields(q).get(('aub1',1),'')
   updated=text+'|nAI casts only while an enemy is within 2000 range.'
   setf(q,'aub1',updated,1);abilities[raw]=q;text_changes.append((text,updated))
  for raw,q in all_objects(v,'w3u').items():
   text=fields(q).get(('utub',None),'');updated=text
   for before,after in text_changes:
    if before:updated=updated.replace(before,after)
   if updated!=text:
    units[raw]=copy.deepcopy(q);setf(units[raw],'utub',updated,None)
 return units,abilities
