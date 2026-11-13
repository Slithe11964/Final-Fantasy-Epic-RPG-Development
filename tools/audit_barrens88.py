from pathlib import Path
from editor_pair import View
from build_forest86 import all_objects
from priest_master import fields
from downgrade import wts_read
from asset_gallery_catalogue import slk
from jtok import functions
v=View(Path('release/development/QuickUI87/FFERPG-QuickUI87.w3x'));w=wts_read(v.archive.read('war3map.wts'))
def resolve(x):
 if isinstance(x,str) and x.startswith('TRIGSTR_'):return w.get(int(x[8:]),x)
 return x
stock={r['unitAbilID']:r for r in slk(Path('tools/build-inputs/unitabilities.slk').read_bytes())}
units=all_objects(v,'w3u'); ab=all_objects(v,'w3a')
lines=[]
for raw in 'nqbh nowe nowb nzrb nrzg nltl nthl nstw nrzt nrzs nrzm nhrw nhrr nhrq ncea ncen ncer ncim ncks ncnk nhar nhrh ndtr nspb nban nbld'.split():
 o=units.get(raw);lines.append('\nUNIT '+raw+' '+str({k:resolve(x) for k,x in fields(o).items() if k[0] in ['unam','uabi','uhpm','umpm','ua1b','ua1d','ua1s','utub']} if o else 'MISSING'))
 if o:
  for a in fields(o).get(('uabi',None),stock.get(o['base'],{}).get('abilList','')).split(','):
   lines.append(' AB '+a+' '+str({k:resolve(x) for k,x in fields(ab[a]).items()} if a in ab else 'stock'))
for raw,o in units.items():
 if any(s in str(resolve(x)).lower() for k,x in fields(o).items() if k[0]=='unam' for s in ['trickster','etem']):lines.append('\nMATCH '+raw+' '+str({k:resolve(x) for k,x in fields(o).items()}))
for raw,o in ab.items():
 if any(s in str(resolve(x)).lower() for k,x in fields(o).items() if k[0]=='anam' for s in ['evil aura','night might','fog','rapid fire']):lines.append('\nABILITY '+raw+' '+str({k:resolve(x) for k,x in fields(o).items()}))
for name,s in v.modules.items():
 if name in ['TFaith','TFog','TFogCheat','TRapidFire','TSpellRapidFire','TBlock','TMonsterData','TBio','TSpawn'] or any('EvilAura' in n for n in functions(s)):Path('build/audit88-'+name+'.j').write_text(s)
fs=functions(v.runtime)
for n,b in fs.items():
 if n.startswith('Trig_Damage_Engine_') and any(x.lower() in b.lower() for x in ['block','faith','night','A03N','fog','thorns']):lines.append('\n'+b)
Path('build/audit88.txt').write_text('\n'.join(lines))
