"""QuickUI81: balance and all house tooltip surfaces, Dragoon test only."""
from pathlib import Path
import re,json,hashlib,subprocess
from editor_pair import View,runtime_for
from jtok import functions,tokens
from performance_runtime import put
from order_libraries import order
from wct import text_of,raw_of,write_wct
from objdata import read_objects,write_objects
from priest_master import setf,fields
from damage_tooltips import merged
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from mpq import MPQ,write_files,compact
from build_spear80 import SPEARS
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI80/FFERPG-QuickUI80.w3x'
OUT=ROOT/'release/development/QuickUI81/FFERPG-QuickUI81.w3x'
OLD_BONUS='Greatly increases the power of Dragon Techniques.'
BONUS='Increases mana regen and reduces enemies chance to block.'
FACTOR='max(0, 1 + 0.02 x (Accuracy - target Evasion))'
HELPER='''function DG_AccuracyMultiplier takes unit caster,unit target returns real
 return RMaxBJ(0.,1.+.02*(Trig_Damage_Engine_GetAccuracy(caster)-Trig_Damage_Engine_GetEvasion(target)))
endfunction
'''

def text(s):
 s=s.replace(' + max(0, Accuracy - target Evasion).',' x '+FACTOR+'.')
 s=s.replace('Impact radius: 200 (diameter 400).','Impact radius: 300 (diameter 600).')
 if 'Spear is used by' in s or 'Spear proficiency' in s:
  s=s.replace('Lancer','Dragoon').replace(OLD_BONUS,BONUS)
 return s

def refresh(s):
 s=text(s);fs=functions(s)
 if 'DG_Area' in fs:
  b=fs['DG_Area']
  for kind in [2,3]:
   old=f'set amount=DG_BaseDamage(caster,{kind},0.)+RMaxBJ(0.,Trig_Damage_Engine_GetAccuracy(caster)-Trig_Damage_Engine_GetEvasion(target))'
   assert old in b;b=b.replace(old,f'set amount=DG_BaseDamage(caster,{kind},0.)*DG_AccuracyMultiplier(caster,target)')
  assert 'elseif kind==4 then\n set radius=200.' in b
  b=b.replace('elseif kind==4 then\n set radius=200.','elseif kind==4 then\n set radius=300.')
  s=put(s,'DG_Area',b);s=s.replace('function DG_Area takes',HELPER+'\nfunction DG_Area takes',1)
 return s

def object_files(v,w):
 def resolve(s):return w.get(int(s[8:]),s) if isinstance(s,str) and s.startswith('TRIGSTR_') else s
 items=merged(v.archive.read('war3map.w3t'),v.archive.read('war3mapSkin.w3t'),'w3t')
 tips={re.sub(r'\|c[0-9a-fA-F]{8}|\|r','',resolve(fields(items[raw])['unam',None])):resolve(fields(items[raw])['utub',None]) for raw in SPEARS}
 abilities=merged(v.archive.read('war3map.w3a'),v.archive.read('war3mapSkin.w3a'),'w3a')
 maxrank=fields(abilities['A11R'])['alev',0]
 files={};armory=[];proficiency=[]
 for ext in ['w3a','w3u','w3q']:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;d=v.archive.read(name)
   if not d:continue
   t=read_objects(d,ext)
   for o in t['custom']+t['original']:
    raw=o['id'] or o['base'];f=fields(o)
    for st in o['sets']:
     for mod in st['mods']:
      if isinstance(mod['value'],str):mod['value']=text(resolve(mod['value'])) if text(resolve(mod['value']))!=resolve(mod['value']) else mod['value']
    if ext=='w3a':
     if raw=='hH79':setf(o,'Oar1',.10,1,data=1);setf(o,'Oar2',1,1,data=2);setf(o,'aub1','Nearby friendly units recover 10% of their maximum health each second.',1)
     if raw=='hM79':setf(o,'Arm1',.10,1,data=1);setf(o,'Arm2',1,1,data=2);setf(o,'aub1','Nearby friendly units recover 10% of their maximum mana each second.',1)
     if raw=='A11R':
      for st in o['sets']:
       for mod in st['mods']:
        if mod['field']=='amcs' and mod['level']==maxrank:mod['value']=200
     if raw=='pF04':proficiency.append(raw)
    if ext=='w3q' and raw=='R009':proficiency.append(raw)
    if ext=='w3u':
     unitname=re.sub(r'\|c[0-9a-fA-F]{8}|\|r','',resolve(f.get(('unam',None),'')))
     if unitname in tips:setf(o,'utub',tips[unitname],None);armory.append((raw,unitname))
   files[name]=write_objects(t,t['version'],ext)
 assert set(name for _,name in armory)==set(tips),(armory,tips.keys())
 assert 'pF04' in proficiency and 'R009' in proficiency
 return files,armory,maxrank

def build():
 assert not OUT.exists()
 v=View(BASE);w=wts_read(v.archive.read('war3map.wts'));files,armory,maxrank=object_files(v,w)
 modules={lib:refresh(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};assert changed=={'TDamage','TRegen'},changed
 runtime,_=order(runtime_for(v,v,v,modules));runtime=re.sub(r'\n{3,}','\n\n',runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 label='FFERPG QuickUI81 (Dragoon)'
 for k,s in list(w.items()):w[k]=text(s)
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
 report=dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),new_functions=sorted(after.keys()-before.keys()),armory_tooltips=armory,sonic_maxrank=maxrank,formula=FACTOR,notes='House-only10%HP/MPpersecond; fountain unchanged. Drakes/Rise base damage including spear scaling multiplied by accuracy-evasion factor, clamped to zero to prevent negative damage healing. Sonic200MPmaxrank only; Jump300radius. Armoryunit+research+cappedproficiency tooltipcopies updated. No inventory/input/preview/timer changes. Dragoon-test only.')
 OUT.with_suffix('.json').write_text(json.dumps(report,indent=2));print(OUT)
if __name__=='__main__':build()
