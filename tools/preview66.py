"""Single readable renderer, event-aware native bag observations, native-style error."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
ROOT=Path(__file__).resolve().parents[1]

def refresh(source):
    fs=functions(source)
    if 'DG_UIUpdate' in fs:
        # Retire the old generic wave renderer while preserving actual Dragoon UI.
        for name,args in [('Wave_Poll','nothing'),('Wave_Draw','unit hero')]:
            source=put(source,name,'function '+name+' takes '+args+' returns nothing\nendfunction')
        body=fs['DG_UIUpdate'].replace(' call Wave_Poll()\n','')
        body=body.replace(' if Wave_Mode>0 then\n call Wave_Draw(u)\n set u=null\n return\n endif\n','')
        assert body!=fs['DG_UIUpdate']
        return put(source,'DG_UIUpdate',body)
    if 'GearInput_Cursor' not in fs:return source
    fragment=(ROOT/'experiments/Forsaken/BagEvent66.j').read_text()
    source=source.replace('endglobals',re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]+'endglobals',1)
    source=source.replace('function BagScreen_Poll65 takes',
        '\n\n'.join(functions(fragment).values())+'\n\nfunction BagScreen_Poll65 takes',1)
    source=put(source,'BagScreen_Poll65','function BagScreen_Poll65 takes nothing returns nothing\n    call BagScreen_Poll66()\nendfunction')
    wave=(ROOT/'experiments/Forsaken/Wave66.j').read_text()
    for name,body in functions(wave).items():
        old=name.replace('Wave66_','Wave65_')
        source=put(source,old,body.replace('function '+name+' takes','function '+old+' takes',1))
    body=fs['QuickGear_Mouse']
    marker='    if GetLocalPlayer()==GetTriggerPlayer() and GetTriggerEventId()==EVENT_PLAYER_MOUSE_MOVE then'
    body=body.replace(marker,'''    if GetLocalPlayer()==GetTriggerPlayer() and GetTriggerEventId()==EVENT_PLAYER_MOUSE_DOWN then
        call BagScreen_Event66()
        if BagHandled66 then
            // Native inventory clicks may retain stale world coordinates.
            // They are never a world target confirmation/cancellation.
            return
        endif
    endif
'''+marker,1)
    source=put(source,'QuickGear_Mouse',body)
    for name in ('GearInput_Init','GearCursor_Error60'):
        body=fs[name].replace('BlzPixelToFrameX(BlzGetLocalClientWidth()/2),.155','.4,.20')
        body=body.replace('GearError65.toc','GearError66.toc').replace('GearGroundError65','GearGroundError66')
        source=put(source,name,body)
    body=fs['QuickGear_Diagnostic'].replace('UI65 F/G:','UI66 F/G:').replace('Hotfix13 F/G:','Hotfix14 F/G:')
    return put(source,'QuickGear_Diagnostic',body)
