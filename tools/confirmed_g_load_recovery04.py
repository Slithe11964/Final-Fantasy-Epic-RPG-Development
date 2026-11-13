"""Restore confirmed pre-autosave g load lifecycle; isolate autosave scheduling."""
from pathlib import Path
from functools import lru_cache
from mpq import MPQ
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]
REF=ROOT/'release/0.9.7.5g/history/2026-11-05-before-autosave'
CORE=['FFL_Guard','FFL_CloseWindow','FFL_Tick','InitTrig_ForsakenFreshLoad']

@lru_cache(maxsize=2)
def reference_functions(classic):
 suffix='-1.29.2' if classic else ''
 return functions(MPQ(str(REF/('FFERPG-0.9.7.5g'+suffix+'.w3x'))).read('war3map.j').decode().replace('\r\n','\n'))

def refresh(s,classic=False):
 reference=reference_functions(classic)
 fs=functions(s)
 for n in CORE:
  if n in fs:s=put(s,n,reference[n])
 # No completion bookkeeping in the shared load/save pump.
 s=s.replace('    boolean array FFL_AutoInFlight\n','')
 if 'FFL_BeginAutosave' in fs:
  s=put(s,'FFL_BeginAutosave','''function FFL_BeginAutosave takes integer pid returns boolean
    // Use the confirmed g manual-save capture/writer path unchanged.
    return FFL_BeginSave(pid,true,true)
endfunction''')
 if 'FFL_TryAutosave' in fs:
  b=fs['FFL_TryAutosave']
  b=b.replace('    if Inventory94Paused or ', '    if not IsTriggerEnabled(udg_AutosaveTimerTrig) or Inventory94Paused or ',1) if not classic else b.replace('    if udg_InCinematicMode or ','    if not IsTriggerEnabled(udg_AutosaveTimerTrig) or udg_InCinematicMode or ',1)
  assert 'not IsTriggerEnabled(udg_AutosaveTimerTrig)' in b
  b=b.replace('            set FFL_AutoInFlight[pid]=true\n','')
  s=put(s,'FFL_TryAutosave',b)
 if 'FFL_QueueAutosave' in fs:
  b=fs['FFL_QueueAutosave'];needle='    if not FFL_AutoRetryActive then';assert needle in b
  b=b.replace(needle,'''    if FFL_AutoRetryTimer==null then
        // Called by shared timer/chat events, never an owner-local callback.
        set FFL_AutoRetryTimer=CreateTimer()
    endif
'''+needle,1);s=put(s,'FFL_QueueAutosave',b)
 if 'Save_InitCommands' in fs:
  b=fs['Save_InitCommands'];needle='    call TriggerRegisterTimerExpireEvent(udg_AutosaveTimerTrig,FFL_AutoTimer)';assert needle in b
  b=b.replace(needle,'    // Direct timer callback queues saves even while the existing load guard disables the capture gate.',1);s=put(s,'Save_InitCommands',b)
 for n in ['FFL_AutoStart','FFL_AutoSchedule']:
  if n in fs:
   b=fs[n].replace('false,null)','false,function Save_Autosave)').replace('true,null)','true,function Save_Autosave)');assert b!=fs[n];s=put(s,n,b)
 return s
