library TSeekers
function Trig_Seekers_TrackEngaged_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_SeekerLeaders))and(IsUnitInGroup(GetTriggerUnit(),udg_BossUnits)==false)
endfunction

function Trig_Seekers_TrackEngaged_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetTriggerUnit(),udg_BossUnits)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Seekers takes nothing returns nothing
endfunction
function RegisterR11_Seekers_TrackEngaged takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Seekers_TrackEngaged=CreateTrigger()
    call DisableTrigger(gg_trg_Seekers_TrackEngaged)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Seekers_TrackEngaged,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Seekers_TrackEngaged,Condition(function Trig_Seekers_TrackEngaged_Conditions))
    call TriggerAddAction(gg_trg_Seekers_TrackEngaged,function Trig_Seekers_TrackEngaged_Actions)
endfunction




endlibrary
