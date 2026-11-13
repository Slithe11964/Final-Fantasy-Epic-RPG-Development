"""Use the proven backdrop cursor and observe native tooltip text for bag waves."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from editor_pair import View
from damage_tooltips import merged
from priest_master import fields
ROOT=Path(__file__).resolve().parents[1]

CURSOR='''function GearInput_Cursor takes nothing returns nothing
    // Fail visibly: never leave the OS pointer disabled for a missing frame.
    call BlzEnableCursor(true)
    if GearInputCursor==null or GetHandleId(GearInputCursor)<=0 then
        return
    endif
    if GearInputTarget and QuickGearPending>=0 and BlzIsLocalClientActive() and not QuickGearChatOpen and not InventoryCinematicActive then
        call BlzFrameSetAbsPoint(GearInputCursor,FRAMEPOINT_CENTER,BlzPixelToFrameX(BlzGetMouseScreenPosX()),BlzPixelToFrameY(BlzGetMouseScreenPosY()))
        call BlzFrameSetVisible(GearInputCursor,true)
        if BlzFrameIsVisible(GearInputCursor) then
            call BlzEnableCursor(false)
        endif
    else
        call BlzFrameSetVisible(GearInputCursor,false)
    endif
endfunction'''


def refresh(source):
    fs=functions(source)
    if 'GearInput_Cursor' not in fs:return source
    fragment=(ROOT/'experiments/Forsaken/GearBag61.j').read_text()
    view=View(ROOT/'release/development/QuickUI60/FFERPG-QuickUI60-Forsaken.w3x')
    items=merged(view.object_bytes('war3map.w3t'),view.object_bytes('war3mapSkin.w3t'),'w3t')
    wave={'A08X','A0Q0','A0Q1','A0Q2','A0SM','A0TP','A0SA','A150','A0UY','A0TM','A17S'}
    rows=[]
    for raw,obj in sorted(items.items()):
        casts=set(str(fields(obj).get(('iabi',None),'')).split(','))&wave
        if casts:rows.append(f"    call GearBag_Add61('{raw}','{sorted(casts)[0]}')")
    assert rows
    batches=[];calls=[]
    for offset in range(0,len(rows),8):
        name='GearBag_Names61_'+str(offset//8)
        batches.append('function '+name+' takes nothing returns nothing\n'+'\n'.join(rows[offset:offset+8])+'\nendfunction')
        calls.append('    call ExecuteFunc("'+name+'")')
    batches.append('function GearBag_Names61 takes nothing returns nothing\n    set GearBagNameCount61=0\n'+'\n'.join(calls)+'\nendfunction')
    source=source.replace('endglobals',re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]+'endglobals',1)
    source=source.replace('function GearInput_Cursor takes','\n\n'.join(list(functions(fragment).values())+batches)+'\n\nfunction GearInput_Cursor takes',1)
    source=put(source,'GearInput_Cursor',CURSOR)
    body=fs['GearInput_Init']
    start=body.index('    call BlzLoadTOCFile("GearTarget60.toc")')
    end=body.index('    call BlzFrameSetSize(GearInputCursor',start)
    body=body[:start]+'''    call BlzLoadTOCFile("GearError61.toc")
    set GearInputCursor=BlzCreateFrameByType("BACKDROP","GearInputCursor61",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetTexture(GearInputCursor,"GearTarget61.tga",0,true)
'''+body[end:]
    start=body.index('    set GearCursorError60=BlzCreateFrameByType(')
    end=body.index('    call BlzFrameSetEnable(GearCursorError60',start)
    body=body[:start]+'''    set GearCursorError60=BlzCreateFrame("GearGroundError61",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,661)
    call BlzFrameSetAbsPoint(GearCursorError60,FRAMEPOINT_CENTER,.4,.295)
'''+body[end:]
    start=body.index('    set GearInputHover=CreateTrigger()')
    end=body.index('    call ExecuteFunc("GearInput_InitSpells")',start)
    body=body[:start]+'    call GearBag_Init61()\n'+body[end:]
    source=put(source,'GearInput_Init',body)
    body=fs['GearCursor_Draw60'].replace('    if GearInputTarget or GearCursorWasShown60 then','    call GearBag_Poll61()\n    if GearInputTarget or GearCursorWasShown60 then',1)
    source=put(source,'GearCursor_Draw60',body)
    source=put(source,'GearInput_Poll','''function GearInput_Poll takes nothing returns nothing
    if not BlzIsLocalClientActive() or QuickGearChatOpen or InventoryCinematicActive then
        set QuickGearPending=-1
        call QuickGear_ClearPreview()
    endif
    call GearInput_Cursor()
    call GearWave_Draw()
endfunction''')
    body=fs['GearInput_Reset'].replace('    set GearInputTarget=false','''    set GearBagTip61=null
    set GearBagUber61=null
    set GearBagTextCount61=0
    set GearBagLeft61=false
    set GearInputTarget=false''',1)
    source=put(source,'GearInput_Reset',body)
    body=fs['QuickGear_Diagnostic'].replace('UI60 F/G:','UI61 F/G:').replace('Hotfix08 F/G:','Hotfix09 F/G:')
    body=body.replace('    if GetLocalPlayer()==owner then','    if GetLocalPlayer()==owner then\n        call DisplayTimedTextToPlayer(owner,0,0,60,"Bag tooltip buffers="+I2S(GearBagTextCount61)+" previews="+I2S(GearBagArms61)+" last="+GearBagLast61)',1)
    return put(source,'QuickGear_Diagnostic',body)
