"""Explicit wave-item click routing, chat focus recovery and lower error text."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]

def refresh(source):
    fs=functions(source)
    if 'GearInput_Cursor' not in fs:return source
    fragment=(ROOT/'experiments/Forsaken/BagCast63.j').read_text()
    source=source.replace('endglobals',re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]+'endglobals',1)
    # Cursor dependency must precede the new click callback in plain JASS.
    end=source.index('endfunction',source.index('function GearInput_Cursor takes'))+len('endfunction')
    source=source[:end]+'\n\n'+'\n\n'.join(functions(fragment).values())+source[end:]
    for name in ('GearProbe_World62','GearProbe_Enter62','GearProbe_Poll62','GearProbe_Reset62','GearProbe_Init62'):
        source=put(source,name,'function '+name+' takes nothing returns nothing\nendfunction')
    for name in ('GearInput_Init','GearCursor_Error60'):
        body=fs[name].replace('BlzPixelToFrameY(R2I(I2R(BlzGetLocalClientHeight())*.507))','.22')
        if name=='GearInput_Init':body=body.replace('call GearProbe_Init62()','call BagCast_Init63()')
        source=put(source,name,body)
    body=fs['GearInput_Reset'].replace('call GearProbe_Reset62()','call BagCast_Reset63()')
    source=put(source,'GearInput_Reset',body)
    body=fs['GearCursor_Draw60'].replace('    call GearProbe_Poll62()','    call GearChat_Poll63()')
    source=put(source,'GearCursor_Draw60',body)
    body=fs['GearInput_Poll'].replace('    call GearInput_Cursor()','    call BagCast_Poll63()\n    call GearInput_Cursor()')
    source=put(source,'GearInput_Poll',body)
    body=fs['QuickGear_Input'].replace('        set QuickGearChatOpen=false\n        set QuickGearChatSentAt=',
        '        set GearChatRecover63=true\n        set QuickGearChatOpen=false\n        set QuickGearChatSentAt=',1)
    body=body.replace('QuickGearChatSentAt<.25','QuickGearChatSentAt<.75')
    source=put(source,'QuickGear_Input',body)
    body=fs['QuickGear_Mouse'].replace('        call GearProbe_World62()\n','')
    marker='            call QuickGear_Send(QuickGearPending,QuickGearPendingHero,QuickGearPendingItem,QuickGearPendingMark,targetId,BlzGetTriggerPlayerMouseX(),BlzGetTriggerPlayerMouseY())'
    body=body.replace(marker,'            if QuickGearPending>=100 then\n                call BagCast_Send63(QuickGearPending-100,QuickGearPendingHero,QuickGearPendingItem,QuickGearPendingMark,BlzGetTriggerPlayerMouseX(),BlzGetTriggerPlayerMouseY())\n            else\n'+marker+'\n            endif')
    source=put(source,'QuickGear_Mouse',body)
    body=fs['QuickGear_Diagnostic'].replace('UI62 F/G:','UI63 F/G:').replace('Hotfix10 F/G:','Hotfix11 F/G:')
    body=re.sub(r'^.*call DisplayTimedTextToPlayer\(owner,0,0,60,"Bag probes=.*\n',
        '        call DisplayTimedTextToPlayer(owner,0,0,60,"Bag routed clicks="+I2S(BagCastClicks63))\n',body,flags=re.M)
    return put(source,'QuickGear_Diagnostic',body)
