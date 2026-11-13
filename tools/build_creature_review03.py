"""Current-map creature review with local rare hunts/bosses and live monster combat."""
from pathlib import Path
import sys,re,json,copy,collections
sys.path.insert(0,str(Path(__file__).resolve().parent))
import build_creature_review as build
import build_creature_review02 as review
from build_removals91 import GLOBAL_REMOVALS,CENTRAL_REMOVALS
from build_forest86 import all_objects
from editor_pair import View
from priest_master import fields
from jtok import functions,tokens
from performance_runtime import put
from review03_origins import origins
ROOT=build.ROOT
BASE=ROOT/'release/development/QuickUI91/FFERPG-QuickUI91.w3x'
OUT=ROOT/'release/development/CreatureReview03/FFERPG-Creature-Review-03.w3x'
REVISION='03'
EVIDENCE={};ORIGINS={};HUNTS={};ARENA={};CURRENT={}

def literal(s):
 s=s.strip()
 if s.startswith('$'):return int(s[1:],16)
 if s.startswith("'"):return int.from_bytes(s[1:-1].encode(),'big')
 return int(s)
def arena_teams(script):
 f=functions(script);roster={literal(m[1]):m[2] for m in re.finditer(r"set\s+udg_ArenaMonsterType\[([^]]+)\]\s*=\s*'(.{4})'",script)}
 names={};membership=collections.defaultdict(set)
 for n,b in f.items():
  if not n.startswith('Trig_Arena_TeamData'):continue
  for m in re.finditer(r'SaveStringBJ\("([^"\n]+)",\s*1,\s*([^,]+),\s*udg_GameStateHash\)',b):names[literal(m[2])]=m[1]
  for m in re.finditer(r"SaveIntegerBJ\(\(\s*(\$[0-9A-Fa-f]+|\d+|'[^']+')\s*\+\s*LoadIntegerBJ\(2,0,udg_GameStateHash\)\),\s*[789],\s*([^,]+),\s*udg_GameStateHash\)",re.sub(r'[ \t]','',b)):
   raw=roster.get(literal(m[1]));team=literal(m[2])
   if raw:membership[raw].add(team)
 return {raw:[names.get(i,'Team '+str(i)) for i in sorted(ids)] for raw,ids in membership.items()},set(roster.values())
def prepare(v):
 global CURRENT
 actual={}
 for p in (ROOT/'src/triggers').rglob('*.j'):
  m=re.match(r'\s*library\s+(\w+)',p.read_text(encoding='utf-8-sig'))
  if m:actual[m[1]]=p.relative_to(ROOT/'src/triggers')
 CURRENT={}
 for lib,text in v.modules.items():
  rel=actual.get(lib,Path('04 Combat and abilities')/(lib[1:]+'.j'))
  target=OUT.parent/'Current-Sources'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
  if 'Startup coordinator' not in str(rel):CURRENT[target]=text
 review.CURRENT_SOURCES=CURRENT;build.SOURCE_TEXTS=CURRENT

