"""Hydra offspring stats/poison and explicit two-generation death splitting."""
import build_barrens92 as package
from build_forest86 import *
BASE=ROOT/'release/development/QuickUI96/FFERPG-QuickUI96.w3x'
OUT=ROOT/'release/development/QuickUI97/FFERPG-QuickUI97.w3x'
LABEL='FFERPG QuickUI97 (Hydra Offspring)'
AVATAR='''function C97_AvatarStart takes unit u returns nothing
 local integer id=GetHandleId(u)
 if LoadBoolean(Forest86Data,id,171) then
 return
 endif
 call SaveBoolean(Forest86Data,id,171,true)
 call SaveBoolean(Forest86Data,id,172,GetUnitAbilityLevel(u,'Amim')==0)
 call BlzSetUnitBaseDamage(u,BlzGetUnitBaseDamage(u,0)+100,0)
 call BlzSetUnitMaxHP(u,BlzGetUnitMaxHP(u)+1000)
 call SetWidgetLife(u,RMinBJ(I2R(BlzGetUnitMaxHP(u)),GetWidgetLife(u)+1000.))
 call UnitAddAbility(u,'Amim')
endfunction
function C97_AvatarEnd takes unit u returns nothing
 local integer id=GetHandleId(u)
 if not LoadBoolean(Forest86Data,id,171) then
 return
 endif
 call RemoveSavedBoolean(Forest86Data,id,171)
 call BlzSetUnitBaseDamage(u,BlzGetUnitBaseDamage(u,0)-100,0)
 call BlzSetUnitMaxHP(u,IMaxBJ(1,BlzGetUnitMaxHP(u)-1000))
 if LoadBoolean(Forest86Data,id,172) then
 call UnitRemoveAbility(u,'Amim')
 endif
 call RemoveSavedBoolean(Forest86Data,id,172)
endfunction
'''

SPLIT='''function C97_SplitDeath takes unit parent returns nothing
 local integer raw=GetUnitTypeId(parent)
 local integer childRaw=0
 local integer i=0
 local real angle=0.
 local unit child=null
 local group wave=null
 if raw=='nahy' then
 set childRaw='nhyd'
 elseif raw=='nhyd' then
 set childRaw='nhyh'
 else
 return
 endif
 if GetWidgetLife(parent)>.405 or GetUnitAbilityLevel(parent,'cSP7')==0 then
 return
 endif
 set wave=LoadGroupHandle(udg_SpawnTimerHash,5,GetUnitUserData(parent))
 loop
 exitwhen i>=2
 set angle=(GetUnitFacing(parent)+I2R(i)*180.)*bj_DEGTORAD
 set child=CreateUnit(GetOwningPlayer(parent),childRaw,GetUnitX(parent)+80.*Cos(angle),GetUnitY(parent)+80.*Sin(angle),GetUnitFacing(parent))
 call SetUnitUserData(child,GetUnitUserData(parent))
 if wave!=null then
 call GroupAddUnit(wave,child)
 endif
 call DestroyEffect(AddSpecialEffect("Objects\\\\Spawnmodels\\\\Naga\\\\NagaDeath\\\\NagaDeath.mdl",GetUnitX(child),GetUnitY(child)))
 set i=i+1
 endloop
 set child=null
 set wave=null
endfunction
'''

