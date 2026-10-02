library THandicap requires TForce
function Trig_Handicap_Command_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    call DisplayTimedTextToForce(udg_TempForce,10.,("Enemy base HP: |cffffcc00 "+(R2S(GetPlayerHandicapBJ(Player($B)))+"%|r"))) // $B = 11
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Handicap takes nothing returns nothing
endfunction
function RegisterR11_Handicap_Command takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Handicap_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(0),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(1),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(2),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(3),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(4),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(5),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(6),"-handicap",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Handicap_Command,Player(7),"-handicap",true)
    call TriggerAddAction(gg_trg_Handicap_Command,function Trig_Handicap_Command_Actions)
endfunction




endlibrary
