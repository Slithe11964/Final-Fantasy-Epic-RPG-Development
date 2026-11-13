"""First autosave at match minute20, then every10minutes; keep accepted H02 behavior."""
from jtok import functions
from performance_runtime import put
def refresh(s):
 fs=functions(s)
 if 'FFL_AutoStart' in fs:
  assert 'boolean FFL_AutoRepeating' not in s
  s=s.replace('endglobals','    boolean FFL_AutoRepeating=false\nendglobals',1)
  b=fs['FFL_AutoStart'];anchor='        call TimerStart(FFL_AutoTimer,600.,true,null)';assert anchor in b
  s=put(s,'FFL_AutoStart',b.replace(anchor,'        set FFL_AutoRepeating=false\n        call TimerStart(FFL_AutoTimer,1200.,false,null)',1))
  b=fs['FFL_AutoSchedule'];anchor='    loop\n        exitwhen pid>=8';assert anchor in b
  s=put(s,'FFL_AutoSchedule',b.replace(anchor,'    if not FFL_AutoRepeating then\n        set FFL_AutoRepeating=true\n        call TimerStart(FFL_AutoTimer,600.,true,null)\n    endif\n'+anchor,1))
 if 'Trig_Autosave_Command_Actions' in fs:
  b=fs['Trig_Autosave_Command_Actions'];assert 'Saves every 10 minutes from match start.' in b
  s=put(s,'Trig_Autosave_Command_Actions',b.replace('Saves every 10 minutes from match start.','First save at minute 20, then every 10 minutes.',1))
 return s
