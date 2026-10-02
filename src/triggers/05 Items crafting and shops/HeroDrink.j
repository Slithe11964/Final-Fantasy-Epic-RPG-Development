library THeroDrink requires TMedicine
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HeroDrink_Cast=null
endglobals

function Trig_HeroDrink_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0IP') // 'A0IP': ability "Hero Drink"
endfunction

function Trig_HeroDrink_Cast_Actions takes nothing returns nothing
    call Medicine_ApplyTimed(GetTriggerUnit(),(GetUnitAbilityLevel(GetTriggerUnit(),'A0HL')>0)) // 'A0HL': ability "Pharmacology"
endfunction

// World Editor calls InitTrig_HeroDrink automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HeroDrink (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HeroDrink takes nothing returns nothing
endfunction

function Register_HeroDrink_Cast takes nothing returns nothing
    set gg_trg_HeroDrink_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HeroDrink_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_HeroDrink_Cast,Condition(function Trig_HeroDrink_Cast_Conditions))
    call TriggerAddAction(gg_trg_HeroDrink_Cast,function Trig_HeroDrink_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HeroDrink takes nothing returns nothing
    call Register_HeroDrink_Cast()
endfunction

endlibrary
