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

NATIVE_PROFILE=True

def patch(source):
 if not NATIVE_PROFILE:return source
 fs=functions(source)
 if 'Travel_Show' not in fs:return source
 if 'integer array TravelEscapeEpoch' not in source:source=source.replace('globals\n','globals\n    integer array TravelEscapeEpoch\n',1)
 if 'Travel_EscapeKey' not in fs:source=source.replace(fs['Travel_Hide'],fs['Travel_Hide']+'\n\n'+HELPERS,1)
 old=fs['Travel_Show'];new=old.replace('    set TravelEscapeEpoch[pid]=TravelEscapeEpoch[pid]+1\n','').replace('    set TravelVisible[pid]=true','    set TravelEscapeEpoch[pid]=TravelEscapeEpoch[pid]+1\n    set TravelVisible[pid]=true')
 source=source.replace(old,new)
 old=fs['Register_Travel_Dialog_Click']
 if 'escapeKeys' in old:return source
 new=old.replace('    local integer pid=0','    local integer pid=0\n    local trigger escapeKeys=CreateTrigger()\n    local trigger escapeSync=CreateTrigger()',1)
 new=new.replace('        set TravelDialog[pid]=DialogCreate()', '        call BlzTriggerRegisterPlayerKeyEvent(escapeKeys,Player(pid),OSKEY_ESCAPE,0,true)\n        call BlzTriggerRegisterPlayerSyncEvent(escapeSync,Player(pid),"FFTravelClose",false)\n        set TravelDialog[pid]=DialogCreate()')
 new=new.replace('    call TriggerAddAction(gg_trg_Travel_Dialog_Click,function Trig_Travel_Dialog_Click_Actions)','    call TriggerAddAction(gg_trg_Travel_Dialog_Click,function Trig_Travel_Dialog_Click_Actions)\n    call TriggerAddAction(escapeKeys,function Travel_EscapeKey)\n    call TriggerAddAction(escapeSync,function Travel_EscapeSync)\n    set escapeKeys=null\n    set escapeSync=null')
 source=source.replace(old,new)
 return source

HELPERS='function Travel_EscapeKey takes nothing returns nothing\n    local player owner=GetTriggerPlayer()\n    local integer pid=GetPlayerId(owner)\n    if GetLocalPlayer()==owner and pid>=0 and pid<8 and TravelVisible[pid] then\n        call BlzSendSyncData("FFTravelClose",I2S(TravelEscapeEpoch[pid]))\n    endif\n    set owner=null\nendfunction\n\nfunction Travel_EscapeSync takes nothing returns nothing\n    local player owner=GetTriggerPlayer()\n    local integer pid=GetPlayerId(owner)\n    if pid>=0 and pid<8 and TravelVisible[pid] and S2I(BlzGetTriggerSyncData())==TravelEscapeEpoch[pid] then\n        call Travel_Hide(owner)\n    endif\n    set owner=null\nendfunction'

def build(base,out,label,classic=False):
 assert not out.exists(),out
 global NATIVE_PROFILE
 NATIVE_PROFILE=not classic
 archive=MPQ(str(base));runtime=archive.read('war3map.j').decode().replace('\r\n','\n');updated=patch(runtime)
 # Classic receives only the Divine Shield object correction.
 wct=read_wct(archive.read('war3map.wct'));changes=[]
 for i,raw in enumerate(wct['entries']):
  text=text_of(raw).replace('\r\n','\n');edited=patch(text)
  if text!=edited:wct['entries'][i]=raw_of(edited.replace('\n','\r\n'));changes.append(i)
 updated,_=order(updated)
 files={'war3map.j':updated.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 from objdata import read_objects,write_objects
 from priest_master import setf
 for name in ['war3map.w3a','war3mapSkin.w3a']:
  data=archive.read(name)
  if not data:continue
  table=read_objects(data,'w3a')
  for group in ['original','custom']:
   for obj in table[group]:
    if obj['id']=='A0RY':
     for entry in obj['sets']:
      entry['mods'][:]=[m for m in entry['mods'] if m['field'] not in ('Ndh1','Ndh2')]
     for rank in range(1,12):
      setf(obj,'Nsi1',0,rank=rank,data=1)
      for field,index in [('Nsi2',2),('Nsi3',3),('Nsi4',4)]:setf(obj,field,0.,rank=rank,data=index)
  files[name]=write_objects(table,table['version'],'w3a')
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
 assert set(changed)==(set() if classic else {'Travel_Show','Register_Travel_Dialog_Click'}),changed
 report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,source_entries=changes,compile='PASS',unrelated_resources='byte-identical',in_game='pending; direct Escape key request synchronized; stale close rejected')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':
 # Native-only APIs: do not inject these handlers into the Classic source/profile.
 for name in ['experiments/Forsaken/TravelPages.j']:
  p=ROOT/name;p.write_text(patch(p.read_text()),newline='\r\n')
 for profile in ['Forsaken','1.29.2']:
  build(ROOT/f'release/0.9.7.5e/FFERPG-0.9.7.5e-{profile}.w3x',ROOT/f'release/development/VersionEHotfix01/FFERPG-0.9.7.5e-Hotfix01-{profile}.w3x',f'FFERPG 0.9.7.5e Hotfix01 ({profile})',profile=='1.29.2')
 build(ROOT/'release/development/QuickUI37/FFERPG-QuickUI37-Forsaken.w3x',ROOT/'release/development/QuickUI38/FFERPG-QuickUI38-Forsaken.w3x','FFERPG QuickUI38 (Escape / Divine Shield)')
