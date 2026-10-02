library TChocobo requires TChocoboBreeding, TChocoboBribing, TChocoboDigging, TChocoboPopulation, TChocoboTaming, TChocoboTechCopy, TChocoboUpgrades, TChocoboWildBehavior
function InitTrig_Chocobo takes nothing returns nothing
endfunction

function RegisterR11_Chocobo_Breed_Score takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Breed_Score=CreateTrigger()

call DisableTrigger(gg_trg_Chocobo_Breed_Score)

call TriggerAddAction(gg_trg_Chocobo_Breed_Score,function Trig_Chocobo_Breed_Score_Actions)

endfunction





function RegisterR11_Chocobo_Bribe takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Bribe=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Bribe,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Chocobo_Bribe,Condition(function Trig_Chocobo_Bribe_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Bribe,function Trig_Chocobo_Bribe_Actions)

endfunction





function RegisterR11_Chocobo_DeadPepper_Dig takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_DeadPepper_Dig=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_DeadPepper_Dig,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Chocobo_DeadPepper_Dig,Condition(function Trig_Chocobo_DeadPepper_Dig_Conditions))

call TriggerAddAction(gg_trg_Chocobo_DeadPepper_Dig,function Trig_Chocobo_DeadPepper_Dig_Actions)

endfunction





function RegisterR11_Chocobo_DigSpot_Nearest takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_DigSpot_Nearest=CreateTrigger()

call TriggerAddAction(gg_trg_Chocobo_DigSpot_Nearest,function Trig_Chocobo_DigSpot_Nearest_Actions)

endfunction





function RegisterR11_Chocobo_Drop_Nut takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Drop_Nut=CreateTrigger()

call DisableTrigger(gg_trg_Chocobo_Drop_Nut)

call TriggerAddAction(gg_trg_Chocobo_Drop_Nut,function Trig_Chocobo_Drop_Nut_Actions)

endfunction





function RegisterR11_Chocobo_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Init=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_Chocobo_Init,20.)

call TriggerAddAction(gg_trg_Chocobo_Init,function Trig_Chocobo_Init_Actions)

endfunction





function RegisterR11_Chocobo_Spawn_Periodic takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Spawn_Periodic=CreateTrigger()

call TriggerRegisterTimerEventPeriodic(gg_trg_Chocobo_Spawn_Periodic,120.)

call TriggerAddCondition(gg_trg_Chocobo_Spawn_Periodic,Condition(function Trig_Chocobo_Spawn_Periodic_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Spawn_Periodic,function Trig_Chocobo_Spawn_Periodic_Actions)

endfunction





function RegisterR11_Chocobo_Respawn takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Respawn=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Respawn,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Chocobo_Respawn,Condition(function Trig_Chocobo_Respawn_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Respawn,function Trig_Chocobo_Respawn_Actions)

endfunction





function RegisterR11_Chocobo_Tame_Limit takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Tame_Limit=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Tame_Limit,EVENT_PLAYER_UNIT_SPELL_CAST)

call TriggerAddCondition(gg_trg_Chocobo_Tame_Limit,Condition(function Trig_Chocobo_Tame_Limit_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Tame_Limit,function Trig_Chocobo_Tame_Limit_Actions)

endfunction





function RegisterR11_Chocobo_Tame_Breed takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Tame_Breed=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Tame_Breed,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Chocobo_Tame_Breed,Condition(function Trig_Chocobo_Tame_Breed_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Tame_Breed,function Trig_Chocobo_Tame_Breed_Actions)

endfunction





function RegisterR11_Chocobo_TechCopy takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_TechCopy=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_TechCopy,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Chocobo_TechCopy,Condition(function Trig_Chocobo_TechCopy_Conditions))

call TriggerAddAction(gg_trg_Chocobo_TechCopy,function Trig_Chocobo_TechCopy_Actions)

endfunction





function RegisterR11_Chocobo_Gysahl_Upgrade takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Gysahl_Upgrade=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Gysahl_Upgrade,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Chocobo_Gysahl_Upgrade,Condition(function Trig_Chocobo_Gysahl_Upgrade_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Gysahl_Upgrade,function Trig_Chocobo_Gysahl_Upgrade_Actions)

endfunction





function RegisterR11_Chocobo_Mimett_Upgrade takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Mimett_Upgrade=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Mimett_Upgrade,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Chocobo_Mimett_Upgrade,Condition(function Trig_Chocobo_Mimett_Upgrade_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Mimett_Upgrade,function Trig_Chocobo_Mimett_Upgrade_Actions)

endfunction





function RegisterR11_Chocobo_Silkis_Upgrade takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Silkis_Upgrade=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Silkis_Upgrade,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Chocobo_Silkis_Upgrade,Condition(function Trig_Chocobo_Silkis_Upgrade_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Silkis_Upgrade,function Trig_Chocobo_Silkis_Upgrade_Actions)

endfunction





function RegisterR11_Chocobo_Defend_Upgrade takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Defend_Upgrade=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Defend_Upgrade,EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Chocobo_Defend_Upgrade,Condition(function Trig_Chocobo_Defend_Upgrade_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Defend_Upgrade,function Trig_Chocobo_Defend_Upgrade_Actions)

endfunction





function RegisterR11_Chocobo_Wild_Death takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Wild_Death=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Wild_Death,EVENT_PLAYER_UNIT_DEATH)

call TriggerAddCondition(gg_trg_Chocobo_Wild_Death,Condition(function Trig_Chocobo_Wild_Death_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Wild_Death,function Trig_Chocobo_Wild_Death_Actions)

endfunction





function RegisterR11_Chocobo_Wild_Retaliate takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Wild_Retaliate=CreateTrigger()

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Chocobo_Wild_Retaliate,Player(8),EVENT_PLAYER_UNIT_ATTACKED)

call TriggerAddCondition(gg_trg_Chocobo_Wild_Retaliate,Condition(function Trig_Chocobo_Wild_Retaliate_Conditions))

call TriggerAddAction(gg_trg_Chocobo_Wild_Retaliate,function Trig_Chocobo_Wild_Retaliate_Actions)

endfunction





function RegisterR11_Chocobo_Wild_AI takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Chocobo_Wild_AI=CreateTrigger()

call TriggerRegisterTimerEventPeriodic(gg_trg_Chocobo_Wild_AI,5.)

call TriggerAddAction(gg_trg_Chocobo_Wild_AI,function Trig_Chocobo_Wild_AI_Actions)

endfunction





endlibrary
