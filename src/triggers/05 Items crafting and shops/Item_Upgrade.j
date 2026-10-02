library TItemUpgrade
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Item_Upgrade_Watera=null
    trigger gg_trg_Item_Upgrade_Wateraga=null
    trigger gg_trg_Item_Upgrade_Quakera=null
    trigger gg_trg_Item_Upgrade_Quakeraga=null
    trigger gg_trg_Item_Upgrade_Demira=null
    trigger gg_trg_Item_Upgrade_Demiga=null
    trigger gg_trg_Item_Upgrade_Aerora=null
    trigger gg_trg_Item_Upgrade_Aeroga=null
endglobals

function Trig_Item_Upgrade_Watera_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I023')and(GetItemCharges(GetManipulatedItem())<1) // 'I023': item "Water Materia"
endfunction

function Trig_Item_Upgrade_Watera_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_ItemUseReplacement=UnitAddItemByIdSwapped('I024',GetManipulatingUnit()) // 'I024': item "Watera Materia"
endfunction

function Trig_Item_Upgrade_Wateraga_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I024')and(GetItemCharges(GetManipulatedItem())<1) // 'I024': item "Watera Materia"
endfunction

function Trig_Item_Upgrade_Wateraga_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_ItemUseReplacement=UnitAddItemByIdSwapped('I025',GetManipulatingUnit()) // 'I025': item "Wateraga Materia"
endfunction

function Trig_Item_Upgrade_Quakera_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03G')and(GetItemCharges(GetManipulatedItem())<1) // 'I03G': item "Quake Materia"
endfunction

function Trig_Item_Upgrade_Quakera_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_ItemUseReplacement=UnitAddItemByIdSwapped('I03H',GetManipulatingUnit()) // 'I03H': item "Quakera Materia"
endfunction

function Trig_Item_Upgrade_Quakeraga_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03H')and(GetItemCharges(GetManipulatedItem())<1) // 'I03H': item "Quakera Materia"
endfunction

function Trig_Item_Upgrade_Quakeraga_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_ItemUseReplacement=UnitAddItemByIdSwapped('I03F',GetManipulatingUnit()) // 'I03F': item "Quakeraga Materia"
endfunction

function Trig_Item_Upgrade_Demira_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03L')and(GetItemCharges(GetManipulatedItem())<1) // 'I03L': item "Demi Materia"
endfunction

function Trig_Item_Upgrade_Demira_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_ItemUseReplacement=UnitAddItemByIdSwapped('I03M',GetManipulatingUnit()) // 'I03M': item "Demira Materia"
endfunction

function Trig_Item_Upgrade_Demiga_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03M')and(GetItemCharges(GetManipulatedItem())<1) // 'I03M': item "Demira Materia"
endfunction

function Trig_Item_Upgrade_Demiga_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_ItemUseReplacement=UnitAddItemByIdSwapped('I03N',GetManipulatingUnit()) // 'I03N': item "Demiga Materia"
endfunction

function Trig_Item_Upgrade_Aerora_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I07N')and(GetItemCharges(GetManipulatedItem())<1) // 'I07N': item "Aero Materia"
endfunction

function Trig_Item_Upgrade_Aerora_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_ItemUseReplacement=UnitAddItemByIdSwapped('I07O',GetManipulatingUnit()) // 'I07O': item "Aerora Materia"
endfunction

function Trig_Item_Upgrade_Aeroga_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I07O')and(GetItemCharges(GetManipulatedItem())<1) // 'I07O': item "Aerora Materia"
endfunction

function Trig_Item_Upgrade_Aeroga_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_ItemUseReplacement=UnitAddItemByIdSwapped('I07P',GetManipulatingUnit()) // 'I07P': item "Aeroga Materia"
endfunction

function InitTrig_Item_Upgrade takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Item_Part3 (module Item),
// which keeps the original registration order.

function Register_Item_Upgrade_Watera takes nothing returns nothing
    set gg_trg_Item_Upgrade_Watera=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Upgrade_Watera,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Item_Upgrade_Watera,Condition(function Trig_Item_Upgrade_Watera_Conditions))
    call TriggerAddAction(gg_trg_Item_Upgrade_Watera,function Trig_Item_Upgrade_Watera_Actions)
endfunction

function Register_Item_Upgrade_Wateraga takes nothing returns nothing
    set gg_trg_Item_Upgrade_Wateraga=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Upgrade_Wateraga,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Item_Upgrade_Wateraga,Condition(function Trig_Item_Upgrade_Wateraga_Conditions))
    call TriggerAddAction(gg_trg_Item_Upgrade_Wateraga,function Trig_Item_Upgrade_Wateraga_Actions)
endfunction

function Register_Item_Upgrade_Quakera takes nothing returns nothing
    set gg_trg_Item_Upgrade_Quakera=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Upgrade_Quakera,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Item_Upgrade_Quakera,Condition(function Trig_Item_Upgrade_Quakera_Conditions))
    call TriggerAddAction(gg_trg_Item_Upgrade_Quakera,function Trig_Item_Upgrade_Quakera_Actions)
endfunction

function Register_Item_Upgrade_Quakeraga takes nothing returns nothing
    set gg_trg_Item_Upgrade_Quakeraga=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Upgrade_Quakeraga,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Item_Upgrade_Quakeraga,Condition(function Trig_Item_Upgrade_Quakeraga_Conditions))
    call TriggerAddAction(gg_trg_Item_Upgrade_Quakeraga,function Trig_Item_Upgrade_Quakeraga_Actions)
endfunction

function Register_Item_Upgrade_Demira takes nothing returns nothing
    set gg_trg_Item_Upgrade_Demira=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Upgrade_Demira,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Item_Upgrade_Demira,Condition(function Trig_Item_Upgrade_Demira_Conditions))
    call TriggerAddAction(gg_trg_Item_Upgrade_Demira,function Trig_Item_Upgrade_Demira_Actions)
endfunction

function Register_Item_Upgrade_Demiga takes nothing returns nothing
    set gg_trg_Item_Upgrade_Demiga=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Upgrade_Demiga,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Item_Upgrade_Demiga,Condition(function Trig_Item_Upgrade_Demiga_Conditions))
    call TriggerAddAction(gg_trg_Item_Upgrade_Demiga,function Trig_Item_Upgrade_Demiga_Actions)
endfunction

function Register_Item_Upgrade_Aerora takes nothing returns nothing
    set gg_trg_Item_Upgrade_Aerora=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Upgrade_Aerora,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Item_Upgrade_Aerora,Condition(function Trig_Item_Upgrade_Aerora_Conditions))
    call TriggerAddAction(gg_trg_Item_Upgrade_Aerora,function Trig_Item_Upgrade_Aerora_Actions)
endfunction

function Register_Item_Upgrade_Aeroga takes nothing returns nothing
    set gg_trg_Item_Upgrade_Aeroga=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Upgrade_Aeroga,EVENT_PLAYER_UNIT_USE_ITEM)
    call TriggerAddCondition(gg_trg_Item_Upgrade_Aeroga,Condition(function Trig_Item_Upgrade_Aeroga_Conditions))
    call TriggerAddAction(gg_trg_Item_Upgrade_Aeroga,function Trig_Item_Upgrade_Aeroga_Actions)
endfunction

endlibrary
