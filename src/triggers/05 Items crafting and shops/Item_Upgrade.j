library TItemUpgrade
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

endlibrary
