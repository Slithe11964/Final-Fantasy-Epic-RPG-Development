"""Local native rendering fixture: isolate parent, anchor and layer choices."""
from pathlib import Path
import hashlib,json
from mpq import MPQ,write_files,compact
from downgrade import wts_read,wts_write
from performance_runtime import put
from jtok import functions
from add_header import read_header,build_header
from test_map_identity import info_labels
import build_asset_gallery as gallery
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/InventoryMultiplayerCheck02/FFERPG-Inventory-Multiplayer-Check-02.w3x'
OUT=ROOT/'release/development/UILayerCheck01/FFERPG-UI-Layer-Check01.w3x'
LABEL='FFERPG UI Layer01'
EXTRA=r'''function Layer_Bool takes boolean value returns string
    if value then
        return "yes"
    endif
    return "no"
endfunction
function Layer_Show takes integer mode returns nothing
    local integer i=0
    if mode<0 or mode>=7 then
        return
    endif
    set LayerMode=mode
    loop
        exitwhen i>=7
        call BlzFrameSetVisible(LayerRoot[i],i==mode)
        set i=i+1
    endloop
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,60.,"Layer "+I2S(mode)+" "+LayerName[mode]+" root="+I2S(GetHandleId(LayerRoot[mode]))+" visible="+Layer_Bool(BlzFrameIsVisible(LayerRoot[mode])) )
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,60.,"Early portrait parent: "+LayerEarlyName+". -layer 0..6; -scene.")
endfunction
function Layer_Init takes nothing returns nothing
    local integer i=0
    local integer slot
    local framehandle parent
    local framehandle control
    local framehandle art
    local framehandle text
    local framehandle model
    local framehandle origin=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
    local framehandle command=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,7)
    local multiboard board=CreateMultiboard()
    call MultiboardSetRowCount(board,1)
    call MultiboardSetColumnCount(board,1)
    call MultiboardSetTitleText(board,"")
    call MultiboardDisplay(board,true)
    set LayerBoard=BlzGetFrameByName("Multiboard",0)
    call BlzFrameSetSize(LayerBoard,0.,0.)
    set parent=BlzGetFrameByName("MultiboardBackdrop",0)
    if parent!=null then
        call BlzFrameSetVisible(parent,false)
    endif
    set LayerName[0]="GAME_UI / native command anchor"
    set LayerName[1]="Console backdrop / native command anchor"
    set LayerName[2]="Portrait parent / native command anchor"
    set LayerName[3]="GAME_UI / above-grid absolute control"
    set LayerName[4]="Portrait parent / right-side absolute"
    set LayerName[5]="Multiboard / native command anchor"
    set LayerName[6]="Original simple frame / native command anchor"
    call BlzLoadTOCFile("war3mapImported\\QuickGear.toc")
    loop
        exitwhen i>=7
        set parent=origin
        if i==1 then
            set parent=BlzGetFrameByName("ConsoleUIBackdrop",0)
        elseif i==2 or i==4 then
            set parent=BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0))
        elseif i==5 then
            set parent=LayerBoard
        endif
        if i==6 then
            set LayerRoot[i]=BlzCreateSimpleFrame("QuickGearDock",origin,5000+i)
        else
            set LayerRoot[i]=BlzCreateFrameByType("FRAME","LayerRoot",parent,"",5000+i)
        endif
        call BlzFrameSetSize(LayerRoot[i],.040,.086)
        call BlzFrameSetLevel(LayerRoot[i],120)
        if i==3 then
            call BlzFrameSetAbsPoint(LayerRoot[i],FRAMEPOINT_TOPLEFT,.748,.265)
        elseif i==4 then
            call BlzFrameSetAbsPoint(LayerRoot[i],FRAMEPOINT_TOPLEFT,.812,.085)
        else
            call BlzFrameSetPoint(LayerRoot[i],FRAMEPOINT_TOPLEFT,command,FRAMEPOINT_TOPRIGHT,.012,0.)
        endif
        set slot=0
        loop
            exitwhen slot>=2
            if i==6 then
                set control=BlzCreateSimpleFrame("QuickGearItemButton",LayerRoot[i],5100+i*2+slot)
            else
                set control=BlzCreateFrameByType("BUTTON","LayerButton",LayerRoot[i],"",5100+i*2+slot)
            endif
            call BlzFrameSetPoint(control,FRAMEPOINT_TOPLEFT,LayerRoot[i],FRAMEPOINT_TOPLEFT,0.,-I2R(slot)*.046)
            call BlzFrameSetSize(control,.040,.040)
            call BlzFrameSetLevel(control,121)
            if i==6 then
                set art=BlzGetFrameByName("QuickGearItemImage",5100+i*2+slot)
            else
                set art=BlzCreateFrameByType("BACKDROP","LayerArt",control,"",5200+i*2+slot)
                call BlzFrameSetAllPoints(art,control)
                call BlzFrameSetEnable(art,false)
            endif
            if slot==0 then
                call BlzFrameSetTexture(art,"ReplaceableTextures\\CommandButtons\\BTNStaffOfNegation.blp",0,true)
            else
                call BlzFrameSetTexture(art,"ReplaceableTextures\\CommandButtons\\BTNBookWater.blp",0,true)
            endif
            if i==6 then
                set text=BlzGetFrameByName("QuickGearItemKey",5100+i*2+slot)
            else
                set text=BlzCreateFrameByType("TEXT","LayerKey",control,"",5300+i*2+slot)
                call BlzFrameSetSize(text,.03,.014)
                call BlzFrameSetPoint(text,FRAMEPOINT_TOPLEFT,control,FRAMEPOINT_TOPLEFT,.002,-.001)
                call BlzFrameSetFont(text,"Fonts\\FRIZQT__.TTF",.010,0)
                call BlzFrameSetLevel(text,124)
                call BlzFrameSetEnable(text,false)
            endif
            if slot==0 then
                call BlzFrameSetText(text,"F")
            else
                call BlzFrameSetText(text,"G")
            endif
            set slot=slot+1
        endloop
        call BlzFrameSetVisible(LayerRoot[i],false)
        set i=i+1
    endloop
    call Layer_Show(3)
    set parent=null
    set control=null
    set art=null
    set text=null
    set model=null
    set origin=null
    set command=null
    set board=null
endfunction
'''

