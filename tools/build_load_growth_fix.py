"""Focused hotfixes for retained 0.9.7.5d and UI30."""
from pathlib import Path
import sys,re,json,hashlib,subprocess
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mpq import MPQ,write_files,compact
from wct import read_wct,write_wct,text_of,raw_of
from jtok import functions,tokens
from order_libraries import order
from add_header import read_header,build_header
ROOT=Path(__file__).resolve().parents[1]

def patch(source):
 fs=functions(source)
 if 'FFL_RestoreUnlocks' in fs:
  old=fs['FFL_RestoreUnlocks']
  new=old.replace('    local integer mastered=0','    local integer mastered=0\n    local player previousPlayer=udg_TempPlayer\n    local integer previousTitle=udg_TempInteger',1)
  a=new.index('    // Fresh heroes are rebuilt')
  b=new.index('    call FFL_RestoreChronicles(pid)',a)
  new=new[:a]+"""    // Use the identical growth/title path as a real job switch, including NG+.
    set udg_TempPlayer=owner
    call Trig_Hero_EndlessGrowth_Actions()
    set udg_TempPlayer=previousPlayer
    set udg_TempInteger=previousTitle
"""+new[b:]
  new=new.replace('    set owner=null','    set previousPlayer=null\n    set owner=null')
  source=source.replace(old,new)
  source=source.replace('requires TForsakenSaveFreshObjects,','requires THeroEndlessGrowth, TForsakenSaveFreshObjects,',1)
 return source

def build(base,out,label,classic=False):
 assert not out.exists(),out
 archive=MPQ(str(base));runtime=archive.read('war3map.j').decode().replace('\r\n','\n');updated=patch(runtime)
 assert updated!=runtime
 wct=read_wct(archive.read('war3map.wct'));changes=[]
 for i,raw in enumerate(wct['entries']):
  text=text_of(raw).replace('\r\n','\n');edited=patch(text)
  if text!=edited:wct['entries'][i]=raw_of(edited.replace('\n','\r\n'));changes.append(i)
 updated,_=order(updated)
 files={'war3map.j':updated.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 from objdata import read_objects,write_objects
 for name in ['war3map.w3a','war3mapSkin.w3a']:
  data=archive.read(name)
  if not data:continue
  table=read_objects(data,'w3a')
  for group in ['original','custom']:
   for obj in table[group]:
    for entry in obj['sets']:
     for m in entry['mods']:
      if isinstance(m['value'],str):
       m['value']=m['value'].replace('-increases rare drops in all areas','-Increases rare drops in all areas').replace('- Increases rare drops in all areas','-Increases rare drops in all areas')
  files[name]=write_objects(table,table['version'],'w3a')
 data=archive.read('war3map.wts')
 if data:files['war3map.wts']=data.replace(b'-increases rare drops in all areas',b'-Increases rare drops in all areas').replace(b'- Increases rare drops in all areas',b'-Increases rare drops in all areas')
 out.parent.mkdir(parents=True,exist_ok=True);script=out.with_suffix('.j');script.write_text(updated)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j')
 blizzard=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(blizzard),str(script)],capture_output=True,text=True)
 print(result.stdout[-1200:],result.stderr);assert result.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));tmp.unlink()
 _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 packed=MPQ(str(out))
 for n,v in files.items():assert packed.read(n)==v,n
 for n in archive.read('(listfile)').decode().splitlines():
  if n not in files and n.lower() not in ['(listfile)','(attributes)','(signature)']:assert packed.read(n)==archive.read(n),n
 before,after=functions(runtime),functions(updated)
 changed=[n for n in before if tokens(before[n])!=tokens(after[n])]
 assert set(changed)=={'FFL_RestoreUnlocks'},changed
 report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,source_entries=changes,compile='PASS',unrelated_resources='byte-identical',in_game='pending; initial-load growth refresh matches job-switch path')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':
 for name in ['src/triggers/12 Save system/ForsakenFreshLoad.j','experiments/Forsaken/Forsaken-fresh-load.j']:
  p=ROOT/name;p.write_text(patch(p.read_text()),newline='\r\n')
 for name in ['tools/chronicles_catalog.py','experiments/Forsaken/ui_recovery.py']:
  p=ROOT/name;s=p.read_text();p.write_text(s.replace('-increases rare drops in all areas','-Increases rare drops in all areas').replace('- Increases rare drops in all areas','-Increases rare drops in all areas'))
 for profile in ['Forsaken','1.29.2']:
  build(ROOT/f'release/development/VersionDHotfix05/FFERPG-0.9.7.5d-Hotfix05-{profile}.w3x',ROOT/f'release/development/VersionDHotfix06/FFERPG-0.9.7.5d-Hotfix06-{profile}.w3x',f'FFERPG 0.9.7.5d Hotfix06 ({profile})',profile=='1.29.2')
 build(ROOT/'release/development/QuickUI35/FFERPG-QuickUI35-Forsaken.w3x',ROOT/'release/development/QuickUI36/FFERPG-QuickUI36-Forsaken.w3x','FFERPG QuickUI36 (Loaded hero growth)')
