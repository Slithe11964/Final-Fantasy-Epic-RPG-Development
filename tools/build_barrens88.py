"""Full Dragoon Barrens/forest role prototype, isolated from normal/classic releases."""
from build_forest87 import *
from build_forest86 import ability,channel,mod
BASE=ROOT/'release/development/QuickUI87/FFERPG-QuickUI87.w3x'
OUT=ROOT/'release/development/QuickUI88/FFERPG-QuickUI88.w3x'
RAW='ndtr ngnb nbld nspb nban nqbh nowe nowb nrzb nrzg nltl nthl nstw nrzt nrzs nrzm nhrw nhrr nhrq n0L0 ncea ncen ncer ncim ncks ncnk nhar nhrh'.split()
STATS={
 'nqbh':(12,1000,27,35,44,500),'nowe':(10,1500,None,None,None,None),'nowb':(8,1000,None,None,None,None),
 'nrzb':(9,800,None,35,42,None),'nrzg':(11,1100,None,50,57,None),'nltl':(7,None,30,44,45,None),
 'nthl':(10,900,44,None,None,None),'nstw':(12,1700,None,60,65,None),'nrzt':(8,750,24,33,37,None),
 'nrzs':(7,800,22,25,30,None),'nrzm':(10,None,20,None,None,None),'nhrw':(7,700,5,30,33,None),
 'nhrr':(9,600,20,None,None,None),'nhrq':(10,800,10,None,None,None),'n0L0':(12,None,10,None,None,None),
 'ncea':(7,900,15,30,40,None),'ncen':(9,None,None,28,38,None),'ncer':(7,1000,None,20,32,None),
 'ncim':(9,None,21,30,35,None),'ncks':(9,None,None,None,None,None),'ncnk':(11,1600,50,None,None,None),
 'nhar':(7,600,3,23,27,None),'nhrh':(8,None,6,None,None,None)}
