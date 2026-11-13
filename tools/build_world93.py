"""World pool moves, role balance, clear status/identity and noninterrupting AI."""
import build_barrens92 as previous
from build_barrens92 import *
from build_removals91 import pool_blocks
BASE=ROOT/'release/development/QuickUI92/FFERPG-QuickUI92.w3x'
OUT=ROOT/'release/development/QuickUI93/FFERPG-QuickUI93.w3x'
TO_NAGA={'nsgn','nsgh','nsgb','nsel','nrel','n01O'}
HIGHROAD_ONLY={'ngno','ngns','ngnv','ngnw'}
CHANGED_UNITS=set();SUMMONS=set();ICON_REPORT={}
ICON_NAMES={
 'Devour Forest Creature':'Devour','Devour Barrens Creature':'DevourMagic','Devour Mountain Creature':'Cannibalize','Devour Highroad Creature':'UnholyFrenzy',
 'Devotion Aura':'Devotion','Evasive Endurance Aura':'Endurance','Rage':'BerserkForTrolls','Heal':'Heal','Cure':'HolyBolt',
 'Taunt':'Taunt','Immovable Taunt':'Command','Elemental Taunt':'MagicImmunity','Evasive Action':'Evasion','Venomous Attack':'EnvenomedSpear','Assassin Poison':'PoisonSting',
 'Alert':'CallToArms','Ensnare':'Ensnare','Blizzaga':'Blizzard','Bio':'WandSkull','Rapid Fire':'FlamingArrows','Trueshot Aura':'TrueShot',
 'Trampled':'Slow','Weakening Shout':'HowlOfTerror','War Shout':'BattleRoar','Swipe':'ClawsOfAttack','Charging Strike':'Charge','Trample':'Stampede',
 'Quill Darts':'QuillSpray','Quill Dart':'BristleBack','Steady Shot':'SearingArrows','Chain Lightning':'ChainLightning','Forked Lightning':'ForkedLightning',
 'Lightning Shield':'LightningShield','Slam':'ThunderClap','Faith':'InnerFire','Fog':'CloudOfFog','Faerie Fire':'FaerieFire','Rejuvenation':'Rejuvenation',
 'Mana Burn':'ManaBurn','Sharp Aim':'Marksmanship','Guard':'Defend','Darkness':'DeathCoil','Summon Demon Hound':'FelHound','Roar':'BattleRoar',
 'Defensive Stance':'HumanArmorUpOne','Bite':'Cannibalize','Mirror Image':'MirrorImage','Carrion Swarm':'CarrionSwarm','Armor Shout':'Roar',
 'Accumulate':'ScrollOfRegenerationGreen','Earth Slam':'WarStomp','Throw Rock':'GolemStormBolt','Bravery':'BloodLust','Brilliance Aura':'Brilliance',
 'Aeroaga':'Tornado','Firebolt':'FireBolt','Critical Strike':'CriticalStrike','Evasion':'Evasion','Shock Attack':'Purge',
 'Head Butt':'StormBolt','Entangle':'EntanglingRoots','Crippling Bite':'VampiricAura','Pack Howl':'HowlOfTerror','Field Kit':'HealingSalve',
 'Whirlwind of Steel':'Whirlwind','Aerial Assault':'Cyclone','Avatar':'Avatar','Expanding Ground Slam':'Earthquake','Rocky Defense':'HardenedSkin','Metal Fist':'SteelMelee'
}

def pools93(body):
 moved={3:[],4:[]};changes=[]
 for m,day,zone in pool_blocks(body):
  lines=[]
  for line in m[0].splitlines():
   r=re.search(r"UnitPoolAddUnitType\(l_pool,\s*'(.{4})',",line)
   if r and r[1] in TO_NAGA:
    if zone!=6:moved[day].append(line)
    else:lines.append(line)
   elif r and r[1] in HIGHROAD_ONLY and zone!=5:continue
   else:lines.append(line)
  changes.append((m.start(),m.end(),day,zone,lines))
 for start,end,day,zone,lines in reversed(changes):
  if zone==6:
   additions=list(dict.fromkeys(moved[day]));existing=set(re.findall(r"'(.{4})'",'\n'.join(lines)))
   additions=[l for l in additions if re.search(r"'(.{4})'",l)[1] not in existing]
   planned=existing|set(re.findall(r"'(.{4})'",'\n'.join(additions)))
   for raw in sorted(TO_NAGA-planned):additions.append("    call UnitPoolAddUnitType(l_pool,'"+raw+"',1.)")
   insert=next(i for i,l in enumerate(lines) if 'SaveUnitPoolHandle' in l);lines[insert:insert]=additions
  body=body[:start]+'\n'.join(lines)+body[end:]
 return body

