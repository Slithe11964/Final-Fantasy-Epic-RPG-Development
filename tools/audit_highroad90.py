from pathlib import Path
from editor_pair import View
from build_forest86 import all_objects,META
from priest_master import fields
from downgrade import wts_read
from asset_gallery_catalogue import slk
v=View(Path('release/development/QuickUI89/FFERPG-QuickUI89.w3x'));w=wts_read(v.archive.read('war3map.wts'));u=all_objects(v,'w3u');a=all_objects(v,'w3a')
def resolve(x):return w.get(int(x[8:]),x) if isinstance(x,str) and x.startswith('TRIGSTR_') else x
for raw,o in u.items():
 f=fields(o);name=resolve(f.get(('unam',None),''))
 if raw in 'nsgg narg nwld nwlg nspb ngns ngna ngno ngnv ngnw ngrk ngst nggr nwrg n01P'.split() or 'lesser flan' in str(name).lower():print(raw,{k:resolve(x) for k,x in f.items() if k[0] in ['unam','uabi','ulev','uhpm','umpm','udef','ua1b','ua1d','ua1s']})
for lib in ['TSpellLiquidSteel','TBio','TSpawn','TMonsterData','TElement','TDamage']:Path('build/audit90-'+lib+'.j').write_text(v.modules[lib])
stock={r['alias']:r for r in slk(Path('tools/build-inputs/abilitydata-review.slk').read_bytes()) if 'alias' in r}
print('Mirror', {k:x for k,x in stock['AOmi'].items() if k.endswith('1') or k in ['code']});print('Mirror authored',fields(a['mMI9']))
print('Avatar fields',[(k,r.get('data'),r.get('displayName')) for k,r in META.items() if 'AHav' in r.get('useSpecific','')]);print('Endurance',[(r,fields(o)) for r,o in a.items() if r in ['AIae']])
