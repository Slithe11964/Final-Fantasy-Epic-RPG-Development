library TClear requires TForce
function Trig_Clear_Command_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    call ClearTextMessagesBJ(udg_TempForce)
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Clear takes nothing returns nothing
endfunction
function RegisterR11_Clear_Command takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Clear_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(0),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(1),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(2),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(3),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(4),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(5),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(6),"-clear",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Clear_Command,Player(7),"-clear",true)
    call TriggerAddAction(gg_trg_Clear_Command,function Trig_Clear_Command_Actions)
endfunction




endlibrary
