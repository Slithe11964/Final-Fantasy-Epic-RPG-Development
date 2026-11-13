"""QuickUI85: native house percentage fields, Eclipse proxy vulnerability and concise spear tooltip."""
from pathlib import Path
import re,json,hashlib,subprocess
from editor_pair import View,runtime_for
from jtok import functions,tokens
from performance_runtime import put
from order_libraries import order
from wct import text_of,raw_of,write_wct
from objdata import read_objects,write_objects
from priest_master import setf,fields
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from mpq import MPQ,write_files,compact
from build_balance82 import DETAIL
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI84/FFERPG-QuickUI84.w3x'
OUT=ROOT/'release/development/QuickUI85/FFERPG-QuickUI85.w3x'
def concise(s):return s.replace(DETAIL,'')
def refresh(s):
 fs=functions(s)
 if 'Trig_HolySwordsman_Eclipse_Actions' in fs:
  n='Trig_HolySwordsman_Eclipse_Actions';b=fs[n]
  b,count=re.subn(r"(call UnitApplyTimedLifeBJ\()2\.(,\s*'BTLF')",r"\g<1>12.\2",b)
  assert count==1
  s=put(s,n,b)
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
      if isinstance(m['value'],str):m['value']=concise(m['value'])
    if ext=='w3a':
     if raw=='hH79':setf(o,'Oar1',.1,1,data=1);setf(o,'Oar2',1,1,data=2)
     if raw=='hM79':setf(o,'Arm1',.1,1,data=1);setf(o,'Arm2',1,1,data=2)
     if raw=='A04N':
      for rank in range(1,fields(o).get(('alev',0),11)+1):setf(o,'Uim6',1,rank,data=6)
   data=write_objects(t,t['version'],ext)
   if data!=d:files[name]=data
 modules={lib:refresh(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};assert changed=={'THolySwordsman'},changed
 runtime=refresh(v.runtime)  # No new calls: preserve compiled inlining in all other functions.
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 label='FFERPG QuickUI85 (Dragoon)'
 for k,s in list(w.items()):w[k]=concise(s)
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
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),notes='House regen native DataA.10/DataB1 with corrected1/2pointers,350range unchanged,fountain untouched. Spear house10research+pF04extra perpoint sectionremoved. Eclipse A04N Uim6=1 data6 all11ranks permits proxiedhit whileImpale targetairborne; h01B lifetime2->12s avoids earlyproxyhashcleanup. Original Eclipse formula/visual/range/stun/damage route retained. Native gameplay acceptance pending; no guaranteed runtime fix claim. Dragoon test only.'),indent=2));print(OUT)
if __name__=='__main__':build()
