"""Central Islands roles on QuickUI94; production/classic and arena rosters preserved."""
from build_forest86 import *
from build_highroad90 import sort90
from build_removals91 import pool_blocks
from editor_pair import runtime_for
BASE=ROOT/'release/development/QuickUI94/FFERPG-QuickUI94.w3x'
OUT=ROOT/'release/development/QuickUI95/FFERPG-QuickUI95.w3x'
LABEL='FFERPG QuickUI95 (Central Islands)'
STATS={
 'ntrd':(45,17500,400,917,932,None),'ntrg':(30,7000,250,300,312,None),
 'nahy':(30,5000,58,252,281,None),'nehy':(26,4000,44,200,218,None),'ntrs':(20,3200,47,176,181,None),
 'njgb':(30,7400,62,306,332,1000),'njga':(27,6100,52,250,259,None),'njg1':(20,3700,38,171,183,None),
 'nlkl':(29,6800,None,212,243,None),'nlsn':(26,4420,51,197,205,None),'nltc':(24,3340,28,157,192,None),
 'nlds':(25,4800,34,238,247,None),'nlrv':(29,4100,7,193,211,None),'ndrv':(27,3600,5,152,189,None),
 'nsrv':(23,2900,10,184,187,None),'ntrv':(20,1900,4,127,129,None),'nsc2':(27,5000,38,157,182,None),
 'nsc3':(24,4200,32,172,201,None),'nscb':(21,2800,29,170,191,None),'nmsc':(27,4100,29,161,189,None),
 'nmtw':(24,3150,44,210,231,None),'nmcf':(22,2800,41,135,154,None),'nmbg':(20,3150,32,154,193,None)}
ICONS={};DESCS={}

