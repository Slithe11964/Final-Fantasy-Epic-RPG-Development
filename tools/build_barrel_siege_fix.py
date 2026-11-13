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

CLASSIC=False

def patch(source):
 source=source.replace('Keg Hunter','Barrel Collector').replace('Monographs held this game:','Monographs collected this game:')
 fs=functions(source)
 if 'Chronicles_CheckInventory' in fs:
  extra='''    set i=0
    loop
        exitwhen i>=6
        call Chronicles_RecordMonograph(p,GetItemTypeId(UnitItemInSlot(udg_PlayerHouse[GetPlayerId(p)+1],i)))
        set i=i+1
    endloop
'''
  if CLASSIC:
   extra+='''    set i=0
    loop
        exitwhen i>=BACKPACK_PAGES*BACKPACK_SLOTS
        if BackpackHolder[GetPlayerId(p)*8+i/BACKPACK_SLOTS]!=null then
            call Chronicles_RecordMonograph(p,GetItemTypeId(UnitItemInSlot(BackpackHolder[GetPlayerId(p)*8+i/BACKPACK_SLOTS],ModuloInteger(i,BACKPACK_SLOTS))))
        endif
        set i=i+1
    endloop
'''
  else:
   extra+='''    set i=0
    loop
        exitwhen i>=30
        call Chronicles_RecordMonograph(p,GetItemTypeId(BlzUnitItemInBagSlot(hero,i)))
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=9
        call Chronicles_RecordMonograph(p,GetItemTypeId(BlzUnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(i))))
        set i=i+1
    endloop
'''
  old=fs['Chronicles_CheckInventory']
  body="""function Chronicles_CheckInventory takes player p returns nothing
    local integer i=0
    local unit hero=Player_GetHero(p)
    local unit spirit=udg_SpiritOfGaya[GetPlayerId(p)+1]
    if IsPlayerInForce(p,udg_TitleForce[59]) or hero==null then
        set hero=null
        set spirit=null
        return
    endif
    loop
        exitwhen i>=6
        call Chronicles_RecordMonograph(p,GetItemTypeId(UnitItemInSlot(hero,i)))
        call Chronicles_RecordMonograph(p,GetItemTypeId(UnitItemInSlot(spirit,i)))
        set i=i+1
    endloop
"""
  source=source.replace(old,body+extra+'    set hero=null\n    set spirit=null\nendfunction')
 if 'Chronicles_MonographPickup' in fs:
  body='''function Chronicles_MonographPickup takes nothing returns nothing
    local unit u=GetTriggerUnit()
    local player p=GetOwningPlayer(u)
    local integer pid=GetPlayerId(p)
    local integer page=0
    local boolean carried=false
    if pid>=0 and pid<8 then
        set carried=u==Player_GetHero(p) or u==udg_SpiritOfGaya[pid+1] or u==udg_PlayerHouse[pid+1]
'''
  if CLASSIC:
   body+='''        loop
            exitwhen page>=BACKPACK_PAGES or carried
            set carried=u==BackpackHolder[pid*8+page]
            set page=page+1
        endloop
'''
  body+='''        if carried and (UnitHasItem(u,GetManipulatedItem()) or GetTriggerEventId()==EVENT_PLAYER_UNIT_DROP_ITEM) then
            call Chronicles_RecordMonograph(p,GetItemTypeId(GetManipulatedItem()))
        endif
    endif
    set u=null
    set p=null
endfunction'''
  source=source.replace(fs['Chronicles_MonographPickup'],body)
 if 'Register_Titles_MonographPickup' in fs and 'EVENT_PLAYER_UNIT_DROP_ITEM' not in fs['Register_Titles_MonographPickup']:
  old=fs['Register_Titles_MonographPickup'];source=source.replace(old,old.replace('    call TriggerAddAction','    call TriggerRegisterAnyUnitEventBJ(gg_trg_Titles_MonographPickup,EVENT_PLAYER_UNIT_DROP_ITEM)\n    call TriggerAddAction',1))
 if 'Chronicles_Tick' in fs:
  old=fs['Chronicles_Tick'];new=old.replace('            call Chronicles_CheckInventory(owner)\n','').replace('        call Chronicles_CheckInventory(owner)\n','').replace('        if ChroniclesCachedInventory','        call Chronicles_CheckInventory(owner)\n        if ChroniclesCachedInventory',1);source=source.replace(old,new)
 # All three Kalm quests: preserve dialogue and timing while avoiding model portraits.
 fs=functions(source)
 for name,body in fs.items():
  if not name.startswith(('Trig_KalmSiege1_','Trig_KalmSiege2_','Trig_KalmSiege3_')):continue
  def say(m):
   speaker,msg,forced=m.group(1),m.group(2),m.group(3)
   if speaker=='null':return m.group(0)
   label='GetUnitName('+speaker+')'
   return 'call Text_Transmission(null,'+label+','+msg+',null,null,0,'+forced+')'
  new=re.sub(r'call Text_Say\((.+?),("[^\n]*"),(true|false)\)',say,body)
  source=source.replace(body,new)
 # Replace shared GUI loop indexes in quest spawning with local counters, including helper predicates.
 fs=functions(source);quest={n:b for n,b in fs.items() if n.startswith(('Trig_KalmSiege1_','Trig_KalmSiege2_','Trig_KalmSiege3_'))}
 loops={n for n,b in quest.items() if 'set bj_forLoopAIndex=' in b}
 indexed={n for n,b in quest.items() if 'GetForLoopIndexA()' in b and n not in loops}
 while True:
  more={n for n,b in quest.items() if n not in loops|indexed and any(h+'()' in b for h in indexed)}
  if not more:break
  indexed|=more
 for n,body in quest.items():
  new=body
  if n in indexed:new=new.replace('takes nothing returns','takes integer siegeIndex returns',1)
  if n in loops:
   new=new.replace('takes nothing returns nothing\n','takes nothing returns nothing\n    local integer siegeIndex=0\n    local integer siegeEnd=0\n',1)
   new=new.replace('bj_forLoopAIndexEnd','siegeEnd').replace('bj_forLoopAIndex','siegeIndex')
  if n in loops|indexed:
   new=new.replace('GetForLoopIndexA()','siegeIndex')
   for helper in indexed:new=new.replace(helper+'()',helper+'(siegeIndex)')
  if new!=body:source=source.replace(body,new)
 return source

