library TSaveDebug
function Trig_SaveDebug_Command_Cond_DebugOff takes nothing returns boolean
    return(udg_SaveDebug==false)
endfunction

function Trig_SaveDebug_Command_Actions takes nothing returns nothing
    if(Trig_SaveDebug_Command_Cond_DebugOff())then
        set udg_SaveDebug=true
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"Save debug logging enabled.")
    else
        set udg_SaveDebug=false
        call DisplayTimedTextToForce(GetPlayersAll(),15.,"Save debug logging disabled.")
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_SaveDebug takes nothing returns nothing
endfunction
function RegisterR11_SaveDebug_Command takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_SaveDebug_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(0),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(1),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(2),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(3),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(4),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(5),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(6),"-sdebug",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_SaveDebug_Command,Player(7),"-sdebug",true)
    call TriggerAddAction(gg_trg_SaveDebug_Command,function Trig_SaveDebug_Command_Actions)
endfunction




endlibrary
