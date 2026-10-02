library TCaravan
function Trig_Caravan_Init_Actions takes nothing returns nothing
    set udg_CaravanStage=0
    call SetUnitInvulnerable(gg_unit_hrdh_0102,true)
    call SetUnitInvulnerable(gg_unit_hrdh_0103,true)
    call SetUnitInvulnerable(gg_unit_hrdh_0104,true)
    call UnitAddAbilityBJ('A0MV',gg_unit_nggr_0203) // 'A0MV': ability "Plentiful"
    call UnitAddAbilityBJ('A0MV',gg_unit_nstw_0199) // 'A0MV': ability "Plentiful"
    call UnitAddAbilityBJ('A0MV',gg_unit_nrzg_0202) // 'A0MV': ability "Plentiful"
    call UnitAddAbilityBJ('A0MV',gg_unit_nowk_0201) // 'A0MV': ability "Plentiful"
    call UnitAddAbilityBJ('A0MV',gg_unit_ncnk_0197) // 'A0MV': ability "Plentiful"
    call UnitAddAbilityBJ('A0MV',gg_unit_nhrq_0198) // 'A0MV': ability "Plentiful"
    call UnitAddAbilityBJ('A0MV',gg_unit_nmrm_0200) // 'A0MV': ability "Plentiful"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Caravan takes nothing returns nothing
endfunction

function RegisterR11_Caravan_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Caravan_Init=CreateTrigger()

call TriggerAddAction(gg_trg_Caravan_Init,function Trig_Caravan_Init_Actions)

endfunction




endlibrary
