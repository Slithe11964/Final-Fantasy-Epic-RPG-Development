"""Build review 03b with separate regional spiders and Barrens corrections."""
from build_barrens92 import *
from build_removals91 import pool_blocks
import build_creature_review03 as review3

SOURCE=ROOT/'build/review03-source92.w3x'
REVISION='03b'
REVIEW_OUT=ROOT/'release/development/CreatureReview03b/FFERPG-Creature-Review-03b.w3x'
HIGHROAD='rSP3'
POISON='rPS3'

def spiders(s):
 fs=functions(s)
 for n in ['H90_Pool','H90_AI']:
  if n in fs:
   s=put(s,n,fs[n].replace("'nspb'","'rSP3'"))
 if 'Forest86_Actor' in fs:s=put(s,'Forest86_Actor',fs['Forest86_Actor'].replace(' return '," return raw=='nspb' or ",1))
 if 'Forest86_OnAttack' in fs:
  b=fs['Forest86_OnAttack'].replace(" elseif raw=='nspb' then"," elseif raw=='nspb' then\n set chance=33\n set coefficient=3\n set base=10\n set duration=10.\n elseif raw=='rSP3' then",1)
  s=put(s,'Forest86_OnAttack',b)
 if 'Trig_Spawn_Pools_Init_Actions' in fs:
  b=fs['Trig_Spawn_Pools_Init_Actions']
  for m,day,zone in reversed(list(pool_blocks(b))):
   if zone!=1:b=b[:m.start()]+m[0].replace("'nspb'","'rSP3'")+b[m.end():]
  s=put(s,'Trig_Spawn_Pools_Init_Actions',b)
 # Arena copies retain the current Highroad definition rather than silently
 # inheriting the restored Forest original.
 s=re.sub(r"(set\s+udg_ArenaMonsterType\[[^]]+\]\s*=\s*)'nspb'",r"\1'rSP3'",s)
 return s

def source():
 assert not SOURCE.exists()
 v=View(OUT);old=View(ROOT/'release/development/QuickUI88/FFERPG-QuickUI88.w3x')
 forest=copy.deepcopy(all_objects(old,'w3u')['nspb'])
 u=copy.deepcopy(all_objects(v,'w3u')['nspb']);u['id']=HIGHROAD
 a=copy.deepcopy(all_objects(old,'w3a')['bP88']);a['id']=POISON
 setf(u,'uabi',','.join(POISON if x=='bP88' else x for x in fields(u)['uabi',None].split(',')))
 setf(u,'unam','Black Spider (Galbados Highroad)')
 setf(forest,'unam','Black Spider (Guardia Forest)')
 desc='30% chance on a landed attack to poison a hero for 10 seconds.|n|n|cffffcc00Damage Calculation|r|n100 + 5 x poisoned hero level damage per second. Non-stacking; equal/stronger applications refresh.'
 mod(a,'aub1',desc,1)
 files={}
 for ext,obj in [('w3u',u),('w3a',a)]:
  t=read_objects(v.archive.read('war3map.'+ext),ext);assert not any((o['id'] or o['base'])==obj['id'] for o in t['custom']+t['original']);t['custom'].append(obj)
  if ext=='w3u':t['original']=[forest if o['base']=='nspb' else o for o in t['original']]
  files['war3map.'+ext]=write_objects(t,t['version'],ext)
 runtime=spiders(v.runtime)
 for i,raw in enumerate(v.wct['entries']):
  txt=text_of(raw);updated=spiders(txt)
  if txt!=updated:v.wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)})
 write_files(str(OUT),str(SOURCE),files)

