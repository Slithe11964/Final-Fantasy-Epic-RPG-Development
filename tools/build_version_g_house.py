"""Add the accepted 7% native house auras to production g, without gameplay script edits."""
import json,hashlib
from pathlib import Path
import build_house79 as package
from house79 import abilities as clone_auras
from objdata import read_objects,write_objects
from priest_master import setf,fields
from editor_pair import View
from build_forest86 import all_objects
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/0.9.7.5g/history/2026-11-04-before-house-regen/FFERPG-0.9.7.5g.w3x'
OUT=ROOT/'build/version-g-house/FFERPG-0.9.7.5g.w3x'

def house7(data):
 t=read_objects(clone_auras(data),'w3a')
 for o in t['custom']:
  if o['id']=='hH79':
   setf(o,'Oar1',.07,1,data=1);setf(o,'Oar2',1,1,data=2)
   setf(o,'aub1','Nearby friendly units recover 7% of their maximum health each second.',1)
  if o['id']=='hM79':
   setf(o,'Arm1',.07,1,data=1);setf(o,'Arm2',1,1,data=2)
   setf(o,'aub1','Nearby friendly units recover 7% of their maximum mana each second.',1)
 return write_objects(t,t['version'],'w3a')

def main():
 package.abilities=house7
 package.build(BASE,OUT,'FFERPG 0.9.7.5g')
 a,b=View(BASE),View(OUT)
 assert a.runtime==b.runtime and a.modules==b.modules
 old,new=all_objects(a,'w3a'),all_objects(b,'w3a')
 assert set(new)-set(old)=={'hH79','hM79'}
 for raw in old:assert old[raw]==new[raw],raw
 for raw,field,flag in [('hH79','Oar1','Oar2'),('hM79','Arm1','Arm2')]:
  f=fields(new[raw]);assert abs(f[field,1]-.07)<1e-7 and f[flag,1]==1
  assert f['aare',1]==350. and '7%' in f['aub1',1]
  for st in new[raw]['sets']:
   assert all(m['data']==({'Oar1':1,'Arm1':1,'Oar2':2,'Arm2':2}[m['field']]) for m in st['mods'] if m['field'] in ['Oar1','Arm1','Oar2','Arm2'])
 old,new=all_objects(a,'w3u'),all_objects(b,'w3u')
 for raw in old:
  if raw not in ['h006','h00N']:assert old[raw]==new[raw],raw
  else:
   f,g=fields(old[raw]),fields(new[raw]);assert g['uabi',None]==f['uabi',None].replace('A001','hH79').replace('A00F','hM79')
   for k in f:
    if k[0]!='uabi':assert f[k]==g[k],(raw,k)
 OUT.with_suffix('.j').write_text(b.runtime)
 report=json.loads(OUT.with_suffix('.json').read_text());report.update(recovery='Both house forms: 7% max HP and max mana per second, native percent flags and data pointers 1/2. Original aura/fountain abilities unchanged, same 350 range/targets, no new timer.',object_isolation='PASS: only two house ability links and two new aura clones',script_editor_and_save_format='byte-identical to prior g',sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),version='0.9.7.5g',date='2026-11-04')
 OUT.with_suffix('.json').write_text(json.dumps(report,indent=2))
 print(json.dumps(report,indent=2))

if __name__=='__main__':main()
