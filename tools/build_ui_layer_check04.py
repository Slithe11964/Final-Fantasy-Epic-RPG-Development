"""Isolated always-visible host, regular labels/models, and scene restoration."""
import build_ui_layer_check02 as single
base=single.base
base.OUT=base.ROOT/'release/development/UILayerCheck04/FFERPG-UI-Layer-Check04.w3x'
base.LABEL='FFERPG UI Layer04'
base.EXTRA=base.EXTRA.replace('UI Layer02','UI Layer04').replace('Layer02','Layer04')
base.EXTRA=base.EXTRA.replace('    set LayerMode=0','    set LayerPosition=mode\n    set LayerMode=0')
base.EXTRA=base.EXTRA.replace('    local framehandle art\n','''    local framehandle art
    local framehandle label
    local framehandle clock
    local leaderboard host=CreateLeaderboard()
    call LeaderboardSetLabel(host,"")
    call PlayerSetLeaderboard(Player(0),host)
    call LeaderboardDisplay(host,true)
    set LayerBoard=BlzGetFrameByName("Leaderboard",0)
    call BlzFrameSetSize(LayerBoard,0.,0.)
    call BlzFrameSetVisible(BlzGetFrameByName("LeaderboardBackdrop",0),false)
    call BlzFrameSetVisible(BlzGetFrameByName("LeaderboardTitle",0),false)
''').replace('BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME,0)','LayerBoard')
base.EXTRA=base.EXTRA.replace('        set slot=slot+1','''        set label=BlzCreateFrameByType("TEXT","Layer04Key",control,"",5300+slot)
        call BlzFrameSetSize(label,.03,.014)
        call BlzFrameSetPoint(label,FRAMEPOINT_TOPLEFT,control,FRAMEPOINT_TOPLEFT,.002,-.001)
        call BlzFrameSetFont(label,"Fonts\\\\FRIZQT__.TTF",.010,0)
        call BlzFrameSetLevel(label,124)
        call BlzFrameSetEnable(label,false)
        if slot==0 then
            call BlzFrameSetText(label,"F")
        else
            call BlzFrameSetText(label,"G")
        endif
        set clock=BlzCreateFrameByType("STATUSBAR","Layer04Clock",control,"",5400+slot)
        call BlzFrameSetModel(clock,"UI\\\\Feedback\\\\Cooldown\\\\UI-Cooldown-Indicator.mdl",0)
        call BlzFrameSetMinMaxValue(clock,0.,1.)
        call BlzFrameSetValue(clock,.5)
        call BlzFrameSetAllPoints(clock,control)
        call BlzFrameSetEnable(clock,false)
        set slot=slot+1''')
base.EXTRA=base.EXTRA.replace('    call Layer_Show(0)','    call Layer_Show(1)').replace('    set art=null','    set art=null\n    set label=null\n    set clock=null\n    set host=null')
# The shared native scene indexes the one root with LayerMode=0, but restores
# the independent position choice. No frame allocation occurs in scene callbacks.
original_build=base.build
def build():
    # Keep the single root index separate from the chosen visual position.
    original_functions=base.functions
    base.EXTRA=base.EXTRA.replace('set LayerPosition=mode','set LayerName[0]=I2S(mode)')
    def funcs(source):
        result=original_functions(source)
        if 'InvCheck_Scene' in result:
            result['InvCheck_Scene']=result['InvCheck_Scene'].replace('    set InvCheckScene=false','    set InvCheckScene=false\n    set LayerMode=S2I(LayerName[0])')
        return result
    base.functions=funcs
    original_build()
if __name__=='__main__':build()
