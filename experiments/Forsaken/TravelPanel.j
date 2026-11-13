globals
    framehandle TravelPanel=null
    framehandle TravelPanelTitle=null
    framehandle array TravelPanelButton
endglobals

function TravelPanel_Render takes player owner returns nothing
    local integer pid=GetPlayerId(owner)
    local integer i=0
    local integer raw
    local integer count=0
    local integer row=0
    local integer total=0
    local string label
    loop
        exitwhen i>15
        if TravelPanelButton[i]!=null then
            call BlzFrameSetVisible(TravelPanelButton[i],false)
        endif
        set i=i+1
    endloop
    set i=1
    loop
        exitwhen i>udg_TravelCount
        set raw=TravelOrder[i]
        if udg_WarpUnlocked[raw] then
            set total=total+1
            if count>=TravelPage[pid]*10 and count<(TravelPage[pid]+1)*10 then
                set label=udg_TravelName[raw]
                if total>0 and raw==10 then
                    set label="Dark Dragon Marsh [J]"
                elseif raw==13 then
                    set label="Arena of Darkness [O]"
                endif
                call BlzFrameSetText(TravelPanelButton[raw],label)
                call BlzFrameClearAllPoints(TravelPanelButton[raw])
                call BlzFrameSetPoint(TravelPanelButton[raw],FRAMEPOINT_TOPLEFT,TravelPanel,FRAMEPOINT_TOPLEFT,.03,-.06-I2R(row)*.04)
                call BlzFrameSetVisible(TravelPanelButton[raw],true)
                set row=row+1
            endif
            set count=count+1
        endif
        set i=i+1
    endloop
    if (TravelPage[pid]+1)*10<total then
        call BlzFrameClearAllPoints(TravelPanelButton[14])
        call BlzFrameSetPoint(TravelPanelButton[14],FRAMEPOINT_TOPLEFT,TravelPanel,FRAMEPOINT_TOPLEFT,.03,-.06-I2R(row)*.04)
        call BlzFrameSetVisible(TravelPanelButton[14],true)
        set row=row+1
    endif
    if TravelPage[pid]>0 then
        call BlzFrameClearAllPoints(TravelPanelButton[15])
        call BlzFrameSetPoint(TravelPanelButton[15],FRAMEPOINT_TOPLEFT,TravelPanel,FRAMEPOINT_TOPLEFT,.03,-.06-I2R(row)*.04)
        call BlzFrameSetVisible(TravelPanelButton[15],true)
        set row=row+1
    endif
    call BlzFrameClearAllPoints(TravelPanelButton[0])
    call BlzFrameSetPoint(TravelPanelButton[0],FRAMEPOINT_TOPLEFT,TravelPanel,FRAMEPOINT_TOPLEFT,.03,-.06-I2R(row)*.04)
    call BlzFrameSetVisible(TravelPanelButton[0],true)
    call BlzFrameSetSize(TravelPanel,.288,.072+I2R(row+1)*.04)
    call BlzFrameSetText(TravelPanelTitle,"Choose destination - Page "+I2S(TravelPage[pid]+1)+" / "+I2S(IMaxBJ(1,(total+9)/10)))
    call BlzFrameSetVisible(TravelPanel,true)
endfunction

function Travel_Show takes player owner,integer page returns nothing
    local integer pid=GetPlayerId(owner)
    local integer total=0
    local integer i=1
    loop
        exitwhen i>udg_TravelCount
        if udg_WarpUnlocked[i] then
            set total=total+1
        endif
        set i=i+1
    endloop
    if page<0 or page*10>=total then
        set page=0
    endif
    if TravelPanel==null then
        return
    endif
    // The native modal dialog swallows Escape: never display it in this profile.
    call DialogDisplay(owner,TravelDialog[pid],false)
    set TravelPage[pid]=page
    set TravelEscapeEpoch[pid]=TravelEscapeEpoch[pid]+1
    set TravelVisible[pid]=true
    if GetLocalPlayer()==owner then
        call TravelPanel_Render(owner)
    endif
endfunction

function TravelPanel_Request takes integer choice returns nothing
    local player owner=GetTriggerPlayer()
    local integer pid=GetPlayerId(owner)
    if GetLocalPlayer()==owner and pid>=0 and pid<8 and TravelVisible[pid] then
        call BlzSendSyncData("FFTravelPick",I2S(TravelEscapeEpoch[pid])+":"+I2S(choice))
    endif
    set owner=null
endfunction

function TravelPanel_Click takes nothing returns nothing
    local integer i=0
    local framehandle clicked=BlzGetTriggerFrame()
    loop
        exitwhen i>15
        if clicked==TravelPanelButton[i] then
            if GetLocalPlayer()==GetTriggerPlayer() then
                call BlzFrameSetEnable(clicked,false)
                call BlzFrameSetEnable(clicked,true)
            endif
            call TravelPanel_Request(i)
            exitwhen true
        endif
        set i=i+1
    endloop
    set clicked=null
endfunction

