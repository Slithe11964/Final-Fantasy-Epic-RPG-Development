"""QuickUI89: Northern Mountains prototype, injured stat-absorbing Devour, loot pickup fix."""
from build_barrens88 import *
from build_barrens88 import build as previous_build
from jtok import strip_comments
BASE=ROOT/'release/development/QuickUI88/FFERPG-QuickUI88.w3x'
OUT=ROOT/'release/development/QuickUI89/FFERPG-QuickUI89.w3x'
STATS={
 'nwiz':(10,1200,13,45,50,800),'nhfp':(12,1400,20,50,55,None),'n0MO':(15,2000,None,70,82,None),
 'nass':(13,None,None,None,None,None),'nban':(11,1500,42,50,64,None),'nbld':(18,2600,None,None,None,800),
 'nbrg':(14,1800,55,120,136,None),'nenf':(17,2400,66,None,None,None),'ngno':(12,1750,33,75,92,None),
 'ngns':(15,1400,36,100,122,None),'ngnv':(19,3150,62,150,164,None),'ngnw':(14,1500,32,106,136,None),
 'nhdc':(15,2200,30,79,92,None),'nhhr':(19,2300,27,120,135,None),'nkob':(10,1200,32,90,113,None),
 'nkog':(15,1500,42,72,89,None),'nkol':(18,2300,41,135,153,None),'nkot':(13,1500,22,None,None,None),
 'nogl':(20,3400,73,160,182,None),'nogm':(17,2200,None,120,134,None),'nogr':(13,1700,42,80,89,None),
 'nomg':(18,1600,33,72,83,None),'nrog':(13,1600,None,72,78,None),'nwzd':(20,3100,52,145,162,None),
 'nwzg':(18,2400,29,125,134,None),'nwzr':(14,1800,26,82,94,None)}
