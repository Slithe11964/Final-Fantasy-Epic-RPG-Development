library TRabbit requires TWait
function Trig_Rabbit_Wander_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='necr')and(GetOwningPlayer(GetTriggerUnit())==Player(PLAYER_NEUTRAL_PASSIVE)) // 'necr': object name not found in map data
endfunction

function Trig_Rabbit_Wander_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_475)
    call IssuePointOrderLocBJ(GetTriggerUnit(),"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(4.)
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Rabbit takes nothing returns nothing
endfunction

function RegisterR11_Rabbit_Wander takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Rabbit_Wander=CreateTrigger()

call TriggerRegisterEnterRectSimple(gg_trg_Rabbit_Wander,gg_rct_480)

call TriggerAddCondition(gg_trg_Rabbit_Wander,Condition(function Trig_Rabbit_Wander_Conditions))

call TriggerAddAction(gg_trg_Rabbit_Wander,function Trig_Rabbit_Wander_Actions)

endfunction




endlibrary