def build():
    assert not OUT.exists();m=MPQ(str(BASE));s=m.read('war3map.j').decode().replace('\r\n','\n')
    s=s.replace('endglobals','    framehandle array LayerRoot\n    string array LayerName\n    integer LayerMode=3\n    string LayerEarlyName=""\n    framehandle LayerBoard=null\nendglobals',1)
    s=s.replace('function InvCheck_Help takes',EXTRA+'\nfunction InvCheck_Help takes',1)
    fs=functions(s)
    b=fs['InvCheck_Chat'].replace('    if text=="-home" then','    if SubString(text,0,7)=="-layer " then\n        if GetLocalPlayer()==p then\n            call Layer_Show(S2I(SubString(text,7,StringLength(text))))\n        endif\n    elseif text=="-home" then',1)
    s=put(s,'InvCheck_Chat',b)
    b=fs['InvCheck_Ready'].replace('    set i=i+1','    set i=i+1')
    b=b.replace('    endloop','    endloop\n    call Layer_Init()',1);s=put(s,'InvCheck_Ready',b)
    b=fs['main_old'].replace('    call InitBlizzard()','    call InitBlizzard()\n    set LayerEarlyName=BlzFrameGetName(BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0)))',1);s=put(s,'main_old',b)
    b=fs['InvCheck_Scene'].replace('    set InvCheckScene=true','    set InvCheckScene=true\n    call BlzFrameSetVisible(LayerRoot[LayerMode],false)',1).replace('    set InvCheckScene=false','    set InvCheckScene=false\n    call Layer_Show(LayerMode)',1);s=put(s,'InvCheck_Scene',b)
    strings=wts_read(m.read('war3map.wts'));ref=wts_read(MPQ(str(ROOT/'release/0.9.7.5f/2026-10-30/FFERPG-0.9.7.5f.w3x')).read('war3map.wts'))
    strings[38788]=LABEL;strings[38790]=ref[38790];strings[4]=LABEL;strings[5]=ref[5]
    files={'war3map.j':s.replace('\n','\r\n').encode(),'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(m.read('war3map.w3i'),LABEL)}
    gallery.NAME=LABEL;files.update(gallery.editor_files(s))
    OUT.parent.mkdir(parents=True,exist_ok=True);tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
    _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(LABEL,flags,players)+d[d.index(b'MPQ\x1a'):]);OUT.with_suffix('.j').write_text(s);print(OUT)
if __name__=='__main__':build()