def catalogue(base,script):
 global EVIDENCE,ORIGINS,HUNTS,ARENA
 rows,audit,fs=review.catalogue(base,script)
 v=View(BASE);units=all_objects(v,'w3u');abilities=all_objects(v,'w3a');w=build.wts_read(base.read('war3map.wts'))
 def resolve(x):return w.get(int(x[8:]),x) if isinstance(x,str) and x.startswith('TRIGSTR_') else x
 ORIGINS,HUNTS,EVIDENCE,rects,areas=origins(script);ARENA,roster=arena_teams(script)
 # Prefer explicitly authored hunt-location descriptions over nearest rectangles.
 aliases={1:r'guardia',2:r'\bbarrens\b',3:r'central (?:islands|isles)',4:r'northern mountains?',5:r'galbados|highroad',6:r'naga islands?',7:r'lothlorien',8:r'icy realm',9:r'(?:dark )?dragon marsh'}
 for raw,hunt in HUNTS.items():
  name=str(resolve(fields(units[raw]).get(('unam',None),'')))
  hints=[]
  for marker,o in units.items():
   f=fields(o);title=str(resolve(f.get(('unam',None),'')))
   if name and name.lower() in title.lower() and ('hunt' in title.lower() or marker==raw):hints.append(str(resolve(f.get(('utub',None),''))))
  matches={area for area,pat in aliases.items() if re.search(pat,' '.join(hints),re.I)}
  if len(matches)==1:
   hunt['area']=next(iter(matches));ORIGINS[raw]=hunt['area'];hunt['location_hint']='Authored hunt description'
 # Associate additional forms/summons with a boss's single verified world area.
 poolraws={r['raw'] for r in rows if r['section'] in ['Regular spawns','After Dimensional Boundary','Later Hell invasion']}
 for path,text in CURRENT.items():
  if not path.name.startswith('Boss'):continue
  refs=set(re.findall(r"'(.{4})'",text))&set(units)
  homes={ORIGINS[r] for r in refs if r in ORIGINS and r not in poolraws}
  if len(homes)==1:
   home=next(iter(homes))
   for raw in refs-poolraws:
    if raw not in ORIGINS:ORIGINS[raw]=home;EVIDENCE.setdefault(raw,[]).append(dict(area=home,source=str(path.relative_to(OUT.parent)),kind='Associated boss form/summon',point=None,distance=None))
 unique={r['raw']:copy.deepcopy(r) for r in rows}
 ORIGINS['mH89']=4
 # New Cultist summon is created for a variable owner, outside old literal scans.
 if 'mH89' not in unique:
  unique['mH89']=dict(raw='mH89',name='Demon Hound',area=4,area_name=build.AREAS[4],section='Area bosses / summons',origin='Cultist summon; Northern Mountains',abilities=[],script_sources=['Current-Sources/MonsterData.j'],script_functions=['M89_Spell'],valid_object=True)
  review.UNIT_OBJECTS['mH89']=units['mH89'];review.LEVELS['mH89']=1;ORIGINS['mH89']=4
 for raw,r in unique.items():
  f=fields(units[raw]) if raw in units else {};proper=str(resolve(f.get(('upro',None),'')))
  if proper and ',' not in proper and len(proper)<70 and proper not in r['name'] and not proper.startswith('TRIGSTR_'):r['name']=proper+' ('+r['name']+')'
  if raw=='U006':r['name']='Nilrem (Necromancer)'
 result=[];seen=set()
 def add(raw,area,section,origin):
  if (raw,area,section) in seen:return
  seen.add((raw,area,section));r=copy.deepcopy(unique[raw]);r.update(area=area,area_name=build.AREAS[area],section=section,origin=origin);result.append(r)
 # Retain pool and Boundary lineups at their correct source areas.
 for r in rows:
  if r['area']<10 and r['section'] in ['Regular spawns','After Dimensional Boundary','Later Hell invasion']:
   if r['raw'] in GLOBAL_REMOVALS or (r['area']==3 and r['raw'] in CENTRAL_REMOVALS):continue
   add(r['raw'],r['area'],r['section'],r['origin'])
 worldshown={r['raw'] for r in result}
 for raw,hunt in HUNTS.items():
  if raw in unique:add(raw,hunt['area'],'Rare hunts','Hunt '+str(hunt['index'])+'; '+hunt['rect']+'; '+hunt.get('location_hint','source spawn position / nearest regional pool'))
 for raw,area in ORIGINS.items():
  if raw in unique and raw not in poolraws and raw not in HUNTS and raw not in GLOBAL_REMOVALS and raw not in CENTRAL_REMOVALS:
   add(raw,area,'Area bosses / summons','World encounter; '+('; '.join(x['source'] for x in EVIDENCE.get(raw,[])[:2]) or 'Authored regional summon'))
 worldshown={r['raw'] for r in result}
 removed_types=GLOBAL_REMOVALS|CENTRAL_REMOVALS
 for r in rows:
  raw=r['raw']
  if raw in removed_types and raw not in worldshown and r['area']!=12:continue
  if r['area'] in [10,12]:
   origin=r['origin']
   if r['area']==12:origin+='; '+('Teams: '+', '.join(ARENA[raw]) if raw in ARENA else 'Arena roster entry; no named team reference found')
   add(raw,r['area'],r['section'],origin)
  elif r['area']==11 and raw not in worldshown:add(raw,11,r['section'],r['origin'])
 # Include new ordinary native/scripted ability descriptions from current objects.
 prefixes=('f','b','m','h')
 role_ids={a for r in result for a in [x['raw'] for x in r['abilities']] if a in abilities and a.startswith(prefixes)}
 for raw in role_ids:
  f=fields(abilities[raw]);desc=str(resolve(f.get(('aub1',1),'')))
  if raw in ['fD86','bD88','mDV9','hDV0'] or re.search(r'^[fbmh][A-Za-z0-9]{3}$',raw):
   if desc:review.SPELLS[raw]=[desc.replace('|n','\n')]
 for raw,r in unique.items():
  extra=[]
  if raw in units:
   f=fields(units[raw]);ids=f.get(('uabi',None),'').split(',')
   if any(a in role_ids for a in ids):extra.append('Current monster-role behavior:\n'+str(resolve(f.get(('utub',None),''))).replace('|n','\n'))
  if raw=='mH89':extra.append('Summoned by Cultist: level 10, 1000 health, 25 Fortified armor, 30-40 Chaos damage; 45-second timed life.')
  if extra:review.MECHANICS[raw]='\n\n'.join(extra)+'\n\n'+review.MECHANICS.get(raw,'')
 review.ROWS=result
 audit.update(current_base=str(BASE),world_removed=sorted(GLOBAL_REMOVALS),central_removed=sorted(CENTRAL_REMOVALS),rare_hunts=len(HUNTS),localized_types=len({r['raw'] for r in result if r['section'] in ['Rare hunts','Area bosses / summons']}),arena_teams={r:ARENA.get(r,[]) for r in sorted(removed_types)},covered_unique=len({r['raw'] for r in result}),combat='Current combat damage pipeline and role spells; quests/loot/world spawns/boss phases disabled')
 (OUT.parent/'Encounter-Origins.json').write_text(json.dumps(dict(hunts=HUNTS,evidence=EVIDENCE,homes=ORIGINS,arena_teams=ARENA),indent=2))
 return result,audit,fs