RAW=list(STATS)+['nfsh','nqbh','mH89']
DEVOUR_LIMIT=2  # Owner confirmed Nerubian Queen n02B's two-use limit.
def objects89(v):
 units=all_objects(v,'w3u');old=all_objects(v,'w3a');new={}
 def ch(raw,name,desc,order,target=0,cd=20.,mana=0,area=0.,reach=600.):
  new[raw]=channel(raw,name,desc,'BTNBattleRoar.blp',order,target,cd,mana,area,reach);return new[raw]
 def native(raw,base,name,desc,cd=15.,mana=0,**data):
  new[raw]=ability(raw,base,name,desc,'BTNBattleRoar.blp',cd,mana)
  for key,val in data.items():mod(new[raw],key,val,1)
  return new[raw]
 def clone(raw,base,name,desc,cd=None,mana=None,duration=None):
  o=copy.deepcopy(old[base]);o['id']=raw
  for st in o['sets']:st['mods']=[m for m in st['mods'] if (m.get('level') or 0)<=1]
  for k,val in {'alev':1,'aher':0,'anam':name,'atp1':name,'aub1':desc}.items():mod(o,k,val)
  for k,val in [('acdn',cd),('amcs',mana),('adur',duration),('ahdu',duration)]:
   if val is not None:mod(o,k,val,1)
  new[raw]=o;return o
 ch('mDA9','Darkness','Damages enemies within 600.|n|n|cffffcc00Damage Calculation|r|n10% of each enemy\'s current health as spell damage. Costs 100 mana. Cooldown: 15 seconds.','howlofterror',cd=15.,mana=100,area=600.)
 ch('mSU9','Summon Demon Hound','Invokes a dark rune and summons a level 10 Felhound: 1000 health, 25 Fortified armor, 30-40 Chaos attack damage. Lasts 45 seconds. Costs 200 mana. Cooldown: 30 seconds.','roar',cd=30.,mana=200)
 ch('mRO9','Roar','Increases attack damage by 300 for 20 seconds. Costs 125 mana. Cooldown: 30 seconds.','roar',cd=30.,mana=125)
 ch('mDS9','Defensive Stance','For 10 seconds, takes 20% less damage, gains 30 percentage points of physical block and 25 percentage points of magical block. Cooldown: 30 seconds.','defend',cd=30.)
 ch('mTE9','Taunt','Forces nearby enemies to attack for 3 seconds and grants 66% physical block and 50% magical block for 10 seconds. Radius: 450. Cooldown: 25 seconds.','roar',cd=25.,area=450.)
 ch('mTV9','Elemental Taunt','Forces nearby enemies to attack for 5 seconds. Grants 50% resistance to magical and elemental damage for 15 seconds. Costs 125 mana. Cooldown: 30 seconds. Radius: 450.','roar',cd=30.,mana=125,area=450.)
 ch('mBI9','Bite','Bites the target.|n|n|cffffcc00Damage Calculation|r|n600 spell damage. Restores 250 health to the caster. Cooldown: 15 seconds.','cripple',1,15.,reach=180.)
 native('mMI9','AOmi','Mirror Image','Creates one illusion dealing 50% damage and taking 50% increased damage. Lasts 30 seconds. Costs 100 mana. Cooldown: 30 seconds.',30.,100,Omi1=1,Omi2=.5,Omi3=1.5,adur=30.,ahdu=30.)
 native('mCS9','ACca','Carrion Swarm','Deals 600 damage per target, up to 2400 total spell damage per cast. Costs 100 mana. Cooldown: 8 seconds.',8.,100,Ucs1=600.,Ucs2=2400.)
 ch('mCU9','Cure','Sends a healing projectile to an injured ally within 800.|n|n|cffffcc00Healing Calculation|r|n600 to the target, 300 to allies along its path. Costs 300 mana. Cooldown: 8 seconds.','holybolt',1,8.,300,reach=800.)
 mod(new['mCU9'],'atar','air,ground,friend,self,organic,vulnerable',1)
 ch('mSH9','Armor Shout','Allies within 800 gain 20 armor for 15 seconds. Costs 250 mana. Cooldown: 30 seconds.','roar',cd=30.,mana=250,area=800.)
 ch('mAC9','Accumulate','Heals 50% of maximum health and increases attack damage by 300 and armor by 40 for 20 seconds. Costs 150 mana. Cooldown: 45 seconds.','roar',cd=45.,mana=150)
 ch('mSL9','Earth Slam','Stuns enemies within 300 for 3 seconds.|n|n|cffffcc00Damage Calculation|r|n600 earth spell damage. Costs 125 mana. Cooldown: 15 seconds.','stomp',cd=15.,mana=125,area=300.)
 ch('mRK9','Throw Rock','Throws a rock at the target.|n|n|cffffcc00Damage Calculation|r|n400 earth spell damage. Reduces attack and movement speed by 33% for 5 seconds. Costs 75 mana. Cooldown: 10 seconds.','thunderbolt',1,10.,75)
 clone('mBR9','ACif','Bravery','Autocast: increases a friendly unit\'s physical damage by 50% for 20 seconds. Costs 100 mana. Cooldown: 15 seconds.',15.,100,20.)
 ch('mDV9','Devour Mountain Creature','Consumes an injured friendly Northern Mountains creature, permanently absorbing both attack damages, maximum HP/mana and armor, and recovering its remaining HP. Unlocks Aeroaga. No heroes/special quest units. Maximum two Devours. Costs 300 mana. Cooldown: 15 seconds.','devour',1,15.,300,reach=350.)
 native('mAU9','AHab','Brilliance Aura','Allies within 600 gain 75% increased mana regeneration.',0.,0,Hab1=.75,Hab2=1,aare=600.,atar='air,ground,friend,self')
 native('mL79','ACcl','Chain Lightning','Deals 750 thunder spell damage to the primary target. Costs 120 mana. Cooldown: 15 seconds.',15.,120,Ocl1=750.,Ocl2=1)
 native('mL69','ACcl','Chain Lightning','Deals 600 thunder spell damage to the primary target. Costs 120 mana. Cooldown: 15 seconds.',15.,120,Ocl1=600.,Ocl2=1)
 native('mFL9','ACfl','Forked Lightning','Deals 450 thunder spell damage to each struck enemy. Costs 100 mana. Cooldown: 15 seconds.',15.,100,Ocl1=450.)
 native('mLS9','ACls','Lightning Shield','Deals 150 thunder spell damage per second around the shielded unit for 20 seconds. Costs 100 mana. Cooldown: 15 seconds.',15.,100,Lsh1=150.,adur=20.,ahdu=20.,atar='air,ground,friend,self')
 ch('mAW9','Aeroaga','Creates a wind storm of radius 300 for 9 seconds, dealing damage at 3, 6 and 9 seconds.|n|n|cffffcc00Damage Calculation|r|nDark Wizard after Devour: 1000 + base attack damage + 0.001 x maximum health per pulse. Other caster: 500 per pulse. Wind spell damage. Costs 200 mana. Cooldown: 20 seconds.','flamestrike',2,20.,200,300.,800.)
 ch('mFB9','Firebolt','Hurls a firebolt that stuns for 3 seconds.|n|n|cffffcc00Damage Calculation|r|n800 fire spell damage. Costs 200 mana. Cooldown: 10 seconds.','firebolt',1,10.,200)
 native('mST9','AHtb','Slam Stun','Stuns for 3 seconds.',0.,0,Htb1=0.,adur=3.,ahdu=3.,aran=99999.)
 native('mSN9','Aslo','Rock Slow','Attack and movement speed reduced by 33% for 5 seconds.',0.,0,Slo1=.33,Slo2=.33,adur=5.,ahdu=5.,aran=99999.)
 for raw,armor in [('mA29',20),('mA49',40)]:native(raw,'AId1','Armor Bonus','Increases armor by '+str(armor)+'.',0.,0,Idef=armor)
 native('mD39','AIat','Attack Bonus','Increases attack damage by 300.',0.,0,Iatt=300)
 for raw,name,desc in [('mPA9','Venomous Attack','25% chance: 10 + 5 x poisoned hero level damage per second for 10 seconds.'),('mPG9','Venomous Attack','25% chance: 10 + 4 x poisoned hero level damage per second for 10 seconds.'),('mCR9','Critical Strike','35% chance to deal 2.5x physical damage.'),('mEV9','Evasion','40 increased evasion.'),('mSK9','Shock Attack','10% chance to Shock on a landed basic attack.')]:native(raw,'AIev',name,desc,0.,0,Eev1=0.)
 clone('mAL9','fL86','Alert','On attacking a hero or taking hero damage, calls reinforcements for 15 seconds. Final 5-4-3-2-1 countdown. Kill caller to cancel. Doubles Northern Mountains spawn frequency, wave size and population cap for 60 seconds. Once per caller.')
 # Native proxy projectiles preserve source attribution and explicit spell elements.
 for raw,name,model,stun in [('mPF9','Firebolt Impact','Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl',3.),('mPE9','Rock Impact','Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl',.001)]:
  native(raw,'AHtb',name,'Proxy projectile damage.',0.,0,Htb1=1.,adur=stun,ahdu=stun,aran=99999.);mod(new[raw],'amat',model,0)
 stock={r['unitAbilID']:r for r in slk((ROOT/'tools/build-inputs/unitabilities.slk').read_bytes())}
 def ua(raw,add=(),remove=()):
  o=units[raw];ab=[x for x in fields(o).get(('uabi',None),stock.get(o['base'],{}).get('abilList','')).split(',') if len(x)==4 and x not in remove]
  for x in add:
   if x not in ab:ab.append(x)
  setf(o,'uabi',','.join(ab),None)
 for raw,(lv,hp,armor,lo,hi,mana) in STATS.items():
  for key,value in [('ulev',lv),('uhpm',hp),('udef',float(armor) if armor is not None else None),('umpm',mana),('umpi',mana)]:
   if value is not None:setf(units[raw],key,value,None)
  if lo is not None:
   for key,value in [('ua1b',lo-1),('ua1d',1),('ua1s',hi-lo+1)]:setf(units[raw],key,value,None)
 adds={'nwiz':['mDA9'],'nhfp':['mSU9'],'n0MO':['mRO9'],'nass':['mPA9'],'nban':['mDS9'],'nbrg':['mAL9'],'nenf':['mTE9'],'ngno':['mBI9'],'ngns':['A03N','mPG9'],'ngnv':['mTV9'],'ngnw':['A0LF','mSK9'],'nhdc':['mMI9'],'nhhr':['mCS9'],'nkob':['mEV9','mAL9'],'nkog':['mCU9'],'nkol':['mCR9'],'nkot':['mSH9'],'nogl':['mAC9'],'nogm':['mSL9'],'nogr':['A0LH','mRK9'],'nomg':['A059','mBR9'],'nrog':['A03N'],'nwzd':['mDV9','mAU9','mL79','mFL9'],'nwzg':['mL69','mLS9','mAW9'],'nwzr':['mFB9']}
 removes={'nass':['A0PH'],'ngns':['A0PH'],'nhhr':['ACcs','ACsw','ACca'],'nkog':['ACsw','A05A'],'nkol':['ACct'],'nogl':['A03Z'],'nwzd':['ACcl','ACfl'],'nwzg':['ACcl','ACls']}
 for raw,add in adds.items():ua(raw,add,removes.get(raw,()))
 setf(units['nhfp'],'unam','Cultist',None);setf(units['nhfp'],'utip','Cultist',None)
 setf(units['nomg'],'udaa','mBR9',None)
 for raw in ['nban','nenf','n0MO','nkot','nogm','nogr']:
  if fields(units[raw]).get(('umpm',None),0)<300:setf(units[raw],'umpm',500,None);setf(units[raw],'umpi',500,None)
 hound={'base':'nfel','id':'mH89','sets':[{'flag':0,'mods':[]}]}
 for k,val in {'unam':'Demon Hound','utip':'Demon Hound','utub':'Level 10. 1000 health, 25 Fortified armor, 30-40 Chaos attack damage.','ulev':10,'uhpm':1000,'udef':25.,'udty':'fort','ua1t':'chaos','ua1b':29,'ua1d':1,'ua1s':11,'uabi':'','umdl':'Units\\Demon\\Felhound\\Felhound.mdl','ufoo':0}.items():setf(hound,k,val,None)
 units['mH89']=hound
 for raw in ['fD86','bD88','fE86']:
  new[raw]=copy.deepcopy(old[raw])
 mod(new['fD86'],'aub1','Consumes an injured friendly Guardia Forest creature. Absorbs its attack damages, maximum HP/mana and armor; heals its remaining HP. Unlocks Blizzaga. Maximum two Devours. Costs 200 mana. Cooldown: 15 seconds.',1)
 mod(new['bD88'],'aub1','Consumes an injured friendly Barrens creature. Absorbs its attack damages, maximum HP/mana and armor; heals its remaining HP. Unlocks Rapid Fire. Maximum two Devours. Costs 250 mana. Cooldown: 15 seconds.',1)
 for k,val in [('amcs',200),('adur',15.),('aub1','Increases evasion by 80 for 15 seconds. Costs 200 mana. Cooldown: 30 seconds.')]:mod(new['fE86'],k,val,1)
 for raw in RAW:
  if raw=='mH89':continue
  f=fields(units[raw]);desc=['Normal base level '+str(STATS[raw][0])+'.'] if raw in STATS else []
  for a in f.get(('uabi',None),'').split(','):
   if a in new:desc.append(fields(new[a]).get(('aub1',1),''))
  if desc:setf(units[raw],'utub','|n|n'.join(desc),None)
 return units,new

