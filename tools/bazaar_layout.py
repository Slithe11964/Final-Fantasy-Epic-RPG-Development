"""Retain the original Bazaar cards; place their buttons above native UI input."""
from performance_runtime import put
from jtok import functions

def refresh(source,*,native=False):
    if not native:return source
    fs=functions(source)
    if 'Forsaken_PollPanels' in fs:
        from gameplay_runtime import dependency
        source=dependency(source,'TBazaar')
        body=functions(source)['Forsaken_PollPanels']
        line='set ForsakenBoardCovered=visible or ForsakenInspectTarget!=null'
        if 'or BazaarBrowserOpen[GetPlayerId(viewer)]' not in body:
            body=body.replace(line,line+' or BazaarBrowserOpen[GetPlayerId(viewer)]')
        source=put(source,'Forsaken_PollPanels',body)
    if 'BazaarFrame_Init' not in fs:return source
    body=fs['BazaarFrame_Init']
    # Undo only the compact-layout values introduced by our previous adapter.
    for old,new in {
      'FRAMEPOINT_CENTER,.4,.38)':'FRAMEPOINT_CENTER,.4,.3)',
      'BazaarFrameRoot,.79,.42)':'BazaarFrameRoot,.79,.57)',
      'BazaarFrameCard[slot],.245,.30)':'BazaarFrameCard[slot],.245,.425)',
      'BazaarFrameParts[slot],.189,.135)':'BazaarFrameParts[slot],.189,.235)',
      'FRAMEPOINT_BOTTOM,0,.079)':'FRAMEPOINT_BOTTOM,0,.085)',
      'BazaarFrameMore[slot],.215,.025)':'BazaarFrameMore[slot],.215,.030)',
      'FRAMEPOINT_BOTTOMLEFT,.028,.043)':'FRAMEPOINT_BOTTOMLEFT,.028,.047)',
      'BazaarFramePrice[slot],.189,.020)':'BazaarFramePrice[slot],.189,.035)',
      'FRAMEPOINT_BOTTOM,0,.017)':'FRAMEPOINT_BOTTOM,0,.007)',
      'BazaarFrameCraft[slot],.215,.028)':'BazaarFrameCraft[slot],.215,.033)',
      'BazaarFrameRoot,10)':'BazaarFrameRoot,80)',
      'BazaarFrameClose,11)':'BazaarFrameClose,81)'}.items():body=body.replace(old,new)
    import re
    body=re.sub(r'(BlzFrameSetFont\(BazaarFrame(?:Parts|Price)\[slot\],[^\n]+),\.013,0\)',r'\1,.016,0)',body)
    # Keep the original GameUI parent and scale. Only the invisible click
    # surfaces use SIMPLEBUTTON, matching the native console's input system.
    body=body.replace('local framehandle origin=BlzGetFrameByName("ConsoleUIBackdrop",0)',
                      'local framehandle origin=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)')
    body=body.replace('    if origin==null then\n        set origin=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)\n    endif\n','')
    if 'framehandle array BazaarFrameCraftHit' not in source:
        source=source.replace('endglobals','    framehandle array BazaarFrameCraftHit\nendglobals',1)
    if 'BlzLoadTOCFile("war3mapImported' not in body:
        body=body.replace('    local real y\n','    local real y\n    call BlzLoadTOCFile("war3mapImported\\\\BazaarPrepare.toc")\n',1)
    marker='        call BlzFrameSetSize(BazaarFrameCraft[slot],.215,.033)'
    if 'set BazaarFrameCraftHit[slot]=' not in body:
        extra='''
        set BazaarFrameCraftHit[slot]=BlzCreateSimpleFrame("BazaarPrepareHitbox",origin,slot+100)
        call BlzFrameSetSize(BazaarFrameCraftHit[slot],.215,.033)
        call BlzFrameSetAbsPoint(BazaarFrameCraftHit[slot],FRAMEPOINT_BOTTOM,x+.1225,y-.418)
        call BlzFrameSetLevel(BazaarFrameCraftHit[slot],100)
        call BlzFrameSetVisible(BazaarFrameCraftHit[slot],false)
        call BlzTriggerRegisterFrameEvent(gg_trg_Bazaar_FrameClick,BazaarFrameCraftHit[slot],FRAMEEVENT_CONTROL_CLICK)'''
        body=body.replace(marker,marker+'\n'+extra,1)
    source=put(source,'BazaarFrame_Init',body)
    source=put(source,'Bazaar_IngredientPageText',functions(source)['Bazaar_IngredientPageText'].replace('page*9','page*18').replace('page*18+9','page*18+18'))
    source=put(source,'Bazaar_MarkPageText',functions(source)['Bazaar_MarkPageText'].replace('3+page*6','3+page*16').replace('slot+4','slot+14'))
    body=functions(source)['BazaarFrame_Show']
    marker='            call BlzFrameSetVisible(BazaarFrameCard[slot],recipe<=udg_BazaarGoodCount)'
    if 'BlzFrameSetVisible(BazaarFrameCraftHit[slot]' not in body:
        body=body.replace(marker,marker+'\n            call BlzFrameSetVisible(BazaarFrameCraftHit[slot],recipe<=udg_BazaarGoodCount)')
    source=put(source,'BazaarFrame_Show',body)
    body=functions(source)['BazaarFrame_Hide']
    if 'local integer hitSlot=0' not in body:
        body=body.replace('returns nothing\n','returns nothing\n    local integer hitSlot=0\n',1)
        body=body.replace('        call BlzFrameSetVisible(BazaarFrameRoot,false)','''        call BlzFrameSetVisible(BazaarFrameRoot,false)
        loop
            exitwhen hitSlot>=3
            call BlzFrameSetVisible(BazaarFrameCraftHit[hitSlot],false)
            set hitSlot=hitSlot+1
        endloop''',1)
    source=put(source,'BazaarFrame_Hide',body)
    body=functions(source)['BazaarFrame_OnClick']
    body=body.replace('elseif clicked==BazaarFrameCraft[slot] then','elseif clicked==BazaarFrameCraft[slot] or clicked==BazaarFrameCraftHit[slot] then')
    source=put(source,'BazaarFrame_OnClick',body)
    return source
