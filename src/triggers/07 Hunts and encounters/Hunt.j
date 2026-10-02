library THunt requires THuntBoard, THuntContracts, THuntEncounters, THuntRewards, THuntShop
function InitTrig_Hunt takes nothing returns nothing
endfunction

function Register_Hunt_Setup takes nothing returns nothing
    set gg_trg_Hunt_Setup=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Hunt_Setup,3.)
    call TriggerAddAction(gg_trg_Hunt_Setup,function Trig_Hunt_Setup_Actions)
endfunction

function Register_Hunt_Board_Markers takes nothing returns nothing
    set gg_trg_Hunt_Board_Markers=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Board_Markers)
    call TriggerAddAction(gg_trg_Hunt_Board_Markers,function Trig_Hunt_Board_Markers_Actions)
endfunction

function Register_Hunt_Accept takes nothing returns nothing
    set gg_trg_Hunt_Accept=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Hunt_Accept,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Hunt_Accept,Condition(function Trig_Hunt_Accept_Conditions))
    call TriggerAddAction(gg_trg_Hunt_Accept,function Trig_Hunt_Accept_Actions)
endfunction

function Register_Hunt_Complete takes nothing returns nothing
    set gg_trg_Hunt_Complete=CreateTrigger()
    call TriggerAddAction(gg_trg_Hunt_Complete,function Trig_Hunt_Complete_Actions)
endfunction

function Register_Hunt_Thextera_Escort takes nothing returns nothing
    set gg_trg_Hunt_Thextera_Escort=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Thextera_Escort)
    call TriggerAddAction(gg_trg_Hunt_Thextera_Escort,function Trig_Hunt_Thextera_Escort_Actions)
endfunction

function Register_Hunt_Tonberry_Setup takes nothing returns nothing
    set gg_trg_Hunt_Tonberry_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Tonberry_Setup)
    call TriggerAddAction(gg_trg_Hunt_Tonberry_Setup,function Trig_Hunt_Tonberry_Setup_Actions)
endfunction

function Register_Hunt_Demon_Setup takes nothing returns nothing
    set gg_trg_Hunt_Demon_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Demon_Setup)
    call TriggerAddAction(gg_trg_Hunt_Demon_Setup,function Trig_Hunt_Demon_Setup_Actions)
endfunction

function Register_Hunt_Parvati_Setup takes nothing returns nothing
    set gg_trg_Hunt_Parvati_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Parvati_Setup)
    call TriggerAddAction(gg_trg_Hunt_Parvati_Setup,function Trig_Hunt_Parvati_Setup_Actions)
endfunction

function Register_Hunt_PhantomDancer_Setup takes nothing returns nothing
    set gg_trg_Hunt_PhantomDancer_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_PhantomDancer_Setup)
    call TriggerAddAction(gg_trg_Hunt_PhantomDancer_Setup,function Trig_Hunt_PhantomDancer_Setup_Actions)
endfunction

function Register_Hunt_Exdeath_Setup takes nothing returns nothing
    set gg_trg_Hunt_Exdeath_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Exdeath_Setup)
    call TriggerAddAction(gg_trg_Hunt_Exdeath_Setup,function Trig_Hunt_Exdeath_Setup_Actions)
endfunction

function Register_Hunt_Mephorash_Setup takes nothing returns nothing
    set gg_trg_Hunt_Mephorash_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Mephorash_Setup)
    call TriggerAddAction(gg_trg_Hunt_Mephorash_Setup,function Trig_Hunt_Mephorash_Setup_Actions)
endfunction

function Register_Hunt_Trickster_Unlock takes nothing returns nothing
    set gg_trg_Hunt_Trickster_Unlock=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Hunt_Trickster_Unlock,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Hunt_Trickster_Unlock,Condition(function Trig_Hunt_Trickster_Unlock_Conditions))
    call TriggerAddAction(gg_trg_Hunt_Trickster_Unlock,function Trig_Hunt_Trickster_Unlock_Actions)
endfunction

function Register_Hunt_Melaiduma_Setup takes nothing returns nothing
    set gg_trg_Hunt_Melaiduma_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Melaiduma_Setup)
    call TriggerAddAction(gg_trg_Hunt_Melaiduma_Setup,function Trig_Hunt_Melaiduma_Setup_Actions)
endfunction

function Register_Hunt_BlackPearl_Setup takes nothing returns nothing
    set gg_trg_Hunt_BlackPearl_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_BlackPearl_Setup)
    call TriggerAddAction(gg_trg_Hunt_BlackPearl_Setup,function Trig_Hunt_BlackPearl_Setup_Actions)
endfunction

function Register_Hunt_Rabite_Setup takes nothing returns nothing
    set gg_trg_Hunt_Rabite_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Rabite_Setup)
    call TriggerAddAction(gg_trg_Hunt_Rabite_Setup,function Trig_Hunt_Rabite_Setup_Actions)
endfunction

function Register_Hunt_Verci_Setup takes nothing returns nothing
    set gg_trg_Hunt_Verci_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Verci_Setup)
    call TriggerAddAction(gg_trg_Hunt_Verci_Setup,function Trig_Hunt_Verci_Setup_Actions)
endfunction

function Register_Hunt_Okuu_Setup takes nothing returns nothing
    set gg_trg_Hunt_Okuu_Setup=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Okuu_Setup)
    call TriggerAddAction(gg_trg_Hunt_Okuu_Setup,function Trig_Hunt_Okuu_Setup_Actions)
endfunction

function Register_Hunt_Shard_Register takes nothing returns nothing
    set gg_trg_Hunt_Shard_Register=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Shard_Register)
    call TriggerAddAction(gg_trg_Hunt_Shard_Register,function Trig_Hunt_Shard_Register_Actions)
endfunction

function Register_Hunt_Shard_Drop takes nothing returns nothing
    set gg_trg_Hunt_Shard_Drop=CreateTrigger()
    call TriggerAddAction(gg_trg_Hunt_Shard_Drop,function Trig_Hunt_Shard_Drop_Actions)
endfunction

function Register_Hunt_Shop_Unlock takes nothing returns nothing
    set gg_trg_Hunt_Shop_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_Hunt_Shop_Unlock)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Hunt_Shop_Unlock,10.)
    call TriggerAddAction(gg_trg_Hunt_Shop_Unlock,function Trig_Hunt_Shop_Unlock_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Hunt takes nothing returns nothing
    call Register_Hunt_Setup()
    call Register_Hunt_Board_Markers()
    call Register_Hunt_Accept()
    call Register_Hunt_Complete()
    call Register_Hunt_Shop_Unlock()
    call Register_Hunt_Thextera_Escort()
    call Register_Hunt_Shard_Register()
    call Register_Hunt_Shard_Drop()
    call Register_Hunt_Tonberry_Setup()
    call Register_Hunt_Demon_Setup()
    call Register_Hunt_Parvati_Setup()
    call Register_Hunt_PhantomDancer_Setup()
    call Register_Hunt_Exdeath_Setup()
    call Register_Hunt_Mephorash_Setup()
    call Register_Hunt_Trickster_Unlock()
    call Register_Hunt_Melaiduma_Setup()
    call Register_Hunt_BlackPearl_Setup()
    call Register_Hunt_Rabite_Setup()
    call Register_Hunt_Verci_Setup()
    call Register_Hunt_Okuu_Setup()
endfunction

endlibrary
