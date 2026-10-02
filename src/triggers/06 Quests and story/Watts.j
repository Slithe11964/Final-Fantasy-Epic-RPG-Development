library TWatts
function Trig_Watts_Talk_Enable_Actions takes nothing returns nothing
    set udg_SpecialEffect[91]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h00Q_0255,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_FieryWings_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Watts takes nothing returns nothing
endfunction

function RegisterR11_Watts_Talk_Enable takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Watts_Talk_Enable=CreateTrigger()

call DisableTrigger(gg_trg_Watts_Talk_Enable)

call TriggerAddAction(gg_trg_Watts_Talk_Enable,function Trig_Watts_Talk_Enable_Actions)

endfunction




endlibrary