function TravelPanel_Key takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local integer pid=GetPlayerId(owner)
    local integer key=GetHandleId(BlzGetTriggerPlayerKey())
    local integer i=1
    local integer raw
    local integer count=0
    local integer hotkey
    if GetLocalPlayer()!=owner or pid<0 or pid>=8 or not TravelVisible[pid] then
        set owner=null
        return
    endif
    if QuickGearChatOpen and key!=27 then
        set owner=null
        return
    endif
    if key==27 then
        call TravelPanel_Request(0)
    elseif key==68 then
        call TravelPanel_Request(14)
    elseif key==65 then
        call TravelPanel_Request(15)
    else
        loop
            exitwhen i>udg_TravelCount
            set raw=TravelOrder[i]
            if udg_WarpUnlocked[raw] then
                if count>=TravelPage[pid]*10 and count<(TravelPage[pid]+1)*10 then
                    set hotkey=udg_TravelHotkey[raw]
                    if raw==10 then
                        set hotkey=74
                    elseif raw==13 then
                        set hotkey=79
                    endif
                    if key==hotkey then
                        call TravelPanel_Request(raw)
                        exitwhen true
                    endif
                endif
                set count=count+1
            endif
            set i=i+1
        endloop
    endif
    set owner=null
endfunction

function TravelPanel_Choose takes player owner,integer choice returns nothing
    local integer pid=GetPlayerId(owner)
    local integer i=1
    local integer raw
    local integer count=0
    local integer total=0
    local boolean valid=false
    local unit hero=Player_GetHero(owner)
    loop
        exitwhen i>udg_TravelCount
        set raw=TravelOrder[i]
        if udg_WarpUnlocked[raw] then
            set total=total+1
            if count>=TravelPage[pid]*10 and count<(TravelPage[pid]+1)*10 and raw==choice then
                set valid=true
            endif
            set count=count+1
        endif
        set i=i+1
    endloop
    if choice==0 then
        call Travel_Hide(owner)
    elseif choice==14 then
        if (TravelPage[pid]+1)*10<total then
            call Travel_Show(owner,TravelPage[pid]+1)
        endif
    elseif choice==15 then
        if TravelPage[pid]>0 then
            call Travel_Show(owner,TravelPage[pid]-1)
        endif
    elseif valid and hero!=null and not udg_InCinematicMode then
        call Travel_Hide(owner)
        call DisableTrigger(udg_WarpEnterTrigger)
        call SetUnitX(hero,udg_TravelX[choice])
        call SetUnitY(hero,udg_TravelY[choice])
        if GetLocalPlayer()==owner then
            call PanCameraToTimed(udg_TravelX[choice],udg_TravelY[choice],0.)
        endif
        call TriggerSleepAction(.01)
        call EnableTrigger(udg_WarpEnterTrigger)
    endif
    set hero=null
endfunction

function TravelPanel_Sync takes nothing returns nothing
    local player owner=GetTriggerPlayer()
    local integer pid=GetPlayerId(owner)
    local string data=BlzGetTriggerSyncData()
    local integer split=0
    loop
        exitwhen split>=StringLength(data) or SubString(data,split,split+1)==":"
        set split=split+1
    endloop
    if pid>=0 and pid<8 and TravelVisible[pid] and split<StringLength(data) and S2I(SubString(data,0,split))==TravelEscapeEpoch[pid] then
        call TravelPanel_Choose(owner,S2I(SubString(data,split+1,StringLength(data))))
    endif
    set owner=null
endfunction

function TravelPanel_Init takes nothing returns nothing
    local integer i=0
    local integer pid=0
    local integer key=65
    local trigger clicks=CreateTrigger()
    local trigger keys=CreateTrigger()
    local trigger sync=CreateTrigger()
    call DestroyTimer(GetExpiredTimer())
    call BlzLoadTOCFile("TravelUI\\TravelDialog.toc")
    set TravelPanel=BlzCreateFrame("TravelDialogBackdrop",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
    call BlzFrameSetAbsPoint(TravelPanel,FRAMEPOINT_CENTER,.4,.3)
    call BlzFrameSetLevel(TravelPanel,12)
    set TravelPanelTitle=BlzCreateFrame("TravelDialogTitle",TravelPanel,0,0)
    call BlzFrameSetPoint(TravelPanelTitle,FRAMEPOINT_TOP,TravelPanel,FRAMEPOINT_TOP,0.,-.03)
    call BlzFrameSetText(TravelPanelTitle,"Choose destination")
    loop
        exitwhen i>15
        set TravelPanelButton[i]=BlzCreateFrame("ScriptDialogButton",TravelPanel,0,i)
        call BlzFrameSetSize(TravelPanelButton[i],.228,.035)
        call BlzFrameSetVisible(TravelPanelButton[i],false)
        call BlzTriggerRegisterFrameEvent(clicks,TravelPanelButton[i],FRAMEEVENT_CONTROL_CLICK)
        set i=i+1
    endloop
    call BlzFrameSetText(TravelPanelButton[0],"Cancel [Esc]")
    call BlzFrameSetText(TravelPanelButton[14],"Next page [D]")
    call BlzFrameSetText(TravelPanelButton[15],"Previous page [A]")
    call BlzFrameSetVisible(TravelPanel,false)
    loop
        exitwhen pid>=8
        call BlzTriggerRegisterPlayerSyncEvent(sync,Player(pid),"FFTravelPick",false)
        call BlzTriggerRegisterPlayerKeyEvent(keys,Player(pid),OSKEY_ESCAPE,0,true)
        set key=65
        loop
            exitwhen key>90
            call BlzTriggerRegisterPlayerKeyEvent(keys,Player(pid),ConvertOsKeyType(key),0,true)
            set key=key+1
        endloop
        set pid=pid+1
    endloop
    call TriggerAddAction(clicks,function TravelPanel_Click)
    call TriggerAddAction(keys,function TravelPanel_Key)
    call TriggerAddAction(sync,function TravelPanel_Sync)
    set clicks=null
    set keys=null
    set sync=null
endfunction
