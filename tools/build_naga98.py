"""Naga Islands roles plus Hydra Hatchlings and the shared Tidal Wave projectile fix."""
from build_forest86 import *
from editor_pair import runtime_for
import build_central95 as package
import tidal_wave98
BASE=ROOT/'release/development/QuickUI97/FFERPG-QuickUI97.w3x'
OUT=ROOT/'release/development/QuickUI98/FFERPG-QuickUI98.w3x'
LABEL='FFERPG QuickUI98 (Naga Islands)'
STATS={'nnsw':(38,5100,47,235,252,1600),'nnrg':(40,9000,41,301,313,800),'nrel':(33,5200,15,238,256,None),'nsel':(37,6100,23,266,291,750),'nhyc':(36,8000,175,271,310,None),'nmpe':(30,3500,45,226,229,None),'nnmg':(32,4000,51,248,271,None),'nsnp':(35,3900,63,355,389,None),'n01O':(31,4000,15,196,216,800),'n01Q':(38,5250,20,300,314,1000),'nmyr':(34,6000,55,271,292,None),'nwgs':(37,3200,46,240,259,600),'nsgn':(32,4175,49,184,212,None),'nsgh':(34,5200,67,287,313,600),'nsgb':(39,7900,84,356,414,800),'nhyh':(20,2000,35,83,97,None)}
ICONS={}
def objects98(v):
 u=all_objects(v,'w3u');old=all_objects(v,'w3a');oldb=all_objects(v,'w3h');a={};buffs={}
 def add(raw,base,name,desc,icon,cd=0.,mana=0,target='air,ground,enemy',area=0.,reach=600.):
  a[raw]=ability(raw,base,name,desc,icon,cd,mana,target,area,reach);ICONS[raw]=icon;return a[raw]
 def passive(raw,name,desc,icon):
  o=add(raw,'AIev',name,desc,icon);mod(o,'Eev1',0.,1);return o
 def ch(raw,name,desc,icon,order,target=0,cd=0.,mana=0,area=0.,reach=600.):
  o=channel(raw,name,desc,icon,order,target,cd,mana,area,reach);a[raw]=o;ICONS[raw]=icon
  for k,val in [('Ncl3',1),('acat',''),('atat',''),('asat',''),('aeat',''),('aefs',''),('aefl','')]:mod(o,k,val,1 if k=='Ncl3' else 0)
  if target==1:mod(o,'atar','air,ground,enemy,vulnerable',1)
  return o
 def buff(raw,base,name,desc,icon,art):
  o=copy.deepcopy(oldb[base]) if base in oldb else {'base':base,'id':raw,'sets':[{'flag':0,'mods':[]}]};o['id']=raw
  for k,val in [('fnam',name),('ftip',name),('fube',desc),('fart','ReplaceableTextures\\CommandButtons\\'+icon),('ftat',art),('ftac',1),('fta0','origin')]:setf(o,k,val,0)
  buffs[raw]=o
 def status(raw,braw,name,desc,icon,art,duration):
  o=add(raw,'Acrs',name,desc,icon,target='air,ground,friend,enemy,self',reach=99999.)
  setf(o,'Crs\0',0.,1,data=1)
  for k in ['acat','atat','asat','aeat']:mod(o,k,'',0)
  for k,val in [('abuf',braw),('adur',duration),('ahdu',duration)]:mod(o,k,val,1)
  buff(braw,'Bcrs',name,desc,icon,art)
 ch('nDV8','Devour Naga Island Creature','Consumes an injured friendly Naga Islands creature, absorbing its attack, maximum health, maximum mana and armor, and healing by its remaining health. Two uses maximum. Unlocks Maelstrom. No heroes or special quest creatures. 250 mana; 20-second cooldown.','BTNDevourMagic.blp','devour',1,20.,250,reach=350.)
 mod(a['nDV8'],'atar','air,ground,friend,organic,mechanical,vulnerable',1)
 ch('nMA8','Maelstrom','Unlocked after Devour. Calls Diablos\' dark storm in the targeted area.|n|n|cffffcc00Damage Calculation|r|n1% of each enemy\'s maximum health per second for 15 seconds, before damage modifiers.|n1800 mana; 60-second cooldown.','BTNDeathAndDecay.blp','deathanddecay',2,60.,1800,area=250.,reach=900.)
 a['nMD8']=copy.deepcopy(old['A0JI']);a['nMD8']['id']='nMD8'
 for k,val in [('Udd1',.01),('amcs',0),('acdn',0.),('adur',15.),('ahdu',15.)]:mod(a['nMD8'],k,val,1)
 ch('nVO8','Vortex','Pulls enemies within 250 of the chosen point into its center over 1 second. 400 mana; 30-second cooldown.','BTNPortal.blp','flamestrike',2,30.,400,area=250.,reach=800.)
 o=add('nAU8','AHab','Abyssal Brilliance','Nearby allies within 800 deal 30% more magic damage.','BTNBrilliance.blp',target='air,ground,friend,self',area=800.)
 for k,val in [('Hab1',0.),('Hab2',0),('abuf','bMP8')]:mod(o,k,val,1)
 buff('bMP8','BHab','Abyssal Brilliance','Magic damage increased by 30%.','BTNBrilliance.blp','')
 o=add('nFA8','ACfu','Frost Armor','Grants +50 armor and 50% ice resistance for 30 seconds. 80 mana; 25-second cooldown.','BTNFrostArmor.blp',25.,80,target='air,ground,friend,self')
 for k,val in [('Ufa1',50.),('adur',30.),('ahdu',30.),('abuf','bFA8')]:mod(o,k,val,1)
 buff('bFA8','BUfa','Frost Armor','Armor increased by 50; ice resistance is at least 50%.','BTNFrostArmor.blp',r'Abilities\Spells\Undead\FrostArmor\FrostArmorTarget.mdl')
 ch('nRG8','Regeneration','Restores a friendly creature\'s health over time.|n|n|cffffcc00Healing Calculation|r|n100% of the Sea Witch\'s maximum health over 60 seconds (maximum health / 60 each second). Amount is recorded at cast time.|n300 mana; 30-second cooldown.','BTNRejuvenation.blp','rejuvination',1,30.,300)
 mod(a['nRG8'],'atar','air,ground,friend,self,vulnerable',1)
 status('nRB8','bRG8','Regenerating','Restoring health each second from the Sea Witch.','BTNRejuvenation.blp',r'Abilities\Spells\NightElf\Rejuvenation\RejuvenationTarget.mdl',60.)
 ch('nWV8','Crushing Wave','Launches a water wave along a 1000-unit path, with a 200 collision radius.|n|n|cffffcc00Damage / Healing Calculation|r|n2000 water damage per enemy. Aqua Flan\'s version also heals each ally along the path for 1000. Each unit is affected once.|n100 mana; 15-second cooldown.','BTNCrushingWave.blp','shockwave',2,15.,100,area=200.,reach=1000.)
 o=add('nBO8','AHtb','Aquatic Bolt','Launches a water bolt that stuns an enemy for 5 seconds.|n|n|cffffcc00Damage Calculation|r|n1000 water damage.|n150 mana; 15-second cooldown.','BTNSeaElemental.blp',15.,150)
 for k,val in [('Htb1',1000.),('adur',5.),('ahdu',5.),('amat',r'Abilities\Spells\Other\CrushingWave\CrushingWaveMissile.mdl')]:mod(o,k,val,0 if k=='amat' else 1)
 ch('nAQ8','Aqualung','Water erupts in a 250-radius circle over 7 seconds.|n|n|cffffcc00Damage Calculation|r|n400 water damage per burst. Eight bursts, including the initial burst: up to 3200 damage.|n250 mana; 20-second cooldown.','BTNSeaTurtleGreen.blp','blizzard',2,20.,250,area=250.,reach=700.)
 ch('nTA8','Shell Taunt','Forces nearby enemies to attack for 5 seconds. Gains +50 percentage points of physical and spell block chance for 10 seconds (60% total with Shell Guard). Gaya\'s Break Stun cancels the forced attack. 30-second cooldown.','BTNSpikedBarricades.blp','roar',cd=30.,area=450.)
 status('nTB8','bTB8','Shell Guard Raised','Physical and spell block chance increased by 50 percentage points.','BTNSpikedBarricades.blp',r'Abilities\Spells\Human\Defend\DefendCaster.mdl',10.)
 passive('nGB8','Shell Guard','10% chance to block physical attacks and spells.','BTNImprovedSpikedBarricades.blp')
 passive('nHS8','Hardened Skin','Reduces each non-healing damage event by 100, to a minimum of 1 damage.','BTNThickFur.blp')
 passive('nAL8','Alert','On attacking or taking damage from a hero in Naga Islands, calls reinforcements for 20 seconds. Final countdown: 5, 4, 3, 2, 1. Kill caller to cancel. Doubles Naga Islands spawn frequency and wave size for 60 seconds. Once per caller.','BTNNagaWeaponUp1.blp')
 for raw,value,icon in [('nE48',40,'BTNDefend.blp'),('nE58',50,'BTNDefend.blp'),('nE68',60,'BTNDefend.blp')]:passive(raw,'Naga Evasion',f'{value} evasion.',icon)
 passive('nPO8','Serpent Venom','40% chance per landed attack to poison a hero for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n250 + 8 x poisoned hero level damage per second. Equal/stronger poison refreshes instead of stacking.','BTNEnvenomedSpear.blp')
 o=add('nBE8','Absk','Serpent Frenzy','Increases attack speed by 120% and damage taken by 40% for 10 seconds. 20-second cooldown.','BTNBerserk.blp',20.)
 for k,val in [('bsk1',0.),('bsk2',1.2),('bsk3',.4),('adur',10.),('ahdu',10.)]:mod(o,k,val,1)
 for raw,dmg,cd in [('nFL8',1750.,15.),('nFQ8',2000.,20.)]:
  o=add(raw,'ACfl','Forked Lightning',f'Strikes up to 3 enemies.|n|n|cffffcc00Damage Calculation|r|n{int(dmg)} lightning damage to each enemy.|n200 mana; {int(cd)}-second cooldown.','BTNMonsoon.blp',cd,200)
  mod(o,'Ocl1',dmg,1);mod(o,'Ocl2',3,1)
 o=add('nCR8','ACct','Critical Strike','35% chance to deal 3x normal attack damage.','BTNCriticalStrike.blp');mod(o,'Ocr1',35.,1);mod(o,'Ocr2',3.,1)
 o=add('nMI8','AOmi','Splintering Images','Splits into two nearby mirror images for 30 seconds. Each deals 25% damage and takes 50% extra damage. Each image\'s death permanently grants its living original +50% attack speed, +1500 maximum/current health and +120 attack damage. 150 mana; 30-second cooldown.','BTNMirrorImage.blp',30.,150,area=128.,reach=96.)
 for k,val in [('Omi1',2),('Omi2',.25),('Omi3',1.5),('adur',30.),('ahdu',30.)]:mod(o,k,val,1)
 o=add('nIH8','AIsx','Image Inheritance','Permanent attack speed gained from fallen images: +50% per image, subject to Warcraft\'s attack speed cap.','BTNUnholyFrenzy.blp');mod(o,'alev',32,0)
 for rank in range(1,33):mod(o,'Isx1',.5*rank,rank)
 for raw,chance,dmg,element,icon in [('nPV8',33,500,'water','BTNSeaGiantPulverize.blp'),('nPL8',40,750,'lightning','BTNStormHammer.blp'),('nPO9',50,100,'omni-elemental','BTNOrbOfDarkness.blp')]:passive(raw,'Pulverize',f'{chance}% chance on a landed attack to deal {dmg} {element} damage to enemies within 300 of the target.',icon)
 o=add('nER8','AEer','Entangling Roots','Roots an enemy in place for 5 seconds.|n|n|cffffcc00Damage Calculation|r|n500 water damage per second (2500 total).|n150 mana; 15-second cooldown.','BTNEntanglingRoots.blp',15.,150)
 for k,val in [('Eer1',500.),('adur',5.),('ahdu',5.)]:mod(o,k,val,1)
 o=add('nST8','Awrs','War Stomp','Stomps enemies within 500.|n|n|cffffcc00Damage Calculation|r|n1500 damage. Stuns for 2 seconds.|n100 mana; 15-second cooldown.','BTNWarStomp.blp',15.,100,area=500.)
 for k,val in [('Wrs1',1500.),('adur',2.),('ahdu',2.)]:mod(o,k,val,1)
 o=add('nBU8','AHtb','Hurl Boulder','Hurls a boulder that stuns for 3 seconds.|n|n|cffffcc00Damage Calculation|r|n1500 damage.|n100 mana; 15-second cooldown.','BTNGolemStormBolt.blp',15.,100)
 for k,val in [('Htb1',1500.),('adur',3.),('ahdu',3.),('amat',r'Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl')]:mod(o,k,val,0 if k=='amat' else 1)
 passive('nPH8','Hatchling Venom','25% chance on a landed attack to poison for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n30 + 4 x attacking hatchling level per second (110 at level 20). Equal/stronger poison refreshes instead of stacking.','BTNPoisonSting.blp')
 o=add('nSL8','Aslo','Icy Grasp','Movement slowed by 30%, attack speed slowed by 20%, and evasion reduced by 30 for 5 seconds.','BTNOrbOfFrost.blp',target='air,ground,enemy',reach=99999.)
 for k,val in [('Slo1',.3),('Slo2',.2),('adur',5.),('ahdu',5.)]:mod(o,k,val,1)
 passive('nFR8','Freezing Attacks','Attacks slow movement by 30% and attack speed by 20%, and reduce evasion by 30 for 5 seconds.','BTNOrbOfFrost.blp')
 adds={'nnsw':['nDV8','nAU8','nFA8','nRG8','nVO8'],'nnrg':['nWV8','nBO8','nE68'],'nrel':['nFR8'],'nsel':['nAQ8'],'nhyc':['nGB8','nHS8','nTA8'],'nmpe':['nAL8','nE58'],'nnmg':['nAL8','nE68'],'nsnp':['nE48','nPO8','nBE8'],'n01O':['nFL8'],'n01Q':['nWV8','nFQ8'],'nmyr':['nCR8'],'nwgs':['nMI8'],'nsgn':['nPV8'],'nsgh':['nPL8','nER8'],'nsgb':['nPO9','nST8','nBU8'],'nhyh':['nPH8']}
 remove={'nnsw':['A0B6','ACfu'],'nnrg':['A03N','ACcb','ACcv','A0N8'],'nhyc':['A0RU'],'nsnp':['A0PH'],'n01O':['ACfl','ACsw'],'n01Q':['ACcv','A02N','ACfl','ACsw'],'nmyr':['A0BD'],'nsgn':['ACpv'],'nsgh':['ACpv','ACen'],'nsgb':['ACpv','Awrs','ACtb'],'nhyh':['A0PH']}
 stock={r['unitAbilID']:r for r in slk((ROOT/'tools/build-inputs/unitabilities.slk').read_bytes())}
 for raw,(lv,hp,ar,lo,hi,mp) in STATS.items():
  f=fields(u[raw]);existing=f.get(('uabi',None),stock.get(u[raw]['base'],{}).get('abilList','')).split(',')
  ab=[r for r in existing if len(r)==4 and r not in remove.get(raw,[])]
  for r in adds[raw]:
   if r not in ab:ab.append(r)
  setf(u[raw],'uabi',','.join(ab),None)
  for k,val in [('ulev',lv),('uhpm',hp),('udef',float(ar)),('ua1b',lo-1),('ua1d',1),('ua1s',hi-lo+1),('umpm',mp),('umpi',mp)]:
   if val is not None:setf(u[raw],k,val,None)
  if mp is not None:setf(u[raw],'umpr',30. if raw=='nnsw' else 10.,None)
  desc=f'Normal level {lv}; {hp} health; {ar} armor; {lo}–{hi} attack damage.'
  for r in adds[raw]:desc+='|n'+fields(a[r])['atp1',1]+': '+fields(a[r])['aub1',1]
  setf(u[raw],'utub',desc,None)
 assert not set(a)&set(old),'Ability collision'
 assert not set(buffs)&set(oldb),'Buff collision'
 a.update(tidal_wave98.objects(v))
 return {r:u[r] for r in STATS},a,buffs
