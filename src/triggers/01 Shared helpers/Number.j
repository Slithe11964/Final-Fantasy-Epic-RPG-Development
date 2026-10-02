library TNumber requires TForce
function Trig_Number_Command_Actions takes nothing returns nothing
    call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),("Your number is: "+I2S(GetConvertedPlayerId(GetTriggerPlayer()))))
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Number takes nothing returns nothing
endfunction

function RegisterR11_Number_Command takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Number_Command=CreateTrigger()

call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(0),"-number",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(1),"-number",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(2),"-number",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(3),"-number",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(4),"-number",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(5),"-number",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(6),"-number",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Number_Command,Player(7),"-number",true)

call TriggerAddAction(gg_trg_Number_Command,function Trig_Number_Command_Actions)

endfunction




endlibrary
