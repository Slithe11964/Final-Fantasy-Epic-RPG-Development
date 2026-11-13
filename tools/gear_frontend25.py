"""F/G rendering comparison: regular frames or a completely absent dock."""
from jtok import functions
from performance_runtime import put

CONTROLS=r'''    loop
        exitwhen slot>=2
        set QuickGearButton[slot]=BlzCreateFrameByType("BUTTON","GearButton25",QuickGearRoot,"",900+slot)
        call BlzFrameSetSize(QuickGearButton[slot],.040,.040)
        call BlzFrameSetPoint(QuickGearButton[slot],FRAMEPOINT_TOPLEFT,QuickGearRoot,FRAMEPOINT_TOPLEFT,0.,-I2R(slot)*.046)
        call BlzFrameSetLevel(QuickGearButton[slot],121)
        set QuickGearIcon[slot]=BlzCreateFrameByType("BACKDROP","GearIcon25",QuickGearButton[slot],"",910+slot)
        call BlzFrameSetAllPoints(QuickGearIcon[slot],QuickGearButton[slot])
        call BlzFrameSetEnable(QuickGearIcon[slot],false)
        set QuickGearLabel[slot]=BlzCreateFrameByType("TEXT","GearKey25",QuickGearButton[slot],"",920+slot)
        call BlzFrameSetSize(QuickGearLabel[slot],.03,.014)
        call BlzFrameSetPoint(QuickGearLabel[slot],FRAMEPOINT_TOPLEFT,QuickGearButton[slot],FRAMEPOINT_TOPLEFT,.002,-.001)
        call BlzFrameSetFont(QuickGearLabel[slot],"Fonts\\FRIZQT__.TTF",.010,0)
        call BlzFrameSetTextAlignment(QuickGearLabel[slot],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_LEFT)
        call BlzFrameSetLevel(QuickGearLabel[slot],124)
        call BlzFrameSetEnable(QuickGearLabel[slot],false)
        set QuickGearShownKey[slot]=-1
        set QuickGearWheelPanel[slot]=BlzCreateFrameByType("FRAME","GearClock25",QuickGearRoot,"",940+slot)
        call BlzFrameSetAllPoints(QuickGearWheelPanel[slot],QuickGearButton[slot])
        call BlzFrameSetLevel(QuickGearWheelPanel[slot],122)
        call BlzFrameSetEnable(QuickGearWheelPanel[slot],false)
        set QuickGearWheelImage[slot]=BlzCreateFrameByType("BACKDROP","GearClockTexture25",QuickGearWheelPanel[slot],"",945+slot)
        call BlzFrameSetAllPoints(QuickGearWheelImage[slot],QuickGearWheelPanel[slot])
        call BlzFrameSetEnable(QuickGearWheelImage[slot],false)
        set QuickGearNumberImage[slot]=null
        call BlzFrameSetVisible(QuickGearWheelPanel[slot],false)
        set QuickGearWheelStep[slot]=-1
        // Preserve the original animated cooldown, now in the same regular
        // frame family and parent tree as its button and texture overlays.
        set QuickGearNativeWheel[slot]=BlzCreateFrameByType("STATUSBAR","QuickGearNativeWheel",QuickGearWheelPanel[slot],"",950+slot)
        call BlzFrameSetModel(QuickGearNativeWheel[slot],"UI\\Feedback\\Cooldown\\UI-Cooldown-Indicator.mdl",0)
        call BlzFrameSetMinMaxValue(QuickGearNativeWheel[slot],0.,1.)
        call BlzFrameSetValue(QuickGearNativeWheel[slot],1.)
        call BlzFrameSetAllPoints(QuickGearNativeWheel[slot],QuickGearButton[slot])
        call BlzFrameSetEnable(QuickGearNativeWheel[slot],false)
        call BlzFrameSetVisible(QuickGearNativeWheel[slot],false)
        if slot==0 then
            call BlzFrameSetText(QuickGearLabel[slot],QuickGear_KeyName(QuickGearWeaponKey[GetPlayerId(GetLocalPlayer())]))
        else
            call BlzFrameSetText(QuickGearLabel[slot],QuickGear_KeyName(QuickGearOffhandKey[GetPlayerId(GetLocalPlayer())]))
        endif
        call BlzFrameSetTexture(QuickGearIcon[slot],"ReplaceableTextures\\CommandButtons\\BTNBackpack.blp",0,true)
        set QuickGearLastRaw[slot]=-1
        call BlzFrameSetVisible(QuickGearButton[slot],true)
        call BlzTriggerRegisterFrameEvent(QuickGearClick,QuickGearButton[slot],FRAMEEVENT_CONTROL_CLICK)
        set slot=slot+1
    endloop
'''

def refresh(source,absent=False):
 fs=functions(source);b=fs['QuickGear_Init']
 start=b.index('    set QuickGearRoot=');end=b.index('    set QuickGearChatEdit=',start)
 if absent:b=b[:start]+'''    // Diagnostic: no F/G frame, icon, label or model is constructed.
    set QuickGearRoot=null
    set QuickGearAnchor=null
'''+b[end:]
 else:
  block=b[start:end].replace('BlzCreateSimpleFrame("QuickGearDock",origin,900)','BlzCreateFrameByType("FRAME","GearDock25",origin,"",900)')
  b=b[:start]+block+b[end:]
 start=b.index('    loop\n        exitwhen slot>=2');end=b.index('    set QuickGearUITimer=',start)
 b=b[:start]+('' if absent else CONTROLS)+b[end:]
 source=put(source,'QuickGear_Init',b)
 b=fs['QuickGear_Reset']
 old='''        if QuickGearWheelPanel[slot]!=null then
            call BlzDestroyFrame(QuickGearWheelPanel[slot])
        endif
        if QuickGearNativeWheel[slot]!=null then
            call BlzDestroyFrame(QuickGearNativeWheel[slot])
            set QuickGearNativeWheel[slot]=null
        endif
        call BlzDestroyFrame(QuickGearButton[slot])''';assert old in b
 b=b.replace(old,'''        // Child first: the model is now owned by the overlay frame.
        if QuickGearNativeWheel[slot]!=null then
            call BlzDestroyFrame(QuickGearNativeWheel[slot])
            set QuickGearNativeWheel[slot]=null
        endif
        if QuickGearWheelPanel[slot]!=null then
            call BlzDestroyFrame(QuickGearWheelPanel[slot])
        endif
        if QuickGearButton[slot]!=null then
            call BlzDestroyFrame(QuickGearButton[slot])
        endif''',1)
 b=b.replace('    call BlzDestroyFrame(QuickGearRoot)','    if QuickGearRoot!=null then\n        call BlzDestroyFrame(QuickGearRoot)\n    endif',1)
 source=put(source,'QuickGear_Reset',b)
 if absent:
  for n in ['QuickGear_Poll','QuickGear_Request']:
   header=next(l for l in fs[n].splitlines() if l.startswith('function '))
   source=put(source,n,header+'\n    // Diagnostic: no gear dock or gear-hotkey activation.\nendfunction')
 else:
  source=put(source,'QuickGear_RepaintIcons','''function QuickGear_RepaintIcons takes nothing returns nothing
    // Regular BACKDROP controls refresh their texture in place. No root
    // hide/show invalidation of a simple-string render batch is required.
endfunction''')
 return source
