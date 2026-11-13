"""One 10Hz UI heartbeat, change-driven icons, and active-only rune rendering."""
from jtok import functions
from performance_runtime import put

GLOBALS='''    real UI72GearNext=0.
    real UI72WaveNext=0.
'''
HELPERS='''function UI72_GearChanged takes unit hero,real now returns boolean
    if now<UI72GearNext then
        return false
    endif
    set UI72GearNext=now+1.
    return QuickGear_SlotsChanged(hero)
endfunction

function UI72_Extra takes nothing returns nothing
endfunction

function UI72_Tick takes nothing returns nothing
    call GearChat_Poll63()
    call QuickGear_WheelTick()
    call QuickGear_Poll()
    call GearInput_Poll()
    call GearCursor_Draw60()
    call ExecuteFunc("Forsaken_PollPanels")
    call UI72_Extra()
endfunction
'''

def refresh(source,dragoon=False):
    fs=functions(source)
    if 'DG_UIUpdate' in fs:
        source=source.replace('endglobals','    boolean UI72DragoonRunes=false\nendglobals',1)
        body=fs['DG_Tick'];assert ' call DG_UIUpdate()' in body
        source=put(source,'DG_Tick',body.replace(' call DG_UIUpdate()',''))
        body=fs['DG_UIUpdate']
        marker=' loop\n exitwhen i>64'
        assert marker in body
        body=body.replace(marker,''' if not show and not UI72DragoonRunes then
 set u=null
 set focus=null
 return
 endif
 set UI72DragoonRunes=show
'''+marker,1)
        return put(source,'DG_UIUpdate',body)
    if 'QuickGear_Poll' not in fs:return source
    assert 'UI72_Tick' not in fs
    source=source.replace('endglobals',GLOBALS+'endglobals',1)
    name='GearInput_Init';body=fs[name]
    old='    set GearCursorTimer60=CreateTimer()\n    call TimerStart(GearCursorTimer60,.01,true,function GearCursor_Draw60)'
    assert old in body;source=put(source,name,body.replace(old,''))
    name='QuickGear_Init';body=fs[name]
    body=body.replace('function QuickGear_Poll)','function UI72_Tick)')
    old='''    if QuickGearWheelTimer==null then
        set QuickGearWheelTimer=CreateTimer()
        call TimerStart(QuickGearWheelTimer,.05,true,function QuickGear_WheelTick)
    endif'''
    assert old in body;source=put(source,name,body.replace(old,''))
    name='Register_Forsaken_PanelAccess';body=fs[name]
    old='    call TimerStart(ForsakenUITimer,.1,true,function Forsaken_PollPanels)'
    assert old in body;source=put(source,name,body.replace(old,'    // Panel updates share the QuickGear 10Hz heartbeat.'))
    name='QuickGear_WheelTick';body=fs[name]
    start=body.index('    local unit iconHero=');end=body.index('    if not QuickGear_FocusReset()')
    body=body[:start]+body[end:]
    body=body.replace('    call GearInput_Poll()','')
    start=body.index('    // Nothing to animate')
    body=body[:start]+'endfunction'
    source=put(source,name,body)
    name='GearCursor_Draw60';body=fs[name]
    start=body.index('    call GearChat_Poll63()');end=body.index('    if GearCursorErrorUntil60>0.')
    source=put(source,name,body[:start]+body[end:])
    name='QuickGear_Poll';body=fs[name]
    body=body.replace('QuickGear_SlotsChanged(hero)','UI72_GearChanged(hero,now)')
    tail='''    if pid<8 and hero!=null and FFL_Phase[pid]==0 and FFN_State[pid]==0 then
        call QuickGear_RefreshIcons(hero)
    endif'''
    assert tail in body;source=put(source,name,body.replace(tail,''))
    name='GearInput_Poll';body=fs[name]
    old='''    call BagScreen_Poll65()
    call GearInput_Cursor()
    call GearWave_Draw()'''
    assert old in body
    new='''    if BagMoving64 or (ForsakenLinkedBag!=null and BlzFrameIsVisible(ForsakenLinkedBag)) then
        call BagScreen_Poll65()
    else
        set BagHoverSlot64=-1
        set BagLeft64=false
        set BagRight64=false
    endif
    if GearInputTarget or GearCursorWasShown60 then
        call GearInput_Cursor()
        set GearCursorWasShown60=GearInputTarget and QuickGearPending>=0
    endif
    if GearWaveMode>0 then
        call GearWave_Draw()
    endif'''
    source=put(source,name,body.replace(old,new))
    name='GearWave_Clear';body=fs[name]
    body=body.replace('    call Wave65_Clear()',
        '    if GearWaveMode==0 then\n        return\n    endif\n    call Wave65_Clear()',1)
    source=put(source,name,body)
    name='GearWave_Draw'
    source=put(source,name,'''function GearWave_Draw takes nothing returns nothing
    local real now=TimerGetElapsed(NativeCDClock)
    if GearWaveMode==0 or now+.001<UI72WaveNext then
        return
    endif
    set UI72WaveNext=now+.1
    call Wave65_Draw()
endfunction''')
    name='GearWave_Arm';body=fs[name]
    source=put(source,name,body.replace('    call GearWave_Clear()',
        '    call GearWave_Clear()\n    set UI72WaveNext=0.',1))
    name='QuickGear_Reset';body=fs[name]
    source=put(source,name,body.replace('    set QuickGearReady=false',
        '    set UI72GearNext=0.\n    set UI72WaveNext=0.\n    set QuickGearReady=false',1))
    helpers=HELPERS
    if dragoon:helpers=helpers.replace('function UI72_Extra takes nothing returns nothing\n',
        'function UI72_Extra takes nothing returns nothing\n    call ExecuteFunc("DG_UIUpdate")\n')
    # The gear helper must precede the poll it is used by; the tick follows poll.
    helper,rest=helpers.split('function UI72_Extra',1)
    source=source.replace('function QuickGear_Poll takes',helper+'\nfunction QuickGear_Poll takes',1)
    return source.replace('function QuickGear_Init takes','function UI72_Extra'+rest+'\nfunction QuickGear_Init takes',1)
