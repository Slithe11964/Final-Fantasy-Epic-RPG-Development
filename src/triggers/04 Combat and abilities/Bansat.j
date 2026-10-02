library TBansat
function Trig_Bansat_ShowTalkIcon_Actions takes nothing returns nothing
    set udg_SpecialEffect[71]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h02Z_0230,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Bansat takes nothing returns nothing
endfunction
function RegisterR11_Bansat_ShowTalkIcon takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Bansat_ShowTalkIcon=CreateTrigger()
    call TriggerAddAction(gg_trg_Bansat_ShowTalkIcon,function Trig_Bansat_ShowTalkIcon_Actions)
endfunction




endlibrary
