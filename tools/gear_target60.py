"""Stock cursor artwork, faster presentation, empty-ground feedback, native skin fallback."""
from jtok import functions
from performance_runtime import put

HELPERS='''function GearCursor_Error60 takes string message returns nothing
    if GearCursorError60!=null then
        call BlzFrameSetText(GearCursorError60,message)
        call BlzFrameSetVisible(GearCursorError60,true)
        set GearCursorErrorUntil60=TimerGetElapsed(NativeCDClock)+2.
        if gg_snd_InterfaceError!=null then
            call StartSound(gg_snd_InterfaceError)
        endif
    endif
endfunction

function GearCursor_Draw60 takes nothing returns nothing
    if GearInputTarget or GearCursorWasShown60 then
        call GearInput_Cursor()
        set GearCursorWasShown60=GearInputTarget and QuickGearPending>=0
    endif
    if GearCursorErrorUntil60>0. and TimerGetElapsed(NativeCDClock)>=GearCursorErrorUntil60 then
        call BlzFrameSetVisible(GearCursorError60,false)
        set GearCursorErrorUntil60=0.
    endif
endfunction'''

SKIN='''function DG_GraphicsSkin60 takes unit hero returns nothing
    // One shared skin identity; the game's file:sd/file:hd/file:de entries pick
    // the actual art independently on each client. No graphics-dependent units.
    if hero!=null and GetUnitTypeId(hero)=='H00C' and BlzGetUnitSkin(hero)!='hctg' then
        call BlzSetUnitSkin(hero,'hctg')
    endif
endfunction'''


def refresh(source):
    fs=functions(source)
    if 'DG_Tick' in fs:
        source=source.replace('function DG_Tick takes',SKIN+'\n\nfunction DG_Tick takes',1)
        body=fs['DG_Tick'];marker=' set u=Player_GetHero(Player(p))'
        assert body.count(marker)==1
        source=put(source,'DG_Tick',body.replace(marker,marker+'\n call DG_GraphicsSkin60(u)',1))
    if 'GearInput_Cursor' not in fs:return source
    source=source.replace('endglobals','''    timer GearCursorTimer60=null
    framehandle GearCursorError60=null
    real GearCursorErrorUntil60=0.
    boolean GearCursorWasShown60=false
endglobals''',1)
    source=source.replace('function GearInput_Hover takes',HELPERS+'\n\nfunction GearInput_Hover takes',1)
    body=fs['GearInput_Init']
    old='''    set GearInputCursor=BlzCreateFrameByType("BACKDROP","GearInputTarget58",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetTexture(GearInputCursor,"QuickGearTarget.tga",0,true)'''
    new='''    call BlzLoadTOCFile("GearTarget60.toc")
    set GearInputCursor=BlzCreateSimpleFrame("GearTargetCursor60",BlzGetOriginFrame(ORIGIN_FRAME_SIMPLE_UI_PARENT,0),660)
    call BlzFrameSetVertexColor(BlzGetFrameByName("GearTargetTexture60",660),BlzConvertColor(255,35,190,195))'''
    assert old in body
    body=body.replace(old,new,1)
    body=body.replace('    set GearInputHover=CreateTrigger()', '''    set GearCursorError60=BlzCreateFrameByType("TEXT","GearCursorError60",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetAbsPoint(GearCursorError60,FRAMEPOINT_CENTER,.4,.18)
    call BlzFrameSetSize(GearCursorError60,.48,.03)
    call BlzFrameSetFont(GearCursorError60,"Fonts\\\\FRIZQT__.TTF",.016,0)
    call BlzFrameSetTextColor(GearCursorError60,BlzConvertColor(255,255,60,50))
    call BlzFrameSetTextAlignment(GearCursorError60,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
    call BlzFrameSetEnable(GearCursorError60,false)
    call BlzFrameSetVisible(GearCursorError60,false)
    set GearCursorTimer60=CreateTimer()
    call TimerStart(GearCursorTimer60,.01,true,function GearCursor_Draw60)
    set GearInputHover=CreateTrigger()''',1)
    source=put(source,'GearInput_Init',body)
    body=fs['GearInput_Reset']
    body=body.replace('    set GearInputTarget=false','''    if GearCursorTimer60!=null then
        call PauseTimer(GearCursorTimer60)
        call DestroyTimer(GearCursorTimer60)
        set GearCursorTimer60=null
    endif
    if GearCursorError60!=null then
        call BlzDestroyFrame(GearCursorError60)
        set GearCursorError60=null
    endif
    set GearCursorErrorUntil60=0.
    set GearCursorWasShown60=false
    set GearInputTarget=false''',1)
    source=put(source,'GearInput_Reset',body)
    body=fs['QuickGear_Mouse'];marker='            call QuickGear_Send(QuickGearPending,'
    at=body.index(marker)
    body=body[:at]+'''            if target==null and LoadInteger(QuickGearData,1,QuickGearPendingItem)==1 then
                call GearCursor_Error60("Must target a unit with this action.")
                // Keep the item armed: the next valid unit click can cast.
                return
            endif
'''+body[at:]
    source=put(source,'QuickGear_Mouse',body)
    body=fs['QuickGear_Diagnostic'].replace('UI58 F/G:','UI60 F/G:').replace('Hotfix06 F/G:','Hotfix08 F/G:')
    return put(source,'QuickGear_Diagnostic',body)
