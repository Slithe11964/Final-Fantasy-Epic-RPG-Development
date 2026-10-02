library TCam requires TPlayerPart01
function Cam_PanToUnit takes unit u,real duration returns nothing
    call PanCameraToTimed(GetUnitX(u),GetUnitY(u),duration)
endfunction

// ---- Cam ----
function Trig_Cam_Command_Conditions takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,5)=="-cam ")
endfunction

function Trig_Cam_Command_Cond_DistanceInRange takes nothing returns boolean
    return(udg_TempInteger2>$FA)and(udg_TempInteger2<=$BB8) // $FA = 250; $BB8 = 3000
endfunction

function Trig_Cam_Command_Cond_IsReset takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),6,$A)=="reset") // $A = 10
endfunction

function Trig_Cam_Command_Cond_IsLock takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),6,9)=="lock")
endfunction

function Trig_Cam_Command_Actions takes nothing returns nothing
    if(Trig_Cam_Command_Cond_IsLock())then
        call SetCameraTargetControllerNoZForPlayer(GetTriggerPlayer(),Player_GetHero(GetTriggerPlayer()),0,0,false)
    else
        if(Trig_Cam_Command_Cond_IsReset())then
            call ResetToGameCameraForPlayer(GetTriggerPlayer(),.5)
            set udg_CameraDistance[GetConvertedPlayerId(GetTriggerPlayer())]=.0
        else
            set udg_TempInteger2=S2I(SubStringBJ(GetEventPlayerChatString(),6,9))
            if(Trig_Cam_Command_Cond_DistanceInRange())then
                // Udg_TempInteger2 treated as a decimal-capable number.
                call SetCameraFieldForPlayer(GetTriggerPlayer(),CAMERA_FIELD_TARGET_DISTANCE,I2R(udg_TempInteger2),.5)
                // Udg_TempInteger2 treated as a decimal-capable number.
                set udg_CameraDistance[GetConvertedPlayerId(GetTriggerPlayer())]=I2R(udg_TempInteger2)
            endif
        endif
    endif
endfunction

// World Editor calls InitTrig_Cam automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cam (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cam takes nothing returns nothing
endfunction

function Register_Cam_Command takes nothing returns nothing
    set gg_trg_Cam_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(0),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(1),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(2),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(3),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(4),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(5),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(6),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(7),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(8),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player(9),"-cam ",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player($A),"-cam ",false) // $A = 10
    call TriggerRegisterPlayerChatEvent(gg_trg_Cam_Command,Player($B),"-cam ",false) // $B = 11
    call TriggerAddCondition(gg_trg_Cam_Command,Condition(function Trig_Cam_Command_Conditions))
    call TriggerAddAction(gg_trg_Cam_Command,function Trig_Cam_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cam takes nothing returns nothing
    call Register_Cam_Command()
endfunction

endlibrary
