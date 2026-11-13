"""Isolate idle local gear reads; use the existing shared maintenance clock."""
from jtok import functions
from performance_runtime import put

GLOBALS='''    unit array Idle76Hero
    item array Idle76Equipment
'''
HELPERS='''function Idle76_Capture takes integer pid returns nothing
    local unit hero=Player_GetHero(Player(pid))
    set Idle76Hero[pid]=hero
    if hero!=null and GetUnitTypeId(hero)!=0 then
        set Idle76Equipment[pid*2]=BlzUnitItemInEquipmentSlot(hero,EQUIPMENT_LOADOUT_SLOT_PRIMARY)
        set Idle76Equipment[pid*2+1]=BlzUnitItemInEquipmentSlot(hero,EQUIPMENT_LOADOUT_SLOT_OFFHAND)
    else
        set Idle76Equipment[pid*2]=null
        set Idle76Equipment[pid*2+1]=null
    endif
    set hero=null
endfunction

function Idle76_Item takes unit hero,integer slot returns item
    local integer pid
    if hero==null or slot<0 or slot>1 then
        return null
    endif
    set pid=GetPlayerId(GetOwningPlayer(hero))
    if pid<0 or pid>=8 or Idle76Hero[pid]!=hero then
        return null
    endif
    return Idle76Equipment[pid*2+slot]
endfunction
'''

def refresh(source):
    fs=functions(source)
    if 'UI72_Tick' not in fs:return source
    assert 'Idle76_Capture' not in fs
    source=source.replace('endglobals',GLOBALS+'endglobals',1)
    source=source.replace('endglobals','endglobals\n'+HELPERS,1)
    # These are presentation/input callers only. The synchronized cast receiver
    # continues validating the exact live item through original QuickGear_Item.
    names=['QuickGear_Draw','QuickGear_Repaint','QuickGear_RefreshIcons','QuickGear_Request','QuickGear_SlotsChanged','BagScreen_Item67']
    found=[]
    for n,b in fs.items():
        if n in names or n.startswith('QuickGear_Repaint'):
            if 'QuickGear_Item(' in b:
                source=put(source,n,b.replace('QuickGear_Item(','Idle76_Item('));found.append(n)
    assert {'QuickGear_Draw','QuickGear_Request','QuickGear_SlotsChanged','BagScreen_Item67'}<=set(found),found
    # All clients execute these maintenance/equipment/load handlers. Never
    # populate a shared snapshot from an owner-local presentation callback.
    n='Forsaken_PrepareInventories';b=fs[n]
    b=b.replace('        call Inventory71_Reconcile(hero,i)','        call Inventory71_Reconcile(hero,i)\n        call Idle76_Capture(i)',1)
    source=put(source,n,b)
    n='QuickGear_Changed';b=fs[n]
    b=b.replace('        set QuickGearRevision[pid]=','        call Idle76_Capture(pid)\n        set QuickGearRevision[pid]=',1)
    source=put(source,n,b)
    n='QuickGear_Loaded';b=fs[n]
    b=b.replace('    if GetLocalPlayer()==Player(pid) then','    call Idle76_Capture(pid)\n    if GetLocalPlayer()==Player(pid) then',1)
    source=put(source,n,b)
    n='GearInput_Poll';b=fs[n]
    old='    if Preview75_QuickVisible() or BagMoving64 or (ForsakenLinkedBag!=null and BlzFrameIsVisible(ForsakenLinkedBag)) then'
    assert old in b
    b=b.replace(old,'    if BagMoving64 or BagLeft64 or BagRight64 or BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT) or BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_RIGHT) then',1)
    source=put(source,n,b)
    return source
