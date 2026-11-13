"""Keep native previews independent of F/G dock; water emphasis and ice footprint."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]

ITEM='''function BagScreen_Item67 takes unit hero,integer slot returns item
    if hero==null then
        return null
    elseif slot>=0 and slot<30 then
        return BlzUnitItemInBagSlot(hero,slot)
    elseif slot==100 or slot==101 then
        return QuickGear_Item(hero,slot-100)
    endif
    return null
endfunction'''

def refresh(source):
    fs=functions(source)
    if 'GearInput_Cursor' not in fs:return source
    wave=(ROOT/'experiments/Forsaken/Wave67.j').read_text()
    declarations=re.search(r'globals\n(.*?)endglobals',wave,re.S)[1].replace('    image array IceAreaRune65\n','')
    source=source.replace('endglobals',declarations+'endglobals',1)
    wf=functions(wave)
    source=source.replace('function Wave65_Init takes',wf['Wave67_BuildEdge']+'\n\nfunction Wave65_Init takes',1)
    for name,body in wf.items():
        if name=='Wave67_BuildEdge':continue
        old=name.replace('Wave67_','Wave65_')
        source=put(source,old,body.replace('function '+name+' takes','function '+old+' takes',1))
    source=put(source,'GearWave_Arm',fs['GearWave_Arm'].replace('    call GearWave_Clear()',
        '    call GearWave_Clear()\n    set GearWaveCast67=cast',1))
    body=fs['QuickGear_Poll'].replace('        if not show then',
        '        if InventoryCinematicActive or not IsUnitSelected(hero,viewer) or (QuickGearPending==0 and not QuickGearActive[0]) or (QuickGearPending==1 and not QuickGearActive[1]) then')
    assert body!=fs['QuickGear_Poll']
    source=put(source,'QuickGear_Poll',body)
    source=source.replace('function BagScreen_Update66 takes',ITEM+'\n\nfunction BagScreen_Update66 takes',1)
    body=fs['BagScreen_Update66'].replace('    local real edge=0.',
        '    local real mouseX=BlzPixelToFrameX(BlzGetMouseScreenPosX())\n    local real mouseY=BlzPixelToFrameY(BlzGetMouseScreenPosY())\n    local real center=0.\n    local real gearBottom=0.\n    local real edge=0.',1)
    marker='    if BagMoving64 and BagSourceSlot66>=0 and hero!=null then'
    body=body.replace(marker,'''    if show and BagHoverSlot64<0 and ForsakenCachedEquipment!=null then
        if BlzFrameIsVisible(ForsakenCachedEquipment) then
            // inventorybar.fdf primary/offhand flank the equipment-panel bottom center.
            set center=edge-BlzFrameGetWidth(ForsakenCachedEquipment)/2.
            set gearBottom=bottom+BlzFrameGetHeight(bag)+.0115
            if mouseY>=gearBottom and mouseY<gearBottom+.03125 then
                if mouseX>=center-.03125 and mouseX<center then
                    set BagHoverSlot64=100
                elseif mouseX>=center and mouseX<center+.03125 then
                    set BagHoverSlot64=101
                endif
            endif
        endif
    endif
'''+marker,1)
    body=body.replace('BlzUnitItemInBagSlot(hero,BagSourceSlot66)','BagScreen_Item67(hero,BagSourceSlot66)')
    source=put(source,'BagScreen_Update66',body)
    body=fs['BagScreen_Click66'].replace('BlzUnitItemInBagSlot(hero,BagHoverSlot64)','BagScreen_Item67(hero,BagHoverSlot64)')
    source=put(source,'BagScreen_Click66',body)
    body=fs['QuickGear_Diagnostic'].replace('UI66 F/G:','UI67 F/G:').replace('Hotfix14 F/G:','Hotfix15 F/G:')
    return put(source,'QuickGear_Diagnostic',body)
