"""Single regular tree in the native board layer; fixture only, no RPG integration."""
import build_ui_layer_check02 as single
base=single.base
base.OUT=base.ROOT/'release/development/UILayerCheck03/FFERPG-UI-Layer-Check03.w3x'
base.LABEL='FFERPG UI Layer03'
base.EXTRA=base.EXTRA.replace('UI Layer02','UI Layer03').replace('Layer02','Layer03')
base.EXTRA=base.EXTRA.replace('    local framehandle art\n','    local framehandle art\n    local multiboard board=CreateMultiboard()\n    call MultiboardSetRowCount(board,1)\n    call MultiboardSetColumnCount(board,1)\n    call MultiboardSetTitleText(board,"UI Layer03")\n    call MultiboardDisplay(board,true)\n')
base.EXTRA=base.EXTRA.replace('BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME,0)','BlzGetFrameByName("Multiboard",0)')
base.EXTRA=base.EXTRA.replace('    call Layer_Show(0)','    call Layer_Show(1)').replace('    set art=null','    set art=null\n    set board=null')
if __name__=='__main__':base.build()
