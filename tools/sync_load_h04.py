"""Separate synchronized profile work from presentation and private file IO."""
import re
from jtok import functions
from performance_runtime import put

GLOBALS='''    real Load04ResumeUntil=0.
'''
HELPERS='''function Load04_Busy takes nothing returns boolean
    local integer pid=0
    loop
        exitwhen pid>=8
        if FFP_Locked[pid] or FFL_Phase[pid]==2 or FFL_Phase[pid]==3 or FFL_Phase[pid]==5 or FFL_Phase[pid]==6 then
            return true
        endif
        set pid=pid+1
    endloop
    return FST_Clock!=null and TimerGetElapsed(FST_Clock)<Load04ResumeUntil
endfunction
function Load04_Resume takes nothing returns nothing
    // All clients release the transaction together; allow native inventory state to settle.
    set Load04ResumeUntil=TimerGetElapsed(FST_Clock)+.5
endfunction
'''
DIGIT='''function Load04_ReadDigit takes string char returns integer
    local integer bucket=0
    local integer value
    // FST_Init creates this immutable table synchronously before file IO.
    // A local callback must never lazily construct a shared hashtable.
    if FSC_Characters==null or StringLength(char)!=1 then
        return -1
    endif
    if StringCase(char,false)!=char then
        set bucket=1
    endif
    set value=LoadInteger(FSC_Characters,StringHash(char),bucket)-1
    if value<0 or SubString(FSC_ALPHABET,value,value+1)!=char then
        return -1
    endif
    return value
endfunction
'''

OBSERVERS={
 'Chronicles_Tick','Chronicles_CheckInventory','Forsaken_PrepareInventories',
 'Inventory71_Reconcile','Forsaken_UpdatePanels','Forsaken_OnEquip',
 'Trig_Status_AutoCleanse_Actions','Talent_ShieldDisplayTick',
 'Armory_PollCounter','SpellCalc_Update','D7_BadgeDraw',
}

def guard(body,text):
 lines=body.splitlines();i=next(i for i,line in enumerate(lines) if line.lstrip().startswith("function "))+1
 while i<len(lines) and (not lines[i].strip() or lines[i].strip().startswith('local ')):i+=1
 return '\n'.join(lines[:i]+text.splitlines()+lines[i:])

def refresh(s):
 fs=functions(s)
 if 'Load04_Busy' in fs:return s
 if 'InventoryH03_LoadBusy' in fs:
  s=s.replace('endglobals',GLOBALS+'endglobals',1)
  b=fs['InventoryH03_LoadBusy'];s=put(s,'InventoryH03_LoadBusy','''function InventoryH03_LoadBusy takes nothing returns boolean
    return Load04_Busy()
endfunction''')
  s=s.replace('endglobals','endglobals\n'+HELPERS,1)
 for n,b in fs.items():
  t=b
  if n in OBSERVERS:t=guard(t,'    if Load04_Busy() then\n        return\n    endif')
  if n=='Trig_Passive_Bonus_Sync_Actions':
   t=guard(t,'    if Load04_Busy() then\n        // This is a one-shot timer: retry rather than silently stopping it.\n        call StartTimerBJ(udg_StatsRefreshTimer,false,1.)\n        return\n    endif')
  if n=='Trig_Status_AutoCleanse_CleanseEnum':
   # Expired heroes can remain in the deferred cleanse group after a load retires them.
   t=guard(t,'    if GetEnumUnit()==null or GetUnitTypeId(GetEnumUnit())==0 then\n        return\n    endif')
  if n=='FFL_Commit':t=t.replace('    call FFL_NotifyNewGamePlus(pid)','    call FFL_NotifyNewGamePlus(pid)\n    call Load04_Resume()',1)
  if n=='FFL_Restore':t=t.replace('        return true','        call Load04_Resume()\n        return true',1)
  if n=='Load_TypeCodeWithUIKeys':t=t.replace('            set bj_forLoopAIndex=1\n','')
  if n=='FST_LocalLegacyHash':t=t.replace('FSC_Value(letter)','Load04_ReadDigit(letter)');t=DIGIT+'\n'+t
  if n=='FST_Pump':t=t.replace('FSS_Concat(','FSS_LocalConcat(')
  if n=='FST_Write':
   at=t.index('    if (GetLocalPlayer() == Player(pid)) then');t=t[:at]+t[at:].replace('FSS_Concat(','FSS_LocalConcat(')
  if n=='Wave65_Draw':
   begin=t.index('    set focus=BlzGetMouseFocusUnit()');end=t.index('    set angle=',begin)
   t=t[:begin]+'    // Preview geometry follows cursor coordinates; it does not acquire local world-unit handles.\n'+t[end:]
  if t!=b:s=put(s,n,t)
 return s
