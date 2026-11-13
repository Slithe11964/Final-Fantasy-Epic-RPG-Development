"""One regular frame tree only; no simple frames, TOC, boards or cross-tree anchors."""
from pathlib import Path
import build_ui_layer_check01 as base

base.OUT=base.ROOT/'release/development/UILayerCheck02/FFERPG-UI-Layer-Check02.w3x'
base.LABEL='FFERPG UI Layer02'
base.EXTRA=r'''function Layer_Show takes integer mode returns nothing
    if mode<0 or mode>1 then
        return
    endif
    set LayerMode=0
    call BlzFrameClearAllPoints(LayerRoot[0])
    if mode==0 then
        call BlzFrameSetAbsPoint(LayerRoot[0],FRAMEPOINT_TOPLEFT,.748,.265)
    else
        call BlzFrameSetAbsPoint(LayerRoot[0],FRAMEPOINT_TOPLEFT,.812,.085)
    endif
    call BlzFrameSetVisible(LayerRoot[0],true)
    call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,15.,"UI Layer02: -layer 0 above grid; -layer 1 right of spells; -scene.")
endfunction
function Layer_Init takes nothing returns nothing
    local integer slot=0
    local framehandle control
    local framehandle art
    set LayerRoot[0]=BlzCreateFrameByType("FRAME","Layer02Root",BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME,0),"",5000)
    call BlzFrameSetSize(LayerRoot[0],.040,.086)
    call BlzFrameSetLevel(LayerRoot[0],120)
    loop
        exitwhen slot>=2
        set control=BlzCreateFrameByType("BUTTON","Layer02Button",LayerRoot[0],"",5100+slot)
        call BlzFrameSetPoint(control,FRAMEPOINT_TOPLEFT,LayerRoot[0],FRAMEPOINT_TOPLEFT,0.,-I2R(slot)*.046)
        call BlzFrameSetSize(control,.040,.040)
        set art=BlzCreateFrameByType("BACKDROP","Layer02Art",control,"",5200+slot)
        call BlzFrameSetAllPoints(art,control)
        call BlzFrameSetEnable(art,false)
        if slot==0 then
            call BlzFrameSetTexture(art,"ReplaceableTextures\\CommandButtons\\BTNStaffOfNegation.blp",0,true)
        else
            call BlzFrameSetTexture(art,"ReplaceableTextures\\CommandButtons\\BTNBookWater.blp",0,true)
        endif
        set slot=slot+1
    endloop
    call Layer_Show(0)
    set control=null
    set art=null
endfunction
'''

if __name__=='__main__':
    base.build()
