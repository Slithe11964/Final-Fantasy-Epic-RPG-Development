library TDamageText requires TForce
function Trig_DamageText_Command_Cond_InDamageTextForce takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TrackedPlayers))
endfunction

function Trig_DamageText_Command_Cond_DamageTextToggle takes nothing returns boolean
    return(GetEventPlayerChatString()=="-damagetext")
endfunction

function Trig_DamageText_Command_Cond_DamageTextOffArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-damagetext off")
endfunction

function Trig_DamageText_Command_Cond_DamageTextOnArg takes nothing returns boolean
    return(GetEventPlayerChatString()=="-damagetext on")
endfunction

function Trig_DamageText_Command_Cond_DamageTextNowOn takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TrackedPlayers))
endfunction

function Trig_DamageText_Command_Actions takes nothing returns nothing
    if(Trig_DamageText_Command_Cond_DamageTextOnArg())then
        call ForceAddPlayerSimple(GetTriggerPlayer(),udg_TrackedPlayers)
    else
        if(Trig_DamageText_Command_Cond_DamageTextOffArg())then
            call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_TrackedPlayers)
        else
            if(Trig_DamageText_Command_Cond_DamageTextToggle())then
                if(Trig_DamageText_Command_Cond_InDamageTextForce())then
                    call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_TrackedPlayers)
                else
                    call ForceAddPlayerSimple(GetTriggerPlayer(),udg_TrackedPlayers)
                endif
            else
                return
            endif
        endif
    endif
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    if(Trig_DamageText_Command_Cond_DamageTextNowOn())then
        call DisplayTimedTextToForce(udg_TempForce,10.,"Damage Floating Text is now turned on.")
    else
        call DisplayTimedTextToForce(udg_TempForce,10.,"Damage Floating Text is now turned off.")
    endif
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DamageText takes nothing returns nothing
endfunction

function RegisterR11_DamageText_Command takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DamageText_Command=CreateTrigger()

call TriggerRegisterPlayerChatEvent(gg_trg_DamageText_Command,Player(0),"-damagetext",false)

call TriggerRegisterPlayerChatEvent(gg_trg_DamageText_Command,Player(1),"-damagetext",false)

call TriggerRegisterPlayerChatEvent(gg_trg_DamageText_Command,Player(2),"-damagetext",false)

call TriggerRegisterPlayerChatEvent(gg_trg_DamageText_Command,Player(3),"-damagetext",false)

call TriggerRegisterPlayerChatEvent(gg_trg_DamageText_Command,Player(4),"-damagetext",false)

call TriggerRegisterPlayerChatEvent(gg_trg_DamageText_Command,Player(5),"-damagetext",false)

call TriggerRegisterPlayerChatEvent(gg_trg_DamageText_Command,Player(6),"-damagetext",false)

call TriggerRegisterPlayerChatEvent(gg_trg_DamageText_Command,Player(7),"-damagetext",false)

call TriggerAddAction(gg_trg_DamageText_Command,function Trig_DamageText_Command_Actions)

endfunction




endlibrary
