"""Do not synthesize cancellation at scene entry; ignore skips outside scenes."""
from jtok import functions
from performance_runtime import put

def refresh(s):
 fs=functions(s)
 if 'Inventory94_CineEnter' in fs:
  b=fs['Inventory94_CineEnter'];assert b.count(' call ForceUICancel()')==1
  s=put(s,'Inventory94_CineEnter',b.replace(' call ForceUICancel()\n','',1))
 if 'Cine_OnSkip' in fs:
  b=fs['Cine_OnSkip'];anchor='    call StopSound('
  assert b.count(anchor)==1
  b=b.replace(anchor,'    if not bj_cineModeAlreadyIn or not udg_InCinematicMode then\n        return\n    endif\n'+anchor,1)
  s=put(s,'Cine_OnSkip',b)
 return s
