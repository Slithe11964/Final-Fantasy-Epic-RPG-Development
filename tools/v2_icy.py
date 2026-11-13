"""Icy Realm object data, isolated from shared player spell definitions."""
from build_forest86 import *

STATS={'n02B':(60,15000,85,384,472),'n025':(56,12500,64,302,418),'n0MQ':(58,20000,86,464,499),'n026':(53,13000,64,362,386),'n02C':(56,14000,53,533,554),'n029':(50,10000,40,264,352),'n02D':(55,9000,56,335,425),'n027':(57,15000,55,464,599),'n028':(59,12000,104,413,443)}
def objects(v):
 u=all_objects(v,'w3u');old=all_objects(v,'w3a');a={};b={}
 def ch(raw,name,desc,icon,order,target,cd,mana,area=0.,reach=800.):
  o=channel(raw,name,desc,icon,order,target,cd,mana,area,reach);a[raw]=o
  for k in ['acat','atat','aeat','asat']:mod(o,k,'war3mapImported\\NoAuraV2.mdx',0)
  mod(o,'Ncl3',1,1)
  if target==1:mod(o,'atar','air,ground,enemy,vulnerable',1)
  return o
 def add(raw,base,name,desc,icon,cd=0.,mana=0,area=0.,reach=800.,target='air,ground,enemy'):
  a[raw]=ability(raw,base,name,desc,icon,cd,mana,target,area,reach);return a[raw]
 def marker(raw,buff,name,desc,icon,art,duration):
  o=add(raw,'Acrs',name,desc,icon,reach=99999.,target='air,ground,friend,enemy,self,organic,mechanical')
  setf(o,'Crs\0',0.,1,data=1)
  for k,val in [('abuf',buff),('adur',duration),('ahdu',duration)]:mod(o,k,val,1)
  for k in ['acat','atat']:mod(o,k,'war3mapImported\\NoAuraV2.mdx',0)
  bb={'base':'Bcrs','id':buff,'sets':[{'flag':0,'mods':[]}]}
  for k,val in [('fnam',name),('ftip',name),('fube',desc),('fart','ReplaceableTextures\\CommandButtons\\'+icon),('ftat',art),('fta0','origin')]:setf(bb,k,val,0)
  b[buff]=bb
 ch('jDV2','Devour Icy Creature','Consumes an injured friendly creature from the Icy Realm day/night pool. Gains its attack damage, maximum HP, maximum mana and armor; heals by its remaining HP. Cannot consume heroes, illusions or special quest units. Two uses maximum. 400 mana; 20-second cooldown.','BTNCannibalize.blp','devour',1,20.,400,reach=350.)
 mod(a['jDV2'],'atar','air,ground,friend,organic,mechanical,vulnerable',1)
 o=add('jEV2','AIev','Icy Evasion','40 evasion.','BTNEvasion.blp');mod(o,'Eev1',0.,1)
 ch('jCL2','Winter Eclipse','Sends a cold line forward, stunning enemy targets and healing allies along its path.|n|n|cffffcc00Effect Calculation|r|n3-second stun per enemy; 2500 HP restored per ally. Each creature is affected once. Path length 1000; width 300. Deals no direct damage. 100 mana; 15-second cooldown.','BTNGlacier.blp','shockwave',2,15.,100,150.,1000.)
 ch('jRG2','Regen','Restores health over 30 seconds.|n|n|cffffcc00Healing Calculation|r|nCaster maximum HP / 30 each second, for 30 ticks (100% of caster maximum HP). Uses maximum HP at cast time. 300 mana; 30-second cooldown.','BTNRegenerate.blp','rejuvination',1,30.,300)
 mod(a['jRG2'],'atar','air,ground,friend,self,vulnerable',1)
 marker('jRM2','bRG2','Icy Regeneration','Recovering the Wendigo Shaman\'s maximum health over 30 seconds.','BTNRegenerate.blp',r'Abilities\Spells\NightElf\Rejuvenation\RejuvenationTarget.mdl',30.)
 ch('jBD2','Blood Duel','Forces one enemy to attack the Berserker until the Berserker dies. During the duel, the Berserker deals 50% more damage, attacks 60% faster, and takes 10% extra damage. Gaya\'s Break Stun cancels the forced attack and ends this duel. The duel also ends if its target dies. 100 mana; 30-second cooldown.','BTNUnholyFrenzy.blp','roar',1,30.,100,reach=600.)
 marker('jDT2','bDT2','Blood Duel','Forced to attack the Wendigo Berserker until it dies, or until Gaya\'s Break Stun cancels the duel.','BTNTaunt.blp',r'Abilities\Spells\NightElf\Taunt\TauntCaster.mdl',1000000.)
 o=add('jAS2','AIsx','Blood Duel Fury','Attack speed increased by 60% during Blood Duel.','BTNBerserk.blp');mod(o,'Isx1',.6,1)
 o=add('jCR2','ACct','Critical Strike','30% chance to deal 2x normal attack damage.','BTNCriticalStrike.blp');mod(o,'Ocr1',30.,1);mod(o,'Ocr2',2.,1)
 o=add('jRO2','AHtb','Throw Stone','Throws a stone at an enemy.|n|n|cffffcc00Damage Calculation|r|n3000 damage on impact; stuns for 4 seconds. 75 mana; 10-second cooldown.','BTNGolemStormBolt.blp',10.,75)
 for k,val in [('Htb1',3000.),('adur',4.),('ahdu',4.),('amat',r'Abilities\Weapons\AncientProtectorMissile\AncientProtectorMissile.mdl')]:mod(o,k,val,0 if k=='amat' else 1)
 o=add('jBF2','ACbf','Breath of Frost','Breathes a blast of ice at enemies.|n|n|cffffcc00Damage Calculation|r|n3000 initial ice damage, then 500 ice damage per second for five seconds (5500 total before modifiers). 280 mana; 15-second cooldown.','BTNBreathOfFrost.blp',15.,280,150.,800.)
 for k,val in [('Ucs1',3000.),('Ucs2',99999.),('Ucs3',250.),('Nbf5',500.),('adur',5.),('ahdu',5.)]:mod(o,k,val,1)
 o=ch('jIB2','Ice Beam','Channels an icy beam at one enemy for up to 10 seconds. Each second adds a separate -20% attack-speed stack. Each stack expires 30 seconds after application; normal Warcraft attack-speed limits still apply. Interrupting the beam stops new stacks. 200 mana; 30-second cooldown.','BTNFreezingBreath.blp','drain',1,30.,200)
 mod(o,'Ncl1',10.,1);mod(o,'Ncl4',10.,1);mod(o,'Ncl5',1,1)
 o=add('jIS2','AIsx','Ice Beam Slow','Attack speed reduced by 20% per Ice Beam stack. Stacks expire independently after 30 seconds.','BTNFreezingBreath.blp');mod(o,'alev',64,0)
 for rank in range(1,65):mod(o,'Isx1',-.2*rank,rank)
 marker('jIM2','bIB2','Ice Beam Slow','-20% attack speed per stack. Each stack expires separately after 30 seconds.','BTNFreezingBreath.blp',r'Abilities\Spells\Other\FrostDamage\FrostDamage.mdl',30.)
 o=add('jAL2','AIev','Alert','On attacking or being damaged by a hero in Icy Realm, begins a 30-second call for reinforcements. Final countdown: 5, 4, 3, 2, 1. Kill the caller to stop it. Once completed, doubles Icy Realm spawn frequency and wave size for one minute. Once per caller.','BTNHornOfDoom.blp');mod(o,'Eev1',0.,1)
 # Native autocast carrier applies the map's existing Shell buff, without changing Priest Shell.
 o=add('jSH2','Ainf','Shell','Autocast: protects allies from magic damage.|n|n|cffffcc00Effect Calculation|r|n33% less magic damage taken for 40 seconds. 200 mana; 5-second cooldown.','BTNAntiMagicShell.blp',5.,200,target='air,ground,friend,self,vulnerable')
 for k,val in [('Inf1',0.),('Inf2',0.),('Inf3',0.),('abuf','B05O'),('adur',40.),('ahdu',40.)]:mod(o,k,val,1)
 for raw,source in [('jBL2','ACcs'),('jFO2','A10R'),('jPA2','A0ZW')]:
  a[raw]=copy.deepcopy(old[source]);a[raw]['id']=raw;mod(a[raw],'ahky','',0);mod(a[raw],'alev',1,0)
  # Fog / Pain / Blind share Curse's native order; script dispatch uses the exact chosen spell.
  if raw in ['jFO2','jPA2']:
   o=a[raw];name='Fog' if raw=='jFO2' else 'Pain';desc=fields(o).get(('aub1',1),'')
   icon='BTNSpiritOfVengeance.blp' if raw=='jFO2' else 'BTNBloodLust.blp'
   a[raw]=channel(raw,name,desc+' 120 mana; 15-second cooldown.',icon,'drunkenhaze' if raw=='jFO2' else 'cripple',1,15.,120)
   mod(a[raw],'Ncl3',1,1);mod(a[raw],'atar','air,ground,enemy,vulnerable',1)
   for k in ['acat','atat','asat','aeat']:mod(a[raw],k,'war3mapImported\\NoAuraV2.mdx',0)
 ch('jGS2','Expanding Ice Slam','Slams the ground twice: first within 300, then at the same point within 500 after two seconds.|n|n|cffffcc00Damage Calculation|r|n2000 ice damage per slam. Each hit stuns for 3 seconds. Up to 4000 damage if both hit. 200 mana; 15-second cooldown.','BTNIceShard.blp','stomp',0,15.,200,500.)
 ch('jAR2','Winter Roar','Allied creatures within 800 gain +60% attack speed for 20 seconds. 100 mana; 40-second cooldown.','BTNHowlOfTerror.blp','battleroar',0,40.,100,800.)
 o=add('jRA2','AIsx','Winter Roar Haste','Attack speed increased by 60% for 20 seconds.','BTNHowlOfTerror.blp');mod(o,'Isx1',.6,1)
 marker('jRB2','bWR2','Winter Roar','Attack speed increased by 60%.','BTNHowlOfTerror.blp',r'Abilities\Spells\NightElf\BattleRoar\RoarTarget.mdl',20.)
 o=add('jPV2','AIev','Icy Pulverize','25% chance on a landed attack to deal 700 ice damage to enemies within 300 of the target.','BTNSeaGiantPulverize.blp');mod(o,'Eev1',0.,1)
 ch('jFB2','Ferocious Bite','Bites an enemy and impairs its recovery.|n|n|cffffcc00Damage Calculation|r|n3000 damage. For 15 seconds, health regeneration per second and healing received are reduced by 50%. 150 mana; 30-second cooldown.','BTNVampiricAura.blp','faeriefire',1,30.,150,reach=200.)
 marker('jFM2','bFB2','Ferocious Wound','Health regeneration and healing received reduced by 50% for 15 seconds.','BTNVampiricAura.blp',r'Abilities\Weapons\PoisonSting\PoisonStingTarget.mdl',15.)
 ch('jSU2','Surge','Charges directly at an enemy, then rapidly attacks for three seconds.|n|n|cffffcc00Damage Calculation|r|n500 ice damage on reaching the target; +500 ice damage per landed normal attack during the following three seconds. +200% attack speed during those attacks. 100 mana; 15-second cooldown.','BTNPolarFurbolg.blp','thunderbolt',1,15.,100)
 o=add('jSA2','AIsx','Surge Attacks','Attack speed increased by 200%; normal attacks deal an additional 500 ice damage for three seconds.','BTNPolarFurbolg.blp');mod(o,'Isx1',2.,1)
 o=add('jST2','AHtb','Winter Stun','Stuns for three seconds.','BTNFrostBolt.blp',reach=99999.)
 for k,val in [('Htb1',0.),('adur',3.),('ahdu',3.),('amat','war3mapImported\\NoAuraV2.mdx')]:mod(o,k,val,0 if k=='amat' else 1)
 adds={'n02B':['jDV2','jEV2'],'n025':['jCL2','jRG2'],'n0MQ':['jBD2','jCR2'],'n026':['jRO2'],'n02C':['jBF2','jIB2'],'n029':['jAL2'],'n02D':['jSH2','jBL2','jFO2','jPA2'],'n027':['jGS2','jAR2'],'n028':['jPV2','jFB2','jSU2']}
 removes={'n02B':['A0YR'],'n025':['A0UT','A0B6'],'n0MQ':['A1C5','A0BD','A12U'],'n026':['A0B5'],'n02C':['A040','A0BK'],'n029':['A0BG'],'n02D':['A0B6','A0BG','A0BJ'],'n027':['A0BM','A0BD','A1F4','A0B5'],'n028':['A0BM','A0BC','A0Z0']}
 for raw,(lv,hp,armor,low,high) in STATS.items():
  f=fields(u[raw]);ab=[x for x in f.get(('uabi',None),'').split(',') if len(x)==4 and x not in removes[raw]]
  ab+=adds[raw]
  for k,val in [('ulev',lv),('uhpm',hp),('udef',float(armor)),('ua1b',low-1),('ua1d',1),('ua1s',high-low+1),('uabi',','.join(dict.fromkeys(ab))),('umpm',2000),('umpi',2000),('umpr',25.),('utub',f'Normal level {lv}; {hp} HP; {armor} armor; {low}-{high} attack damage.'+'|n'+'|n'.join(fields(a[x]).get(('atp1',1),x)+': '+fields(a[x]).get(('aub1',1),'') for x in adds[raw]))]:setf(u[raw],k,val,None)
  if f.get(('udaa',None)) in removes[raw]:setf(u[raw],'udaa','',None)
 setf(u['n02D'],'udaa','jSH2',None)
 assert not set(a)&set(old),set(a)&set(old)
 return {r:u[r] for r in STATS},a,b

