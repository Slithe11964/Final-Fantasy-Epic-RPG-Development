library TMelaiduma requires TMusic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Melaiduma_Death=null
endglobals

function Trig_Melaiduma_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call Music_ClearTrack(37)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]=$B1 // $B1 = 177
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Melaiduma automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Melaiduma (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Melaiduma takes nothing returns nothing
endfunction

function Register_Melaiduma_Death takes nothing returns nothing
    set gg_trg_Melaiduma_Death=CreateTrigger()
    call TriggerAddAction(gg_trg_Melaiduma_Death,function Trig_Melaiduma_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Melaiduma takes nothing returns nothing
    call Register_Melaiduma_Death()
endfunction

endlibrary