def objects95(v):
 u=all_objects(v,'w3u');old=all_objects(v,'w3a');a={};buffs={}
 def add(raw,base,name,desc,icon,cd=0.,mana=0,target='air,ground,enemy,vulnerable',area=0.,reach=600.):
  a[raw]=ability(raw,base,name,desc,icon,cd,mana,target,area,reach);ICONS[raw]=icon;DESCS[raw]=desc;return a[raw]
 def ch(raw,name,desc,icon,order,target=0,cd=20.,mana=0,area=0.,reach=600.):
  a[raw]=channel(raw,name,desc,icon,order,target,cd,mana,area,reach)
  for k,val in [('Ncl3',1),('acat',''),('atat',''),('aeat',''),('asat',''),('acac',0),('atac',0),('Ncl5',0)]:mod(a[raw],k,val,1 if k.startswith('Ncl') else 0)
  mod(a[raw],'atar','air,ground,enemy,vulnerable',1);ICONS[raw]=icon;DESCS[raw]=desc;return a[raw]
 def passive(raw,name,desc,icon):
  o=add(raw,'AIev',name,desc,icon);mod(o,'Eev1',0.,1);return o
 def status(raw,buff,name,desc,icon,art,duration):
  o=add(raw,'Acrs',name,desc,icon,0.,0,'air,ground,friend,enemy,self,organic,mechanical',reach=99999.)
  setf(o,'Crs\0',0.,1,data=1)
  for k,val in [('adur',duration),('ahdu',duration),('abuf',buff),('acat',''),('atat','')]:mod(o,k,val,1 if k not in ['acat','atat'] else 0)
  b={'base':'Bcrs','id':buff,'sets':[{'flag':0,'mods':[]}]}
  for k,val in [('fnam',name),('ftip',name),('fube',desc),('fart','ReplaceableTextures\\CommandButtons\\'+icon),('ftat',art),('fta0','origin')]:setf(b,k,val,0)
  buffs[buff]=b
 def clonebuff(raw,base,name,desc,icon,art):
  b={'base':base,'id':raw,'sets':[{'flag':0,'mods':[]}]}
  for k,val in [('fnam',name),('ftip',name),('fube',desc),('fart','ReplaceableTextures\\CommandButtons\\'+icon),('ftat',art),('fta0','origin')]:setf(b,k,val,0)
  buffs[raw]=b
 passive('cG15','Adaman Guard','15% chance to block physical attacks or spells.','BTNAdvancedMoonArmor.blp')
 passive('cG10','Shell Guard','10% chance to block physical attacks or spells.','BTNImprovedMoonArmor.blp')
 passive('cP25','Ancient Hydra Venom','25% chance on a landed attack to poison for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n10 + 6 x attacking hydra level per second. Equal/stronger poison refreshes instead of stacking.','BTNOrbOfVenom.blp')
 passive('cP33','Hydra Venom','33% chance on a landed attack to poison for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n100 + 5 x attacking hydra level per second. Equal/stronger poison refreshes instead of stacking.','BTNPoisonArrow.blp')
 passive('cE40','Island Evasion','40 evasion.','BTNDrunkenDodge.blp')
 passive('cAL5','Alert','On attacking or taking damage from a hero in Central Islands, calls reinforcements for 15 seconds. Final 5-4-3-2-1 countdown. Kill caller to cancel. Doubles Central Islands spawn frequency, wave amount and population cap for 60 seconds. Once per caller.','BTNAncestralStaff.blp')
 o=add('cAU5','ACac','Command Aura','Nearby melee allies within 600 gain 15% attack damage.','BTNDrum.blp',target='air,ground,friend,self',area=600.)
 for k,val in [('Cac1',.15),('Ear2',1),('Ear3',0),('Ear4',0)]:mod(o,k,val,1)
 ch('cPU5','1–2 Punch','Two elemental punches. The second connects only if the enemy is still alive and within 300.|n|n|cffffcc00Damage Calculation|r|nFirst: 1400 water damage and Imperil (one resistance rank lower for 10 seconds). After 2 seconds: 1000 earth damage and a 3-second stun.|n150 mana; 30-second cooldown.','BTNSeaGiantPulverize.blp','thunderbolt',1,30.,150,reach=200.)
 # Same native Imperil buff/rank rule as Calculator; isolate duration/area.
 a['cIM5']=copy.deepcopy(old['A0RX']);a['cIM5']['id']='cIM5'
 for k,val in [('alev',1),('amcs',0),('acdn',0.),('adur',10.),('ahdu',10.),('aare',.01),('aran',99999.),('areq','')]:mod(a['cIM5'],k,val,0 if k in ['alev','areq'] else 1)
 ch('cDV5','Devour Central Islands Creature','Consumes an injured friendly creature from the Central Islands pool, absorbing its attack, maximum health/mana and armor and healing its remaining HP. Two uses maximum. Unlocks Elementa. No heroes or special quest creatures. 200 mana; 20-second cooldown.','BTNCannibalize.blp','devour',1,20.,200,reach=350.)
 ch('cEL5','Elementa','Unlocked after Devour. Uses Elementa’s Fire, Ice and Bolt effects.|n|n|cffffcc00Damage Calculation|r|nEach primary elemental hit: 2 x current base attack damage (including Devour gains). Bolt’s secondary missiles deal 30% of its primary damage. Existing Fire/Ice splash and Bolt paths apply.|n1100 mana; 45-second cooldown.','BTNOrbOfLightning.blp','firebolt',1,45.,1100)
 passive('cCR5','Crushing Critical','20% chance on a landed normal attack to deal 2.5x damage and slow attack and movement speed by 20% for 5 seconds.','BTNCrushingWave.blp')
 o=add('cSL5','Aslo','Crushing Slow','Movement and attack speed reduced by 20% for 5 seconds.','BTNSlow.blp',target='air,ground,enemy',reach=99999.)
 for k,val in [('Slo1',.2),('Slo2',.2),('adur',5.),('ahdu',5.)]:mod(o,k,val,1)
 o=add('cFK5','AEfk','Stone Knives','Sends knives at enemies within 600.|n|n|cffffcc00Damage Calculation|r|n1600 earth damage per enemy.|n200 mana; 15-second cooldown.','BTNImpalingBolt.blp',15.,200,area=600.)
 for k,val in [('Efk1',1600.),('Efk2',999999.),('Efk3',0.),('Efk4',1.)]:mod(o,k,val,1)
 ch('cSK5','Tidal Shuriken','Throws a spinning, returning blade around the caster, using the Ninja shuriken path.|n|n|cffffcc00Damage Calculation|r|n1400 water damage on projectile contact; the existing shuriken hit groups prevent repeated hits in the same pass.|n200 mana; 15-second cooldown.','BTNUpgradeMoonGlaive.blp','battleroar',0,15.,200)
 ch('cWV5','Water Wave','Sends a wave up to 1000 units, striking enemies along its path (200 collision radius).|n|n|cffffcc00Damage Calculation|r|n1200 water damage per enemy.|n100 mana; 20-second cooldown.','BTNSeaElemental.blp','shockwave',2,20.,100,reach=1000.)
 o=add('cRG5','Absk','Island Berserk','Increases attack speed by 80% and damage taken by 20% for 10 seconds. 20-second cooldown.','BTNBerserk.blp',20.)
 for k,val in [('bsk1',0.),('bsk2',.8),('bsk3',.2),('adur',10.),('ahdu',10.)]:mod(o,k,val,1)
 ch('cSH5','Shielding Shout','Allies within 600 gain 10 percentage points of physical and spell block chance for 20 seconds. 30-second cooldown.','BTNHumanArmorUpTwo.blp','roar',cd=30.,area=600.)
 ch('cGD5','Raise Shield','Raises a shield, increasing physical block chance by 40 percentage points for 10 seconds. 30-second cooldown.','BTNHumanArmorUpThree.blp','defend',cd=30.)
 o=add('cBN5','AHbn','Banish Self','Banishes itself for 15 seconds: native ethereal immunity to physical attacks. Can summon water elementals while banished. 100 mana; 30-second cooldown.','BTNBanish.blp',30.,100,target='self,ground,friend')
 for k,val in [('Hbn1',0.),('Hbn2',0.),('adur',15.),('ahdu',15.),('abuf','bBN5')]:mod(o,k,val,1)
 clonebuff('bBN5','BHbn','Banished','Ethereal: immune to physical attacks; can cast spells.','BTNBanish.blp','Abilities\\Spells\\Human\\Banish\\BanishTarget.mdl')
 ch('cSU5','Summon Tidal Guardians','While banished, summons two water elementals for 60 seconds. Each has 2000 HP, 3 Divine armor, 125–139 magic attack, range 600, and a frost-slowing attack. 150 mana; 30-second cooldown.','BTNWaterElemental.blp','waterelemental',cd=30.,mana=150)
 o=add('cNT5','AHtb','Binding Net','Wraps an enemy in an orange net, preventing all actions for 4 seconds. Gaya’s Break Stun removes it. 300 mana; 20-second cooldown.','BTNWeb.blp',20.,300)
 for k,val in [('Htb1',0.),('adur',4.),('ahdu',4.),('abuf','bNT5'),('amat','Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl')]:mod(o,k,val,0 if k=='amat' else 1)
 clonebuff('bNT5','BPSE','Binding Net','Unable to act. Gaya’s Break Stun releases this net.','BTNWeb.blp','Abilities\\Spells\\Orc\\Ensnare\\ensnareTarget.mdl')
 o=add('cBI5','ACcs','Blind','Uses the map’s Blind status: halves hit chance for 30 seconds and respects Blindproof and Eye of the Dragon. 200 mana; 10-second cooldown.','BTNWitchDoctorAdept.blp',10.,200)
 setf(o,'Crs\0',0.,1,data=1)
 for k,val in [('abuf','B00P'),('adur',30.),('ahdu',30.)]:mod(o,k,val,1)
 ch('cPN5','Pinch','Pinches an enemy and reduces its accuracy by 30 for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n1200 physical damage.|n200 mana; 15-second cooldown.','BTNLobstrokkRed.blp','cripple',1,15.,200,reach=180.)
 ch('cBU5','Restorative Burrow','At 50% health or less, burrows and becomes untargetable for 5 seconds. Emerges fully healed, with +80 evasion for 3 seconds. 200 mana; 30-second cooldown.','BTNNagaBurrow.blp','burrow',cd=30.,mana=200)
 ch('cWW5','Earthen Whirlwind','Whirls through nearby enemies for 5 seconds, within 250.|n|n|cffffcc00Damage Calculation|r|n800 earth damage per second.|n200 mana; 30-second cooldown.','BTNSpinyCrab.blp','whirlwind',cd=30.,mana=200,area=250.)
 ch('cRA5','Healing Rain','Channels healing rain over friendly units within 600 for 10 seconds. Moving or stopping ends the rain.|n|n|cffffcc00Healing Calculation|r|n200 health per second per ally (up to 2000).|n200 mana; 20-second cooldown.','BTNTranquility.blp','tranquility',cd=20.,mana=200,area=600.)
 mod(a['cRA5'],'Ncl1',10.,1);mod(a['cRA5'],'Ncl5',1,1)
 ch('cCH5','Bleeding Charge','Dashes to an enemy and stabs it.|n|n|cffffcc00Damage Calculation|r|n1000 physical damage, then 100 + 7 x wounded hero level physical bleed damage per second for 5 seconds.|n250 mana; 20-second cooldown.','BTNReinforcedHides.blp','charge',1,20.,250,reach=800.)
 ch('cWR5','Elemental War Cry','Allies within 600 gain 100 attack damage for 20 seconds. Their normal attacks become earth-elemental for melee allies, water-elemental for ranged allies. 30-second cooldown.','BTNSeaGiantWarStomp.blp','howlofterror',cd=30.,area=600.)
 o=add('cD15','AIat','War Cry Damage','Attack damage increased by 100.','BTNArcaniteMelee.blp');mod(o,'Iatt',100,1)
 o=add('cAS5','AIsx','Constant Haste','Attack speed is always increased by 30%.','BTNGlove.blp');mod(o,'Isx1',.3,1)
 for raw,buff,name,desc,icon,art,dur in [
 ('cBL5','bBL5','Bleeding','Losing health each second from Bleeding Charge.','BTNThorns.blp','Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl',5.),
 ('cEV5','bEV5','Burrow Recovery','Evasion increased by 80.','BTNCarrionScarabs.blp','Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl',3.),
 ('cPB5','bPB5','Pinched','Accuracy reduced by 30.','BTNCripple.blp','Abilities\\Spells\\Undead\\Cripple\\CrippleTarget.mdl',10.),
 ('cSB5','bSB5','Shield Raised','Physical block chance increased by 40 percentage points.','BTNHumanArmorUpThree.blp','Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl',10.),
 ('cGB5','bGB5','Shielding Shout','Physical and spell block chance increased by 10 percentage points.','BTNHumanArmorUpTwo.blp','Abilities\\Spells\\Human\\DevotionAura\\DevotionAura.mdl',20.),
 ('cWB5','bWB5','Elemental War Cry','Attack damage +100; melee attacks are earth, ranged attacks are water.','BTNSeaGiantWarStomp.blp','Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl',20.),
 ('cPO5','bPO5','Hydra Poison','Losing health each second from hydra venom.','BTNOrbOfVenom.blp','Abilities\\Spells\\Other\\Poison\\PoisonTarget.mdl',10.)]:status(raw,buff,name,desc,icon,art,dur)
 stock={r['unitAbilID']:r for r in slk((ROOT/'tools/build-inputs/unitabilities.slk').read_bytes())}
 for raw,(lv,hp,armor,lo,hi,mana) in STATS.items():
  for k,val in [('ulev',lv),('uhpm',hp),('udef',float(armor) if armor is not None else None),('ua1b',lo-1),('ua1d',1),('ua1s',hi-lo+1),('umpm',mana),('umpi',mana)]:
   if val is not None:setf(u[raw],k,val,None)
 adds={'ntrd':['cG15'],'ntrg':['cG10'],'nahy':['cP25','cE40','Aspy'],'nehy':['cP33','cE40','A03N'],'ntrs':['cG10','cAL5'],'njgb':['cAU5','cPU5','cDV5'],'njga':['cCR5'],'njg1':['cAL5','cE40'],'nlkl':['cFK5'],'nlsn':['cSK5'],'nltc':['cWV5'],'nlds':['cRG5'],'nlrv':['cSH5','cGD5'],'ndrv':['cBN5','cSU5'],'nsrv':['cNT5'],'ntrv':['cBI5'],'nsc2':['cPN5'],'nsc3':['cBU5'],'nscb':['cWW5'],'nmsc':['cRA5'],'nmtw':['cCH5'],'nmcf':['cWR5'],'nmbg':['cAS5']}
 for raw,extra in adds.items():
  f=fields(u[raw]);abil=f.get(('uabi',None),stock.get(u[raw]['base'],{}).get('abilList','')).split(',')
  remove={'Aspo','ACvs','ACss','A0PH'} if raw in ['nahy','nehy'] else set()
  if raw in ['ntrd','ntrg']:remove|={'ACrk'}
  if raw=='nmsc':remove|={'ACcs'}
  abil=[x for x in abil if len(x)==4 and x not in remove]
  for r in extra:
   if r not in abil:abil.append(r)
  setf(u[raw],'uabi',','.join(abil),None)
  if any(a.get(r,{}).get('base')!='AIev' and fields(a[r]).get(('amcs',1),0)>0 for r in extra if r in a) and raw!='njgb' and fields(u[raw]).get(('umpm',None),0)<400:
   setf(u[raw],'umpm',600,None);setf(u[raw],'umpi',600,None)
  lv,hp,ar,lo,hi,mp=STATS[raw]
  desc=f'Normal level {lv}; {hp} HP; {lo}–{hi} attack damage.'+(f' Armor: {ar}.' if ar is not None else '')
  desc+='|n'+'|n'.join(fields(a[r]).get(('anam',0),'')+': '+DESCS.get(r,'') for r in extra if r in a)
  if raw=='nahy':desc+='|nSplits into two smaller Hydras on death (native Spawn Hydra).'
  if raw=='nehy':desc+='|nNight Might: existing night-time damage/resistance bonuses.'
  setf(u[raw],'utub',desc,None)
 # Explicit ranged magic attacker and separate timed summon definition.
 for k,val in [('ua1r',600),('ua1w','missile'),('ua1t','magic'),('ua1m','Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl'),('ua1z',900)]:setf(u['ndrv'],k,val,None)
 setf(u['njgb'],'umpr',20.,None)
 setf(u['njgb'],'utub',fields(u['njgb'])['utub',None]+'|nMana regeneration: 20 per second. Elementa needs the expanded mana pool after Devour.',None)
 summon={'base':'hwat','id':'cWE5','sets':[{'flag':0,'mods':[]}]}
 for k,val in [('unam','Tidal Guardian'),('uhpm',2000),('udef',3.),('udty','divine'),('ua1b',124),('ua1d',1),('ua1s',15),('ua1r',600),('ua1t','magic'),('ua1w','missile'),('uabi','cFR5'),('ulev',20),('uacq',1000.),('ufoo',0),('ubba',0),('ugol',0),('ulub',0),('utub','Summoned for 60 seconds. 2000 HP, 3 Divine armor; 125–139 magic attack, range 600. Frost attacks slow movement by 30% and attack speed by 20% for 3 seconds.')]:setf(summon,k,val,None)
 u['cWE5']=summon
 passive('cFR5','Frost Attack','Attacks slow movement by 30% and attack speed by 20% for 3 seconds.','BTNOrbOfFrost.blp')
 o=add('cFS5','Aslo','Frost Slow','Movement reduced by 30% and attack speed by 20% for 3 seconds.','BTNOrbOfFrost.blp',reach=99999.)
 for k,val in [('Slo1',.3),('Slo2',.2),('adur',3.),('ahdu',3.),('abuf','Bfro')]:mod(o,k,val,1)
 assert not set(a)&set(old),'New spells must not overwrite existing spells.'
 return {r:u[r] for r in list(STATS)+['cWE5']},a,buffs

