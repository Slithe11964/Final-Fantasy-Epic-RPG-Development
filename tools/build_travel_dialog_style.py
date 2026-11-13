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

def add_assets(files,archive):
 import struct
 imp=files.get('war3map.imp') or archive.read('war3map.imp') or struct.pack('<II',1,0)
 version,count=struct.unpack_from('<II',imp)
 extra=[]
 for asset in ['TravelDialog.fdf','TravelDialog.toc']:
  path='TravelUI\\'+asset
  files[path]=(ROOT/'experiments/Forsaken/TravelUI'/asset).read_bytes()
  if path.encode()+b'\0' not in imp[8:]:extra.append(bytes([13])+path.encode()+b'\0')
 if extra:files['war3map.imp']=struct.pack('<II',version,count+len(extra))+imp[8:]+b''.join(extra)

def patch(source):
 fs=functions(source)
 fresh=functions((ROOT/'experiments/Forsaken/TravelPanel.j').read_text())
 for name in ['TravelPanel_Render','TravelPanel_Init']:
  if name in fs:source=source.replace(fs[name],fresh[name])
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
 import struct
 assets=['TravelDialog.fdf','TravelDialog.toc']
 imp=archive.read('war3map.imp');version,count=struct.unpack_from('<II',imp)
 for asset in assets:files['TravelUI\\'+asset]=(ROOT/'experiments/Forsaken/TravelUI'/asset).read_bytes()
 files['war3map.imp']=struct.pack('<II',version,count+len(assets))+imp[8:]+b''.join(bytes([13])+('TravelUI\\'+asset).encode()+b'\0' for asset in assets)
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
 assert set(changed)=={'TravelPanel_Render','TravelPanel_Init'},changed
 report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,source_entries=changes,compile='PASS',unrelated_resources='byte-identical',in_game='pending; original dialog styling on user-confirmed Escape implementation')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':
 build(ROOT/'release/development/VersionEHotfix02/FFERPG-0.9.7.5e-Hotfix02-Forsaken.w3x',ROOT/'release/development/VersionEHotfix03/FFERPG-0.9.7.5e-Hotfix03-Forsaken.w3x','FFERPG 0.9.7.5e Hotfix03 (Original teleporter style)')
 build(ROOT/'release/development/QuickUI39/FFERPG-QuickUI39-Forsaken.w3x',ROOT/'release/development/QuickUI40/FFERPG-QuickUI40-Forsaken.w3x','FFERPG QuickUI40 (Original teleporter style)')
