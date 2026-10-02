library THolyKnight
function Trig_HolyKnight_Setup_Actions takes nothing returns nothing
    call SetUnitInvulnerable(gg_unit_Eill_0119,true)
    call ShowUnitHide(gg_unit_Ewrd_0120)
    call PauseUnitBJ(true,gg_unit_Ewrd_0120)
    call SetUnitInvulnerable(gg_unit_Ewrd_0120,true)
    call UnitAddAbilityBJ('A0VJ',gg_unit_Ewrd_0120) // 'A0VJ': ability "Unaffected by Cinematics"
    call ShowUnitHide(gg_unit_e009_0118)
    call PauseUnitBJ(true,gg_unit_e009_0118)
    call SetUnitInvulnerable(gg_unit_e009_0118,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_HolyKnight takes nothing returns nothing
endfunction

function RegisterR11_HolyKnight_Setup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_HolyKnight_Setup=CreateTrigger()

call TriggerAddAction(gg_trg_HolyKnight_Setup,function Trig_HolyKnight_Setup_Actions)

endfunction




endlibrary