WAVE=r'''function N98_Wave takes nothing returns nothing
 local unit caster=N98WaveCaster
 local real angle=Atan2(N98WaveY-GetUnitY(caster),N98WaveX-GetUnitX(caster))*bj_RADTODEG
 local integer d=Missile_CreateWithEffects(caster,"Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveMissile.mdl","",angle,0.)
 if d!=0 then
 set udg_MissileSpeed[d]=30.
 set udg_MissileRange[d]=1000.
 set udg_MissileAoE[d]=200.
 set udg_MissileTravelDamage[d]=2000.
 set udg_MissileHitOnce[d]=true
 set udg_MissileImpactDamage[d]=0.
 set udg_MissileElement[d]=4
 set udg_MissileIsMagic[d]=true
 set udg_MissileAttackType[d]=ATTACK_TYPE_NORMAL
 if GetUnitTypeId(caster)=='n01Q' then
 set MissileTag[d]=98
 endif
 endif
 set caster=null
endfunction
'''

def sort98(s):
 helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_','M89_','H90_','C95_','R93_','C97_','N98_')) and not n.endswith(('UpdateSpawnTimer','BioMana'))}
 names=set(helpers);deps={n:(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',re.sub(r'"(?:\\.|[^"\\])*"','""',b)))|set(re.findall(r'\bfunction\s+(\w+)',b)))&names-{n} for n,b in helpers.items()};ordered=[];todo=list(helpers)
 while todo:
  ready=[n for n in todo if not deps[n]-set(ordered)];assert ready,todo
  for n in ready:ordered.append(n);todo.remove(n)
 if not helpers:return s
 start=min(s.index(b) for b in helpers.values());prefix=s[:start];tail=s[start:]
 for b in helpers.values():tail=tail.replace(b,'',1)
 return prefix+'\n\n'.join(helpers[n] for n in ordered)+'\n'+tail

