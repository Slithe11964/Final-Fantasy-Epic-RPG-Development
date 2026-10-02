library TSpell requires TSpellAero, TSpellDemi, TSpellDewall, TSpellFlamesOfJudgment, TSpellGayaRage, TSpellHeatWave, TSpellHellhounds, TSpellHoming, TSpellIncandescentHellfire, TSpellInfernoRipple, TSpellJavelinRain, TSpellLivingFlame, TSpellMeteor, TSpellOzmeteor, TSpellQuake, TSpellSatellite, TSpellTables, TSpellTerraBreak, TSpellWater, TSpellWave, TSpellXerosBeat
function InitTrig_Spell takes nothing returns nothing
endfunction
function RegisterR11_Spell_Aero takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Aero=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Aero,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Aero,Condition(function Trig_Spell_Aero_Conditions))
    call TriggerAddAction(gg_trg_Spell_Aero,function Trig_Spell_Aero_Actions)
endfunction
function RegisterR11_Spell_Demi takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Demi=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Demi,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Demi,Condition(function Trig_Spell_Demi_Conditions))
    call TriggerAddAction(gg_trg_Spell_Demi,function Trig_Spell_Demi_Actions)
endfunction
function RegisterR11_Spell_Dewall_Apply takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Dewall_Apply=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Dewall_Apply,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Dewall_Apply,Condition(function Trig_Spell_Dewall_Apply_Conditions))
    call TriggerAddAction(gg_trg_Spell_Dewall_Apply,function Trig_Spell_Dewall_Apply_Actions)
endfunction
function RegisterR11_Spell_FlamesOfJudgment takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_FlamesOfJudgment=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_FlamesOfJudgment,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_FlamesOfJudgment,Condition(function Trig_Spell_FlamesOfJudgment_Conditions))
    call TriggerAddAction(gg_trg_Spell_FlamesOfJudgment,function Trig_Spell_FlamesOfJudgment_Actions)
endfunction
function RegisterR11_Spell_GayaRage_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_GayaRage_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Spell_GayaRage_Start)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_GayaRage_Start,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddCondition(gg_trg_Spell_GayaRage_Start,Condition(function Trig_Spell_GayaRage_Start_Conditions))
    call TriggerAddAction(gg_trg_Spell_GayaRage_Start,function Trig_Spell_GayaRage_Start_Actions)
endfunction
function RegisterR11_Spell_GayaRage_Ring takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_GayaRage_Ring=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Spell_GayaRage_Ring,udg_GayaRageTimer)
    call TriggerAddCondition(gg_trg_Spell_GayaRage_Ring,Condition(function Trig_Spell_GayaRage_Ring_Conditions))
    call TriggerAddAction(gg_trg_Spell_GayaRage_Ring,function Trig_Spell_GayaRage_Ring_Actions)
endfunction
function RegisterR11_Spell_GayaRage_Damage takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_GayaRage_Damage=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_GayaRage_Damage,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_GayaRage_Damage,Condition(function Trig_Spell_GayaRage_Damage_Conditions))
    call TriggerAddAction(gg_trg_Spell_GayaRage_Damage,function Trig_Spell_GayaRage_Damage_Actions)
endfunction
function RegisterR11_Spell_HeatWave_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_HeatWave_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_HeatWave_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_HeatWave_Cast,Condition(function Trig_Spell_HeatWave_Cast_Conditions))
    call TriggerAddAction(gg_trg_Spell_HeatWave_Cast,function Trig_Spell_HeatWave_Cast_Actions)
endfunction
function RegisterR11_Spell_Hellhounds takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Hellhounds=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Hellhounds,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Hellhounds,Condition(function Trig_Spell_Hellhounds_Conditions))
    call TriggerAddAction(gg_trg_Spell_Hellhounds,function Trig_Spell_Hellhounds_Actions)
endfunction
function RegisterR11_Spell_Homing_Rockets takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Homing_Rockets=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Homing_Rockets,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Homing_Rockets,Condition(function Trig_Spell_Homing_Rockets_Conditions))
    call TriggerAddAction(gg_trg_Spell_Homing_Rockets,function Trig_Spell_Homing_Rockets_Actions)
endfunction
function RegisterR11_Spell_IncandescentHellfire takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_IncandescentHellfire=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_IncandescentHellfire,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_IncandescentHellfire,Condition(function Trig_Spell_IncandescentHellfire_Conditions))
    call TriggerAddAction(gg_trg_Spell_IncandescentHellfire,function Trig_Spell_IncandescentHellfire_Actions)
endfunction
function RegisterR11_Spell_InfernoRipple takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_InfernoRipple=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_InfernoRipple,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_InfernoRipple,Condition(function Trig_Spell_InfernoRipple_Conditions))
    call TriggerAddAction(gg_trg_Spell_InfernoRipple,function Trig_Spell_InfernoRipple_Actions)
endfunction
function RegisterR11_Spell_JavelinRain_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_JavelinRain_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_JavelinRain_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_JavelinRain_Cast,Condition(function Trig_Spell_JavelinRain_Cast_Conditions))
    call TriggerAddAction(gg_trg_Spell_JavelinRain_Cast,function Trig_Spell_JavelinRain_Cast_Actions)
