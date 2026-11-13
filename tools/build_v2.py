"""V2: bearer-only auras, mobile roots, timed brood, permanent spider offspring and active cover."""
from build_forest86 import *
from build_ancient99 import sort99
import build_central95 as package
import struct
import v2_icy
import v2_marsh
BASE=ROOT/'release/development/V1/FFERPG-V1.w3x'
OUT=ROOT/'release/development/V2/FFERPG-V2.w3x'
LABEL='FFERPG V2'
STATS={'nsbm':(40,2500,39,173,196),'nspr':(30,1000,25,125,134)}
ICONS={}
BLANK='war3mapImported\\NoAuraV2.mdx'
def objects2(v):
 u=all_objects(v,'w3u');old=all_objects(v,'w3a');oldb=all_objects(v,'w3h');a={};b={}
 def passive(raw,name,desc,icon):
  o=ability(raw,'AIev',name,desc,icon);mod(o,'Eev1',0.,1);a[raw]=o;return o
 def status(raw,buff,name,desc,icon,art,duration):
  o=ability(raw,'Acrs',name,desc,icon,target='air,ground,friend,enemy,self,organic,mechanical',cast_range=99999.)
  setf(o,'Crs\0',0.,1,data=1)
  for key,val in [('abuf',buff),('adur',duration),('ahdu',duration),('acat',BLANK),('atat',BLANK)]:mod(o,key,val,0 if key in ['acat','atat'] else 1)
  a[raw]=o;bb={'base':'Bcrs','id':buff,'sets':[{'flag':0,'mods':[]}]}
  for key,val in [('fnam',name),('ftip',name),('fube',desc),('fart','ReplaceableTextures\\CommandButtons\\'+icon),('ftat',art),('fta0','origin')]:setf(bb,key,val,0)
  b[buff]=bb
 for raw in ['hEA0','nAU8','zTH9']:
  a[raw]=copy.deepcopy(old[raw])
  for field in ['acat','atat','asat','aeat','aaea']:mod(a[raw],field,BLANK,0)
 for raw in ['bE90','bMP8','bTH9']:
  b[raw]=copy.deepcopy(oldb[raw]);setf(b[raw],'ftat',BLANK,0)
 a['nMI8']=copy.deepcopy(old['nMI8']);mod(a['nMI8'],'acdn',60.,1)
 # Native carrier lasts35s; a tracked one-shot removes each image exactly at30s without granting inheritance.
 for field in ['adur','ahdu']:mod(a['nMI8'],field,35.,1)
 mod(a['nMI8'],'aub1','Creates two nearby images for 30 seconds. Each deals 25% damage and takes 50% extra damage. Each image killed by an enemy before expiring grants the living original +50% attack speed, +1500 maximum/current health and +120 attack damage. Expiration or removal grants no bonuses. 150 mana; 60-second cooldown.',1)
 a['zAP9']=copy.deepcopy(old['zAP9']);mod(a['zAP9'],'acdn',0.,1);mod(a['zAP9'],'aub1','Root as a ranged tower: 451-512 siege damage at 1000 range; takes 25% increased damage. Stays rooted until manually uprooted or its target moves out of range. It can uproot, reposition and root again. Uprooted attack: 351-362 damage at 128 range.',1)
 a['zEG9']=copy.deepcopy(old['zEG9']);mod(a['zEG9'],'atp1','Brood Shell',1);mod(a['zEG9'],'aub1','Carries an egg sac on its back. After 10 seconds it hatches into three permanent Broodlings. Killing Mother Spider before hatching cancels the pending egg wave; her normal death split still releases three Broodlings. The eggs have no separate health or shield. 150 mana; 30-second cooldown.',1)
 a['zCV9']=channel('zCV9','Cover Archers','Protect allied Corrupted Archers within 800 for 30 seconds, taking 50% of the damage they would receive. Only one nearby guardian absorbs each hit. The rooted Ancient of War still takes 25% extra damage. 45-second cooldown.','BTNDefend.blp','defend',0,45.,0)
 for key,val in [('Ncl3',1),('acat',BLANK),('atat',BLANK),('aeat',BLANK),('asat',BLANK),('Ncl5',0)]:mod(a['zCV9'],key,val,1 if key.startswith('Ncl') else 0)
 status('dCB2','bCB2','Cover Archers','Protecting allied Corrupted Archers within 800; absorbs 50% of incoming damage.','BTNDefend.blp',r'Abilities\Spells\Human\Defend\DefendCaster.mdl',30.)
 passive('dPV2','Broodling Venom','35% chance per landed attack against a hero to add a poison stack. Every stack ticks independently for five seconds.|n|n|cffffcc00Damage Calculation|r|nEach stack: 100 + 5 x poisoned hero level damage per second, for five ticks. Separate applications add damage instead of refreshing a single stack.','BTNPoisonSting.blp')
 passive('dSP2','Split into Spiderlings','On death, releases two permanent Spiderlings. In creature review, select a Broodling and type -split.','BTNSpiderBlack.blp')
 passive('dDR2','Spiderling Death Roar','On death, permanently grants +5% attack speed to allied Mother Spiders and Broodlings within 1000. Stacks with other Spiderling deaths and obeys Warcraft attack-speed limits. Other creature types receive no bonus.','BTNBattleRoar.blp')
 o=ability('dFR2','AIsx','Spider Family Fury','Permanent attack speed gained from nearby Spiderling deaths: +5% per death, stacking; normal attack-speed cap applies.','BTNBattleRoar.blp');mod(o,'alev',128,0)
 for rank in range(1,129):mod(o,'Isx1',.05*rank,rank)
 a['dFR2']=o
 status('dPB2','bPV2','Broodling Poison','Poison stacks deal 100 + 5 x poisoned hero level damage per second per stack. Each stack lasts five ticks.','BTNPoisonSting.blp',r'Abilities\Weapons\PoisonSting\PoisonStingTarget.mdl',6.)
 # Native Inferno owns the meteor delay, impact and summon, so the unit cannot appear before landing.
 o=ability('zIF9','ANin','Summon Forest Infernal','An Infernal meteor falls at the target point. On landing after 1.5 seconds, deals 2000 fire damage within 300 and creates a level 45 Infernal for 60 seconds: 4000 HP, 20 Demon armor, 200-243 chaos damage and Demon\'s Contest. 300 mana; 60-second cooldown.','BTNInfernal.blp',60.,300,area=300.,cast_range=800.)
 for key,val in [('Uin1',2000.),('Uin2',60.),('Uin3',1.5),('Uin4','qI99'),('adur',0.),('ahdu',0.)]:mod(o,key,val,1)
 a['zIF9']=o
 for raw,(level,hp,armor,low,high) in STATS.items():
  for key,val in [('unam','Broodling' if raw=='nsbm' else 'Spiderling'),('utip','Broodling' if raw=='nsbm' else 'Spiderling'),('ulev',level),('uhpm',hp),('udef',float(armor)),('ua1b',low-1),('ua1d',1),('ua1s',high-low+1),('uabi','dPV2,dSP2' if raw=='nsbm' else 'dDR2'),('utyp',''),('uacq',1000.),('utub',f'Normal level {level}; {hp} HP; {armor} armor; {low}-{high} attack damage. Permanent creature; no timed life. '+('Broodling Venom: 35% chance per landed hit to poison a hero for (100 + 5 x hero level) per second per stack, for five seconds. On death, releases two Spiderlings.' if raw=='nsbm' else 'Death Roar: allied Mother Spiders and Broodlings within 1000 gain permanent +5% attack speed per death; stacks.'))]:setf(u[raw],key,val,None)
 for key,val in [('ubui',''),('utyp','')]:setf(u['qL99'],key,val,None)
 # Predeclare the ranged weapon instead of relying on a runtime range-cache update.
 for key,val in [('uaen',2),('ua1r',1000.),('ua1w','missile'),('ua1m',r'Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl'),('ua1z',900),('ua1g','air,ground,structure,ward,item,debris'),('ua2b',350),('ua2d',1),('ua2s',12),('ua2r',128.),('ua2w','normal'),('ua2t','siege'),('ua2c',.9),('udp2',.5),('ubs2',.4),('ua2g','ground,structure,ward,item,debris'),('ua2m',''),('uacq',1000.)]:setf(u['n00O'],key,val,None)
 for raw in ['n00O','n00N','n00P']:setf(u[raw],'umvs',270,None)
 for raw,skill in [('n00O','zAP9'),('n010','zEG9'),('n00N','zCV9'),('nsth','zIF9'),('nwgs','nMI8')]:
  desc=fields(u[raw]).get(('utub',None),'');oldtext=fields(old[skill]).get(('aub1',1),'');newtext=fields(a[skill])['aub1',1]
  setf(u[raw],'utub',desc.replace(oldtext,newtext) if oldtext in desc else desc+'|n'+newtext,None)
 for raw in ['dPV2','dSP2','dDR2','dFR2','dPB2','dCB2']:assert raw not in old,raw
 result={raw:u[raw] for raw in ['nsbm','nspr','qL99','n00O','n00N','n00P','n010','nsth','nwgs']}
 icyu,icya,icyb=v2_icy.objects(v);result.update(icyu);a.update(icya);b.update(icyb)
 marshu,marsha,marshb=v2_marsh.objects(v);result.update(marshu);a.update(marsha);b.update(marshb)
 return result,a,b

