"""Presentation reads synchronized inventory snapshots; gameplay retains native reads."""
import re
from jtok import functions
from performance_runtime import put
GLOBALS='''    hashtable Inventory05Data=null
    boolean Inventory05ReadOnly=false
    boolean array Inventory05Dirty
    unit array Inventory05Hero
    unit array Inventory05Gaya
'''
HELPERS='''function Inventory05_Capture takes unit u returns nothing
    local integer key=GetHandleId(u)
    local integer i=0
    local integer size=0
    local item it=null
    if u==null or GetUnitTypeId(u)==0 or Inventory05Data==null or Load04_Busy() or Inventory94Paused then
        return
    endif
    set size=BlzUnitExtendedInventorySize(u)
    call SaveInteger(Inventory05Data,key,-1,size)
    loop
        exitwhen i>=6
        call SaveItemHandle(Inventory05Data,key,i,UnitItemInSlot(u,i))
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=size
        call SaveItemHandle(Inventory05Data,key,128+i,BlzUnitItemInBagSlot(u,i))
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=9
        call SaveItemHandle(Inventory05Data,key,64+i,BlzUnitItemInEquipmentSlot(u,ConvertLoadoutSlot(i)))
        set i=i+1
    endloop
endfunction
function Inventory05_Refresh takes nothing returns nothing
    local integer pid=0
    local unit hero=null
    local unit gaya=null
    if Inventory05Data==null or Load04_Busy() or Inventory94Paused then
        return
    endif
    loop
        exitwhen pid>=8
        set hero=udg_PlayerHero[pid+1]
        set gaya=udg_SpiritOfGaya[pid+1]
        if Inventory05Dirty[pid] or hero!=Inventory05Hero[pid] or gaya!=Inventory05Gaya[pid] then
            if hero!=Inventory05Hero[pid] and Inventory05Hero[pid]!=null then
                call FlushChildHashtable(Inventory05Data,GetHandleId(Inventory05Hero[pid]))
            endif
            if gaya!=Inventory05Gaya[pid] and Inventory05Gaya[pid]!=null then
                call FlushChildHashtable(Inventory05Data,GetHandleId(Inventory05Gaya[pid]))
            endif
            call Inventory05_Capture(hero)
            call Inventory05_Capture(gaya)
            set Inventory05Hero[pid]=hero
            set Inventory05Gaya[pid]=gaya
            set Inventory05Dirty[pid]=false
        endif
        set pid=pid+1
    endloop
    set hero=null
    set gaya=null
endfunction
function Inventory05_Slot takes unit u,integer slot returns item
    if Inventory05ReadOnly then
        return LoadItemHandle(Inventory05Data,GetHandleId(u),slot)
    endif
    return UnitItemInSlot(u,slot)
endfunction
function Inventory05_Bag takes unit u,integer slot returns item
    if Inventory05ReadOnly then
        if slot<0 or slot>=LoadInteger(Inventory05Data,GetHandleId(u),-1) then
            return null
        endif
        return LoadItemHandle(Inventory05Data,GetHandleId(u),128+slot)
    endif
    return BlzUnitItemInBagSlot(u,slot)
endfunction
function Inventory05_Size takes unit u returns integer
    if Inventory05ReadOnly then
        return LoadInteger(Inventory05Data,GetHandleId(u),-1)
    endif
    return BlzUnitExtendedInventorySize(u)
endfunction
function Inventory05_Equipment takes unit u,loadoutslot slot returns item
    if Inventory05ReadOnly then
        return LoadItemHandle(Inventory05Data,GetHandleId(u),64+GetHandleId(slot))
    endif
    return BlzUnitItemInEquipmentSlot(u,slot)
endfunction
'''
# These entry points only present UI/read input/send synchronized requests.
ROOTS={'UI72_Tick','Forsaken_PollPanels','Forsaken_DrawPanels','Forsaken_RenderInspection','Forsaken_RenderStats','QuickGear_Request','QuickGear_Mouse','QuickGear_Input','QuickGear_Click','GearInput_Hover','BagScreen_Click66','Forsaken_PanelClick','Forsaken_PanelAccess'}
READERS={'Forsaken_RenderInspection','BagScreen_Item67','QuickGear_Item','Forsaken_ActiveGear','Forsaken_TwoHandedWeapon'}
REPLACE={'BlzUnitExtendedInventorySize':'Inventory05_Size','BlzUnitItemInBagSlot':'Inventory05_Bag','BlzUnitItemInEquipmentSlot':'Inventory05_Equipment','UnitItemInSlot':'Inventory05_Slot'}
def refresh(s):
 if 'function Inventory05_Capture ' in s:return s
 fs=functions(s)
 for n,b in fs.items():
  t=b
  if n in READERS:
   for a,c in REPLACE.items():t=re.sub(r'\b'+a+r'\(',c+'(',t)
  if n=='Inventory94_Init':
   at=t.index('\n',t.index('function '));# init before first existing statement, following locals
   lines=t.splitlines();i=next(i for i,l in enumerate(lines) if l.lstrip().startswith('function '))+1
   while i<len(lines) and (not lines[i].strip() or lines[i].strip().startswith('local ')):i+=1
   lines[i:i]=['    if Inventory05Data==null then','        set Inventory05Data=InitHashtable()','    endif'];t='\n'.join(lines)
  if n=='Forsaken_PanelAccess':
   t=t.replace('    if Inventory94_Blocked() then','    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED then\n        call Inventory05_Capture(selected)\n    endif\n    if Inventory94_Blocked() then',1)
  if n=='Load04_Resume':
   t=t.replace('    // All clients', '    local integer pid=0\n    loop\n        exitwhen pid>=8\n        set Inventory05Dirty[pid]=true\n        set pid=pid+1\n    endloop\n    // All clients',1)
  if n=='Inventory94_Changed':t=t.replace(' set Inventory94Until[pid]=',' set Inventory05Dirty[pid]=true\n set Inventory94Until[pid]=',1)
  if n in ROOTS:
   original='Inventory05_UI_'+n
   t=t.replace('function '+n+' takes','function '+original+' takes',1)
   sig=re.search(r'function '+original+r' takes (.*?) returns (\w+)',t)
   params=sig[1];assert sig[2]=='nothing'
   args='' if params=='nothing' else ','.join(p.strip().split()[-1] for p in params.split(','))
   before='    call Inventory05_Refresh()\n' if n=='UI72_Tick' else ''
   # Selection snapshot must be shared, outside presentation-only scope.
   if n=='Forsaken_PanelAccess':
    t=t.replace('    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED then\n        call Inventory05_Capture(selected)\n    endif\n','')
    before='    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED then\n        call Inventory05_Capture(GetTriggerUnit())\n    endif\n'
   t+='\nfunction '+n+' takes '+params+' returns nothing\n    local boolean previous=Inventory05ReadOnly\n'+before+'    set Inventory05ReadOnly=true\n    call '+original+'('+args+')\n    set Inventory05ReadOnly=previous\nendfunction'
  if t!=b:s=put(s,n,t)
 return s