endfunction
function RegisterR11_Spell_LivingFlame_Apply takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_LivingFlame_Apply=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_LivingFlame_Apply,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_LivingFlame_Apply,Condition(function Trig_Spell_LivingFlame_Apply_Conditions))
    call TriggerAddAction(gg_trg_Spell_LivingFlame_Apply,function Trig_Spell_LivingFlame_Apply_Actions)
endfunction
function RegisterR11_Spell_LivingFlame_Tick takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_LivingFlame_Tick=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Spell_LivingFlame_Tick,1.)
    call TriggerAddCondition(gg_trg_Spell_LivingFlame_Tick,Condition(function Trig_Spell_LivingFlame_Tick_Conditions))
    call TriggerAddAction(gg_trg_Spell_LivingFlame_Tick,function Trig_Spell_LivingFlame_Tick_Actions)
endfunction
function RegisterR11_Spell_LivingFlame_Spread takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_LivingFlame_Spread=CreateTrigger()
    call DisableTrigger(gg_trg_Spell_LivingFlame_Spread)
    call TriggerAddCondition(gg_trg_Spell_LivingFlame_Spread,Condition(function Trig_Spell_LivingFlame_Spread_Conditions))
    call TriggerAddAction(gg_trg_Spell_LivingFlame_Spread,function Trig_Spell_LivingFlame_Spread_Actions)
endfunction
function RegisterR11_Spell_Meteor_Wide takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Meteor_Wide=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Meteor_Wide,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Meteor_Wide,Condition(function Trig_Spell_Meteor_Wide_Conditions))
    call TriggerAddAction(gg_trg_Spell_Meteor_Wide,function Trig_Spell_Meteor_Wide_Actions)
endfunction
function RegisterR11_Spell_Ozmeteor takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Ozmeteor=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Ozmeteor,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Ozmeteor,Condition(function Trig_Spell_Ozmeteor_Conditions))
    call TriggerAddAction(gg_trg_Spell_Ozmeteor,function Trig_Spell_Ozmeteor_Actions)
endfunction
function RegisterR11_Spell_Quake takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Quake=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Quake,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Quake,Condition(function Trig_Spell_Quake_Conditions))
    call TriggerAddAction(gg_trg_Spell_Quake,function Trig_Spell_Quake_Actions)
endfunction
function RegisterR11_Spell_Satellite_Beam takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Satellite_Beam=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Satellite_Beam,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Satellite_Beam,Condition(function Trig_Spell_Satellite_Beam_Conditions))
    call TriggerAddAction(gg_trg_Spell_Satellite_Beam,function Trig_Spell_Satellite_Beam_Actions)
endfunction
function RegisterR11_Spell_Satellite_Beam_InGroup takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Satellite_Beam_InGroup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Satellite_Beam_InGroup,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Satellite_Beam_InGroup,Condition(function Trig_Spell_Satellite_Beam_InGroup_Conditions))
    call TriggerAddAction(gg_trg_Spell_Satellite_Beam_InGroup,function Trig_Spell_Satellite_Beam_InGroup_Actions)
endfunction
function RegisterR11_Spell_Satellite_Beam_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Satellite_Beam_Death=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Satellite_Beam_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Spell_Satellite_Beam_Death,Condition(function Trig_Spell_Satellite_Beam_Death_Conditions))
    call TriggerAddAction(gg_trg_Spell_Satellite_Beam_Death,function Trig_Spell_Satellite_Beam_Death_Actions)
endfunction
function RegisterR11_Spell_Tables_Init takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Tables_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Spell_Tables_Init,2.)
    call TriggerAddAction(gg_trg_Spell_Tables_Init,function Trig_Spell_Tables_Init_Actions)
endfunction
function RegisterR11_Spell_TerraBreak takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_TerraBreak=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_TerraBreak,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_TerraBreak,Condition(function Trig_Spell_TerraBreak_Conditions))
    call TriggerAddAction(gg_trg_Spell_TerraBreak,function Trig_Spell_TerraBreak_Actions)
endfunction
function RegisterR11_Spell_Water takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Water=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Water,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Water,Condition(function Trig_Spell_Water_Conditions))
    call TriggerAddAction(gg_trg_Spell_Water,function Trig_Spell_Water_Actions)
endfunction
function RegisterR11_Spell_Wave_Cannon takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_Wave_Cannon=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Wave_Cannon,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Wave_Cannon,Condition(function Trig_Spell_Wave_Cannon_Conditions))
    call TriggerAddAction(gg_trg_Spell_Wave_Cannon,function Trig_Spell_Wave_Cannon_Actions)
endfunction
function RegisterR11_Spell_XerosBeat_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spell_XerosBeat_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_XerosBeat_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_XerosBeat_Cast,Condition(function Trig_Spell_XerosBeat_Cast_Conditions))
    call TriggerAddAction(gg_trg_Spell_XerosBeat_Cast,function Trig_Spell_XerosBeat_Cast_Actions)
endfunction





endlibrary