def status(raw,buff,name,desc,icon,art,duration):
 o=ability(raw,'Acrs',name,desc,icon,0.,0,'air,ground,enemy,friend,organic,mechanical',0.,99999.)
 for key,val in {'Crs1':0.,'adur':duration,'ahdu':duration,'abuf':buff,'atat':'','acat':'','amat':''}.items():mod(o,key,val,1 if key in ['Crs1','adur','ahdu','abuf'] else 0)
 b={'base':'Bcrs','id':buff,'sets':[{'flag':0,'mods':[]}]}
 for key,val in {'fnam':name,'ftip':name,'fube':desc,'fart':'ReplaceableTextures\\CommandButtons\\'+icon,'ftat':art,'fta0':'origin'}.items():setf(b,key,val,0)
 return o,b

def objects93(v):
 global CHANGED_UNITS,SUMMONS
 units=all_objects(v,'w3u');abilities=all_objects(v,'w3a');changed={};buffs={}
 for raw,old,new in [('nfsh','fA86','hEA0'),('nggr','hEA0','fA86')]:
  setf(units[raw],'uabi',','.join(new if x==old else x for x in fields(units[raw])['uabi',None].split(',')))
  setf(units[raw],'utub',fields(units[raw]).get(('utub',None),'')+'|nAura: '+('nearby allies gain 20% increased evasion.' if raw=='nfsh' else 'nearby allies gain 10% increased armor.'))
  CHANGED_UNITS.add(raw)
 unit_text={
 'nfsh':'Normal level 5; 15-23 attack damage; 5 Unarmored armor; 300 mana.|nEvasive Endurance Aura: nearby allies gain 20% increased evasion within 600.|nDevour Forest Creature: consumes injured friendly Forest creatures, absorbs their stats, and unlocks Blizzaga. Maximum two uses. Costs 200 mana; 20-second cooldown.',
 'nggr':'Normal level 24; 4000 health; 135-149 attack damage; 50 base evasion. Naturally blocks 33% of physical attacks and spells.|nDevotion Aura: nearby allies gain 10% increased armor within 600.|nDevour Highroad Creature: consumes injured friendly Highroad creatures and absorbs their stats. Maximum two uses. Costs 350 mana; 20-second cooldown. Unlocks Rocky Defense: 100 base evasion and 60% physical/magical block for 10 seconds; costs 400 mana, 30-second cooldown.',
 'nowe':'Normal level 10; 1800 health. Naturally blocks 20% of physical attacks and spells.|nTaunt forces nearby enemies to attack for 3 seconds and reflects 20% of physical and spell damage received for 5 seconds. Radius: 450. Cooldown: 20 seconds.',
 'nsgg':'Normal level 25; 3500 health; 160 armor; 160-178 attack damage. Naturally blocks 20% of physical attacks.|nImmovable Taunt: AI casts only with an enemy within 150. Forces enemies within 450 to attack for 5 seconds, stands in place, and takes 50% less damage. Cooldown: 30 seconds.',
 'narg':'Normal level 15; 2500 health; 110-131 attack damage. Naturally blocks 15% of physical attacks.|nHead Butt: 800 spell damage and a 3-second stun. Costs 100 mana; 30-second cooldown.'}
 for raw,text in unit_text.items():setf(units[raw],'utub',text,None);CHANGED_UNITS.add(raw)
 ids=fields(units['nhar'])['uabi',None].split(',')
 if 'bAL8' not in ids:ids.append('bAL8')
 setf(units['nhar'],'uabi',','.join(ids));setf(units['nhar'],'utub',fields(units['nhar']).get(('utub',None),'')+'|nAlert: 15-second interruptible call; doubles Barrens spawn frequency and wave size for 60 seconds.');CHANGED_UNITS.add('nhar')
 for raw in ['n08E','n08B']:setf(units[raw],'uacq',800.,None,kind=2);CHANGED_UNITS.add(raw)
 for raw,o in units.items():
  f=fields(o)
  if 'A009' in f.get(('uabi',None),'').split(',') or 'A14I' in f.get(('uabi',None),'').split(','):SUMMONS.add(raw)
 for lib,text in v.modules.items():
  if lib.startswith('TSummon') or 'Animal' in lib or lib=='TLancer':
   for fn,b in functions(text).items():
    if lib=='TLancer' and 'DragonAlly' not in fn:continue
    for raw in re.findall(r"CreateNUnitsAtLoc(?:FacingLocBJ)?\([^,]+,\s*'(.{4})'",b):
     if raw in units and raw not in ['h01B','h020','h02S'] and 'Aloc' not in fields(units[raw]).get(('uabi',None),''):SUMMONS.add(raw)
    if 'CreateNUnitsAtLoc' in b and 'gg_trg_Summon_Powerup' in b:
     for raw in re.findall(r"'(.{4})'",b):
      if raw in units and raw[0].islower() and 'Aloc' not in fields(units[raw]).get(('uabi',None),''):SUMMONS.add(raw)
     for array in set(re.findall(r'CreateNUnitsAtLoc(?:FacingLocBJ)?\([^,]+,\s*(udg_\w+)\[',b)):
      for raw in re.findall(r"set\s+"+re.escape(array)+r"\[[^]]+\]\s*=\s*'(.{4})'",v.runtime):
       if raw in units:SUMMONS.add(raw)
 for raw in SUMMONS:setf(units[raw],'uacq',1000.,None,kind=2);CHANGED_UNITS.add(raw)
 descriptions={'hB30':'20% chance to block a physical attack.','hB20':'15% chance to block a physical attack.','bBW8':'20% chance to block physical attacks and spells.','bT88':'Taunts nearby enemies for 3 seconds and reflects 20% of physical and spell damage received for 5 seconds. Cooldown: 20 seconds. Radius: 450.'}
 for raw,desc in descriptions.items():mod(abilities[raw],'aub1',desc,1);changed[raw]=abilities[raw]
 for raw,desc in {'hEA0':'Nearby allies, including the bearer, gain 20% increased evasion. Radius: 600.','mPG9':'25% chance on a landed attack to poison a hero for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n50 + 7 x poisoned hero level damage per second. Non-stacking; equal/stronger applications refresh.','bP88':'30% chance on a landed attack to poison a hero for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n100 + 5 x poisoned hero level damage per second. Non-stacking; equal/stronger applications refresh.'}.items():mod(abilities[raw],'aub1',desc,1);changed[raw]=abilities[raw]
 mod(abilities['mAW9'],'areq','',0);mod(abilities['mAW9'],'arqa',0,0);changed['mAW9']=abilities['mAW9']
 for key in ['aefs','aefl']:mod(abilities['hAV0'],key,'',0)
 changed['hAV0']=abilities['hAV0']
 # Reuse valid icon paths already present in this map; exact named spells
 # share an icon, while different spell names receive distinct paths.
 available={str(fields(o).get(('aart',0),'')) for o in abilities.values()}-{''}
 cache=json.loads((ROOT/'tools/build-inputs/asset-gallery/casc-names.json').read_text())
 def cached_strings(value):
  if isinstance(value,str):yield value
  elif isinstance(value,list):
   for x in value:yield from cached_strings(x)
  elif isinstance(value,dict):
   for x in value.values():yield from cached_strings(x)
 for path in cached_strings(cache):
  if path.lower().startswith('war3.w3mod:replaceabletextures\\commandbuttons\\') and path.lower().endswith('.blp'):available.add(path.split(':',1)[1])
 available=sorted(x for x in available if x.lower().endswith(('.blp','.dds','.tga')))
 used={};assigned={}
 for raw,o in abilities.items():
  f=fields(o);name=f.get(('anam',0),'')
  if not re.match(r'^[fbmh][A-Z0-9]{3}$',raw) or 'preview' in name.lower() or name=='Hero Stats':continue
  if name not in assigned:
   desired='ReplaceableTextures\\CommandButtons\\BTN'+ICON_NAMES.get(name,'')+'.blp'
   candidates=[x for x in available if x.lower()==desired.lower()]
   candidates += [x for x in available if any(word.lower() in x.lower() for word in name.split() if len(word)>3)]
   candidates += available
   icon=next(x for x in candidates if x.lower() not in used)
   assigned[name]=icon;used[icon.lower()]=name
  mod(o,'aart',assigned[name],0);changed[raw]=o;ICON_REPORT[raw]={'name':name,'icon':assigned[name]}
 for key in ['abuf']:mod(abilities['hER0'],key,'bER3',1)
 changed['hER0']=abilities['hER0'];buffs['bER3']={'base':'BEer','id':'bER3','sets':[{'flag':0,'mods':[]}]}
 for key,val in {'fnam':'Entangled','ftip':'Entangled','fube':'Rooted in place for 3 seconds; takes 400 damage per second.','fart':'ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp','ftat':'Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl','fta0':'origin'}.items():setf(buffs['bER3'],key,val,0)
 configs=[('xT93','bT93','Taunted','Forced to attack the taunting creature for 3 seconds.','BTNTaunt.blp','Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl',3.),('xT95','bT95','Taunted','Forced to attack the taunting creature for 5 seconds.','BTNTaunt.blp','Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl',5.),('xW93','bW93','Weakened','Deals 20% less damage for 5 seconds.','BTNHowlOfTerror.blp','Abilities\\Spells\\Other\\HowlOfTerror\\HowlTarget.mdl',5.),('xV93','bV93','Exposed','Takes 10% increased damage for 10 seconds.','BTNBattleRoar.blp','Abilities\\Spells\\Other\\HowlOfTerror\\HowlTarget.mdl',10.),('xG93','bG93','Off Balance','Evasion reduced by 10% for 5 seconds.','BTNCripple.blp','Abilities\\Spells\\Human\\Slow\\SlowTarget.mdl',5.)]
 for args in configs:
  a,b=status(*args);changed[a['id']]=a;buffs[b['id']]=b
 for args in [('xB93','bB93','Bleeding','Loses 1% of maximum health per second for 3 seconds.','BTNCleavingAttack.blp','Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodFootman.mdl',3.),('xP93','bP93','Poisoned','Taking periodic poison damage for 5 seconds. The damage is based on the attacking creature and the poisoned hero level.','BTNEnvenomedSpear.blp','Abilities\\Spells\\Other\\AcidBomb\\BottleImpact.mdl',5.),('xP95','bP95','Poisoned','Taking periodic poison damage for 10 seconds. The damage is based on the attacking creature and the poisoned hero level.','BTNEnvenomedSpear.blp','Abilities\\Spells\\Other\\AcidBomb\\BottleImpact.mdl',10.)]:
  a,b=status(*args);changed[a['id']]=a;buffs[b['id']]=b
 return {r:units[r] for r in CHANGED_UNITS},changed,buffs

