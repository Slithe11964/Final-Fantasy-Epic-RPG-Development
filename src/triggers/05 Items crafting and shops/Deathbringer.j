library TDeathbringer
function Trig_Deathbringer_Warning_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0EQ')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)) // 'I0EQ': item "Deathbringer"
endfunction

function Trig_Deathbringer_Warning_Cond_EternityMode takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Deathbringer_Warning_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Deathbringer_Warning_Cond_EternityMode())then
        call DisplayTimedTextToForce(GetPlayersAll(),30.,"|cffff0000Warning:|r Deathbringer cannot instantly kill normal enemies in Eternity Mode.")
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Deathbringer takes nothing returns nothing
endfunction

function RegisterR11_Deathbringer_Warning takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Deathbringer_Warning=CreateTrigger()

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Deathbringer_Warning,Player(0),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Deathbringer_Warning,Player(1),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Deathbringer_Warning,Player(2),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Deathbringer_Warning,Player(3),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Deathbringer_Warning,Player(4),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Deathbringer_Warning,Player(5),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Deathbringer_Warning,Player(6),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Deathbringer_Warning,Player(7),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Deathbringer_Warning,Condition(function Trig_Deathbringer_Warning_Conditions))

call TriggerAddAction(gg_trg_Deathbringer_Warning,function Trig_Deathbringer_Warning_Actions)

endfunction




endlibrary
