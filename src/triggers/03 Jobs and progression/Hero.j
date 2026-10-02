library THero requires THeroDeath, THeroEndlessGrowth, THeroLevelUp, THeroMedicineEvents, THeroOrder, THeroSelect
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Hero_Death_Revive=null
    trigger gg_trg_Hero_Order_Cooldown=null
    trigger gg_trg_Hero_Medicine_Pickup=null
    trigger gg_trg_Hero_Select_Redirect=null
endglobals

function InitTrig_Hero takes nothing returns nothing
endfunction

function Register_Hero_Death_Revive takes nothing returns nothing
    set gg_trg_Hero_Death_Revive=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Hero_Death_Revive,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Hero_Death_Revive,Condition(function Trig_Hero_Death_Revive_Conditions))
    call TriggerAddAction(gg_trg_Hero_Death_Revive,function Trig_Hero_Death_Revive_Actions)
endfunction

function Register_Hero_EndlessGrowth takes nothing returns nothing
    set gg_trg_Hero_EndlessGrowth=CreateTrigger()
    call DisableTrigger(gg_trg_Hero_EndlessGrowth)
    call TriggerAddAction(gg_trg_Hero_EndlessGrowth,function Trig_Hero_EndlessGrowth_Actions)
endfunction

function Register_Hero_LevelUp takes nothing returns nothing
    set gg_trg_Hero_LevelUp=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Hero_LevelUp,EVENT_PLAYER_HERO_LEVEL)
    call TriggerAddAction(gg_trg_Hero_LevelUp,function Trig_Hero_LevelUp_Actions)
endfunction

function Register_Hero_Medicine_Pickup takes nothing returns nothing
    set gg_trg_Hero_Medicine_Pickup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Hero_Medicine_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Hero_Medicine_Pickup,Condition(function Trig_Hero_Medicine_Pickup_Conditions))
    call TriggerAddAction(gg_trg_Hero_Medicine_Pickup,function Trig_Hero_Medicine_Pickup_Actions)
endfunction

function Register_Hero_Order_Cooldown takes nothing returns nothing
    set gg_trg_Hero_Order_Cooldown=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(0),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(1),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(2),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(3),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(4),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(5),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(6),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hero_Order_Cooldown,Player(7),EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerAddCondition(gg_trg_Hero_Order_Cooldown,Condition(function Trig_Hero_Order_Cooldown_Conditions))
    call TriggerAddAction(gg_trg_Hero_Order_Cooldown,function Trig_Hero_Order_Cooldown_Actions)
endfunction

function Register_Hero_Select_Redirect takes nothing returns nothing
    set gg_trg_Hero_Select_Redirect=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Hero_Select_Redirect,Player(7),true)
    call TriggerAddCondition(gg_trg_Hero_Select_Redirect,Condition(function Trig_Hero_Select_Redirect_Conditions))
    call TriggerAddAction(gg_trg_Hero_Select_Redirect,function Trig_Hero_Select_Redirect_Actions)
endfunction

// Creates part 1 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Hero_Part1 takes nothing returns nothing
    call Register_Hero_LevelUp()
    call Register_Hero_EndlessGrowth()
endfunction

// Creates part 2 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Hero_Part2 takes nothing returns nothing
    call Register_Hero_Death_Revive()
    call Register_Hero_Order_Cooldown()
endfunction

// Creates part 3 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Hero_Part3 takes nothing returns nothing
    call Register_Hero_Medicine_Pickup()
endfunction

// Creates part 4 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Hero_Part4 takes nothing returns nothing
    call Register_Hero_Select_Redirect()
endfunction

endlibrary
