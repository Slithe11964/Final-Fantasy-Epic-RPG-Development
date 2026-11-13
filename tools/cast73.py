"""Defer owner-local preview cleanup out of synchronized spell event threads."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    fs=functions(source)
    if 'QuickGear_RecordSpell' not in fs:return source
    source=source.replace('endglobals','''    boolean UI73ClearRequested=false
    integer UI73AimRevision=0
    integer UI73ClearRevision=0
endglobals''',1)
    name='QuickGear_RecordSpell';body=fs[name]
    old='''                call Preview_LogClear68("spell-start/effect")
                call ExecuteFunc("QuickGear_ClearPreview")'''
    assert old in body
    body=body.replace(old,'''                // Do not launch owner-only cleanup inside a shared spell event.
                set UI73ClearRequested=true
                set UI73ClearRevision=UI73AimRevision''')
    source=put(source,name,body)
    name='UI72_Tick';body=fs[name]
    body=body.replace('    call GearChat_Poll63()', '''    if UI73ClearRequested then
        set UI73ClearRequested=false
        if UI73ClearRevision==UI73AimRevision then
            call Preview_LogClear68("deferred spell-start/effect")
            call QuickGear_ClearPreview()
        endif
    endif
    call GearChat_Poll63()''',1)
    source=put(source,name,body)
    # A newly armed preview must not be cancelled by the previous cast's notice.
    name='QuickGear_Request';body=fs[name]
    body=body.replace('    set QuickGearRequests=QuickGearRequests+1',
        '    set UI73AimRevision=UI73AimRevision+1\n    set QuickGearRequests=QuickGearRequests+1',1)
    source=put(source,name,body)
    name='GearWave_Arm';body=fs[name]
    body=body.replace('    call GearWave_Clear()',
        '    set UI73AimRevision=UI73AimRevision+1\n    call GearWave_Clear()',1)
    return put(source,name,body)
