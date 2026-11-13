"""Standalone native-storage / independent regular-frame backpack prototype."""
from pathlib import Path
import hashlib,json
from mpq import MPQ,write_files,compact
from jtok import functions,tokens
from performance_runtime import put
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
import build_asset_gallery as gallery

ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/InventoryMultiplayerCheck02/FFERPG-Inventory-Multiplayer-Check-02.w3x'
OUT=ROOT/'release/development/InventoryPanel04/FFERPG-Independent-Backpack-04.w3x'
NAME='FFERPG - Independent Backpack 04'
GLOBALS='''    framehandle Bag04Root
    framehandle Bag04Gear
    framehandle Bag04Bag
    framehandle Bag04Access
    framehandle Bag04Close
    framehandle Bag04Home
    framehandle Bag04Drop
    framehandle Bag04Talents
    framehandle Bag04Title
    framehandle array Bag04Button
    framehandle array Bag04Icon
    framehandle array Bag04Count
    framehandle array Bag04TipText
    trigger Bag04ClickTrigger
    boolean Bag04Ready=false
    boolean Bag04Open=false
    boolean Bag04Chat=false
    boolean Bag04Resume=false
    integer Bag04Held=-1
    integer Bag04HeldId=0
    integer Bag04Hover=-1
    integer array Bag04ItemId
    string array Bag04IconPath
    string array Bag04Tooltip
    string array Bag04Charges
'''

def source_for(original):
    panel=(ROOT/'experiments/InventoryPanel04/Panel.j').read_text()
    source=original.replace('endglobals',GLOBALS+'endglobals',1)
    source=source.replace('function InvCheck_Help takes',panel+'\n\nfunction InvCheck_Help takes',1)
    fs=functions(source)
    ready=fs['InvCheck_Ready'].replace('    call DestroyTimer(GetExpiredTimer())','    call DestroyTimer(GetExpiredTimer())\n    call Bag04_Init()',1)
    source=put(source,'InvCheck_Ready',ready)
    scene=fs['InvCheck_Scene'].replace('    set InvCheckScene=true','    set InvCheckScene=true\n    set Bag04Resume=Bag04Open\n    call Bag04_Show(false)\n    call BlzFrameSetVisible(Bag04Access,false)',1)
    scene=scene.replace('    set InvCheckScene=false','    set InvCheckScene=false\n    call BlzFrameSetVisible(Bag04Access,true)\n    call Bag04_Show(Bag04Resume)',1)
    source=put(source,'InvCheck_Scene',scene)
    chat=fs['InvCheck_Chat'].replace('    set p=null','    if GetLocalPlayer()==p then\n        set Bag04Chat=false\n    endif\n    set p=null')
    chat=chat.replace('        call InvCheck_Bare(pid)','        call InvCheck_Bare(pid)\n        call Bag04_Capture(pid)',1)
    chat=chat.replace('        call InvCheck_Mage(pid)','        call InvCheck_Mage(pid)\n        call Bag04_Capture(pid)',1)
    source=put(source,'InvCheck_Chat',chat)
    text='Independent backpack PROTOTYPE. B or backpack button opens; X/ESC closes. Two players should keep their bags open while the other opens/closes. Right-click an item then left/right-click a destination; use Drop held item to drop. Six quick slots are mirrored beside the bag. Native slot/equip acceptance needs testing. -scene tests hide/resume. Appearance/ownership/moving test ONLY: no RPG talents, F/G, item casting, saves or load codes. Original maps are unchanged.'
    source=put(source,'InvCheck_Help','function InvCheck_Help takes player p returns nothing\n    call DisplayTimedTextToPlayer(p,0.,0.,60.,"'+text+'")\nendfunction')
    # Fill quick slots before adding spare equipment so the native engine puts
    # overflow in its real bag. No duplicate or scripted inventory store.
    main=fs['main_old']
    marker="        call UnitAddItemById(InvCheckHero[i],'pman')"
    additions='\n'.join("        call UnitAddItemById(InvCheckHero[i],'"+raw+"')" for raw in ['phea','pman','phea','pman','f104','f220'])
    assert main.count(marker)==1
    main=main.replace(marker,marker+'\n'+additions,1)
    source=put(source,'main_old',main)
    source=source.replace('Native inventory test with mage equipment: -scene, -instant, -bare, -mage.','Independent backpack prototype: B opens; right-click item, then destination. No RPG load/casting. -scene tests hide/resume.')
    # One one-shot startup timer only; never poll UI, inventory or held keys.
    assert source.count('TimerStart(')==1
    assert 'ForceUIKey' not in source and 'BlzGetItemAbility' not in source
    old,new=functions(original),functions(source)
    changed={n for n in old if tokens(old[n])!=tokens(new[n])}
    assert changed=={'InvCheck_Ready','InvCheck_Help','InvCheck_Scene','InvCheck_Chat','main_old'},changed
    return source

def build():
    assert not OUT.exists(),'Preserve prior tests'
    base=MPQ(str(BASE));source=source_for(base.read('war3map.j').decode().replace('\r\n','\n'))
    strings=wts_read(base.read('war3map.wts'));strings[38788]=NAME;strings[38790]='Independent backpack prototype: native items/storage with custom viewer-only panel. No saves/load codes. B opens.'
    files={'war3map.j':source.replace('\n','\r\n').encode(),'war3map.wts':wts_write(strings)}
    gallery.NAME=NAME;files.update(gallery.editor_files(source))
    OUT.parent.mkdir(parents=True,exist_ok=True)
    tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
    _,flags,players=read_header(str(BASE));raw=OUT.read_bytes();OUT.write_bytes(build_header(NAME,flags,players)+raw[raw.index(b'MPQ\x1a'):])
    result=MPQ(str(OUT))
    for n,data in files.items():assert result.read(n)==data,n
    for n in ['war3map.w3u','war3map.w3a','war3map.w3t','war3mapSkin.w3a','war3mapSkin.w3t','war3map.w3i']:assert result.read(n)==base.read(n),n
    OUT.with_suffix('.j').write_text(source)
    report=dict(output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),base=str(BASE),status='Prototype only, native visual/input/multiplayer acceptance pending',layout='Native equipment positions, 6x5 bag, EscMenuBackdrop, X/Talents/Move to hero, portrait sprite; extra test quick-slot mirror/drop button',boundary='Shared snapshots on inventory events; local callbacks read cached strings/IDs and show one precreated frame tree; all item changes validated by sync receiver',limitations=['No RPG talents, F/G, item casting or save codes','Exact native portrait appearance and native extended-slot moves require in-game verification','Native storage/capacity/equipment retained; native global open controller ASpc removed on shared startup'])
    OUT.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':build()
