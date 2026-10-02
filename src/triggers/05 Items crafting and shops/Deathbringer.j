library TDeathbringer
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Deathbringer_Warning=null
endglobals

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

// World Editor calls InitTrig_Deathbringer automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Deathbringer (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Deathbringer takes nothing returns nothing
endfunction

function Register_Deathbringer_Warning takes nothing returns nothing
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

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Deathbringer takes nothing returns nothing
    call Register_Deathbringer_Warning()
endfunction

endlibrary
