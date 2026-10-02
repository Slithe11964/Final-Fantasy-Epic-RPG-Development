library TBrothers requires TWait
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
    set udg_SpecialEffect[52]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ocb2_0147,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_EidolonChallenge_Start)
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Brothers takes nothing returns nothing
endfunction
function RegisterR11_Brothers_Alert_Eidolons takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Brothers_Alert_Eidolons=CreateTrigger()
    call DisableTrigger(gg_trg_Brothers_Alert_Eidolons)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Brothers_Alert_Eidolons,udg_SharedDelayTimer4)
    call TriggerAddAction(gg_trg_Brothers_Alert_Eidolons,function Trig_Brothers_Alert_Eidolons_Actions)
endfunction
function RegisterR11_Brothers_Alert_Rematch takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Brothers_Alert_Rematch=CreateTrigger()
    call DisableTrigger(gg_trg_Brothers_Alert_Rematch)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Brothers_Alert_Rematch,udg_SharedDelayTimer4)
    call TriggerAddAction(gg_trg_Brothers_Alert_Rematch,function Trig_Brothers_Alert_Rematch_Actions)
endfunction




endlibrary
