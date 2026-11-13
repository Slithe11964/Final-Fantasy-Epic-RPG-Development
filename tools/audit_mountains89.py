from pathlib import Path
from editor_pair import View
from build_forest86 import all_objects
from priest_master import fields
from downgrade import wts_read
from jtok import functions
v=View(Path('release/development/QuickUI88/FFERPG-QuickUI88.w3x'));w=wts_read(v.archive.read('war3map.wts'));units=all_objects(v,'w3u');ab=all_objects(v,'w3a');items=all_objects(v,'w3t')
def resolve(x):return w.get(int(x[8:]),x) if isinstance(x,str) and x.startswith('TRIGSTR_') else x
lines=[]
for raw,o in units.items():
 f=fields(o);name=resolve(f.get(('unam',None),''))
 if raw in 'nass nban nbld nbrg nenf ngno ngns ngnv ngnw nhdc nhhr nkob nkog nkol nkot nogl nogm nogr nomg nrog nwzd nwzg nwzr'.split() or any(s in name.lower() for s in ['apprentice dark','kultist','ogre berserker','queen']):
  lines.append('UNIT '+raw+' '+str({k:resolve(x) for k,x in f.items() if k[0] in ['unam','uabi','ulev','uhpm','umpm','ua1b','ua1d','ua1s','udef','umdl']}))
  for a in f.get(('uabi',None),'').split(','):
   if a in ab:lines.append(' AB '+a+' '+str(ab[a]['base'])+' '+str({k:resolve(x) for k,x in fields(ab[a]).items() if k[0] in ['anam','aub1','acdn','amcs','adur','aare','abuf']}))
for raw in ['I073','I071']:lines.append('ITEM '+raw+' '+str({k:resolve(x) for k,x in fields(items[raw]).items()}))
for name in ['TEquip','TItem','TBackpack','TDevour','TSpawn','TAccumulate','TDarkness','TShock','TSpellCure','TSpell','TUnit']:
 if name in v.modules:Path('build/audit89-'+name+'.j').write_text(v.modules[name])
fs=functions(v.runtime)
for n,b in fs.items():
 if 'accessor' in b.lower() or ('Stack' in n and ('Item' in n or 'Inventory' in n)):lines.append('\n'+b)
Path('build/audit89.txt').write_text('\n'.join(lines))
