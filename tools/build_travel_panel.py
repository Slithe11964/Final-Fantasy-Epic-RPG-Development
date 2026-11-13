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
 if 'Travel_Show' in fs and 'TravelPanel_Render' not in fs:
  helper=(ROOT/'experiments/Forsaken/TravelPanel.j').read_text()
  block=re.search(r'^globals\n(.*?)^endglobals',helper,re.M|re.S)[1]
  source=source.replace('globals\n','globals\n'+block,1)
  old=fs['Travel_Hide'];new=old.replace('    set TravelVisible[pid]=false','    if GetLocalPlayer()==owner then\n        call BlzFrameSetVisible(TravelPanel,false)\n    endif\n    set TravelVisible[pid]=false')
  source=source.replace(fs['Travel_Show'],'')
  source=source.replace(old,new+'\n\n'+'\n\n'.join(functions(helper).values()),1)
  old=fs['Register_Travel_Dialog_Click'];new=old.replace('    set escapeKeys=null','    call TimerStart(CreateTimer(),.5,false,function TravelPanel_Init)\n    set escapeKeys=null',1)
  assert old!=new
  source=source.replace(old,new)
 if 'QuickGear_Input' in fs and 'if TravelVisible[GetPlayerId(GetTriggerPlayer())] then' not in fs['QuickGear_Input']:
  old=fs['QuickGear_Input'];anchor='    if key==ConvertOsKeyType(QuickGearOffhandKey'
  assert anchor in old
  new=old.replace(anchor,'    if TravelVisible[GetPlayerId(GetTriggerPlayer())] then\n        return\n    endif\n'+anchor,1)
  source=source.replace(old,new)
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
 assert set(changed)=={'Travel_Show','Travel_Hide','Register_Travel_Dialog_Click','QuickGear_Input'},changed
 report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,source_entries=changes,compile='PASS',unrelated_resources='byte-identical',in_game='pending; modeless native panel replaces modal dialog')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':
 build(ROOT/'release/development/VersionEHotfix01/FFERPG-0.9.7.5e-Hotfix01-Forsaken.w3x',ROOT/'release/development/VersionEHotfix02/FFERPG-0.9.7.5e-Hotfix02-Forsaken.w3x','FFERPG 0.9.7.5e Hotfix02 (Teleporter panel)')
 build(ROOT/'release/development/QuickUI38/FFERPG-QuickUI38-Forsaken.w3x',ROOT/'release/development/QuickUI39/FFERPG-QuickUI39-Forsaken.w3x','FFERPG QuickUI39 (Teleporter panel)')
