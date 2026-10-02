library TBanditLord
function Trig_BanditLord_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0010,false)
    call EnableTrigger(gg_trg_Mid_Freed)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_BanditLord takes nothing returns nothing
endfunction
function RegisterR11_BanditLord_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_BanditLord_Death=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_BanditLord_Death,gg_unit_nbld_0014,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_BanditLord_Death,gg_unit_nbld_0014,EVENT_UNIT_CHANGE_OWNER)
    call TriggerAddAction(gg_trg_BanditLord_Death,function Trig_BanditLord_Death_Actions)
endfunction




endlibrary
