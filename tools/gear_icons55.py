"""Refresh art before cooldown rendering and invalidate the owned simple-frame draw."""
from jtok import functions
from performance_runtime import put


def refresh(source):
    fs=functions(source)
    if 'QuickGear_PaintIcon' not in fs:return source
    repaint='''function QuickGear_RepaintIcons takes nothing returns nothing
    // A job change hides/shows this panel and refreshes its simple-button art.
    // Invalidate only the existing owned panel, retaining its visibility and
    // all input, pending target and cooldown state. No frame is recreated.
    if QuickGearRoot!=null and BlzFrameIsVisible(QuickGearRoot) then
        call BlzFrameSetVisible(QuickGearRoot,false)
        call BlzFrameSetVisible(QuickGearRoot,true)
    endif
endfunction'''
    source=source.replace('function QuickGear_PaintIcon takes',repaint+'\n\nfunction QuickGear_PaintIcon takes',1)
    body=fs['QuickGear_PaintIcon']
    marker='            call BlzFrameSetTexture(QuickGearIcon[slot],path,0,true)'
    assert body.count(marker)==1
    source=put(source,'QuickGear_PaintIcon',body.replace(marker,marker+'\n            call QuickGear_RepaintIcons()',1))
    body=fs['QuickGear_WheelTick']
    marker='    local integer pid=GetPlayerId(GetLocalPlayer())'
    assert body.count(marker)==1
    body=body.replace(marker,marker+'''
    local unit iconHero=Player_GetHero(GetLocalPlayer())
    // Paint before the native cooldown model calls and before the idle return.
    // A failed/early native panel draw must not block fresh equipment art.
    if pid<8 and iconHero!=null and FFL_Phase[pid]==0 and FFN_State[pid]==0 then
        call QuickGear_RefreshIcons(iconHero)
    endif
    set iconHero=null''',1)
    source=put(source,'QuickGear_WheelTick',body)
    body=fs['QuickGear_Diagnostic'].replace('UI53 F/G:','UI55 F/G:')
    marker='            set slot=slot+1'
    assert body.count(marker)==1
    body=body.replace(marker,'''            call DisplayTimedTextToPlayer(owner,0,0,60,"Icon slot="+I2S(slot)+" painted="+QuickGearPaintedPath[slot]+" lookup="+LoadStr(QuickGearIconPaths,0,GetItemTypeId(carried)))
'''+marker,1)
    return put(source,'QuickGear_Diagnostic',body)
