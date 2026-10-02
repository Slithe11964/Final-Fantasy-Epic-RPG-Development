library TStop
function Trig_Stop_Friendly_Attack_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetAttacker()),udg_ActivePlayers))and(IsPlayerInForce(GetOwningPlayer(GetAttackedUnitBJ()),udg_PlayingPlayers))and(IsUnitEnemy(GetTriggerUnit(),GetOwningPlayer(GetAttacker()))==false)
endfunction

function Trig_Stop_Friendly_Attack_Actions takes nothing returns nothing
    call IssueImmediateOrderBJ(GetAttacker(),"stop")
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Stop takes nothing returns nothing
endfunction

function RegisterR11_Stop_Friendly_Attack takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Stop_Friendly_Attack=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Stop_Friendly_Attack,EVENT_PLAYER_UNIT_ATTACKED)

call TriggerAddCondition(gg_trg_Stop_Friendly_Attack,Condition(function Trig_Stop_Friendly_Attack_Conditions))

call TriggerAddAction(gg_trg_Stop_Friendly_Attack,function Trig_Stop_Friendly_Attack_Actions)

endfunction




endlibrary