def refresh93(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n=='Trig_Spawn_Pools_Init_Actions':new=pools93(b)
  if n=='B88_BlockChance':
   new=b.replace(" if raw=='nggr'", " if raw=='nowe' and (physical or magical) then\n return 20\n endif\n if raw=='nggr'",1).replace("raw=='nsgg' then\n return 30","raw=='nsgg' then\n return 20").replace("raw=='narg' then\n return 20","raw=='narg' then\n return 15")
  if n=='B88_Thorns':new=b.replace('amount*.1','amount*.2')
  if n=='H90_Evasion':new=b.replace("GetUnitTypeId(u)!='nggr' and ",'')
  if n=='H90_AI':new=b.replace('IsUnitInRange(u,victim,450.)','IsUnitInRange(u,victim,150.)',1).replace("raw=='ngst' and Forest86_Ready(u,'hGS0',200) and IsUnitInRange(u,victim,500.)","raw=='ngst' and Forest86_Ready(u,'hGS0',200) and IsUnitInRange(u,victim,150.)")
  if n=='Trig_Zone_Spawn_System_SpawnZoneUnits':new=new.replace('        call SetUnitUserData(l_spawned,i)','        exitwhen l_spawned==null\n        call SetUnitUserData(l_spawned,i)',1)
  if n in ['Forest86_Alert','B88_AlertZone','Forest86_AI']:new=new.replace("raw=='nhrr'", "(raw=='nhrr' or raw=='nhar')").replace("GetUnitTypeId(u)!='nhrr'", "GetUnitTypeId(u)!='nhrr' and GetUnitTypeId(u)!='nhar'").replace("if GetUnitTypeId(u)=='nhrr' then","if GetUnitTypeId(u)=='nhrr' or GetUnitTypeId(u)=='nhar' then")
  if n=='Forest86_Taunt':new=b.replace(' call Forest86_TauntOrder(victim,caster)',' if duration>3. then\n call M89_Dummy(caster,victim,\'xT95\',"curse")\n else\n call M89_Dummy(caster,victim,\'xT93\',"curse")\n endif\n call Forest86_TauntOrder(victim,caster)',1)
  if n=='B88_Area':
   new=b.replace(' local unit u',' local effect roar=null\n local unit u',1).replace(' call B88_Buff(u,key,duration)',' call B88_Buff(u,key,duration)\n if key==40 then\n call M89_Dummy(caster,u,\'xW93\',"curse")\n elseif key==41 then\n call M89_Dummy(caster,u,\'xV93\',"curse")\n endif',1)
   new=new.replace(' call DestroyEffect(AddSpecialEffectTarget("Abilities\\\\Spells\\\\Other\\\\HowlOfTerror\\\\HowlCaster.mdl",caster,"origin"))',' set roar=AddSpecialEffectTarget("Abilities\\\\Spells\\\\Other\\\\HowlOfTerror\\\\HowlCaster.mdl",caster,"origin")\n if key==41 then\n call BlzSetSpecialEffectColor(roar,255,150,70)\n call BlzSetSpecialEffectScale(roar,1.2)\n endif\n call DestroyEffect(roar)\n set roar=null')
  if n=='B88_ChargeEnd':new=b.replace(' call B88_Buff(victim,43,5.)',' call B88_Buff(victim,43,5.)\n call M89_Dummy(u,victim,\'xG93\',"curse")',1)
  if n=='B88_Spell':new=new.replace(' call B88_Buff(victim,47,3.)',' call B88_Buff(victim,47,3.)\n call M89_Dummy(caster,victim,\'xB93\',"curse")',1)
  if n=='Forest86_OnAttack':new=new.replace(' call GroupAddUnit(Forest86Poisoned,victim)',' call GroupAddUnit(Forest86Poisoned,victim)\n if duration>5. then\n call M89_Dummy(attacker,victim,\'xP95\',"curse")\n else\n call M89_Dummy(attacker,victim,\'xP93\',"curse")\n endif',1)
  if n=='Forest86_AI':new=new.replace(' or B88_Active(u,103) then',' or B88_Active(u,103) or R93_Casting(u) then')
  if n=='Trig_Summon_Powerup_Actions':new=new.replace('    call UnitAddAbilityBJ', '    call SetUnitAcquireRange(udg_TempUnit2,1000.)\n    call UnitAddAbilityBJ',1)
  if n!='Trig_Summon_Powerup_Actions' and 'gg_trg_Summon_Powerup' in new:
   new=re.sub(r'(?m)^([ \t]*)call ((?:ConditionalTriggerExecute|TriggerExecute)\(gg_trg_Summon_Powerup\))',r'\1call SetUnitAcquireRange(udg_TempUnit2,1000.)\n\1call \2',new)
  if n=='Trig_Boss_Penance_Summon_UnpauseArm':new=new.replace('endfunction','    call SetUnitAcquireRange(GetEnumUnit(),800.)\nendfunction')
  if n=='M89_Spell':new=new.replace(" call M89_Projectile(caster,victim,'mPF9',800.,1,false)", ' set udg_TempUnit=caster\n set udg_TempUnit2=victim\n call ExecuteFunc("R93_Firebolt")')
  if n=='Forest86_Spell':new=new.replace(" if raw=='fD86' then", " call R93_Visual(caster,victim,raw)\n if raw=='fD86' then",1)
  if n=='Forest86_TauntTick':new=new.replace(' call GroupRemoveUnit(Forest86Taunted,victim)'," call UnitRemoveAbility(victim,'bT93')\n call UnitRemoveAbility(victim,'bT95')\n call GroupRemoveUnit(Forest86Taunted,victim)",1)
  if n=='H90_BreakTaunt':new=new.replace(' call GroupRemoveUnit'," call UnitRemoveAbility(hero,'bT93')\n call UnitRemoveAbility(hero,'bT95')\n call GroupRemoveUnit",1)
  if new!=b:s=put(s,n,new)
 if 'Forest86_AI' in fs:
  helper='''function R93_Casting takes unit u returns boolean
 local integer order=GetUnitCurrentOrder(u)
 local integer id=GetHandleId(u)
 local boolean casting=order>0 and (order==OrderId("firebolt") or order==OrderId("thunderbolt") or order==OrderId("chainlightning") or order==OrderId("forkedlightning") or order==OrderId("flamestrike") or order==OrderId("carrionswarm") or order==OrderId("holybolt") or order==OrderId("healingwave") or order==OrderId("devour") or order==OrderId("entanglingroots") or order==OrderId("shockwave"))
 if not casting then
 if HaveSavedInteger(Forest86Data,id,160) then
 call RemoveSavedInteger(Forest86Data,id,160)
 call RemoveSavedReal(Forest86Data,id,161)
 endif
 return false
 endif
 if LoadInteger(Forest86Data,id,160)!=order then
 call SaveInteger(Forest86Data,id,160,order)
 call SaveReal(Forest86Data,id,161,Forest86Now)
 return true
 endif
 // Do not leave a creature stuck forever on a stale or obstructed order.
 return Forest86Now-LoadReal(Forest86Data,id,161)<3.
endfunction
'''
  s=s.replace('function Forest86_AI takes',helper+'\nfunction Forest86_AI takes',1)
 if 'Forest86_Spell' in fs:
  effects={
   'bB88':('Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl',True,.7,(255,100,80)),
   'mRO9':('Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl',False,1.,(255,200,80)),
   'mSH9':('Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl',False,1.4,(80,160,255)),
   'mAC9':('Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl',False,.7,(255,255,180)),
   'hHW0':('Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl',False,1.3,(140,255,200)),
   'fE86':('Abilities\\Spells\\Human\\Invisibility\\InvisibilityTarget.mdl',False,.8,(180,240,255)),
   'hFK0':('Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl',True,1.,(255,255,255)),
   'hRD0':('Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl',False,1.3,(255,220,140)),
   'hBI0':('Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl',True,.5,(180,90,90)),
   'hMF0':('Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl',True,.8,(210,210,230))}
  code=['function R93_Visual takes unit caster,unit victim,integer raw returns nothing',' local effect visual=null',' local unit anchor=caster']
  for index,(raw,(path,target,scale,color)) in enumerate(effects.items()):
   code.append((' if' if index==0 else ' elseif')+" raw=='"+raw+"' then")
   if target:code.append(' set anchor=victim')
   code+=[' set visual=AddSpecialEffectTarget("'+path.replace('\\','\\\\')+'",anchor,"origin")',f' call BlzSetSpecialEffectScale(visual,{scale})',f' call BlzSetSpecialEffectColor(visual,{color[0]},{color[1]},{color[2]})']
  code+=[' endif',' if visual!=null then',' call DestroyEffect(visual)',' endif',' set visual=null',' set anchor=null','endfunction']
  s=s.replace('function Forest86_Spell takes','\n'.join(code)+'\nfunction Forest86_Spell takes',1)
 if 'Missile_CreateWithEffects' in fs:
  fire='''function R93_Firebolt takes nothing returns nothing
 local unit caster=udg_TempUnit
 local unit victim=udg_TempUnit2
 local integer d=Missile_CreateWithEffects(caster,"Abilities\\\\Weapons\\\\FireBallMissile\\\\FireBallMissile.mdl","",GetUnitFacing(caster),0.)
 if d<=0 then
 return
 endif
 set udg_MissileTarget[d]=victim
 set udg_MissileHoming[d]=true
 set udg_MissileSpeed[d]=27.
 set udg_MissileRange[d]=2000.
 set udg_MissileImpactDamage[d]=800.
 set udg_MissileIsMagic[d]=true
 set udg_MissileElement[d]=1
 set udg_MissileHitEffect[d]="Abilities\\\\Spells\\\\Other\\\\Incinerate\\\\FireLordDeathExplode.mdl"
 set MissileTag[d]=93
 call BlzSetSpecialEffectScale(udg_MissileModelEffect[d],1.5)
 set caster=null
 set victim=null
endfunction
'''
  s=s.replace('function Missile_DamageUnit takes',fire+'\nfunction Missile_DamageUnit takes',1)
 if 'Missile_Impact' in fs:
  b=functions(s)['Missile_Impact'].replace('    local damagetype l_dmgType','    local unit stunDummy=null\n    local damagetype l_dmgType',1)
  b=b.replace('    if udg_MissileIsPure[l_idx]then','''    if MissileTag[l_idx]==93 and (udg_MissileTarget[l_idx]==null or GetWidgetLife(udg_MissileTarget[l_idx])<=.405 or (GetUnitX(udg_MissileTarget[l_idx])-udg_MissileX[l_idx])*(GetUnitX(udg_MissileTarget[l_idx])-udg_MissileX[l_idx])+(GetUnitY(udg_MissileTarget[l_idx])-udg_MissileY[l_idx])*(GetUnitY(udg_MissileTarget[l_idx])-udg_MissileY[l_idx])>8100.) then
        set udg_MissileImpactDamage[l_idx]=0.
    endif
    if udg_MissileIsPure[l_idx]then''',1)
  b=b.replace('    set udg_MissileActiveCount=', '''    if MissileTag[l_idx]==93 and udg_MissileImpactDamage[l_idx]>0. then
        set stunDummy=CreateUnit(GetOwningPlayer(udg_MissileCaster[l_idx]),'h01B',udg_MissileX[l_idx],udg_MissileY[l_idx],0.)
        call SetUnitVertexColor(stunDummy,255,255,255,0)
        call UnitAddAbility(stunDummy,'mST9')
        call IssueTargetOrder(stunDummy,"thunderbolt",udg_MissileTarget[l_idx])
        call UnitApplyTimedLife(stunDummy,'BTLF',2.)
        set stunDummy=null
    endif
    set udg_MissileActiveCount=''',1)
  s=put(s,'Missile_Impact',b)
 if 'function main takes' in s:s=order(s)[0]
 return s

def build():
 v=View(BASE);u,a,b=objects93(v)
 previous.BASE=BASE;previous.OUT=OUT;previous.LABEL='FFERPG QuickUI93 (World Creatures)'
 previous.objects92=lambda _: (u,a)
 previous.refresh92=refresh93
 # Reuse the exact archive-preserving builder; then append custom status
 # buffs through the same object writer before packing its candidate.
 previous.build()
 # Object buffs are separate from abilities and must exist in both runtime
 # and editor archive data. Repack only the new buff table.
 archive=MPQ(str(OUT));t=read_objects(archive.read('war3map.w3h'),'w3h');t['custom'].extend(b.values());tmp=OUT.with_suffix('.buffs.w3x')
 write_files(str(OUT),str(tmp),{'war3map.w3h':write_objects(t,t['version'],'w3h')});compact(str(tmp),str(OUT.with_suffix('.final.w3x')))
 data=OUT.with_suffix('.final.w3x').read_bytes();_,flags,players=read_header(str(BASE));OUT.write_bytes(build_header(previous.LABEL,flags,players)+data[data.index(b'MPQ\x1a'):])
 report=json.loads(OUT.with_suffix('.json').read_text());report['sha256']=hashlib.sha256(OUT.read_bytes()).hexdigest();OUT.with_suffix('.json').write_text(json.dumps(report,indent=2))
 (OUT.parent/'Icons.json').write_text(json.dumps(ICON_REPORT,indent=2));(OUT.parent/'Changes.json').write_text(json.dumps(dict(to_naga=sorted(TO_NAGA),highroad_only=sorted(HIGHROAD_ONLY),summons=sorted(SUMMONS),changed_units=sorted(CHANGED_UNITS),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest()),indent=2))
if __name__=='__main__':build()
