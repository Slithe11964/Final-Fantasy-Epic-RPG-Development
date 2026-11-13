"""Keep item aim-only refresh, restore the original h native opening observer."""
from pathlib import Path
from mpq import MPQ
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]
ORIGINAL=ROOT/'release/0.9.7.5h/history/2026-11-06-before-ui-stability/FFERPG-0.9.7.5h.w3x'
def refresh(s):
 fs=functions(s)
 if 'Forsaken_BackpackVisible' not in fs:return s
 original=functions(MPQ(str(ORIGINAL)).read('war3map.j').decode().replace('\r\n','\n'))
 for n in ['Forsaken_BackpackVisible','UI72_Tick']:s=put(s,n,original[n])
 fs=functions(s)
 # Reading another unit's inventory is confined to the read-only inspect UI.
 b=fs['Forsaken_InventoryContext'];b=b.replace('return hero!=null','return hero!=null and GetOwningPlayer(hero)==viewer and (IsUnitSelected(hero,viewer) or (udg_SpiritOfGaya[GetPlayerId(viewer)+1]!=null and IsUnitSelected(udg_SpiritOfGaya[GetPlayerId(viewer)+1],viewer)))',1)
 s=put(s,'Forsaken_InventoryContext',b)
 keep='''function Forsaken_KeepInventoryFrames takes framehandle gear,framehandle backdrop,framehandle bag returns nothing
    local integer kind=0
    local integer index=0
    local framehandle pane=null
    local framehandle keep=null
    loop
        exitwhen kind>=3
        if kind==0 then
            set keep=gear
        elseif kind==1 then
            set keep=backdrop
        else
            set keep=bag
        endif
        set index=0
        loop
            exitwhen index>=ForsakenNativeFrameCount[kind]
            set pane=ForsakenNativeFrame[kind*256+index]
            if pane!=null and pane!=keep and BlzFrameIsVisible(pane) then
                call BlzFrameSetVisible(pane,false)
            endif
            set index=index+1
        endloop
        set kind=kind+1
    endloop
    set pane=null
    set keep=null
endfunction
'''
 b=functions(s)['Forsaken_BackpackVisible']
 b=b.replace('    if InventoryCinematicActive then','    if InventoryCinematicActive or ForsakenInspectTarget!=null or not Forsaken_InventoryContext(hero,GetLocalPlayer()) then',1)
 b=b.replace('        set ForsakenInventoryHero=hero','        set ForsakenInventoryHero=hero\n        call Forsaken_KeepInventoryFrames(gear,backdrop,bag)',1)
 s=put(s,'Forsaken_BackpackVisible',keep+'\n'+b)
 # A native window can swallow B's key-up; recover only the physical key
 # latch on the existing UI tick. Never synthesize an opening key or frame.
 b=functions(s)['UI72_Tick'];b=b.replace('    if Inventory94_Blocked() then','    if ForsakenBackpackKeyHeld and not BlzIsKeyPressed(OSKEY_B) then\n        set ForsakenBackpackKeyHeld=false\n    endif\n    if Inventory94_Blocked() then',1);s=put(s,'UI72_Tick',b)
 b=fs['Forsaken_CloseBackpack'];b=b.replace('    set ForsakenBackpackWanted=false','    set ForsakenBackpackWanted=false\n    set ForsakenBackpackKeyHeld=false',1);s=put(s,'Forsaken_CloseBackpack',b)
 b=fs['Forsaken_BackpackAccess'];b=b.replace('if ForsakenLastToggleSource==3 and TimerGetElapsed(ForsakenPanelClock)-ForsakenLastToggleTime<.25 then','if ForsakenLastToggleSource==3 and TimerGetElapsed(ForsakenPanelClock)-ForsakenLastToggleTime<.25 and not BlzIsKeyPressed(OSKEY_B) then',1);s=put(s,'Forsaken_BackpackAccess',b)
 b=fs['Forsaken_RequestBackpackToggle'];b=b.replace('if now-ForsakenLastToggleTime<.25 and source!=ForsakenLastToggleSource then','if now-ForsakenLastToggleTime<.25 and source!=ForsakenLastToggleSource and not (source==1 and BlzIsKeyPressed(OSKEY_B)) then',1);s=put(s,'Forsaken_RequestBackpackToggle',b)
 b=fs['Forsaken_PanelAccess'];anchor='        if GetTriggerEventId()==EVENT_PLAYER_UNIT_SELECTED then'
 b=b.replace(anchor,anchor+'\n            if not Forsaken_InventoryContext(hero,viewer) then\n                call Forsaken_HideInventory()\n            endif',1);s=put(s,'Forsaken_PanelAccess',b)
 b=fs['Forsaken_BackpackToggleAction'];b=b.replace('if GetLocalPlayer()==viewer and not ForsakenBackpackKeyHeld and not InventoryCinematicActive then','if GetLocalPlayer()==viewer and not ForsakenBackpackKeyHeld and not InventoryCinematicActive and Forsaken_InventoryContext(hero,viewer) and ForsakenInspectTarget==null then',1);s=put(s,'Forsaken_BackpackToggleAction',b)
 b=fs['Forsaken_PanelClick'];b=b.replace('            set ForsakenInspectTarget=ForsakenSelectedTarget','            call Forsaken_CloseBackpack()\n            set ForsakenInspectTarget=ForsakenSelectedTarget',1);s=put(s,'Forsaken_PanelClick',b)
 # Tooltips must not sit on the icon being hovered, nor intercept its mouse.
 b=fs['Forsaken_CreateInspection'];b=b.replace('    set ForsakenInspectSlotName[0]','    if ForsakenInspectRoot!=null then\n        return\n    endif\n    set ForsakenInspectSlotName[0]',1)
 b=b.replace('        call BlzFrameSetAbsPoint(ForsakenInspectItemText[slot],FRAMEPOINT_TOPLEFT,.415,.40)','        call BlzFrameSetPoint(ForsakenInspectItemText[slot],FRAMEPOINT_TOPRIGHT,ForsakenInspectRoot,FRAMEPOINT_TOPLEFT,-.032,-.025)\n        call BlzFrameSetEnable(ForsakenInspectItemText[slot],false)',1)
 b=b.replace('        call BlzFrameSetLevel(tip,40)','        call BlzFrameSetLevel(tip,40)\n        call BlzFrameSetEnable(tip,false)',1);s=put(s,'Forsaken_CreateInspection',b)
 b=fs['Register_Forsaken_PanelAccess'];b=b.replace('    call Forsaken_RegisterBackpackActivity()','    if ForsakenTalentRoot!=null then\n        return\n    endif\n    call Forsaken_RegisterBackpackActivity()',1);s=put(s,'Register_Forsaken_PanelAccess',b)
 b=fs['Forsaken_RebuildPanels'];b=b.replace('    // Saved custom frame handles are stale; recreate them without touching talent choices.','    // Saved custom frame handles are stale; recreate them without touching talent choices.\n    set ForsakenTalentRoot=null\n    set ForsakenInspectRoot=null',1);s=put(s,'Forsaken_RebuildPanels',b)
 # PollPanels already refreshes inspected items only when their revision
 # changes; drawing stats must not reset 39 hovered tooltips every .5s.
 b=fs['Forsaken_DrawPanels'];b=b.replace('    if Inventory94_Blocked() then','    if Inventory94_Blocked() or (playerIndex<8 and TimerGetElapsed(NativeCDClock)<Inventory94Until[playerIndex]) then',1);b=b.replace('            call Forsaken_RenderInspection(hero)','            // Inventory tooltips refresh through PollPanels revision checks.',1);s=put(s,'Forsaken_DrawPanels',b)
 b=fs['Forsaken_PollPanels'];needle='            call Forsaken_RenderInspection(ForsakenInspectTarget)\n            set ForsakenLastInspectTarget=ForsakenInspectTarget\n            set ForsakenLastInspectInventory=CollectionInventoryRevision[GetPlayerId(GetOwningPlayer(ForsakenInspectTarget))]'
 assert needle in b
 b=b.replace(needle,'            if GetPlayerId(GetOwningPlayer(ForsakenInspectTarget))>=8 or TimerGetElapsed(NativeCDClock)>=Inventory94Until[GetPlayerId(GetOwningPlayer(ForsakenInspectTarget))] then\n'+needle+'\n            endif',1);s=put(s,'Forsaken_PollPanels',b)
 b=fs['Forsaken_RenderInspection'];b=b.replace('    if Inventory94_Blocked() then','    if Inventory94_Blocked() or (GetPlayerId(GetOwningPlayer(hero))<8 and TimerGetElapsed(NativeCDClock)<Inventory94Until[GetPlayerId(GetOwningPlayer(hero))]) then',1);s=put(s,'Forsaken_RenderInspection',b)
 # New owner checks and inspect-close calls need these pure UI helpers before
 # their callers in both playable JASS and the editor source.
 ordered=functions(s);early=[]
 for n in ['Forsaken_HideInventory','Forsaken_InventoryContext','Forsaken_CloseBackpack']:
  early.append(ordered[n]);s=s.replace(ordered[n],'',1)
 s=s.replace('function Forsaken_PanelClick takes','\n'.join(early)+'\nfunction Forsaken_PanelClick takes',1)
 return s
