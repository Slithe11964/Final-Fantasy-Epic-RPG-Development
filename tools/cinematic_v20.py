"""Shared cinematic handoff and bounded staged autosave on V19."""
import re
from jtok import functions
from performance_runtime import put
from selective_f_restore import guard

PROFILE_GLOBALS='''    boolean C20ProfilePaused=false
    boolean C20PollPaused=false
    boolean array C20CapturePaused
    real C20PauseStarted=0.
    boolean array C20SoftAutosave
    real array C20RetryAfter
'''
PROFILE='''function C20_ProfilePause takes nothing returns nothing
    local integer pid=0
    if C20ProfilePaused then
        return
    endif
    set C20ProfilePaused=true
    set C20PauseStarted=TimerGetElapsed(FST_Clock)
    set C20PollPaused=FFL_Poll!=null and TimerGetRemaining(FFL_Poll)>0.
    if C20PollPaused then
        call PauseTimer(FFL_Poll)
    endif
    loop
        exitwhen pid>=8
        set C20CapturePaused[pid]=FRC_Phase[pid]!=0 and FRC_Timer[pid]!=null
        if C20CapturePaused[pid] then
            call PauseTimer(FRC_Timer[pid])
            call PauseTimer(FRC_Watchdog[pid])
        endif
        set pid=pid+1
    endloop
endfunction
function C20_ProfileResume takes nothing returns nothing
    local integer pid=0
    local real elapsed=TimerGetElapsed(FST_Clock)-C20PauseStarted
    if not C20ProfilePaused then
        return
    endif
    set C20ProfilePaused=false
    loop
        exitwhen pid>=8
        if FFL_Phase[pid]!=0 then
            set FFL_Started[pid]=FFL_Started[pid]+elapsed
        endif
        if C20CapturePaused[pid] and FRC_Phase[pid]!=0 then
            call ResumeTimer(FRC_Timer[pid])
            call ResumeTimer(FRC_Watchdog[pid])
        endif
        set C20CapturePaused[pid]=false
        set pid=pid+1
    endloop
    if C20PollPaused then
        call ResumeTimer(FFL_Poll)
    endif
    set C20PollPaused=false
endfunction
function C20_BeginAutosave takes integer pid returns boolean
    if udg_InCinematicMode or InventoryCinematicActive or TimerGetElapsed(FST_Clock)<C20RetryAfter[pid] then
        return false
    endif
    if not FRC_Start(pid) then
        set C20RetryAfter[pid]=TimerGetElapsed(FST_Clock)+10.
        return false
    endif
    // One bounded capture step per 100ms; never pump 400 steps inline.
    call TimerStart(FRC_Timer[pid],.1,true,function FRC_Tick)
    call TimerStart(FRC_Watchdog[pid],60.,false,function FRC_Timeout)
    set FFL_SaveFile[pid]=true
    set FST_LegacySaveMessages[pid]=true
    set FFL_Phase[pid]=1
    set C20SoftAutosave[pid]=true
    return true
endfunction
'''

