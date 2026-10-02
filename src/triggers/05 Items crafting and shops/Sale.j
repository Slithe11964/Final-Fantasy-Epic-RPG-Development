library TSale
function Trig_Sale_MithrilSword_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03T') // 'I03T': item "Mithril Sword (25% off!)"
endfunction

function Trig_Sale_MithrilSword_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    call UnitAddItemByIdSwapped('I00V',GetManipulatingUnit()) // 'I00V': item "Mithril Sword"
endfunction

function Trig_Sale_MithrilAxe_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03U') // 'I03U': item "Mithril Axe (25% off!)"
endfunction

function Trig_Sale_MithrilAxe_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    call UnitAddItemByIdSwapped('I01B',GetManipulatingUnit()) // 'I01B': item "Mithril Axe"
endfunction

function Trig_Sale_MithrilShield_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03V') // 'I03V': item "Mithril Shield (25% off!)"
endfunction

function Trig_Sale_MithrilShield_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    call UnitAddItemByIdSwapped('I014',GetManipulatingUnit()) // 'I014': item "Mithril Shield"
endfunction

function Trig_Sale_MithrilMail_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03W') // 'I03W': item "Mithril Mail (25% off!)"
endfunction

function Trig_Sale_MithrilMail_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    call UnitAddItemByIdSwapped('I01R',GetManipulatingUnit()) // 'I01R': item "Mithril Mail"
endfunction

function Trig_Sale_MithrilHelmet_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03X') // 'I03X': item "Mithril Helmet (25% off!)"
endfunction

function Trig_Sale_MithrilHelmet_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    call UnitAddItemByIdSwapped('I01I',GetManipulatingUnit()) // 'I01I': item "Mithril Helmet"
endfunction

function Trig_Sale_Nectar_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I03Z') // 'I03Z': item "Nectar (50% off!)"
endfunction

function Trig_Sale_Nectar_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    call UnitAddItemByIdSwapped('I02V',GetManipulatingUnit()) // 'I02V': item "Nectar"
endfunction

// World Editor calls InitTrig_Sale automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Sale (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Sale takes nothing returns nothing
endfunction

function Register_Sale_MithrilSword takes nothing returns nothing
    set gg_trg_Sale_MithrilSword=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sale_MithrilSword,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Sale_MithrilSword,Condition(function Trig_Sale_MithrilSword_Conditions))
    call TriggerAddAction(gg_trg_Sale_MithrilSword,function Trig_Sale_MithrilSword_Actions)
endfunction

function Register_Sale_MithrilAxe takes nothing returns nothing
    set gg_trg_Sale_MithrilAxe=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sale_MithrilAxe,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Sale_MithrilAxe,Condition(function Trig_Sale_MithrilAxe_Conditions))
    call TriggerAddAction(gg_trg_Sale_MithrilAxe,function Trig_Sale_MithrilAxe_Actions)
endfunction

function Register_Sale_MithrilShield takes nothing returns nothing
    set gg_trg_Sale_MithrilShield=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sale_MithrilShield,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Sale_MithrilShield,Condition(function Trig_Sale_MithrilShield_Conditions))
    call TriggerAddAction(gg_trg_Sale_MithrilShield,function Trig_Sale_MithrilShield_Actions)
endfunction

function Register_Sale_MithrilMail takes nothing returns nothing
    set gg_trg_Sale_MithrilMail=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sale_MithrilMail,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Sale_MithrilMail,Condition(function Trig_Sale_MithrilMail_Conditions))
    call TriggerAddAction(gg_trg_Sale_MithrilMail,function Trig_Sale_MithrilMail_Actions)
endfunction

function Register_Sale_MithrilHelmet takes nothing returns nothing
    set gg_trg_Sale_MithrilHelmet=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sale_MithrilHelmet,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Sale_MithrilHelmet,Condition(function Trig_Sale_MithrilHelmet_Conditions))
    call TriggerAddAction(gg_trg_Sale_MithrilHelmet,function Trig_Sale_MithrilHelmet_Actions)
endfunction

function Register_Sale_Nectar takes nothing returns nothing
    set gg_trg_Sale_Nectar=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sale_Nectar,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Sale_Nectar,Condition(function Trig_Sale_Nectar_Conditions))
    call TriggerAddAction(gg_trg_Sale_Nectar,function Trig_Sale_Nectar_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Sale takes nothing returns nothing
    call Register_Sale_MithrilSword()
    call Register_Sale_MithrilAxe()
    call Register_Sale_MithrilShield()
    call Register_Sale_MithrilMail()
    call Register_Sale_MithrilHelmet()
    call Register_Sale_Nectar()
endfunction

endlibrary
