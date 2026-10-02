library TCeleborn
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Celeborn takes nothing returns nothing
endfunction
function RegisterR11_Celeborn_Summon_Alert takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Celeborn_Summon_Alert=CreateTrigger()
    call DisableTrigger(gg_trg_Celeborn_Summon_Alert)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Celeborn_Summon_Alert,udg_KalmSiegeTimer)
    call TriggerAddAction(gg_trg_Celeborn_Summon_Alert,function Trig_Celeborn_Summon_Alert_Actions)
endfunction




endlibrary
