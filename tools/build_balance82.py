"""QuickUI82: separate accuracy coefficients and 5% spear mana regeneration."""
from pathlib import Path
import re,json,hashlib,subprocess
from editor_pair import View,runtime_for
from jtok import functions,tokens
from performance_runtime import put
from order_libraries import order
from wct import text_of,raw_of,write_wct
from objdata import read_objects,write_objects
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from mpq import MPQ,write_files,compact
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'tools/tests/fixtures/historical-maps/QuickUI81/FFERPG-QuickUI81.w3x'
OUT=ROOT/'release/development/QuickUI82/FFERPG-QuickUI82.w3x'
DETAIL='|nPer proficiency point: +5% mana regeneration and reduces enemy block chance by 1 percentage point.'
def tip(s,raw=None):
 if raw=='A03M':s=s.replace('0.02 x (Accuracy - target Evasion)','0.004 x (Accuracy - target Evasion)')
 if raw=='A14D':s=s.replace('0.02 x (Accuracy - target Evasion)','0.01 x (Accuracy - target Evasion)')
 if 'Spear is used by' in s and 'Proficiency Bonus:' in s and DETAIL not in s:s+=DETAIL
 return s

def refresh(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n=='DG_AccuracyMultiplier':
   assert 'unit target returns real' in new and '1.+.02*' in new
   new=new.replace('unit target returns real','unit target,real coefficient returns real').replace('1.+.02*','1.+coefficient*')
  if n=='DG_Area':
   for kind,rate in [(2,'.004'),(3,'.01')]:
    old=f'DG_BaseDamage(caster,{kind},0.)*DG_AccuracyMultiplier(caster,target)';assert old in new
    new=new.replace(old,f'DG_BaseDamage(caster,{kind},0.)*DG_AccuracyMultiplier(caster,target,{rate})')
  if n=='Spear80_SyncMana':
   assert new.count('.1*I2R(prof)')==2
   new=new.replace('.1*I2R(prof)','.05*I2R(prof)')
  if n=='Forsaken_ReadRegeneration':
   old=".1*I2R(Prof_GetLevel(hero,'R009'))";assert old in new
   new=new.replace(old,".05*I2R(Prof_GetLevel(hero,'R009'))")
  lines=[]
  for line in new.splitlines():
   raw='A03M' if "SaveStr(SpellCalcData,'A03M'" in line else 'A14D' if "SaveStr(SpellCalcData,'A14D'" in line else None
   lines.append(tip(line,raw))
  new='\n'.join(lines)
  if new!=b:s=put(s,n,new)
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);w=wts_read(v.archive.read('war3map.wts'));files={}
 for ext in ['w3a','w3q']:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;d=v.archive.read(name)
   if not d:continue
   t=read_objects(d,ext)
   for o in t['custom']+t['original']:
    raw=o['id'] or o['base']
    for st in o['sets']:
     for m in st['mods']:
      if not isinstance(m['value'],str):continue
      old=m['value'];resolved=w.get(int(old[8:]),old) if old.startswith('TRIGSTR_') else old
      new=tip(resolved,raw)
      if new!=resolved:m['value']=new
   data=write_objects(t,t['version'],ext)
   if data!=d:files[name]=data
 modules={lib:refresh(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};assert changed=={'TDamage','TRegen','TEquip'},changed
 runtime,_=order(runtime_for(v,v,v,modules));runtime=re.sub(r'\n{3,}','\n\n',runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 label='FFERPG QuickUI82 (Dragoon)'
 for k,s in list(w.items()):w[k]=tip(s)
 w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 m=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert m.read(name)==files.get(name,v.archive.read(name)),name
 before,after=functions(v.runtime),functions(runtime)
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),notes='Drakes multiplier .004; Rise .01; spear regen .05 per point in shared native ability and read-only panel. Ranked spell/research/capped tooltip copies match. House aura10%, spear/drake damage scaling, block reduction1point, input/inventory/timers preserved. Dragoon-test only; native acceptance pending.'),indent=2));print(OUT)
if __name__=='__main__':build()
