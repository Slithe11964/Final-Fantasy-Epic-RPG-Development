library TRamuh
function Trig_Ramuh_Setup_Actions takes nothing returns nothing
    set udg_SpecialEffect[48]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n020_0129,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call SetUnitInvulnerable(gg_unit_n020_0129,true)
    call ShowUnitHide(gg_unit_n01Z_0127)
    call PauseUnitBJ(true,gg_unit_n01Z_0127)
    call SetUnitInvulnerable(gg_unit_n01Z_0127,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Ramuh takes nothing returns nothing
endfunction

function RegisterR11_Ramuh_Setup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Ramuh_Setup=CreateTrigger()

call TriggerAddAction(gg_trg_Ramuh_Setup,function Trig_Ramuh_Setup_Actions)

endfunction




endlibrary
