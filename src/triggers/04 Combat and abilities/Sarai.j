library TSarai
function Trig_Sarai_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[77]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e013_0176,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_TentacleCount=-1
    call EnableTrigger(gg_trg_Tentacles_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Sarai takes nothing returns nothing
endfunction
function RegisterR11_Sarai_ShowTalkIcon takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Sarai_ShowTalkIcon=CreateTrigger()
    call DisableTrigger(gg_trg_Sarai_ShowTalkIcon)
    call TriggerAddAction(gg_trg_Sarai_ShowTalkIcon,function Trig_Sarai_ShowTalkIcon_Actions)
endfunction




endlibrary
