"""QuickUI90: Galbados Highroad roles, smaller damage buffs/close Mirror Image, 20s Devours."""
from build_mountains89 import *
BASE=ROOT/'release/development/QuickUI89/FFERPG-QuickUI89.w3x'
OUT=ROOT/'release/development/QuickUI90/FFERPG-QuickUI90.w3x'
STATS={
 'nsgg':(25,3500,160,160,178,None),'narg':(15,2500,None,110,131,None),'n01P':(18,2000,3,80,96,None),
 'nwld':(22,3100,49,172,195,None),'nwlg':(20,1900,33,149,156,None),'nspb':(23,2900,48,170,192,None),
 'ngns':(19,2300,28,130,136,None),'ngna':(16,2100,42,121,143,None),'ngno':(19,2500,52,None,None,None),
 'ngnv':(24,4100,54,161,185,None),'ngnw':(23,2750,45,210,219,None),'ngrk':(17,2000,58,135,148,None),
 'ngst':(23,3800,None,183,197,None),'nggr':(24,4000,None,135,149,1000),'nwrg':(21,3200,None,165,173,None)}
RAW=list(STATS)+['n0MO','nogl','nhdc','nfsh','nqbh','nwzd','n02B']
def objects90(v):
 units=all_objects(v,'w3u');old=all_objects(v,'w3a');new={};buffs={}
 def ch(raw,name,desc,order,target=0,cd=20.,mana=0,area=0.,reach=600.):
  new[raw]=channel(raw,name,desc,'BTNBattleRoar.blp',order,target,cd,mana,area,reach);return new[raw]
 def native(raw,base,name,desc,cd=15.,mana=0,**data):
  new[raw]=ability(raw,base,name,desc,'BTNBattleRoar.blp',cd,mana)
  for k,val in data.items():mod(new[raw],k,val,1)
  return new[raw]
 def clone(raw,base,name=None,desc=None):
  o=copy.deepcopy(old[base]);o['id']=raw
  if name:mod(o,'anam',name);mod(o,'atp1',name,1)
  if desc:mod(o,'aub1',desc,1)
  new[raw]=o;return o
 ch('hTT0','Immovable Taunt','Forces enemies within 450 to attack for 5 seconds. Stands in place and takes 50% less damage for those 5 seconds. Cooldown: 30 seconds.','roar',cd=30.,area=450.)
 native('hHB0','AHtb','Head Butt','Stuns for 3 seconds.|n|n|cffffcc00Damage Calculation|r|n800 spell damage. Costs 100 mana. Cooldown: 30 seconds.',30.,100,Htb1=800.,adur=3.,ahdu=3.,aran=180.)
 native('hER0','AEer','Entangle','Roots an enemy for 3 seconds.|n|n|cffffcc00Damage Calculation|r|n400 spell damage per second. Costs 200 mana. Cooldown: 12 seconds.',12.,200,Eer1=400.,adur=3.,ahdu=3.)
 ch('hBI0','Crippling Bite','Bites the enemy and reduces evasion by 30 and movement speed by 20% for 5 seconds.|n|n|cffffcc00Damage Calculation|r|n1000 physical damage. Costs 150 mana. Cooldown: 15 seconds.','cripple',1,15.,150,reach=180.)
 native('hSL0','Aslo','Crippling Bite Slow','Movement speed reduced by 20% for 5 seconds.',0.,0,Slo1=.2,Slo2=0.,adur=5.,ahdu=5.,aran=99999.)
 ch('hHW0','Pack Howl','Allies within 800 gain 200 attack damage and 20% attack speed for 20 seconds. Cooldown: 30 seconds.','roar',cd=30.,area=800.)
 native('hD20','AIat','Pack Howl Damage','Attack damage increased by 200.',0.,0,Iatt=200)
 native('hAS0','AIsx','Pack Howl Haste','Attack speed increased by 20%.',0.,0,Isx1=.2)
 native('hA25','AIsx','Avatar Haste','Attack speed increased by 25%.',0.,0,Isx1=.25)
 clone('hBO0','fI86','Bio','Poisons the enemy and slows movement by 30% for 10 seconds. Uses Stinger\'s reduced Bio damage at a lower mana cost.|n|n|cffffcc00Damage Calculation|r|nBase damage per tick: 0.8 x floor(200 / 3) x Inner Mana spell power. Costs 100 mana. Cooldown: 20 seconds.')
 mod(new['hBO0'],'amcs',100,1);mod(new['hBO0'],'ansf','[Highroad: Stinger damage]')
 clone('hAL0','mAL9','Alert','On attacking a hero or taking hero damage in Galbados Highroad, calls reinforcements for 15 seconds. Final 5-4-3-2-1 countdown. Kill caller to cancel. Doubles Highroad spawn frequency, wave amount and population cap for 60 seconds. Once per caller.')
 ch('hFK0','Field Kit','Treats an injured friendly target within 800.|n|n|cffffcc00Healing Calculation|r|n1000 immediate healing, plus 100 per second for 5 seconds. Costs 50 mana. Cooldown: 20 seconds.','healingwave',1,20.,50,reach=800.)
 mod(new['hFK0'],'atar','air,ground,friend,self,organic,vulnerable',1)
 ch('hWW0','Whirlwind of Steel','Spins in a whirlwind of steel for 5 seconds.|n|n|cffffcc00Damage Calculation|r|n500 physical damage per second within 250. Costs 150 mana. Cooldown: 20 seconds.','whirlwind',cd=20.,mana=150,area=250.)
 ch('hAA0','Aerial Assault','Bounces between enemies using Liquid Steel\'s movement.|n|n|cffffcc00Damage Calculation|r|n150 wind-elemental physical damage per bounce. 5 bounces. Costs 100 mana. Cooldown: 15 seconds.','chainlightning',1,15.,100)
 native('hAV0','AHav','Avatar','Grows in size, becomes spell immune, and gains 100 attack damage, 25% attack speed and 1000 maximum health for 30 seconds. Costs 150 mana. Cooldown: 45 seconds.',45.,150,Hav1=0.,Hav2=1000.,Hav3=100.,Hav4=1.,adur=30.,ahdu=30.)
 ch('hGS0','Expanding Ground Slam','Slams a 300-radius area, then the same center explodes in a 500-radius area after 2 seconds.|n|n|cffffcc00Damage Calculation|r|n800 earth spell damage per slam. Costs 200 mana. Cooldown: 15 seconds.','stomp',cd=15.,mana=200,area=500.)
 native('hEA0','AOae','Evasive Endurance Aura','Allies within 600 gain 20% increased evasion. Uses Ancient Janggo of Endurance\'s aura visual. The caster retains its specified base evasion.',0.,0,Oae1=0.,Oae2=0.,aare=600.,abuf='bE90',atar='air,ground,friend,self')
 b={'base':'BOae','id':'bE90','sets':[{'flag':0,'mods':[]}]}
 for k,val in {'fnam':'Evasive Endurance Aura','ftip':'Evasive Endurance Aura','fube':'Evasion increased by 20%.'}.items():setf(b,k,val,None)
 buffs['bE90']=b
 ch('hDV0','Devour Highroad Creature','Consumes an injured friendly Highroad creature, absorbing both attack damages, maximum health/mana and armor, and healing its remaining HP. No heroes or special quest creatures. Maximum two uses. Unlocks Rocky Defense. Costs 350 mana. Cooldown: 20 seconds.','devour',1,20.,350,reach=350.)
 ch('hRD0','Rocky Defense','Unlocked by Devour Highroad Creature. Sets base evasion to 100 and physical/magical block chance to 60% for 10 seconds. Costs 400 mana. Cooldown: 30 seconds.','howlofterror',cd=30.,mana=400)
 ch('hMF0','Metal Fist','Strikes the enemy and reduces its attack damage by 25% for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n1200 physical damage. Costs 100 mana. Cooldown: 30 seconds.','cripple',1,30.,100,reach=180.)
 native('hPB0','ACcr','Metal Fist Weakness','Attack damage reduced by 25% for 10 seconds.',0.,0,Cri1=0.,Cri2=0.,Cri3=.25,adur=10.,ahdu=10.,aran=99999.)
 for raw,name,desc in [('hB30','Guard','30% chance to block physical attacks.'),('hB20','Guard','20% chance to block physical attacks.'),('hB15','Guard','15% chance to block physical or magical attacks.'),('hB33','Rocky Guard','Base evasion: 50. 33% chance to block physical or magical attacks.')]:native(raw,'AIev',name,desc,0.,0,Eev1=0.)
 # Shared bonus is used only by Ogre Berserker's Roar and nogl's Accumulate.
 for raw in ['mD39','mRO9','mAC9','mMI9','bP88','mPG9','A0B4']:
  new[raw]=copy.deepcopy(old[raw])
  if raw in ['mD39','mRO9','mAC9']:
   for st in new[raw]['sets']:
    for m in st['mods']:
     if isinstance(m['value'],str):m['value']=m['value'].replace('300 attack damage','150 attack damage').replace('damage by 300','damage by 150')
 mod(new['mD39'],'Iatt',150,1)
 mod(new['mMI9'],'aran',96.,1);mod(new['mMI9'],'aare',128.,1)
 mod(new['mMI9'],'aub1','Creates one nearby illusion, keeping the real unit and image close together. Image deals 50% damage and takes 50% increased damage. Lasts 30 seconds. Costs 100 mana. Cooldown: 30 seconds.',1)
 mod(new['bP88'],'aub1','30% chance on a landed attack against a hero to poison for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n100 + 5 x poisoned hero level damage per second. Non-stacking; equal/stronger applications refresh.',1)
 mod(new['mPG9'],'aub1','25% chance on a landed attack against a hero to poison for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n50 + 7 x poisoned hero level damage per second. Non-stacking; equal/stronger applications refresh.',1)
 for st in new['A0B4']['sets']:
  for m in st['mods']:
   if m['field']=='aub1':m['value']='Dispels Stun, Freeze, Sleep, Daze and monster Taunt from your hero instantly.'
 # Every Devour, including the original Queen's spell, now has a 20s cooldown.
 for raw,o in old.items():
  if 'devour' not in str(fields(o).get(('anam',0),'')).lower():continue
  new[raw]=copy.deepcopy(o)
  ranks={m.get('level') for st in o['sets'] for m in st['mods'] if m['field']=='acdn'} or {1}
  for rank in ranks:mod(new[raw],'acdn',20.,rank)
  for st in new[raw]['sets']:
   for m in st['mods']:
    if isinstance(m['value'],str):m['value']=m['value'].replace('Cooldown: 15 seconds','Cooldown: 20 seconds').replace('Cooldown: 30 seconds','Cooldown: 20 seconds')
 stock={r['unitAbilID']:r for r in slk((ROOT/'tools/build-inputs/unitabilities.slk').read_bytes())}
 def ua(raw,add=(),remove=()):
  o=units[raw];ab=[x for x in fields(o).get(('uabi',None),stock.get(o['base'],{}).get('abilList','')).split(',') if len(x)==4 and x not in remove]
  for x in add:
   if x not in ab:ab.append(x)
  setf(o,'uabi',','.join(ab),None)
 for raw,(lv,hp,armor,lo,hi,mana) in STATS.items():
  for k,val in [('ulev',lv),('uhpm',hp),('udef',float(armor) if armor is not None else None),('umpm',mana),('umpi',mana)]:
   if val is not None:setf(units[raw],k,val,None)
  if lo is not None:
   for k,val in [('ua1b',lo-1),('ua1d',1),('ua1s',hi-lo+1)]:setf(units[raw],k,val,None)
 adds={'nsgg':['hTT0','hB30'],'narg':['hHB0','hB20'],'n01P':['hER0'],'nwld':['hBI0'],'nwlg':['hHW0'],'nspb':['hBO0'],'ngna':['hAL0'],'ngno':['hFK0'],'ngnv':['hWW0'],'ngnw':['hAA0'],'ngrk':['hAV0'],'ngst':['hGS0'],'nggr':['hEA0','hDV0','hB33'],'nwrg':['hB15','hMF0']}
 for raw,abilities in adds.items():ua(raw,abilities,['A07A'] if raw in ['nsgg','narg','nwrg'] else [])
 for raw in ['narg','nwld','ngst']:
  if fields(units[raw]).get(('umpm',None),0)<300:setf(units[raw],'umpm',500,None);setf(units[raw],'umpi',500,None)
 # Readied native data plus descriptions/calculations on every changed unit.
 combined=old|new
 for raw in RAW:
  f=fields(units[raw]);parts=['Normal base level '+str(STATS[raw][0])+'.'] if raw in STATS else []
  for a in f.get(('uabi',None),'').split(','):
   if a in new:parts.append(fields(new[a]).get(('aub1',1),''))
  if parts:setf(units[raw],'utub','|n|n'.join(parts),None)
 assert not (set(new)-{'mD39','mRO9','mAC9','mMI9','bP88','mPG9','A0B4','A0YR','fD86','bD88','mDV9'})&set(old)
 assert 'bE90' not in all_objects(v,'w3h')
 return units,new,buffs