def refresh(s):
 fs=functions(s)
 for n,b in fs.items():
  t=b
  if n=='Forest86_Init':t=t.replace(' set D2Data=InitHashtable()',' set I2Data=InitHashtable()\n set I2Stacks=InitHashtable()\n set I2Active=CreateGroup()\n set D2Data=InitHashtable()',1)
  if n=='Forest86_Actor':t=t.replace(' return ',' return I2_Pool(raw) or ',1)
  if n=='Forest86_Entered':t=t.replace(' call D2_Track(u)',' call D2_Track(u)\n call I2_Track(u)',1)
  if n=='Forest86_Initial':t=t.replace(' call D2_Track(GetEnumUnit())',' call D2_Track(GetEnumUnit())\n call I2_Track(GetEnumUnit())',1)
  if n=='F99_Cleanup':t=t.replace(' call D2_Cleanup(u)',' call D2_Cleanup(u)\n call I2_Cleanup(u)',1)
  if n=='Forest86_Death':t=t.replace(' call D2_Death(u)',' call D2_Death(u)\n call I2_Cleanup(u)',1)
  if n=='Forest86_Spell':t=t.replace(' call D2_Spell(caster,raw)',' call D2_Spell(caster,raw)\n call I2_Spell(caster,victim,raw)',1)
  if n=='Forest86_OnAttack':t=t.replace(' call D2_OnHit(attacker,victim)',' call D2_OnHit(attacker,victim)\n call I2_OnHit(attacker,victim)',1)
  if n=='Forest86_Tick':t=t.replace(' call F99_Tick()',' call F99_Tick()\n call I2_Tick()',1)
  if n=='Forest86_AI':
   t=t.replace(" if raw=='nsty' then"," if raw=='n029' then\n set I2AlertUntil=Forest86Now+60.\n set I2AlertActive=true\n call ExecuteFunc(\"I2_UpdateSpawnTimer\")\n elseif raw=='nsty' then",1)
   t=t.replace("or raw=='qI99' then","or raw=='qI99' or I2_Pool(raw) then",1)
   t=t.replace(" if F99_Pool(raw) or raw=='qS99'", " if I2_Pool(raw) then\n call I2_AI(u,victim)\n elseif F99_Pool(raw) or raw=='qS99'",1)
  if n=='Forest86_Alert':
   t=t.replace(" and GetUnitTypeId(u)!='nsty'"," and GetUnitTypeId(u)!='nsty' and GetUnitTypeId(u)!='n029'",1)
   t=t.replace(" if GetUnitTypeId(u)=='nmpe'", " if GetUnitTypeId(u)=='n029' then\n call SaveReal(Forest86Data,id,4,Forest86Now+30.)\n elseif GetUnitTypeId(u)=='nmpe'",1)
  if n=='Forest86_Death':t=t.replace("or GetUnitTypeId(u)=='nsty')","or GetUnitTypeId(u)=='nsty' or GetUnitTypeId(u)=='n029')",1)
  if n=='B88_AlertZone':t=t.replace(' if '," if GetUnitTypeId(u)=='n029' then\n return 8\n endif\n if ",1)
  if n=='Forest86_SpawnFactor':t=t.replace(' return 1',' if zone==8 and I2AlertUntil>Forest86Now then\n return 2\n endif\n return 1',1)
  if n in ['Forest86_TauntTick','H90_BreakTaunt']:t=t.replace(" call UnitRemoveAbility(victim,'bT95')"," call UnitRemoveAbility(victim,'bT95')\n call UnitRemoveAbility(victim,'bDT2')").replace(" call UnitRemoveAbility(hero,'bT95')"," call UnitRemoveAbility(hero,'bT95')\n call UnitRemoveAbility(hero,'bDT2')")
  if n=='B88_ChargeEnd':t=t.replace(" if GetUnitTypeId(u)=='nmtw' then"," if GetUnitTypeId(u)=='n028' then\n call I2_SurgeImpact(u,victim)\n elseif GetUnitTypeId(u)=='nmtw' then",1)
  if n=='N98_Evasion':t=t.replace(" if raw=='nnrg'", " if raw=='n02B' then\n set value=40.\n elseif raw=='nnrg'",1)
  if n=='Element_GetOfUnit':t=t.replace('    if(l_isPhysical)then',"    if not l_isPhysical and GetUnitTypeId(u)=='n02C' then\n        return 2\n    endif\n    if(l_isPhysical)then",1)
  if n=='M89_Heal':t=t.replace(' if Forest86_Alive(victim) then',' if I2_Active(victim,40) then\n set amount=amount*.5\n endif\n if Forest86_Alive(victim) then',1)
  if n=='Trig_Damage_Engine_Step18_FinalModifiers':t=t.replace('    set DmgCtx_Amount[c]=l_amount','''    if not l_manaDamage then
        if l_heal and I2_Active(t,40) then
            set l_amount=l_amount*.5
        elseif not l_heal then
            if I2_Dueling(u) then
                set l_amount=l_amount*1.5
            endif
            if I2_Dueling(t) then
                set l_amount=l_amount*1.1
            endif
        endif
    endif
    set DmgCtx_Amount[c]=l_amount''',1)
  if n=='Forsaken_StatHealingReceived':t=t.replace('    return (mult-1.)*100.','    if I2_Active(hero,40) then\n        set mult=mult*.5\n    endif\n    return (mult-1.)*100.',1)
  if n=='Forsaken_ReadRegeneration':
   t=t.replace('    set ForsakenHPFlat=0.', '    if I2_Active(hero,40) then\n        set hp=hp+LoadReal(I2Data,GetHandleId(hero),41)\n    endif\n    set ForsakenHPFlat=0.',1)
   t=t.replace('    set ForsakenMPRegen=', '    if I2_Active(hero,40) then\n        set ForsakenHPRegen=ForsakenHPRegen*.5\n    endif\n    set ForsakenMPRegen=',1)
  if n=='Missile_DamageUnit':
   # ExecuteFunc keeps the missile module independent of monster helpers.
   t=t.replace('    if MissileTag[l_idx]==98', '    if MissileTag[l_idx]==202 then\n        set udg_ArgIndex=l_idx\n        set udg_ArgUnit=t\n        call ExecuteFunc("I2_WaveHit")\n        return\n    endif\n    if MissileTag[l_idx]==98',1)
  if t!=b:s=put(s,n,t)
 if 'N98_UpdateSpawnTimer' in fs:
  timer=fs['N98_UpdateSpawnTimer'].replace('N98_UpdateSpawnTimer','I2_UpdateSpawnTimer').replace(',3,6)',',3,8)').replace(',1,6)',',1,8)').replace('SpawnFactor(6)','SpawnFactor(8)')
  s=s.replace('function N98_UpdateSpawnTimer takes',timer+'\nfunction N98_UpdateSpawnTimer takes',1)
 if 'RegisterTriggers_MonsterData' in fs:
  fragment=(ROOT/'experiments/V2/Icy.j').read_text();g=re.search(r'globals\n(.*?)endglobals',fragment,re.S)
  s=s.replace('endglobals',g[1]+'endglobals',1).replace('function RegisterTriggers_MonsterData takes',fragment[g.end():].strip()+'\nfunction RegisterTriggers_MonsterData takes',1)
 return s
