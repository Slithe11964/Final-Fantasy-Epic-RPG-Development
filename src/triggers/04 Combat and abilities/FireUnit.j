library TFireUnit
function Trig_FireUnit_Enter_IsFireUnitType takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n041')or(GetUnitTypeId(GetTriggerUnit())=='n0CB')or(GetUnitTypeId(GetTriggerUnit())=='nslr')or(GetUnitTypeId(GetTriggerUnit())=='n00F')or(GetUnitTypeId(GetTriggerUnit())=='E00Q')or(GetUnitTypeId(GetTriggerUnit())=='n04A')or(GetUnitTypeId(GetTriggerUnit())=='h02B') // 'n041': unit "Ruby Dragon"; 'n0CB': unit "Vulcan"; 'nslr': unit "Zalamander"; 'n00F': unit "Fire Golem"; 'E00Q': unit "Warring Triad Member"; 'n04A': unit "Ifrit"; 'h02B': unit "Fire"
endfunction

function Trig_FireUnit_Enter_Conditions takes nothing returns boolean
    return(Trig_FireUnit_Enter_IsFireUnitType())
endfunction

function Trig_FireUnit_Enter_Actions takes nothing returns nothing
    call GroupAddUnitSimple(GetTriggerUnit(),udg_ImmolationAuraGroup)
endfunction

function Trig_FireUnit_Death_IsFireUnitType takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n041')or(GetUnitTypeId(GetTriggerUnit())=='n0CB')or(GetUnitTypeId(GetTriggerUnit())=='nslr')or(GetUnitTypeId(GetTriggerUnit())=='n00F')or(GetUnitTypeId(GetTriggerUnit())=='E00Q')or(GetUnitTypeId(GetTriggerUnit())=='n04A')or(GetUnitTypeId(GetTriggerUnit())=='h02B') // 'n041': unit "Ruby Dragon"; 'n0CB': unit "Vulcan"; 'nslr': unit "Zalamander"; 'n00F': unit "Fire Golem"; 'E00Q': unit "Warring Triad Member"; 'n04A': unit "Ifrit"; 'h02B': unit "Fire"
endfunction

function Trig_FireUnit_Death_Conditions takes nothing returns boolean
    return(Trig_FireUnit_Death_IsFireUnitType())
endfunction

function Trig_FireUnit_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ImmolationAuraGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_FireUnit takes nothing returns nothing
endfunction

function RegisterR11_FireUnit_Enter takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_FireUnit_Enter=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_FireUnit_Enter,GetPlayableMapRect())

call TriggerAddCondition(gg_trg_FireUnit_Enter,Condition(function Trig_FireUnit_Enter_Conditions))

call TriggerAddAction(gg_trg_FireUnit_Enter,function Trig_FireUnit_Enter_Actions)

endfunction




function RegisterR11_FireUnit_Death takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_FireUnit_Death=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_FireUnit_Death,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_FireUnit_Death,Condition(function Trig_FireUnit_Death_Conditions))

call TriggerAddAction(gg_trg_FireUnit_Death,function Trig_FireUnit_Death_Actions)

endfunction




endlibrary
