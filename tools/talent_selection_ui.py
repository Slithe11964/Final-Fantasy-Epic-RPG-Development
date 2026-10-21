"""Selected talent borders are local presentation of synchronized talent picks."""
from performance_runtime import put
from jtok import functions

def refresh(source,*,native=False):
    if not native or 'Forsaken_DrawPanels' not in functions(source):return source
    if 'framehandle array ForsakenTalentChosenBorder' not in source:
        source=source.replace('endglobals','    framehandle array ForsakenTalentChosenBorder\nendglobals',1)
    helper='''function Forsaken_UpdateTalentBorder takes unit hero,integer node returns nothing
    call BlzFrameSetVisible(ForsakenTalentChosenBorder[node],node<12 and Talent_Has(hero,node/3+1,ModuloInteger(node,3)+1))
endfunction'''
    if 'Forsaken_UpdateTalentBorder' not in functions(source):source=source.replace('function Forsaken_DrawPanels takes',helper+'\n\nfunction Forsaken_DrawPanels takes',1)
    body=functions(source)['Register_Forsaken_PanelAccess']
    marker='        call BlzFrameSetEnable(ForsakenTalentIcon[node],false)'
    if 'set ForsakenTalentChosenBorder[node]=' not in body:
        extra=r'''
        set ForsakenTalentChosenBorder[node]=BlzCreateFrameByType("BACKDROP","TalentChosenBorder",ForsakenTalentButton[node],"",node+1)
        call BlzFrameSetAllPoints(ForsakenTalentChosenBorder[node],ForsakenTalentButton[node])
        call BlzFrameSetTexture(ForsakenTalentChosenBorder[node],"UI\\Widgets\\Console\\Human\\CommandButton\\human-multipleselection-border.blp",0,true)
        call BlzFrameSetVertexColor(ForsakenTalentChosenBorder[node],BlzConvertColor(255,255,215,0))
        call BlzFrameSetEnable(ForsakenTalentChosenBorder[node],false)
        call BlzFrameSetLevel(ForsakenTalentChosenBorder[node],2)
        call BlzFrameSetVisible(ForsakenTalentChosenBorder[node],false)'''
        body=body.replace(marker,marker+extra,1)
    source=put(source,'Register_Forsaken_PanelAccess',body)
    for name in ['Forsaken_DrawPanels','Forsaken_UpdatePanels']:
        fs=functions(source)
        if name not in fs:continue
        body=fs[name].replace('"Points: "','"Points Earned: "')
        marker='            call BlzFrameSetVisible(ForsakenTalentButton[node],true)'
        if 'call Forsaken_UpdateTalentBorder(hero,node)' not in body:body=body.replace(marker,marker+'\n            call Forsaken_UpdateTalentBorder(hero,node)',1)
        source=put(source,name,body)
    return source
