library TPeace requires TForce
function Trig_Peace_Command_Conditions takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,7)=="-peace ")and(StringLength(GetEventPlayerChatString())==8)
endfunction

function Trig_Peace_Command_Cond_PeaceTargetAbsent takes nothing returns boolean
    return(GetPlayerSlotState(ConvertedPlayer(udg_AllianceTargetSlot))!=PLAYER_SLOT_STATE_PLAYING)
endfunction

function Trig_Peace_Command_Cond_PeaceTargetMissing takes nothing returns boolean
    return(GetPlayerSlotState(ConvertedPlayer(udg_AllianceTargetSlot))!=PLAYER_SLOT_STATE_PLAYING)
endfunction

function Trig_Peace_Command_Cond_PeaceTargetIsSelf takes nothing returns boolean
    return(udg_AllianceTargetSlot==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Peace_Command_Cond_PeaceOnSelf takes nothing returns boolean
    return(udg_AllianceTargetSlot==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Peace_Command_Cond_PeaceSlotMin takes nothing returns boolean
    return(udg_AllianceTargetSlot>=1)
endfunction

function Trig_Peace_Command_Cond_PeaceSlotMax takes nothing returns boolean
    return(udg_AllianceTargetSlot<=8)
endfunction

function Trig_Peace_Command_Cond_PeaceSlotValid takes nothing returns boolean
    return(GetBooleanAnd(Trig_Peace_Command_Cond_PeaceSlotMin(),Trig_Peace_Command_Cond_PeaceSlotMax()))
endfunction

function Trig_Peace_Command_Actions takes nothing returns nothing
    set udg_AllianceTargetSlot=S2I(SubStringBJ(GetEventPlayerChatString(),8,8))
    if(Trig_Peace_Command_Cond_PeaceSlotValid())then
        if(Trig_Peace_Command_Cond_PeaceTargetAbsent())then
            call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),"Sorry, but the player you want to be in peace with is not present in game.")
        endif
        if(Trig_Peace_Command_Cond_PeaceTargetMissing())then
            return
        endif
        if(Trig_Peace_Command_Cond_PeaceTargetIsSelf())then
            call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),"Sorry, but you can't be in peace with yourself. :)")
        endif
        if(Trig_Peace_Command_Cond_PeaceOnSelf())then
            return
        endif
        call DisplayTextToForce(GetPlayersAll(),(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+(" disallowed himself to attack "+(udg_PlayerName[udg_AllianceTargetSlot]+"."))))
        call SetPlayerAllianceStateBJ(GetTriggerPlayer(),ConvertedPlayer(udg_AllianceTargetSlot),bj_ALLIANCE_ALLIED_VISION)
        set udg_AllianceTargetSlot=0
        call ConditionalTriggerExecute(gg_trg_Job_XP_Handicap)
    else
        call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),"You typed something wrong. Command won't work.")
        set udg_AllianceTargetSlot=0
    endif
endfunction

// World Editor calls InitTrig_Peace automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Peace (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Peace takes nothing returns nothing
endfunction

function Register_Peace_Command takes nothing returns nothing
    set gg_trg_Peace_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Peace_Command,Player(0),"-peace",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Peace_Command,Player(1),"-peace",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Peace_Command,Player(2),"-peace",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Peace_Command,Player(3),"-peace",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Peace_Command,Player(4),"-peace",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Peace_Command,Player(5),"-peace",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Peace_Command,Player(6),"-peace",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_Peace_Command,Player(7),"-peace",false)
    call TriggerAddCondition(gg_trg_Peace_Command,Condition(function Trig_Peace_Command_Conditions))
    call TriggerAddAction(gg_trg_Peace_Command,function Trig_Peace_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Peace takes nothing returns nothing
    call Register_Peace_Command()
endfunction

endlibrary
