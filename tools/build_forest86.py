"""Guardia Forest role prototype on the Dragoon test, Normal authored stats."""
from pathlib import Path
import copy,re,json,hashlib,subprocess
from editor_pair import View
from order_libraries import order
from jtok import functions,tokens
from performance_runtime import put
from objdata import read_objects,write_objects
from priest_master import fields,setf
from downgrade import wts_read,wts_write
from wct import text_of,raw_of,write_wct
from mpq import MPQ,write_files,compact
from add_header import read_header,build_header
from asset_gallery_catalogue import slk
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI85/FFERPG-QuickUI85.w3x'
OUT=ROOT/'release/development/QuickUI86/FFERPG-QuickUI86.w3x'
RAW=['nfsh','nwlt','nftb','nfsp','ndtp','ndtr','nspg','ngnb','nftt','nbrg','nbld','n0BS']

def all_objects(v,ext):
 result={}
 for name in ['war3map.'+ext,'war3mapSkin.'+ext]:
  data=v.archive.read(name)
  if not data:continue
  t=read_objects(data,ext)
  for o in t['original']+t['custom']:
   raw=o['id'] or o['base']
   if raw not in result:result[raw]=copy.deepcopy(o)
   else:
    for st in o['sets']:
     for m in st['mods']:setf(result[raw],m['field'],m['value'],m['level'],m['type'],m['data'])
 return result
META={r['ID']:r for r in slk((ROOT/'tools/build-inputs/abilitymetadata-review.slk').read_bytes())}
def ability(raw,base,name,desc,icon,cd=0.,mana=0,target='air,ground,enemy',area=0.,cast_range=600.):
 o={'base':base,'id':raw,'sets':[{'flag':0,'mods':[]}]}
 for k,val in {'anam':name,'aher':0,'aite':0,'alev':1,'aart':'ReplaceableTextures\\CommandButtons\\'+icon,'atp1':name,'aub1':desc,'abpx':0,'abpy':0,'arac':'creeps','acdn':float(cd),'amcs':mana,'atar':target,'aare':float(area),'aran':float(cast_range),'acas':0.}.items():
  mod(o,k,val)
 return o

def mod(o,k,value,rank=None):
 if rank is None:rank=1 if META.get(k,{}).get('repeat','0') not in ['0',''] or k in ['atp1','aub1','acdn','amcs','atar','aare','aran','adur','ahdu','acas','abuf'] else 0
 data=int(META.get(k,{}).get('data','0') or '0')
 setf(o,k,value,rank,data=data)

def channel(raw,name,desc,icon,order_name,target,cd,mana,area=0.,cast_range=600.):
 o=ability(raw,'ANcl',name,desc,icon,cd,mana,'air,ground,friend,enemy,organic,mechanical',area,cast_range)
 for k,val in {'Ncl1':0.,'Ncl2':target,'Ncl3':17,'Ncl4':0.,'Ncl5':0,'Ncl6':order_name,'aani':'spell'}.items():mod(o,k,val,0 if k=='aani' else 1)
 return o

