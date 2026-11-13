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
 if 'Armory_VisitHouse' in fs:
  body=fs['Armory_VisitHouse']
  new=body.replace("CreateUnit(viewer,'e01G',GetUnitX(hero),GetUnitY(hero),270.)", "CreateUnit(viewer,'e01G',GetUnitX(house),GetUnitY(house),270.)")
  new=new.replace('    set ArmoryViewOwner[visitor]=owner','    call SetUnitPosition(shop,GetUnitX(house),GetUnitY(house))\n    set ArmoryViewOwner[visitor]=owner')
  while '    call SetUnitVertexColor(shop,255,255,255,0)\n    call SetUnitVertexColor(shop,255,255,255,0)' in new:
   new=new.replace('    call SetUnitVertexColor(shop,255,255,255,0)\n    call SetUnitVertexColor(shop,255,255,255,0)','    call SetUnitVertexColor(shop,255,255,255,0)')
  source=source.replace(body,new)
 if 'Trig_Armory_Open_Actions' in fs:
  body=fs['Trig_Armory_Open_Actions']
  new=body.replace('    if(Trig_Armory_Open_NoArmoryYet())then', "    if udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==null then\n        return\n    endif\n    if(Trig_Armory_Open_NoArmoryYet())then")
  new=new.replace('GetUnitLoc(GetTriggerUnit())','GetUnitLoc(udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])')
  new=new.replace('    call SetUnitVertexColor(udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],255,255,255,0)\n','')
  needle='    call SelectUnitForPlayerSingle('
  new=new.replace(needle,'    call SetUnitPosition(udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetUnitX(udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),GetUnitY(udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))\n    call SetUnitVertexColor(udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],255,255,255,255)\n    call ShowUnit(udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)\n'+needle)
  source=source.replace(body,new)
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
 assert set(changed)=={'Armory_VisitHouse','Trig_Armory_Open_Actions'},changed
 report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,source_entries=changes,compile='PASS',unrelated_resources='byte-identical',in_game='pending; armory proxies anchored at browsed house')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':
 for name in ['experiments/Forsaken/ArmoryVisits.j','src/triggers/05 Items crafting and shops/Armory.j']:
  p=ROOT/name;s=p.read_text();p.write_text(patch(s),newline='\r\n')
 for profile in ['Forsaken','1.29.2']:
  build(ROOT/f'release/development/VersionDHotfix03/FFERPG-0.9.7.5d-Hotfix03-{profile}.w3x',ROOT/f'release/development/VersionDHotfix04/FFERPG-0.9.7.5d-Hotfix04-{profile}.w3x',f'FFERPG 0.9.7.5d Hotfix04 ({profile})',profile=='1.29.2')
 build(ROOT/'release/development/QuickUI33/FFERPG-QuickUI33-Forsaken.w3x',ROOT/'release/development/QuickUI34/FFERPG-QuickUI34-Forsaken.w3x','FFERPG QuickUI34 (Armory at houses)')
