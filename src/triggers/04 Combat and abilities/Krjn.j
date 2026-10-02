library TKrjn
function Trig_Krjn_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[75]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e012_0227,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_AncientHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Krjn takes nothing returns nothing
endfunction

function RegisterR11_Krjn_ShowTalkIcon takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Krjn_ShowTalkIcon=CreateTrigger()

call DisableTrigger(gg_trg_Krjn_ShowTalkIcon)

call TriggerAddAction(gg_trg_Krjn_ShowTalkIcon,function Trig_Krjn_ShowTalkIcon_Actions)

endfunction




endlibrary
