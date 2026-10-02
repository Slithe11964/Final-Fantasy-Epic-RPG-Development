library TSummon requires TSummonBahamut, TSummonCyclops, TSummonGolem, TSummonIfrit, TSummonItems, TSummonLifecycle, TSummonScaling, TSummonShiva, TSummonTransfusion
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Summon_Detect=null
    trigger gg_trg_Summon_Powerup=null
    trigger gg_trg_Summon_Transfusion_Consume=null
    trigger gg_trg_Summon_Death_Cleanup=null
    trigger gg_trg_Summon_Item_Dropped=null
endglobals

function InitTrig_Summon takes nothing returns nothing
endfunction

function Register_Summon_Bahamut takes nothing returns nothing
    set gg_trg_Summon_Bahamut=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Bahamut,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Bahamut,Condition(function Trig_Summon_Bahamut_Conditions))
    call TriggerAddAction(gg_trg_Summon_Bahamut,function Trig_Summon_Bahamut_Actions)
endfunction

function Register_Summon_Cyclops takes nothing returns nothing
    set gg_trg_Summon_Cyclops=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Cyclops,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Cyclops,Condition(function Trig_Summon_Cyclops_Conditions))
    call TriggerAddAction(gg_trg_Summon_Cyclops,function Trig_Summon_Cyclops_Actions)
endfunction

function Register_Summon_Golem takes nothing returns nothing
    set gg_trg_Summon_Golem=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Golem,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Golem,Condition(function Trig_Summon_Golem_Conditions))
    call TriggerAddAction(gg_trg_Summon_Golem,function Trig_Summon_Golem_Actions)
endfunction

function Register_Summon_Ifrit takes nothing returns nothing
    set gg_trg_Summon_Ifrit=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Ifrit,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Ifrit,Condition(function Trig_Summon_Ifrit_Conditions))
    call TriggerAddAction(gg_trg_Summon_Ifrit,function Trig_Summon_Ifrit_Actions)
endfunction

function Register_Summon_Item_Dropped takes nothing returns nothing
    set gg_trg_Summon_Item_Dropped=CreateTrigger()
    call DisableTrigger(gg_trg_Summon_Item_Dropped)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Item_Dropped,EVENT_PLAYER_UNIT_DROP_ITEM)
    call TriggerAddCondition(gg_trg_Summon_Item_Dropped,Condition(function Trig_Summon_Item_Dropped_Conditions))
    call TriggerAddAction(gg_trg_Summon_Item_Dropped,function Trig_Summon_Item_Dropped_Actions)
endfunction

function Register_Summon_Detect takes nothing returns nothing
    set gg_trg_Summon_Detect=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Summon_Detect,GetPlayableMapRect())
    call TriggerAddCondition(gg_trg_Summon_Detect,Condition(function Trig_Summon_Detect_Conditions))
    call TriggerAddAction(gg_trg_Summon_Detect,function Trig_Summon_Detect_Actions)
endfunction

function Register_Summon_Death_Cleanup takes nothing returns nothing
    set gg_trg_Summon_Death_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Death_Cleanup,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Summon_Death_Cleanup,Condition(function Trig_Summon_Death_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Summon_Death_Cleanup,function Trig_Summon_Death_Cleanup_Actions)
endfunction

function Register_Summon_Powerup takes nothing returns nothing
    set gg_trg_Summon_Powerup=CreateTrigger()
    call DisableTrigger(gg_trg_Summon_Powerup)
    call TriggerAddCondition(gg_trg_Summon_Powerup,Condition(function Trig_Summon_Powerup_Conditions))
    call TriggerAddAction(gg_trg_Summon_Powerup,function Trig_Summon_Powerup_Actions)
endfunction

function Register_Summon_Shiva takes nothing returns nothing
    set gg_trg_Summon_Shiva=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Shiva,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Shiva,Condition(function Trig_Summon_Shiva_Conditions))
    call TriggerAddAction(gg_trg_Summon_Shiva,function Trig_Summon_Shiva_Actions)
endfunction

function Register_Summon_Transfusion_Consume takes nothing returns nothing
    set gg_trg_Summon_Transfusion_Consume=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Transfusion_Consume,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Summon_Transfusion_Consume,Condition(function Trig_Summon_Transfusion_Consume_Conditions))
    call TriggerAddAction(gg_trg_Summon_Transfusion_Consume,function Trig_Summon_Transfusion_Consume_Actions)
endfunction

// Creates part 1 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Summon_Part1 takes nothing returns nothing
    call Register_Summon_Detect()
    call Register_Summon_Powerup()
endfunction

// Creates part 2 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Summon_Part2 takes nothing returns nothing
    call Register_Summon_Shiva()
    call Register_Summon_Ifrit()
    call Register_Summon_Golem()
    call Register_Summon_Cyclops()
    call Register_Summon_Bahamut()
endfunction

// Creates part 3 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Summon_Part3 takes nothing returns nothing
    call Register_Summon_Transfusion_Consume()
    call Register_Summon_Death_Cleanup()
endfunction

// Creates part 4 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Summon_Part4 takes nothing returns nothing
    call Register_Summon_Item_Dropped()
endfunction

endlibrary
