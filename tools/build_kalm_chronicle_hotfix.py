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
  addition='''    // Fresh heroes are rebuilt from job levels, not saved attribute totals.
    // Apply each owned title once after readback/commit, just as job switching does.
    set i=1
    loop
        exitwhen i>59
        if IsPlayerInForce(owner,udg_TitleForce[i]) and not udg_TitleStatsBlocked[i] and not IsUnitInGroup(Player_GetHero(owner),udg_BonusGroup[i]) then
            set udg_TempPlayer=owner
            set udg_TempInteger=i
            call ConditionalTriggerExecute(gg_trg_Title_ApplyStats)
            call GroupAddUnit(udg_BonusGroup[i],Player_GetHero(owner))
        endif
        set i=i+1
    endloop
'''
  assert 'call FFL_RestoreChronicles(pid)' in old
  source=source.replace(old,old.replace('    call FFL_RestoreChronicles(pid)',addition+'    call FFL_RestoreChronicles(pid)'))
  source=source.replace('// Title stats are not reapplied: the saved hero attributes already include them.','// Fresh hero title stats are applied once by FFL_RestoreUnlocks after commit.')
 if 'Trig_KalmSiege2_Start_Actions' in fs:
  for name in ['Trig_KalmSiege2_Start_Actions','Trig_KalmSiege2_Restart_Actions']:
   old=fs[name];new=old
   # Keep dialogue and timing; suppress model portraits in this reported crashing opening.
   new=new.replace('call Text_Say(gg_unit_Hvwd_0098,','call Text_Transmission(null,"Meliadoul",')
   new=new.replace('call Text_Say(Player_GetHero(GetTriggerPlayer()),','call Text_Transmission(null,GetPlayerName(GetTriggerPlayer()),')
   new=re.sub(r'(call Text_Transmission\(null,.*?),(false|true)\)',r'\1,null,null,0,\2)',new)
   source=source.replace(old,new)
 if 'Register_Travel_Dialog_Click' in fs:
  old=fs['Register_Travel_Dialog_Click'];new=old.replace('        set TravelDialog[pid]=DialogCreate()', '        call TriggerRegisterPlayerEvent(gg_trg_Travel_Dialog_Click,Player(pid),EVENT_PLAYER_END_CINEMATIC)\n        set TravelDialog[pid]=DialogCreate()')
  assert new!=old;source=source.replace(old,new)
  old=fs['Trig_Travel_Dialog_Click_Actions'];needle='    if clicked!=null'
  at=old.index(needle)
  new=old[:at]+'''    if GetTriggerEventId()==EVENT_PLAYER_END_CINEMATIC then
        call Travel_Hide(owner)
        set clicked=null
        set owner=null
        set hero=null
        return
    endif
'''+old[at:];source=source.replace(old,new)
 if 'Armory_VisitHouse' in fs:
  old=fs['Armory_VisitHouse'];new=old.replace('    call ShowUnit(shop,true)','    call SetUnitVertexColor(shop,255,255,255,0)\n    call ShowUnit(shop,true)')
  source=source.replace(old,new)
 if 'Trig_Armory_Open_Actions' in fs:
  old=fs['Trig_Armory_Open_Actions'];new=old.replace('    call SelectUnitForPlayerSingle(',"    call SetUnitVertexColor(udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],255,255,255,0)\n    call SelectUnitForPlayerSingle(")
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
 from objdata import read_objects,write_objects
 from priest_master import setf
 for name in ['war3map.w3a','war3mapSkin.w3a']:
  data=archive.read(name)
  if not data:continue
  table=read_objects(data,'w3a')
  for obj in table['custom']:
   if obj['id']=='A0RY':
    for rank in range(1,12):
     setf(obj,'Ndh1',0.,rank=rank,data=1);setf(obj,'Ndh2',0.,rank=rank,data=2)
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
 assert set(changed)=={'FFL_RestoreUnlocks','Trig_KalmSiege2_Start_Actions','Trig_KalmSiege2_Restart_Actions','Register_Travel_Dialog_Click','Trig_Travel_Dialog_Click_Actions','Armory_VisitHouse','Trig_Armory_Open_Actions'},changed
 report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,source_entries=changes,compile='PASS',unrelated_resources='byte-identical',in_game='pending; portrait workaround requires acceptance')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':
 for path in [ROOT/'src/triggers/12 Save system/ForsakenFreshLoad.j',ROOT/'experiments/Forsaken/Forsaken-fresh-load.j',ROOT/'src/triggers/06 Quests and story/KalmSiege2.j',ROOT/'src/triggers/08 World and travel/Travel.j',ROOT/'experiments/Forsaken/TravelPages.j',ROOT/'experiments/Forsaken/ArmoryVisits.j',ROOT/'src/triggers/05 Items crafting and shops/Armory.j']:
  s=path.read_text();p=patch(s) if path.name in ['Armory.j','ArmoryVisits.j'] else s
  if p!=s:path.write_text(p,newline='\r\n')
 for profile in ['Forsaken','1.29.2']:
  base=ROOT/f'release/0.9.7.5d/FFERPG-0.9.7.5d-{profile}.w3x'
  build(base,ROOT/f'release/development/VersionDHotfix03/FFERPG-0.9.7.5d-Hotfix03-{profile}.w3x',f'FFERPG 0.9.7.5d Hotfix03 ({profile})',profile=='1.29.2')
 build(ROOT/'release/development/QuickUI30/FFERPG-QuickUI30-Forsaken.w3x',ROOT/'release/development/QuickUI33/FFERPG-QuickUI33-Forsaken.w3x','FFERPG QuickUI33 (Kalm / Chronicles / Escape)')
