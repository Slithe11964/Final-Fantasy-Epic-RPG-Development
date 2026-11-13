"""Ancient Forest roles and correction of Naga aura/Frost Armor/Vortex presentation."""
from build_forest86 import *
import struct
import build_central95 as package
from build_naga98 import sort98
BASE=ROOT/'release/development/QuickUI98/FFERPG-QuickUI98.w3x'
OUT=ROOT/'release/development/QuickUI99/FFERPG-QuickUI99.w3x'
LABEL='FFERPG QuickUI99 (Ancient Forest)'
STATS={'n00P':(50,9000,None,None,None),'nepl':(44,7500,55,None,None),'nenp':(46,8000,44,345,348),'nsty':(40,4500,42,303,313),'n0ML':(45,6200,44,469,477),'n01N':(48,5500,20,301,304),'n010':(49,10000,64,376,400),'nsat':(43,4500,50,256,284),'nstl':(45,6000,57,274,301),'nsts':(46,5400,54,None,None),'nsth':(50,7200,61,360,370),'nenc':(43,5950,65,316,324),'n00N':(46,6500,None,None,None),'n00O':(43,5500,125,351,362)}
ICONS={}
SUMMONS={'qL99':('ewsp','Life of the Forest',40,2000,30,'none',0,0,'normal',0,320.),'qD99':('edry','Corrupted Dryad',40,4000,62,'small',212,244,'pierce',600,300.),'qS99':('efdr','Sylph',45,5000,10,'hero',175,225,'chaos',600,350.),'qE99':('nfro','Brood Shell',40,2000,30,'fort',0,0,'normal',0,0.),'qI99':('ninf','Forest Infernal',45,4000,20,'divine',200,243,'chaos',128,270.),'qT99':('nenc','Corrupted Ent',40,2200,41,'fort',212,232,'siege',128,270.),'qA99':('earc','Corrupted Archer',40,3600,30,'small',180,197,'pierce',600,300.)}
def objects99(v):
 u=all_objects(v,'w3u');old=all_objects(v,'w3a');oldb=all_objects(v,'w3h');a={};b={}
 def add(r,base,name,desc,icon,cd=0.,mana=0,target='air,ground,enemy,vulnerable',area=0.,reach=600.):
  o=ability(r,base,name,desc,icon,cd,mana,target,area,reach);a[r]=o;ICONS[r]=icon;return o
 def ch(r,name,desc,icon,order,target=0,cd=30.,mana=0,area=0.,reach=600.):
  o=channel(r,name,desc,icon,order,target,cd,mana,area,reach);a[r]=o;ICONS[r]=icon
  for k,val in [('Ncl3',1),('acat',''),('atat',''),('asat',''),('aeat',''),('aefs',''),('aefl','')]:mod(o,k,val,1 if k=='Ncl3' else 0)
  mod(o,'atar','air,ground,enemy,vulnerable' if target==1 else 'air,ground,friend,enemy,self,vulnerable',1)
  return o
 def passive(r,name,desc,icon):
  o=add(r,'AIev',name,desc,icon);mod(o,'Eev1',0.,1);return o
 def buff(r,base,name,desc,icon,art):
  o={'base':base,'id':r,'sets':[{'flag':0,'mods':[]}]}
  for k,val in [('fnam',name),('ftip',name),('fube',desc),('fart','ReplaceableTextures\\CommandButtons\\'+icon),('ftat',art),('fta0','origin')]:setf(o,k,val,0)
  b[r]=o
 def mark(r,br,name,desc,icon,art,dur):
  o=add(r,'Acrs',name,desc,icon,target='air,ground,friend,enemy,self,organic,mechanical',reach=99999.)
  setf(o,'Crs\0',0.,1,data=1)
  for k,val in [('abuf',br),('adur',dur),('ahdu',dur),('acat',''),('atat','')]:mod(o,k,val,0 if k in ['acat','atat'] else 1)
  if br not in ['B007','B05O']:buff(br,'Bcrs',name,desc,icon,art)
 ch('zRT9','Plant Roots','Roots in place for 30 seconds, becoming a stationary base and gaining 100 armor. Produces one Life of the Forest every 5 seconds (six total). Uproots automatically afterward. AI plants only while its other summons/Devour are on cooldown. 60-second cooldown.','BTNCorruptedTreeOfLife.blp','root',cd=60.)
 ch('zAW9','Produce Corrupted Archers','Roots as a stationary base for 30 seconds, producing a Corrupted Archer every 5 seconds (six total). Takes 25% increased damage while rooted. Uproots automatically. 60-second cooldown.','BTNCorruptedAncientOfWar.blp','root',cd=60.)
 ch('zAP9','Rooted Protector','Roots as a tower for 30 seconds. Tower attack:451–512 siege damage,1000 range. Takes 25% increased damage. Uproots automatically to351–362 damage at melee range. 60-second cooldown.','BTNCorruptedAncientProtector.blp','root',cd=60.)
 ch('zUP9','Uproot','Ends the rooted form and resumes walking. Production stops.','BTNUnLoad.blp','unroot',cd=0.)
 ch('zDY9','Summon Corrupted Dryads','Summons two level40 Corrupted Dryads for60seconds:4000health,62light armor,212–244 piercing damage at600range. Each attack removes1accuracy; every stack expires independently after30seconds. 250mana;60-second cooldown.','BTNDryad.blp','forceofnature',cd=60.,mana=250)
 ch('zSY9','Summon Sylph','Summons a level45 Faerie Dragon for60seconds:5000health,10Impenetrable armor,175–225chaos damage. Casts5-second Silence, Haste, Imperil, Protect and Shell. 800mana;30-second cooldown.','BTNFaerieDragon.blp','waterelemental',cd=30.,mana=800)
 ch('zDV9','Devour Ancient Forest Creature','Consumes an injured friendly Ancient Forest creature. Absorbs attack,maximum HP/mana and armor; restores its remaining HP. Two uses maximum; no heroes,summons or special quest units. 300mana;20-second cooldown.','BTNCannibalize.blp','devour',1,20.,300,reach=350.)
 mod(a['zDV9'],'atar','air,ground,friend,organic,mechanical,vulnerable',1)
 o=add('zTH9','AHab','Forest Thorns Aura','Allies within600 reflect10% of incoming physical and magic damage back to their attackers. Reflections do not reflect again.','BTNThorns.blp',target='air,ground,friend,self',area=600.)
 for k,val in [('Hab1',0.),('Hab2',0),('abuf','bTH9')]:mod(o,k,val,1)
 buff('bTH9','BHab','Forest Thorns','Reflects10% of received physical and magic damage.','BTNThorns.blp',r'Abilities\Spells\NightElf\ThornsAura\ThornsAura.mdl')
 passive('zWB9','Forest Bomb','Seeks the nearest enemy hero. Explodes within250 of the target.|n|n|cffffcc00Damage Calculation|r|n3000fire damage to enemies within500. Can be killed before detonating.','BTNWispSplode.blp')
 passive('zDA9','Withering Attacks','Each landed normal attack adds -1accuracy. Stacks independently for30seconds.','BTNPoisonArrow.blp')
 o=add('zPL9','Aap3','Plague','Nearby enemy organic creatures suffer400damage per second. Uses the existing Plague rules and radius.','BTNPlagueCloud.blp');mod(o,'Apl2',400.,1)
 passive('zPO9','Poison Treant Venom','30% chance on landed attacks against a hero to poison for10seconds.|n|n|cffffcc00Damage Calculation|r|n300 + 7 x poisoned hero level damage per second. Equal/stronger poison refreshes instead of stacking.','BTNOrbOfVenom.blp')
 passive('zAL9','Alert','Calls reinforcements on attacking or taking damage from a hero in Ancient Forest. Kill the caller within20seconds to cancel; shows final5–1countdown. A completed call doubles regional spawn frequency and wave size for60seconds. Once per caller.','BTNSatyr.blp')
 for r,dmg,base,name,icon,cd in [('zFL9',1750.,'ACfl','Forked Lightning','BTNMonsoon.blp',15.),('zIC9',2000.,'ACfn','Ice','BTNGlacier.blp',15.),('zAB9',1500.,'AHtb','Aquatic Bolt','BTNCrushingWave.blp',15.)]:
  o=add(r,base,name,f'|cffffcc00Damage Calculation|r|n{int(dmg)} '+('lightning damage to3targets.' if r=='zFL9' else 'ice damage to the target and nearby enemies.' if r=='zIC9' else 'water damage and a3-second stun.')+f' 200mana;{int(cd)}-second cooldown.',icon,cd,200)
  if r=='zFL9':mod(o,'Ocl1',dmg,1);mod(o,'Ocl2',3,1)
  elif r=='zIC9':mod(o,'Ufn1',0.,1);mod(o,'Ufn2',dmg,1);mod(o,'aare',200.,1)
  else:
   for k,val in [('Htb1',dmg),('adur',3.),('ahdu',3.),('amat',r'Abilities\Spells\Other\CrushingWave\CrushingWaveMissile.mdl')]:mod(o,k,val,0 if k=='amat' else 1)
 ch('zEG9','Brood Shell','Creates a destructible2000HP shell. It hatches after10seconds or when killed, releasing3Brood Mothers. Mother Spider also releases3on death. 150mana;30-second cooldown.','BTNSpiderCrab.blp','carrionscarabs',cd=30.,mana=150)
 passive('zBP9','Binding Poison','Every landed attack adds10% movement/attack slow. Each stack lasts45seconds. At15stacks,stuns the hero for5seconds and clears all stacks. Movement slow caps at90% until the stun.','BTNWeb.blp')
 mark('zAM9','bAC9','Withered Accuracy','Accuracy reduced by1per live Dryad stack. Each stack expires after30seconds.','BTNPoisonArrow.blp',r'Abilities\Spells\Undead\Cripple\CrippleTarget.mdl',30.)
 o=add('zSL9','Aslo','Binding Poison Slow','Slowed by10% per active binding stack. Each stack lasts45seconds. 15stacks stun and clear all stacks.','BTNWeb.blp',target='air,ground,enemy,friend,self,vulnerable',reach=99999.)
 mod(o,'alev',14,0)
 for rank in range(1,15):
  for k,val in [('Slo1',min(.9,.1*rank)),('Slo2',.1*rank),('adur',45.),('ahdu',45.),('abuf','bSL9')]:mod(o,k,val,rank)
 buff('bSL9','Bslo','Binding Poison','Movement and attack speed reduced by active binding stacks.','BTNWeb.blp',r'Abilities\Spells\Undead\Web\WebTarget.mdl')
 o=add('zST9','AHtb','Binding Stun','Stunned for5seconds after15binding poison stacks.','BTNStun.blp',reach=99999.)
 for k,val in [('Htb1',0.),('adur',5.),('ahdu',5.),('amat','')]:mod(o,k,val,0 if k=='amat' else 1)
 o=add('zBL9','ACcs','Blind','Uses the existing Blind status and immunities. 100mana;15-second cooldown.','BTNCurse.blp',15.,100)
 setf(o,'Crs\0',0.,1,data=1);mod(o,'abuf','B00P',1);mod(o,'adur',20.,1);mod(o,'ahdu',20.,1)
 o=add('zMI9','AOmi','Mirror Image','Creates one nearby mirror image for30seconds. It deals50%damage and takes50%extra damage. 150mana;30-second cooldown.','BTNMirrorImage.blp',30.,150,area=128.,reach=96.)
 for k,val in [('Omi1',1),('Omi2',.5),('Omi3',1.5),('adur',30.),('ahdu',30.)]:mod(o,k,val,1)
 for r,name,icon,order in [('zDL9','Drain Life','BTNLifeDrain.blp','drain'),('zDM9','Drain Mana','BTNManaDrain.blp','siphonmana')]:
  desc='Drains1000health per second for5seconds. Heals caster and nearby allies within600 for50% of actual health drained.' if r=='zDL9' else 'Drains up to300MP per second for5seconds and restores it to the caster. Deals2x the MP actually drained as magic damage.'
  o=ch(r,name,'|cffffcc00Damage / Healing Calculation|r|n'+desc+' Moving,stopping,losing the target or moving beyond800ends the channel. 200mana;30-second cooldown.',icon,order,1,30.,200,reach=600.);mod(o,'Ncl1',5.,1);mod(o,'Ncl5',1,1)
 ch('zCU9','Cura','|cffffcc00Healing Calculation|r|nRestores1500HP to a friendly target. 150mana;30-second cooldown.','BTNHeal.blp','holybolt',1,30.,150);mod(a['zCU9'],'atar','air,ground,friend,self,vulnerable',1)
 ch('zCL9','Shadow Double','Creates a hostile-to-the-hero illusion of the target hero for30seconds,allied to the Satyr. It deals20% of the copied hero\'s damage. 200mana;30-second cooldown.','BTNShade.blp','shadowstrike',1,30.,200)
 o=add('zCI9','AIil','Shadow Double (native copy)','Creates a20%-damage illusion for30seconds.','BTNShade.blp',target='air,ground,enemy,friend,self',reach=99999.);mod(o,'Iild',.2,1);mod(o,'Iilw',1.,1);mod(o,'adur',30.,1);mod(o,'ahdu',30.,1)
 ch('zAC9','Accumulate','Restores50%maximum HP immediately; +200attack damage and+50armor for20seconds. 125mana;30-second cooldown.','BTNInnerFire.blp','battleroar',cd=30.,mana=125)
 ch('zIF9','Summon Forest Infernal','Summons a level45Infernal for60seconds at the target point:4000HP,20Demon armor,200–243chaos damage. It can use Demon\'s Contest.|n|n|cffffcc00Damage Calculation|r|n2000fire damage within300on impact. 300mana;60-second cooldown.','BTNInfernal.blp','inferno',2,60.,300,area=300.,reach=800.)
 ch('zIT9',"Demon's Contest",'Taunts enemies within450for5seconds. Gains60armor for20seconds. Gaya\'s Break Stun releases the forced attack. 30-second cooldown.','BTNHowlOfTerror.blp','roar',cd=30.,area=450.)
 mark('zIB9','bIA9',"Demon's Contest",'Armor increased by60for20seconds.','BTNHowlOfTerror.blp',r'Abilities\Spells\Human\Defend\DefendCaster.mdl',20.)
 ch('zEN9','Summon Corrupted Ents','Summons3level40Ents for60seconds:2200HP,41Fortified armor,212–232melee siege damage. Each Ent yells on death,granting nearby allies+20%attack speed. Death-yell bonuses stack and last20seconds independently. 200mana;30-second cooldown.','BTNEnt.blp','forceofnature',cd=30.,mana=200)
 passive('zEY9','Death Yell','On death,allies within600gain+20%attack speed for20seconds per yell. Bonuses stack independently.','BTNBattleRoar.blp')
 o=add('zAS9','AIsx','Ent Fury','Attack speed increased by20%per active Death Yell stack.','BTNBattleRoar.blp');mod(o,'alev',32,0)
 for rank in range(1,33):mod(o,'Isx1',.2*rank,rank)
 passive('zCV9','Cover Archers','Corrupted Archers within800transfer50%of incoming damage to this living Ancient of War. Only the nearest guardian absorbs a given hit. The rooted guardian takes25%increased damage.','BTNReinforcedHides.blp')
 # Native projectile helper carries explicit water element and three-second stun.
 a['zQB9']=copy.deepcopy(a['zAB9']);a['zQB9']['id']='zQB9';mod(a['zQB9'],'amcs',0,1);mod(a['zQB9'],'acdn',0.,1)
 for r,name,desc,icon,order in [('zIC9','Ice','2000ice damage to enemies within200of the target. 200mana;15-second cooldown.','BTNGlacier.blp','frostnova'),('zAB9','Aquatic Bolt','Launches a water projectile:1500water damage and a3-second stun. 200mana;15-second cooldown.','BTNCrushingWave.blp','thunderbolt')]:ch(r,name,'|cffffcc00Damage Calculation|r|n'+desc,icon,order,1,15.,200)
 # Sylph uses the same statuses as existing jobs, with isolated spell IDs/cooldowns.
 o=add('zSI9','ACsi','Silence','Silences enemies in the target area for5seconds. 100mana;20-second cooldown.','BTNSilence.blp',20.,100,area=250.)
 for k,val in [('adur',5.),('ahdu',5.),('abuf','B02C')]:mod(o,k,val,1)
 o=add('zHA9','Ablo','Haste','Increases attack speed by80%and movement speed by50%for15seconds. 100mana;15-second cooldown.','BTNBloodLust.blp',15.,100,target='air,ground,friend,self')
 for k,val in [('Blo1',.8),('Blo2',.5),('Blo3',0.),('adur',15.),('ahdu',15.),('abuf','B00F')]:mod(o,k,val,1)
 a['zIM9']=copy.deepcopy(old['cIM5']);a['zIM9']['id']='zIM9'
 for k,val in [('anam','Imperil'),('amcs',100),('acdn',15.),('aran',600.),('adur',20.),('ahdu',20.),('aub1','Lowers elemental resistance by1rank for20seconds. 100mana;15-second cooldown.')]:mod(a['zIM9'],k,val)
 for r,name,icon,order in [('zPR9','Protect','BTNDevotion.blp','innerfire'),('zSH9','Shell','BTNAntiMagicShell.blp','antimagicshell')]:
  ch(r,name,'Reduces '+('physical' if r=='zPR9' else 'magic')+' damage taken by33%for20seconds. 100mana;15-second cooldown.',icon,order,1,15.,100);mod(a[r],'atar','air,ground,friend,self,vulnerable',1)
 mark('zPB9','B007','Protect','Physical damage taken reduced by33%.','BTNDevotion.blp','',20.)
 mark('zSB9','B05O','Shell','Magic damage taken reduced by33%.','BTNAntiMagicShell.blp','',20.)
 adds={'n00P':['zRT9','zDY9','zSY9','zDV9','zTH9'],'nepl':['zPL9'],'nenp':['A03N','zPO9'],'nsty':['zAL9'],'n0ML':['A03N'],'n01N':['zFL9','zIC9','zAB9'],'n010':['zEG9','zBP9'],'nsat':['zBL9','zMI9'],'nstl':['zDL9','zDM9','zCU9'],'nsts':['zCL9'],'nsth':['zAC9','zIF9'],'nenc':['zEN9'],'n00N':['zAW9','zCV9'],'n00O':['zAP9']}
 removes={'nepl':['Aap3'],'nenp':['A0PH'],'n01N':['ACfl','ACcb','A0BG'],'n010':['A0PI','A018'],'nsat':['ACbl','A1F5','ACct','ACf2'],'nstl':['A1BD','ACct','A1F5','A05A'],'nsts':['A1F5','ACbl','ACcs','ACct'],'nsth':['ACbl','A1F5','A03Z']}
 for r,(lv,hp,ar,lo,hi) in STATS.items():
  f=fields(u[r]);ab=[x for x in f.get(('uabi',None),'').split(',') if len(x)==4 and x not in removes.get(r,[])];ab+= [x for x in adds[r] if x not in ab];setf(u[r],'uabi',','.join(ab),None)
  if f.get(('udaa',None)) in removes.get(r,[]):setf(u[r],'udaa','',None)
  for k,val in [('ulev',lv),('uhpm',hp),('udef',float(ar) if ar is not None else None),('ua1b',lo-1 if lo is not None else None),('ua1d',1 if lo is not None else None),('ua1s',hi-lo+1 if lo is not None else None)]:
   if val is not None:setf(u[r],k,val,None)
  if r in ['n00P','nstl','nsth','nenc','n010','nsat','nsts']:setf(u[r],'umpm',2400 if r=='n00P' else 1200,None);setf(u[r],'umpi',2400 if r=='n00P' else 1200,None);setf(u[r],'umpr',20.,None)
  desc=f'Normal level{lv};{hp}HP.'+(f' Armor:{ar}.' if ar is not None else '')+(f' Attack:{lo}–{hi}.' if lo is not None else '')
  for x in adds[r]:
   if x in a:desc+='|n'+fields(a[x])['atp1',1]+': '+fields(a[x])['aub1',1]
  setf(u[r],'utub',desc,None)
 for k in ['unam','utip']:setf(u['n010'],k,'Mother Spider',None)
 summonabil={'qL99':'zWB9','qD99':'zDA9','qS99':'zSI9,zHA9,zIM9,zPR9,zSH9','qE99':'','qI99':'zIT9','qT99':'zEY9','qA99':''}
 for r,(base,name,lv,hp,armor,atype,lo,hi,attack,reach,speed) in SUMMONS.items():
  assert r not in u,r
  o={'base':base,'id':r,'sets':[{'flag':0,'mods':[]}]}
  for k,val in [('unam',name),('utip',name),('ulev',lv),('uhpm',hp),('udef',float(armor)),('udty',atype),('ua1b',max(0,lo-1)),('ua1d',1),('ua1s',max(1,hi-lo+1)),('ua1t',attack),('ua1r',float(reach)),('ua1w','missile' if reach>128 else 'normal'),('uaen',1 if lo else 0),('umvs',speed),('uabi',summonabil[r]),('ufoo',0),('ugol',0),('ulub',0),('ubba',0),('uacq',1000.),('umpm',1800 if r=='qS99' else 600),('umpi',1800 if r=='qS99' else 600),('umpr',20.),('utub',f'Level{lv};{hp}HP;{armor}{atype}armor;{lo}–{hi}{attack}damage. '+('See abilities for calculations.'))]:setf(o,k,val,None)
  if r=='qD99':setf(o,'umdl',r'units\nightelf\Dryad\Dryad.mdl',None);setf(o,'uclr',160,None);setf(o,'uclg',80,None);setf(o,'uclb',180,None)
  if r=='qE99':setf(o,'umdl',r'Doodads\Dungeon\Terrain\EggSack\EggSack0.mdl',None);setf(o,'usca',.65,None);setf(o,'umvs',0.,None)
  if r=='qS99':setf(o,'ufle',1,None)
  u[r]=o
 assert not (set(a)&set(old)), 'New ability collision'
 setf(u['n00O'],'ua1w','missile',None)
 setf(u['n00O'],'ua1m',r'Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl',None)
 setf(u['n00O'],'ua1z',900,None)
 setf(u['n00O'],'ua1r',128.,None)
 # Fix Frost Armor's real armor field, and give auras baked-color assets.
 a['nFA8']=copy.deepcopy(old['nFA8']);mod(a['nFA8'],'Ufa1',5.,1);mod(a['nFA8'],'Ufa2',50.,1)
 for r,asset in [('bMP8','AbyssalPurple'),('bE90','EvasiveGreen')]:
  b[r]=copy.deepcopy(oldb[r]);setf(b[r],'ftat','war3mapImported\\'+asset+'.mdx',0)
 return {r:u[r] for r in list(STATS)+list(SUMMONS)},a,b
