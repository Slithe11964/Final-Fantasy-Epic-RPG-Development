library TItem requires TItemCooldown, TItemStack, TItemUpgrade
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Item_Stack_Order=null
    trigger gg_trg_Item_Stack_Pickup=null
    trigger gg_trg_Item_Cooldown_Start=null
    trigger gg_trg_Item_Upgrade_Watera=null
    trigger gg_trg_Item_Upgrade_Wateraga=null
    trigger gg_trg_Item_Upgrade_Quakera=null
    trigger gg_trg_Item_Upgrade_Quakeraga=null
    trigger gg_trg_Item_Upgrade_Demira=null
    trigger gg_trg_Item_Upgrade_Demiga=null
    trigger gg_trg_Item_Upgrade_Aerora=null
    trigger gg_trg_Item_Upgrade_Aeroga=null
endglobals

function InitTrig_Item takes nothing returns nothing
endfunction

function Register_Item_Cooldown_Start takes nothing returns nothing
    set gg_trg_Item_Cooldown_Start=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(0),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(1),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(2),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(3),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(4),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(5),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(6),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(7),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Item_Cooldown_Start,Condition(function Trig_Item_Cooldown_Start_Conditions))
    call TriggerAddAction(gg_trg_Item_Cooldown_Start,function Trig_Item_Cooldown_Start_Actions)
endfunction

function Register_Item_Stack_Order takes nothing returns nothing
    set gg_trg_Item_Stack_Order=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Stack_Order,EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerAddCondition(gg_trg_Item_Stack_Order,Condition(function Trig_Item_Stack_Order_Conditions))
    call TriggerAddAction(gg_trg_Item_Stack_Order,function Trig_Item_Stack_Order_Actions)
endfunction

function Register_Item_Stack_Pickup takes nothing returns nothing
    set gg_trg_Item_Stack_Pickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Item_Stack_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Item_Stack_Pickup,Condition(function Trig_Item_Stack_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Item_Stack_Pickup,function Trig_Item_Stack_Pickup_Actions)
endfunction

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

// Creates part 1 of 3 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Item_Part1 takes nothing returns nothing
    call Register_Item_Stack_Order()
    call Register_Item_Stack_Pickup()
endfunction

// Creates part 2 of 3 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Item_Part2 takes nothing returns nothing
    call Register_Item_Cooldown_Start()
endfunction

// Creates part 3 of 3 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Item_Part3 takes nothing returns nothing
    call Register_Item_Upgrade_Watera()
    call Register_Item_Upgrade_Wateraga()
    call Register_Item_Upgrade_Quakera()
    call Register_Item_Upgrade_Quakeraga()
    call Register_Item_Upgrade_Demira()
    call Register_Item_Upgrade_Demiga()
    call Register_Item_Upgrade_Aerora()
    call Register_Item_Upgrade_Aeroga()
endfunction

endlibrary
