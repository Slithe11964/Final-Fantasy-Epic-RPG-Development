library TRoll
function Trig_Roll_Command_Actions takes nothing returns nothing
    // A random whole number from 1 through 100.
    call DisplayTimedTextToForce(GetPlayersAll(),15.,((udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" rolled |cffffcc00")+(I2S(GetRandomInt(1,'d'))+"|r (1-100)!")))
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Roll takes nothing returns nothing
endfunction
function RegisterR11_Roll_Command takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Roll_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(0),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(1),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(2),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(3),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(4),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(5),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(6),"-roll",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Roll_Command,Player(7),"-roll",true)
    call TriggerAddAction(gg_trg_Roll_Command,function Trig_Roll_Command_Actions)
endfunction




endlibrary
