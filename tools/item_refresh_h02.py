"""Forward only the accepted aim-only item cleanup, preserving development-specific state."""
from jtok import functions
from performance_runtime import put
def refresh(s):
 fs=functions(s)
 if 'Inventory94_ClearLocal' not in fs or 'Inventory94_ClearAim' in fs:return s
 b=fs['Inventory94_ClearLocal'];split=b.index(' if QuickGearRoot!=null then')
 aim=b[:split].replace('Inventory94_ClearLocal','Inventory94_ClearAim',1)+' set QuickGearReady=false\n set QuickGearSeenRevision=-1\nendfunction'
 full='function Inventory94_ClearLocal takes nothing returns nothing\n call Inventory94_ClearAim()\n'+b[split:]
 s=put(s,'Inventory94_ClearLocal',aim+'\n\n'+full)
 return put(s,'Inventory94_Changed',fs['Inventory94_Changed'].replace('call Inventory94_ClearLocal()','call Inventory94_ClearAim()',1))