def refresh90(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n=='Forest86_Actor':new=new.replace('return M89_Pool(raw)','return H90_Pool(raw) or M89_Pool(raw)',1)
  if n=='Forest86_Init':new=new.replace(' set M89Buffs=CreateGroup()',' set H90Buffs=CreateGroup()\n set M89Buffs=CreateGroup()')
  if n=='Forest86_Death':new=new.replace('and not IsUnitInGroup(u,M89Buffs) then','and not IsUnitInGroup(u,M89Buffs) and not IsUnitInGroup(u,H90Buffs) then').replace("or GetUnitTypeId(u)=='nkob')","or GetUnitTypeId(u)=='nkob' or GetUnitTypeId(u)=='ngna')");new=new.replace(' call GroupRemoveUnit(M89Buffs,u)',' call H90_Cleanup(u)\n call GroupRemoveUnit(M89Buffs,u)',1)
  if n=='Forest86_SpawnFactor':new=new.replace(' return 1',' if zone==5 and H90AlertUntil>Forest86Now then\n return 2\n endif\n return 1')
  if n=='B88_AlertZone':new=new.replace(' if GetUnitTypeId'," if GetUnitTypeId(u)=='ngna' then\n return 5\n endif\n if GetUnitTypeId",1)
  if n=='Forest86_Alert':new=new.replace("and GetUnitTypeId(u)!='nkob')","and GetUnitTypeId(u)!='nkob' and GetUnitTypeId(u)!='ngna')")
  if n=='Forest86_AI':
   new=new.replace(" if raw=='nbrg' or raw=='nkob' then"," if raw=='ngna' then\n set H90AlertUntil=Forest86Now+60.\n set H90AlertActive=true\n call ExecuteFunc(\"H90_UpdateSpawnTimer\")\n elseif raw=='nbrg' or raw=='nkob' then",1)
   new=new.replace(' or LoadBoolean(Forest86Data,id,65) then',' or LoadBoolean(Forest86Data,id,65) or B88_Active(u,103) then')
   new=new.replace('or M89_Pool(raw) then','or M89_Pool(raw) or H90_Pool(raw) then').replace(' if M89_Pool(raw) then',' if H90_Pool(raw) then\n call H90_AI(u,victim)\n elseif M89_Pool(raw) then',1)
  if n=='Forest86_Tick':new=new.replace(' call ForGroup(M89Buffs', ' call ForGroup(H90Buffs,function H90_TickUnit)\n if H90AlertActive and Forest86Now>=H90AlertUntil then\n set H90AlertActive=false\n call ExecuteFunc("H90_UpdateSpawnTimer")\n endif\n call ForGroup(M89Buffs',1)
  if n=='Forest86_Taunt':new=new.replace("GetUnitTypeId(caster)=='ngnv'", "(GetUnitTypeId(caster)=='ngnv' or GetUnitTypeId(caster)=='nsgg')")
  if n=='Forest86_Spell':new=new.replace(' call M89_Spell(caster,victim,raw)',' call M89_Spell(caster,victim,raw)\n call H90_Spell(caster,victim,raw)')
  if n=='Trig_Gaya_BreakStun_Actions':new=new.replace('    set u=null','    call H90_BreakTaunt(u)\n    set u=null',1)
  if n=='Forest86_OnAttack':
   for raw,chance,coefficient,base in [('nspb',30,5,100),('ngns',25,7,50)]:
    pattern=r"(elseif raw=='"+raw+r"' then\n)(.*?)(?= elseif| endif)";m=re.search(pattern,new,re.S);assert m,raw
    block=re.sub(r'set chance=\d+','set chance='+str(chance),m[2]);block=re.sub(r'set coefficient=\d+','set coefficient='+str(coefficient),block);block=re.sub(r'set base=\d+','set base='+str(base),block)
    new=new[:m.start(2)]+block+new[m.end(2):]
  if n=='B88_BlockChance':new=new.replace(' if physical then', ''' if raw=='nggr' and (physical or magical) then
 if B88_Active(u,106) then
 return 60
 endif
 return 33
 elseif raw=='nwrg' and (physical or magical) then
 return 15
 elseif physical and raw=='nsgg' then
 return 30
 elseif physical and raw=='narg' then
 return 20
 endif
 if physical then''',1)
  if n=='Trig_Damage_Engine_Step18_FinalModifiers':new=new.replace('    if l_amount>0. and not l_heal then','    if l_amount>0. and not l_heal then\n        if B88_Active(t,100) then\n            set l_amount=l_amount*.5\n        endif',1)
  if n in ['Trig_Damage_Engine_GetEvasion','Forsaken_Stat_GetEvasion','Stats_Stat_GetEvasion']:
   anchor="    if(Forsaken_ElementAbilityLevel(u,'A1DI')" if n=='Trig_Damage_Engine_GetEvasion' else "    if(Forsaken_StatAbilityLevel(u,'A1DI')"
   assert anchor in new
   new=new.replace(anchor,"    if GetUnitTypeId(u)=='nggr' then\n        if B88_Active(u,106) then\n            set l_eva=100.\n        else\n            set l_eva=50.\n        endif\n    endif\n"+anchor,1)
   new=new.replace('    set l_eva=l_eva+Forest86_Evasion(u)','    set l_eva=l_eva+Forest86_Evasion(u)\n    set l_eva=H90_Evasion(u,l_eva)',1)
   if n!='Trig_Damage_Engine_GetEvasion':
    reduction=re.search(r'    if DG_Data!=null.*?\n    endif\n',new,re.S)
    if reduction:
     block=reduction[0];new=new.replace(block,'',1);pos=new.rfind('    return ');new=new[:pos]+block+new[pos:]
  if n in ['Trig_Bio_Cast_IsBio','Trig_Bio_Cast_Conditions']:new=new.replace("GetSpellAbilityId()=='fI86'", "(GetSpellAbilityId()=='fI86' or GetSpellAbilityId()=='hBO0')",1)
  if n=='Trig_Bio_Cast_Actions':
   new=new.replace("GetSpellAbilityId()=='fI86'", "(GetSpellAbilityId()=='fI86' or GetSpellAbilityId()=='hBO0')")
   new=new.replace('BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))','H90_BioMana(GetTriggerUnit(),GetSpellAbilityId())')
  if n=='Trig_Spell_LiquidSteel_Alloc':new=new.replace('    set udg_LiquidSteelDelay[l_idx]=0','    set H90LiquidWind[l_idx]=false\n    set udg_LiquidSteelDelay[l_idx]=0')
  if n=='Trig_Spell_LiquidSteel_Conditions':new=new.replace('return(',"return(GetSpellAbilityId()=='hAA0' or ",1)
  if n=='Trig_Spell_LiquidSteel_Actions':
   new=new.replace("    if(GetSpellAbilityId()=='A01Q')then", "    if GetSpellAbilityId()=='hAA0' then\n        set H90LiquidWind[d]=true\n        set udg_LiquidSteelBounces[d]=5\n    elseif(GetSpellAbilityId()=='A01Q')then",1)
   pos=new.index('    set udg_LiquidSteelX[d]');new=new[:pos]+"    if GetSpellAbilityId()=='hAA0' then\n        set udg_LiquidSteelDmg[d]=150.\n    endif\n"+new[pos:]
   last='    set udg_LiquidSteelEffect[d]=AddSpecialEffectTarget';pos=new.index(last);new=new[:pos]+'''    if H90LiquidWind[d] then
        set udg_LiquidSteelEffect[d]=AddSpecialEffectTarget("Abilities\\\\Spells\\\\Other\\\\Tornado\\\\TornadoElementalSmall.mdl",gg_unit_h020_0272[d],"chest")
    else
'''+new[pos:];new=new.replace('endfunction','    endif\nendfunction',1)
  if n=='Trig_Spell_LiquidSteel_Loop':new=new.replace('            set udg_DamageElement=4','            if H90LiquidWind[d] then\n                set udg_DamageElement=6\n            else\n                set udg_DamageElement=4\n            endif',1)
  if n=='Trig_Zone_Spawn_System_SpawnZoneUnits':new=new.replace('M89_Pool(GetUnitTypeId(l_spawned))','H90_Pool(GetUnitTypeId(l_spawned)) or M89_Pool(GetUnitTypeId(l_spawned))')
  if new!=b:s=put(s,n,new)
 if 'Trig_Bio_Cast_Actions' in fs:
  helper='''function H90_BioMana takes unit caster,integer raw returns integer
 if raw=='hBO0' then
 return 200
 endif
 return BlzGetAbilityManaCost(raw,Abil_GetLevel(caster,raw))
endfunction
''';s=s.replace('function Trig_Bio_Cast_Actions takes',helper+'\nfunction Trig_Bio_Cast_Actions takes',1)
 if 'Trig_Spell_LiquidSteel_Alloc' in fs:
  if 'RegisterTriggers_MonsterData' in fs:s=s.replace('endglobals',' boolean array H90LiquidWind\nendglobals',1)
  else:s=s.replace('endglobals','    boolean array H90LiquidWind\nendglobals',1)
 if 'RegisterTriggers_MonsterData' in fs:
  fragment=(ROOT/'experiments/GuardiaForest/Highroad90.j').read_text();glob=re.search(r'globals\n(.*?)endglobals',fragment,re.S);s=s.replace('endglobals',glob[1]+'endglobals',1);s=s.replace('function RegisterTriggers_MonsterData takes',fragment[glob.end():].strip()+'\nfunction RegisterTriggers_MonsterData takes',1);s=sort90(s)
 if 'Trig_Zone_Spawn_System_ZoneRespawnTick' in fs:
  clock=fs['B88_UpdateSpawnTimer'].replace('B88_UpdateSpawnTimer','H90_UpdateSpawnTimer').replace(',3,2)',',3,5)').replace(',1,2)',',1,5)').replace('SpawnFactor(2)','SpawnFactor(5)');s=s.replace('function B88_UpdateSpawnTimer takes',clock+'\nfunction B88_UpdateSpawnTimer takes',1)
 return s

def sort90(s):
 helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_','M89_','H90_')) and not n.endswith(('UpdateSpawnTimer','BioMana'))}
 names=set(helpers);deps={n:(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',re.sub(r'"(?:\\.|[^"\\])*"','""',b)))|set(re.findall(r'\bfunction\s+(\w+)',b)))&names-{n} for n,b in helpers.items()};result=[];remaining=list(helpers)
 while remaining:
  ready=[n for n in remaining if not deps[n]-set(result)];assert ready,remaining
  for n in ready:result.append(n);remaining.remove(n)
 start=min(s.index(b) for b in helpers.values());prefix=s[:start];tail=s[start:]
 for b in helpers.values():tail=tail.replace(b,'',1)
 return prefix+'\n\n'.join(helpers[n] for n in result)+'\n'+tail

def build():
 assert not OUT.exists()
 v=View(BASE);units,abil,buffs=objects90(v);files={}
 for ext,replacements in [('w3u',{r:units[r] for r in RAW}),('w3a',abil),('w3h',buffs)]:
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
 modules={lib:refresh90(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};runtime=refresh90(v.runtime)
 for lib in changed:
  oldfs=functions(v.modules[lib])
  for n,b in functions(modules[lib]).items():
   if n in oldfs and tokens(b)!=tokens(oldfs[n]):runtime=put(runtime,n,b)
 runtime,moved=order(runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:
   source=modules[m[1]]
   if m[1]=='TGayaSupport':source=source.replace('requires TPlayerHero, TText','requires TPlayerHero, TText, TMonsterData',1)
   v.wct['entries'][i]=raw_of(source.replace('\n','\r\n'))
 w=wts_read(v.archive.read('war3map.wts'));label='FFERPG QuickUI90 (Galbados Highroad)';w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-3500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 a=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert a.read(name)==files.get(name,v.archive.read(name)),name
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),units=RAW,moved=moved,notes='Full Dragoon; Normal stats; shared heartbeat; native acceptance pending.'),indent=2));print(OUT)
if __name__=='__main__':build()