def layout(rows,area,x,y):
 here=[r for r in rows if r['valid_object'] and r['area']==area]
 if area>=10:return [(build.AREAS[area],here,x,y-500.,y-1100.,(24,350.,440.))]
 groups=[('Regular spawns',[r for r in here if r['section']=='Regular spawns'],x,y-450.,y-950.),('After Boundary / later',[r for r in here if r['section'] in ['After Dimensional Boundary','Later Hell invasion']],x+4700.,y-450.,y-950.),('Rare hunts',[r for r in here if r['section']=='Rare hunts'],x,y-3500.,y-3950.),('Area bosses / summons',[r for r in here if r['section']=='Area bosses / summons'],x+4700.,y-3500.,y-3950.)]
 for title,g,gx,ly,sy in groups:assert len(g)<=45,(area,title,len(g))
 return [(title,g,gx,ly,sy,(9,450.,440.)) for title,g,gx,ly,sy in groups]

def script_hook(script,rows):
 script=review.script_hook(script,rows)
 # The isolated entry point owns these registrations; dormant RPG startup
 # definitions must not retain duplicate call sites.
 for name in ['Register_Damage_RegisterEnter','Register_Damage_RegisterAttacked','Register_Damage_Engine','Register_Damage_ProxyCleanup','Register_Damage_Splash','Forest86_Init']:
  script=re.sub(r'^[ \t]*call\s+(?:ExecuteFunc\(\s*"'+re.escape(name)+r'"\s*\)|'+re.escape(name)+r'\(\s*\))[^\n]*','    // Registered by Creature Review combat startup.',script,flags=re.M)
 fragment=(ROOT/'experiments/GuardiaForest/CreatureReview03.j').read_text();glob=re.search(r'globals\n(.*?)endglobals',fragment,re.S);script=script.replace('endglobals',glob[1]+'endglobals',1)
 # All review dependencies are already above the runtime helper section.
 script=script.replace('function Review_Start takes',fragment[glob.end():].strip()+'\nfunction Review_Start takes',1)
 fs=functions(script)
 b=fs['Review_Start'].replace('    call ExecuteFunc("Review02_Load")','    call ExecuteFunc("Review02_Load")\n    call Review03_Combat()',1).replace('Creature Review 02 ready.','Creature Review 03 ready.')
 b=b.replace('Selection is silent.','Selection is silent. -enemy tests hostile AI; -wound injures selected unit; -day / -night sets time.')
 script=put(script,'Review_Start',b)
 b=fs['Review_Add'].replace('    call Review02_Setup(u)','    call SaveInteger(ReviewHash,GetHandleId(u),2,Review03_AreaAt(x,y))\n    call Review02_Setup(u)',1)
 # AreaAt must precede Add; place it before the first review helper.
 area_fn=functions(fragment)['Review03_AreaAt'];script=script.replace(area_fn,'',1);script=script.replace('function Review_Add takes',area_fn+'\nfunction Review_Add takes',1);script=put(script,'Review_Add',b)
 b=fs['Review_Chat'].replace('    elseif s=="-refresh"', '''    elseif s=="-enemy" and u!=null then
        call Review03_Hostile(u)
    elseif s=="-wound" and u!=null then
        call SetWidgetLife(u,RMaxBJ(1.,I2R(BlzGetUnitMaxHP(u))*.5))
    elseif s=="-day" then
        call SetFloatGameState(GAME_STATE_TIME_OF_DAY,12.)
    elseif s=="-night" then
        call SetFloatGameState(GAME_STATE_TIME_OF_DAY,22.)
    elseif s=="-refresh"''',1)
 b=b.replace('        call Review02_Setup(ReviewFighter)','        call SaveInteger(ReviewHash,GetHandleId(ReviewFighter),2,LoadInteger(ReviewHash,GetHandleId(u),2))\n        call Review02_Setup(ReviewFighter)',1)
 b=b.replace('-refresh restores HP/mana/cooldowns;', '-enemy: hostile AI; -wound: selected half HP; -day/-night: time; -refresh restores HP/mana/cooldowns;')
 script=put(script,'Review_Chat',b)
 b=fs['Review_Targets'].replace("CreateUnit(Player(11),'hfoo'","CreateUnit(Player(11),'Hpal'").replace("CreateUnit(Player(0),'hfoo'","CreateUnit(Player(0),'Hpal'")
 b=b.replace('        call BlzSetUnitMaxHP(u,1000000)','        call SetHeroLevel(u,10,false)\n        call SuspendHeroXP(u,true)\n        call BlzSetUnitMaxHP(u,1000000)')
 b=b.replace('    call BlzSetUnitMaxHP(ReviewFriend,100000)','    call SetHeroLevel(ReviewFriend,10,false)\n    call SuspendHeroXP(ReviewFriend,true)\n    call BlzSetUnitMaxHP(ReviewFriend,100000)')
 script=put(script,'Review_Targets',b)
 # Manual casts are available to Red; hostile copies alone run the monster AI.
 b=fs['Trig_Damage_Engine_Step19_Apply'].replace("GetUnitTypeId(u)=='nhdc' and GetOwningPlayer(u)==Player(11)","GetUnitTypeId(u)=='nhdc' and (GetOwningPlayer(u)==Player(11) or GetOwningPlayer(u)==Player(0))")
 script=put(script,'Trig_Damage_Engine_Step19_Apply',b)
 # Calls are by name where the control functions precede their definitions.
 script=script.replace('call Review03_Hostile(u)','set ReviewSelected=u\n        call ExecuteFunc("Review03_HostileSelected")')
 selected='function Review03_HostileSelected takes nothing returns nothing\n    call Review03_Hostile(ReviewSelected)\nendfunction\n'
 script=script.replace('function Review_Start takes',selected+'\nfunction Review_Start takes',1)
 return script

