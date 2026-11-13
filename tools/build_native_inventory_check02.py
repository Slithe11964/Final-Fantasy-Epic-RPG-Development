"""Native-only backpack and mage-equipped cinematic reproduction map."""
from build_f1030_inventory_rollback import *
import build_inventory_multiplayer_check as prior
import build_asset_gallery as gallery
from priest_master import setf
BASE=ROOT/'release/development/InventoryMultiplayerCheck01/FFERPG-Inventory-Multiplayer-Check-01.w3x'
CURRENT=ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-Recovery12.w3x'
OUT=ROOT/'release/development/InventoryMultiplayerCheck02/FFERPG-Inventory-Multiplayer-Check-02.w3x'
NAME='FFERPG - Native Inventory Check 02'
HELPERS='''function InvCheck_Bare takes integer pid returns nothing
    if InvCheckWand[pid]!=null then
        call BlzUnitUnequipItem(InvCheckHero[pid],InvCheckWand[pid])
        call UnitRemoveItem(InvCheckHero[pid],InvCheckWand[pid])
        call RemoveItem(InvCheckWand[pid])
        set InvCheckWand[pid]=null
    endif
    if InvCheckBook[pid]!=null then
        call BlzUnitUnequipItem(InvCheckHero[pid],InvCheckBook[pid])
        call UnitRemoveItem(InvCheckHero[pid],InvCheckBook[pid])
        call RemoveItem(InvCheckBook[pid])
        set InvCheckBook[pid]=null
    endif
endfunction
function InvCheck_Mage takes integer pid returns nothing
    call InvCheck_Bare(pid)
    set InvCheckWand[pid]=CreateItem('f104',GetUnitX(InvCheckHero[pid]),GetUnitY(InvCheckHero[pid]))
    set InvCheckBook[pid]=CreateItem('f220',GetUnitX(InvCheckHero[pid]),GetUnitY(InvCheckHero[pid]))
    call UnitAddItem(InvCheckHero[pid],InvCheckWand[pid])
    call UnitAddItem(InvCheckHero[pid],InvCheckBook[pid])
    if not BlzUnitEquipItem(InvCheckHero[pid],InvCheckWand[pid]) then
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Wand did not equip; equip it manually using the native Backpack.")
    endif
    if not BlzUnitEquipItem(InvCheckHero[pid],InvCheckBook[pid]) then
        call DisplayTimedTextToPlayer(Player(pid),0.,0.,30.,"Book did not equip; equip it manually using the native Backpack.")
    endif
endfunction
function InvCheck_Scene takes player speaker,real fade returns nothing
    local integer i=0
    set InvCheckScene=true
    loop
        exitwhen i>=8
        call PauseUnit(InvCheckHero[i],true)
        call PauseUnit(InvCheckCourier[i],true)
        set i=i+1
    endloop
    call ClearSelection()
    call ShowInterface(false,fade)
    call EnableUserControl(false)
    call SetCinematicScene('Zi78',GetPlayerColor(speaker),"Native inventory test","Short native cutscene. No F/G frames or RPG scripts exist in this map.",3.,3.)
    call TriggerSleepAction(3.)
    call EndCinematicScene()
    call ShowInterface(true,fade)
    call EnableUserControl(true)
    set i=0
    loop
        exitwhen i>=8
        call PauseUnit(InvCheckHero[i],false)
        call PauseUnit(InvCheckCourier[i],false)
        call InvCheck_Home(Player(i))
        set i=i+1
    endloop
    set InvCheckScene=false
endfunction
'''
CHAT='''function InvCheck_Chat takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local integer pid=GetPlayerId(p)
    local string text=GetEventPlayerChatString()
    if InvCheckScene or pid<0 or pid>=8 then
        set p=null
        return
    endif
    if text=="-home" then
        call InvCheck_Home(p)
    elseif text=="-bare" then
        call InvCheck_Bare(pid)
    elseif text=="-mage" then
        call InvCheck_Mage(pid)
    elseif text=="-scene" then
        call InvCheck_Scene(p,.5)
    elseif text=="-instant" then
        call InvCheck_Scene(p,0.)
    else
        call InvCheck_Help(p)
    endif
    set p=null
endfunction'''
HELP='''function InvCheck_Help takes player p returns nothing
    call DisplayTimedTextToPlayer(p,0.,0.,60.,"Native test only: no F/G UI, inventory polling, save code or RPG scripts. Ice Wand U and Book of Depths start equipped. -scene plays a 3-second cutscene; -instant plays it without a UI fade. -bare removes your test wand/book, -mage equips fresh ones. For backpacks: two people leave their own Backpack open, then alternate B/open/close. -home returns to your tester. No save files are read or written.")
endfunction'''

