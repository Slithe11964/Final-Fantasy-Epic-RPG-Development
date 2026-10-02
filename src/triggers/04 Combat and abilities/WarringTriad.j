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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_WarringTriad takes nothing returns nothing
endfunction

function RegisterR11_WarringTriad_Freeze takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_WarringTriad_Freeze=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_WarringTriad_Freeze,GetPlayableMapRect())

call TriggerAddCondition(gg_trg_WarringTriad_Freeze,Condition(function Trig_WarringTriad_Freeze_Conditions))

call TriggerAddAction(gg_trg_WarringTriad_Freeze,function Trig_WarringTriad_Freeze_Actions)

endfunction




endlibrary
