globals
    framehandle array GearProbe62
    hashtable GearProbeSlots62=InitHashtable()
    trigger GearProbeEvents62=null
    integer GearProbeCurrent62=-1
    integer GearProbeCast62=0
    integer GearProbeRaw62=0
    unit GearProbeHero62=null
    boolean GearProbeDown62=false
    boolean GearProbeShown62=false
    framehandle GearProbeBag62=null
    real GearProbeWidth62=0.
    real GearProbeHeight62=0.
    integer GearProbeEnters62=0
    integer GearProbeArms62=0
endglobals

function GearProbe_World62 takes nothing returns nothing
    if not BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT) then
        if GearProbeCurrent62>=0 then
            call BlzFrameSetEnable(GearProbe62[GearProbeCurrent62],true)
        endif
        set GearProbeCurrent62=-1
        set GearProbeCast62=0
        set GearProbeHero62=null
    endif
endfunction

function GearProbe_Enter62 takes nothing returns nothing
    local framehandle control=BlzGetTriggerFrame()
    local integer slot=LoadInteger(GearProbeSlots62,0,GetHandleId(control))-1
    local unit hero=null
    local item carried=null
    if GetTriggerPlayer()==GetLocalPlayer() and slot>=0 and slot<30 then
        // Release mouse control first. Native inventory receives the real click
        // and remains responsible for tooltip, cursor and actual item cast.
        call BlzFrameSetEnable(control,false)
        if GearProbeCurrent62>=0 and GearProbeCurrent62!=slot then
            call BlzFrameSetEnable(GearProbe62[GearProbeCurrent62],true)
        endif
        set GearProbeCurrent62=slot
        set GearProbeEnters62=GearProbeEnters62+1
        set hero=Player_GetHero(GetLocalPlayer())
        set carried=BlzUnitItemInBagSlot(hero,slot)
        set GearProbeHero62=hero
        set GearProbeRaw62=GetItemTypeId(carried)
        set GearProbeCast62=LoadInteger(GearInputSpells,0,GearProbeRaw62)
        if GearProbeCast62==0 then
            set GearProbeCast62=LoadInteger(QuickGearData,0,GearProbeRaw62)
        endif
        if GearWave_ModeFor(GearProbeCast62)==0 then
            set GearProbeCast62=0
        endif
    endif
    set carried=null
    set hero=null
    set control=null
endfunction

function GearProbe_Poll62 takes nothing returns nothing
    local framehandle bag=ForsakenLinkedBag
    local unit hero=Player_GetHero(GetLocalPlayer())
    local boolean down=BlzIsMouseButtonPressed(MOUSE_BUTTON_TYPE_LEFT)
    local boolean show=bag!=null and hero!=null and IsUnitSelected(hero,GetLocalPlayer()) and not QuickGearChatOpen and not InventoryCinematicActive and BlzIsLocalClientActive()
    local real width=0.
    local real height=0.
    local real cellX=0.
    local real cellY=0.
    local integer slot=0
    if show then
        set show=BlzFrameIsVisible(bag)
    endif
    if show then
        set width=BlzFrameGetWidth(bag)
        set height=BlzFrameGetHeight(bag)
        if bag!=GearProbeBag62 or width!=GearProbeWidth62 or height!=GearProbeHeight62 then
            set GearProbeBag62=bag
            set GearProbeWidth62=width
            set GearProbeHeight62=height
            set cellX=RMaxBJ(.001,(width-.02)/6.)
            set cellY=RMaxBJ(.001,(height-.02)/5.)
            loop
                exitwhen slot>=30
                call BlzFrameClearAllPoints(GearProbe62[slot])
                call BlzFrameSetPoint(GearProbe62[slot],FRAMEPOINT_TOPLEFT,bag,FRAMEPOINT_TOPLEFT,.01+I2R(ModuloInteger(slot,6))*cellX,-.01-I2R(slot/6)*cellY)
                call BlzFrameSetSize(GearProbe62[slot],cellX,cellY)
                set slot=slot+1
            endloop
        endif
    endif
    if show!=GearProbeShown62 then
        set slot=0
        loop
            exitwhen slot>=30
            call BlzFrameSetVisible(GearProbe62[slot],show)
            call BlzFrameSetEnable(GearProbe62[slot],true)
            set slot=slot+1
        endloop
        set GearProbeShown62=show
        set GearProbeCurrent62=-1
        set GearProbeCast62=0
    endif
    if down and not GearProbeDown62 and show and GearProbeCurrent62>=0 and GearProbeCast62!=0 and hero==GearProbeHero62 then
        if GetItemTypeId(BlzUnitItemInBagSlot(hero,GearProbeCurrent62))==GearProbeRaw62 then
            set QuickGearPending=-1
            call QuickGear_ClearPreview()
            call GearWave_Arm(GearProbeCast62)
            set GearInputArmedAt=TimerGetElapsed(NativeCDClock)
            set GearProbeArms62=GearProbeArms62+1
        endif
    endif
    set GearProbeDown62=down
    set hero=null
    set bag=null
endfunction

function GearProbe_Reset62 takes nothing returns nothing
    local integer slot=0
    if GearProbeEvents62!=null then
        call DestroyTrigger(GearProbeEvents62)
        set GearProbeEvents62=null
    endif
    loop
        exitwhen slot>=30
        if GearProbe62[slot]!=null then
            call BlzDestroyFrame(GearProbe62[slot])
        endif
        set GearProbe62[slot]=null
        set slot=slot+1
    endloop
    call FlushParentHashtable(GearProbeSlots62)
    set GearProbeCurrent62=-1
    set GearProbeCast62=0
    set GearProbeHero62=null
    set GearProbeDown62=false
    set GearProbeShown62=false
    set GearProbeBag62=null
endfunction

function GearProbe_Init62 takes nothing returns nothing
    local integer slot=0
    local framehandle origin=BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0)
    set GearProbeEvents62=CreateTrigger()
    call TriggerAddAction(GearProbeEvents62,function GearProbe_Enter62)
    loop
        exitwhen slot>=30
        set GearProbe62[slot]=BlzCreateFrameByType("BUTTON","GearBagProbe62",origin,"",620+slot)
        call BlzFrameSetAlpha(GearProbe62[slot],0)
        call BlzFrameSetLevel(GearProbe62[slot],40)
        call BlzFrameSetVisible(GearProbe62[slot],false)
        call SaveInteger(GearProbeSlots62,0,GetHandleId(GearProbe62[slot]),slot+1)
        call BlzTriggerRegisterFrameEvent(GearProbeEvents62,GearProbe62[slot],FRAMEEVENT_MOUSE_ENTER)
        set slot=slot+1
    endloop
    set origin=null
endfunction
