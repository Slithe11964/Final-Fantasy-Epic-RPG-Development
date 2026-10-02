library TEidolonChallenge
function Trig_EidolonChallenge_Setup_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_H01I_0070)
    call PauseUnitBJ(true,gg_unit_H01I_0070)
    call SetUnitInvulnerable(gg_unit_H01I_0070,true)
    call ShowUnitHide(gg_unit_H01J_0069)
    call PauseUnitBJ(true,gg_unit_H01J_0069)
    call SetUnitInvulnerable(gg_unit_H01J_0069,true)
    call ShowUnitHide(gg_unit_H01K_0068)
    call PauseUnitBJ(true,gg_unit_H01K_0068)
    call SetUnitInvulnerable(gg_unit_H01K_0068,true)
    call ShowUnitHide(gg_unit_H01L_0067)
    call PauseUnitBJ(true,gg_unit_H01L_0067)
    call SetUnitInvulnerable(gg_unit_H01L_0067,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_EidolonChallenge takes nothing returns nothing
endfunction
function RegisterR11_EidolonChallenge_Setup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_EidolonChallenge_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_EidolonChallenge_Setup,function Trig_EidolonChallenge_Setup_Actions)
endfunction




endlibrary
