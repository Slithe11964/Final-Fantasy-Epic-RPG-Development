"""Recovery10 baseline: suspend existing background work and native gear art."""
from jtok import functions
from performance_runtime import put
from selective_f_restore import guard

TRIGGERS=['QuickGearClick','QuickGearKeys','QuickGearMouse','QuickGearSync','QuickGearChat','QuickGearBindings','QuickGearChanges','QuickGearSpellObserver','QuickGearDiagnostics','GearInputHover','GearWaveKeys','GearWaveCommands','GearWaveIceCommands','GearWaveCalculator','ForsakenBackpackToggleEvents','ForsakenBackpackEvents','ForsakenBackpackCloseEvents','ForsakenBackpackChatEvents','ForsakenBackpackDebugEvents','gg_trg_Forsaken_PanelAccess','gg_trg_Forsaken_TalentClick','gg_trg_Forsaken_TalentSync']
UI_GLOBALS='''    trigger array C23Control
    boolean array C23ControlResume
    boolean array C23ButtonEnabled
    timer array C23DropTimer
    integer C23DropCount=0
'''
UI_PAUSE='''function C23_PauseControls takes nothing returns nothing
    local integer i=0
'''+''.join('    set C23Control[%d]=%s\n'%(i,t) for i,t in enumerate(TRIGGERS))+'''    loop
        exitwhen i>=22
        set C23ControlResume[i]=C23Control[i]!=null and IsTriggerEnabled(C23Control[i])
        if C23ControlResume[i] then
            call DisableTrigger(C23Control[i])
        endif
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=2
        set C23ButtonEnabled[i]=QuickGearButton[i]!=null and BlzFrameGetEnable(QuickGearButton[i])
        if QuickGearButton[i]!=null then
            call BlzFrameSetEnable(QuickGearButton[i],false)
        endif
        set i=i+1
    endloop
endfunction
function C23_ResumeControls takes nothing returns nothing
    local integer i=0
    loop
        exitwhen i>=22
        if C23ControlResume[i] and C23Control[i]!=null then
            call EnableTrigger(C23Control[i])
        endif
        set C23ControlResume[i]=false
        set C23Control[i]=null
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=2
        if QuickGearButton[i]!=null then
            call BlzFrameSetEnable(QuickGearButton[i],C23ButtonEnabled[i])
        endif
        set QuickGearHeld[i]=false
        set i=i+1
    endloop
    set ForsakenBackpackKeyHeld=false
    set i=0
    loop
        exitwhen i>=C23DropCount
        call TimerStart(C23DropTimer[i],0.,false,function Forsaken_CarryDrop)
        set C23DropTimer[i]=null
        set i=i+1
    endloop
    set C23DropCount=0
    call ExecuteFunc("C23_ResumeRebuild")
endfunction
function C23_HidePreviewImages takes nothing returns nothing
    local integer i=1
    loop
        exitwhen i>QuickGearPreviewCount
        if QuickGearPreviewImage[i]!=null then
            call ShowImage(QuickGearPreviewImage[i],false)
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>64
        if GearWaveRune[i]!=null then
            call ShowImage(GearWaveRune[i],false)
        endif
        set i=i+1
    endloop
    call Wave65_Clear()
    set GearWaveMode=0
    set Preview75Caster=null
    set GearInputTarget=false
    set GearCursorWasShown60=false
    set GearInputHoverSlot=0
    set UI73ClearRequested=false
    set QuickGearPending=-1
    set QuickGearPreview=0
    if GearCursorError60!=null then
        call BlzFrameSetVisible(GearCursorError60,false)
    endif
    set GearCursorErrorUntil60=0.
endfunction
'''

def timer_helpers(prefix,timer):
 return f'''function {prefix}_Pause takes nothing returns nothing
    set {prefix}Running={timer}!=null and TimerGetRemaining({timer})>0.
    if {prefix}Running then
        call PauseTimer({timer})
    endif
endfunction
function {prefix}_Resume takes nothing returns nothing
    if {prefix}Running and {timer}!=null then
        call ResumeTimer({timer})
    endif
    set {prefix}Running=false
endfunction
'''

