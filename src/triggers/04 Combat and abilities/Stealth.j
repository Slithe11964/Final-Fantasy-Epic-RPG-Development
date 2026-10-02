library TStealth
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Stealth_Break_OnAttack=null
endglobals

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

// World Editor calls InitTrig_Stealth automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Stealth (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Stealth takes nothing returns nothing
endfunction

function Register_Stealth_Break_OnAttack takes nothing returns nothing
    set gg_trg_Stealth_Break_OnAttack=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Stealth_Break_OnAttack,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Stealth_Break_OnAttack,Condition(function Trig_Stealth_Break_OnAttack_Conditions))
    call TriggerAddAction(gg_trg_Stealth_Break_OnAttack,function Trig_Stealth_Break_OnAttack_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Stealth takes nothing returns nothing
    call Register_Stealth_Break_OnAttack()
endfunction

endlibrary
