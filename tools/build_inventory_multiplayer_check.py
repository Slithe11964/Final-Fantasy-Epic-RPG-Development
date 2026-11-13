"""Isolate native inventory behavior without any RPG or frame-control runtime."""
from pathlib import Path
import sys,copy,struct,json,hashlib
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mpq import MPQ,write_files,compact
from objdata import read_objects,write_objects
from priest_master import setf
from jtok import functions,tokens
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
import build_asset_gallery as gallery

ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI77/FFERPG-QuickUI77.w3x'
OUT=ROOT/'release/development/InventoryMultiplayerCheck01/FFERPG-Inventory-Multiplayer-Check-01.w3x'
NAME='FFERPG - Native Inventory Multiplayer Check 01'
SOURCE=r'''globals
    unit array InvCheckHero
    unit array InvCheckCourier
endglobals

function InvCheck_Home takes player p returns nothing
    local integer i=GetPlayerId(p)
    if i>=0 and i<8 and GetLocalPlayer()==p then
        call ClearSelection()
        call SelectUnit(InvCheckHero[i],true)
        call PanCameraToTimed(GetUnitX(InvCheckHero[i]),GetUnitY(InvCheckHero[i]),0.)
        call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,1800.,0.)
    endif
endfunction

function InvCheck_Help takes player p returns nothing
    call DisplayTimedTextToPlayer(p,0.,0.,60.,"Native inventory isolation test. Have at least two people join different player slots. Each player selects their own Inventory Tester and opens Backpack with B or its icon. Leave it open while the other player opens/closes theirs, then reverse roles. There is no RPG runtime, custom bag UI, frame control, inventory polling, F/G or preview code in this map. -home returns to your tester. Report whether another player's bag action closes yours.")
endfunction

function InvCheck_Chat takes nothing returns nothing
    if GetEventPlayerChatString()=="-home" then
        call InvCheck_Home(GetTriggerPlayer())
    else
        call InvCheck_Help(GetTriggerPlayer())
    endif
endfunction

function InvCheck_Ready takes nothing returns nothing
    local integer i=0
    call DestroyTimer(GetExpiredTimer())
    loop
        exitwhen i>=8
        call InvCheck_Home(Player(i))
        call InvCheck_Help(Player(i))
        set i=i+1
    endloop
endfunction

function main_old takes nothing returns nothing
    local integer i=0
    local real x
    local real y
    local trigger t=CreateTrigger()
    local quest info=CreateQuest()
    call InitBlizzard()
    call SetCameraBounds(-3000.,-3000.,3000.,3000.,-3000.,3000.,3000.,-3000.)
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl","Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call SetFloatGameState(GAME_STATE_TIME_OF_DAY,12.)
    call SuspendTimeOfDay(true)
    call FogEnable(false)
    call FogMaskEnable(false)
    loop
        exitwhen i>=8
        set x=-2100.+I2R(ModuloInteger(i,4))*1400.
        set y=800.-I2R(i/4)*1800.
        set InvCheckHero[i]=CreateUnit(Player(i),'Zi78',x,y,270.)
        set InvCheckCourier[i]=CreateUnit(Player(i),'zi78',x+300.,y,270.)
        call SetPlayerState(Player(i),PLAYER_STATE_RESOURCE_GOLD,100000)
        call SetPlayerState(Player(i),PLAYER_STATE_RESOURCE_LUMBER,100000)
        call UnitAddItemById(InvCheckHero[i],'phea')
        call UnitAddItemById(InvCheckHero[i],'pman')
        call UnitAddItemById(InvCheckCourier[i],'phea')
        call TriggerRegisterPlayerChatEvent(t,Player(i),"-",false)
        set i=i+1
    endloop
    call TriggerAddAction(t,function InvCheck_Chat)
    call QuestSetTitle(info,"Native inventory: two-player test")
    call QuestSetRequired(info,false)
    call QuestSetDiscovered(info,true)
    call QuestSetDescription(info,"Use different player slots. Both players select their own Inventory Tester. Player A opens Backpack and leaves it open. Player B opens/closes theirs using B or the Backpack icon. Check whether A's panel closes; reverse roles. Try the nearby Courier separately. This map uses the same fBag, fGer and ASpc object definitions as UI77 but contains no RPG triggers or custom frame/UI handling. There is one startup timer, which destroys itself after positioning the camera. No repeating callbacks run. -home returns to your tester; -help repeats instructions. This test is diagnostic, not an inventory fix.")
    call TimerStart(CreateTimer(),.5,false,function InvCheck_Ready)
    set t=null
    set info=null
endfunction

function InitTrig_AssetShowcase takes nothing returns nothing
    call main_old()
endfunction

function main takes nothing returns nothing
    call main_old()
endfunction
'''

