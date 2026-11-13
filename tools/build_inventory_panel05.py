"""Standalone replacement test that cannot silently fall back to ASpc."""
from pathlib import Path
import hashlib,json,re
from mpq import MPQ,write_files,compact
from jtok import functions,tokens
from performance_runtime import put
from objdata import read_objects,write_objects
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from test_map_identity import info_labels
import build_asset_gallery as gallery

ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/InventoryPanel04/FFERPG-Independent-Backpack-04.w3x'
OUT=ROOT/'release/development/InventoryPanel05/FFERPG-Independent-Backpack-05.w3x'
NAME='FFERPG Backpack05'

def source_for(source):
    fs=functions(source)
    init=fs['Bag04_Init']
    start=init.index('    loop\n        exitwhen i>=45')
    end=init.index('    set Bag04Access=',start)
    slots=init[start:end].replace('exitwhen i>=45','exitwhen i>=stop',1).replace('FrameEvent(hover,','FrameEvent(Bag05Hover,')
    slot_init='''function Bag05_InitSlots takes nothing returns nothing
    local integer i=Bag05Next
    local integer stop=Bag05Next+15
    local integer slot
    local integer column
    local integer row
    local real x
    local real y
    local framehandle parent
    local framehandle tip
'''+slots+'''    set Bag05Next=i
    set parent=null
    set tip=null
endfunction
'''
    init=init[:start]+'''    set Bag05Hover=hover
    call ExecuteFunc("Bag05_InitSlots")
    call ExecuteFunc("Bag05_InitSlots")
    call ExecuteFunc("Bag05_InitSlots")
    if Bag05Next!=45 then
        return
    endif
    set Bag05Hover=null
'''+init[end:]
    init=init.replace('    call BlzFrameSetPoint(Bag04Root,FRAMEPOINT_BOTTOMRIGHT,BlzGetFrameByName("ConsoleBottomBar",0),FRAMEPOINT_TOPRIGHT,0.,.03)','    call BlzFrameSetAbsPoint(Bag04Root,FRAMEPOINT_BOTTOMRIGHT,.797,.166)')
    init=init.replace('Bag04Gear,"X"','Bag04Gear,"X 05"')
    start=init.index('    set Bag04Access=')
    end=init.index('    set i=0',start)
    init=init[:start]+'''    set Bag04Access=Bag04_Control(BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"Test Bag 05",0.,0.,.085,.026)
    call BlzFrameClearAllPoints(Bag04Access)
    call BlzFrameSetAbsPoint(Bag04Access,FRAMEPOINT_BOTTOMRIGHT,.797,.137)
    call BlzFrameSetLevel(Bag04Access,90)
'''+init[end:]
    init=re.sub(r'(?m)^        // Disable the engine.*\n        // Capacity.*\n        call UnitRemoveAbility\(InvCheckHero\[i\],\'ASpc\'\)\n        call UnitRemoveAbility\(InvCheckCourier\[i\],\'ASpc\'\)\n','',init)
    assert "'ASpc'" not in init
    source=put(source,'Bag04_Init',slot_init+'\n'+init)
    source=source.replace('endglobals','    integer Bag05Next=0\n    trigger Bag05Hover=null\n    integer Bag05Transitions=0\nendglobals',1)
    show=fs['Bag04_Show'].replace('    set Bag04Open=value','    if value!=Bag04Open then\n        set Bag05Transitions=Bag05Transitions+1\n    endif\n    set Bag04Open=value',1)
    source=put(source,'Bag04_Show',show)
    ready=fs['InvCheck_Ready'].replace('    call Bag04_Init()','    call ExecuteFunc("Bag04_Init")',1)
    source=put(source,'InvCheck_Ready',ready)
    help='''function InvCheck_Help takes player p returns nothing
    call DisplayTimedTextToPlayer(p,0.,0.,40.,"Backpack05: use Test Bag 05 above the command grid or B. Confirm X 05 and Drop held item are on the open panel. Alternate opening and closing in two player slots. -bagstate shows local open state and whether the native opener is absent.")
endfunction'''
    source=put(source,'InvCheck_Help',help)
    chat=fs['InvCheck_Chat'].replace('    if text=="-home" then','''    if text=="-bagstate" then
        if GetLocalPlayer()==p then
            call DisplayTimedTextToPlayer(p,0.,0.,30.,"Bag05 slots="+I2S(Bag05Next)+" native hero/courier="+I2S(GetUnitAbilityLevel(InvCheckHero[pid],'ASpc'))+"/"+I2S(GetUnitAbilityLevel(InvCheckCourier[pid],'ASpc'))+" transitions="+I2S(Bag05Transitions))
            if not Bag04Ready then
                call DisplayTimedTextToPlayer(p,0.,0.,30.,"Bag05 setup did not finish.")
            elseif Bag04Open then
                if BlzFrameIsVisible(Bag04Root) then
                    call DisplayTimedTextToPlayer(p,0.,0.,30.,"Bag05 open=yes visible=yes")
                else
                    call DisplayTimedTextToPlayer(p,0.,0.,30.,"Bag05 open=yes visible=no")
                endif
            else
                call DisplayTimedTextToPlayer(p,0.,0.,30.,"Bag05 open=no")
            endif
        endif
    elseif text=="-home" then''',1)
    source=put(source,'InvCheck_Chat',chat)
    main=re.sub(r'call QuestSetDescription\(info,"[^\n]*"\)', 'call QuestSetDescription(info,"Use Test Bag 05 or B. Look for X 05 and Drop held item. Alternate opening and closing in two player slots; -bagstate reports local status.")',fs['main_old'])
    source=put(source,'main_old',main)
    assert source.count('TimerStart(')==1 and 'ForceUIKey' not in source
    assert all(tokens(functions(source)[n])==tokens(fs[n]) for n in ['Bag04_Click','Bag04_Key','Bag04_Receive','Bag04_Capture'])
    return source

