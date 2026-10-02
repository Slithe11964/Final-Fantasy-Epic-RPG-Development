library TTextInstant
function Trig_TextInstant_Command_Actions takes nothing returns nothing
    set udg_CinematicsDisabled=false
    set udg_TextSpeed=.0
    call DisplayTimedTextToForce(GetPlayersAll(),15.,(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" changed text speed to |cffffcc00Instant|r"))
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_TextInstant takes nothing returns nothing
endfunction
function RegisterR11_TextInstant_Command takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_TextInstant_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(0),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(1),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(2),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(3),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(4),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(5),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(6),"-instant",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_TextInstant_Command,Player(7),"-instant",true)
    call TriggerAddAction(gg_trg_TextInstant_Command,function Trig_TextInstant_Command_Actions)
endfunction




endlibrary
