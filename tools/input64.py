"""Restore native inventory ownership, remove Return-release recovery dependency."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]

def refresh(source):
    fs=functions(source)
    if 'Trig_Clear_Command_Actions' in fs:
        return put(source,'Trig_Clear_Command_Actions',fs['Trig_Clear_Command_Actions'].replace(
            '    call ClearTextMessagesBJ(l_tempForce)',
            '    call ClearTextMessagesBJ(l_tempForce)\n    call ExecuteFunc("GearChat_Sent64")'))
    if 'GearInput_Cursor' not in fs:return source
    fragment=(ROOT/'experiments/Forsaken/Input64.j').read_text()
    source=source.replace('endglobals',re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]+'endglobals',1)
    fragment_functions=functions(fragment)
    source=source.replace('function GearChat_Poll63 takes',
        '\n\n'.join(body for name,body in fragment_functions.items() if name!='GearRaw_Poll64')+'\n\nfunction GearChat_Poll63 takes',1)
    # Request is needed by physical key fallback, and already follows helpers.
    end=source.index('endfunction',source.index('function QuickGear_Request takes'))+len('endfunction')
    source=source[:end]+'\n\n'+fragment_functions['GearRaw_Poll64']+source[end:]
    source=put(source,'GearChat_Poll63',fs['GearChat_Poll63'].replace(
        ' and not BlzIsKeyPressed(OSKEY_RETURN)','').replace('TimerGetElapsed(ForsakenPanelClock)','TimerGetElapsed(NativeCDClock)'))
    for name in ('GearInput_Init','GearCursor_Error60'):
        source=put(source,name,fs[name].replace('Width()/2),.22','Width()/2),.14'))
    body=fs['BagCast_Init63']
    body=body.replace('    set BagCastClick63=CreateTrigger()','').replace('    set BagCastSync63=CreateTrigger()','')
    body=body.replace('    call TriggerAddAction(BagCastClick63,function BagCast_Click63)','').replace('    call TriggerAddAction(BagCastSync63,function BagCast_Receive63)','')
    body=body.replace('        call BlzTriggerRegisterFrameEvent(BagCastClick63,BagCastButton63[slot],FRAMEEVENT_CONTROL_CLICK)',
        '''        call BlzFrameSetEnable(BagCastButton63[slot],false)
        set BagHoverTip64[slot]=BlzCreateFrameByType("SIMPLEFRAME","BagHoverTip64",BagCastRoot63,"",700+slot)
        call BlzFrameSetSize(BagHoverTip64[slot],.001,.001)
        call BlzFrameSetTooltip(BagCastButton63[slot],BagHoverTip64[slot])
        call BlzFrameSetVisible(BagHoverTip64[slot],false)''')
    body=re.sub(r'    loop\n        exitwhen pid>=8.*?    endloop\n','',body,flags=re.S)
    source=put(source,'BagCast_Init63',body)
    # Retire proxy casting, including any accidental ExecuteFunc access.
    for name in ('BagCast_Click63','BagCast_Receive63','BagCast_Poll63'):
        source=put(source,name,'function '+name+' takes nothing returns nothing\nendfunction')
    body=fs['BagCast_Reset63'].replace('        set BagCastButton63[slot]=null',
        '''        set BagCastButton63[slot]=null
        if BagHoverTip64[slot]!=null then
            call BlzDestroyFrame(BagHoverTip64[slot])
            set BagHoverTip64[slot]=null
        endif''')
    source=put(source,'BagCast_Reset63',body)
    # Leave the .01 cursor callback lean; visual probe uses normal .05 UI clock.
    body=fs['GearInput_Poll'].replace('call BagCast_Poll63()','call BagHover_Poll64()')
    source=put(source,'GearInput_Poll',body)
    body=fs['QuickGear_Input'].replace('TimerGetElapsed(ForsakenPanelClock)','TimerGetElapsed(NativeCDClock)')
    source=put(source,'QuickGear_Input',body)
    body=fs['QuickGear_WheelTick'].replace('    call GearInput_Poll()',
        '    call GearRaw_Poll64()\n    call GearInput_Poll()')
    source=put(source,'QuickGear_WheelTick',body)
    body=fs['QuickGear_Mouse'].replace('        set QuickGearMouseX=',
        '        call BagHover_World64()\n        set QuickGearMouseX=',1)
    start='            if QuickGearPending>=100 then\n'
    if start in body:
        a=body.index(start);b=body.index('            endif',a)+len('            endif')
        body=body[:a]+'''            call QuickGear_Send(QuickGearPending,QuickGearPendingHero,QuickGearPendingItem,QuickGearPendingMark,targetId,BlzGetTriggerPlayerMouseX(),BlzGetTriggerPlayerMouseY())'''+body[b:]
    source=put(source,'QuickGear_Mouse',body)
    body=fs['QuickGear_Diagnostic'].replace('UI63 F/G:','UI64 F/G:').replace('Hotfix11 F/G:','Hotfix12 F/G:')
    body=body.replace('"Bag routed clicks="+I2S(BagCastClicks63)',
        '"Passive bag slot="+I2S(BagHoverSlot64)+" moving="+QuickGear_Bool(BagMoving64)+" raw key requests="+I2S(GearRawRequests64)')
    return put(source,'QuickGear_Diagnostic',body)
