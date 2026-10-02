library TGhost
function Trig_Ghost_Despawn_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='u00D') // 'u00D': unit "Death Ghost"
endfunction

function Trig_Ghost_Despawn_Actions takes nothing returns nothing
    call KillUnit(GetTriggerUnit())
    call RemoveUnit(GetTriggerUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Ghost takes nothing returns nothing
endfunction

function RegisterR11_Ghost_Despawn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Ghost_Despawn=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Ghost_Despawn,gg_rct_582)

call TriggerAddCondition(gg_trg_Ghost_Despawn,Condition(function Trig_Ghost_Despawn_Conditions))

call TriggerAddAction(gg_trg_Ghost_Despawn,function Trig_Ghost_Despawn_Actions)

endfunction




endlibrary
