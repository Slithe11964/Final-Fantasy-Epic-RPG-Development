library TCeleborn
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Celeborn_Summon_Alert=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    sound gg_snd_FurionWarcry=null
endglobals

function Trig_Celeborn_Summon_Alert_Cond_HashmalumNotMet takes nothing returns boolean
    return(udg_HashmalumEncountered==false)
endfunction

function Trig_Celeborn_Summon_Alert_Actions takes nothing returns nothing
    if(Trig_Celeborn_Summon_Alert_Cond_HashmalumNotMet())then
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffCeleborn has something to tell you !!!|r")
        call PlaySoundBJ(gg_snd_FurionWarcry)
        set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Emns_0156,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call GroupAddUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
        call EnableTrigger(gg_trg_Quest_ZodiacAge_Start)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Celeborn automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Celeborn (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Celeborn takes nothing returns nothing
endfunction

function Register_Celeborn_Summon_Alert takes nothing returns nothing
    set gg_trg_Celeborn_Summon_Alert=CreateTrigger()
    call DisableTrigger(gg_trg_Celeborn_Summon_Alert)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Celeborn_Summon_Alert,udg_KalmSiegeTimer)
    call TriggerAddAction(gg_trg_Celeborn_Summon_Alert,function Trig_Celeborn_Summon_Alert_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Celeborn takes nothing returns nothing
    call Register_Celeborn_Summon_Alert() // starts off; enabled by Boss_Zalera
endfunction

endlibrary
