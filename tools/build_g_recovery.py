"""Restore retained g byte-for-byte; roll production H layers out of development."""
from build_forest86 import *
from editor_pair import View,runtime_for,decls,put_globals
from wct import read_wct
import shutil
BASE=ROOT/'release/development/V9/FFERPG-V9.w3x'
REF=ROOT/'release/development/V2/FFERPG-V2.w3x'
OUT=ROOT/'release/development/V10/FFERPG-V10.w3x'
LIBS=['TTalents','TUnit','TPassive','TRegen','TStatus','TArmory','TEquip','TTravel','TSave','TLoad','TGame','TTitles','TAutosave','TForsakenSaveTransport','TForsakenFreshLoad']

def main():
 assert not OUT.exists()
 v=View(BASE);ref=View(REF);modules=dict(v.modules)
 for lib in LIBS:modules[lib]=ref.modules[lib]
 b=modules['TMonsterData'];old=' if Load04_Busy() then\n        return\n    endif\n';f=functions(b)['D7_BadgeDraw'];assert old in f
 modules['TMonsterData']=put(b,'D7_BadgeDraw',f.replace(old,'',1))
 rt=runtime_for(v,v,v,modules)
 reference_functions=functions(ref.runtime)
 for lib in LIBS:
  for n in functions(ref.modules[lib]):rt=put(rt,n,reference_functions[n])
 rt,_=order(rt)
 header=text_of(v.wct['header']).replace('\r\n','\n');oldheader=text_of(ref.wct['header']).replace('\r\n','\n')
 for n in functions(header):rt=put(rt,n,'')
 values=decls(rt)
 for n in decls(header).keys()-decls(oldheader).keys():values.pop(n,None)
 rt=put_globals(rt,values)
 v.wct['header']=raw_of(oldheader.replace('\n','\r\n'))
 for i,raw in enumerate(v.wct['entries']):
  s=text_of(raw).replace('\r\n','\n');match=re.match(r'\s*library (\w+)',s)
  if match and match[1] in modules and modules[match[1]]!=s:v.wct['entries'][i]=raw_of(modules[match[1]].replace('\n','\r\n'))
 for token in ['Inventory05','Load04_','Load04Resume','InventoryH03_LoadBusy','Forsaken_KeepInventoryFrames','FFL_AutoSchedule']:
  assert token not in rt,token
 fs=functions(rt);rf=functions(ref.runtime)
 for lib in LIBS:
  for n in functions(ref.modules[lib]):assert tokens(fs[n])==tokens(rf[n]),n
 files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(rt)
 result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(result.stdout[-2200:],result.stderr);assert result.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT));_,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header('FFERPG V10 - g systems recovery',flags,players)+d[d.index(b'MPQ\x1a'):])
 m=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert m.read(name)==files.get(name,v.archive.read(name)),name
 manifest=dict(base=str(BASE),systems_reference=str(REF),restored_libraries=LIBS,preserved='All V9 objects/imports, jobs, creatures, damage difficulty, status badges and arena roster. Only D7 badge loading guard removed alongside deleted H helpers.',acceptance='Recovery based on owner-reported stable g. No new gameplay fix. Actual multiplayer acceptance not claimed.',sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),new_polling_timers=0)
 OUT.with_suffix('.json').write_text(json.dumps(manifest,indent=2));print(OUT)
 recovery=ROOT/'release/development/StableGRecovery';recovery.mkdir(parents=True,exist_ok=True)
 for suffix in ['', '-1.29.2']:
  src=ROOT/'release/0.9.7.5g'/('FFERPG-0.9.7.5g'+suffix+'.w3x');dst=recovery/('FFERPG-0.9.7.5g'+suffix+'-StableRollback.w3x');shutil.copy2(src,dst) if not dst.exists() else None;assert dst.read_bytes()==src.read_bytes();print(dst,hashlib.sha256(dst.read_bytes()).hexdigest())
if __name__=='__main__':main()
