library TWar requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_War_Command=null
endglobals

function Trig_War_Command_Conditions takes nothing returns boolean
    return(SubStringBJ(GetEventPlayerChatString(),1,5)=="-war ")and(StringLength(GetEventPlayerChatString())==6)
endfunction

function Trig_War_Command_Cond_WarTargetAbsent takes nothing returns boolean
    return(GetPlayerSlotState(ConvertedPlayer(udg_AllianceTargetSlot))!=PLAYER_SLOT_STATE_PLAYING)
endfunction

function Trig_War_Command_Cond_WarTargetMissing takes nothing returns boolean
    return(GetPlayerSlotState(ConvertedPlayer(udg_AllianceTargetSlot))!=PLAYER_SLOT_STATE_PLAYING)
endfunction

function Trig_War_Command_Cond_WarTargetIsSelf takes nothing returns boolean
    return(udg_AllianceTargetSlot==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_War_Command_Cond_WarOnSelf takes nothing returns boolean
    return(udg_AllianceTargetSlot==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_War_Command_Cond_WarSlotMin takes nothing returns boolean
    return(udg_AllianceTargetSlot>=1)
endfunction

function Trig_War_Command_Cond_WarSlotMax takes nothing returns boolean
    return(udg_AllianceTargetSlot<=8)
endfunction

function Trig_War_Command_Cond_WarSlotValid takes nothing returns boolean
    return(GetBooleanAnd(Trig_War_Command_Cond_WarSlotMin(),Trig_War_Command_Cond_WarSlotMax()))
endfunction

function Trig_War_Command_Actions takes nothing returns nothing
    set udg_AllianceTargetSlot=S2I(SubStringBJ(GetEventPlayerChatString(),6,6))
    if(Trig_War_Command_Cond_WarSlotValid())then
        if(Trig_War_Command_Cond_WarTargetAbsent())then
            call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),"Sorry, but the player you want to be in war with is not present in game.")
        endif
        if(Trig_War_Command_Cond_WarTargetMissing())then
            return
        endif
        if(Trig_War_Command_Cond_WarTargetIsSelf())then
            call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),"Sorry, but you can't be in war with yourself.")
        endif
        if(Trig_War_Command_Cond_WarOnSelf())then
            return
        endif
        call DisplayTextToForce(GetPlayersAll(),(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+(" has declared war on "+(udg_PlayerName[udg_AllianceTargetSlot]+"!"))))
        call SetPlayerAllianceStateBJ(ConvertedPlayer(udg_AllianceTargetSlot),GetTriggerPlayer(),bj_ALLIANCE_UNALLIED_VISION)
        call SetPlayerAllianceStateBJ(GetTriggerPlayer(),ConvertedPlayer(udg_AllianceTargetSlot),bj_ALLIANCE_UNALLIED_VISION)
        set udg_AllianceTargetSlot=0
        call ConditionalTriggerExecute(gg_trg_Job_XP_Handicap)
    else
        call DisplayTextToForce(Force_OfPlayer(GetTriggerPlayer()),"You typed something wrong. Command won't work.")
        set udg_AllianceTargetSlot=0
    endif
endfunction

// World Editor calls InitTrig_War automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_War (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_War takes nothing returns nothing
endfunction

function Register_War_Command takes nothing returns nothing
    set gg_trg_War_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_War_Command,Player(0),"-war",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_War_Command,Player(1),"-war",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_War_Command,Player(2),"-war",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_War_Command,Player(3),"-war",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_War_Command,Player(4),"-war",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_War_Command,Player(5),"-war",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_War_Command,Player(6),"-war",false)
    call TriggerRegisterPlayerChatEvent(gg_trg_War_Command,Player(7),"-war",false)
    call TriggerAddCondition(gg_trg_War_Command,Condition(function Trig_War_Command_Conditions))
    call TriggerAddAction(gg_trg_War_Command,function Trig_War_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_War takes nothing returns nothing
    call Register_War_Command()
endfunction

endlibrary
