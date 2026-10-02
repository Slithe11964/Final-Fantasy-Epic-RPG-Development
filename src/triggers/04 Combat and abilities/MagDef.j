library TMagDef requires TForce, TPlayerPart01
function Trig_MagDef_Command_Actions takes nothing returns nothing
    set udg_CurrentHero=Player_GetHero(GetTriggerPlayer())
    call ConditionalTriggerExecute(gg_trg_MagicDefense_Calc)
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    // Result 1: udg_MagicDefense at position GetConvertedPlayerId(the triggering player) treated as a
    // decimal-capable number.
    // Result 2: udg_MagicDefense at position GetConvertedPlayerId(the triggering player) treated as a
    // decimal-capable number.
    // Result 3: (result 2) plus (50).
    // Result 4: (result 1) divided by (result 3).
    // Result 5: (result 4) times (100).
    // Result 6: (result 5) with its decimal part removed.
    call DisplayTextToForce(udg_TempForce,(("Your magic defense is "+I2S(udg_MagicDefense[GetConvertedPlayerId(GetTriggerPlayer())]))+(" ("+(I2S(R2I(((I2R(udg_MagicDefense[GetConvertedPlayerId(GetTriggerPlayer())])/(I2R(udg_MagicDefense[GetConvertedPlayerId(GetTriggerPlayer())])+50.))*100.)))+"% reduction)"))))
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_MagDef takes nothing returns nothing
endfunction
function RegisterR11_MagDef_Command takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_MagDef_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_MagDef_Command,Player(0),"-magdef",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_MagDef_Command,Player(1),"-magdef",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_MagDef_Command,Player(2),"-magdef",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_MagDef_Command,Player(3),"-magdef",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_MagDef_Command,Player(4),"-magdef",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_MagDef_Command,Player(5),"-magdef",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_MagDef_Command,Player(6),"-magdef",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_MagDef_Command,Player(7),"-magdef",true)
    call TriggerAddAction(gg_trg_MagDef_Command,function Trig_MagDef_Command_Actions)
endfunction




endlibrary
