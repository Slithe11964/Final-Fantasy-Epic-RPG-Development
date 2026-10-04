library TBrothers requires TWait, optional TQuestEidolonChallenge
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Brothers_Alert_Eidolons=null
    trigger gg_trg_Brothers_Alert_Rematch=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    sound gg_snd_HeroTaurenChieftainYesAttack=null
endglobals

function Trig_Brothers_Alert_Eidolons_Cond_SiegeNotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[9])==false)
endfunction

function Trig_Brothers_Alert_Eidolons_Actions takes nothing returns nothing
    if(Trig_Brothers_Alert_Eidolons_Cond_SiegeNotDone())then
        call StartTimerBJ(udg_SharedDelayTimer4,false,120.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call Wait_Polled(90.)
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffMinotaur has something to tell you !!!|r")
    call PlaySoundBJ(gg_snd_HeroTaurenChieftainYesAttack)
    static if LIBRARY_TQuestEidolonChallenge then
        call ExecuteFunc("QuestEidolonChallenge_Available") // the "!" over Minotaur; the Eidolon Challenge can start
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Brothers_Alert_Rematch_Cond_SiegeIIINotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[$B])==false) // $B = 11
endfunction

function Trig_Brothers_Alert_Rematch_Actions takes nothing returns nothing
    if(Trig_Brothers_Alert_Rematch_Cond_SiegeIIINotDone())then
        call StartTimerBJ(udg_SharedDelayTimer4,false,30.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call Wait_Polled(60.)
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffMinotaur has something to tell you !!!|r")
    call PlaySoundBJ(gg_snd_HeroTaurenChieftainYesAttack)
    set udg_SpecialEffect[53]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ocb2_0147,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_Rematch_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Brothers automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Brothers (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Brothers takes nothing returns nothing
endfunction

function Register_Brothers_Alert_Eidolons takes nothing returns nothing
    set gg_trg_Brothers_Alert_Eidolons=CreateTrigger()
    call DisableTrigger(gg_trg_Brothers_Alert_Eidolons)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Brothers_Alert_Eidolons,udg_SharedDelayTimer4)
    call TriggerAddAction(gg_trg_Brothers_Alert_Eidolons,function Trig_Brothers_Alert_Eidolons_Actions)
endfunction

function Register_Brothers_Alert_Rematch takes nothing returns nothing
    set gg_trg_Brothers_Alert_Rematch=CreateTrigger()
    call DisableTrigger(gg_trg_Brothers_Alert_Rematch)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Brothers_Alert_Rematch,udg_SharedDelayTimer4)
    call TriggerAddAction(gg_trg_Brothers_Alert_Rematch,function Trig_Brothers_Alert_Rematch_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Brothers takes nothing returns nothing
    call Register_Brothers_Alert_Eidolons() // starts off; enabled by Quest_Brothers
    call Register_Brothers_Alert_Rematch() // starts off; enabled by Quest_EidolonChallenge
endfunction

endlibrary
