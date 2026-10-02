library TKiemarl
function Trig_Kiemarl_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[79]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e016_0019,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_DragonEgg_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Kiemarl takes nothing returns nothing
endfunction

function RegisterR11_Kiemarl_ShowTalkIcon takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Kiemarl_ShowTalkIcon=CreateTrigger()

call DisableTrigger(gg_trg_Kiemarl_ShowTalkIcon)

call TriggerAddAction(gg_trg_Kiemarl_ShowTalkIcon,function Trig_Kiemarl_ShowTalkIcon_Actions)

endfunction




endlibrary