def build(base,out,label,classic=False):
 assert not out.exists(),out
 global CLASSIC
 CLASSIC=classic
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
      if isinstance(m['value'],str):m['value']=m['value'].replace('Keg Hunter','Barrel Collector')
  files[name]=write_objects(table,table['version'],'w3a')
 data=archive.read('war3map.wts')
 if data:files['war3map.wts']=data.replace(b'Keg Hunter',b'Barrel Collector')
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
 assert all(n.startswith(('Trig_KalmSiege1_','Trig_KalmSiege2_','Trig_KalmSiege3_','Chronicles_','Register_Titles_MonographPickup','Trig_Titles_Init_')) for n in changed),changed
 report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=changed,source_entries=changes,compile='PASS',unrelated_resources='byte-identical',in_game='pending; all three Sieges audited and hardened, crash cause unconfirmed')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':
 CLASSIC=True
 for name in ['src/triggers/09 Player features/Titles.j','src/triggers/06 Quests and story/KalmSiege1.j','src/triggers/06 Quests and story/KalmSiege2.j','src/triggers/06 Quests and story/KalmSiege3.j','experiments/Forsaken/ChronicleCache.j']:
  p=ROOT/name;s=p.read_text();p.write_text(patch(s),newline='\r\n')
 for name in ['tools/chronicles_catalog.py','experiments/Forsaken/ui_recovery.py']:
  p=ROOT/name;s=p.read_text();p.write_text(s.replace('Keg Hunter','Barrel Collector'))
 for profile in ['Forsaken','1.29.2']:
  build(ROOT/f'release/development/VersionDHotfix04/FFERPG-0.9.7.5d-Hotfix04-{profile}.w3x',ROOT/f'release/development/VersionDHotfix05/FFERPG-0.9.7.5d-Hotfix05-{profile}.w3x',f'FFERPG 0.9.7.5d Hotfix05 ({profile})',profile=='1.29.2')
 build(ROOT/'release/development/QuickUI34/FFERPG-QuickUI34-Forsaken.w3x',ROOT/'release/development/QuickUI35/FFERPG-QuickUI35-Forsaken.w3x','FFERPG QuickUI35 (Barrel Collector / Kalm)')
