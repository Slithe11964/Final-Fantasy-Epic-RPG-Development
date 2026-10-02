library TStealth
function Trig_Stealth_Break_OnAttack_Conditions takes nothing returns boolean
    return((UnitHasBuffBJ(GetAttacker(),'B016'))and(IsUnitType(GetAttacker(),UNIT_TYPE_HERO))and(IsUnitIllusionBJ(GetAttacker())==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_STRUCTURE)==false)and(GetUnitStateSwap(UNIT_STATE_MANA,GetAttacker())>=.0))!=null // 'B016': buff tooltip "Stealth"
endfunction

function Trig_Stealth_Break_OnAttack_IsInvisible takes nothing returns boolean
    return(IsUnitInvisible(GetAttacker(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Stealth_Break_OnAttack_Actions takes nothing returns nothing
    if(Trig_Stealth_Break_OnAttack_IsInvisible())then
        call UnitRemoveBuffBJ('B016',GetAttacker()) // 'B016': buff tooltip "Stealth"
        call UnitAddItemByIdSwapped('I0BD',GetAttacker()) // 'I0BD': item "Stealth Bonus"
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Stealth takes nothing returns nothing
endfunction
function RegisterR11_Stealth_Break_OnAttack takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Stealth_Break_OnAttack=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stealth_Break_OnAttack,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Stealth_Break_OnAttack,Condition(function Trig_Stealth_Break_OnAttack_Conditions))
    call TriggerAddAction(gg_trg_Stealth_Break_OnAttack,function Trig_Stealth_Break_OnAttack_Actions)
endfunction




endlibrary
