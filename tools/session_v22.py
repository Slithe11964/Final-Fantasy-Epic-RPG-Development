"""Bound-pane recovery and model-free gear cooldown rendering."""
import re
from jtok import functions
from performance_runtime import put
from selective_f_restore import guard

GLOBALS='''    unit Bag22Hero=null
    framehandle Bag22Gear=null
    framehandle Bag22Bag=null
    framehandle Bag22Backdrop=null
    boolean Bag22Armed=false
    real Bag22NextRestore=0.
'''

WHEEL='''function QuickGear_DrawWheel takes integer slot,boolean show,real now returns nothing
    local real remaining=RMaxBJ(0.,QuickGearEnds[slot]-now)
    local boolean visible=show and QuickGearActive[slot]
    local integer step=0
    local string suffix
    if QuickGearWheelPanel[slot]==null or QuickGearWheelImage[slot]==null then
        return
    endif
    if visible and remaining>.01 then
        set step=IMinBJ(64,IMaxBJ(1,R2I(RMinBJ(64.,64.*remaining/RMaxBJ(.01,QuickGearDuration[slot]))+.999)))
    endif
    if step!=QuickGearWheelStep[slot] then
        set QuickGearWheelStep[slot]=step
        set suffix=I2S(step)
        if step<10 then
            set suffix="0"+suffix
        endif
        // Reuse the shipped radial textures. No animated STATUSBAR/model is
        // anchored across the simple-button and normal-frame hierarchies.
        call BlzFrameSetTexture(QuickGearWheelImage[slot],"war3mapImported\\\\QuickGearWheelCD"+suffix+".tga",0,true)
    endif
    if BlzFrameIsVisible(QuickGearWheelPanel[slot])!=visible then
        call BlzFrameSetVisible(QuickGearWheelPanel[slot],visible)
    endif
endfunction'''

def refresh(source):
 fs=functions(source)
 source=source.replace('endglobals',GLOBALS+'endglobals',1)
 b=fs['Forsaken_BackpackVisible']
 b=b.replace('''    if not Forsaken_InventoryContext(hero,GetLocalPlayer()) then
''','''    if not Forsaken_InventoryContext(hero,GetLocalPlayer()) then
        set Bag22Armed=false
''',1)
 marker='''    if InventoryCinematicActive then
        set visible=false
    elseif visible then'''
 assert marker in b
 b=b.replace(marker,'''    if InventoryCinematicActive then
        set Bag22Armed=false
        set visible=false
    elseif ForsakenBackpackExplicitlyClosed and now<ForsakenInventoryBindUntil then
        // Native B/mouse closure can settle after this poll. Do not turn a
        // deliberate close back into an open request during that interval.
        set visible=false
    else
        if not visible and Bag22Armed and ForsakenBackpackWanted and not ForsakenBackpackExplicitlyClosed and Bag22Hero==hero and now>=ForsakenInventoryBindUntil and now>=Bag22NextRestore then
            // The native multiplayer bug can hide an already-bound pane.
            // Restore only this viewer's last verified live pair. Never find
            // a new context, send a key, issue an order, or rebind any item.
            set Bag22NextRestore=now+1.
            call BlzFrameSetVisible(Bag22Gear,true)
            call BlzFrameSetVisible(Bag22Bag,true)
            if Bag22Backdrop!=null then
                call BlzFrameSetVisible(Bag22Backdrop,true)
            endif
            set gear=Bag22Gear
            set bag=Bag22Bag
            set backdrop=Bag22Backdrop
            set visible=BlzFrameIsVisible(gear) and BlzFrameIsVisible(bag)
        endif
        if visible then''',1)
 marker='''        set ForsakenBackpackWanted=true
    endif'''
 assert marker in b
 b=b.replace(marker,'''        set ForsakenBackpackWanted=true
        if gear!=null and bag!=null then
            set Bag22Hero=hero
            set Bag22Gear=gear
            set Bag22Bag=bag
            set Bag22Backdrop=backdrop
            set Bag22Armed=true
        endif
        endif
    endif''',1)
 source=put(source,'Forsaken_BackpackVisible',b)
 for name in ['Forsaken_CloseBackpack','Forsaken_ResetBackpackControls']:
  b=fs[name];marker='    set ForsakenBackpackWanted=false';assert marker in b
  b=b.replace(marker,'    set Bag22Armed=false\n    set Bag22Hero=null\n    set Bag22Gear=null\n    set Bag22Bag=null\n    set Bag22Backdrop=null\n'+marker,1)
  source=put(source,name,b)
 b=fs['Forsaken_RequestBackpackToggle'];marker='    set ForsakenBackpackExplicitlyClosed=not ForsakenBackpackWanted';assert marker in b
 b=b.replace(marker,marker+'\n    if not ForsakenBackpackWanted then\n        set Bag22Armed=false\n    endif',1)
 source=put(source,'Forsaken_RequestBackpackToggle',b)
 source=put(source,'QuickGear_DrawWheel',WHEEL)
 b=fs['QuickGear_Init']
 start=b.index("        // The game's cooldown wheel model")
 end=b.index('        if QuickGearIcon',start)
 b=b[:start]+'''        // The existing simple-frame radial texture is the only cooldown
        // renderer. Keep the legacy handle empty for reset compatibility.
        set QuickGearNativeWheel[slot]=null
'''+b[end:]
 source=put(source,'QuickGear_Init',b)
 b=fs['C20_HideUI'];marker='''        if QuickGearButton[i]!=null then''';assert marker in b
 b=b.replace(marker,'''        if QuickGearNativeWheel[i]!=null then
            call BlzFrameSetVisible(QuickGearNativeWheel[i],false)
        endif
'''+marker,1)
 b=b.replace('''    set QuickGearPending=-1''','''    if GearCursorError60!=null then
        call BlzFrameSetVisible(GearCursorError60,false)
    endif
    set GearCursorErrorUntil60=0.
    set UI73ClearRequested=false
    set GearInputHoverSlot=0
    set QuickGearHeld[0]=false
    set QuickGearHeld[1]=false
    set QuickGearPending=-1''',1)
 source=put(source,'C20_HideUI',b)
 # These command/hover notifications can occur when the HUD is being hidden.
 # Stop before any initialized local hero/ability/frame getter.
 for name in ['GearInput_Hover','GearWave_CancelKey','GearWave_WaterCommand','GearWave_IceCommand','GearWave_CalculatorArm','QuickGear_RecordSpell','QuickGear_Draw','QuickGear_RepaintIcons']:
  source=put(source,name,guard(fs[name]))
 return source
