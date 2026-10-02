library TTextSpeed
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_TextSpeed_Command=null
endglobals

function Trig_TextSpeed_Command_Conditions takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,6)=="-text ")
endfunction

function Trig_TextSpeed_Command_Cond_SpeedInRange takes nothing returns boolean
    return(udg_TextSpeed>=100.)and(udg_TextSpeed<=500.)
endfunction

function Trig_TextSpeed_Command_Cond_IsSkipArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-text skip")
endfunction

function Trig_TextSpeed_Command_Cond_IsInstantArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-text instant")
endfunction

function Trig_TextSpeed_Command_Actions takes nothing returns nothing
    if(Trig_TextSpeed_Command_Cond_IsInstantArg())then
        set udg_CinematicsDisabled=false
        set udg_TextSpeed=.0
        call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" changed text speed to |cffffcc00Instant|r"))
    else
        if(Trig_TextSpeed_Command_Cond_IsSkipArg())then
            set udg_CinematicsDisabled=true
            set udg_TextSpeed=.0
            call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" changed text speed to |cffffcc00Skip|r"))
        else
            set udg_CinematicsDisabled=false
            // (100) plus ((50) times ((S2R(SubStringBJ(GetEventPlayerChatString(), 7, 7))) minus (1))).
            set udg_TextSpeed=(100.+(50.*(S2R(SubStringBJ(GetEventPlayerChatString(),7,7))-1)))
            if(Trig_TextSpeed_Command_Cond_SpeedInRange())then
                // (udg_TextSpeed) with its decimal part removed.
                call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+(" changed text speed to |cffffcc00"+(I2S(R2I(udg_TextSpeed))+"wpm|r"))))
            else
                call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" used text speed changing command improperly. Text speed has been set to normal."))
                set udg_TextSpeed=300.
            endif
        endif
    endif
endfunction

// World Editor calls InitTrig_TextSpeed automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_TextSpeed (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_TextSpeed takes nothing returns nothing
endfunction

function Register_TextSpeed_Command takes nothing returns nothing
    set gg_trg_TextSpeed_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSpeed_Command,Player(0),"-text",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSpeed_Command,Player(1),"-text",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSpeed_Command,Player(2),"-text",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSpeed_Command,Player(3),"-text",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSpeed_Command,Player(4),"-text",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSpeed_Command,Player(5),"-text",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSpeed_Command,Player(6),"-text",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextSpeed_Command,Player(7),"-text",false)
    call TriggerAddCondition(gg_trg_TextSpeed_Command,Condition(function Trig_TextSpeed_Command_Conditions))
    call TriggerAddAction(gg_trg_TextSpeed_Command,function Trig_TextSpeed_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_TextSpeed takes nothing returns nothing
    call Register_TextSpeed_Command() // disabled by GameMode
endfunction

endlibrary