def main():
 source()
 review3.BASE=SOURCE;review3.OUT=REVIEW_OUT;review3.REVISION=REVISION
 hook=review3.script_hook
 def labelled(s,rows):
  s=hook(s,rows).replace('Creature Review 03 ready.','Creature Review '+REVISION+' ready.')
  # The isolated review omitted the normal path probe and shared wrapper
  # callbacks. Missiles were disappearing and liquid/wind instances could
  # never release their effects. Initialize only the combat callbacks needed.
  startup='''    call Path_Init()
    set udg_MissileCollisionTrig=CreateTrigger()
    call TriggerAddCondition(udg_MissileCollisionTrig,Condition(function Missile_CheckCollision))
    set udg_MissileDamageTrig=CreateTrigger()
    call TriggerAddCondition(udg_MissileDamageTrig,Condition(function Missile_DamageWrap))
    set udg_MissileImpactTrig=CreateTrigger()
    call TriggerAddCondition(udg_MissileImpactTrig,Condition(function Missile_Impact))
    set udg_LiquidSteelRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_LiquidSteelRemoveTrig,Condition(function LiquidSteel_Remove))
    set udg_RapidFireRemoveTrig=CreateTrigger()
    call TriggerAddCondition(udg_RapidFireRemoveTrig,Condition(function RapidFire_Remove))
'''
  fs=functions(s)
  s=put(s,'Review03_Combat',fs['Review03_Combat'].replace(' call Forest86_Init()',startup+' call Forest86_Init()',1))
  # Keep one initializer call site, matching the existing isolated startup rule.
  fs=functions(s)
  for n,b in fs.items():
   if n!='Review03_Combat' and 'call Path_Init()' in b:s=put(s,n,b.replace('call Path_Init()','// Path probe initialized by review combat startup.'))
  return s
 review3.script_hook=labelled
 original_catalogue=review3.catalogue;original_files=review3.files_hook
 detailed={}
 def readable(base,script):
  rows,audit,fs=original_catalogue(base,script)
  rv=review3.review
  detailed.update(spells=copy.deepcopy(rv.SPELLS),scripted=copy.deepcopy(rv.MECHANICS))
  for raw,entries in rv.SPELLS.items():
   rv.SPELLS[raw]=[text.split('\nScript calculation',1)[0].removeprefix('Hero-caster formula (where applicable): ').replace('floor(its current HP at release)','its current health at release, rounded down').replace('floor(its current HP)','its current health, rounded down').replace('93.75%-100%','93.75% to 100%') for text in entries]
  v=View(SOURCE);units=all_objects(v,'w3u');strings=wts_read(v.archive.read('war3map.wts'))
  rv.SPELLS[POISON]=[str(fields(all_objects(v,'w3a')[POISON])['aub1',1]).replace('|n','\n')]
  for raw,trace in list(rv.MECHANICS.items()):
   authored=str(fields(units[raw]).get(('utub',None),'')) if raw in units else ''
   if authored.startswith('TRIGSTR_'):authored=strings.get(int(authored[8:]),'')
   kinds=[]
   for needle,label in [('UnitDamage','direct damage'),('Heal','healing'),('CreateNUnits','summons'),('UnitAddAbility','temporary abilities or status changes'),('SetUnitMoveSpeed','movement changes')]:
    if needle in trace:kinds.append(label)
   extra='Scripted encounter effects: '+', '.join(kinds)+'. Full conditional audit: Detailed-Script-Audit.json.' if kinds else 'No additional scripted damage or healing found; see -abilities for its spells.'
   rv.MECHANICS[raw]=(authored.replace('|n','\n')+'\n\n' if authored else '')+extra
  return rows,audit,fs
 def clean_files(files,base):
  files=original_files(files,base)
  rv=review3.review
  plain=lambda text:re.sub(r'\|c[0-9A-Fa-f]{8}|\|r|\s','',text.replace('|n',' '))
  for filename in ['war3map.w3a','war3mapSkin.w3a']:
   if filename not in files:continue
   t=read_objects(files[filename],'w3a')
   for o in t['original']+t['custom']:
    raw=o['id'] or o['base']
    for rank,desc in enumerate(rv.SPELLS.get(raw,[]),1):
     f=fields(o);text=str(f.get(('aub1',rank),''));authored=text.split('|n|n|cffffcc00Calculation / effect values|r|n',1)[0]
     if plain(desc) in plain(authored) or desc.startswith('No direct damage/heal amount:'):text=authored
     else:text=authored+'|n|n|cffffcc00Effect and calculation|r|n'+desc.replace('\n','|n')
     setf(o,'aub1',text,rank)
   files[filename]=write_objects(t,t['version'],'w3a')
  (review3.OUT.parent/'Detailed-Script-Audit.json').write_text(json.dumps(detailed,indent=2),encoding='utf-8')
  return files
 review3.catalogue=readable;review3.files_hook=clean_files
 review3.main()
 p=review3.OUT.parent/'README.md';p.write_text(p.read_text().replace('Creature Review 03','Creature Review '+REVISION).replace('Based on QuickUI91','Based on the current candidate; Forest nspb restores its QuickUI88 values and Highroad uses a separate clone retaining its current numbers. Includes projectile pathing/cleanup initialization. Based on the current full Dragoon map'),encoding='utf-8')
if __name__=='__main__':main()
