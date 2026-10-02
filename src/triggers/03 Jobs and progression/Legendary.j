library TLegendary
function Trig_Legendary_Unlock_IsShrineUnlocked takes nothing returns boolean
    return(udg_ShrineUnlocked)
endfunction

function Trig_Legendary_Unlock_Actions takes nothing returns nothing
    set udg_LegendaryUnlocked=true
    call ShowUnitShow(udg_ShrineMenuUnit[18])
    if(Trig_Legendary_Unlock_IsShrineUnlocked())then
        call ShowUnitShow(udg_ShrineMenuUnit[19])
    endif
    call GroupAddUnitSimple(udg_ShrineMenuUnit[19],udg_SecondShrineUnits)
    call AddUnitToStockBJ('n0KL',gg_unit_n04U_0204,1,1) // 'n0KL': unit "Legendary Bonus Menu"
    call AddUnitToStockBJ('n0KL',gg_unit_n04U_0189,1,1) // 'n0KL': unit "Legendary Bonus Menu"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Legendary takes nothing returns nothing
endfunction

function RegisterR11_Legendary_Unlock takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Legendary_Unlock=CreateTrigger()

call DisableTrigger(gg_trg_Legendary_Unlock)

call TriggerAddAction(gg_trg_Legendary_Unlock,function Trig_Legendary_Unlock_Actions)

endfunction




endlibrary