def objects(v):
 units=all_objects(v,'w3u');old=all_objects(v,'w3a');new={}
 def ch(raw,name,desc,order,target=1,cd=15.,mana=0,area=0.,reach=600.):
  new[raw]=channel(raw,name,desc,'BTN'+{'Devour Barrens Creature':'Devour','Taunt':'Taunt','Rapid Fire':'SearingArrows'}.get(name,'BattleRoar')+'.blp',order,target,cd,mana,area,reach);return new[raw]
 def native(raw,base,name,desc,cd=15.,mana=0,**data):
  new[raw]=ability(raw,base,name,desc,'BTN'+{'Heal':'Heal','Faith':'InnerFire','Fog':'SpiritOfVengeance','Chain Lightning':'ChainLightning','Faerie Fire':'FaerieFire','Rejuvenation':'Rejuvenation','Mana Burn':'ManaBurn','Steady Shot':'StormBolt','Trueshot Aura':'TrueShot','Rage':'BerserkForTrolls'}.get(name,'BattleRoar')+'.blp',cd,mana)
  for k,val in data.items():mod(new[raw],k,val,1)
  return new[raw]
 ch('bD88','Devour Barrens Creature','Consume another Barrens pool creature to unlock Rapid Fire. Cannot consume heroes or special quest units. Costs 250 mana. Cooldown: 15 seconds.','devour',mana=250,reach=350.)
 # Clone the Archer's channel, preserving its order/channel duration and 16-arrow emitter.
 new['bR88']=copy.deepcopy(old['A0AE']);new['bR88']['id']='bR88'
 for st in new['bR88']['sets']:
  st['mods']=[m for m in st['mods'] if (m.get('level') or 0)<=1]
 for k,val in {'alev':1,'aher':0,'amcs':100,'acdn':20.,'anam':'Rapid Fire','atp1':'Rapid Fire','aub1':'Rapidly fires 16 explosive arrows after devouring a Barrens creature.|n|n|cffffcc00Damage Calculation|r|nEach arrow: 93.75%-100% of (0.02 x maximum health + base attack damage). Costs 100 mana. Cooldown: 20 seconds.'}.items():mod(new['bR88'],k,val)
 native('bAUR','AEar','Trueshot Aura','Nearby ranged allies deal 15% increased attack damage. Radius: 600.',0.,0,Ear1=.15,Ear2=0,Ear3=1,Ear4=0,aare=600.,atar='air,ground,friend,self')
 ch('bT88','Taunt','Forces nearby enemies to attack for 3 seconds. Reflects 10% of physical and spell damage received for 5 seconds. Cooldown: 20 seconds. Radius: 450.','roar',0,20.,area=450.,reach=0.)
 ch('bK88','Taunt','Forces nearby enemies to attack for 3 seconds. Grants 50 armor for 15 seconds. Costs 150 mana. Cooldown: 30 seconds. Radius: 450.','roar',0,30.,150,450.,0.)
 native('bA88','AId1','Taunt Armor','Armor increased by 50.',0.,0,Idef=50)
 native('bX88','AIsx','Trampled','Attack speed reduced by 25% for 5 seconds.',0.,0,Isx1=-.25)
 ch('bW88','Weakening Shout','Nearby enemies deal 20% less physical and magical damage for 5 seconds. Radius: 450. Cooldown: 30 seconds.','howlofterror',0,30.,area=450.,reach=0.)
 ch('bV88','War Shout','Nearby enemies take 10% increased damage for 10 seconds. Radius: 450. Cooldown: 20 seconds.','howlofterror',0,20.,area=450.,reach=0.)
 ch('bB88','Swipe','Swipes the target and causes bleeding.|n|n|cffffcc00Damage Calculation|r|nPhysical damage: 300. Bleed: 1% of target maximum health per second for 3 seconds. Cooldown: 15 seconds.','cripple',reach=180.)
 ch('bG88','Charging Strike','Dash to the target and reduce its evasion by 10% for 5 seconds. Costs 50 mana. Cooldown: 15 seconds.','acidbomb',mana=50)
 ch('bC88','Trample','Dash to the target, dealing 400 physical damage and reducing attack speed by 25% for 5 seconds. Cooldown: 20 seconds.','acidbomb',cd=20.)
 ch('bQ88','Quill Darts','Shoot three quill darts at the target.|n|n|cffffcc00Damage Calculation|r|n3 x 120 physical damage. Costs 50 mana. Cooldown: 15 seconds.','shadowstrike',mana=50)
 native('bY88','AHtb','Quill Dart','Physical damage: 120 per dart.',0.,0,Htb1=1.,adur=.001,ahdu=.001,aran=99999.)
 mod(new['bY88'],'amat','Abilities\\Weapons\\BristleBackMissile\\BristleBackMissile.mdl',0)
 native('bS88','AHtb','Steady Shot','Shoots an arrow, stunning the target for 2 seconds. Cooldown: 15 seconds.|n|n|cffffcc00Damage Calculation|r|n100 spell damage.',Htb1=100.,adur=2.,ahdu=2.)
 mod(new['bS88'],'amat','Abilities\\Weapons\\Arrow\\ArrowMissile.mdl',0)
 native('bZ88','Absk','Rage','Increases attack speed by 80% and damage taken by 25% for 10 seconds. Cooldown: 30 seconds.',30.,0,bsk1=0.,bsk2=.8,bsk3=.25,adur=10.,ahdu=10.)
 native('bH88','Ahea','Heal','Autocast: restores 75 health to a friendly ally. Costs 50 mana. Cooldown: 1 second.',1.,50,Hea1=75.,atar='air,ground,friend,organic,vulnerable')
 native('bL88','ACcl','Chain Lightning','Deals 450 spell damage to the primary target. Costs 120 mana. Cooldown: 30 seconds.',30.,120,Ocl1=450.,Ocl2=1)
 native('bI88','ACls','Lightning Shield','Deals 40 spell damage per second around the shielded unit. Costs 75 mana. Cooldown: 15 seconds.',15.,75,Lsh1=40.,adur=20.,ahdu=20.,atar='air,ground,friend,self')
 native('bM88','ACt2','Slam','Deals 100 damage and slows nearby enemies movement and attack speed by 33% for 5 seconds. Radius: 250. Cooldown: 15 seconds.',Ctc1=100.,Ctc2=0.,Ctc3=.33,Ctc4=.33,adur=5.,ahdu=5.,aare=250.)
 for raw,base,name,desc,mana in [('bF88','A0N0','Faith','Increases an ally\'s magic damage by 50% for 15 seconds. Costs 150 mana. Cooldown: 30 seconds.',150),('bO88','A1FM','Fog','Reduces an enemy\'s magic damage by 33% for 20 seconds. Dispels Faith. Costs 50 mana. Cooldown: 30 seconds.',50)]:
  new[raw]=copy.deepcopy(old[base]);new[raw]['id']=raw
  for st in new[raw]['sets']:st['mods']=[m for m in st['mods'] if (m.get('level') or 0)<=1]
  for k,val in {'alev':1,'aher':0,'amcs':mana,'acdn':30.,'adur':15. if raw=='bF88' else 20.,'ahdu':15. if raw=='bF88' else 20.,'anam':name,'atp1':name,'aub1':desc}.items():mod(new[raw],k,val)
 # Trickster already owns Curse/Pain. A separate channel order selects Fog
 # unambiguously, with its native buff applied by the existing simple dummy.
 new['bOF8']=copy.deepcopy(new['bO88']);new['bOF8']['id']='bOF8';mod(new['bOF8'],'amcs',0,1);mod(new['bOF8'],'acdn',0.,1);mod(new['bOF8'],'aran',99999.,1)
 ch('bO88','Fog','Reduces an enemy\'s magic damage by 33% for 20 seconds. Dispels Faith. Costs 50 mana. Cooldown: 30 seconds.','drunkenhaze',1,30.,50)
 native('bE88','ACff','Faerie Fire','Reduces armor by 8. Costs 35 mana. Cooldown: 5 seconds.',5.,35,Fae1=8,adur=30.,ahdu=30.)
 native('bJ88','ACr2','Rejuvenation','Restores 600 health over 9 seconds. Costs 75 mana. Cooldown: 15 seconds.',15.,75,Rej1=600.,Rej2=0.,adur=9.,ahdu=9.,atar='air,ground,friend,self,organic,vulnerable')
 native('bN88','Ambd','Mana Burn','Burns up to 200 mana and deals matching damage. Costs 50 mana. Cooldown: 15 seconds.',15.,50,Emb1=200.)
 native('bU88','Ainf','Sharp Aim','Autocast: grants an ally +30 accuracy for 20 seconds. Costs 100 mana. Cooldown: 30 seconds.',30.,100,Inf1=0.,Inf2=0,Inf3=0.,adur=20.,ahdu=20.,atar='air,ground,friend,self,organic,vulnerable')
 native('bP88','AIev','Venomous Attack','33% chance on a landed attack to poison a hero for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n10 + 3 x poisoned hero level damage per second. Non-stacking; equal/stronger applications refresh.',0.,0,Eev1=0.)
 native('bBL8','AIev','Guard','15% chance to block physical damage. 10% chance to block magical damage.',0.,0,Eev1=0.)
 native('bBN8','AIev','Guard','25% chance to block physical damage. 15% chance to block magical damage.',0.,0,Eev1=0.)
 native('bBW8','AIev','Guard','15% chance to block physical damage.',0.,0,Eev1=0.)
 new['bAL8']=copy.deepcopy(old['fL86']);new['bAL8']['id']='bAL8';mod(new['bAL8'],'aub1','On attacking a hero or taking hero damage, calls reinforcements for 15 seconds. Kill this harpy to cancel. Final 5-4-3-2-1 countdown. Doubles Barrens spawn frequency, wave size and population cap for 60 seconds. Once per harpy.',1)
 stock={r['unitAbilID']:r for r in slk((ROOT/'tools/build-inputs/unitabilities.slk').read_bytes())}
 def ua(raw,add=(),remove=()):
  o=units[raw];f=fields(o);ab=[x for x in f.get(('uabi',None),stock.get(o['base'],{}).get('abilList','')).split(',') if len(x)==4 and x not in remove]
  for x in add:
   if x not in ab:ab.append(x)
  setf(o,'uabi',','.join(ab),None)
 for raw,(lv,hp,armor,lo,hi,mana) in STATS.items():
  for k,val in {'ulev':lv,'uhpm':hp,'udef':float(armor) if armor!=None else None,'umpm':mana,'umpi':mana}.items():
   if val!=None:setf(units[raw],k,val,None)
  if lo!=None:
   for k,val in {'ua1b':lo-1,'ua1d':1,'ua1s':hi-lo+1}.items():setf(units[raw],k,val,None)
 adds={'ndtr':['A03N'],'nspb':['bP88'],'nban':['bBN8'],'nbld':['bBL8'],'nqbh':['bD88','bAUR'],'nowe':['bT88','bBW8'],'nowb':['bW88'],'nrzb':['bB88'],'nrzg':['bG88'],'nltl':['bL88'],'nthl':['bL88','bI88','bM88'],'nstw':['bF88'],'nrzt':['bQ88'],'nrzs':['A03N'],'nrzm':['bH88'],'nhrw':['bE88'],'nhrr':['bAL8'],'nhrq':['bJ88','bE88','bN88'],'n0L0':['bO88'],'ncea':['bS88'],'ncen':['bC88'],'ncer':['bV88'],'ncim':['bZ88'],'ncks':['bU88'],'ncnk':['bK88']}
 removes={'nltl':['ACcl'],'nthl':['ACcl','ACls','ACt2'],'nstw':['ACcl','ACls'],'nhrw':['ACff'],'nhrq':['Acht','ACcr','ACr2','ACff','Ambd']}
 for raw,add in adds.items():ua(raw,add,removes.get(raw,()))
 for raw,auto in [('nrzm','bH88'),('ncks','bU88')]:setf(units[raw],'udaa',auto,None)
 # Supply usable mana where a newly assigned mana-cost spell lacked a pool.
 for raw in ['nrzm','ncks','ncnk']:
  if fields(units[raw]).get(('umpm',None),0)<300:setf(units[raw],'umpm',500,None);setf(units[raw],'umpi',500,None)
 changed={'fT86':copy.deepcopy(old['fT86']),'fE86':copy.deepcopy(old['fE86'])}
 mod(changed['fT86'],'aub1','Forces nearby enemies to attack this gnoll for 3 seconds and grants 70 increased evasion for 10 seconds. Costs 25 mana. Cooldown: 20 seconds. Radius: 450.',1)
 mod(changed['fE86'],'aub1','Increases evasion by 80 for 10 seconds. Cooldown: 30 seconds.',1)
 assert not set(new)&set(old)
 for raw in RAW:
  o=units[raw];f=fields(o);parts=[]
  if raw in STATS:parts.append('Normal base stats: level '+str(STATS[raw][0])+'.')
  for a in f.get(('uabi',None),'').split(','):
   if a in new or a in changed:parts.append(fields((new|changed)[a]).get(('aub1',1),''))
  if raw in ['ndtr','nrzs']:parts.append('Night Might: +60% outgoing damage and 37.5% less incoming damage from 18:00 to 06:00.')
  setf(o,'utub','|n|n'.join(parts) or f.get(('utub',None),''),None)
 return units,new|changed

