library TUnstuck requires TCine, TWait
function Trig_Unstuck_Command_Cond_UnstuckBlocked takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Unstuck_Command_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call Wait_Polled(.2)
    if(Trig_Unstuck_Command_Cond_UnstuckBlocked())then
        call EnableTrigger(GetTriggeringTrigger())
        return
    endif
    call Cine_Enter()
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,90.)
    call Wait_Polled(1.)
    call Cine_Exit()
    call Wait_Polled(30.)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Unstuck takes nothing returns nothing
endfunction

function RegisterR11_Unstuck_Command takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Unstuck_Command=CreateTrigger()

call TriggerRegisterPlayerChatEvent(gg_trg_Unstuck_Command,Player(0),"-unstuck",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Unstuck_Command,Player(1),"-unstuck",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Unstuck_Command,Player(2),"-unstuck",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Unstuck_Command,Player(3),"-unstuck",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Unstuck_Command,Player(4),"-unstuck",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Unstuck_Command,Player(5),"-unstuck",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Unstuck_Command,Player(6),"-unstuck",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Unstuck_Command,Player(7),"-unstuck",true)

call TriggerAddAction(gg_trg_Unstuck_Command,function Trig_Unstuck_Command_Actions)

endfunction




endlibrary