def refresh98(s):
 s=tidal_wave98.refresh(s);fs=functions(s)
 for n,b in fs.items():
  t=b
  if n=='Forest86_Init':
   t=t.replace(' local trigger deaths=CreateTrigger()',' local trigger deaths=CreateTrigger()\n local trigger summons=CreateTrigger()',1)
   t=t.replace(' set C95Data=InitHashtable()',' set N98Data=InitHashtable()\n set N98Buffs=CreateGroup()\n set N98Pulls=CreateGroup()\n set N98PullTimer=CreateTimer()\n set C95Data=InitHashtable()',1)
   t=t.replace(' call TriggerRegisterPlayerUnitEvent(deaths,Player(i),EVENT_PLAYER_UNIT_DEATH,null)',' call TriggerRegisterPlayerUnitEvent(deaths,Player(i),EVENT_PLAYER_UNIT_DEATH,null)\n call TriggerRegisterPlayerUnitEvent(summons,Player(i),EVENT_PLAYER_UNIT_SUMMON,null)',1)
   t=t.replace(' call TriggerAddAction(deaths,function Forest86_Death)',' call TriggerAddAction(deaths,function Forest86_Death)\n call TriggerAddAction(summons,function N98_Summoned)',1).replace(' set deaths=null',' set summons=null\n set deaths=null',1)
  if n=='Forest86_Actor':t=t.replace(' return ',' return N98_Pool(raw) or ',1)
  if n=='Forest86_Entered':t=t.replace(' local unit u=GetTriggerUnit()',' local unit u=GetTriggerUnit()\n call N98_Track(u)',1)
  if n=='Forest86_Initial':t=t.replace(' call Forest86_Track',' call N98_Track(GetEnumUnit())\n call Forest86_Track',1)
  if n=='Forest86_Spell':t=t.replace(' call C95_Spell(caster,victim,raw)',' call C95_Spell(caster,victim,raw)\n call N98_Spell(caster,victim,raw)',1)
  if n=='Forest86_Tick':t=t.replace(' call C95_Tick()',' call C95_Tick()\n call N98_Tick()',1)
  if n=='Forest86_OnAttack':t=t.replace(' call C95_Poison(attacker,victim)',' call C95_Poison(attacker,victim)\n call N98_OnHit(attacker,victim)',1)
  if n=='Forest86_Evasion':t=t.replace(' return C95_Evasion(u)',' return C95_Evasion(u)+N98_Evasion(u)',1)
  if n=='B88_BlockChance':
   t=t.replace(' local integer central=C95_Block(u,physical,magical)',' local integer central=C95_Block(u,physical,magical)\n local integer naga=N98_Block(u,physical,magical)\n if naga>0 then\n return naga\n endif',1)
  if n=='Forest86_Alert':
   t=t.replace(" and GetUnitTypeId(u)!='njg1'"," and GetUnitTypeId(u)!='njg1' and GetUnitTypeId(u)!='nmpe' and GetUnitTypeId(u)!='nnmg'",1)
   t=t.replace(' call SaveReal(Forest86Data,id,4,Forest86Now+15.)'," if GetUnitTypeId(u)=='nmpe' or GetUnitTypeId(u)=='nnmg' then\n call SaveReal(Forest86Data,id,4,Forest86Now+20.)\n else\n call SaveReal(Forest86Data,id,4,Forest86Now+15.)\n endif",1)
  if n=='B88_AlertZone':t=t.replace(' local integer ', ' local integer ',1).replace(" if GetUnitTypeId(u)=='ntrs'", " if GetUnitTypeId(u)=='nmpe' or GetUnitTypeId(u)=='nnmg' then\n return 6\n endif\n if GetUnitTypeId(u)=='ntrs'",1)
  if n=='Forest86_AI':
   t=t.replace(' if not Forest86_Alive(u) then',' if not Forest86_Alive(u) then\n call N98_Cleanup(u)',1)
   t=t.replace(" if raw=='ntrs' or raw=='njg1' then"," if raw=='nmpe' or raw=='nnmg' then\n set N98AlertUntil=Forest86Now+60.\n set N98AlertActive=true\n call ExecuteFunc(\"N98_UpdateSpawnTimer\")\n elseif raw=='ntrs' or raw=='njg1' then",1)
   t=t.replace('or C95_Pool(raw) then','or C95_Pool(raw) or N98_Pool(raw) then',1)
   t=t.replace(' if C95_Pool(raw) then',' if N98_Pool(raw) then\n call N98_AI(u,victim)\n elseif C95_Pool(raw) then',1)
  if n=='Forest86_Death':
   t=t.replace(' local unit u=GetTriggerUnit()',' local unit u=GetTriggerUnit()\n call N98_Cleanup(u)',1)
   t=t.replace("GetUnitTypeId(u)=='njg1')", "GetUnitTypeId(u)=='njg1' or GetUnitTypeId(u)=='nmpe' or GetUnitTypeId(u)=='nnmg')",1)
  if n=='Forest86_SpawnFactor':t=t.replace(' return 1',' if zone==6 and N98AlertUntil>Forest86Now then\n return 2\n endif\n return 1',1)
  if n=='Forest86_Taunt':t=t.replace("or GetUnitTypeId(caster)=='nsgg')", "or GetUnitTypeId(caster)=='nsgg' or GetUnitTypeId(caster)=='nhyc')",1)
  if n=='C95_Poison':
   t=t.replace(" and raw!='nhyd' then"," and raw!='nhyd' and raw!='nhyh' then",1).replace(" if raw=='nhyd' then"," if raw=='nhyh' then\n set chance=25\n set amount=30.+4.*I2R(GetUnitLevel(attacker))\n elseif raw=='nhyd' then",1)
  if n in ['Trig_Damage_Engine_GetElementResist','Forsaken_Stat_GetElementResist']:
   t=t.replace('    return l_tier',"    if l_element==2 and GetUnitAbilityLevel(u,'bFA8')>0 then\n        set l_tier=IMaxBJ(l_tier,5)\n    endif\n    return l_tier",1)
  if n=='Element_GetOfUnit':t=t.replace('    if(l_isPhysical)then',"    if not l_isPhysical and (GetUnitTypeId(u)=='nsgh') then\n        return 4\n    endif\n    if not l_isPhysical and (GetUnitTypeId(u)=='n01O' or GetUnitTypeId(u)=='n01Q') then\n        return 3\n    endif\n    if(l_isPhysical)then",1)
  if n=='Trig_Damage_Engine_Step18_FinalModifiers':
   t=t.replace('    if l_amount>0. and not l_heal then',"    if l_amount>0. and not l_heal and l_magical and GetUnitAbilityLevel(u,'bMP8')>0 then\n        set l_amount=l_amount*1.3\n    endif\n    if l_amount>0. and not l_heal then",1)
   anchor="            elseif(Forsaken_ElementAbilityLevel(t,'A0RU')>0)then";assert anchor in t
   t=t.replace(anchor,"            elseif GetUnitAbilityLevel(t,'nHS8')>0 then\n                set l_amount=RMaxBJ(1.,l_amount-100.)\n"+anchor,1)
  if n=='Trig_Damage_Engine_Step19_Apply':
   anchor="if IsUnitIllusion(u) and not (GetUnitTypeId(u)=='nhdc' and GetOwningPlayer(u)==Player(11)) then";assert anchor in t
   t=t.replace(anchor,anchor.replace(' then'," and not (GetUnitTypeId(u)=='nwgs' and N98Data!=null and HaveSavedHandle(N98Data,GetHandleId(u),30)) then"),1)
  if n=='Trig_Aqualung_Cast_IsAqualungAbility':t=t.replace('return(',"return(GetSpellAbilityId()=='nAQ8' or ",1)
  if n=='Trig_Aqualung_Cast_Actions':t=t.replace('    call SaveReal(AquaData,key,3,damage*Prof_RodPower(caster))',"    if GetSpellAbilityId()=='nAQ8' then\n        call SaveReal(AquaData,key,3,400.)\n    else\n        call SaveReal(AquaData,key,3,damage*Prof_RodPower(caster))\n    endif",1)
  if n=='Missile_DamageUnit':
   anchor='    if MissileNoDamage[l_idx]then';assert anchor in t
   t=t.replace(anchor,'''    if MissileTag[l_idx]==98 and IsUnitAlly(t,GetOwningPlayer(udg_MissileCaster[l_idx])) then
        if GetWidgetLife(t)>.405 and not IsUnitInGroup(t,udg_MissileHitGroup[l_idx]) then
            call GroupAddUnit(udg_MissileHitGroup[l_idx],t)
            call SetWidgetLife(t,RMinBJ(I2R(BlzGetUnitMaxHP(t)),GetWidgetLife(t)+1000.))
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Human\\\\HolyBolt\\\\HolyBoltSpecialArt.mdl",t,"origin"))
        endif
        return
    endif
'''+anchor,1)
  if t!=b:s=put(s,n,t)
 if 'B88_UpdateSpawnTimer' in fs:
  timer=fs['B88_UpdateSpawnTimer'].replace('B88_UpdateSpawnTimer','N98_UpdateSpawnTimer').replace(',3,2)',',3,6)').replace(',1,2)',',1,6)').replace('SpawnFactor(2)','SpawnFactor(6)')
  s=s.replace('function B88_UpdateSpawnTimer takes',timer+'\nfunction B88_UpdateSpawnTimer takes',1)
 if 'RegisterTriggers_MonsterData' in fs:
  frag=(ROOT/'experiments/GuardiaForest/Naga98.j').read_text();g=re.search(r'globals\n(.*?)endglobals',frag,re.S)
  s=s.replace('endglobals',g[1]+'endglobals',1).replace('function RegisterTriggers_MonsterData takes',frag[g.end():].strip()+'\nfunction RegisterTriggers_MonsterData takes',1)
  s=sort98(s)
 if 'Missile_CreateWithEffects' in fs:
  # Defined after missile allocation helpers; gameplay module calls by name to avoid a library cycle.
  s=s.replace('function Missile_DamageUnit takes',WAVE+'\nfunction Missile_DamageUnit takes',1)
 return s

def main():
 package.BASE=BASE;package.OUT=OUT;package.LABEL=LABEL;package.STATS=STATS;package.ICONS=ICONS
 package.objects95=objects98;package.refresh95=refresh98;package.build()
 p=OUT.with_suffix('.json');r=json.loads(p.read_text());r['new_polling_timers']='None always active; one 10Hz Vortex timer only while pulling targets. Existing 1Hz monster heartbeat reused.';p.write_text(json.dumps(r,indent=2))
if __name__=='__main__':main()

