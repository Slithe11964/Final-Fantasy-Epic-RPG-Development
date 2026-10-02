library TShinra
function Trig_Shinra_TalkPrepare_Actions takes nothing returns nothing
    set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_DimensionalBoundary_Start)
    call AddItemToStockBJ('I08Q',gg_unit_n02Y_0052,1,1) // 'I08Q': item "Information: Al Bhed Child"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Shinra takes nothing returns nothing
endfunction

function RegisterR11_Shinra_TalkPrepare takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Shinra_TalkPrepare=CreateTrigger()

call DisableTrigger(gg_trg_Shinra_TalkPrepare)

call TriggerAddAction(gg_trg_Shinra_TalkPrepare,function Trig_Shinra_TalkPrepare_Actions)

endfunction




endlibrary