def build():
    assert not OUT.exists()
    m=MPQ(str(BASE));source=source_for(m.read('war3map.j').decode().replace('\r\n','\n'))
    strings=wts_read(m.read('war3map.wts'));strings[38788]=NAME;strings[4]=NAME
    files={'war3map.j':source.replace('\n','\r\n').encode(),'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(m.read('war3map.w3i'),NAME)}
    removed=set();listed=m.read('(listfile)').decode().splitlines()
    for filename in ['war3map.w3u','war3mapSkin.w3u']:
        if filename not in listed:continue
        data=read_objects(m.read(filename),'w3u');changed=False
        for obj in data['custom']+data['original']:
            if (obj['id'] or obj['base']) not in ('Zi78','zi78'):continue
            for section in obj['sets']:
                for mod in section['mods']:
                    if mod['field']=='uabi' and 'ASpc' in mod['value'].split(','):
                        mod['value']=','.join(x for x in mod['value'].split(',') if x!='ASpc')
                        removed.add(obj['id']);changed=True
        if changed:files[filename]=write_objects(data,data['version'],'w3u')
    assert removed=={'Zi78','zi78'},removed
    gallery.NAME=NAME;files.update(gallery.editor_files(source))
    OUT.parent.mkdir(parents=True,exist_ok=True)
    tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
    _,flags,players=read_header(str(BASE));raw=OUT.read_bytes();OUT.write_bytes(build_header(NAME,flags,players)+raw[raw.index(b'MPQ\x1a'):])
    checked=MPQ(str(OUT))
    for name in listed:
        if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert checked.read(name)==files.get(name,m.read(name)),name
    OUT.with_suffix('.j').write_text(source)
    OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),removed_native_opener=sorted(removed),status='Diagnostic only; native appearance and multiplayer isolation pending'),indent=2))
    print(OUT)

if __name__=='__main__':build()
