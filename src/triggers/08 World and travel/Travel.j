library TTravel requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Travel_Dialog_Click=null
endglobals

function Travel_AddDestination takes string l_name,rect l_area,integer hk returns nothing
    set udg_TravelCount=udg_TravelCount+1
    set udg_TravelName[udg_TravelCount]=l_name
    set udg_TravelHotkey[udg_TravelCount]=hk
    set udg_TravelX[udg_TravelCount]=GetRectCenterX(l_area)
    set udg_TravelY[udg_TravelCount]=GetRectCenterY(l_area)
    set udg_TravelRegion[udg_TravelCount]=CreateRegion()
    call RegionAddRect(udg_TravelRegion[udg_TravelCount],l_area)
    set udg_WarpUnlocked[udg_TravelCount]=false
endfunction

function Travel_InitDestinations takes nothing returns nothing
    local integer i=1
    set udg_TravelName[0]="Cancel"
    set udg_TravelHotkey[0]=512
    set udg_WarpUnlocked[0]=true
    set udg_TravelCount=0
    call Travel_AddDestination("|cFFFFFFFFK|ralm",gg_rct_398,75)
    call Travel_AddDestination("|cFFFFFFFFG|ruardia Forest",gg_rct_396,71)
    call Travel_AddDestination("|cFFFFFFFFB|rarrens",gg_rct_394,66)
    call Travel_AddDestination("|cFFFFFFFFF|rarm",gg_rct_395,70)
    call Travel_AddDestination("Northern |cFFFFFFFFM|rountain",gg_rct_400,77)
    call Travel_AddDestination("|cFFFFFFFFC|rentral Islands",gg_rct_397,67)
    call Travel_AddDestination("|cFFFFFFFFN|raga Islands",gg_rct_401,78)
    call Travel_AddDestination("|cFFFFFFFFL|rothlorien",gg_rct_399,76)
    call Travel_AddDestination("|cFFFFFFFFI|rcy Realm",gg_rct_403,73)
    call Travel_AddDestination("|cFFFFFFFFD|rark Dragon Marsh",gg_rct_456,68)
    call Travel_AddDestination("|cFFFFFFFFE|rlysium",gg_rct_402,69)
endfunction

// ---- Travel ----
function Trig_Travel_Dialog_Click_Actions takes nothing returns nothing
    local integer i=1
    local button l_clicked=GetClickedButton()
    local player p=GetTriggerPlayer()
    local unit u=Player_GetHero(p)
    if l_clicked==udg_TravelButton[0]then
        call DialogDisplay(p,udg_WarpDialog,false)
        set l_clicked=null
        set p=null
        set u=null
        return
    endif
    call DisableTrigger(udg_WarpEnterTrigger)
    loop
        exitwhen i>udg_TravelCount
        if l_clicked==udg_TravelButton[i]then
            call SetUnitX(u,udg_TravelX[i])
            call SetUnitY(u,udg_TravelY[i])
            if(not udg_InCinematicMode and GetLocalPlayer()==p)then
                call PanCameraToTimed(udg_TravelX[i],udg_TravelY[i],0)
            endif
            call DialogDisplay(p,udg_WarpDialog,false)
            set l_clicked=null
            set p=null
            set u=null
            call TriggerSleepAction(.01)
            call EnableTrigger(udg_WarpEnterTrigger)
            return
        endif
        set i=i+1
    endloop
    call DialogDisplay(p,udg_WarpDialog,false)
    set l_clicked=null
    set p=null
    set u=null
    call EnableTrigger(udg_WarpEnterTrigger)
endfunction

// World Editor calls InitTrig_Travel automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Travel (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Travel takes nothing returns nothing
endfunction

function Register_Travel_Dialog_Click takes nothing returns nothing
    set gg_trg_Travel_Dialog_Click=CreateTrigger()
    call TriggerRegisterDialogEvent(gg_trg_Travel_Dialog_Click,udg_WarpDialog)
    call TriggerAddAction(gg_trg_Travel_Dialog_Click,function Trig_Travel_Dialog_Click_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Travel takes nothing returns nothing
    call Register_Travel_Dialog_Click()
endfunction

endlibrary
