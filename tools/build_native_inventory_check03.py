"""Isolate native bag interference from allied/shared-vision configuration.

This is a diagnostic, not a production fix. No custom UI or recurring work.
"""
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
OUT=ROOT/'release/development/InventoryMultiplayerCheck03/FFERPG-Inventory-Multiplayer-Check-03.w3x'
NAME='FFERPG - Native Inventory Check 03'
TEAM=r'''function InvCheck_Teams takes integer mode returns nothing
    local integer a=0
    local integer b
    loop
        exitwhen a>=8
        set b=0
        loop
            exitwhen b>=8
            if a!=b then
                call SetPlayerAlliance(Player(a),Player(b),ALLIANCE_PASSIVE,mode!=2)
                call SetPlayerAlliance(Player(a),Player(b),ALLIANCE_SHARED_VISION,mode==0)
                call SetPlayerAlliance(Player(a),Player(b),ALLIANCE_SHARED_CONTROL,false)
                call SetPlayerAlliance(Player(a),Player(b),ALLIANCE_SHARED_ADVANCED_CONTROL,false)
            endif
            set b=b+1
        endloop
        set a=a+1
    endloop
    if mode==0 then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,60.,"BASELINE: allied, shared vision; original test configuration.")
    elseif mode==1 then
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,60.,"VISION OFF: still allied, no shared vision or control. Close and reopen your own bag before checking.")
    else
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,60.,"ISOLATED: not allied; no shared vision or control. Close and reopen your own bag before checking.")
    endif
endfunction'''

def source_for(original):
    source=original.replace('function InvCheck_Chat takes',TEAM+'\n\nfunction InvCheck_Chat takes',1)
    fs=functions(source)
    chat=fs['InvCheck_Chat'].replace('    if text=="-home" then', '''    if text=="-baseline" then
        call InvCheck_Teams(0)
    elseif text=="-visionoff" then
        call InvCheck_Teams(1)
    elseif text=="-isolated" then
        call InvCheck_Teams(2)
    elseif text=="-home" then''',1)
    source=put(source,'InvCheck_Chat',chat)
    helptext='Check03 starts ALLIED with shared vision OFF. Two people open their own bags simultaneously and alternate opening/closing. -baseline restores original allied/shared vision settings; -visionoff stays allied but removes shared vision; -isolated also removes alliance. After changing modes close and reopen both bags. Compare all three. -bare/-mage and -scene/-instant still available. No custom UI, polling, save code, or F/G exists.'
    source=put(source,'InvCheck_Help','function InvCheck_Help takes player p returns nothing\n    call DisplayTimedTextToPlayer(p,0.,0.,60.,"'+helptext+'")\nendfunction')
    main=fs['main_old'];assert main.count('    call InitBlizzard()')==1
    source=put(source,'main_old',main.replace('    call InitBlizzard()','    call InitBlizzard()\n    call InvCheck_Teams(1)',1))
    source=source.replace('Native inventory test with mage equipment: -scene, -instant, -bare, -mage.','Check03: -baseline / -visionoff / -isolated; compare native cross-closing. -scene / -bare / -mage.')
    old,new=functions(original),functions(source)
    assert set(new)-set(old)=={'InvCheck_Teams'}
    changed={n for n in old if tokens(old[n])!=tokens(new[n])}
    assert changed=={'InvCheck_Chat','InvCheck_Help','main_old'},changed
    assert source.count('TimerStart(')==1
    assert not any(x in source for x in ['BlzFrame','BlzGetFrame','BlzSendSyncData','ForceUIKey','Forsaken_','QuickGear_'])
    return source

def build():
    assert not OUT.exists(),'Never replace a prior test'
    base=MPQ(str(BASE));source=source_for(base.read('war3map.j').decode().replace('\r\n','\n'))
    strings=wts_read(base.read('war3map.wts'));strings[38788]=NAME;strings[38790]='Native bag test: shared vision OFF by default; -baseline / -visionoff / -isolated. No custom UI.'
    files={'war3map.j':source.replace('\n','\r\n').encode(),'war3map.wts':wts_write(strings)}
    gallery.NAME=NAME;files.update(gallery.editor_files(source))
    OUT.parent.mkdir(parents=True,exist_ok=True)
    temp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(temp),files);compact(str(temp),str(OUT))
    _,flags,players=read_header(str(BASE));raw=OUT.read_bytes();OUT.write_bytes(build_header(NAME,flags,players)+raw[raw.index(b'MPQ\x1a'):])
    result=MPQ(str(OUT))
    for n,data in files.items():assert result.read(n)==data,n
    for n in ['war3map.w3u','war3map.w3a','war3map.w3t','war3mapSkin.w3a','war3mapSkin.w3t','war3map.w3i']:assert result.read(n)==base.read(n),n
    OUT.with_suffix('.j').write_text(source)
    report=dict(output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),baseline=str(BASE),changes='Event-driven shared alliance settings only. No gameplay object, item, native bag control, custom frame, save or repeating callback changes.',status='Diagnostic only; no multiplayer result. Production and development unchanged.')
    OUT.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':build()