def sort_helpers(s):
 helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_','M89_')) and not n.endswith('UpdateSpawnTimer')}
 names=set(helpers);deps={n:(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',re.sub(r'"(?:\\.|[^"\\])*"','""',b)))|set(re.findall(r'\bfunction\s+(\w+)',b)))&names-{n} for n,b in helpers.items()}
 result=[];remaining=list(helpers)
 while remaining:
  ready=[n for n in remaining if not deps[n]-set(result)]
  assert ready,remaining
  for n in ready:result.append(n);remaining.remove(n)
 start=min(s.index(b) for b in helpers.values());prefix=s[:start];tail=s[start:]
 for b in helpers.values():tail=tail.replace(b,'',1)
 return prefix+'\n\n'.join(helpers[n] for n in result)+'\n'+tail

def refresh89(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n=='Trig_Equip_Restrictions_Conditions':new=new.replace('    if ForsakenConvertingGear',"    if GetItemTypeId(GetManipulatedItem())=='I073' or GetItemTypeId(GetManipulatedItem())=='I071' then\n        return false\n    endif\n    if ForsakenConvertingGear",1)
  if n=='ItemStack_Eligible':new=new.replace("GetItemTypeId(picked)=='I03Y'","GetItemTypeId(picked)=='I03Y' or GetItemTypeId(picked)=='I073' or GetItemTypeId(picked)=='I071'")
  if n=='Trig_Item_Stack_Pickup_IsStackable':new=new.replace('    return','    return',1);new='function '+n+' takes nothing returns boolean\n    return ItemStack_Eligible(GetManipulatedItem())\nendfunction'
  if n=='Forest86_Actor':new=new.replace('return B88_Actor','return M89_Pool(raw) or B88_Actor',1)
  if n=='Forest86_Init':new=new.replace(' set B88Buffs=CreateGroup()',' set M89Buffs=CreateGroup()\n set B88Buffs=CreateGroup()')
  if n=='Forest86_Track':new=new.replace(" if GetUnitTypeId(u)=='nrzm' then",''' if GetUnitTypeId(u)=='nomg' then
 call SaveBoolean(Forest86Data,GetHandleId(u),91,true)
 call IssueImmediateOrder(u,"innerfireon")
 endif
 if GetUnitTypeId(u)=='nrzm' then''')
  if n=='Forest86_Track':new=new.replace('if Forest86_Actor(GetUnitTypeId(u)) and GetOwningPlayer(u)==Player(11) then','if Forest86_Actor(GetUnitTypeId(u)) and GetOwningPlayer(u)==Player(11) and not IsUnitIllusion(u) then')
  if n=='Forest86_Death':new=new.replace('and not IsUnitInGroup(u,B88Charges) then','and not IsUnitInGroup(u,B88Charges) and not IsUnitInGroup(u,M89Buffs) then');new=new.replace("or GetUnitTypeId(u)=='nhrr')","or GetUnitTypeId(u)=='nhrr' or GetUnitTypeId(u)=='nbrg' or GetUnitTypeId(u)=='nkob')");new=new.replace(' call GroupRemoveUnit(B88Buffs,u)'," call GroupRemoveUnit(M89Buffs,u)\n call UnitRemoveAbility(u,'mD39')\n call UnitRemoveAbility(u,'mA49')\n call UnitRemoveAbility(u,'mA29')\n call GroupRemoveUnit(B88Buffs,u)")
  if n=='Forest86_SpawnFactor':new=new.replace(' return 1',' if zone==4 and M89AlertUntil>Forest86Now then\n return 2\n endif\n return 1')
  if n=='B88_AlertZone':new=new.replace(" if GetUnitTypeId(u)=='nhrr' then"," if GetUnitTypeId(u)=='nbrg' or GetUnitTypeId(u)=='nkob' then\n return 4\n endif\n if GetUnitTypeId(u)=='nhrr' then")
  if n=='Forest86_Alert':new=new.replace("and GetUnitTypeId(u)!='nhrr')","and GetUnitTypeId(u)!='nhrr' and GetUnitTypeId(u)!='nbrg' and GetUnitTypeId(u)!='nkob')")
  if n=='Forest86_AI':
   new=new.replace(" if raw=='nhrr' then"," if raw=='nbrg' or raw=='nkob' then\n set M89AlertUntil=Forest86Now+60.\n set M89AlertActive=true\n call ExecuteFunc(\"M89_UpdateSpawnTimer\")\n elseif raw=='nhrr' then",1)
   new=new.replace('if victim!=null or B88_Actor(raw) then','if victim!=null or B88_Actor(raw) or M89_Pool(raw) then').replace(' if B88_Actor(raw) then',' if M89_Pool(raw) then\n call M89_AI(u,victim)\n elseif B88_Actor(raw) then')
   new=new.replace("raw=='nfsh' and not LoadBoolean(Forest86Data,id,1)","raw=='nfsh' and LoadInteger(Forest86Data,id,90)<2")
   new=new.replace(' call IssueTargetOrder(u,"devour",victim)\n endif\n else', ''' call IssueTargetOrder(u,"devour",victim)
 elseif Forest86_Ready(u,'fB86',100) then
 set victim=Forest86_Find(u,0)
 if victim!=null then
 call IssuePointOrder(u,"shockwave",GetUnitX(victim),GetUnitY(victim))
 endif
 endif
 else''',1)
  if n=='B88_AI':new=new.replace("raw=='nqbh' and not LoadBoolean(Forest86Data,GetHandleId(u),1)","raw=='nqbh' and LoadInteger(Forest86Data,GetHandleId(u),90)<2")
  if n=='Forest86_Tick':new=new.replace(' call ForGroup(B88Buffs', ' call ForGroup(M89Buffs,function M89_TickUnit)\n if M89AlertActive and Forest86Now>=M89AlertUntil then\n set M89AlertActive=false\n call ExecuteFunc("M89_UpdateSpawnTimer")\n endif\n call ForGroup(B88Buffs',1)
  if n=='Forest86_DevourValid':new=new.replace('return Forest86_Alive(victim)','return M89_Injured(victim) and IsUnitAlly(victim,GetOwningPlayer(caster)) and LoadInteger(Forest86Data,GetHandleId(caster),90)<2',1)
  if n=='Forest86_Find':new=new.replace('and Forest86_Pool(GetUnitTypeId(u))','and M89_Injured(u) and Forest86_Pool(GetUnitTypeId(u))')
  if n=='B88_Ally':new=new.replace('and B88_Pool(GetUnitTypeId(u))','and M89_Injured(u) and B88_Pool(GetUnitTypeId(u))')
  if n=='Forest86_Spell':new=new.replace(' if Forest86_DevourValid(caster,victim) then',' if Forest86_DevourValid(caster,victim) then\n call M89_Absorb(caster,victim)',1).replace('30,Forest86Now+10.','30,Forest86Now+15.').replace(' call B88_Spell(caster,victim,raw)',' call B88_Spell(caster,victim,raw)\n call M89_Spell(caster,victim,raw)')
  if n=='B88_Spell':new=new.replace("if Forest86_Alive(victim) and victim!=caster and B88_Pool", "if M89_Injured(victim) and IsUnitAlly(victim,GetOwningPlayer(caster)) and LoadInteger(Forest86Data,id,90)<2 and victim!=caster and B88_Pool").replace(' set spawned=LoadGroupHandle',' call M89_Absorb(caster,victim)\n set spawned=LoadGroupHandle',1)
  if n=='Forest86_Taunt':new=new.replace(' local integer id',' local integer id\n local real duration=3.',1).replace(' call SaveReal(Forest86Data,GetHandleId(caster),22'," if GetUnitTypeId(caster)=='ngnv' then\n set duration=5.\n endif\n call SaveReal(Forest86Data,GetHandleId(caster),22",1).replace('21,Forest86Now+3.','21,Forest86Now+duration')
  if n=='Forest86_Evasion':new=new.replace('Forest86Now<LoadReal(Forest86Data,GetHandleId(u),30)','Forest86Now<LoadReal(Forest86Data,GetHandleId(u),30)');new=new.replace(' return 0.'," if GetUnitTypeId(u)=='nkob' then\n return 40.\n endif\n return 0.")
  if n=='Forest86_Order':new=new.replace(" if GetUnitTypeId(victim)=='ncks' then",''' if GetUnitTypeId(victim)=='nomg' then
 if GetIssuedOrderId()==OrderId("innerfireon") then
 call SaveBoolean(Forest86Data,id,91,true)
 elseif GetIssuedOrderId()==OrderId("innerfireoff") then
 call SaveBoolean(Forest86Data,id,91,false)
 endif
 endif
 if GetUnitTypeId(victim)=='ncks' then''')
  if n=='B88_BlockChance':new=new.replace(' return 25'," if B88_Active(u,80) then\n return 55\n endif\n return 25",1).replace(" elseif raw=='nbld' or raw=='nowe' then"," elseif raw=='nenf' and B88_Active(u,81) then\n return 66\n elseif raw=='nbld' or raw=='nowe' then",1)
  if n=='B88_BlockChance':new=new.replace(" elseif magical then\n if raw=='nban' then\n return 15", " elseif magical then\n if raw=='nban' then\n if B88_Active(u,80) then\n return 40\n endif\n return 15").replace(" elseif raw=='nbld' then\n return 10", " elseif raw=='nenf' and B88_Active(u,81) then\n return 50\n elseif raw=='nbld' then\n return 10")
  if n=='Trig_Damage_Engine_Step18_FinalModifiers':new=new.replace('    if l_amount>0. and not l_heal then','    if l_amount>0. and not l_heal then\n        if B88_Active(t,80) then\n            set l_amount=l_amount*.8\n        endif\n        if B88_Active(t,82) and (l_magical or l_element>0) then\n            set l_amount=l_amount*.5\n        endif',1)
  if n=='Trig_Damage_Engine_Step19_Apply':new=new.replace('if IsUnitIllusion(u)then',"if IsUnitIllusion(u) and not (GetUnitTypeId(u)=='nhdc' and GetOwningPlayer(u)==Player(11)) then")
  if n=='Forest86_OnAttack':new=new.replace(" elseif raw=='nbrg' then"," elseif raw=='nass' then\n set chance=25\n set coefficient=5\n set base=10\n set duration=10.\n elseif raw=='ngns' then\n set chance=25\n set coefficient=4\n set base=10\n set duration=10.\n elseif raw=='nbrg' then");new=new.replace(' if chance>0'," if raw=='ngnw' and GetRandomInt(1,100)<=10 then\n call M89_Dummy(attacker,victim,'A13V',\"acidbomb\")\n endif\n if chance>0",1)
  if n=='Trig_Damage_Engine_GetCritMult':pos=new.index('    if');new=new[:pos]+"    if GetUnitTypeId(u)=='nkol' and GetRandomInt(1,100)<=35 then\n        return 2.5\n    endif\n"+new[pos:]
  if n=='Forest86_OnAttack':
   shock=' if raw==\'ngnw\' and GetRandomInt(1,100)<=10 then\n call M89_Dummy(attacker,victim,\'A13V\',"acidbomb")\n endif\n'
   assert shock in new
   new=new.replace(shock,'').replace(' if Forest86Data==null', ' if Forest86Data!=null and raw==\'ngnw\' and IsUnitEnemy(victim,GetOwningPlayer(attacker)) and GetRandomInt(1,100)<=10 then\n call M89_Dummy(attacker,victim,\'A13V\',"acidbomb")\n endif\n if Forest86Data==null',1)
  if n=='Trig_Damage_Engine_ProxyDamageApply':new=new.replace('        call UnitDamageTarget(u,t,l_amount', '''        if HaveSavedInteger(udg_ProxyDamageHash,dh,100) then
            set udg_DamageElement=LoadInteger(udg_ProxyDamageHash,dh,100)
            if LoadBoolean(udg_ProxyDamageHash,dh,101) then
                call M89_Dummy(u,t,'mSN9',"slow")
            endif
        endif
        call UnitDamageTarget(u,t,l_amount''',1)
  if n=='Trig_Spell_Cure_Conditions':new=new.replace('return(',"return(GetSpellAbilityId()=='mCU9' or ",1)
  if n=='Trig_Spell_Cure_Actions':
   new=new.replace('    local integer d','    local real splash=r*.25\n    local integer d',1).replace('    if hostile then',"    if GetSpellAbilityId()=='mCU9' then\n        set r=600.\n        set splash=300.\n    endif\n    if hostile then",1).replace('128.,r*.25,r,true','128.,splash,r,true')
  if n=='Trig_Spell_Cure_Actions':new=new.replace('        set r=.0','        set r=.0\n        set splash=.0',1)
  if n=='Trig_Zone_Spawn_System_SpawnZoneUnits':new=new.replace('B88_Actor(GetUnitTypeId(l_spawned))','M89_Pool(GetUnitTypeId(l_spawned)) or B88_Actor(GetUnitTypeId(l_spawned))')
  if new!=b:s=put(s,n,new)
 if 'RegisterTriggers_MonsterData' in fs:
  fragment=(ROOT/'experiments/GuardiaForest/Mountains89.j').read_text();glob=re.search(r'globals\n(.*?)endglobals',fragment,re.S);s=s.replace('endglobals',glob[1]+'endglobals',1);s=s.replace('function RegisterTriggers_MonsterData takes',fragment[glob.end():].strip()+'\nfunction RegisterTriggers_MonsterData takes',1);s=sort_helpers(s)
 if 'Trig_Zone_Spawn_System_ZoneRespawnTick' in fs:
  clock=fs['B88_UpdateSpawnTimer'].replace('B88_UpdateSpawnTimer','M89_UpdateSpawnTimer').replace(',3,2)',',3,4)').replace(',1,2)',',1,4)').replace('SpawnFactor(2)','SpawnFactor(4)')
  s=s.replace('function B88_UpdateSpawnTimer takes',clock+'\nfunction B88_UpdateSpawnTimer takes',1)
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);units,abil=objects89(v);files={}
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
 modules={lib:refresh89(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};runtime=refresh89(v.runtime)
 for lib in changed:
  oldfs=functions(v.modules[lib])
  for n,b in functions(modules[lib]).items():
   if n in oldfs and tokens(b)!=tokens(oldfs[n]):runtime=put(runtime,n,b)
 runtime,moved=order(runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 w=wts_read(v.archive.read('war3map.wts'));label='FFERPG QuickUI89 (Northern Mountains)';w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-3500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 a=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert a.read(name)==files.get(name,v.archive.read(name)),name
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),units=RAW,moved=moved,notes='Full Dragoon only; Normal base stats; shared heartbeat. Live acceptance pending.'),indent=2));print(OUT)
if __name__=='__main__':build()
