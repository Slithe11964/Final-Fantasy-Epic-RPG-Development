library TBlackPearl
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_BlackPearl_Death=null
endglobals

function Trig_BlackPearl_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$B9 // $B9 = 185
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_BlackPearl automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BlackPearl (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BlackPearl takes nothing returns nothing
endfunction

function Register_BlackPearl_Death takes nothing returns nothing
    set gg_trg_BlackPearl_Death=CreateTrigger()
    call TriggerAddAction(gg_trg_BlackPearl_Death,function Trig_BlackPearl_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BlackPearl takes nothing returns nothing
    call Register_BlackPearl_Death() // used by Hunt_Encounters
endfunction

endlibrary
