"""QuickUI84: Sonic STR/debuff, Drakes multiplier, reduced drake scaling."""
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
BASE=ROOT/'release/development/QuickUI83/FFERPG-QuickUI83.w3x'
OUT=ROOT/'release/development/QuickUI84/FFERPG-QuickUI84.w3x'
def tip(s,raw):
 if raw=='A11R':s=s.replace('5 x MP cost + 3 x STR','5 x MP cost + 4 x STR').replace('10 evasion per stack','5 evasion per stack').replace('Evasion reduction: 10 per stack','Evasion reduction: 5 per stack')
 if raw=='A03M':s=s.replace('0.004 x (Accuracy - target Evasion)','0.006 x (Accuracy - target Evasion)')
 if raw in ['A03M','A14D']:s=re.sub(r'max\(0, (1 \+ 0\.\d+ x \(Accuracy - target Evasion\))\)',r'(\1)',s)
 if raw=='A14G':s=s.replace('1 + 0.1 x Spear Proficiency','1 + 0.04 x Spear Proficiency')
 return s

def refresh(s):
 fs=functions(s)
 for n,b in fs.items():
  new=b
  if n=='DG_BaseDamage':
   old='return (5.*cost+3.*I2R(GetHeroStr(caster,true)))*power';assert old in new
   new=new.replace(old,'return (5.*cost+4.*I2R(GetHeroStr(caster,true)))*power')
  if n=='DG_Area':
   assert 'DG_Reduction(target)+10.' in new and 'DG_AccuracyMultiplier(caster,target,.004)' in new
   new=new.replace('DG_Reduction(target)+10.','DG_Reduction(target)+5.').replace('DG_AccuracyMultiplier(caster,target,.004)','DG_AccuracyMultiplier(caster,target,.006)')
  if n=='DG_AccuracyMultiplier':
   old='return RMaxBJ(0.,1.+coefficient*(Trig_Damage_Engine_GetAccuracy(caster)-Trig_Damage_Engine_GetEvasion(target)))';assert old in new
   new=new.replace(old,'return 1.+coefficient*(Trig_Damage_Engine_GetAccuracy(caster)-Trig_Damage_Engine_GetEvasion(target))')
  if n=='DG_Deal':
   new=new.replace('returns nothing\n','returns nothing\n if amount<=0. then\n return\n endif\n',1)
  if n=='Dragoon80_ScaleDrake':
   assert '1.+.1*I2R' in new;new=new.replace('1.+.1*I2R','1.+.04*I2R')
  lines=[]
  for line in new.splitlines():
   for raw in ['A11R','A03M','A14D','A14G']:
    if "SaveStr(SpellCalcData,'"+raw+"'" in line:line=tip(line,raw)
   lines.append(line)
  new='\n'.join(lines)
  if new!=b:s=put(s,n,new)
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);w=wts_read(v.archive.read('war3map.wts'));files={}
 for name in ['war3map.w3a','war3mapSkin.w3a']:
  d=v.archive.read(name)
  if not d:continue
  t=read_objects(d,'w3a')
  for o in t['custom']+t['original']:
   raw=o['id'] or o['base']
   if raw not in ['A11R','A03M','A14D','A14G']:continue
   for st in o['sets']:
    for m in st['mods']:
     if isinstance(m['value'],str):
      old=m['value'];resolved=w.get(int(old[8:]),old) if old.startswith('TRIGSTR_') else old;new=tip(resolved,raw)
      if new!=resolved:m['value']=new
  data=write_objects(t,t['version'],'w3a')
  if data!=d:files[name]=data
 modules={lib:refresh(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};assert changed=={'TDamage','TLancer','TRegen'},changed
 runtime,_=order(runtime_for(v,v,v,modules));runtime=re.sub(r'\n{3,}','\n\n',runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 label='FFERPG QuickUI84 (Dragoon)';w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 m=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert m.read(name)==files.get(name,v.archive.read(name)),name
 before,after=functions(v.runtime),functions(runtime)
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),notes='Sonic STR4/stack5; Drakes .006; raw accuracy multiplier1+c*(ACC-EVA) with no outer max. Evasion gameplay/stat floors remain0. DG_Deal ignores nonpositive damage so no accidental healing. Drake multiplier1+.04*casterSpearProf replacing .1. Tooltips match. Dragoon-only, inventory/input/timers/normal/classic/master preserved.'),indent=2));print(OUT)
if __name__=='__main__':build()
