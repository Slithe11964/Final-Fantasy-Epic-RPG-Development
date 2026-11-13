"""Remove selected world spawns, retaining all objects and arena entries."""
from build_highroad90 import *
BASE=ROOT/'release/development/QuickUI90/FFERPG-QuickUI90.w3x'
OUT=ROOT/'release/development/QuickUI91/FFERPG-QuickUI91.w3x'
GLOBAL_REMOVALS={'nlpd','nlpr','nmrv','nmsn','ntrh','ntrt','ndth'}
CENTRAL_REMOVALS={'ndtr','ndtb','ndtt','ndtp','ndth'}
def pool_blocks(body):
 pattern=r'(?:    )?set l_pool=CreateUnitPool\(\).*?call SaveUnitPoolHandle\(udg_SpawnDataHash,\s*([34]),\s*(\d+|\$[0-9A-Fa-f]+),\s*l_pool\)[^\n]*'
 for m in re.finditer(pattern,body,re.S):yield m,int(m[1]),int(m[2][1:],16) if m[2].startswith('$') else int(m[2])
def refresh91(s):
 fs=functions(s)
 if 'Trig_Spawn_Pools_Init_Actions' not in fs:return s
 body=fs['Trig_Spawn_Pools_Init_Actions'];new=body
 for m,daynight,zone in reversed(list(pool_blocks(body))):
  forbidden=GLOBAL_REMOVALS|(CENTRAL_REMOVALS if zone==3 else set())
  block='\n'.join(l for l in m[0].splitlines() if not any("UnitPoolAddUnitType(l_pool,'"+raw+"'" in re.sub(r'[ \t]','',l) for raw in forbidden))
  new=new[:m.start()]+block+new[m.end():]
 assert new!=body
 return put(s,'Trig_Spawn_Pools_Init_Actions',new)
def build():
 assert not OUT.exists()
 v=View(BASE);modules={lib:refresh91(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};assert changed=={'TSpawn'}
 runtime=put(v.runtime,'Trig_Spawn_Pools_Init_Actions',functions(modules['TSpawn'])['Trig_Spawn_Pools_Init_Actions'])
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 w=wts_read(v.archive.read('war3map.wts'));label='FFERPG QuickUI91 (World Pool Cleanup)';w[38788]=label
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)}
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1000:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 a=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert a.read(name)==files.get(name,v.archive.read(name)),name
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),global_removals=sorted(GLOBAL_REMOVALS),central_removals=sorted(CENTRAL_REMOVALS),arena='All objects and arena data unchanged',native_acceptance='pending'),indent=2));print(OUT)
if __name__=='__main__':build()
