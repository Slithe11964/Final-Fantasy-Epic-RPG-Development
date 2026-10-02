library TBilly
function Trig_Billy_ShowTalkIcon_NeedsSelectAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Aneu',gg_unit_n0KE_0072)<=0) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_Billy_ShowTalkIcon_Actions takes nothing returns nothing
    if(Trig_Billy_ShowTalkIcon_NeedsSelectAbility())then
        call UnitAddAbilityBJ('Aneu',gg_unit_n0KE_0072) // 'Aneu': standard ability reference "Neutral Building"
        set udg_SpecialEffect[86]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0KE_0072,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_ChocoboRider_Start)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Billy takes nothing returns nothing
endfunction

function RegisterR11_Billy_ShowTalkIcon takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Billy_ShowTalkIcon=CreateTrigger()

call DisableTrigger(gg_trg_Billy_ShowTalkIcon)

call TriggerAddAction(gg_trg_Billy_ShowTalkIcon,function Trig_Billy_ShowTalkIcon_Actions)

endfunction




endlibrary