def build():
 assert not OUT.exists();base=MPQ(str(BASE));current=view(str(CURRENT));oldfs=functions(base.read('war3map.j').decode())
 source=prior.SOURCE.replace('endglobals','    item array InvCheckWand\n    item array InvCheckBook\n    boolean InvCheckScene=false\nendglobals',1)
 source=source.replace('function InvCheck_Chat takes',HELPERS+'\nfunction InvCheck_Chat takes',1)
 source=put(source,'InvCheck_Chat',CHAT);source=put(source,'InvCheck_Help',HELP)
 marker="        set InvCheckHero[i]=CreateUnit(Player(i),'Zi78',x,y,270.)";assert marker in source
 source=source.replace(marker,marker+'\n        call SetHeroLevel(InvCheckHero[i],99,false)\n        call InvCheck_Mage(i)',1)
 source=source.replace('Use different player slots. Both players select their own Inventory Tester.', 'Native test with mage equipment: -scene, -instant, -bare, -mage. Use different player slots. Both players select their own Inventory Tester.')
 source=source.replace('same fBag, fGer and ASpc object definitions as UI77','same fBag, fGer, ASpc and mage-item definitions as Recovery12')
 source+='\n'+'\n'.join(oldfs[n] for n in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities','config'])
 units=read_objects(current.archive.read('war3map.w3u'),'w3u');oldunits=read_objects(base.read('war3map.w3u'),'w3u')
 for raw in ['Zi78','zi78']:
  assert not any((o['id'] or o['base'])==raw for o in units['custom']+units['original'])
  units['custom'].append(next(o for o in oldunits['custom'] if o['id']==raw))
 strings=dict(current.strings);strings[38788]=NAME;strings[38790]='Native-only inventory/cinematic isolation. Mage gear starts equipped. -scene / -instant / -bare / -mage. No save files.'
 files={'war3map.j':source.replace('\n','\r\n').encode(),'war3map.w3u':write_objects(units,units['version'],'w3u'),'war3map.wts':wts_write(strings)}
 for ext in ['w3a','w3t']:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;data=current.archive.read(name)
   if data:files[name]=data
 gallery.NAME=NAME;files.update(gallery.editor_files(source))
 assert not any(x in source for x in ['BlzFrame','BlzGetFrame','BlzGetOriginFrame','QuickGear_','Forsaken_','BlzSendSyncData','-load','-save'])
 assert source.count('TimerStart(')==1 and '.5,false,function InvCheck_Ready' in source
 assert 'call InvCheck_Scene(p,.5)' in source and 'call InvCheck_Scene(p,0.)' in source
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(source)
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));data=OUT.read_bytes();OUT.write_bytes(build_header(NAME,flags,players)+data[data.index(b'MPQ\x1a'):])
 result=MPQ(str(OUT))
 for n,data in files.items():assert result.read(n)==data,n
 OUT.with_suffix('.json').write_text(json.dumps(dict(output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),native_definition_reference=str(CURRENT),mage_items=['f104 Ice Wand U','f220 Book of Depths'],runtime='native-only; no custom frame APIs, F/G, polling, RPG functions or save files; one one-shot startup timer',acceptance='pending; diagnostic only, not a fix'),indent=2));print(OUT)
if __name__=='__main__':build()
