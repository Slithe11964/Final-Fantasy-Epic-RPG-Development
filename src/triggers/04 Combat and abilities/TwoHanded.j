library TTwoHanded
function Trig_TwoHanded_Check_Conditions takes nothing returns boolean
    return((GetUnitAbilityLevelSwapped('A0GP',GetAttacker())>0)and(IsUnitType(GetAttacker(),UNIT_TYPE_MELEE_ATTACKER))and(IsUnitIllusionBJ(GetAttacker())==false)and(IsUnitType(GetAttacker(),UNIT_TYPE_HERO))and(GetUnitStateSwap(UNIT_STATE_MANA,GetAttacker())>=.0))!=null // 'A0GP': ability "Two-Handed"
endfunction

function Trig_TwoHanded_Check_SlotCancelsBonus takes nothing returns boolean
    return(udg_TempBoolean)or(GetItemType(UnitItemInSlotBJ(GetAttacker(),udg_SlotIndex))==ITEM_TYPE_POWERUP)
endfunction

function Trig_TwoHanded_Check_CancelsBonus takes nothing returns boolean
    return(Trig_TwoHanded_Check_SlotCancelsBonus())
endfunction

function Trig_TwoHanded_Check_ItemIsGear takes nothing returns boolean
    return(GetItemType(UnitItemInSlotBJ(GetAttacker(),udg_SlotIndex))==ITEM_TYPE_PERMANENT)or(GetItemType(UnitItemInSlotBJ(GetAttacker(),udg_SlotIndex))==ITEM_TYPE_POWERUP)
endfunction

function Trig_TwoHanded_Check_SlotHasGear takes nothing returns boolean
    return(UnitItemInSlotBJ(GetAttacker(),udg_SlotIndex)!=null)and(Trig_TwoHanded_Check_ItemIsGear())
endfunction

function Trig_TwoHanded_Check_TwoHandedActive takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_TwoHanded_Check_Actions takes nothing returns nothing
    set udg_TempBoolean=false
    set udg_SlotIndex=1
    loop
        exitwhen udg_SlotIndex>6
        if(Trig_TwoHanded_Check_SlotHasGear())then
            if(Trig_TwoHanded_Check_CancelsBonus())then
                set udg_TempBoolean=false
                call UnitRemoveBuffBJ('B05W',GetAttacker()) // 'B05W': buff tooltip "Two-Handed Swing"
                return
            else
                set udg_TempBoolean=true
            endif
        endif
        set udg_SlotIndex=udg_SlotIndex+1
    endloop
    if(Trig_TwoHanded_Check_TwoHandedActive())then
        call UnitAddItemByIdSwapped('I0GK',GetAttacker()) // 'I0GK': item "Two-Handed Bonus"
    else
        call UnitRemoveBuffBJ('B05W',GetAttacker()) // 'B05W': buff tooltip "Two-Handed Swing"
    endif
endfunction

// World Editor calls InitTrig_TwoHanded automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_TwoHanded (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_TwoHanded takes nothing returns nothing
endfunction

function Register_TwoHanded_Check takes nothing returns nothing
    set gg_trg_TwoHanded_Check=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_TwoHanded_Check,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_TwoHanded_Check,Condition(function Trig_TwoHanded_Check_Conditions))
    call TriggerAddAction(gg_trg_TwoHanded_Check,function Trig_TwoHanded_Check_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_TwoHanded takes nothing returns nothing
    call Register_TwoHanded_Check()
endfunction

endlibrary
