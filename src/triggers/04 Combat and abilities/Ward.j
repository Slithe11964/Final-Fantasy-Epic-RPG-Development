library TWard
function Trig_Ward_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[76]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h030_0243,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_WendigoHunt_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Ward takes nothing returns nothing
endfunction
function RegisterR11_Ward_ShowTalkIcon takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ward_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Ward_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Ward_ShowTalkIcon,function Trig_Ward_ShowTalkIcon_Actions)
endfunction




endlibrary