def build():
    assert not OUT.exists(),'Preserve prior test maps'
    base=MPQ(str(BASE));fs=functions(base.read('war3map.j').decode())
    source=SOURCE+'\n\n'+'\n\n'.join(fs[n] for n in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities','config'])
    units=read_objects(base.read('war3map.w3u'),'w3u');used={o['id'] or o['base'] for o in units['custom']+units['original']}
    assert not {'Zi78','zi78'}&used
    for raw,base_raw,name in [('Zi78','Hpal','Inventory Tester'),('zi78','hfoo','Inventory Courier')]:
        o=dict(base=base_raw,id=raw,sets=[dict(flag=0,mods=[])])
        for k,v in {'unam':name,'utip':name,'utub':'Native inventory test unit.','uabi':'Avul,AInv,fBag,fGer,ASpc','uhab':'','umdl':'units\\human\\Footman\\Footman.mdl','umvs':350,'uaen':0,'uacq':0.,'uhpm':10000,'umpm':1000,'upgr':'','ufma':0,'ufoo':0,'ussc':1.,'usca':1.,'upro':'Inventory Tester','upco':1}.items():setf(o,k,v,rank=None)
        units['custom'].append(o)
    strings=wts_read(base.read('war3map.wts'));strings[38788]=NAME;strings[38790]='Two-player native inventory check. No RPG/frame/UI polling code. -help for test instructions.'
    files={'war3map.j':source.replace('\n','\r\n').encode(),'war3map.w3u':write_objects(units,units['version'],'w3u'),'war3map.wts':wts_write(strings),
        'war3map.w3e':gallery.terrain(base.read('war3map.w3e')),'war3map.wpm':base.read('war3map.wpm')[:16]+bytes(len(base.read('war3map.wpm'))-16),
        'war3map.shd':bytes(len(base.read('war3map.shd'))),'war3map.doo':base.read('war3map.doo')[:12]+struct.pack('<iii',0,0,0),'war3mapUnits.doo':base.read('war3mapUnits.doo')[:12]+struct.pack('<i',0)}
    gallery.NAME=NAME;files.update(gallery.editor_files(source))
    # No frame APIs or inventory helpers are present, including dormant ones.
    assert not any(x in source for x in ['BlzFrame','BlzGetFrame','BlzGetOriginFrame','Forsaken_','QuickGear_','GearWave_','Idle76_','BlzSendSyncData'])
    assert source.count('TimerStart(')==1 and '.5,false,function InvCheck_Ready' in source
    OUT.parent.mkdir(parents=True,exist_ok=True);tmp=OUT.with_suffix('.unpacked.w3x')
    write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
    _,flags,players=read_header(str(BASE));raw=OUT.read_bytes();OUT.write_bytes(build_header(NAME,flags,players)+raw[raw.index(b'MPQ\x1a'):])
    checked=MPQ(str(OUT))
    for n,data in files.items():assert checked.read(n)==data,n
    for n in ['war3map.w3i','war3map.w3a','war3map.w3t','war3map.imp']:assert checked.read(n)==base.read(n),n
    for n in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities','config']:assert tokens(functions(source)[n])==tokens(fs[n]),n
    OUT.with_suffix('.j').write_text(source)
    report=dict(output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),native_abilities='byte-identical to UI77',runtime='standalone; no custom frame APIs, RPG functions, inventory polling, sync requests or repeating timers',players='Up to 8; test requires at least 2 human clients',acceptance='pending; diagnostic only, not a fix')
    OUT.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':build()