def object_files(v):
 units=all_objects(v,'w3u');old=all_objects(v,'w3a');changes={};new={}
 new['fD86']=channel('fD86','Devour Forest Creature','Consume another creature from the Guardia Forest day/night spawn pool. Cannot consume heroes or special quest units. Unlocks Blizzaga after a successful devour. Costs 200 mana.','BTNDevour.blp','devour',1,15.,200,0.,350.)
 new['fA86']=ability('fA86','AHad','Devotion Aura','Nearby allies gain 10% increased armor.','BTNDevotion.blp',area=600.,target='air,ground,friend,self,vulnerable')
 mod(new['fA86'],'Had1',.1,1);mod(new['fA86'],'Had2',1,1);mod(new['fA86'],'abuf','bA86',1)
 new['fR86']=ability('fR86','Absk','Rage','Increases attack speed by 30% and damage taken by 30% for 10 seconds. Cooldown: 30 seconds.','BTNBerserkForTrolls.blp',30.)
 for k,val in {'bsk1':0.,'bsk2':.3,'bsk3':.3,'adur':10.,'ahdu':10.,'abuf':'bR86'}.items():mod(new['fR86'],k,val,1)
 new['fH86']=ability('fH86','Ahea','Heal','Autocast healing for friendly allies.|n|n|cffffcc00Healing Calculation|r|nRestores 25 health per cast. Costs 10 mana.','BTNHeal.blp',1.,10,target='air,ground,friend,organic,vulnerable',cast_range=600.)
 mod(new['fH86'],'Hea1',25.,1)
 new['fT86']=channel('fT86','Taunt','Forces nearby enemies to attack this gnoll for 5 seconds. During Taunt, the gnoll takes 20% less damage. Costs 25 mana. Cooldown: 15 seconds. Radius: 450.','BTNTaunt.blp','roar',0,15.,25,450.,0.)
 new['fE86']=channel('fE86','Evasive Action','Increases evasion by 40 for 10 seconds. Cooldown: 30 seconds.','BTNEvasion.blp','howlofterror',0,30.,0,0.,0.)
 new['fP86']=ability('fP86','AIev','Venomous Attack','33% chance on a landed attack against a hero to poison that hero for 5 seconds.|n|n|cffffcc00Damage Calculation|r|nBase damage per second: 5 + 25 x poisoned hero level. Non-stacking; a new equal/stronger application refreshes the poison.','BTNEnvenomedSpear.blp')
 new['fQ86']=ability('fQ86','AIev','Assassin Poison','15% chance on a landed attack against a hero to poison that hero for 5 seconds.|n|n|cffffcc00Damage Calculation|r|nBase damage per second: 5 + 35 x poisoned hero level. Non-stacking; a new equal/stronger application refreshes the poison.','BTNEnvenomedSpear.blp')
 new['fL86']=ability('fL86','AIev','Alert','When attacking a hero or damaged by a hero in Guardia Forest, calls reinforcements for 10 seconds. Kill this goblin to stop the call. Shows 5, 4, 3, 2, 1 before completion. A successful alert doubles Guardia Forest spawn frequency, wave size and population cap for 60 seconds. Further alerts refresh the duration. Once per goblin.','BTNCallToArms.blp')
 for raw in ['fP86','fQ86','fL86']:mod(new[raw],'Eev1',0.,1)
 new['fN86']=ability('fN86','ACen','Ensnare','Ensnare the enemy and stun it for 1 second when the net lands.','BTNEnsnare.blp',15.,0,cast_range=500.)
 new['fS86']=ability('fS86','AHtb','Trapper stun','Stuns for 1 second.','BTNStormBolt.blp',0.,0,cast_range=99999.)
 for k,val in {'Htb1':0.,'adur':1.,'ahdu':1.}.items():mod(new['fS86'],k,val,1)
 new['fB86']=channel('fB86','Blizzaga','Unlocked by Devour Forest Creature. Sends three ice waves; the middle wave splits into shards.|n|n|cffffcc00Damage Calculation|r|nEach wave: (65 + 1.5 x INT) x Rod spell power. Each shard: (25 + INT) x Rod spell power. This non-hero has 0 INT. Costs 100 mana. Cooldown: 12 seconds.','BTNBlizzard.blp','shockwave',2,12.,100,200.,900.)
 new['fI86']=copy.deepcopy(old['A10N']);new['fI86']['id']='fI86';mod(new['fI86'],'ansf','[Stinger: 20% reduced poison]');mod(new['fI86'],'aub1','Poisons an enemy and slows movement by 30% for 10 seconds. Deals 20% less damage than the previous Stinger Bio.|n|n|cffffcc00Damage Calculation|r|nBase poison per tick: 0.8 x floor(200 / 3) x Inner Mana spell power.',1)
 assert not (set(new)&set(old)), 'New ability IDs must not overwrite any existing spell'
 stock={r['unitAbilID']:r for r in slk((ROOT/'tools/build-inputs/unitabilities.slk').read_bytes())}
 def ua(raw,add=(),remove=()):
  o=units[raw];f=fields(o);existing=f.get(('uabi',None),stock.get(o['base'],{}).get('abilList',''))
  ab=[x for x in existing.split(',') if len(x)==4 and x not in remove]
  for x in add:
   if x not in ab:ab.append(x)
  setf(o,'uabi',','.join(ab),None)
 def uf(raw,**values):
  for k,val in values.items():setf(units[raw],k,val,None)
 uf('nfsh',ulev=5,ua1b=14,ua1d=1,ua1s=9,udef=5.,udty='none',umpm=300,umpi=300)
 ua('nfsh',['fD86','fA86']);uf('nfsh',utub='Level 5. Normal base attack: 15-23. Unarmored, 5 armor, 300 mana. Devours allied Guardia Forest creatures to unlock Blizzaga. Devotion Aura increases nearby allied armor by 10%.')
 ua('nwlt',['A03N']);uf('nwlt',utub='Night Might: stronger and takes less damage at night.')
 uf('nftb',ulev=5,uhpm=350,udef=10.,utub='Level 5. Normal base health: 350. Armor: 10. Rage grants +30% attack speed and +30% damage taken for 10 seconds; 30-second cooldown.');ua('nftb',['fR86'])
 uf('nfsp',uhpm=200,ua1b=5,ua1d=1,ua1s=7,udaa='fH86',utub='Normal base health: 200. Attack: 6-12. Autocast Heal restores 25 allied health for 10 mana.');ua('nfsp',['fH86'],['ACcs'])
 uf('ndtp',udef=7.,uhpm=350);ua('ndtr',['fL86']);ua('nspg',['fP86']);ua('nbrg',['fQ86']);ua('nbld',['fE86'])
 uf('ngnb',ulev=4,uhpm=440,udef=11.,umpm=100,umpi=100,utub='Level 4. Normal base health: 440. Armor: 11. Mana: 100. Taunt forces enemies to attack for 5 seconds and reduces damage taken by 20%. Cost: 25 mana. Cooldown: 15 seconds.');ua('ngnb',['fT86'])
 ua('nftt',['fN86'],['ACen']);ua('n0BS',['fI86'],['A10N']);uf('n0BS',utub='Hunt boss: Stinger. Bio poison damage is 20% lower than before. Bio base damage per tick: 0.8 x floor(200 / 3) x Inner Mana spell power.')
 for raw,desc in {'ndtr':'Alert: Calling Reinforcements for 10 seconds, with a final 5-4-3-2-1 countdown. Kill it before completion to prevent doubled Guardia Forest spawning for 60 seconds.','ndtp':'Normal base health: 350. Armor: 7.','nspg':'33% poison chance per landed attack. Poison base DPS: 5 + 25 x poisoned hero level, for 5 seconds.','nbrg':'15% poison chance per landed attack. Poison base DPS: 5 + 35 x poisoned hero level, for 5 seconds.','nbld':'Evasive Action grants 40 evasion for 10 seconds.','nftt':'Ensnare also stuns its target for 1 second.'}.items():uf(raw,utub=desc)
 changes.update({raw:units[raw] for raw in RAW})
 files={}
 for ext,replacements in [('w3u',changes),('w3a',new)]:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;data=v.archive.read(name)
   if not data:continue
   t=read_objects(data,ext)
   if prefix=='war3map':
    existing=set()
    for table in ['original','custom']:
     updated=[]
     for o in t[table]:
      raw=o['id'] or o['base'];updated.append(copy.deepcopy(replacements.get(raw,o)));existing.add(raw)
     t[table]=updated
    for raw,o in replacements.items():
     if raw not in existing:t['custom' if o['id'] else 'original'].append(copy.deepcopy(o))
    if ext=='w3a':
     for o in t['custom']:
      if o['id']=='hH79':mod(o,'Oar1',.07,1);mod(o,'aub1','Nearby friendly units recover 7% of their maximum health each second.',1)
      if o['id']=='hM79':mod(o,'Arm1',.07,1);mod(o,'aub1','Nearby friendly units recover 7% of their maximum mana each second.',1)
   else:
    for table in ['original','custom']:t[table]=[o for o in t[table] if (o['id'] or o['base']) not in replacements]
   files[name]=write_objects(t,t['version'],ext)
 # Unique aura/rage buffs avoid touching other monster/hero skills.
 for prefix in ['war3map','war3mapSkin']:
  name=prefix+'.w3h';data=v.archive.read(name)
  if not data:continue
  if prefix=='war3map':
   t=read_objects(data,'w3h')
   assert not ({'bA86','bR86'}&set(all_objects(v,'w3h')))
   for raw,base,title,desc in [('bA86','BHad','Devotion Aura','Armor increased by 10%.'),('bR86','Bbsk','Rage','Attack speed increased by 30%. Takes 30% more damage.')]:
    o={'base':base,'id':raw,'sets':[{'flag':0,'mods':[]}]};setf(o,'fnam',title,None);setf(o,'ftip',title,None);setf(o,'fube',desc,None);t['custom'].append(o)
   files[name]=write_objects(t,t['version'],'w3h')
 return files

