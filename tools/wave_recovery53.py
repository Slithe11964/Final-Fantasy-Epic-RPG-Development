"""Retain known origin-frame previews; remove all native bag frame discovery."""
from performance_runtime import put
from jtok import functions

INIT='''function Wave_Init takes nothing returns nothing
    local integer index=0
    if Wave_Clicks!=null then
        call DestroyTrigger(Wave_Clicks)
        call DestroyTrigger(Wave_Keys)
        call FlushParentHashtable(Wave_Controls)
    endif
    set Wave_Clicks=CreateTrigger()
    set Wave_Keys=CreateTrigger()
    call TriggerAddAction(Wave_Clicks,function Wave_FrameClick)
    call TriggerAddAction(Wave_Keys,function Wave_CalculatorKey)
    set Wave_Calculator=BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,BlzGetAbilityPosY('A17S')*4+BlzGetAbilityPosX('A17S'))
    call Wave_Hook(Wave_Calculator,3)
    loop
        exitwhen index>=8
        call BlzTriggerRegisterPlayerKeyEvent(Wave_Keys,Player(index),OSKEY_E,0,true)
        set index=index+1
    endloop
endfunction'''


def refresh(source):
    fs=functions(source)
    if 'Wave_Init' not in fs:return source
    # Retain the generated shared item lookup from the current map's objects.
    rows='\n'.join(l for l in fs['Wave_Init'].splitlines() if 'SaveInteger(Wave_Spells' in l)
    body=INIT.replace('    if Wave_Clicks!=null then',rows+'\n    if Wave_Clicks!=null then',1)
    source=put(source,'Wave_Init',body)
    source=put(source,'Wave_Hook','''function Wave_Hook takes framehandle control,integer slotCode returns nothing
    local integer key=GetHandleId(control)
    if control!=null and not HaveSavedInteger(Wave_Controls,0,key) then
        call SaveInteger(Wave_Controls,0,key,slotCode)
        call BlzTriggerRegisterFrameEvent(Wave_Clicks,control,FRAMEEVENT_CONTROL_CLICK)
    endif
endfunction''')
    for name in ('Wave_CacheBatch','Wave_BagChildren','Wave_RefreshControls'):
        if name in fs:source=source.replace(fs[name],'')
    return source