def refresh(lib,s,classic=False):
 fs=functions(s)
 if lib=='TCine':
  s=s.replace('endglobals','    boolean C23StatsDirty=false\nendglobals',1)
  b=fs['Cine_Enter'];marker='    call ExecuteFunc("C20_CooldownPause")';assert marker in b
  b=b.replace(marker,marker+'\n    call ExecuteFunc("C23Chronicles_Pause")\n    call ExecuteFunc("C23Shield_Pause")',1);s=put(s,'Cine_Enter',b)
  b=fs['Cine_Exit'];marker='    call ExecuteFunc("C20_CooldownResume")';assert marker in b
  b=b.replace(marker,marker+'\n    call ExecuteFunc("C23Chronicles_Resume")\n    call ExecuteFunc("C23Shield_Resume")',1)
  old='''    if C20StatsPaused then
        call ResumeTimer(udg_StatsRefreshTimer)
    endif''';assert old in b
  b=b.replace(old,'''    if C23StatsDirty then
        call StartTimerBJ(udg_StatsRefreshTimer,false,.01)
    elseif C20StatsPaused then
        call ResumeTimer(udg_StatsRefreshTimer)
    endif
    set C23StatsDirty=false''',1);s=put(s,'Cine_Exit',b)
 if lib=='TPassive':
  b=fs['Trig_Passive_Bonus_Sync_Actions']
  old='''    call StartTimerBJ(udg_StatsRefreshTimer,false,2.)
    if udg_InCinematicMode or InventoryCinematicActive then
        return
    endif''';assert old in b
  b=b.replace(old,'''    if udg_InCinematicMode or InventoryCinematicActive then
        set C23StatsDirty=true
        return
    endif
    call StartTimerBJ(udg_StatsRefreshTimer,false,2.)''',1)
  s=put(s,'Trig_Passive_Bonus_Sync_Actions',b)
 if lib=='TStats':
  b=fs['Trig_Stats_RefreshOnEvent_Actions'];marker='    call StartTimerBJ(udg_StatsRefreshTimer,false,.01)';assert marker in b
  b=b.replace(marker,'''    if udg_InCinematicMode or InventoryCinematicActive then
        set C23StatsDirty=true
        return
    endif
'''+marker,1);s=put(s,'Trig_Stats_RefreshOnEvent_Actions',b)
 if lib=='TTitles':
  s=s.replace('endglobals','    timer C23ChroniclesTimer=null\n    boolean C23ChroniclesRunning=false\nendglobals',1)
  b=fs['Chronicles_Init'];marker='    call TimerStart(CreateTimer(),1.,true,function Chronicles_Tick)';assert marker in b
  b=b.replace(marker,'    set C23ChroniclesTimer=CreateTimer()\n    call TimerStart(C23ChroniclesTimer,1.,true,function Chronicles_Tick)',1)
  s=put(s,'Chronicles_Init',b)
  s=s.replace('endlibrary',timer_helpers('C23Chronicles','C23ChroniclesTimer')+'\nendlibrary',1)
 if lib=='TTalents':
  s=s.replace('endglobals','    boolean C23ShieldRunning=false\nendglobals',1)
  s=s.replace('endlibrary',timer_helpers('C23Shield','TalentShieldDisplayTimer')+'\nendlibrary',1)
 if lib=='TForsakenUIRecovery' and not classic:
  if 'endglobals' in s:s=s.replace('endglobals','    timer C23RebuildTimer=null\nendglobals',1)
  else:s=s.replace('\nfunction ','\nglobals\n    timer C23RebuildTimer=null\nendglobals\n\nfunction ',1)
  b=guard(fs['ForsakenUI_Rebuild'])
  b=b.replace('''        return
    endif''','''        set C23RebuildTimer=GetExpiredTimer()
        return
    endif''',1);s=put(s,'ForsakenUI_Rebuild',b)
  s=s.replace('endlibrary','''function C23_ResumeRebuild takes nothing returns nothing
    if C23RebuildTimer!=null then
        call TimerStart(C23RebuildTimer,0.,false,function ForsakenUI_Rebuild)
        set C23RebuildTimer=null
    endif
endfunction
endlibrary''',1)
 if lib=='TEquip' and not classic:
  s=s.replace('endglobals',UI_GLOBALS+'endglobals',1)
  s=s.replace('function C20_HideUI takes',UI_PAUSE+'\nfunction C20_HideUI takes',1)
  b=fs['C20_UIPause'];marker='    call C20_HideUI()';assert marker in b
  s=put(s,'C20_UIPause',b.replace(marker,'    call C23_PauseControls()\n'+marker,1))
  b=fs['C20_UIResume'];marker='    set C20UIPaused=false';assert marker in b
  s=put(s,'C20_UIResume',b.replace(marker,marker+'\n    call C23_ResumeControls()',1))
  b=fs['C20_HideUI'];marker='''        if QuickGearButton[i]!=null then''';assert marker in b
  b=b.replace(marker,'''        // These model widgets are parented outside the simple gear root.
        if QuickGearNativeWheel[i]!=null then
            call BlzFrameSetVisible(QuickGearNativeWheel[i],false)
        endif
'''+marker,1)
  marker='    call QuickGear_ClearPreview()';assert marker in b
  b=b.replace(marker,marker+'\n    call C23_HidePreviewImages()',1);s=put(s,'C20_HideUI',b)
  # Existing one-shot callbacks retain their work, without inventory getters
  # during cinematics. Their original timers are restarted after Cine_Exit.
  b=guard(fs['Forsaken_CarryDrop'])
  b=b.replace('''        return
    endif''','''        set C23DropTimer[C23DropCount]=GetExpiredTimer()
        set C23DropCount=C23DropCount+1
        return
    endif''',1);s=put(s,'Forsaken_CarryDrop',b)
  for name in ['GearInput_Hover','GearWave_CancelKey','GearWave_WaterCommand','GearWave_IceCommand','GearWave_CalculatorArm','QuickGear_RecordSpell','QuickGear_Draw','QuickGear_RepaintIcons','QuickGear_Diagnostic','Forsaken_BackpackDebug']:
   s=put(s,name,guard(fs[name]))
  # Enforce player identity inside the input helper as well as its callers.
  # Do not manufacture open state or process synchronized spell notifications.
  b=fs['Forsaken_BackpackAccess'];marker='    if InventoryCinematicActive then';assert marker in b
  s=put(s,'Forsaken_BackpackAccess',b.replace(marker,'    if GetLocalPlayer()!=viewer then\n        return\n    endif\n'+marker,1))
  for name in ['Forsaken_BackpackToggleAction','Forsaken_BackpackCloseAction','Forsaken_PanelAccess']:
   b=fs[name];marker='    set viewer=GetTriggerPlayer()';assert marker in b
   s=put(s,name,b.replace(marker,marker+'\n    if viewer!=GetLocalPlayer() then\n        set viewer=null\n        return\n    endif',1))
 return s
