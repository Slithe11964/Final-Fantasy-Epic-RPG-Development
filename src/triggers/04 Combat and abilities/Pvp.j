library TPvp
function Trig_Pvp_Command_Cond_DifferentPlayers takes nothing returns boolean
    return(GetForLoopIndexA()!=GetForLoopIndexB())
endfunction

function Trig_Pvp_Command_Cond_PvpEnabled takes nothing returns boolean
    return(IsTriggerEnabled(gg_trg_War_Command))
endfunction

function Trig_Pvp_Command_Actions takes nothing returns nothing
    if(Trig_Pvp_Command_Cond_PvpEnabled())then
        call DisableTrigger(gg_trg_War_Command)
        call DisableTrigger(gg_trg_Peace_Command)
        call ConditionalTriggerExecute(gg_trg_Init_NeutralPlayer8)
        call ConditionalTriggerExecute(gg_trg_Init_AllyPlayer9)
        call ConditionalTriggerExecute(gg_trg_Init_AllyPlayer10)
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=8
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            set bj_forLoopBIndex=1
            set bj_forLoopBIndexEnd=8
            loop
                exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
                if(Trig_Pvp_Command_Cond_DifferentPlayers())then
                    call SetPlayerAllianceStateBJ(ConvertedPlayer(GetForLoopIndexA()),ConvertedPlayer(GetForLoopIndexB()),bj_ALLIANCE_ALLIED_VISION)
                endif
                set bj_forLoopBIndex=bj_forLoopBIndex+1
            endloop
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call DisplayTextToForce(GetPlayersAll(),(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" disabled PvP. Players can no longer declare war on each other."))
    else
        call EnableTrigger(gg_trg_War_Command)
        call EnableTrigger(gg_trg_Peace_Command)
        call DisplayTextToForce(GetPlayersAll(),(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" enabled PvP. Players can once more declare war on each other."))
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Pvp takes nothing returns nothing
endfunction

function RegisterR11_Pvp_Command takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Pvp_Command=CreateTrigger()

call TriggerRegisterPlayerChatEvent(gg_trg_Pvp_Command,Player(0),"-pvp",true)

call TriggerAddAction(gg_trg_Pvp_Command,function Trig_Pvp_Command_Actions)

endfunction




endlibrary