def sort99(s):
 helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_','M89_','H90_','C95_','R93_','C97_','N98_','F99_')) and not n.endswith(('UpdateSpawnTimer','BioMana'))}
 if not helpers:return s
 names=set(helpers);deps={n:(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',re.sub(r'"(?:\\.|[^"\\])*"','""',b)))|set(re.findall(r'\bfunction\s+(\w+)',b)))&names-{n} for n,b in helpers.items()};ordered=[];todo=list(helpers)
 while todo:
  ready=[n for n in todo if not deps[n]-set(ordered)];assert ready,todo
  for n in ready:ordered.append(n);todo.remove(n)
 start=min(s.index(b) for b in helpers.values());prefix=s[:start];tail=s[start:]
 for b in helpers.values():tail=tail.replace(b,'',1)
 return prefix+'\n\n'.join(helpers[n] for n in ordered)+'\n'+tail

def refresh99(s):
 fs=functions(s)
 for n,b in fs.items():
  t=b
  if n=='Forest86_Init':
   t=t.replace(' set N98Data=InitHashtable()',' set F99Data=InitHashtable()\n set F99Stacks=InitHashtable()\n set F99Active=CreateGroup()\n set F99Guardians=CreateGroup()\n set N98Data=InitHashtable()',1)
   t=t.replace(' call TriggerAddAction(summons,function N98_Summoned)',' call TriggerAddAction(summons,function N98_Summoned)\n call TriggerAddAction(summons,function F99_Summoned)',1)
  if n=='Forest86_Actor':t=t.replace(' return '," return F99_Pool(raw) or raw=='qS99' or raw=='qI99' or ",1)
  if n=='Forest86_Entered':t=t.replace(' call N98_Track(u)',' call N98_Track(u)\n call F99_Track(u)',1)
  if n=='Forest86_Initial':t=t.replace(' call N98_Track(GetEnumUnit())',' call N98_Track(GetEnumUnit())\n call F99_Track(GetEnumUnit())',1)
  if n=='Forest86_Spell':t=t.replace(' call N98_Spell(caster,victim,raw)',' call N98_Spell(caster,victim,raw)\n call F99_Spell(caster,victim,raw)',1)
  if n=='Forest86_Tick':t=t.replace(' call N98_Tick()',' call N98_Tick()\n call F99_Tick()',1)
  if n=='Forest86_OnAttack':t=t.replace(' call N98_OnHit(attacker,victim)',' call N98_OnHit(attacker,victim)\n call F99_OnHit(attacker,victim)',1)
  if n=='Forest86_Death':
   t=t.replace(' local unit u=GetTriggerUnit()',' local unit u=GetTriggerUnit()\n call F99_Death(u)',1)
   t=t.replace("GetUnitTypeId(u)=='nnmg')","GetUnitTypeId(u)=='nnmg' or GetUnitTypeId(u)=='nsty')",1)
  if n=='Forest86_AI':
   t=t.replace(' call N98_Cleanup(u)',' call N98_Cleanup(u)\n call F99_Cleanup(u)',1)
   t=t.replace(" if raw=='nmpe' or raw=='nnmg' then"," if raw=='nsty' then\n set F99AlertUntil=Forest86Now+60.\n set F99AlertActive=true\n call ExecuteFunc(\"F99_UpdateSpawnTimer\")\n elseif raw=='nmpe' or raw=='nnmg' then",1)
   t=t.replace('or N98_Pool(raw) then',"or N98_Pool(raw) or F99_Pool(raw) or raw=='qS99' or raw=='qI99' then",1)
   t=t.replace(' if N98_Pool(raw) then'," if F99_Pool(raw) or raw=='qS99' or raw=='qI99' then\n call F99_AI(u,victim)\n elseif N98_Pool(raw) then",1)
  if n=='Forest86_Alert':
   t=t.replace(" and GetUnitTypeId(u)!='nnmg'"," and GetUnitTypeId(u)!='nnmg' and GetUnitTypeId(u)!='nsty'",1)
   t=t.replace("or GetUnitTypeId(u)=='nnmg' then","or GetUnitTypeId(u)=='nnmg' or GetUnitTypeId(u)=='nsty' then",1)
  if n=='B88_AlertZone':t=t.replace(" if GetUnitTypeId(u)=='nmpe'", " if GetUnitTypeId(u)=='nsty' then\n return 7\n endif\n if GetUnitTypeId(u)=='nmpe'",1)
  if n=='Forest86_SpawnFactor':t=t.replace(' return 1',' if zone==7 and F99AlertUntil>Forest86Now then\n return 2\n endif\n return 1',1)
  if n=='Forest86_Taunt':t=t.replace("or GetUnitTypeId(caster)=='nhyc')", "or GetUnitTypeId(caster)=='nhyc' or GetUnitTypeId(caster)=='qI99')",1)
  if n in ['Trig_Damage_Engine_GetAccuracy','Forsaken_Stat_GetAccuracy','Stats_Stat_GetAccuracy']:
   pos=t.rfind('    return ');assert pos>0
   t=t[:pos]+'''    if F99Data!=null then
        set l_acc=l_acc-I2R(LoadInteger(F99Data,GetHandleId(u),105))
    endif
'''+t[pos:]
  if n=='Element_GetOfUnit':t=t.replace('    if(l_isPhysical)then',"    if not l_isPhysical and GetUnitTypeId(u)=='n01N' then\n        return 3\n    endif\n    if(l_isPhysical)then",1)
  if n=='Trig_Damage_Engine_Step18_FinalModifiers':
   t=t.replace('    set DmgCtx_Amount[c]=l_amount',"    if not l_heal and not l_manaDamage and l_amount>0. then\n        if F99_Active(t,10) and (GetUnitTypeId(t)=='n00N' or GetUnitTypeId(t)=='n00O') then\n            set l_amount=l_amount*1.25\n        endif\n        set l_amount=F99_Share(u,t,l_amount)\n    endif\n    set DmgCtx_Amount[c]=l_amount",1)
  if n=='Trig_Damage_Engine_Actions':t=t.replace('        call B88_Thorns(u,triggeringUnit,l_amount)','        call B88_Thorns(u,triggeringUnit,l_amount)\n        call F99_Thorns(u,triggeringUnit,l_amount,l_dmgKind)',1)
  if n=='B88_Thorns':t=t.replace(' if not B88Reflecting',' if not F99Reflecting and not B88Reflecting',1)
  if n=='Trig_Damage_Engine_Step19_Apply':t=t.replace("    if IsUnitIllusion(u) and not ","    if IsUnitIllusion(u) and not (F99Data!=null and LoadBoolean(F99Data,GetHandleId(u),40)) and not ",1)
  if n=='N98_Track':t='function N98_Track takes unit u returns nothing\n // Colored aura is now native buff art, shared consistently across clients.\nendfunction'
  if n=='N98_Vortex':
   t=t.replace(' local effect fx=AddSpecialEffect("Abilities\\\\Spells\\\\Human\\\\FlameStrike\\\\FlameStrikeTarget.mdl",x,y)',' local effect fx=null\n call F99_VortexFx(x,y)',1)
   t=t.replace(' call BlzSetSpecialEffectColor(fx,40,0,70)\n call DestroyEffect(fx)','',1)
  if t!=b:s=put(s,n,t)
 if 'B88_UpdateSpawnTimer' in fs:
  timer=fs['B88_UpdateSpawnTimer'].replace('B88_UpdateSpawnTimer','F99_UpdateSpawnTimer').replace(',3,2)',',3,7)').replace(',1,2)',',1,7)').replace('SpawnFactor(2)','SpawnFactor(7)')
  s=s.replace('function B88_UpdateSpawnTimer takes',timer+'\nfunction B88_UpdateSpawnTimer takes',1)
 if 'RegisterTriggers_MonsterData' in fs:
  frag=(ROOT/'experiments/Ancient99/Ancient99.j').read_text();g=re.search(r'globals\n(.*?)endglobals',frag,re.S)
  s=s.replace('endglobals',g[1]+'endglobals',1).replace('function RegisterTriggers_MonsterData takes',frag[g.end():].strip()+'\nfunction RegisterTriggers_MonsterData takes',1)
  s=sort99(s)
 return s