def refresh88(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n=='Forest86_Actor':new=new.replace("return raw==",'return B88_Actor(raw) or raw==',1)
  if n=='Forest86_Track':new=new.replace(" if GetUnitTypeId(u)=='nfsp' then",''' if GetUnitTypeId(u)=='nrzm' then
 call IssueImmediateOrder(u,"healon")
 elseif GetUnitTypeId(u)=='ncks' then
 call SaveBoolean(Forest86Data,GetHandleId(u),49,true)
 call IssueImmediateOrder(u,"innerfireon")
 endif
 if GetUnitTypeId(u)=='nfsp' then''')
  if n=='Forest86_Init':new=new.replace(' set Forest86Actors=CreateGroup()',' set B88Buffs=CreateGroup()\n set B88Charges=CreateGroup()\n set B88ChargeTimer=CreateTimer()\n set Forest86Actors=CreateGroup()')
  if n=='Forest86_Death':new=new.replace('and not IsUnitInGroup(u,Forest86Taunted) then','and not IsUnitInGroup(u,Forest86Taunted) and not IsUnitInGroup(u,B88Buffs) and not IsUnitInGroup(u,B88Charges) then');new=new.replace("GetUnitTypeId(u)=='nmrl'", "(GetUnitTypeId(u)=='nmrl' or GetUnitTypeId(u)=='nhrr')");new=new.replace(' call FlushChildHashtable'," call GroupRemoveUnit(B88Buffs,u)\n call UnitRemoveAbility(u,'bA88')\n call UnitRemoveAbility(u,'bX88')\n call FlushChildHashtable")
  if n=='Forest86_SpawnFactor':new=new.replace(' return 1',' if zone==2 and B88AlertUntil>Forest86Now then\n return 2\n endif\n return 1')
  if n=='Forest86_Alert':new=new.replace("GetUnitTypeId(u)!='nmrl'", "(GetUnitTypeId(u)!='nmrl' and GetUnitTypeId(u)!='nhrr')").replace('not Forest86_InForest(u)',"not B88_InZone(u,B88_AlertZone(u))")
  if n=='Forest86_AI':
   new=new.replace(' set Forest86AlertUntil=Forest86Now+60.'," if raw=='nhrr' then\n set B88AlertUntil=Forest86Now+60.\n set B88AlertActive=true\n call ExecuteFunc(\"B88_UpdateSpawnTimer\")\n else\n set Forest86AlertUntil=Forest86Now+60.").replace(' call ExecuteFunc("Forest86_UpdateSpawnTimer")',' call ExecuteFunc("Forest86_UpdateSpawnTimer")\n endif')
   new=new.replace(" if raw=='nfsh' and Forest86_Ready", " if B88_Actor(raw) then\n call B88_AI(u,victim)\n elseif raw=='nfsh' and Forest86_Ready",1)
   # Support heal/buffs/devour even without a hostile target, avoid calling twice.
   new=new.replace(' if victim!=null then\n if B88_Actor(raw)', ' if victim!=null or B88_Actor(raw) then\n if B88_Actor(raw)')
   new=new.replace(' or udg_InCinematicMode then',' or udg_InCinematicMode or LoadBoolean(Forest86Data,id,65) then')
  if n=='Forest86_Taunt':new=new.replace('22,Forest86Now+15.','22,Forest86Now+10.')
  if n=='Forest86_Evasion':new=new.replace('return 40.','return 70.',1);pos=new.index("GetUnitTypeId(u)=='nbld'");new=new[:pos]+new[pos:].replace('return 40.','return 80.',1)
  if n=='Forest86_OnAttack':
   new=new.replace(' local integer chance=0',' local integer chance=0\n local integer base=5\n local real duration=5.')
   new=new.replace(" elseif raw=='nbrg' then"," elseif raw=='nspb' then\n set chance=33\n set coefficient=3\n set base=10\n set duration=10.\n elseif raw=='nbrg' then")
   new=new.replace('Forest86_PoisonDamage(GetHeroLevel(victim),coefficient)','I2R(base+coefficient*GetHeroLevel(victim))').replace('12,Forest86Now+5.','12,Forest86Now+duration')
  if n=='Forest86_Spell':new=new.replace(' set spawned=null\n set caster=null',' call B88_Spell(caster,victim,raw)\n set spawned=null\n set caster=null')
  if n=='Forest86_Order':new=new.replace(' if not Forest86OrderGuard', ''' if GetUnitTypeId(victim)=='ncks' then
 if GetIssuedOrderId()==OrderId("innerfireon") then
 call SaveBoolean(Forest86Data,id,49,true)
 elseif GetIssuedOrderId()==OrderId("innerfireoff") then
 call SaveBoolean(Forest86Data,id,49,false)
 endif
 endif
 if not Forest86OrderGuard''',1)
  if n=='Forest86_Tick':new=new.replace(' call ForGroup(Forest86Actors', ' call ForGroup(B88Buffs,function B88_BuffTick)\n if B88AlertActive and Forest86Now>=B88AlertUntil then\n set B88AlertActive=false\n call ExecuteFunc("B88_UpdateSpawnTimer")\n endif\n call ForGroup(Forest86Actors',1)
  if n=='Trig_Damage_Engine_RollBlock':
   anchor='    // A random';pos=new.index(anchor);new=new[:pos]+'''    if B88_BlockChance(u,l_physical,l_magical)>0 and GetRandomInt(1,100)<=B88_BlockChance(u,l_physical,l_magical)-reduction then
        return true
    endif
'''+new[pos:]
  if n in ['Trig_Damage_Engine_GetAccuracy','Forsaken_Stat_GetAccuracy','Stats_Stat_GetAccuracy']:
   pos=new.rfind('    return ');new=new[:pos]+'    if B88_Active(u,44) then\n        set l_acc=l_acc+30.\n    endif\n'+new[pos:]
  if n in ['Trig_Damage_Engine_GetEvasion','Forsaken_Stat_GetEvasion','Stats_Stat_GetEvasion']:
   pos=new.rfind('    return ');new=new[:pos]+'    if B88_Active(u,43) then\n        set l_eva=l_eva*.9\n    endif\n'+new[pos:]
  if n=='Trig_Damage_Engine_Step18_FinalModifiers':
   pos=new.index('    if l_amount>0. and not l_heal then');new=new[:pos]+'''    if l_amount>0. and not l_heal then
        if B88_Active(u,40) then
            set l_amount=l_amount*.8
        endif
        if B88_Active(t,41) then
            set l_amount=l_amount*1.1
        endif
    endif
'''+new[pos:]
  if n=='Trig_Damage_Engine_Actions':new=new.replace('        call BlzSetEventDamage(l_amount)','        call BlzSetEventDamage(l_amount)\n        call B88_Thorns(u,triggeringUnit,l_amount)',1)
  if n=='Trig_Spell_RapidFire_Conditions':new=new.replace('return(',"return(GetSpellAbilityId()=='bR88' or ",1)
  if n=='Trig_Spell_RapidFire_Actions':new=new.replace("    if(GetSpellAbilityId()=='A0AE')then", "    if GetSpellAbilityId()=='bR88' then\n        call SaveBoolean(Forest86Data,GetHandleId(triggeringUnit),65,true)\n        set udg_RapidFireDmg[d]=I2R(BlzGetUnitMaxHP(triggeringUnit))*.02+I2R(BlzGetUnitBaseDamage(triggeringUnit,0))\n    elseif(GetSpellAbilityId()=='A0AE')then",1)
  if n=='Trig_Spell_RapidFire_End_Actions':new=new.replace('endfunction',"    if GetSpellAbilityId()=='bR88' then\n        call RemoveSavedBoolean(Forest86Data,GetHandleId(GetTriggerUnit()),65)\n    endif\nendfunction")
  if n=='Trig_Faith_Target_Cleanup_IsFaithSpell':new=new.replace('return(',"return(GetSpellAbilityId()=='bF88' or GetSpellAbilityId()=='bO88' or GetSpellAbilityId()=='bOF8' or ",1)
  if n=='Trig_Zone_Spawn_System_SpawnZoneUnits':new=new.replace("GetUnitTypeId(l_spawned)=='nfsh'", "B88_Actor(GetUnitTypeId(l_spawned)) or GetUnitTypeId(l_spawned)=='nfsh'")
  if new!=b:s=put(s,n,new)
 if 'RegisterTriggers_MonsterData' in fs:
  fragment=(ROOT/'experiments/GuardiaForest/Barrens88.j').read_text();glob=re.search(r'globals\n(.*?)endglobals',fragment,re.S);s=s.replace('endglobals',glob[1]+'endglobals',1)
  extra='''function B88_AlertZone takes unit u returns integer
 if GetUnitTypeId(u)=='nhrr' then
 return 2
 endif
 return 1
endfunction
function B88_InZone takes unit u,integer zone returns boolean
 local integer i=1
 local rect area
 if GetUnitUserData(u)==zone then
 return true
 endif
 loop
 exitwhen i>LoadInteger(udg_SpawnDataHash,2,zone)
 set area=LoadRectHandle(udg_SpawnRectHash,zone,i)
 if area!=null and RectContainsCoords(area,GetUnitX(u),GetUnitY(u)) then
 set area=null
 return true
 endif
 set i=i+1
 endloop
 set area=null
 return false
endfunction
function B88_BlockChance takes unit u,boolean physical,boolean magical returns integer
 local integer raw=GetUnitTypeId(u)
 if physical then
 if raw=='nban' then
 return 25
 elseif raw=='nbld' or raw=='nowe' then
 return 15
 endif
 elseif magical then
 if raw=='nban' then
 return 15
 elseif raw=='nbld' then
 return 10
 endif
 endif
 return 0
endfunction
'''
  fragment=fragment[glob.end():].strip();update=functions(fragment)['B88_UpdateSpawnTimer'];fragment=fragment.replace(update,'')
  s=s.replace('function RegisterTriggers_MonsterData takes',extra+fragment+'\nfunction RegisterTriggers_MonsterData takes',1)
 if 'Trig_Zone_Spawn_System_ZoneRespawnTick' in fs:
  fragment=(ROOT/'experiments/GuardiaForest/Barrens88.j').read_text();update=functions(fragment)['B88_UpdateSpawnTimer']
  s=s.replace('function Forest86_UpdateSpawnTimer takes',update+'\nfunction Forest86_UpdateSpawnTimer takes',1)
 if 'RegisterTriggers_MonsterData' in fs:
  # JASS requires local helpers before their callers, in editor source and runtime.
  helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_')) and not n.endswith('UpdateSpawnTimer')}
  names=set(helpers);deps={n:(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',re.sub(r'"(?:\\.|[^"\\])*"','""',b)))|set(re.findall(r'\bfunction\s+(\w+)',b)))&names-{n} for n,b in helpers.items()}
  ordered=[];remaining=list(helpers)
  while remaining:
   ready=[n for n in remaining if not deps[n]-set(ordered)]
   assert ready,('forest helper cycle',remaining)
   for n in ready:ordered.append(n);remaining.remove(n)
  start=min(s.index(b) for b in helpers.values());prefix=s[:start];tail=s[start:]
  for b in helpers.values():tail=tail.replace(b,'',1)
  s=prefix+'\n\n'.join(helpers[n] for n in ordered)+'\n'+tail
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);units,abil=objects(v);files={}
 for ext,replacements in [('w3u',{r:units[r] for r in RAW}),('w3a',abil)]:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;data=v.archive.read(name)
   if not data:continue
   t=read_objects(data,ext);seen=set()
   for table in ['original','custom']:
    if prefix=='war3map':
     for i,o in enumerate(t[table]):
      raw=o['id'] or o['base']
      if raw in replacements:t[table][i]=copy.deepcopy(replacements[raw]);seen.add(raw)
    else:t[table]=[o for o in t[table] if (o['id'] or o['base']) not in replacements]
   if prefix=='war3map':
    for raw,o in replacements.items():
     if raw not in seen:t['custom' if o['id'] else 'original'].append(copy.deepcopy(o))
   files[name]=write_objects(t,t['version'],ext)
 modules={lib:refresh88(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]}
 runtime=refresh88(v.runtime)
 # Use the edited module body for every changed existing function. Older runtime
 # functions sometimes retain JassHelper spacing, which must not skip an edit.
 for lib in changed:
  oldfs=functions(v.modules[lib])
  for n,b in functions(modules[lib]).items():
   if n in oldfs and tokens(b)!=tokens(oldfs[n]):runtime=put(runtime,n,b)
 runtime,moved=order(runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:
   source=modules[m[1]]
   if m[1]=='TSpellRapidFire':source=source.replace('requires TAbil, TMissile, TProf','requires TAbil, TMissile, TProf, TMonsterData')
   v.wct['entries'][i]=raw_of(source.replace('\n','\r\n'))
 w=wts_read(v.archive.read('war3map.wts'));label='FFERPG QuickUI88 (Barrens)';w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-3500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 a=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert a.read(name)==files.get(name,v.archive.read(name)),name
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),units=RAW,moved=moved,notes='Full Dragoon only; Normal authored stats, shared1Hz AI/buffs,activeonly10Hzcharges; native acceptance pending.'),indent=2));print(OUT)
if __name__=='__main__':build()