UI_GLOBALS='''    boolean C20UIPaused=false
    boolean C20UITimerActive=false
    boolean C20InventoryActive=false
    boolean C20EquipEventsActive=false
    timer array C20DeferredBag
    integer C20DeferredCount=0
'''
UI='''function C20_HideUI takes nothing returns nothing
    local integer i=0
    call Forsaken_CloseBackpack()
    if QuickGearRoot!=null then
        call BlzFrameSetVisible(QuickGearRoot,false)
    endif
    loop
        exitwhen i>=2
        if QuickGearButton[i]!=null then
            call BlzFrameSetVisible(QuickGearButton[i],false)
        endif
        if QuickGearWheelPanel[i]!=null then
            call BlzFrameSetVisible(QuickGearWheelPanel[i],false)
        endif
        set i=i+1
    endloop
    call QuickGear_ClearPreview()
    if ForsakenTalentRoot!=null then
        call BlzFrameSetVisible(ForsakenTalentRoot,false)
        call BlzFrameSetVisible(ForsakenTalentToggle,false)
        call BlzFrameSetVisible(ForsakenBackpackClose,false)
        call BlzFrameSetVisible(ForsakenLinkedBagClose,false)
        call BlzFrameSetVisible(ForsakenInspectRoot,false)
        call BlzFrameSetVisible(ForsakenInspectButton,false)
    endif
    if CarryUIButton!=null then
        call BlzFrameSetVisible(CarryUIButton,false)
        call BlzFrameSetVisible(CarryUIRoot,false)
    endif
    set QuickGearPending=-1
    set QuickGearShown=false
    set QuickGearReady=false
endfunction
function C20_UIPause takes nothing returns nothing
    if C20UIPaused then
        return
    endif
    set C20UIPaused=true
    set C20UITimerActive=QuickGearUITimer!=null and TimerGetRemaining(QuickGearUITimer)>0.
    set C20InventoryActive=ForsakenInventoryTimer!=null and TimerGetRemaining(ForsakenInventoryTimer)>0.
    set C20EquipEventsActive=gg_trg_Forsaken_Equipment!=null and IsTriggerEnabled(gg_trg_Forsaken_Equipment)
    if C20UITimerActive then
        call PauseTimer(QuickGearUITimer)
    endif
    if C20InventoryActive then
        call PauseTimer(ForsakenInventoryTimer)
    endif
    if C20EquipEventsActive then
        call DisableTrigger(gg_trg_Forsaken_Equipment)
    endif
    call C20_HideUI()
endfunction
function C20_UIResume takes nothing returns nothing
    local integer i=0
    if not C20UIPaused then
        return
    endif
    set C20UIPaused=false
    set QuickGearReady=false
    set QuickGearSeenRevision=-1
    set ForsakenNextPanelDraw=0.
    set ForsakenTalentAnchor=null
    if C20EquipEventsActive then
        call EnableTrigger(gg_trg_Forsaken_Equipment)
    endif
    if C20InventoryActive then
        call ResumeTimer(ForsakenInventoryTimer)
    endif
    if C20UITimerActive then
        call ResumeTimer(QuickGearUITimer)
    endif
    loop
        exitwhen i>=C20DeferredCount
        call TimerStart(C20DeferredBag[i],0.,false,function Forsaken_RebindBag)
        set C20DeferredBag[i]=null
        set i=i+1
    endloop
    set C20DeferredCount=0
endfunction
'''

def add_guard(b):
 if 'if udg_InCinematicMode or InventoryCinematicActive then' in b:return b
 return guard(b)

