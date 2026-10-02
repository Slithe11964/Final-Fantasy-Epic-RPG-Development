library TFishing requires TFishingCasting, TFishingEncounters, TFishingReelingAndCatch, TFishingSetup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Fishing_Pole_Found=null
    trigger gg_trg_Fishing_Unlock=null
    trigger gg_trg_Fishing_Cast=null
    trigger gg_trg_Fishing_Tick=null
    trigger gg_trg_Fishing_Input=null
    trigger gg_trg_Fishing_Catch=null
    trigger gg_trg_Fishing_End=null
    trigger gg_trg_Fishing_Monster_Spawn=null
endglobals

function InitTrig_Fishing takes nothing returns nothing
endfunction

function Register_Fishing_Cast takes nothing returns nothing
    set gg_trg_Fishing_Cast=CreateTrigger()
    call DisableTrigger(gg_trg_Fishing_Cast)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fishing_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Fishing_Cast,Condition(function Trig_Fishing_Cast_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Cast,function Trig_Fishing_Cast_Actions)
endfunction

function Register_Fishing_Monster_Spawn takes nothing returns nothing
    set gg_trg_Fishing_Monster_Spawn=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fishing_Monster_Spawn,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Fishing_Monster_Spawn,Condition(function Trig_Fishing_Monster_Spawn_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Monster_Spawn,function Trig_Fishing_Monster_Spawn_Actions)
endfunction

function Register_Fishing_Tick takes nothing returns nothing
    set gg_trg_Fishing_Tick=CreateTrigger()
    call DisableTrigger(gg_trg_Fishing_Tick)
    call TriggerAddAction(gg_trg_Fishing_Tick,function Trig_Fishing_Tick_Actions)
endfunction

function Register_Fishing_Input takes nothing returns nothing
    set gg_trg_Fishing_Input=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fishing_Input,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Fishing_Input,Condition(function Trig_Fishing_Input_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Input,function Trig_Fishing_Input_Actions)
endfunction

function Register_Fishing_Catch takes nothing returns nothing
    set gg_trg_Fishing_Catch=CreateTrigger()
    call DisableTrigger(gg_trg_Fishing_Catch)
    call TriggerAddAction(gg_trg_Fishing_Catch,function Trig_Fishing_Catch_Actions)
endfunction

function Register_Fishing_End takes nothing returns nothing
    set gg_trg_Fishing_End=CreateTrigger()
    call DisableTrigger(gg_trg_Fishing_End)
    call TriggerAddAction(gg_trg_Fishing_End,function Trig_Fishing_End_Actions)
endfunction

function Register_Fishing_Setup takes nothing returns nothing
    set gg_trg_Fishing_Setup=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Fishing_Setup,2.)
    call TriggerAddAction(gg_trg_Fishing_Setup,function Trig_Fishing_Setup_Actions)
endfunction

function Register_Fishing_Pole_Found takes nothing returns nothing
    set gg_trg_Fishing_Pole_Found=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Fishing_Pole_Found,gg_rct_581)
    call TriggerAddCondition(gg_trg_Fishing_Pole_Found,Condition(function Trig_Fishing_Pole_Found_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Pole_Found,function Trig_Fishing_Pole_Found_Actions)
endfunction

function Register_Fishing_Unlock takes nothing returns nothing
    set gg_trg_Fishing_Unlock=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fishing_Unlock,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Fishing_Unlock,Condition(function Trig_Fishing_Unlock_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Unlock,function Trig_Fishing_Unlock_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Fishing_Part1 takes nothing returns nothing
    call Register_Fishing_Setup()
    call Register_Fishing_Pole_Found()
    call Register_Fishing_Unlock()
    call Register_Fishing_Cast()
    call Register_Fishing_Tick()
    call Register_Fishing_Input()
    call Register_Fishing_Catch()
    call Register_Fishing_End()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Fishing_Part2 takes nothing returns nothing
    call Register_Fishing_Monster_Spawn()
endfunction

endlibrary
