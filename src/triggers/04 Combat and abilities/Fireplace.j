library TFireplace
function Trig_Fireplace_Init_Actions takes nothing returns nothing
    call UnitRemoveAbilityBJ('Aneu',gg_unit_n0KG_0263) // 'Aneu': standard ability reference "Neutral Building"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Fireplace takes nothing returns nothing
endfunction
function RegisterR11_Fireplace_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Fireplace_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Fireplace_Init,function Trig_Fireplace_Init_Actions)
endfunction




endlibrary