def objects97(v):
 u=all_objects(v,'w3u');a={};poison='20% chance on a landed attack to poison for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n50 + 5 x attacking hydra level damage per second (175 at level 25). Equal/stronger poison refreshes instead of stacking.'
 a['cPH7']=ability('cPH7','AIev','Hydra Offspring Venom',poison,'BTNPoisonSting.blp');mod(a['cPH7'],'Eev1',0.,1)
 a['cSP7']=ability('cSP7','AIev','Divide','On death, Ancient Hydra splits into two Hydras. Each Hydra splits into two Hydra Hatchlings on death. In creature review, select either living size and type -split.','BTNHydra.blp');mod(a['cSP7'],'Eev1',0.,1)
 old=all_objects(v,'w3a')['hAV0'];f=fields(old)
 a['hAV0']=channel('hAV0','Avatar',f['aub1',1],f['aart',0].split('\\')[-1],'avatar',0,45.,150)
 for key,val in [('Ncl3',1),('acat',''),('atat',''),('asat',''),('aeat',''),('aefs',''),('aefl','')]:mod(a['hAV0'],key,val,1 if key=='Ncl3' else 0)
 for raw in ['nahy','nhyd']:
  ab=[r for r in fields(u[raw])['uabi',None].split(',') if r not in ['Aspy','Aspt']]
  if raw=='nhyd':ab=[r for r in ab if r!='A0PH']+['cPH7']
  ab.append('cSP7');setf(u[raw],'uabi',','.join(dict.fromkeys(ab)),None)
 for k,val in [('ulev',25),('uhpm',3000),('udef',41.),('ua1b',134),('ua1d',1),('ua1s',6)]:setf(u['nhyd'],k,val,None)
 setf(u['nhyd'],'utub','Normal level 25; 3000 health; 41 armor; 135–140 attack damage.|n'+poison+'|nDivide: on death, creates two Hydra Hatchlings (nhyh).',None)
 setf(u['nahy'],'utub',fields(u['nahy'])['utub',None].replace('Splits into two smaller Hydras on death (native Spawn Hydra).','Splits into two level 25 Hydras on death. Each can split again into Hydra Hatchlings.'),None)
 return {r:u[r] for r in ['nahy','nhyd']},a

def refresh97(s):
 fs=functions(s)
 if 'C95_Pool' in fs:
  s=put(s,'C95_Pool',fs['C95_Pool'].replace(' return '," return raw=='nhyd' or ",1))
  s=put(s,'C95_Poison',fs['C95_Poison'].replace("if raw!='nahy' and raw!='nehy' then","if raw!='nahy' and raw!='nehy' and raw!='nhyd' then",1).replace(" if raw=='nehy' then"," if raw=='nhyd' then\n set chance=20\n set amount=50.+5.*I2R(GetUnitLevel(attacker))\n elseif raw=='nehy' then",1))
 if 'Forest86_Death' in fs:
  s=s.replace('function Forest86_Death takes',SPLIT+'\nfunction Forest86_Death takes',1)
  b=functions(s)['Forest86_Death'].replace(' local unit u=GetTriggerUnit()',' local unit u=GetTriggerUnit()\n call C97_SplitDeath(u)',1)
  s=put(s,'Forest86_Death',b)
 if 'H90_Cleanup' in fs:
  s=s.replace('function H90_Cleanup takes',AVATAR+'\nfunction H90_Cleanup takes',1)
  b=functions(s)['H90_Cleanup'].replace(' local integer id=GetHandleId(u)',' local integer id=GetHandleId(u)\n call C97_AvatarEnd(u)',1);s=put(s,'H90_Cleanup',b)
  b=functions(s)['H90_Spell']
  bad='Abilities\\\\Spells\\\\Orc\\\\Whirlwind\\\\Whirlwind.mdl';good='Abilities\\\\Spells\\\\Orc\\\\Bladestorm\\\\BladestormTarget.mdl';assert bad in b
  b=b.replace(bad,good).replace(" elseif raw=='hAV0' then"," elseif raw=='hAV0' then\n call C97_AvatarStart(caster)",1)
  b=b.replace(" elseif raw=='hWW0' then"," elseif raw=='hWW0' then\n call SetUnitAnimation(caster,\"spin\")",1);s=put(s,'H90_Spell',b)
  b=functions(s)['H90_TickUnit'].replace(' if not B88_Active(u,105) and LoadBoolean(Forest86Data,id,111) then',' if not B88_Active(u,105) then\n call C97_AvatarEnd(u)\n endif\n if not B88_Active(u,105) and LoadBoolean(Forest86Data,id,111) then',1)
  s=put(s,'H90_TickUnit',b)
 return s

def main():
 package.BASE=BASE;package.OUT=OUT;package.LABEL=LABEL;package.objects92=objects97;package.refresh92=refresh97;package.build()
 p=OUT.with_suffix('.json');r=json.loads(p.read_text());r.update(offspring='nhyd: level25,3000HP,41armor,135-140attack;20%poison50+5*attackerLevel/s10s',split='Explicit shared death hook: nahy -> 2 nhyd -> 2 nhyh each. Native Aspy/Aspt removed from those units to prevent duplicate spawns. Same owner and wave metadata. No new timer or local gameplay.',save_format='unchanged');p.write_text(json.dumps(r,indent=2))

if __name__=='__main__':main()
