"""Reconcile native inventory on actual changes rather than every timer tick."""
from jtok import functions
from performance_runtime import put

GLOBALS='''    unit array Inventory71Hero
    item array Inventory71Item
    integer array Inventory71Raw
    integer array Inventory71Size
    integer array Inventory71Level
    integer array Inventory71Dual
    integer array Inventory71Grip
'''
HELPERS='''function Inventory71_Scan takes unit hero,integer pid,boolean remember returns boolean
    local integer size=BlzUnitExtendedInventorySize(hero)
    local integer level=GetHeroLevel(hero)
    local integer dual=GetUnitAbilityLevel(hero,'A0HP')
    local integer grip=GetUnitAbilityLevel(hero,'A0GP')
    local integer slot=0
    local integer key=0
    local item carried=null
    local integer raw=0
    local boolean changed=Inventory71Hero[pid]!=hero or Inventory71Size[pid]!=size or Inventory71Level[pid]!=level or Inventory71Dual[pid]!=dual or Inventory71Grip[pid]!=grip
    if GetUnitAbilityLevel(hero,'fBag')==0 or GetUnitAbilityLevel(hero,'fGer')==0 or GetUnitAbilityLevel(hero,'ASpc')==0 then
        set changed=true
    endif
    loop
        exitwhen slot>=64
        set carried=null
        if slot<6 then
            set carried=UnitItemInSlot(hero,slot)
        elseif slot<6+size then
            set carried=BlzUnitItemInBagSlot(hero,slot-6)
        elseif slot<6+size+9 then
            set carried=BlzUnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot-6-size))
        endif
        set raw=GetItemTypeId(carried)
        set key=pid*64+slot
        if Inventory71Item[key]!=carried or Inventory71Raw[key]!=raw then
            set changed=true
        endif
        if remember then
            set Inventory71Item[key]=carried
            set Inventory71Raw[key]=raw
        endif
        set slot=slot+1
    endloop
    if remember then
        set Inventory71Hero[pid]=hero
        set Inventory71Size[pid]=size
        set Inventory71Level[pid]=level
        set Inventory71Dual[pid]=dual
        set Inventory71Grip[pid]=grip
    endif
    set carried=null
    return changed
endfunction

function Inventory71_Clear takes integer pid returns nothing
    local integer slot=0
    set Inventory71Hero[pid]=null
    loop
        exitwhen slot>=64
        set Inventory71Item[pid*64+slot]=null
        set Inventory71Raw[pid*64+slot]=0
        set slot=slot+1
    endloop
endfunction

function Inventory71_Reconcile takes unit hero,integer pid returns nothing
    if hero==null or GetUnitTypeId(hero)==0 then
        if Inventory71Hero[pid]!=null then
            call Inventory71_Clear(pid)
        endif
        return
    endif
    if Inventory71_Scan(hero,pid,false) then
        // Synchronized gameplay maintenance only after gear/job changes.
        call Forsaken_EnableHero(hero)
        // Capture final state: conversions can replace item handles themselves.
        call Inventory71_Scan(hero,pid,true)
    endif
endfunction
'''

def refresh(source):
    fs=functions(source)
    if 'Forsaken_EnableHero' not in fs:return source
    assert 'Inventory71_Scan' not in fs
    source=source.replace('endglobals',GLOBALS+'endglobals',1)
    name='Forsaken_EnableHero';body=fs[name]
    for raw in ['fBag','fGer','ASpc']:
        old=f"    call UnitAddAbility(holder,'{raw}')\n    call UnitMakeAbilityPermanent(holder,true,'{raw}')"
        assert old in body
        body=body.replace(old,f"    if GetUnitAbilityLevel(holder,'{raw}')==0 then\n"+old+"\n    endif")
    source=put(source,name,body)
    source=source.replace('function Forsaken_PrepareInventories takes',HELPERS+'\nfunction Forsaken_PrepareInventories takes',1)
    name='Forsaken_PrepareInventories';body=fs[name]
    old='''        if hero!=null and GetUnitTypeId(hero)!=0 then
            call Forsaken_EnableHero(hero)
        endif'''
    assert old in body
    source=put(source,name,body.replace(old,'        call Inventory71_Reconcile(hero,i)'))
    return source
