library TWarringTriad
function Trig_WarringTriad_Freeze_Cond_IsTriadMember takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='E00P')or(GetUnitTypeId(GetTriggerUnit())=='E00Q')or(GetUnitTypeId(GetTriggerUnit())=='E00R') // 'E00P': unit "Warring Triad Member"; 'E00Q': unit "Warring Triad Member"; 'E00R': unit "Warring Triad Member"
endfunction

function Trig_WarringTriad_Freeze_Conditions takes nothing returns boolean
    return(Trig_WarringTriad_Freeze_Cond_IsTriadMember())
endfunction

function Trig_WarringTriad_Freeze_Actions takes nothing returns nothing
    call SetUnitAnimation(GetTriggerUnit(),"spell")
    call SetUnitTimeScalePercent(GetTriggerUnit(),.0)
endfunction

// World Editor calls InitTrig_WarringTriad automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_WarringTriad (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_WarringTriad takes nothing returns nothing
endfunction

function Register_WarringTriad_Freeze takes nothing returns nothing
    set gg_trg_WarringTriad_Freeze=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_WarringTriad_Freeze,GetPlayableMapRect())
    call TriggerAddCondition(gg_trg_WarringTriad_Freeze,Condition(function Trig_WarringTriad_Freeze_Conditions))
    call TriggerAddAction(gg_trg_WarringTriad_Freeze,function Trig_WarringTriad_Freeze_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_WarringTriad takes nothing returns nothing
    call Register_WarringTriad_Freeze()
endfunction

endlibrary
