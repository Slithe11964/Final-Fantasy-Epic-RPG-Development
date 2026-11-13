"""Review 03d: Central Islands roles and explicit Ancient Hydra split testing."""
from pathlib import Path
import copy,re
import build_review03_revision92 as previous
import build_creature_review03 as review3
from editor_pair import View
from build_forest86 import all_objects
from priest_master import fields
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]
SOURCE_MAP=ROOT/'release/development/QuickUI95/FFERPG-QuickUI95.w3x'
SOURCE=ROOT/'build/review03-source95.w3x'
REVISION='03d'
REVIEW_OUT=ROOT/'release/development/CreatureReview03d/FFERPG-Creature-Review-03d.w3x'
POST_HOOK=lambda script,rows:script
EXTRA_SPELLS=()
EXTRA_EXHIBITS=()

def main():
 previous.OUT=SOURCE_MAP
 previous.SOURCE=SOURCE
 previous.REVISION=REVISION
 previous.REVIEW_OUT=REVIEW_OUT
 catalogue=review3.catalogue;hook=review3.script_hook
 def central_catalogue(base,script):
  rows,audit,fs=catalogue(base,script)
  v=View(previous.SOURCE);units=all_objects(v,'w3u');abilities=all_objects(v,'w3a');rv=review3.review
  for raw,o in abilities.items():
   if (raw.startswith('c') and len(raw)==4 and raw[-1].isdigit()) or raw in EXTRA_SPELLS:
    text=fields(o).get(('aub1',1),'')
    if text:rv.SPELLS[raw]=[str(text).replace('|n','\n')]
  exhibits=[('nhyd','Hydra (Ancient Hydra offspring)','Ancient Hydra: two Hydra offspring on death.',[r for r in ['cPH7','cSP7'] if r in abilities]),('cWE5','Tidal Guardian','Banished Revenant: two summoned guardians; 60-second duration.',['cFR5'])]
  if 'cSP7' in abilities:exhibits.append(('nhyh','Hydra Hatchling','Hydra: two hatchlings when a Hydra dies.',['nPH8'] if 'nPH8' in abilities else []))
  for raw,name,origin,spellids in exhibits:
   if raw not in units:continue
   rv.UNIT_OBJECTS[raw]=units[raw];rv.LEVELS[raw]=fields(units[raw]).get(('ulev',None),1)
   rv.MECHANICS[raw]=origin
   if not any(r['raw']==raw and r['area']==3 for r in rows):
    rows.append(dict(raw=raw,name=name,area=3,area_name='Central Islands',section='Area bosses / summons',origin=origin,abilities=[dict(raw=r,name=fields(abilities[r]).get(('anam',0),r)) for r in spellids],script_sources=['Current-Sources/MonsterData.j'],script_functions=['C95_Spell'],valid_object=True))
  localized={x[0] for x in exhibits}
  rows=[r for r in rows if not (r['raw'] in localized and r['area']==11)]
  rv.MECHANICS['nahy']='Ancient Hydra splits into two smaller Hydras on death. Select it and type -split to see this. Its poison uses the attacking hydra’s level, not the victim’s level.'
  for raw,name,area,area_name,origin in EXTRA_EXHIBITS:
   if raw not in units:continue
   rv.UNIT_OBJECTS[raw]=units[raw];rv.LEVELS[raw]=fields(units[raw]).get(('ulev',None),1);rv.MECHANICS[raw]=origin
   abilityids=fields(units[raw]).get(('uabi',None),'').split(',')
   if not any(r['raw']==raw and r['area']==area for r in rows):rows.append(dict(raw=raw,name=name,area=area,area_name=area_name,section='Area bosses / summons',origin=origin,abilities=[dict(raw=r,name=fields(abilities[r]).get(('anam',0),r)) for r in abilityids if r in abilities],script_sources=['Current-Sources/MonsterData.j'],script_functions=['F99_Spell'],valid_object=True))
   rows=[r for r in rows if not (r['raw']==raw and r['area']==11)]
  review3.review.ROWS=rows
  return rows,audit,fs
 def central_hook(script,rows):
  script=hook(script,rows);fs=functions(script)
  b=fs['Review_Chat'].replace('    elseif s=="-info" and u!=null then','    elseif s=="-split" and u!=null then\n        if GetUnitTypeId(u)==\'nahy\' then\n            call KillUnit(u)\n            call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Ancient Hydra: its native Spawn Hydra creates two smaller Hydras at this location.")\n        else\n            call DisplayTimedTextToPlayer(Player(0),0.,0.,10.,"Select an Ancient Hydra (nahy), then type -split.")\n        endif\n    elseif s=="-info" and u!=null then',1)
  script=put(script,'Review_Chat',b)
  fs=functions(script);b=fs['Review03_Combat'].replace(' call Forest86_Init()', ' call Inventory94_Init()\n set udg_ShurikenDamageTrig=CreateTrigger()\n call TriggerAddCondition(udg_ShurikenDamageTrig,Condition(function Shuriken_Damage))\n set udg_ShurikenRemoveTrig=CreateTrigger()\n call TriggerAddCondition(udg_ShurikenRemoveTrig,Condition(function Shuriken_Remove))\n call Forest86_Init()',1)
  script=put(script,'Review03_Combat',b)
  return POST_HOOK(script,rows)
 review3.catalogue=central_catalogue;review3.script_hook=central_hook
 previous.main()
 p=previous.REVIEW_OUT.parent/'README.md';p.write_text(p.read_text()+'\nCentral Islands: select Ancient Hydra and type -split to test its native two-hydra death split. Smaller Hydras and Tidal Guardians are shown separately beside Central Islands summons. New role tooltips use authored plain-language calculations.\n')

if __name__=='__main__':main()
