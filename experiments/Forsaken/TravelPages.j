globals
    dialog array TravelDialog
    button array TravelChoice
    integer array TravelPage
    boolean array TravelVisible
    integer array TravelOrder
endglobals

function Travel_Hide takes player owner returns nothing
    local integer pid=GetPlayerId(owner)
    call DialogDisplay(owner,TravelDialog[pid],false)
    set TravelVisible[pid]=false
endfunction

function Travel_Show takes player owner,integer page returns nothing
    local integer pid=GetPlayerId(owner)
    local integer i=1
    local integer count=0
    local integer raw
    local integer total=0
    local integer key=pid*16
    loop
        exitwhen i>udg_TravelCount
        if udg_WarpUnlocked[i] then
            set total=total+1
        endif
        set TravelChoice[key+i]=null
        set i=i+1
    endloop
    if page<0 or page*10>=total then
        set page=0
    endif
    set TravelPage[pid]=page
    call DialogClear(TravelDialog[pid])
    call DialogSetMessage(TravelDialog[pid],"Choose destination - Page "+I2S(page+1)+" / "+I2S(IMaxBJ(1,(total+9)/10)))
    set i=1
    loop
        exitwhen i>udg_TravelCount
        set raw=TravelOrder[i]
        if udg_WarpUnlocked[raw] then
            if count>=page*10 and count<(page+1)*10 then
                set TravelChoice[key+raw]=DialogAddButton(TravelDialog[pid],udg_TravelName[raw],udg_TravelHotkey[raw])
            endif
            set count=count+1
        endif
        set i=i+1
    endloop
    set TravelChoice[key+14]=null
    set TravelChoice[key+15]=null
    if (page+1)*10<total then
        set TravelChoice[key+14]=DialogAddButton(TravelDialog[pid],"Next page",512)
    endif
    if page>0 then
        set TravelChoice[key+15]=DialogAddButton(TravelDialog[pid],"Previous page",512)
    endif
    set TravelChoice[key]=DialogAddButton(TravelDialog[pid],"Cancel",512)
    set TravelVisible[pid]=true
    call DialogDisplay(owner,TravelDialog[pid],true)
endfunction

function Travel_Refresh takes nothing returns nothing
    local integer pid=0
    loop
        exitwhen pid>=8
        if TravelVisible[pid] then
            call Travel_Show(Player(pid),TravelPage[pid])
        endif
        set pid=pid+1
    endloop
endfunction

function Trig_Travel_Dialog_Click_Actions takes nothing returns nothing
    local integer i=1
    local button clicked=GetClickedButton()
    local player owner=GetTriggerPlayer()
    local integer pid=GetPlayerId(owner)
    local integer key=pid*16
    local unit hero=Player_GetHero(owner)
    if clicked!=null and clicked==TravelChoice[key+14] then
        call Travel_Show(owner,TravelPage[pid]+1)
    elseif clicked!=null and clicked==TravelChoice[key+15] then
        call Travel_Show(owner,TravelPage[pid]-1)
    else
        call Travel_Hide(owner)
        loop
            exitwhen i>udg_TravelCount
            if clicked!=null and clicked==TravelChoice[key+i] and udg_WarpUnlocked[i] and hero!=null then
                call DisableTrigger(udg_WarpEnterTrigger)
                call SetUnitX(hero,udg_TravelX[i])
                call SetUnitY(hero,udg_TravelY[i])
                if not udg_InCinematicMode and GetLocalPlayer()==owner then
                    call PanCameraToTimed(udg_TravelX[i],udg_TravelY[i],0)
                endif
                call TriggerSleepAction(.01)
                call EnableTrigger(udg_WarpEnterTrigger)
                exitwhen true
            endif
            set i=i+1
        endloop
    endif
    set clicked=null
    set owner=null
    set hero=null
endfunction

function Register_Travel_Dialog_Click takes nothing returns nothing
    local integer pid=0
    set gg_trg_Travel_Dialog_Click=CreateTrigger()
    // Display order is independent of the permanent destination/unlock indexes.
    set TravelOrder[1]=1
    set TravelOrder[2]=2
    set TravelOrder[3]=3
    set TravelOrder[4]=5
    set TravelOrder[5]=12
    set TravelOrder[6]=6
    set TravelOrder[7]=4
    set TravelOrder[8]=8
    set TravelOrder[9]=7
    set TravelOrder[10]=10
    set TravelOrder[11]=9
    set TravelOrder[12]=11
    set TravelOrder[13]=13
    loop
        exitwhen pid>=8
        set TravelDialog[pid]=DialogCreate()
        call TriggerRegisterDialogEvent(gg_trg_Travel_Dialog_Click,TravelDialog[pid])
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_Travel_Dialog_Click,function Trig_Travel_Dialog_Click_Actions)
endfunction