UPDATE_CLOCK='''function Forest86_UpdateSpawnTimer takes nothing returns nothing
 local timer wave=LoadTimerHandle(udg_SpawnTimerHash,3,1)
 local timer zone=LoadTimerHandle(udg_SpawnTimerHash,1,1)
 if wave!=null and zone!=null and TimerGetRemaining(zone)>0. then
 call TimerStart(wave,30./I2R(Forest86_SpawnFactor(1)),true,function Trig_Zone_Spawn_System_ZoneRespawnTick)
 endif
 set wave=null
 set zone=null
endfunction
'''

def refresh(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n=='RegisterTriggers_MonsterData':new=new.replace('endfunction','    call Forest86_Init()\nendfunction')
  if n=='Trig_Damage_Engine_Actions':
   anchor='        call BlzSetEventDamage(l_amount)';assert anchor in new
   new=new.replace(anchor,anchor+'''\n        if l_amount>0. then
            if IsUnitType(u,UNIT_TYPE_HERO) then
                call Forest86_Alert(triggeringUnit)
            endif
            if priestBasic then
                call Forest86_OnAttack(u,triggeringUnit)
            endif
        endif''',1)
  if n=='Trig_Damage_Engine_Step18_FinalModifiers':
   pos=new.index('    if l_amount>.0')
   new=new[:pos]+'''    if l_amount>0. and not l_heal then
        set l_amount=l_amount*Forest86_Defense(t)
    endif
'''+new[pos:]
  if n in ['Trig_Damage_Engine_GetEvasion','Forsaken_Stat_GetEvasion','Stats_Stat_GetEvasion']:
   pos=new.rfind('    return ');assert pos>=0
   new=new[:pos]+'    set l_eva=l_eva+Forest86_Evasion(u)\n'+new[pos:]
  if n=='Trig_Zone_Spawn_System_SpawnZoneUnits':
   new,count=re.subn(r'(local integer l_maxUnits=LoadInteger\(udg_SpawnDataHash,\s*7,\s*i\))',r'\1*Forest86_SpawnFactor(i)',new);assert count==1
   new,count=re.subn(r'targetUnitCount=l_amount\s*\+\s*j',r'targetUnitCount=l_amount*Forest86_SpawnFactor(i)+j',new);assert count==1
   # These newly authored mana pools start full in either daytime or night.
   anchor='    set j=j+1'
   new=new.replace(anchor,"    if GetUnitTypeId(l_spawned)=='nfsh' or GetUnitTypeId(l_spawned)=='ngnb' then\n        call SetUnitState(l_spawned,UNIT_STATE_MANA,GetUnitState(l_spawned,UNIT_STATE_MAX_MANA))\n    endif\n"+anchor,1)
  if n=='Trig_Zone_Spawn_System_ZoneRespawnTick':
   new,count=re.subn(r'(local integer l_maxUnits=LoadInteger\(udg_SpawnDataHash,\s*7,\s*i\))',r'\1*Forest86_SpawnFactor(i)',new);assert count==1
  if n=='Trig_Zone_Spawn_System_OnZoneEntered':
   new,count=re.subn(r'TimerStart\(l_waveTimer,\s*30,',r'TimerStart(l_waveTimer,30./I2R(Forest86_SpawnFactor(i)),',new);assert count==1
  if n=='Trig_Spell_Blizzaga_Conditions':
   new=re.sub(r'(^[ \t]*return)([^\n]+?)([ \t]*//[^\n]*)?$',r"\1 GetSpellAbilityId()=='fB86' or (\2)\3",new,flags=re.M)
  if n in ['Trig_Bio_Cast_IsBio','Trig_Bio_Cast_Conditions']:
   new=re.sub(r'(^\s*return)([^\n]+?)(\s*//[^\n]*)?$',r"\1 GetSpellAbilityId()=='fI86' or (\2)\3",new,flags=re.M)
  if n=='Trig_Bio_Cast_Actions':
   anchor='    set l_tempReal=Prof_InnerManaPower(GetTriggerUnit())';assert anchor in new
   new=new.replace(anchor,anchor+"\n    if GetSpellAbilityId()=='fI86' then\n        set l_tempReal=l_tempReal*.8\n    endif")
  if new!=b:s=put(s,n,new)
 if 'RegisterTriggers_MonsterData' in fs:
  fragment=(ROOT/'experiments/GuardiaForest/Forest86.j').read_text()
  glob=re.search(r'globals\n(.*?)endglobals',fragment,re.S)
  s=s.replace('endglobals',glob[1]+'endglobals',1)
  funcs=fragment[glob.end():].strip()
  s=s.replace('function RegisterTriggers_MonsterData takes',funcs+'\n\nfunction RegisterTriggers_MonsterData takes',1)
 if 'Trig_Zone_Spawn_System_ZoneRespawnTick' in fs:s=s.replace('function Trig_Zone_Spawn_System_RemoveSpawnedUnit takes',UPDATE_CLOCK+'\nfunction Trig_Zone_Spawn_System_RemoveSpawnedUnit takes',1)
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);files=object_files(v)
 modules={lib:refresh(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]}
 runtime=refresh(v.runtime);runtime,moved=order(runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:
   source=modules[m[1]]
   # Dependencies are explicit for World Editor; playable ordering is verified separately.
   if m[1] in ['TDamage','TZone','TEquip']:
    header=source.splitlines()[0]
    if 'TMonsterData' not in header:source=source.replace(header,header+(', TMonsterData' if ' requires ' in header else ' requires TMonsterData'),1)
   v.wct['entries'][i]=raw_of(source.replace('\n','\r\n'))
 w=wts_read(v.archive.read('war3map.wts'));label='FFERPG QuickUI86 (Guardia Forest)';w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-3500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 a=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert a.read(name)==files.get(name,v.archive.read(name)),name
 before,after=functions(v.runtime),functions(runtime)
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),new_functions=sorted(after.keys()-before.keys()),moved_libraries=moved,units=RAW,notes='Full Dragoon test only. Authored Normal stats. Shared1HzAI/poison/taunt/alert, no local reads. Alert zone1 only:15s/2xwaves/2xcap60s,refreshnotmultiply. Poison targethero level,nonstacking5ticks. House7%. Native gameplay/multiplayer acceptance pending.'),indent=2));print(OUT)
if __name__=='__main__':build()