def refresh95(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n=='Forest86_Init':new=new.replace(' set Forest86Data=InitHashtable()',' set C95Data=InitHashtable()\n set C95Buffs=CreateGroup()\n set Forest86Data=InitHashtable()',1)
  if n=='Forest86_Actor':new=new.replace(' return ',' return C95_Pool(raw) or ',1)
  if n=='Forest86_Spell':new=new.replace(' call H90_Spell(caster,victim,raw)',' call H90_Spell(caster,victim,raw)\n call C95_Spell(caster,victim,raw)',1)
  if n=='Forest86_Tick':new=new.replace(' call ForGroup(H90Buffs',' call C95_Tick()\n call ForGroup(H90Buffs',1)
  if n=='Forest86_OnAttack':new=new.replace(' if Forest86Data!=null',' call C95_Poison(attacker,victim)\n if Forest86Data!=null',1)
  if n=='Forest86_Evasion':new=new.replace(' return 0.',' return C95_Evasion(u)',1)
  if n=='B88_BlockChance':
   new=new.replace(' local integer raw=GetUnitTypeId(u)',' local integer raw=GetUnitTypeId(u)\n local integer central=C95_Block(u,physical,magical)\n if central>0 then\n return central\n endif',1)
  if n=='Forest86_Alert':new=new.replace(" and GetUnitTypeId(u)!='ngna'"," and GetUnitTypeId(u)!='ngna' and GetUnitTypeId(u)!='ntrs' and GetUnitTypeId(u)!='njg1'",1)
  if n=='B88_AlertZone':new=new.replace(" if GetUnitTypeId(u)=='ngna'", " if GetUnitTypeId(u)=='ntrs' or GetUnitTypeId(u)=='njg1' then\n return 3\n endif\n if GetUnitTypeId(u)=='ngna'",1)
  if n=='Forest86_AI':
   new=new.replace(" if raw=='ngna' then"," if raw=='ntrs' or raw=='njg1' then\n set C95AlertUntil=Forest86Now+60.\n set C95AlertActive=true\n call ExecuteFunc(\"C95_UpdateSpawnTimer\")\n elseif raw=='ngna' then",1)
   new=new.replace('or H90_Pool(raw) then','or H90_Pool(raw) or C95_Pool(raw) then',1)
   new=new.replace(' if H90_Pool(raw) then',' if C95_Pool(raw) then\n call C95_AI(u,victim)\n elseif H90_Pool(raw) then',1)
  if n=='Forest86_Death':
   new=new.replace(' local unit u=GetTriggerUnit()',' local unit u=GetTriggerUnit()\n call C95_Cleanup(u)',1)
   new=new.replace("GetUnitTypeId(u)=='ngna')", "GetUnitTypeId(u)=='ngna' or GetUnitTypeId(u)=='ntrs' or GetUnitTypeId(u)=='njg1')",1)
  if n=='Forest86_SpawnFactor':new=new.replace(' return 1',' if zone==3 and C95AlertUntil>Forest86Now then\n return 2\n endif\n return 1',1)
  if n=='B88_ChargeEnd':new=new.replace(" if GetUnitTypeId(u)=='nrzg' then", " if GetUnitTypeId(u)=='nmtw' then\n call B88_Damage(u,victim,1000.,true)\n call C95_Bleed(u,victim)\n call DestroyEffect(AddSpecialEffectTarget(\"Abilities\\\\Spells\\\\Other\\\\Stampede\\\\StampedeMissileDeath.mdl\",victim,\"chest\"))\n elseif GetUnitTypeId(u)=='nrzg' then",1)
  if n in ['Trig_Damage_Engine_GetAccuracy','Forsaken_Stat_GetAccuracy','Stats_Stat_GetAccuracy']:
   pos=new.rfind('    return ');new=new[:pos]+'    if C95_Active(u,50) then\n        set l_acc=l_acc-30.\n    endif\n'+new[pos:]
  if n=='Element_GetOfUnit':new=new.replace('    if(l_isPhysical)then','    if l_isPhysical and C95Data!=null and Forest86Now<LoadReal(C95Data,GetHandleId(u),11) then\n        return LoadInteger(C95Data,GetHandleId(u),13)\n    endif\n    if not l_isPhysical and GetUnitTypeId(u)==\'nlkl\' then\n        return 5\n    endif\n    if(l_isPhysical)then',1)
  if n=='Trig_Damage_Engine_Step16_PhysicalHit':
   new=new.replace('    set DmgCtx_Amount[c]=l_amount','    if l_melee and l_amount>0. and BlzGetEventIsAttack() and GetUnitTypeId(u)==\'njga\' and GetRandomInt(1,100)<=20 then\n        set l_amount=l_amount*2.5\n        call M89_Dummy(u,t,\'cSL5\',"slow")\n    endif\n    set DmgCtx_Amount[c]=l_amount',1)
  if n=='Trig_Gaya_BreakStun_Actions':new=new.replace("    call UnitRemoveAbility(u,'BPSE')","    call UnitRemoveAbility(u,'bNT5')\n    call UnitRemoveAbility(u,'BPSE')",1)
  if n=='Trig_Spell_Shuriken_Conditions':
   new,count=re.subn(r"GetSpellAbilityId\(\)\s*==\s*'A0AD'","(GetSpellAbilityId()=='A0AD' or GetSpellAbilityId()=='cSK5')",new,count=1);assert count==1
  if n=='Trig_Spell_Shuriken_Actions':
   pos=new.index('    set udg_ShurikenAngle[d]');new=new[:pos]+"    if GetSpellAbilityId()=='cSK5' then\n        set udg_ShurikenDamage[d]=1400.\n    endif\n"+new[pos:]
   new=new.replace('endfunction','''    if GetSpellAbilityId()=='cSK5' then
        call DestroyEffect(udg_ShurikenEffect[d])
        set udg_ShurikenEffect[d]=AddSpecialEffectTarget("Abilities\\\\Weapons\\\\SentinelMissile\\\\SentinelMissile.mdl",gg_unit_h020_0271[d],"chest")
        call BlzSetSpecialEffectColor(udg_ShurikenEffect[d],70,180,255)
    endif
endfunction''',1)
  if n=='Shuriken_Damage':new=new.replace('                set udg_IsPhysicalAttack=true',"                if GetUnitTypeId(udg_ShurikenCaster[l_idx])=='nlsn' then\n                    set udg_DamageElement=4\n                endif\n                set udg_IsPhysicalAttack=true",1)
  if n in ['Trig_Fire_Cast_IsFire','Trig_Fire_Cast_IsElementa','Trig_Ice_Cast_IsIce','Trig_Ice_Cast_IsElementa','Trig_Spell_Bolt_Conditions']:
   new=new.replace("GetSpellAbilityId()=='A0JD'", "GetSpellAbilityId()=='A0JD' or GetSpellAbilityId()=='cEL5'") if n!='Trig_Spell_Bolt_Conditions' else new.replace("spellAbilityId=='A0JD'", "spellAbilityId=='A0JD' or spellAbilityId=='cEL5'")
  if n in ['Trig_Fire_Cast_Actions','Trig_Ice_Cast_Actions']:
   anchor='    set l_tempReal=Prof_RodPower(GetTriggerUnit())';assert anchor in new
   new=new.replace(anchor,anchor+"\n    if GetSpellAbilityId()=='cEL5' then\n        set l_tempInteger=2*BlzGetUnitBaseDamage(GetTriggerUnit(),0)\n        set l_tempReal=1.\n    endif",1)
  if n=='Trig_Spell_Bolt_Actions':
   anchor='    set r=Trig_Spell_Bolt_DamageFormula(manaCost,GetHeroInt(triggeringUnit,true),Prof_RodPower(triggeringUnit))';assert anchor in new
   new=new.replace(anchor,anchor+"\n    if GetSpellAbilityId()=='cEL5' then\n        set r=2.*I2R(BlzGetUnitBaseDamage(triggeringUnit,0))\n    endif",1)
  if new!=b:s=put(s,n,new)
 if 'B88_UpdateSpawnTimer' in fs:
  timer=fs['B88_UpdateSpawnTimer'].replace('B88_UpdateSpawnTimer','C95_UpdateSpawnTimer').replace(',3,2)',',3,3)').replace(',1,2)',',1,3)').replace('SpawnFactor(2)','SpawnFactor(3)')
  s=s.replace('function B88_UpdateSpawnTimer takes',timer+'\nfunction B88_UpdateSpawnTimer takes',1)
 if 'RegisterTriggers_MonsterData' in fs:
  fragment=(ROOT/'experiments/GuardiaForest/Central95.j').read_text();g=re.search(r'globals\n(.*?)endglobals',fragment,re.S)
  s=s.replace('endglobals',g[1]+'endglobals',1)
  s=s.replace('function RegisterTriggers_MonsterData takes',fragment[g.end():].strip()+'\nfunction RegisterTriggers_MonsterData takes',1)
  # All role helpers share a module; sort cross-area call dependencies together.
  s=sort_helpers(s)
 return s

def sort_helpers(s):
 helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_','M89_','H90_','C95_','R93_')) and not n.endswith(('UpdateSpawnTimer','BioMana'))}
 names=set(helpers);deps={n:(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',re.sub(r'"(?:\\.|[^"\\])*"','""',b)))|set(re.findall(r'\bfunction\s+(\w+)',b)))&names-{n} for n,b in helpers.items()};ordered=[];todo=list(helpers)
 while todo:
  ready=[n for n in todo if not deps[n]-set(ordered)];assert ready,todo
  for n in ready:ordered.append(n);todo.remove(n)
 start=min(s.index(b) for b in helpers.values());prefix=s[:start];tail=s[start:]
 for b in helpers.values():tail=tail.replace(b,'',1)
 return prefix+'\n\n'.join(helpers[n] for n in ordered)+'\n'+tail

def build():
 assert not OUT.exists()
 v=View(BASE);u,a,b=objects95(v);files={}
 for ext,replacements in [('w3u',u),('w3a',a),('w3h',b)]:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;data=v.archive.read(name)
   if not data:continue
   t=read_objects(data,ext);seen=set()
   for table in ['original','custom']:
    if prefix=='war3map':
     seen.update(o['id'] or o['base'] for o in t[table]);t[table]=[copy.deepcopy(replacements.get(o['id'] or o['base'],o)) for o in t[table]]
    else:t[table]=[o for o in t[table] if (o['id'] or o['base']) not in replacements]
   if prefix=='war3map':
    for raw,o in replacements.items():
     if raw not in seen:t['custom' if o['id'] else 'original'].append(copy.deepcopy(o))
   files[name]=write_objects(t,t['version'],ext)
 modules={lib:refresh95(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]}
 runtime,_=order(runtime_for(v,v,v,modules));runtime=re.sub(r'\n{3,}','\n\n',runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 w=wts_read(v.archive.read('war3map.wts'));w[38788]=LABEL
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-4500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(LABEL,flags,players)+d[d.index(b'MPQ\x1a'):])
 final=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert final.read(name)==files.get(name,v.archive.read(name)),name
 for lib in v.modules:
  if 'Arena' in lib:assert modules[lib]==v.modules[lib],lib
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),normal_stats=STATS,icons=ICONS,archive_readback='PASS',arena_rosters='unchanged',new_polling_timers=0,acceptance='Native spell/visual/AI and multiplayer acceptance pending.'),indent=2));print(OUT)

if __name__=='__main__':build()