def files_hook(files,base):
 files=review.files_hook(files,base)
 path=OUT.parent/'Creature-Catalogue.md';text=path.read_text(encoding='utf-8');text=text.replace('Creature Review 02','Creature Review 03').replace('The full RPG damage pipeline and automatic encounter AI do not run in this isolated review.','Current damage and monster-role spell mechanics run; automatic boss phases, quests, loot and world spawners stay off. -enemy creates a hostile practice copy using current monster AI.');path.write_text(text,encoding='utf-8')
 return files

def main():
 assert not OUT.exists()
 OUT.parent.mkdir(parents=True,exist_ok=True);v=View(BASE);prepare(v)
 build.EXTRA_UNITS=set(origins(v.runtime)[1])|{'mH89'}
 build.BASE=BASE;build.OUT=OUT;build.NAME='FFERPG - Creature Review '+REVISION;build.DISPLAY_AREAS=12;build.PRACTICE_AREA=13
 build.AREAS.update({4:'Northern Mountains',5:'Galbados Highroad',10:'Arena of Darkness',11:'Other story / world encounters',12:'Battle Arena',13:'Practice arena'})
 build.center=lambda i:(17800.,-21100.) if i==13 else (-2800.+((i-1)%3)*10300.,2900.-((i-1)//3)*6000.)
 build.catalogue=catalogue;build.SCRIPT_HOOK=script_hook;build.FILES_HOOK=files_hook;build.LAYOUT_GROUPS=layout;build.CHANGED_OBJECTS={'war3map.w3a'}
 build.DIRECTORY='Red controls exhibits. -info: stats/origin. -abilities [page]: calculations. -spells [page]: scripts. -test: controlled practice copy. -enemy: hostile AI copy. -wound: selected half HP. -day/-night: time. -refresh: HP/MP/cooldowns. -mana: test mana. -reset: targets. -safe/-vulnerable: protection.\n\n'+'\n'.join(f'-area {i}: {name}' for i,name in build.AREAS.items())+'\n\nNormal baseline. Area groups: regular, later/Boundary, rare hunts, local bosses. Current combat enabled; quests, world spawns and boss phases off. No saves.'
 build.build()
 (OUT.parent/'README.md').write_text('# Creature Review 03\n\n'+build.DIRECTORY+'\n\nBased on QuickUI91, including all role/balance changes through QuickUI90 and the world-pool removals. Selection stays silent. -info and -abilities/-spells are explicit. Normal authored stats, damageable copies, authored boss levels/gear/ranks. New monster-role spells and the damage engine run; full encounter phases remain documented, not automatically started. Use -enemy to observe hostile AI. Use -wound for injured-only Devour and healing tests. Rare-hunt origins and encounter placement evidence: Encounter-Origins.json. Native acceptance pending.\n',encoding='utf-8')
if __name__=='__main__':main()
