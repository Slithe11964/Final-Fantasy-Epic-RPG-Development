"""QuickUI87: lighter poisons, Triton Alert, short taunt with longer evasion."""
from pathlib import Path
import copy,re,json,hashlib,subprocess
from editor_pair import View
from jtok import functions,tokens
from performance_runtime import put
from order_libraries import order
from objdata import read_objects,write_objects
from priest_master import fields,setf
from build_forest86 import all_objects
from asset_gallery_catalogue import slk
from downgrade import wts_read,wts_write
from wct import text_of,raw_of,write_wct
from mpq import MPQ,write_files,compact
from add_header import read_header,build_header
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI86/FFERPG-QuickUI86.w3x'
OUT=ROOT/'release/development/QuickUI87/FFERPG-QuickUI87.w3x'
ALERT='When attacking a hero or damaged by a hero in Guardia Forest, calls reinforcements for 15 seconds. Kill this triton to stop the call. Shows 5, 4, 3, 2, 1 before completion. A successful alert doubles Guardia Forest spawn frequency, wave size and population cap for 60 seconds. Further alerts refresh the duration. Once per triton.'
TAUNT='Forces nearby enemies to attack this gnoll for 3 seconds and grants the gnoll 40 increased evasion for 15 seconds. Costs 25 mana. Cooldown: 20 seconds. Radius: 450.'
def refresh(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n in ['Forest86_Actor','Forest86_Alert','Forest86_Death']:new=new.replace("'ndtr'","'nmrl'")
  if n=='Forest86_Alert':
   assert 'Forest86Now+10.' in new;new=new.replace('Forest86Now+10.','Forest86Now+15.')
  if n=='Forest86_OnAttack':
   assert 'coefficient=25' in new and 'coefficient=35' in new
   new=new.replace('coefficient=25','coefficient=2').replace('coefficient=35','coefficient=4')
  if n=='Forest86_Taunt':
   assert '22,Forest86Now+5.' in new and '21,Forest86Now+5.' in new
   new=new.replace('22,Forest86Now+5.','22,Forest86Now+15.').replace('21,Forest86Now+5.','21,Forest86Now+3.')
  if n=='Forest86_Defense':new='function Forest86_Defense takes unit u returns real\n return 1.\nendfunction'
  if n=='Forest86_Evasion':
   new=new.replace('returns real\n',"returns real\n if Forest86Data!=null and GetUnitTypeId(u)=='ngnb' and Forest86Now<LoadReal(Forest86Data,GetHandleId(u),22) then\n return 40.\n endif\n",1)
  if new!=b:s=put(s,n,new)
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);units=all_objects(v,'w3u');abil=all_objects(v,'w3a');files={}
 stock={r['unitAbilID']:r for r in slk((ROOT/'tools/build-inputs/unitabilities.slk').read_bytes())}
 for raw in ['nmrl','ndtr']:
  o=units[raw];f=fields(o);ab=[x for x in f.get(('uabi',None),stock.get(o['base'],{}).get('abilList','')).split(',') if len(x)==4 and x!='fL86']
  if raw=='nmrl':ab.append('fL86')
  setf(o,'uabi',','.join(ab),None)
 setf(units['nmrl'],'utub','Alert: Calling Reinforcements for 15 seconds, with a final 5-4-3-2-1 countdown. Kill it before completion to prevent doubled Guardia Forest spawning for 60 seconds.',None)
 setf(units['ndtr'],'utub','Dark Goblin. Appears in the Guardia Forest night pool.',None)
 setf(units['nspg'],'utub','33% poison chance per landed attack. Poison base DPS: 5 + 2 x poisoned hero level, for 5 seconds.',None)
 setf(units['nbrg'],'utub','15% poison chance per landed attack. Poison base DPS: 5 + 4 x poisoned hero level, for 5 seconds.',None)
 setf(units['ngnb'],'utub','Level 4. Normal base health: 440. Armor: 11. Mana: 100. Taunt forces enemies to attack for 3 seconds and grants 40 evasion for 15 seconds. Cost: 25 mana. Cooldown: 20 seconds.',None)
 for raw,old,new in [('fP86','5 + 25 x','5 + 2 x'),('fQ86','5 + 35 x','5 + 4 x')]:
  for st in abil[raw]['sets']:
   for m in st['mods']:
    if isinstance(m['value'],str):m['value']=m['value'].replace(old,new)
 setf(abil['fL86'],'aub1',ALERT,1)
 setf(abil['fT86'],'aub1',TAUNT,1);setf(abil['fT86'],'acdn',20.,1)
 for ext,replacements in [('w3u',{r:units[r] for r in ['nmrl','ndtr','nspg','nbrg','ngnb']}),('w3a',{r:abil[r] for r in ['fP86','fQ86','fL86','fT86']})]:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;d=v.archive.read(name)
   if not d:continue
   t=read_objects(d,ext);seen=set()
   for table in ['original','custom']:
    if prefix=='war3map':
     for i,o in enumerate(t[table]):
      raw=o['id'] or o['base']
      if raw in replacements:t[table][i]=copy.deepcopy(replacements[raw]);seen.add(raw)
    else:t[table]=[o for o in t[table] if (o['id'] or o['base']) not in replacements]
   if prefix=='war3map':
    for raw,o in replacements.items():
     if raw not in seen:t['custom' if o['id'] else 'original'].append(copy.deepcopy(o))
   data=write_objects(t,t['version'],ext)
   if data!=d:files[name]=data
 modules={lib:refresh(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};assert changed=={'TMonsterData'},changed
 runtime=refresh(v.runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 w=wts_read(v.archive.read('war3map.wts'));label='FFERPG QuickUI87 (Guardia Forest)';w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 a=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert a.read(name)==files.get(name,v.archive.read(name)),name
 before,after=functions(v.runtime),functions(runtime)
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),notes='Spider5+2*victimLv/33%,assassin5+4*victimLv/15%,5ticks retained. Alertmovedndtr->nmrl15s final5..1; day/nightpoolunchanged. Gnoll3staunt/40evasion15s/CD20,25MP retained;damage reductionremoved. No new timers/input/UI callbacks. FullDragoononly,liveacceptancepending.'),indent=2));print(OUT)
if __name__=='__main__':build()
