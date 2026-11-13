from pathlib import Path
import re,json
from editor_pair import View
from jtok import functions
from build_forest86 import all_objects
from priest_master import fields
ROOT=Path(__file__).resolve().parents[1]
v=View(ROOT/'release/development/QuickUI90/FFERPG-QuickUI90.w3x');fs=functions(v.runtime)
raws=['nlpd','nlpr','nmrv','nmsn','ntrh','ntrt','ndth','ndtr','ndtb','ndtt','ndtp']
units=all_objects(v,'w3u')
report={r:{'object':{str(k):x for k,x in fields(units[r]).items()},'references':[]} for r in raws}
for lib,s in v.modules.items():
 for n,b in functions(s).items():
  for raw in raws:
   if "'"+raw+"'" in b or 'gg_unit_'+raw+'_' in b:
    report[raw]['references'].append({'module':lib,'function':n,'lines':[l.strip() for l in b.splitlines() if raw in l]})
Path('build/removals91-audit.json').write_text(json.dumps(report,indent=2))
for r,d in report.items():print(r,[(v['module'],v['function'],v['lines'][:4]) for v in d['references']])
for name in ['THunt','THuntGuest','THuntFestival','TBoss','TSpawn','TZeromus','TEnemy','TArena','TArenaExpansion','TZone','TGhoul','TSeeker']:
 if name in v.modules:Path('build/review03-'+name+'.j').write_text(v.modules[name])
print('Nilrem',[(r,fields(o).get(('unam',None))) for r,o in all_objects(v,'w3u').items() if 'nilrem' in str(o).lower()])
