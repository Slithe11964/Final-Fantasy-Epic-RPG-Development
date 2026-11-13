"""Owned passive bag probes, screenshot warning style, no native UI tree discovery."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]


def refresh(source):
    fs=functions(source)
    if 'GearInput_Cursor' not in fs:return source
    fragment=(ROOT/'experiments/Forsaken/GearProbe62.j').read_text()
    source=source.replace('endglobals',re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]+'endglobals',1)
    source=source.replace('function GearInput_Cursor takes','\n\n'.join(functions(fragment).values())+'\n\nfunction GearInput_Cursor takes',1)
    # Retire the failed native tooltip access, including all child lookups.
    for name in fs:
        if name.startswith('GearBag_'):
            source=put(source,name,'function '+name+' takes '+re.search(r'takes (.*?) returns',fs[name])[1]+' returns '+re.search(r'returns (\w+)',fs[name])[1]+'\n'+('    return 0\n' if ' returns integer' in fs[name] else '    return ""\n' if ' returns string' in fs[name] else '')+'endfunction')
    body=fs['GearInput_Init'].replace('GearError61.toc','GearError62.toc').replace('GearGroundError61','GearGroundError62')
    body=body.replace('    call BlzFrameSetAbsPoint(GearCursorError60,FRAMEPOINT_CENTER,.4,.295)',
        '    call BlzFrameSetAbsPoint(GearCursorError60,FRAMEPOINT_CENTER,BlzPixelToFrameX(BlzGetLocalClientWidth()/2),BlzPixelToFrameY(R2I(I2R(BlzGetLocalClientHeight())*.507)))')
    body=body.replace('    call BlzFrameSetEnable(GearCursorError60,false)','    call BlzFrameSetEnable(GearCursorError60,true)')
    body=body.replace('    call GearBag_Init61()','    call GearProbe_Init62()')
    source=put(source,'GearInput_Init',body)
    body=fs['GearInput_Reset'].replace('    if GearCursorTimer60!=null then','    call GearProbe_Reset62()\n    if GearCursorTimer60!=null then',1)
    source=put(source,'GearInput_Reset',body)
    body=fs['GearCursor_Draw60'].replace('call GearBag_Poll61()','call GearProbe_Poll62()')
    source=put(source,'GearCursor_Draw60',body)
    body=fs['GearCursor_Error60'].replace('call BlzFrameSetText(GearCursorError60,message)',
        'call BlzFrameSetAbsPoint(GearCursorError60,FRAMEPOINT_CENTER,BlzPixelToFrameX(BlzGetLocalClientWidth()/2),BlzPixelToFrameY(R2I(I2R(BlzGetLocalClientHeight())*.507)))\n        call BlzFrameSetText(GearCursorError60,"|cffffcc00"+message+"|r")')
    source=put(source,'GearCursor_Error60',body)
    body=fs['QuickGear_Mouse'].replace('        set QuickGearMouseX=BlzGetTriggerPlayerMouseX()',
        '        call GearProbe_World62()\n        set QuickGearMouseX=BlzGetTriggerPlayerMouseX()',1)
    source=put(source,'QuickGear_Mouse',body)
    body=fs['QuickGear_Diagnostic'].replace('UI61 F/G:','UI62 F/G:').replace('Hotfix09 F/G:','Hotfix10 F/G:')
    body=re.sub(r'^.*call DisplayTimedTextToPlayer\(owner,0,0,60,"Bag tooltip buffers=.*\n','',body,flags=re.M)
    body=body.replace('    if GetLocalPlayer()==owner then','    if GetLocalPlayer()==owner then\n        call DisplayTimedTextToPlayer(owner,0,0,60,"Bag probes="+I2S(GearProbeEnters62)+" previews="+I2S(GearProbeArms62)+" slot="+I2S(GearProbeCurrent62)+" raw="+I2S(GearProbeRaw62)+" width="+R2S(GearProbeWidth62)+" height="+R2S(GearProbeHeight62))',1)
    return put(source,'QuickGear_Diagnostic',body)
