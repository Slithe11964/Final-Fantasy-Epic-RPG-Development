"""Item maintenance cancels stale aim, without tearing down persistent UI."""
from jtok import functions
from performance_runtime import put

def refresh(source):
 fs=functions(source)
 if 'Inventory94_ClearLocal' not in fs:return source
 assert 'Inventory94_ClearAim' not in fs
 original=fs['Inventory94_ClearLocal'];split=original.index(' if QuickGearRoot!=null then')
 reset=original[:split].replace('Inventory94_ClearLocal','Inventory94_ClearAim',1)
 reset+=' set QuickGearReady=false\n set QuickGearSeenRevision=-1\nendfunction'
 full='function Inventory94_ClearLocal takes nothing returns nothing\n call Inventory94_ClearAim()\n'+original[split:]
 source=put(source,'Inventory94_ClearLocal',reset+'\n\n'+full)
 changed=fs['Inventory94_Changed'];assert changed.count('call Inventory94_ClearLocal()')==1
 source=put(source,'Inventory94_Changed',changed.replace('call Inventory94_ClearLocal()','call Inventory94_ClearAim()',1))
 # A native equipment rebind can briefly expose an otherwise closed frame.
 # Only B/native backpack clicks may establish the intent to open it.
 b=fs['Forsaken_BackpackVisible'];assert 'elseif ForsakenBackpackExplicitlyClosed then' in b
 b=b.replace('elseif ForsakenBackpackExplicitlyClosed then','elseif ForsakenBackpackExplicitlyClosed or not ForsakenBackpackWanted then',1)
 b=b.replace('        set ForsakenBackpackWanted=true','        // Opening intent comes only from the explicit backpack toggle.',1)
 source=put(source,'Forsaken_BackpackVisible',b)
 # This guard uses startup-reserved frame handles only. Keep it running even
 # during the short item-settle window; all item/stat polling stays blocked.
 b=fs['UI72_Tick'];anchor='    if Inventory94_Blocked() then';assert anchor in b
 b=b.replace(anchor,anchor+'\n        if not ForsakenBackpackWanted then\n            call Forsaken_HideInventory()\n        endif',1)
 return put(source,'UI72_Tick',b)