def refresh(lib,s,classic=False):
 fs=functions(s)
 if lib=='TCine':
  s=s.replace('endglobals','    boolean C20StatsPaused=false\n    boolean C20HeroRefreshPaused=false\nendglobals',1)
  b=fs['Cine_Enter'];marker='    set InventoryCinematicActive=true';assert marker in b
  calls='''
    set C20StatsPaused=TimerGetRemaining(udg_StatsRefreshTimer)>0.
    set C20HeroRefreshPaused=TimerGetRemaining(udg_HeroRefreshTimer)>0.
    if C20StatsPaused then
        call PauseTimer(udg_StatsRefreshTimer)
    endif
    if C20HeroRefreshPaused then
        call PauseTimer(udg_HeroRefreshTimer)
    endif
    call ExecuteFunc("C20_ProfilePause")
    call ExecuteFunc("C20_CooldownPause")
'''
  if not classic:calls+='    call ExecuteFunc("C20_UIPause")\n'
  b=b.replace(marker,marker+calls,1);s=put(s,'Cine_Enter',b)
  b=fs['Cine_Exit'];marker='    set InventoryCinematicActive=false';assert marker in b
  calls='''
    call ExecuteFunc("C20_ProfileResume")
    call ExecuteFunc("C20_CooldownResume")
    if C20StatsPaused then
        call ResumeTimer(udg_StatsRefreshTimer)
    endif
    if C20HeroRefreshPaused then
        call ResumeTimer(udg_HeroRefreshTimer)
    endif
'''
  if not classic:calls+='    call ExecuteFunc("C20_UIResume")\n'
  s=put(s,'Cine_Exit',b.replace(marker,marker+calls,1))
 if lib=='TForsakenFreshLoad':
  s=s.replace('endglobals',PROFILE_GLOBALS+'endglobals',1)
  s=s.replace('function Restore_AutosaveTick takes',PROFILE+'\nfunction Restore_AutosaveTick takes',1)
  b=fs['Restore_AutosaveTick'];assert 'FFL_BeginSave(pid,true,true)' in b
  s=put(s,'Restore_AutosaveTick',b.replace('FFL_BeginSave(pid,true,true)','C20_BeginAutosave(pid)',1))
  b=fs['FFL_Tick'];marker='''        elseif ((FFL_Phase[pid] == 1) and (FRC_Phase[pid] == 0)) then
            set FFL_Phase[pid]=0''';assert marker in b
  new=marker+'''
            if C20SoftAutosave[pid] then
                set C20SoftAutosave[pid]=false
                if not FRC_Ready[pid] then
                    set RestoreAutoPending[pid]=true
                    set C20RetryAfter[pid]=TimerGetElapsed(FST_Clock)+10.
                endif
            endif'''
  s=put(s,'FFL_Tick',b.replace(marker,new,1))
  s=put(s,'FFL_Tick',add_guard(functions(s)['FFL_Tick']))
  b=add_guard(fs['FFL_Chat'])
  b=b.replace('''        return
    endif''','''        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Please wait until the cutscene ends before loading or saving.")
        return
    endif''',1)
  s=put(s,'FFL_Chat',b)
 if lib=='TForsakenSaveCapture':
  s=put(s,'FRC_Tick',add_guard(fs['FRC_Tick']))
 if lib=='TSave':
  for n in ['Save_OnSaveCommand','Save_OnSaveToFile','Save_OnNewGamePlus']:
   if n in fs:s=put(s,n,add_guard(fs[n]))
 if lib=='TEquip' and 'QuickGear_Init' in fs:
  s=s.replace('endglobals',UI_GLOBALS+'endglobals',1)
  # Put helpers after existing preview functions, before the initialization tail.
  s=s.replace('function Register_Forsaken_Equipment takes',UI+'\nfunction Register_Forsaken_Equipment takes',1)
  entry={'QuickGear_Receive','QuickGear_Click','QuickGear_Input','QuickGear_Mouse','GearInput_Mouse','GearInput_Key','BagScreen_Event66','CarryUI_Receive','Forsaken_OnEquip'}
  for n in entry:
   if n in fs:s=put(s,n,add_guard(fs[n]))
  b=functions(s)['Forsaken_OnEquip'];marker='    if holder==null then';assert marker in b
  b=b.replace(marker,"    if holder!=null and (GetUnitTypeId(holder)=='h01B' or GetUnitTypeId(holder)=='h02S') then\n        set holder=null\n        return\n    endif\n"+marker,1)
  marker='    if GetTriggerEventId()==EVENT_PLAYER_UNIT_DROP_ITEM or';assert marker in b
  b=b.replace(marker,'''    if GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER or GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER or GetTriggerEventId()==EVENT_PLAYER_UNIT_ISSUED_ORDER then
        // Orders need only the native item-transfer routing. Moving/attacking/
        // opening a command must not rescan and remove/re-add worn abilities.
        call Forsaken_CarryOrder(holder)
        set holder=null
        return
    endif
'''+marker,1)
  s=put(s,'Forsaken_OnEquip',b)
  b=guard(fs['Forsaken_RebindBag'])
  b=b.replace('''        return
    endif''','''        set C20DeferredBag[C20DeferredCount]=GetExpiredTimer()
        set C20DeferredCount=C20DeferredCount+1
        return
    endif''',1)
  s=put(s,'Forsaken_RebindBag',b)
  # The short native-context adoption window could leave Talents/X/Move hidden
  # controls after delayed engine rebinding. Owner/selection/inspect checks stay.
  b=fs['Forsaken_BackpackVisible']
  b=re.sub(r'    elseif visible and \(ForsakenInventoryHero!=hero.*?\n        set visible=false\n','',b,count=1)
  s=put(s,'Forsaken_BackpackVisible',b)
 if lib=='TItemCooldown':
  if 'NativeCD_Commit' not in fs:
   return s.replace('endlibrary','''function C20_CooldownPause takes nothing returns nothing
endfunction
function C20_CooldownResume takes nothing returns nothing
endfunction
endlibrary''',1)
  helpers='''function C20_CooldownPause takes nothing returns nothing
    if NativeCDCommitCount>0 then
        call PauseTimer(NativeCDCommitTimer)
    endif
endfunction
function C20_CooldownResume takes nothing returns nothing
    if NativeCDCommitCount>0 then
        call TimerStart(NativeCDCommitTimer,0.,false,function NativeCD_Commit)
    endif
endfunction
'''
  s=put(s,'NativeCD_Commit',add_guard(fs['NativeCD_Commit']))
  b=fs['NativeCD_Queue'];marker='        call TimerStart(NativeCDCommitTimer,0.,false,function NativeCD_Commit)';assert marker in b
  b=b.replace(marker,'        if not udg_InCinematicMode and not InventoryCinematicActive then\n'+marker+'\n        endif',1)
  s=put(s,'NativeCD_Queue',b)
  s=s.replace('function NativeCD_Queue takes',helpers+'\nfunction NativeCD_Queue takes',1)
 return s
