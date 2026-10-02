library TOlga
function Trig_Olga_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[74]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e014_0149,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_FlanHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Olga takes nothing returns nothing
endfunction

function RegisterR11_Olga_ShowTalkIcon takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Olga_ShowTalkIcon=CreateTrigger()

call DisableTrigger(gg_trg_Olga_ShowTalkIcon)

call TriggerAddAction(gg_trg_Olga_ShowTalkIcon,function Trig_Olga_ShowTalkIcon_Actions)

endfunction




endlibrary