def main():
 package.BASE=BASE;package.OUT=OUT;package.LABEL=LABEL;package.STATS=STATS;package.ICONS=ICONS
 package.objects95=objects99;package.refresh95=refresh99
 write=package.write_files
 assets={'war3mapImported\\'+p.name:p.read_bytes() for p in (ROOT/'experiments/Ancient99/Assets').iterdir() if p.suffix in ['.mdx','.tga']}
 assert len(assets)==4
 def write_assets(src,dest,files):
  files.update(assets)
  imp=MPQ(str(src)).read('war3map.imp');version,count=struct.unpack_from('<II',imp);entries=[]
  for name in assets:
   assert name.encode()+b'\0' not in imp
   entries.append(bytes([13])+name.encode()+b'\0')
  files['war3map.imp']=struct.pack('<II',version,count+len(entries))+imp[8:]+b''.join(entries)
  return write(src,dest,files)
 package.write_files=write_assets
 package.build()
 archive=MPQ(str(OUT))
 for name,data in assets.items():assert archive.read(name)==data,name
 p=OUT.with_suffix('.json');r=json.loads(p.read_text());r.update(summons=SUMMONS,new_polling_timers='None: existing 1Hz monster heartbeat; only one-shot Vortex effect and mirror binding timers.',assets=list(assets));p.write_text(json.dumps(r,indent=2))
if __name__=='__main__':main()
