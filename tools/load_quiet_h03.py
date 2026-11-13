"""Isolation candidate: keep native inventory reads out of profile restoration."""
from jtok import functions
from performance_runtime import put
BUSY="""function InventoryH03_LoadBusy takes nothing returns boolean
    local integer pid=0
    loop
        exitwhen pid>=8
        if FFP_Locked[pid] or FFL_Phase[pid]==2 or FFL_Phase[pid]==3 or FFL_Phase[pid]==5 or FFL_Phase[pid]==6 then
            return true
        endif
        set pid=pid+1
    endloop
    return false
endfunction
"""
def refresh(s):
 f=functions(s)
 if 'Inventory94_Blocked' not in f:return s
 if 'InventoryH03_LoadBusy' in f:return s
 b=f['Inventory94_Blocked'];b=b.replace('    if Inventory94Paused','    if InventoryH03_LoadBusy() then\n        return true\n    endif\n    if Inventory94Paused',1) if '    if Inventory94Paused' in b else b.replace(' if Inventory94Paused',' if InventoryH03_LoadBusy() then\n return true\n endif\n if Inventory94Paused',1)
 assert 'InventoryH03_LoadBusy()' in b
 s=put(s,'Inventory94_Blocked',BUSY+'\n'+b)
 b=f['Inventory71_Reconcile'];anchor='    if hero==null or GetUnitTypeId(hero)==0 then';assert anchor in b
 b=b.replace(anchor,'    if FFP_Locked[pid] or FFL_Phase[pid]==2 or FFL_Phase[pid]==3 or FFL_Phase[pid]==5 or FFL_Phase[pid]==6 then\n        return\n    endif\n'+anchor,1);s=put(s,'Inventory71_Reconcile',b)
 return s
