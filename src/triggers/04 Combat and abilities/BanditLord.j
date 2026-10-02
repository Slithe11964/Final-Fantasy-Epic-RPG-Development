library TBanditLord
function Trig_BanditLord_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetDestructableInvulnerableBJ(gg_dest_LOcg_0010,false)
    call EnableTrigger(gg_trg_Mid_Freed)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_BanditLord automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_BanditLord (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_BanditLord takes nothing returns nothing
endfunction

function Register_BanditLord_Death takes nothing returns nothing
    set gg_trg_BanditLord_Death=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_BanditLord_Death,gg_unit_nbld_0014,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_BanditLord_Death,gg_unit_nbld_0014,EVENT_UNIT_CHANGE_OWNER)
    call TriggerAddAction(gg_trg_BanditLord_Death,function Trig_BanditLord_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_BanditLord takes nothing returns nothing
    call Register_BanditLord_Death()
endfunction

endlibrary
