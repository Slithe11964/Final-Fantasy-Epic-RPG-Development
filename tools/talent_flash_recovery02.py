"""Preserve talent/X presentation during item cleanup; retain cinematic teardown."""
from jtok import functions
from performance_runtime import put
FRAMES=['ForsakenTalentRoot','ForsakenTalentToggle','ForsakenBackpackClose','ForsakenLinkedBagClose']
CINEMATIC='Inventory94Paused or InventoryCinematicActive or udg_InCinematicMode'
def refresh(s):
 fs=functions(s)
 if 'Inventory94_ClearLocal' not in fs:return s
 b=fs['Inventory94_ClearLocal']
 for frame in FRAMES:
  needle=' if '+frame+'!=null then'
  assert b.count(needle)==1,frame
  b=b.replace(needle,' if ('+CINEMATIC+') and '+frame+'!=null then',1)
 needle=' set ForsakenPanelOpen=false';assert b.count(needle)==1
 b=b.replace(needle,' if '+CINEMATIC+' then\n'+needle+'\n endif',1)
 return put(s,'Inventory94_ClearLocal',b)
