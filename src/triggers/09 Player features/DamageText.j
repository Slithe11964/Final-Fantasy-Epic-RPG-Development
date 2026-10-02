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

// World Editor calls InitTrig_DamageText automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DamageText (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DamageText takes nothing returns nothing
endfunction

function Register_DamageText_Command takes nothing returns nothing
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

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DamageText takes nothing returns nothing
    call Register_DamageText_Command()
endfunction

endlibrary
