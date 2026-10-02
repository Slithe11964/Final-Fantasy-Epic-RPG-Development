library TDebug
function Trig_Debug_ImmortalDeath_Ninja_HasRescueTimer takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='H00F')and(TimerGetRemaining(udg_NinjaImmortalTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])>.0) // 'H00F': unit "Ninja"
endfunction

function Trig_Debug_ImmortalDeath_Unit_IsImmortal takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0ZR',GetTriggerUnit())>0)or(GetUnitAbilityLevelSwapped('A0X2',GetTriggerUnit())>0)or(Trig_Debug_ImmortalDeath_Ninja_HasRescueTimer()) // 'A0ZR': ability "Immortal"; 'A0X2': ability "Perma Cover"
endfunction

function Trig_Debug_ImmortalDeath_Conditions takes nothing returns boolean
    return(GetTriggerUnit()!=null)and(GetKillingUnitBJ()!=null)and(Trig_Debug_ImmortalDeath_Unit_IsImmortal())
endfunction

function Trig_Debug_ImmortalDeath_Actions takes nothing returns nothing
    call DisplayTimedTextToForce(GetPlayersAll(),30,("DEBUG: Immortal unit "+(GetUnitName(GetTriggerUnit())+" just got killed!")))
    call DisplayTimedTextToForce(GetPlayersAll(),30,("TempDamageTaken = "+R2S(udg_LastDamageDealt)))
    call DisplayTimedTextToForce(GetPlayersAll(),30,("Killing Unit = "+GetUnitName(GetKillingUnitBJ())))
    call DisplayTimedTextToForce(GetPlayersAll(),30,("Last Immortal Rescue Damager = "+GetUnitName(udg_ImmortalSource)))
    call DisplayTimedTextToForce(GetPlayersAll(),30,("Last Immortal Rescue Unit = "+GetUnitName(udg_ImmortalUnit)))
    call DisplayTimedTextToForce(GetPlayersAll(),30,("Last Immortal Rescue DMG = "+R2S(udg_ImmortalDamage)))
    call DisplayTimedTextToForce(GetPlayersAll(),30,("Last Immortal Rescue HP = "+R2S(udg_ImmortalLife)))
    call DisplayTimedTextToForce(GetPlayersAll(),30,"Please screenshot this information and post it in our bug reports.")
endfunction

// World Editor calls InitTrig_Debug automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Debug (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Debug takes nothing returns nothing
endfunction

function Register_Debug_ImmortalDeath takes nothing returns nothing
    set gg_trg_Debug_ImmortalDeath=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Debug_ImmortalDeath,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Debug_ImmortalDeath,Condition(function Trig_Debug_ImmortalDeath_Conditions))
    call TriggerAddAction(gg_trg_Debug_ImmortalDeath,function Trig_Debug_ImmortalDeath_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Debug takes nothing returns nothing
    call Register_Debug_ImmortalDeath()
endfunction

endlibrary