def sort2(s):
 helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_','M89_','H90_','C95_','R93_','C97_','N98_','F99_','D2_','I2_','M2_')) and not n.endswith(('UpdateSpawnTimer','BioMana'))}
 if not helpers:return s
 names=set(helpers);deps={n:(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',re.sub(r'"(?:\\.|[^"\\])*"','""',b)))|set(re.findall(r'\bfunction\s+(\w+)',b)))&names-{n} for n,b in helpers.items()};ordered=[];todo=list(helpers)
 while todo:
  ready=[n for n in todo if not deps[n]-set(ordered)];assert ready,todo
  for n in ready:ordered.append(n);todo.remove(n)
 start=min(s.index(b) for b in helpers.values());prefix=s[:start];tail=s[start:]
 for b in helpers.values():tail=tail.replace(b,'',1)
 return prefix+'\n\n'.join(helpers[n] for n in ordered)+'\n'+tail

def refresh2(s):
 fs=functions(s)
 for n,b in fs.items():
  t=b
  if n=='Forest86_Init':t=t.replace(' set F99Data=InitHashtable()',' set D2Data=InitHashtable()\n set D2Poison=InitHashtable()\n set D2Watch=CreateGroup()\n set F99Data=InitHashtable()',1)
  if n=='Forest86_Entered':t=t.replace(' call F99_Track(u)',' call F99_Track(u)\n call D2_Track(u)',1)
  if n=='Forest86_Initial':t=t.replace(' call F99_Track(GetEnumUnit())',' call F99_Track(GetEnumUnit())\n call D2_Track(GetEnumUnit())',1)
  if n=='Forest86_Death':t=t.replace(' call F99_Death(u)',' call N98_ImageDeath(u)\n call D2_Death(u)\n call F99_Death(u)',1)
  if n=='Forest86_OnAttack':t=t.replace(' call F99_OnHit(attacker,victim)',' call F99_OnHit(attacker,victim)\n call D2_OnHit(attacker,victim)',1)
  if n=='Forest86_Spell':t=t.replace(' call F99_Spell(caster,victim,raw)',' call F99_Spell(caster,victim,raw)\n call D2_Spell(caster,raw)',1)
  if n=='F99_Cleanup':t=t.replace(' call F99_RootEnd(u)',' call D2_Cleanup(u)\n call F99_RootEnd(u)',1)
  if n=='F99_Tick':t=t.replace(' call ForGroup(F99Active',' call D2_Tick()\n call ForGroup(F99Active',1)
  if n=='F99_Active':t=t.replace(' return '," if key==10 and GetUnitTypeId(u)=='n00O' and F99Data!=null and HaveSavedReal(F99Data,GetHandleId(u),10) then\n return true\n endif\n return ",1)
  if n=='F99_Root':t=t.replace(' call GroupAddUnit(F99Active,u)',' call D2_RootWeapons(u,true)\n call GroupAddUnit(F99Active,u)',1)
  if n=='F99_RootEnd':
   t=t.replace(' call SetUnitMoveSpeed(u,LoadReal(F99Data,id,13))'," call UnitAddAbility(u,'Amov')\n if LoadReal(F99Data,id,13)<=0. then\n call SaveReal(F99Data,id,13,GetUnitDefaultMoveSpeed(u))\n endif\n call SetUnitMoveSpeed(u,LoadReal(F99Data,id,13))\n call D2_RootWeapons(u,false)",1)
   t=t.replace(" if LoadBoolean(F99Data,id,17) then\n call UnitAddAbility(u,'Amov')\n endif",'')
  if n=='F99_AI':t=t.replace(' if F99_Active(u,10)'," if raw=='n00N' and not IsUnitIllusion(u) and Forest86_Ready(u,'zCV9',0) and D2_ArcherNear(u) then\n call IssueImmediateOrder(u,\"defend\")\n return\n endif\n if raw=='n00O' and victim==null then\n set victim=D2_FindEnemy(u,1000.)\n endif\n if F99_Active(u,10)",1)
  if n=='F99_Cover':t=t.replace("and GetUnitAbilityLevel(u,'zCV9')>0 then","and GetUnitAbilityLevel(u,'zCV9')>0 and D2_Active(u,60) then",1)
  if n=='F99_Brood':t='''function F99_Brood takes unit shell returns nothing
 if LoadBoolean(F99Data,GetHandleId(shell),23) then
 return
 endif
 call SaveBoolean(F99Data,GetHandleId(shell),23,true)
 call D2_SpawnOffspring(shell,'nsbm',3)
 call F99_LingerFx("Objects\\\\Spawnmodels\\\\Undead\\\\CryptFiendEggsack\\\\CryptFiendEggsack.mdl",GetUnitX(shell),GetUnitY(shell),1.5)
endfunction'''
  if n=='F99_Spell':
   start=t.index(" elseif raw=='zEG9' then");end=t.index(" elseif raw=='zDV9' then",start);t=t[:start]+t[end:]
  if n=='F99_VortexFx':
   t=t.replace('Abilities\\\\Spells\\\\Demon\\\\DarkPortal\\\\DarkPortalTarget.mdl','Abilities\\\\Spells\\\\Other\\\\Tornado\\\\TornadoElementalSmall.mdl')
   t=t.replace(' call BlzSetSpecialEffectScale(fx,1.4)',' call BlzSetSpecialEffectColor(fx,70,140,255)\n call BlzSetSpecialEffectMatrixScale(fx,2.5,2.5,.2)')
  if n=='N98_ImageDeath':t=t.replace(' if Forest86_Alive(parent) then',' if Forest86_Alive(parent) and not LoadBoolean(N98Data,id,32) and GetKillingUnit()!=null and IsUnitEnemy(GetKillingUnit(),GetOwningPlayer(parent)) then',1)
  if n in ['N98_Summoned','N98_BindImages']:t=t.replace(' call SaveUnitHandle(N98Data,GetHandleId(child),30,parent)',' call SaveUnitHandle(N98Data,GetHandleId(child),30,parent)\n call D2_ImageLife(child)',1)
  if n=='N98_Cleanup':t=t.replace(' call N98_ImageDeath(u)',' call D2_ImageCancel(u)\n call D2_Cleanup(u)',1)
  if n=='Element_GetOfUnit':t=t.replace('    if(l_isPhysical)then',"    if not l_isPhysical and GetUnitTypeId(u)=='nsth' then\n        return 1\n    endif\n    if(l_isPhysical)then",1)
  # Forest Devour predates generic removal cleanup; reclaim bearer art before consuming its victim.
  if n=='Forest86_Spell':t=t.replace(' call RemoveUnit(victim)',' call D2_Cleanup(victim)\n call RemoveUnit(victim)')
  if t!=b:s=put(s,n,t)
 if 'RegisterTriggers_MonsterData' in fs:
  frag=(ROOT/'experiments/V2/V2.j').read_text();g=re.search(r'globals\n(.*?)endglobals',frag,re.S)
  s=s.replace('endglobals',g[1]+'endglobals',1).replace('function RegisterTriggers_MonsterData takes',frag[g.end():].strip()+'\nfunction RegisterTriggers_MonsterData takes',1)
 return sort2(v2_marsh.refresh(v2_icy.refresh(s)))

def main():
 package.BASE=BASE;package.OUT=OUT;package.LABEL=LABEL;package.STATS=STATS;package.ICONS=ICONS
 package.objects95=objects2;package.refresh95=refresh2
 write=package.write_files
 assets={'war3mapImported\\NoAuraV2.mdx':(ROOT/'experiments/V2/Assets/NoAuraV2.mdx').read_bytes()}
 def write_assets(src,dest,files):
  files.update(assets);imp=MPQ(str(src)).read('war3map.imp');version,count=struct.unpack_from('<II',imp)
  entries=[]
  for name in assets:
   assert name.encode()+b'\0' not in imp
   entries.append(bytes([13])+name.encode()+b'\0')
  files['war3map.imp']=struct.pack('<II',version,count+len(entries))+imp[8:]+b''.join(entries)
  return write(src,dest,files)
 package.write_files=write_assets;package.build()
 for name,data in assets.items():assert MPQ(str(OUT)).read(name)==data
 p=OUT.with_suffix('.json');r=json.loads(p.read_text());r.update(new_polling_timers='None. Reuses existing 1Hz monster heartbeat; image expiration uses one-shot timers.',assets=list(assets));p.write_text(json.dumps(r,indent=2))
if __name__=='__main__':main()
